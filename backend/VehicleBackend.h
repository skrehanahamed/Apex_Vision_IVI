/**
 * ==============================================================================
 * Project: Apex VISION IVI - Digital Cockpit & Infotainment System
 * File: VehicleBackend.h
 * Author / Developer: Sk Rehan Ahamed
 * License: MIT
 * ==============================================================================
 */

#pragma once

#include <QObject>
#include <QMap>
#include <QVariantList>
#include <QVariantMap>

class VehicleSimulator;
class PersistenceManager;

class VehicleBackend : public QObject
{
    Q_OBJECT

    Q_PROPERTY(int vehicleSpeed READ vehicleSpeed NOTIFY vehicleSpeedChanged)
    Q_PROPERTY(int engineRpm READ engineRpm NOTIFY engineRpmChanged)
    Q_PROPERTY(QString gear READ gear WRITE setGear NOTIFY gearChanged)
    Q_PROPERTY(QString driveMode READ driveMode WRITE setDriveMode NOTIFY driveModeChanged)
    Q_PROPERTY(double outsideTemperature READ outsideTemperature NOTIFY outsideTemperatureChanged)
    Q_PROPERTY(int batteryLevel READ batteryLevel NOTIFY batteryLevelChanged)
    Q_PROPERTY(double tripDistance READ tripDistance NOTIFY tripDistanceChanged)
    Q_PROPERTY(bool headlights READ headlights WRITE setHeadlights NOTIFY headlightsChanged)
    Q_PROPERTY(bool autoHold READ autoHold WRITE setAutoHold NOTIFY autoHoldChanged)
    Q_PROPERTY(bool valetMode READ valetMode WRITE setValetMode NOTIFY valetModeChanged)
    Q_PROPERTY(bool ambientLighting READ ambientLighting WRITE setAmbientLighting NOTIFY ambientLightingChanged)
    Q_PROPERTY(QString ambientColor READ ambientColor WRITE setAmbientColor NOTIFY ambientColorChanged)
    Q_PROPERTY(double ambientBrightness READ ambientBrightness WRITE setAmbientBrightness NOTIFY ambientBrightnessChanged)
    Q_PROPERTY(bool trunkOpen READ trunkOpen WRITE setTrunkOpen NOTIFY trunkOpenChanged)
    Q_PROPERTY(int oilLife READ oilLife NOTIFY oilLifeChanged)
    Q_PROPERTY(int tirePressureFL READ tirePressureFL NOTIFY tirePressureChanged)
    Q_PROPERTY(int tirePressureFR READ tirePressureFR NOTIFY tirePressureChanged)
    Q_PROPERTY(int tirePressureRL READ tirePressureRL NOTIFY tirePressureChanged)
    Q_PROPERTY(int tirePressureRR READ tirePressureRR NOTIFY tirePressureChanged)
    Q_PROPERTY(int recPressureFront READ recPressureFront CONSTANT)
    Q_PROPERTY(int recPressureRear READ recPressureRear CONSTANT)

    // Driver Profile properties
    Q_PROPERTY(QString driverProfile READ driverProfile WRITE setDriverProfile NOTIFY driverProfileChanged)
    Q_PROPERTY(QString driverProfileName READ driverProfileName WRITE setDriverProfileName NOTIFY driverProfileChanged)
    Q_PROPERTY(QString driverProfileAvatar READ driverProfileAvatar WRITE setDriverProfileAvatar NOTIFY driverProfileChanged)
    Q_PROPERTY(QString driverProfileAvatarPath READ driverProfileAvatarPath WRITE setDriverProfileAvatarPath NOTIFY driverProfileChanged)
    Q_PROPERTY(QVariantList profilesList READ profilesList NOTIFY driverProfileChanged)
    Q_PROPERTY(int profileCount READ profileCount NOTIFY driverProfileChanged)
    Q_PROPERTY(bool canAddProfile READ canAddProfile NOTIFY driverProfileChanged)
    Q_PROPERTY(QString currentProfileId READ currentProfileId NOTIFY driverProfileChanged)
    Q_PROPERTY(bool isGuestSession READ isGuestSession NOTIFY driverProfileChanged)

    // Profile Security & Device Linking
    Q_PROPERTY(QString currentLockType READ currentLockType WRITE setCurrentLockType NOTIFY profileSecurityChanged)
    Q_PROPERTY(QString profilePinCode READ profilePinCode WRITE setProfilePinCode NOTIFY profileSecurityChanged)
    Q_PROPERTY(QString profilePassword READ profilePassword WRITE setProfilePassword NOTIFY profileSecurityChanged)
    Q_PROPERTY(QString currentProfileRole READ currentProfileRole CONSTANT)
    Q_PROPERTY(bool keyFobLinked READ keyFobLinked WRITE setKeyFobLinked NOTIFY profileSecurityChanged)
    Q_PROPERTY(bool phoneKeyLinked READ phoneKeyLinked WRITE setPhoneKeyLinked NOTIFY profileSecurityChanged)
    Q_PROPERTY(bool btDeviceLinked READ btDeviceLinked WRITE setBtDeviceLinked NOTIFY profileSecurityChanged)

public:
    explicit VehicleBackend(VehicleSimulator *simulator, PersistenceManager *persistence = nullptr, QObject *parent = nullptr);

    struct ProfileData {
        QString id;
        QString name;
        QString avatar{"monogram"};
        QString avatarPath{""};
        QString linkedKey{"Key Fob 1, Phone As A Key linked"};
        QString lockType{"None"};
        QString pinCode{"1234"};
        QString password{""};
        QString role{"Signed in as admin"};
        bool keyFobLinked{true};
        bool phoneKeyLinked{true};
        bool btDeviceLinked{true};
    };

    int vehicleSpeed() const { return m_vehicleSpeed; }
    int engineRpm() const { return m_engineRpm; }
    QString gear() const { return m_gear; }
    QString driveMode() const { return m_driveMode; }
    double outsideTemperature() const { return m_outsideTemperature; }
    int batteryLevel() const { return m_batteryLevel; }
    double tripDistance() const { return m_tripDistance; }
    bool headlights() const { return m_headlights; }
    bool autoHold() const { return m_autoHold; }
    bool valetMode() const { return m_valetMode; }
    bool ambientLighting() const { return m_ambientLighting; }
    QString ambientColor() const { return m_ambientColor; }
    double ambientBrightness() const { return m_ambientBrightness; }
    bool trunkOpen() const { return m_trunkOpen; }
    int oilLife() const { return m_oilLife; }
    int tirePressureFL() const { return m_tirePressureFL; }
    int tirePressureFR() const { return m_tirePressureFR; }
    int tirePressureRL() const { return m_tirePressureRL; }
    int tirePressureRR() const { return m_tirePressureRR; }
    int recPressureFront() const { return m_recPressureFront; }
    int recPressureRear() const { return m_recPressureRear; }

    QString driverProfile() const;
    QString driverProfileName() const;
    QString driverProfileAvatar() const;
    QString driverProfileAvatarPath() const;
    QVariantList profilesList() const;
    int profileCount() const;
    bool canAddProfile() const;
    QString currentProfileId() const;
    bool isGuestSession() const { return m_isGuest; }

    // Security & Link getters
    QString currentLockType() const;
    QString profilePinCode() const;
    QString profilePassword() const;
    QString currentProfileRole() const;
    bool keyFobLinked() const;
    bool phoneKeyLinked() const;
    bool btDeviceLinked() const;

    Q_INVOKABLE void setGear(const QString &gear);
    Q_INVOKABLE void setDriveMode(const QString &mode);
    Q_INVOKABLE void cycleDriveMode();
    Q_INVOKABLE void setDriverProfile(const QString &profile);
    Q_INVOKABLE void setDriverProfileName(const QString &name);
    Q_INVOKABLE void setDriverProfileAvatar(const QString &avatar, const QString &path = QString());
    Q_INVOKABLE void setDriverProfileAvatarPath(const QString &path);
    Q_INVOKABLE bool switchProfile(const QString &profileId);
    Q_INVOKABLE bool addProfile(const QString &name, const QString &avatar = "monogram", const QString &avatarPath = "", const QString &linkedKey = "Key Fob linked");
    Q_INVOKABLE bool deleteProfile(const QString &profileId);
    Q_INVOKABLE void driveAsGuest();
    Q_INVOKABLE void showToast(const QString &msg) { Q_UNUSED(msg); }
    Q_INVOKABLE void renameProfile(const QString &profileId, const QString &name);
    Q_INVOKABLE void updateProfileAvatar(const QString &profileId, const QString &avatar, const QString &avatarPath = "");

    // Security & Link invokables
    Q_INVOKABLE void setCurrentLockType(const QString &lockType);
    Q_INVOKABLE void setProfilePinCode(const QString &pin);
    Q_INVOKABLE void setProfilePassword(const QString &password);
    Q_INVOKABLE void setKeyFobLinked(bool linked);
    Q_INVOKABLE void setPhoneKeyLinked(bool linked);
    Q_INVOKABLE void setBtDeviceLinked(bool linked);
    Q_INVOKABLE void setProfileSecurity(const QString &profileId, const QString &lockType, const QString &pinCode, const QString &password);
    Q_INVOKABLE void setProfileLinks(const QString &profileId, bool keyFob, bool phoneKey, bool btDevice);

    Q_INVOKABLE void setHeadlights(bool on);
    Q_INVOKABLE void setAutoHold(bool on);
    Q_INVOKABLE void toggleAutoHold();
    Q_INVOKABLE void setValetMode(bool on);
    Q_INVOKABLE void toggleValetMode();
    Q_INVOKABLE void setAmbientLighting(bool on);
    Q_INVOKABLE void toggleAmbientLighting();
    Q_INVOKABLE void setAmbientColor(const QString &color);
    Q_INVOKABLE void setAmbientBrightness(double brightness);
    Q_INVOKABLE void setTrunkOpen(bool on);
    Q_INVOKABLE void toggleTrunk();
    Q_INVOKABLE void saveVehicleStudioPose(double yaw, double pitch, double cameraZ, double posX, double posY);
    Q_INVOKABLE QVariantMap loadVehicleStudioPose() const;

signals:
    void vehicleSpeedChanged();
    void engineRpmChanged();
    void gearChanged();
    void driveModeChanged();
    void outsideTemperatureChanged();
    void batteryLevelChanged();
    void tripDistanceChanged();
    void headlightsChanged();
    void autoHoldChanged();
    void valetModeChanged();
    void ambientLightingChanged();
    void ambientColorChanged();
    void ambientBrightnessChanged();
    void trunkOpenChanged();
    void oilLifeChanged();
    void tirePressureChanged();
    void driverProfileChanged();
    void profileSecurityChanged();

private slots:
    void onTelemetryUpdated(double speed, double rpm, const QString &gear, double temp, int battery);

private:
    void syncFromPersistence();
    void saveCurrentProfilePreferences();
    void loadProfilePreferences(const QString &profileId);

    PersistenceManager *m_persistence{nullptr};

    QList<ProfileData> m_profiles;
    QString m_currentProfileId{"p1"};
    bool m_isGuest{false};
    int m_vehicleSpeed{68};
    int m_engineRpm{1900};
    QString m_gear{"D"};
    QString m_driveMode{"COMFORT"};
    double m_outsideTemperature{21.5};
    int m_batteryLevel{88};
    double m_tripDistance{142.6};
    bool m_headlights{true};
    bool m_autoHold{true};
    bool m_valetMode{false};
    bool m_ambientLighting{true};
    QString m_ambientColor{"#70C5F5"};
    double m_ambientBrightness{0.85};
    bool m_trunkOpen{false};
    int m_oilLife{100};
    int m_tirePressureFL{35};
    int m_tirePressureFR{35};
    int m_tirePressureRL{41};
    int m_tirePressureRR{41};
    int m_recPressureFront{33};
    int m_recPressureRear{40};
};
