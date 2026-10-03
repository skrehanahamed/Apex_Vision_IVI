/**
 * ==============================================================================
 * Project: Apex VISION IVI - Digital Cockpit & Infotainment System
 * File: SystemBackend.cpp
 * Author / Developer: Sk Rehan Ahamed
 * License: MIT
 * ==============================================================================
 */

#include "SystemBackend.h"
#include "PersistenceManager.h"
#include <algorithm>
#include <QProcess>
#include <QElapsedTimer>

SystemBackend::SystemBackend(PersistenceManager *persistence, QObject *parent)
    : QObject(parent)
    , m_persistence(persistence)
{
    if (m_persistence) {
        m_is24HourFormat = m_persistence->getSetting(QStringLiteral("sys_is24HourFormat"), true).toBool();
        m_autoTimeEnabled = m_persistence->getSetting(QStringLiteral("sys_autoTimeEnabled"), true).toBool();
        m_autoTimeZoneEnabled = m_persistence->getSetting(QStringLiteral("sys_autoTimeZoneEnabled"), true).toBool();
        m_selectedTimeZone = m_persistence->getSetting(QStringLiteral("sys_selectedTimeZone"), QStringLiteral("GMT-04:00 Eastern Daylight Time")).toString();
        m_selectedLanguage = m_persistence->getSetting(QStringLiteral("sys_selectedLanguage"), QStringLiteral("English")).toString();
        m_selectedKeyboard = m_persistence->getSetting(QStringLiteral("sys_selectedKeyboard"), QStringLiteral("Apex Touch Keyboard")).toString();
        m_selectedAutofill = m_persistence->getSetting(QStringLiteral("sys_selectedAutofill"), QStringLiteral("Apex Cloud")).toString();
        m_pointerSpeed = m_persistence->getSetting(QStringLiteral("sys_pointerSpeed"), 50).toInt();
        m_unitsTemperature = m_persistence->getSetting(QStringLiteral("sys_unitsTemperature"), QStringLiteral("Celsius (°C)")).toString();
        m_brightness = m_persistence->getSetting(QStringLiteral("sys_brightness"), 85).toInt();
        m_touchSoundsEnabled = m_persistence->getSetting(QStringLiteral("sys_touchSoundsEnabled"), true).toBool();
    }

    updateClock();
    connect(&m_clockTimer, &QTimer::timeout, this, &SystemBackend::updateClock);
    m_clockTimer.start(1000);
}

SystemBackend::~SystemBackend()
{
    stopTts();
}

void SystemBackend::updateClock()
{
    QDateTime now = QDateTime::currentDateTime();
    if (!m_autoTimeEnabled && m_hasManualOffset) {
        now = now.addSecs(m_manualTimeOffsetSec);
    }

    QString timeStr;
    if (m_is24HourFormat) {
        timeStr = now.toString("HH:mm");
    } else {
        int h = now.time().hour() % 12;
        if (h == 0) h = 12;
        timeStr = QString("%1:%2").arg(h).arg(now.time().minute(), 2, 10, QChar('0'));
    }
    const QString dateStr = now.toString("dddd, MMM d");

    bool changed = false;
    if (m_currentTime != timeStr) {
        m_currentTime = timeStr;
        changed = true;
    }
    if (m_currentDate != dateStr) {
        m_currentDate = dateStr;
        changed = true;
    }
    if (changed) {
        emit timeChanged();
    }
}

void SystemBackend::setIs24HourFormat(bool is24)
{
    if (m_is24HourFormat != is24) {
        m_is24HourFormat = is24;
        if (m_persistence) {
            m_persistence->setSetting(QStringLiteral("sys_is24HourFormat"), is24);
        }
        updateClock();
        emit is24HourFormatChanged();
    }
}

void SystemBackend::setAutoTimeEnabled(bool enabled)
{
    if (m_autoTimeEnabled != enabled) {
        m_autoTimeEnabled = enabled;
        if (m_autoTimeEnabled) {
            m_hasManualOffset = false;
            m_manualTimeOffsetSec = 0;
        }
        if (m_persistence) {
            m_persistence->setSetting(QStringLiteral("sys_autoTimeEnabled"), enabled);
        }
        updateClock();
        emit autoTimeEnabledChanged();
    }
}

void SystemBackend::setAutoTimeZoneEnabled(bool enabled)
{
    if (m_autoTimeZoneEnabled != enabled) {
        m_autoTimeZoneEnabled = enabled;
        if (m_persistence) {
            m_persistence->setSetting(QStringLiteral("sys_autoTimeZoneEnabled"), enabled);
        }
        emit autoTimeZoneEnabledChanged();
    }
}

void SystemBackend::setSelectedTimeZone(const QString &tz)
{
    if (m_selectedTimeZone != tz) {
        m_selectedTimeZone = tz;
        if (m_persistence) {
            m_persistence->setSetting(QStringLiteral("sys_selectedTimeZone"), tz);
        }
        emit selectedTimeZoneChanged();
    }
}

void SystemBackend::setManualTime(int hour, int minute)
{
    QDateTime now = QDateTime::currentDateTime();
    QDateTime target(now.date(), QTime(hour, minute, 0));
    m_manualTimeOffsetSec = now.secsTo(target);
    m_hasManualOffset = true;
    m_autoTimeEnabled = false;
    emit autoTimeEnabledChanged();
    updateClock();
}

void SystemBackend::setManualDate(int year, int month, int day)
{
    QDateTime now = QDateTime::currentDateTime();
    if (m_hasManualOffset) {
        now = now.addSecs(m_manualTimeOffsetSec);
    }
    QDateTime target(QDate(year, month, day), now.time());
    m_manualTimeOffsetSec = QDateTime::currentDateTime().secsTo(target);
    m_hasManualOffset = true;
    m_autoTimeEnabled = false;
    emit autoTimeEnabledChanged();
    updateClock();
}

void SystemBackend::setWifiConnected(bool connected)
{
    if (m_wifiConnected != connected) {
        m_wifiConnected = connected;
        emit wifiConnectedChanged();
    }
}

void SystemBackend::setBrightness(int b)
{
    b = std::clamp(b, 10, 100);
    if (m_brightness != b) {
        m_brightness = b;
        if (m_persistence) {
            m_persistence->setSetting(QStringLiteral("sys_brightness"), b);
        }
        emit brightnessChanged();
    }
}

void SystemBackend::setSelectedLanguage(const QString &lang)
{
    if (m_selectedLanguage != lang) {
        m_selectedLanguage = lang;
        if (m_persistence) {
            m_persistence->setSetting(QStringLiteral("sys_selectedLanguage"), lang);
        }
        emit selectedLanguageChanged();
    }
}

void SystemBackend::setSelectedKeyboard(const QString &kb)
{
    if (m_selectedKeyboard != kb) {
        m_selectedKeyboard = kb;
        if (m_persistence) {
            m_persistence->setSetting(QStringLiteral("sys_selectedKeyboard"), kb);
        }
        emit selectedKeyboardChanged();
    }
}

void SystemBackend::setSelectedAutofill(const QString &af)
{
    if (m_selectedAutofill != af) {
        m_selectedAutofill = af;
        if (m_persistence) {
            m_persistence->setSetting(QStringLiteral("sys_selectedAutofill"), af);
        }
        emit selectedAutofillChanged();
    }
}

void SystemBackend::setPointerSpeed(int speed)
{
    speed = std::clamp(speed, 0, 100);
    if (m_pointerSpeed != speed) {
        m_pointerSpeed = speed;
        if (m_persistence) {
            m_persistence->setSetting(QStringLiteral("sys_pointerSpeed"), speed);
        }
        emit pointerSpeedChanged();
    }
}

void SystemBackend::playTtsSample(const QString &text, double rate, double pitch)
{
    Q_UNUSED(pitch);
    stopTts();

    int wpm = (rate > 10.0) ? static_cast<int>(110 + (rate / 100.0) * 140) : 175;

    m_ttsProcess = new QProcess(this);
    connect(m_ttsProcess, QOverload<int, QProcess::ExitStatus>::of(&QProcess::finished),
            this, [this](int exitCode, QProcess::ExitStatus exitStatus) {
        Q_UNUSED(exitCode);
        if (m_ttsProcess) {
            m_ttsProcess->deleteLater();
            m_ttsProcess = nullptr;
        }
        if (exitStatus == QProcess::NormalExit) {
            emit ttsFinished();
        }
    });

    QStringList args;
    args << "-r" << QString::number(wpm) << text;
    m_ttsProcess->start("say", args);
}

void SystemBackend::stopTts()
{
    if (m_ttsProcess) {
        m_ttsProcess->disconnect(this);
        m_ttsProcess->kill();
        m_ttsProcess->waitForFinished(300);
        m_ttsProcess->deleteLater();
        m_ttsProcess = nullptr;
    }
}

void SystemBackend::setUnitsTemperature(const QString &unit)
{
    if (m_unitsTemperature != unit) {
        m_unitsTemperature = unit;
        if (m_persistence) {
            m_persistence->setSetting(QStringLiteral("sys_unitsTemperature"), unit);
        }
        emit unitsTemperatureChanged();
    }
}

void SystemBackend::setTouchSoundsEnabled(bool enabled)
{
    if (m_touchSoundsEnabled != enabled) {
        m_touchSoundsEnabled = enabled;
        if (m_persistence) {
            m_persistence->setSetting(QStringLiteral("sys_touchSoundsEnabled"), enabled);
        }
        emit touchSoundsEnabledChanged();
    }
}

void SystemBackend::playTouchSound()
{
    if (!m_touchSoundsEnabled) return;

    static QElapsedTimer lastTouchTimer;
    static bool timerStarted = false;
    if (timerStarted && lastTouchTimer.elapsed() < 50) {
        return;
    }
    lastTouchTimer.restart();
    timerStarted = true;

    static QString soundPath;
    if (soundPath.isEmpty()) {
        const QStringList candidates = {
            QStringLiteral("/Users/reno/Projects/APEX_VISION_IVI/qml/assets/sounds/touch_click.wav"),
            QDir::currentPath() + QStringLiteral("/qml/assets/sounds/touch_click.wav"),
            QCoreApplication::applicationDirPath() + QStringLiteral("/qml/assets/sounds/touch_click.wav"),
            QCoreApplication::applicationDirPath() + QStringLiteral("/../Resources/qml/assets/sounds/touch_click.wav")
        };
        for (const QString &p : candidates) {
            if (QFile::exists(p)) {
                soundPath = p;
                break;
            }
        }
        if (soundPath.isEmpty() && QFile::exists(QStringLiteral(":/ApexVision/qml/assets/sounds/touch_click.wav"))) {
            QString tmpPath = QDir::tempPath() + QStringLiteral("/apex_touch_click.wav");
            QFile::remove(tmpPath);
            if (QFile::copy(QStringLiteral(":/ApexVision/qml/assets/sounds/touch_click.wav"), tmpPath)) {
                soundPath = tmpPath;
            }
        }
    }

    if (!soundPath.isEmpty()) {
#if defined(Q_OS_MACOS)
        QProcess::startDetached(QStringLiteral("afplay"), {QStringLiteral("-v"), QStringLiteral("0.35"), soundPath});
#elif defined(Q_OS_LINUX)
        QProcess::startDetached(QStringLiteral("aplay"), {QStringLiteral("-q"), soundPath});
#endif
    }
}

void SystemBackend::playSound(const QString &soundName)
{
    QString baseName = soundName;
    if (!baseName.endsWith(QStringLiteral(".wav"))) {
        baseName += QStringLiteral(".wav");
    }

    const QStringList candidates = {
        QCoreApplication::applicationDirPath() + QStringLiteral("/qml/assets/sounds/") + baseName,
        QStringLiteral("/opt/apex_vision_ivi/qml/assets/sounds/") + baseName,
        QDir::currentPath() + QStringLiteral("/qml/assets/sounds/") + baseName,
        QStringLiteral("/Users/reno/Projects/APEX_VISION_IVI/qml/assets/sounds/") + baseName
    };

    QString targetPath;
    for (const QString &p : candidates) {
        if (QFile::exists(p)) {
            targetPath = p;
            break;
        }
    }

    if (targetPath.isEmpty()) {
        const QString resPath = QStringLiteral(":/ApexVision/qml/assets/sounds/") + baseName;
        if (QFile::exists(resPath)) {
            QString tmpPath = QDir::tempPath() + QStringLiteral("/apex_") + baseName;
            QFile::remove(tmpPath);
            if (QFile::copy(resPath, tmpPath)) {
                targetPath = tmpPath;
            }
        }
    }

    if (!targetPath.isEmpty()) {
#if defined(Q_OS_MACOS)
        QProcess::startDetached(QStringLiteral("afplay"), {targetPath});
#elif defined(Q_OS_LINUX)
        QProcess::startDetached(QStringLiteral("aplay"), {QStringLiteral("-q"), targetPath});
#endif
    }
}
