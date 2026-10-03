/**
 * ==============================================================================
 * Project: Apex VISION IVI - Digital Cockpit & Infotainment System
 * File: VehicleBackend.cpp
 * Author / Developer: Sk Rehan Ahamed
 * License: MIT
 * ==============================================================================
 */

#include "VehicleBackend.h"
#include "VehicleSimulator.h"
#include "PersistenceManager.h"
#include <cmath>
#include <QFile>
#include <QJsonDocument>
#include <QJsonObject>
#include <QDebug>

VehicleBackend::VehicleBackend(VehicleSimulator *simulator, PersistenceManager *persistence, QObject *parent)
    : QObject(parent)
    , m_persistence(persistence)
{
    if (m_persistence) {
        syncFromPersistence();
    } else {
        m_profiles.append({QStringLiteral("p1"), QStringLiteral("Profile 1"), QStringLiteral("monogram"), QString(), QStringLiteral("Key Fob 1, Phone As A Key linked")});
        m_currentProfileId = QStringLiteral("p1");
        m_isGuest = false;
    }

    if (simulator) {
        connect(simulator, &VehicleSimulator::telemetryUpdated,
                this, &VehicleBackend::onTelemetryUpdated);
    }
}

void VehicleBackend::syncFromPersistence()
{
    if (!m_persistence) return;

    m_profiles.clear();
    const auto records = m_persistence->profileRecords();
    for (const auto &r : records) {
        ProfileData p;
        p.id = r.id;
        p.name = r.name;
        p.avatar = r.avatar;
        p.avatarPath = r.avatarPath;
        p.linkedKey = r.linkedKey;
        p.lockType = r.lockType;
        p.pinCode = r.pinCode;
        p.password = r.password;
        p.role = r.role;
        p.keyFobLinked = r.keyFobLinked;
        p.phoneKeyLinked = r.phoneKeyLinked;
        p.btDeviceLinked = r.btDeviceLinked;
        m_profiles.append(p);
    }

    m_currentProfileId = m_persistence->activeProfileId();
    if (m_currentProfileId.isEmpty() && !m_profiles.isEmpty()) {
        m_currentProfileId = m_profiles.first().id;
    }
    m_isGuest = false;

    // Load active profile preferences
    loadProfilePreferences(m_currentProfileId);

    // Load global vehicle settings
    m_headlights = m_persistence->getSetting(QStringLiteral("veh_headlights"), true).toBool();
    m_autoHold = m_persistence->getSetting(QStringLiteral("veh_autoHold"), true).toBool();
    m_valetMode = m_persistence->getSetting(QStringLiteral("veh_valetMode"), false).toBool();
}

void VehicleBackend::saveCurrentProfilePreferences()
{
    if (!m_persistence || m_isGuest || m_currentProfileId.isEmpty()) return;

    m_persistence->setProfilePreference(m_currentProfileId, QStringLiteral("driveMode"), m_driveMode);
    m_persistence->setProfilePreference(m_currentProfileId, QStringLiteral("ambientColor"), m_ambientColor);
    m_persistence->setProfilePreference(m_currentProfileId, QStringLiteral("ambientBrightness"), m_ambientBrightness);
    m_persistence->setProfilePreference(m_currentProfileId, QStringLiteral("ambientLighting"), m_ambientLighting);
}

void VehicleBackend::loadProfilePreferences(const QString &profileId)
{
    if (!m_persistence || profileId.isEmpty()) return;

    m_driveMode = m_persistence->getProfilePreference(profileId, QStringLiteral("driveMode"), QStringLiteral("COMFORT")).toString();
    m_ambientColor = m_persistence->getProfilePreference(profileId, QStringLiteral("ambientColor"), QStringLiteral("#70C5F5")).toString();
    m_ambientBrightness = m_persistence->getProfilePreference(profileId, QStringLiteral("ambientBrightness"), 0.85).toDouble();
    m_ambientLighting = m_persistence->getProfilePreference(profileId, QStringLiteral("ambientLighting"), true).toBool();
}

void VehicleBackend::onTelemetryUpdated(double speed, double rpm, const QString &gear, double temp, int battery)
{
    const int newSpeed = static_cast<int>(std::round(speed));
    const int newRpm = static_cast<int>(std::round(rpm));

    if (m_vehicleSpeed != newSpeed) {
        m_vehicleSpeed = newSpeed;
        emit vehicleSpeedChanged();
    }
    if (m_engineRpm != newRpm) {
        m_engineRpm = newRpm;
        emit engineRpmChanged();
    }
    if (m_gear != gear) {
        m_gear = gear;
        emit gearChanged();
    }
    if (std::abs(m_outsideTemperature - temp) > 0.05) {
        m_outsideTemperature = temp;
        emit outsideTemperatureChanged();
    }
    if (m_batteryLevel != battery) {
        m_batteryLevel = battery;
        emit batteryLevelChanged();
    }
}

void VehicleBackend::setGear(const QString &gear)
{
    if (m_gear != gear) {
        m_gear = gear;
        emit gearChanged();
    }
}

void VehicleBackend::setDriveMode(const QString &mode)
{
    if (m_driveMode != mode) {
        m_driveMode = mode;
        if (m_persistence && !m_isGuest) {
            m_persistence->setProfilePreference(m_currentProfileId, QStringLiteral("driveMode"), mode);
        }
        emit driveModeChanged();
    }
}

void VehicleBackend::cycleDriveMode()
{
    if (m_driveMode == "COMFORT") {
        setDriveMode("SPORT");
    } else if (m_driveMode == "SPORT") {
        setDriveMode("ECO");
    } else {
        setDriveMode("COMFORT");
    }
}

static QString computeInitials(const QString &name)
{
    QString trimmed = name.trimmed();
    if (trimmed.isEmpty()) return QStringLiteral("P1");

    int spaceIdx = trimmed.indexOf(' ');
    if (spaceIdx != -1 && spaceIdx + 1 < trimmed.length()) {
        return QString(trimmed[0].toUpper()) + trimmed[spaceIdx + 1].toUpper();
    }
    if (trimmed.length() >= 2) {
        return trimmed.left(2).toUpper();
    }
    return trimmed.toUpper();
}

QString VehicleBackend::driverProfile() const
{
    return computeInitials(driverProfileName());
}

QString VehicleBackend::driverProfileName() const
{
    if (m_isGuest) return QStringLiteral("Guest");
    for (const auto &p : m_profiles) {
        if (p.id == m_currentProfileId) return p.name;
    }
    if (!m_profiles.isEmpty()) return m_profiles.first().name;
    return QStringLiteral("Profile 1");
}

QString VehicleBackend::driverProfileAvatar() const
{
    if (m_isGuest) return QStringLiteral("monogram");
    for (const auto &p : m_profiles) {
        if (p.id == m_currentProfileId) return p.avatar;
    }
    if (!m_profiles.isEmpty()) return m_profiles.first().avatar;
    return QStringLiteral("monogram");
}

QString VehicleBackend::driverProfileAvatarPath() const
{
    if (m_isGuest) return QString();
    for (const auto &p : m_profiles) {
        if (p.id == m_currentProfileId) return p.avatarPath;
    }
    if (!m_profiles.isEmpty()) return m_profiles.first().avatarPath;
    return QString();
}

QString VehicleBackend::currentLockType() const
{
    if (m_isGuest) return QStringLiteral("None");
    for (const auto &p : m_profiles) {
        if (p.id == m_currentProfileId) return p.lockType;
    }
    return QStringLiteral("None");
}

QString VehicleBackend::profilePinCode() const
{
    for (const auto &p : m_profiles) {
        if (p.id == m_currentProfileId) return p.pinCode;
    }
    return QStringLiteral("1234");
}

QString VehicleBackend::profilePassword() const
{
    for (const auto &p : m_profiles) {
        if (p.id == m_currentProfileId) return p.password;
    }
    return QString();
}

QString VehicleBackend::currentProfileRole() const
{
    if (m_isGuest) return QStringLiteral("Guest driver");
    for (const auto &p : m_profiles) {
        if (p.id == m_currentProfileId) return p.role;
    }
    return QStringLiteral("Signed in as admin");
}

bool VehicleBackend::keyFobLinked() const
{
    for (const auto &p : m_profiles) {
        if (p.id == m_currentProfileId) return p.keyFobLinked;
    }
    return true;
}

bool VehicleBackend::phoneKeyLinked() const
{
    for (const auto &p : m_profiles) {
        if (p.id == m_currentProfileId) return p.phoneKeyLinked;
    }
    return true;
}

bool VehicleBackend::btDeviceLinked() const
{
    for (const auto &p : m_profiles) {
        if (p.id == m_currentProfileId) return p.btDeviceLinked;
    }
    return true;
}

void VehicleBackend::setCurrentLockType(const QString &lockType)
{
    if (m_isGuest) return;
    setProfileSecurity(m_currentProfileId, lockType, QString(), QString());
}

void VehicleBackend::setProfilePinCode(const QString &pin)
{
    if (m_isGuest) return;
    setProfileSecurity(m_currentProfileId, QStringLiteral("PIN"), pin, QString());
}

void VehicleBackend::setProfilePassword(const QString &password)
{
    if (m_isGuest) return;
    setProfileSecurity(m_currentProfileId, QStringLiteral("Password"), QString(), password);
}

void VehicleBackend::setKeyFobLinked(bool linked)
{
    if (m_isGuest) return;
    for (auto &p : m_profiles) {
        if (p.id == m_currentProfileId) {
            p.keyFobLinked = linked;
            if (m_persistence) m_persistence->setProfileLinks(m_currentProfileId, p.keyFobLinked, p.phoneKeyLinked, p.btDeviceLinked);
            emit profileSecurityChanged();
            break;
        }
    }
}

void VehicleBackend::setPhoneKeyLinked(bool linked)
{
    if (m_isGuest) return;
    for (auto &p : m_profiles) {
        if (p.id == m_currentProfileId) {
            p.phoneKeyLinked = linked;
            if (m_persistence) m_persistence->setProfileLinks(m_currentProfileId, p.keyFobLinked, p.phoneKeyLinked, p.btDeviceLinked);
            emit profileSecurityChanged();
            break;
        }
    }
}

void VehicleBackend::setBtDeviceLinked(bool linked)
{
    if (m_isGuest) return;
    for (auto &p : m_profiles) {
        if (p.id == m_currentProfileId) {
            p.btDeviceLinked = linked;
            if (m_persistence) m_persistence->setProfileLinks(m_currentProfileId, p.keyFobLinked, p.phoneKeyLinked, p.btDeviceLinked);
            emit profileSecurityChanged();
            break;
        }
    }
}

void VehicleBackend::setProfileSecurity(const QString &profileId, const QString &lockType, const QString &pinCode, const QString &password)
{
    for (auto &p : m_profiles) {
        if (p.id == profileId) {
            p.lockType = lockType;
            if (!pinCode.isEmpty()) p.pinCode = pinCode;
            if (!password.isEmpty()) p.password = password;

            if (m_persistence) {
                m_persistence->setProfileSecurity(profileId, lockType, p.pinCode, p.password);
            }
            emit profileSecurityChanged();
            return;
        }
    }
}

void VehicleBackend::setProfileLinks(const QString &profileId, bool keyFob, bool phoneKey, bool btDevice)
{
    for (auto &p : m_profiles) {
        if (p.id == profileId) {
            p.keyFobLinked = keyFob;
            p.phoneKeyLinked = phoneKey;
            p.btDeviceLinked = btDevice;

            if (m_persistence) {
                m_persistence->setProfileLinks(profileId, keyFob, phoneKey, btDevice);
            }
            emit profileSecurityChanged();
            return;
        }
    }
}

QVariantList VehicleBackend::profilesList() const
{
    QVariantList list;
    for (const auto &p : m_profiles) {
        QVariantMap map;
        map[QStringLiteral("id")] = p.id;
        map[QStringLiteral("name")] = p.name;
        map[QStringLiteral("avatar")] = p.avatar;
        map[QStringLiteral("avatarPath")] = p.avatarPath;
        map[QStringLiteral("initials")] = computeInitials(p.name);
        map[QStringLiteral("isCurrent")] = (!m_isGuest && p.id == m_currentProfileId);
        map[QStringLiteral("linkedKey")] = p.linkedKey;
        map[QStringLiteral("lockType")] = p.lockType;
        map[QStringLiteral("pinCode")] = p.pinCode;
        map[QStringLiteral("role")] = p.role;
        map[QStringLiteral("keyFobLinked")] = p.keyFobLinked;
        map[QStringLiteral("phoneKeyLinked")] = p.phoneKeyLinked;
        map[QStringLiteral("btDeviceLinked")] = p.btDeviceLinked;
        map[QStringLiteral("isGuest")] = false;
        list.append(map);
    }
    return list;
}

int VehicleBackend::profileCount() const
{
    return m_profiles.size();
}

bool VehicleBackend::canAddProfile() const
{
    return m_profiles.size() < 3;
}

QString VehicleBackend::currentProfileId() const
{
    return m_isGuest ? QStringLiteral("guest") : m_currentProfileId;
}

bool VehicleBackend::switchProfile(const QString &profileId)
{
    if (profileId == QStringLiteral("guest")) {
        saveCurrentProfilePreferences();
        driveAsGuest();
        return true;
    }

    for (const auto &p : m_profiles) {
        if (p.id == profileId) {
            saveCurrentProfilePreferences();
            m_isGuest = false;
            m_currentProfileId = profileId;

            if (m_persistence) {
                m_persistence->setActiveProfileId(profileId);
            }

            loadProfilePreferences(profileId);

            emit driverProfileChanged();
            emit driveModeChanged();
            emit ambientColorChanged();
            emit ambientBrightnessChanged();
            emit ambientLightingChanged();
            emit profileSecurityChanged();
            return true;
        }
    }
    return false;
}

bool VehicleBackend::addProfile(const QString &name, const QString &avatar, const QString &avatarPath, const QString &linkedKey)
{
    // If the only profile is the default untuned "Profile 1", update it rather than creating duplicate
    if (m_profiles.size() == 1 && m_profiles[0].id == QStringLiteral("p1") && m_profiles[0].name == QStringLiteral("Profile 1")) {
        QString finalName = name.trimmed();
        if (finalName.isEmpty()) {
            finalName = QStringLiteral("Profile 1");
        }
        m_profiles[0].name = finalName;
        m_profiles[0].avatar = avatar.isEmpty() ? QStringLiteral("monogram") : avatar;
        m_profiles[0].avatarPath = avatarPath;
        if (!linkedKey.trimmed().isEmpty()) {
            m_profiles[0].linkedKey = linkedKey.trimmed();
        }
        m_isGuest = false;
        m_currentProfileId = QStringLiteral("p1");

        if (m_persistence) {
            m_persistence->addOrUpdateProfile(QStringLiteral("p1"), finalName, m_profiles[0].avatar, avatarPath, m_profiles[0].linkedKey);
        }

        emit driverProfileChanged();
        emit profileSecurityChanged();
        return true;
    }

    if (m_profiles.size() >= 3) {
        return false;
    }

    QSet<QString> existingIds;
    for (const auto &p : m_profiles) {
        existingIds.insert(p.id);
    }
    QString newId = QStringLiteral("p1");
    for (int i = 1; i <= 3; ++i) {
        QString candidate = QStringLiteral("p") + QString::number(i);
        if (!existingIds.contains(candidate)) {
            newId = candidate;
            break;
        }
    }

    QString finalName = name.trimmed();
    if (finalName.isEmpty()) {
        finalName = QStringLiteral("Profile ") + newId.mid(1);
    }

    QString finalKey = linkedKey.trimmed();
    if (finalKey.isEmpty()) {
        finalKey = QStringLiteral("Key Fob ") + newId.mid(1) + QStringLiteral(" linked");
    }

    ProfileData newProfile;
    newProfile.id = newId;
    newProfile.name = finalName;
    newProfile.avatar = avatar.isEmpty() ? QStringLiteral("monogram") : avatar;
    newProfile.avatarPath = avatarPath;
    newProfile.linkedKey = finalKey;
    newProfile.role = QStringLiteral("Signed in as driver");

    saveCurrentProfilePreferences();

    m_profiles.append(newProfile);
    m_isGuest = false;
    m_currentProfileId = newId;

    if (m_persistence) {
        m_persistence->addOrUpdateProfile(newId, finalName, newProfile.avatar, avatarPath, finalKey);
        m_persistence->setActiveProfileId(newId);
    }

    loadProfilePreferences(newId);

    emit driverProfileChanged();
    emit driveModeChanged();
    emit ambientColorChanged();
    emit ambientBrightnessChanged();
    emit ambientLightingChanged();
    emit profileSecurityChanged();
    return true;
}

bool VehicleBackend::deleteProfile(const QString &profileId)
{
    if (m_profiles.size() <= 1) {
        if (!m_profiles.isEmpty()) {
            m_profiles[0].name = QStringLiteral("Profile 1");
            m_profiles[0].avatar = QStringLiteral("monogram");
            m_profiles[0].avatarPath = QString();
            m_profiles[0].linkedKey = QStringLiteral("Key Fob 1, Phone As A Key linked");
            m_profiles[0].lockType = QStringLiteral("None");
            m_profiles[0].pinCode = QStringLiteral("1234");
            m_profiles[0].password = QString();
            m_isGuest = false;
            m_currentProfileId = m_profiles[0].id;

            if (m_persistence) {
                m_persistence->addOrUpdateProfile(m_profiles[0].id, m_profiles[0].name, m_profiles[0].avatar, QString(), m_profiles[0].linkedKey);
                m_persistence->setProfileSecurity(m_profiles[0].id, QStringLiteral("None"), QStringLiteral("1234"), QString());
            }

            emit driverProfileChanged();
            emit profileSecurityChanged();
            return true;
        }
        return false;
    }

    for (int i = 0; i < m_profiles.size(); ++i) {
        if (m_profiles[i].id == profileId) {
            m_profiles.removeAt(i);
            if (m_currentProfileId == profileId) {
                m_currentProfileId = m_profiles.first().id;
                m_isGuest = false;
            }

            if (m_persistence) {
                m_persistence->removeProfile(profileId);
                m_persistence->setActiveProfileId(m_currentProfileId);
            }

            loadProfilePreferences(m_currentProfileId);

            emit driverProfileChanged();
            emit driveModeChanged();
            emit ambientColorChanged();
            emit ambientBrightnessChanged();
            emit ambientLightingChanged();
            emit profileSecurityChanged();
            return true;
        }
    }
    return false;
}

void VehicleBackend::driveAsGuest()
{
    m_isGuest = true;
    emit driverProfileChanged();
    emit profileSecurityChanged();
}

void VehicleBackend::renameProfile(const QString &profileId, const QString &name)
{
    const QString trimmed = name.trimmed();
    if (trimmed.isEmpty()) return;

    for (auto &p : m_profiles) {
        if (p.id == profileId) {
            if (p.name != trimmed) {
                p.name = trimmed;
                if (m_persistence) {
                    m_persistence->addOrUpdateProfile(profileId, trimmed, p.avatar, p.avatarPath, p.linkedKey);
                }
                emit driverProfileChanged();
            }
            return;
        }
    }
}

void VehicleBackend::updateProfileAvatar(const QString &profileId, const QString &avatar, const QString &avatarPath)
{
    for (auto &p : m_profiles) {
        if (p.id == profileId) {
            if (p.avatar != avatar || p.avatarPath != avatarPath) {
                p.avatar = avatar;
                p.avatarPath = avatarPath;
                if (m_persistence) {
                    m_persistence->addOrUpdateProfile(profileId, p.name, avatar, avatarPath, p.linkedKey);
                }
                emit driverProfileChanged();
            }
            return;
        }
    }
}

void VehicleBackend::setDriverProfile(const QString &profile)
{
    switchProfile(profile);
}

void VehicleBackend::setDriverProfileName(const QString &name)
{
    if (m_isGuest) return;
    renameProfile(m_currentProfileId, name);
}

void VehicleBackend::setDriverProfileAvatar(const QString &avatar, const QString &path)
{
    if (m_isGuest) return;
    updateProfileAvatar(m_currentProfileId, avatar, path);
}

void VehicleBackend::setDriverProfileAvatarPath(const QString &path)
{
    if (m_isGuest) return;
    updateProfileAvatar(m_currentProfileId, driverProfileAvatar(), path);
}

void VehicleBackend::setHeadlights(bool on)
{
    if (m_headlights != on) {
        m_headlights = on;
        if (m_persistence) {
            m_persistence->setSetting(QStringLiteral("veh_headlights"), on);
        }
        emit headlightsChanged();
    }
}

void VehicleBackend::setAutoHold(bool on)
{
    if (m_autoHold != on) {
        m_autoHold = on;
        if (m_persistence) {
            m_persistence->setSetting(QStringLiteral("veh_autoHold"), on);
        }
        emit autoHoldChanged();
    }
}

void VehicleBackend::toggleAutoHold()
{
    setAutoHold(!m_autoHold);
}

void VehicleBackend::setValetMode(bool on)
{
    if (m_valetMode != on) {
        m_valetMode = on;
        if (m_persistence) {
            m_persistence->setSetting(QStringLiteral("veh_valetMode"), on);
        }
        emit valetModeChanged();
    }
}

void VehicleBackend::toggleValetMode()
{
    setValetMode(!m_valetMode);
}

void VehicleBackend::setAmbientLighting(bool on)
{
    if (m_ambientLighting != on) {
        m_ambientLighting = on;
        if (m_persistence && !m_isGuest) {
            m_persistence->setProfilePreference(m_currentProfileId, QStringLiteral("ambientLighting"), on);
        }
        emit ambientLightingChanged();
    }
}

void VehicleBackend::toggleAmbientLighting()
{
    setAmbientLighting(!m_ambientLighting);
}

void VehicleBackend::setAmbientColor(const QString &color)
{
    if (m_ambientColor != color) {
        m_ambientColor = color;
        if (m_persistence && !m_isGuest) {
            m_persistence->setProfilePreference(m_currentProfileId, QStringLiteral("ambientColor"), color);
        }
        emit ambientColorChanged();
    }
}

void VehicleBackend::setAmbientBrightness(double brightness)
{
    if (qAbs(m_ambientBrightness - brightness) > 0.001) {
        m_ambientBrightness = qBound(0.0, brightness, 1.0);
        if (m_persistence && !m_isGuest) {
            m_persistence->setProfilePreference(m_currentProfileId, QStringLiteral("ambientBrightness"), m_ambientBrightness);
        }
        emit ambientBrightnessChanged();
    }
}

void VehicleBackend::setTrunkOpen(bool on)
{
    if (m_trunkOpen != on) {
        m_trunkOpen = on;
        emit trunkOpenChanged();
    }
}

void VehicleBackend::toggleTrunk()
{
    setTrunkOpen(!m_trunkOpen);
}

void VehicleBackend::saveVehicleStudioPose(double yaw, double pitch, double cameraZ, double posX, double posY)
{
    QJsonObject obj;
    obj["yaw"] = yaw;
    obj["pitch"] = pitch;
    obj["cameraZ"] = cameraZ;
    obj["posX"] = posX;
    obj["posY"] = posY;

    QJsonDocument doc(obj);
    const QStringList paths = {
        "/Users/reno/Projects/APEX_VISION_IVI/vehicle_studio_pose.json",
        "vehicle_studio_pose.json"
    };
    for (const QString &p : paths) {
        QFile file(p);
        if (file.open(QIODevice::WriteOnly | QIODevice::Truncate)) {
            file.write(doc.toJson());
            file.close();
        }
    }
    qDebug() << "[APEX STUDIO POSE SAVED] yaw:" << yaw << "pitch:" << pitch << "cameraZ:" << cameraZ << "posX:" << posX << "posY:" << posY;
}

QVariantMap VehicleBackend::loadVehicleStudioPose() const
{
    QVariantMap map;
    const QStringList paths = {
        "/Users/reno/Projects/APEX_VISION_IVI/vehicle_studio_pose.json",
        "vehicle_studio_pose.json"
    };
    for (const QString &p : paths) {
        QFile file(p);
        if (file.open(QIODevice::ReadOnly)) {
            QJsonDocument doc = QJsonDocument::fromJson(file.readAll());
            file.close();
            if (doc.isObject()) {
                QJsonObject obj = doc.object();
                map["yaw"] = obj.value("yaw").toDouble(64.0);
                map["pitch"] = obj.value("pitch").toDouble(-5.0);
                map["cameraZ"] = obj.value("cameraZ").toDouble(11.5);
                map["posX"] = obj.value("posX").toDouble(0.0);
                map["posY"] = obj.value("posY").toDouble(0.65);
                return map;
            }
        }
    }
    return map;
}
