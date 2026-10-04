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
    Q_PROPERTY(bool wifiConnected READ wifiConnected WRITE setWifiConnected NOTIFY wifiConnectedChanged)
    Q_PROPERTY(int brightness READ brightness WRITE setBrightness NOTIFY brightnessChanged)
    Q_PROPERTY(QString unitsTemperature READ unitsTemperature WRITE setUnitsTemperature NOTIFY unitsTemperatureChanged)
    Q_PROPERTY(bool touchSoundsEnabled READ touchSoundsEnabled WRITE setTouchSoundsEnabled NOTIFY touchSoundsEnabledChanged)
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
    bool wifiConnected() const { return m_wifiConnected; }
    int brightness() const { return m_brightness; }
    QString unitsTemperature() const { return m_unitsTemperature; }

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
    Q_INVOKABLE void setWifiConnected(bool connected);
    Q_INVOKABLE void setBrightness(int b);
    Q_INVOKABLE void setUnitsTemperature(const QString &unit);
    Q_INVOKABLE void setTouchSoundsEnabled(bool enabled);
    Q_INVOKABLE void playTouchSound();

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
    void wifiConnectedChanged();
    void brightnessChanged();
    void unitsTemperatureChanged();
    void touchSoundsEnabledChanged();
    void ttsFinished();

private slots:
    void updateClock();

private:
    PersistenceManager *m_persistence{nullptr};

    QTimer m_clockTimer;
    QString m_currentTime{"12:35"};
    QString m_currentDate{"Wednesday, Sep 23"};
    bool m_is24HourFormat{true};
    bool m_autoTimeEnabled{true};
    bool m_autoTimeZoneEnabled{true};
    QString m_selectedTimeZone{"GMT-04:00 Eastern Daylight Time"};
    QString m_selectedLanguage{"English"};
    QString m_selectedKeyboard{"Apex Touch Keyboard"};
    QString m_selectedAutofill{"Apex Cloud"};
    int m_pointerSpeed{50};
    qint64 m_manualTimeOffsetSec{0};
    bool m_hasManualOffset{false};
    bool m_wifiConnected{true};
    int m_brightness{85};
    QString m_unitsTemperature{"Celsius (°C)"};
    bool m_touchSoundsEnabled{true};
    QProcess *m_ttsProcess{nullptr};
};
