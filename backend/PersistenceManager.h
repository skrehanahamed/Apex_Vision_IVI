/**
 * ==============================================================================
 * Project: Apex VISION IVI - Digital Cockpit & Infotainment System
 * File: PersistenceManager.h
 * Author / Developer: Sk Rehan Ahamed
 * License: MIT
 * ==============================================================================
 * Description:
 * Automotive Non-Volatile Memory (NVM) & Persistence Management Service.
 * Provides high-speed in-memory caching with atomic disk serialization
 * for driver profiles, security keys, vehicle states, and system preferences.
 * ==============================================================================
 */

#pragma once

#include <QObject>
#include <QString>
#include <QVariantMap>
#include <QVariantList>
#include <QTimer>
#include <QJsonObject>
#include <QJsonArray>
#include <QJsonDocument>
#include <QSaveFile>
#include <QFile>
#include <QFileInfo>
#include <QDir>
#include <QStandardPaths>
#include <QDebug>
#include <QCoreApplication>

class PersistenceManager : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString activeProfileId READ activeProfileId WRITE setActiveProfileId NOTIFY activeProfileChanged)
    Q_PROPERTY(QVariantList profiles READ profiles NOTIFY profilesChanged)
    Q_PROPERTY(int profileCount READ profileCount NOTIFY profilesChanged)
    Q_PROPERTY(bool isDirty READ isDirty NOTIFY dirtyChanged)
    Q_PROPERTY(QString storageFilePath READ storageFilePath CONSTANT)

public:
    struct ProfileRecord {
        QString id;
        QString name;
        QString avatar{"monogram"};
        QString avatarPath{""};
        QString linkedKey{"Key Fob 1, Phone As A Key linked"};
        QString lockType{"None"}; // "None" | "Pattern" | "PIN" | "Password"
        QString pinCode{"1234"};
        QString password{""};
        QString role{"Signed in as admin"};
        bool keyFobLinked{true};
        bool phoneKeyLinked{true};
        bool btDeviceLinked{true};
        QVariantMap preferences; // driveMode, ambientColor, ambientBrightness, ambientLighting, etc.
    };

    explicit PersistenceManager(QObject *parent = nullptr);
    ~PersistenceManager() override;

    static PersistenceManager* instance();

    QString storageFilePath() const { return m_storageFilePath; }
    bool isDirty() const { return m_isDirty; }

    QString activeProfileId() const { return m_activeProfileId; }
    void setActiveProfileId(const QString &id);

    QVariantList profiles() const;
    int profileCount() const { return m_profiles.size(); }

    QList<ProfileRecord> profileRecords() const { return m_profiles; }
    bool getProfileRecord(const QString &profileId, ProfileRecord &outRecord) const;
    bool updateProfileRecord(const ProfileRecord &record);

    // Profile CRUD & Security
    Q_INVOKABLE QVariantMap getProfile(const QString &profileId) const;
    Q_INVOKABLE bool addOrUpdateProfile(const QString &id, const QString &name, const QString &avatar, const QString &avatarPath, const QString &linkedKey);
    Q_INVOKABLE bool removeProfile(const QString &profileId);
    Q_INVOKABLE bool setProfileSecurity(const QString &profileId, const QString &lockType, const QString &pinCode, const QString &password);
    Q_INVOKABLE bool setProfileLinks(const QString &profileId, bool keyFob, bool phoneKey, bool btDevice);

    // Profile-scoped preferences (e.g. ambient lighting, drive mode)
    Q_INVOKABLE QVariant getProfilePreference(const QString &profileId, const QString &key, const QVariant &defaultValue = QVariant()) const;
    Q_INVOKABLE void setProfilePreference(const QString &profileId, const QString &key, const QVariant &value);

    // Global / App Settings
    Q_INVOKABLE QVariant getSetting(const QString &key, const QVariant &defaultValue = QVariant()) const;
    Q_INVOKABLE void setSetting(const QString &key, const QVariant &value);
    Q_INVOKABLE bool hasSetting(const QString &key) const;
    Q_INVOKABLE void removeSetting(const QString &key);
    Q_INVOKABLE QVariantMap getAllSettings() const { return m_globalSettings; }

    // Memory Sync & Persistence Lifecycle
    Q_INVOKABLE void flush();            // Flush in-memory state to disk immediately
    Q_INVOKABLE void scheduleSave();     // Debounced flush (prevents disk thrashing)
    Q_INVOKABLE void reloadFromDisk();   // Discard in-memory changes & re-read disk
    Q_INVOKABLE void resetToDefaults();  // Factory reset (wipes profiles and settings)

signals:
    void activeProfileChanged(const QString &id);
    void profilesChanged();
    void settingChanged(const QString &key, const QVariant &value);
    void profilePreferenceChanged(const QString &profileId, const QString &key, const QVariant &value);
    void dirtyChanged(bool dirty);
    void savedToDisk();

private slots:
    void onSaveTimeout();

private:
    void initStoragePath();
    void loadFromDisk();
    void saveToDiskInternal();
    void setDirty();
    void seedDefaultsIfEmpty();

    static PersistenceManager *s_instance;

    QString m_storageFilePath;
    QList<ProfileRecord> m_profiles;
    QString m_activeProfileId{"p1"};
    QVariantMap m_globalSettings;

    bool m_isDirty{false};
    QTimer m_saveTimer;
};
