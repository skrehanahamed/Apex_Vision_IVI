/**
 * ==============================================================================
 * Project: Apex VISION IVI - Digital Cockpit & Infotainment System
 * File: SystemBackend.h
 * Author / Developer: Sk Rehan Ahamed
 * License: MIT
 * ==============================================================================
 */

#pragma once

#include <QObject>
#include <QTimer>
#include <QDateTime>
#include <QProcess>

class PersistenceManager;

class SystemBackend : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString currentTime READ currentTime NOTIFY timeChanged)
    Q_PROPERTY(QString currentDate READ currentDate NOTIFY timeChanged)
    Q_PROPERTY(bool is24HourFormat READ is24HourFormat WRITE setIs24HourFormat NOTIFY is24HourFormatChanged)
    Q_PROPERTY(bool autoTimeEnabled READ autoTimeEnabled WRITE setAutoTimeEnabled NOTIFY autoTimeEnabledChanged)
    Q_PROPERTY(bool autoTimeZoneEnabled READ autoTimeZoneEnabled WRITE setAutoTimeZoneEnabled NOTIFY autoTimeZoneEnabledChanged)
    Q_PROPERTY(QString selectedTimeZone READ selectedTimeZone WRITE setSelectedTimeZone NOTIFY selectedTimeZoneChanged)
    Q_PROPERTY(QString selectedLanguage READ selectedLanguage WRITE setSelectedLanguage NOTIFY selectedLanguageChanged)
    Q_PROPERTY(QString selectedKeyboard READ selectedKeyboard WRITE setSelectedKeyboard NOTIFY selectedKeyboardChanged)
    Q_PROPERTY(QString selectedAutofill READ selectedAutofill WRITE setSelectedAutofill NOTIFY selectedAutofillChanged)
    Q_PROPERTY(int pointerSpeed READ pointerSpeed WRITE setPointerSpeed NOTIFY pointerSpeedChanged)
    Q_PROPERTY(bool wifiEnabled READ wifiEnabled WRITE setWifiEnabled NOTIFY wifiEnabledChanged)
    Q_PROPERTY(bool wifiConnected READ wifiConnected WRITE setWifiConnected NOTIFY wifiConnectedChanged)
    Q_PROPERTY(QString wifiBand READ wifiBand WRITE setWifiBand NOTIFY wifiBandChanged)
    Q_PROPERTY(int wifiSignalBars READ wifiSignalBars WRITE setWifiSignalBars NOTIFY wifiSignalBarsChanged)
    Q_PROPERTY(int wifiSignalDbm READ wifiSignalDbm NOTIFY wifiSignalDbmChanged)
    Q_PROPERTY(QString wifiSsid READ wifiSsid NOTIFY wifiSsidChanged)
    Q_PROPERTY(QString wifiIpAddress READ wifiIpAddress NOTIFY wifiIpAddressChanged)
    Q_PROPERTY(QString wifiMacAddress READ wifiMacAddress NOTIFY wifiMacAddressChanged)
    Q_PROPERTY(QString wifiSecurity READ wifiSecurity NOTIFY wifiSecurityChanged)
    Q_PROPERTY(bool wifiScanning READ wifiScanning NOTIFY wifiScanningChanged)
    Q_PROPERTY(QVariantList wifiNetworks READ wifiNetworks NOTIFY wifiNetworksChanged)
    Q_PROPERTY(QString lastWifiError READ lastWifiError NOTIFY lastWifiErrorChanged)
    Q_PROPERTY(int brightness READ brightness WRITE setBrightness NOTIFY brightnessChanged)
    Q_PROPERTY(QString unitsTemperature READ unitsTemperature WRITE setUnitsTemperature NOTIFY unitsTemperatureChanged)
    Q_PROPERTY(bool touchSoundsEnabled READ touchSoundsEnabled WRITE setTouchSoundsEnabled NOTIFY touchSoundsEnabledChanged)
    Q_PROPERTY(int volumePrompts READ volumePrompts WRITE setVolumePrompts NOTIFY volumePromptsChanged)
    Q_PROPERTY(int volumePhone READ volumePhone WRITE setVolumePhone NOTIFY volumePhoneChanged)
    Q_PROPERTY(int volumeCallRing READ volumeCallRing WRITE setVolumeCallRing NOTIFY volumeCallRingChanged)
    Q_PROPERTY(bool hasWebEngine READ hasWebEngine CONSTANT)

public:
    explicit SystemBackend(PersistenceManager *persistence = nullptr, QObject *parent = nullptr);
    ~SystemBackend() override;

    bool hasWebEngine() const {
#ifdef HAVE_WEBENGINE
        return true;
#else
        return false;
#endif
    }

    bool touchSoundsEnabled() const { return m_touchSoundsEnabled; }
    int volumePrompts() const { return m_volumePrompts; }
    int volumePhone() const { return m_volumePhone; }
    int volumeCallRing() const { return m_volumeCallRing; }

    QString currentTime() const { return m_currentTime; }
    QString currentDate() const { return m_currentDate; }
    bool is24HourFormat() const { return m_is24HourFormat; }
    bool autoTimeEnabled() const { return m_autoTimeEnabled; }
    bool autoTimeZoneEnabled() const { return m_autoTimeZoneEnabled; }
    QString selectedTimeZone() const { return m_selectedTimeZone; }
    QString selectedLanguage() const { return m_selectedLanguage; }
    QString selectedKeyboard() const { return m_selectedKeyboard; }
    QString selectedAutofill() const { return m_selectedAutofill; }
    int pointerSpeed() const { return m_pointerSpeed; }
    bool wifiEnabled() const { return m_wifiEnabled; }
    bool wifiConnected() const { return m_wifiConnected; }
    QString wifiBand() const { return m_wifiBand; }
    int wifiSignalBars() const { return m_wifiSignalBars; }
    int wifiSignalDbm() const { return m_wifiSignalDbm; }
    QString wifiSsid() const { return m_wifiSsid; }
    QString wifiIpAddress() const { return m_wifiIpAddress; }
    QString wifiMacAddress() const { return m_wifiMacAddress; }
    QString wifiSecurity() const { return m_wifiSecurity; }
    bool wifiScanning() const { return m_wifiScanning; }
    QVariantList wifiNetworks() const { return m_wifiNetworks; }
    QString lastWifiError() const { return m_lastWifiError; }
    int brightness() const { return m_brightness; }
    QString unitsTemperature() const { return m_unitsTemperature; }

    Q_INVOKABLE void setVolumePrompts(int vol);
    Q_INVOKABLE void setVolumePhone(int vol);
    Q_INVOKABLE void setVolumeCallRing(int vol);
    Q_INVOKABLE void setIs24HourFormat(bool is24);
    Q_INVOKABLE void setAutoTimeEnabled(bool enabled);
    Q_INVOKABLE void setAutoTimeZoneEnabled(bool enabled);
    Q_INVOKABLE void setSelectedTimeZone(const QString &tz);
    Q_INVOKABLE void setSelectedLanguage(const QString &lang);
    Q_INVOKABLE void setSelectedKeyboard(const QString &kb);
    Q_INVOKABLE void setSelectedAutofill(const QString &af);
    Q_INVOKABLE void setPointerSpeed(int speed);
    Q_INVOKABLE void playTtsSample(const QString &text, double rate, double pitch);
    Q_INVOKABLE void stopTts();
    Q_INVOKABLE void setManualTime(int hour, int minute);
    Q_INVOKABLE void setManualDate(int year, int month, int day);
    Q_INVOKABLE void setWifiEnabled(bool enabled);
    Q_INVOKABLE void setWifiConnected(bool connected);
    Q_INVOKABLE void setWifiBand(const QString &band);
    Q_INVOKABLE void setWifiSignalBars(int bars);
    Q_INVOKABLE void refreshWifiStatus();
    Q_INVOKABLE void scanWifiNetworks();
    Q_INVOKABLE void scanWifiNetworks(bool userInitiated);
    Q_INVOKABLE void connectToNetwork(const QString &ssid, const QString &password = QString());
    Q_INVOKABLE void disconnectWifi();
    Q_INVOKABLE void forgetNetwork(const QString &ssid);
    Q_INVOKABLE void setBrightness(int b);
    Q_INVOKABLE void setUnitsTemperature(const QString &unit);
    Q_INVOKABLE void setTouchSoundsEnabled(bool enabled);
    Q_INVOKABLE void playTouchSound();
    Q_INVOKABLE void playSound(const QString &soundName);

    Q_INVOKABLE void syncTimeFromInternet();

signals:
    void timeChanged();
    void is24HourFormatChanged();
    void autoTimeEnabledChanged();
    void autoTimeZoneEnabledChanged();
    void selectedTimeZoneChanged();
    void selectedLanguageChanged();
    void selectedKeyboardChanged();
    void selectedAutofillChanged();
    void pointerSpeedChanged();
    void wifiEnabledChanged();
    void wifiConnectedChanged();
    void wifiBandChanged();
    void wifiSignalBarsChanged();
    void wifiSignalDbmChanged();
    void wifiSsidChanged();
    void wifiIpAddressChanged();
    void wifiMacAddressChanged();
    void wifiSecurityChanged();
    void wifiScanningChanged();
    void wifiNetworksChanged();
    void lastWifiErrorChanged();
    void wifiConnectResult(bool success, const QString &message);
    void brightnessChanged();
    void unitsTemperatureChanged();
    void touchSoundsEnabledChanged();
    void volumePromptsChanged();
    void volumePhoneChanged();
    void volumeCallRingChanged();
    void ttsFinished();

private slots:
    void updateClock();
    void updateWifiStatus();

private:
    static int parseGmtOffset(const QString &tzStr);
    void parseScanResults(const QString &scanOutput, const QString &listOutput);

    PersistenceManager *m_persistence{nullptr};

    QTimer m_clockTimer;
    QTimer m_internetSyncTimer;
    class QNetworkAccessManager *m_networkManager{nullptr};
    QString m_currentTime{"12:35"};
    QString m_currentDate{"Wednesday, Sep 23"};
    bool m_is24HourFormat{true};
    bool m_autoTimeEnabled{true};
    bool m_autoTimeZoneEnabled{true};
    QString m_selectedTimeZone{"GMT+05:30 India Standard Time (IST)"};
    QString m_selectedLanguage{"English"};
    QString m_selectedKeyboard{"Apex Touch Keyboard"};
    QString m_selectedAutofill{"Apex Cloud"};
    int m_pointerSpeed{50};
    qint64 m_manualTimeOffsetSec{0};
    bool m_hasManualOffset{false};
    bool m_wifiEnabled{true};
    bool m_wifiConnected{true};
    QString m_wifiBand{"5G"};
    int m_wifiSignalBars{4};
    int m_wifiSignalDbm{-68};
    QString m_wifiSsid{"Knspg 4 th floor_5G"};
    QString m_wifiIpAddress{"192.168.1.217"};
    QString m_wifiMacAddress{"98:fe:54:2b:64:6e"};
    QString m_wifiSecurity{"WPA2-PSK"};
    bool m_wifiScanning{false};
    QVariantList m_wifiNetworks;
    QString m_lastWifiError;
    QTimer m_wifiStatusTimer;
    QTimer m_wifiScanTimer;
    int m_brightness{85};
    QString m_unitsTemperature{"Celsius (°C)"};
    bool m_touchSoundsEnabled{true};
    int m_volumePrompts{10};
    int m_volumePhone{30};
    int m_volumeCallRing{10};
    QProcess *m_ttsProcess{nullptr};
};

