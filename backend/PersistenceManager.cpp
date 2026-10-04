/**
 * ==============================================================================
 * Project: Apex VISION IVI - Digital Cockpit & Infotainment System
 * File: PersistenceManager.cpp
 * Author / Developer: Sk Rehan Ahamed
 * License: MIT
 * ==============================================================================
 */

#include "PersistenceManager.h"

PersistenceManager *PersistenceManager::s_instance = nullptr;

PersistenceManager::PersistenceManager(QObject *parent)
    : QObject(parent)
{
    s_instance = this;

    m_saveTimer.setSingleShot(true);
    m_saveTimer.setInterval(350); // 350ms debounce for rapid UI changes
    connect(&m_saveTimer, &QTimer::timeout, this, &PersistenceManager::onSaveTimeout);

    // Ensure memory is flushed to disk when application exits
    if (qApp) {
        connect(qApp, &QCoreApplication::aboutToQuit, this, &PersistenceManager::flush);
    }

    initStoragePath();
    loadFromDisk();
}

PersistenceManager::~PersistenceManager()
{
    if (m_isDirty) {
        saveToDiskInternal();
    }
    if (s_instance == this) {
        s_instance = nullptr;
    }
}

PersistenceManager *PersistenceManager::instance()
{
    return s_instance;
}

void PersistenceManager::initStoragePath()
{
    // Try workspace / local current directory first for transparent local inspection
    const QString workspaceFile = QDir::currentPath() + QStringLiteral("/apex_settings.json");
    const QString projectRootFile = QStringLiteral("/Users/reno/Projects/APEX_VISION_IVI/apex_settings.json");

    if (QFileInfo::exists(projectRootFile)) {
        m_storageFilePath = projectRootFile;
    } else if (QFileInfo::exists(workspaceFile)) {
        m_storageFilePath = workspaceFile;
    } else {
        // Test writeability of current directory
        QFile testFile(workspaceFile);
        if (testFile.open(QIODevice::WriteOnly)) {
            testFile.close();
            m_storageFilePath = workspaceFile;
        } else {
            // Fallback to system standard AppDataLocation
            const QString appDataDir = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
            QDir().mkpath(appDataDir);
            m_storageFilePath = appDataDir + QStringLiteral("/apex_settings.json");
        }
    }

    qInfo() << "[APEX MEMORY] Persistence file bound to:" << m_storageFilePath;
}

void PersistenceManager::seedDefaultsIfEmpty()
{
    if (m_profiles.isEmpty()) {
        ProfileRecord p1;
        p1.id = QStringLiteral("p1");
        p1.name = QStringLiteral("Profile 1");
        p1.avatar = QStringLiteral("monogram");
        p1.avatarPath = QString();
        p1.linkedKey = QStringLiteral("Key Fob 1, Phone As A Key linked");
        p1.lockType = QStringLiteral("None");
        p1.pinCode = QStringLiteral("1234");
        p1.password = QString();
        p1.role = QStringLiteral("Signed in as admin");
        p1.keyFobLinked = true;
        p1.phoneKeyLinked = true;
        p1.btDeviceLinked = true;

        QVariantMap defaultPrefs;
        defaultPrefs[QStringLiteral("driveMode")] = QStringLiteral("COMFORT");
        defaultPrefs[QStringLiteral("ambientColor")] = QStringLiteral("#70C5F5");
        defaultPrefs[QStringLiteral("ambientBrightness")] = 0.85;
        defaultPrefs[QStringLiteral("ambientLighting")] = true;
        p1.preferences = defaultPrefs;

        m_profiles.append(p1);
        m_activeProfileId = QStringLiteral("p1");
    }

    if (m_globalSettings.isEmpty()) {
        m_globalSettings[QStringLiteral("sys_is24HourFormat")] = true;
        m_globalSettings[QStringLiteral("sys_autoTimeEnabled")] = true;
        m_globalSettings[QStringLiteral("sys_autoTimeZoneEnabled")] = true;
        m_globalSettings[QStringLiteral("sys_selectedTimeZone")] = QStringLiteral("GMT+05:30 India Standard Time (IST)");
        m_globalSettings[QStringLiteral("sys_selectedLanguage")] = QStringLiteral("English");
        m_globalSettings[QStringLiteral("sys_selectedKeyboard")] = QStringLiteral("Apex Touch Keyboard");
        m_globalSettings[QStringLiteral("sys_selectedAutofill")] = QStringLiteral("Apex Cloud");
        m_globalSettings[QStringLiteral("sys_pointerSpeed")] = 50;
        m_globalSettings[QStringLiteral("sys_unitsTemperature")] = QStringLiteral("Celsius (°C)");
        m_globalSettings[QStringLiteral("sys_brightness")] = 85;

        m_globalSettings[QStringLiteral("veh_headlights")] = true;
        m_globalSettings[QStringLiteral("veh_autoHold")] = true;
        m_globalSettings[QStringLiteral("veh_valetMode")] = false;
        m_globalSettings[QStringLiteral("veh_powerLiftgateMode")] = QStringLiteral("Power");
        m_globalSettings[QStringLiteral("veh_mirrorAutofoldEnabled")] = true;
        m_globalSettings[QStringLiteral("veh_remoteStartEnabled")] = true;
        m_globalSettings[QStringLiteral("veh_autoHighBeamsEnabled")] = true;
        m_globalSettings[QStringLiteral("veh_autolampDelay")] = QStringLiteral("20 seconds");
    }

    setDirty();
}

void PersistenceManager::loadFromDisk()
{
    m_profiles.clear();
    m_globalSettings.clear();

    QFile file(m_storageFilePath);
    if (!file.exists() || !file.open(QIODevice::ReadOnly)) {
        qInfo() << "[APEX MEMORY] Storage file does not exist yet. Initializing defaults.";
        seedDefaultsIfEmpty();
        saveToDiskInternal();
        return;
    }

    QByteArray data = file.readAll();
    file.close();

    QJsonParseError err;
    QJsonDocument doc = QJsonDocument::fromJson(data, &err);
    if (err.error != QJsonParseError::NoError || !doc.isObject()) {
        qWarning() << "[APEX MEMORY] Error parsing persistence JSON:" << err.errorString();
        seedDefaultsIfEmpty();
        saveToDiskInternal();
        return;
    }

    QJsonObject root = doc.object();
    m_activeProfileId = root.value(QStringLiteral("activeProfileId")).toString(QStringLiteral("p1"));

    // Parse profiles
    QJsonArray profArr = root.value(QStringLiteral("profiles")).toArray();
    for (const QJsonValue &val : profArr) {
        if (!val.isObject()) continue;
        QJsonObject pObj = val.toObject();

        ProfileRecord p;
        p.id = pObj.value(QStringLiteral("id")).toString();
        p.name = pObj.value(QStringLiteral("name")).toString(QStringLiteral("Profile"));
        p.avatar = pObj.value(QStringLiteral("avatar")).toString(QStringLiteral("monogram"));
        p.avatarPath = pObj.value(QStringLiteral("avatarPath")).toString();
        p.linkedKey = pObj.value(QStringLiteral("linkedKey")).toString(QStringLiteral("Key Fob linked"));
        p.lockType = pObj.value(QStringLiteral("lockType")).toString(QStringLiteral("None"));
        p.pinCode = pObj.value(QStringLiteral("pinCode")).toString(QStringLiteral("1234"));
        p.password = pObj.value(QStringLiteral("password")).toString();
        p.role = pObj.value(QStringLiteral("role")).toString(QStringLiteral("Signed in as admin"));
        p.keyFobLinked = pObj.value(QStringLiteral("keyFobLinked")).toBool(true);
        p.phoneKeyLinked = pObj.value(QStringLiteral("phoneKeyLinked")).toBool(true);
        p.btDeviceLinked = pObj.value(QStringLiteral("btDeviceLinked")).toBool(true);

        QJsonObject prefsObj = pObj.value(QStringLiteral("preferences")).toObject();
        p.preferences = prefsObj.toVariantMap();

        if (!p.id.isEmpty()) {
            m_profiles.append(p);
        }
    }

    // Parse global settings
    QJsonObject settingsObj = root.value(QStringLiteral("globalSettings")).toObject();
    m_globalSettings = settingsObj.toVariantMap();

    if (m_profiles.isEmpty()) {
        seedDefaultsIfEmpty();
        saveToDiskInternal();
    }

    m_isDirty = false;
    emit dirtyChanged(false);
    emit profilesChanged();
    emit activeProfileChanged(m_activeProfileId);
    qInfo() << "[APEX MEMORY] Loaded" << m_profiles.size() << "profiles and" << m_globalSettings.size() << "settings from disk.";
}

void PersistenceManager::saveToDiskInternal()
{
    QJsonObject root;
    root[QStringLiteral("version")] = 1;
    root[QStringLiteral("activeProfileId")] = m_activeProfileId;

    QJsonArray profArr;
    for (const ProfileRecord &p : m_profiles) {
        QJsonObject pObj;
        pObj[QStringLiteral("id")] = p.id;
        pObj[QStringLiteral("name")] = p.name;
        pObj[QStringLiteral("avatar")] = p.avatar;
        pObj[QStringLiteral("avatarPath")] = p.avatarPath;
        pObj[QStringLiteral("linkedKey")] = p.linkedKey;
        pObj[QStringLiteral("lockType")] = p.lockType;
        pObj[QStringLiteral("pinCode")] = p.pinCode;
        pObj[QStringLiteral("password")] = p.password;
        pObj[QStringLiteral("role")] = p.role;
        pObj[QStringLiteral("keyFobLinked")] = p.keyFobLinked;
        pObj[QStringLiteral("phoneKeyLinked")] = p.phoneKeyLinked;
        pObj[QStringLiteral("btDeviceLinked")] = p.btDeviceLinked;
        pObj[QStringLiteral("preferences")] = QJsonObject::fromVariantMap(p.preferences);
        profArr.append(pObj);
    }
    root[QStringLiteral("profiles")] = profArr;
    root[QStringLiteral("globalSettings")] = QJsonObject::fromVariantMap(m_globalSettings);

    QJsonDocument doc(root);
    QByteArray bytes = doc.toJson(QJsonDocument::Indented);

    // Atomic write via QSaveFile to prevent corruption during unexpected shutdowns
    QSaveFile saveFile(m_storageFilePath);
    if (saveFile.open(QIODevice::WriteOnly)) {
        saveFile.write(bytes);
        if (saveFile.commit()) {
            m_isDirty = false;
            emit dirtyChanged(false);
            emit savedToDisk();
            qInfo() << "[APEX MEMORY] Atomically persisted settings & profiles to:" << m_storageFilePath;
            return;
        }
    }

    // Direct fallback if QSaveFile failed
    QFile directFile(m_storageFilePath);
    if (directFile.open(QIODevice::WriteOnly | QIODevice::Truncate)) {
        directFile.write(bytes);
        directFile.close();
        m_isDirty = false;
        emit dirtyChanged(false);
        emit savedToDisk();
        qInfo() << "[APEX MEMORY] Directly persisted settings to:" << m_storageFilePath;
    } else {
        qWarning() << "[APEX MEMORY] Failed to write persistence file:" << directFile.errorString();
    }
}

void PersistenceManager::setDirty()
{
    if (!m_isDirty) {
        m_isDirty = true;
        emit dirtyChanged(true);
    }
    scheduleSave();
}

void PersistenceManager::scheduleSave()
{
    m_saveTimer.start();
}

void PersistenceManager::onSaveTimeout()
{
    if (m_isDirty) {
        saveToDiskInternal();
    }
}

void PersistenceManager::flush()
{
    m_saveTimer.stop();
    if (m_isDirty) {
        saveToDiskInternal();
    }
}

void PersistenceManager::reloadFromDisk()
{
    m_saveTimer.stop();
    loadFromDisk();
}

void PersistenceManager::resetToDefaults()
{
    m_saveTimer.stop();
    m_profiles.clear();
    m_globalSettings.clear();
    m_activeProfileId = QStringLiteral("p1");
    seedDefaultsIfEmpty();
    saveToDiskInternal();
    emit profilesChanged();
    emit activeProfileChanged(m_activeProfileId);
}

void PersistenceManager::setActiveProfileId(const QString &id)
{
    if (m_activeProfileId != id) {
        m_activeProfileId = id;
        setDirty();
        emit activeProfileChanged(id);
    }
}

static QString computeProfileInitials(const QString &name)
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

QVariantList PersistenceManager::profiles() const
{
    QVariantList list;
    for (const ProfileRecord &p : m_profiles) {
        QVariantMap map;
        map[QStringLiteral("id")] = p.id;
        map[QStringLiteral("name")] = p.name;
        map[QStringLiteral("avatar")] = p.avatar;
        map[QStringLiteral("avatarPath")] = p.avatarPath;
        map[QStringLiteral("initials")] = computeProfileInitials(p.name);
        map[QStringLiteral("linkedKey")] = p.linkedKey;
        map[QStringLiteral("lockType")] = p.lockType;
        map[QStringLiteral("pinCode")] = p.pinCode;
        map[QStringLiteral("password")] = p.password;
        map[QStringLiteral("role")] = p.role;
        map[QStringLiteral("keyFobLinked")] = p.keyFobLinked;
        map[QStringLiteral("phoneKeyLinked")] = p.phoneKeyLinked;
        map[QStringLiteral("btDeviceLinked")] = p.btDeviceLinked;
        map[QStringLiteral("isCurrent")] = (p.id == m_activeProfileId);
        map[QStringLiteral("preferences")] = p.preferences;
        list.append(map);
    }
    return list;
}

bool PersistenceManager::getProfileRecord(const QString &profileId, ProfileRecord &outRecord) const
{
    for (const ProfileRecord &p : m_profiles) {
        if (p.id == profileId) {
            outRecord = p;
            return true;
        }
    }
    return false;
}

bool PersistenceManager::updateProfileRecord(const ProfileRecord &record)
{
    for (int i = 0; i < m_profiles.size(); ++i) {
        if (m_profiles[i].id == record.id) {
            m_profiles[i] = record;
            setDirty();
            emit profilesChanged();
            return true;
        }
    }
    return false;
}

QVariantMap PersistenceManager::getProfile(const QString &profileId) const
{
    for (const ProfileRecord &p : m_profiles) {
        if (p.id == profileId) {
            QVariantMap map;
            map[QStringLiteral("id")] = p.id;
            map[QStringLiteral("name")] = p.name;
            map[QStringLiteral("avatar")] = p.avatar;
            map[QStringLiteral("avatarPath")] = p.avatarPath;
            map[QStringLiteral("initials")] = computeProfileInitials(p.name);
            map[QStringLiteral("linkedKey")] = p.linkedKey;
            map[QStringLiteral("lockType")] = p.lockType;
            map[QStringLiteral("pinCode")] = p.pinCode;
            map[QStringLiteral("password")] = p.password;
            map[QStringLiteral("role")] = p.role;
            map[QStringLiteral("keyFobLinked")] = p.keyFobLinked;
            map[QStringLiteral("phoneKeyLinked")] = p.phoneKeyLinked;
            map[QStringLiteral("btDeviceLinked")] = p.btDeviceLinked;
            map[QStringLiteral("isCurrent")] = (p.id == m_activeProfileId);
            map[QStringLiteral("preferences")] = p.preferences;
            return map;
        }
    }
    return QVariantMap();
}

bool PersistenceManager::addOrUpdateProfile(const QString &id, const QString &name, const QString &avatar, const QString &avatarPath, const QString &linkedKey)
{
    for (int i = 0; i < m_profiles.size(); ++i) {
        if (m_profiles[i].id == id) {
            m_profiles[i].name = name;
            m_profiles[i].avatar = avatar;
            m_profiles[i].avatarPath = avatarPath;
            if (!linkedKey.isEmpty()) {
                m_profiles[i].linkedKey = linkedKey;
            }
            setDirty();
            emit profilesChanged();
            return true;
        }
    }

    if (m_profiles.size() >= 3) {
        return false;
    }

    ProfileRecord p;
    p.id = id;
    p.name = name;
    p.avatar = avatar.isEmpty() ? QStringLiteral("monogram") : avatar;
    p.avatarPath = avatarPath;
    p.linkedKey = linkedKey.isEmpty() ? QStringLiteral("Key Fob linked") : linkedKey;
    p.lockType = QStringLiteral("None");
    p.pinCode = QStringLiteral("1234");
    p.role = QStringLiteral("Signed in as driver");
    p.keyFobLinked = true;
    p.phoneKeyLinked = true;
    p.btDeviceLinked = true;

    QVariantMap defaultPrefs;
    defaultPrefs[QStringLiteral("driveMode")] = QStringLiteral("COMFORT");
    defaultPrefs[QStringLiteral("ambientColor")] = QStringLiteral("#70C5F5");
    defaultPrefs[QStringLiteral("ambientBrightness")] = 0.85;
    defaultPrefs[QStringLiteral("ambientLighting")] = true;
    p.preferences = defaultPrefs;

    m_profiles.append(p);
    m_activeProfileId = id;

    // Immediate flush on profile creation to guarantee data persistence
    flush();
    emit profilesChanged();
    emit activeProfileChanged(m_activeProfileId);
    return true;
}

bool PersistenceManager::removeProfile(const QString &profileId)
{
    for (int i = 0; i < m_profiles.size(); ++i) {
        if (m_profiles[i].id == profileId) {
            m_profiles.removeAt(i);
            if (m_activeProfileId == profileId) {
                m_activeProfileId = m_profiles.isEmpty() ? QString() : m_profiles.first().id;
                emit activeProfileChanged(m_activeProfileId);
            }
            // Immediate flush on profile deletion
            flush();
            emit profilesChanged();
            return true;
        }
    }
    return false;
}

bool PersistenceManager::setProfileSecurity(const QString &profileId, const QString &lockType, const QString &pinCode, const QString &password)
{
    for (ProfileRecord &p : m_profiles) {
        if (p.id == profileId) {
            p.lockType = lockType;
            if (!pinCode.isEmpty()) p.pinCode = pinCode;
            if (!password.isEmpty()) p.password = password;
            flush(); // Immediate write for security credentials
            emit profilesChanged();
            return true;
        }
    }
    return false;
}

bool PersistenceManager::setProfileLinks(const QString &profileId, bool keyFob, bool phoneKey, bool btDevice)
{
    for (ProfileRecord &p : m_profiles) {
        if (p.id == profileId) {
            p.keyFobLinked = keyFob;
            p.phoneKeyLinked = phoneKey;
            p.btDeviceLinked = btDevice;
            setDirty();
            emit profilesChanged();
            return true;
        }
    }
    return false;
}

QVariant PersistenceManager::getProfilePreference(const QString &profileId, const QString &key, const QVariant &defaultValue) const
{
    for (const ProfileRecord &p : m_profiles) {
        if (p.id == profileId) {
            return p.preferences.value(key, defaultValue);
        }
    }
    return defaultValue;
}

void PersistenceManager::setProfilePreference(const QString &profileId, const QString &key, const QVariant &value)
{
    for (ProfileRecord &p : m_profiles) {
        if (p.id == profileId) {
            if (p.preferences.value(key) != value) {
                p.preferences[key] = value;
                setDirty();
                emit profilePreferenceChanged(profileId, key, value);
            }
            return;
        }
    }
}

QVariant PersistenceManager::getSetting(const QString &key, const QVariant &defaultValue) const
{
    return m_globalSettings.value(key, defaultValue);
}

void PersistenceManager::setSetting(const QString &key, const QVariant &value)
{
    if (m_globalSettings.value(key) != value) {
        m_globalSettings[key] = value;
        setDirty();
        emit settingChanged(key, value);
    }
}

bool PersistenceManager::hasSetting(const QString &key) const
{
    return m_globalSettings.contains(key);
}

void PersistenceManager::removeSetting(const QString &key)
{
    if (m_globalSettings.remove(key) > 0) {
        setDirty();
        emit settingChanged(key, QVariant());
    }
}
