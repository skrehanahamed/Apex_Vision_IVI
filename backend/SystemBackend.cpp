/**
 * ==============================================================================
 * Project: Apex VISION IVI - Digital Cockpit & Infotainment System
 * File: SystemBackend.cpp
 * Author / Developer: Sk Rehan Ahamed
 * License: MIT
 * ==============================================================================
 */

#include "SystemBackend.h"
#include <algorithm>
#include <QProcess>

SystemBackend::SystemBackend(QObject *parent)
    : QObject(parent)
{
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
        updateClock();
        emit autoTimeEnabledChanged();
    }
}

void SystemBackend::setAutoTimeZoneEnabled(bool enabled)
{
    if (m_autoTimeZoneEnabled != enabled) {
        m_autoTimeZoneEnabled = enabled;
        emit autoTimeZoneEnabledChanged();
    }
}

void SystemBackend::setSelectedTimeZone(const QString &tz)
{
    if (m_selectedTimeZone != tz) {
        m_selectedTimeZone = tz;
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
        emit brightnessChanged();
    }
}

void SystemBackend::setSelectedLanguage(const QString &lang)
{
    if (m_selectedLanguage != lang) {
        m_selectedLanguage = lang;
        emit selectedLanguageChanged();
    }
}

void SystemBackend::setSelectedKeyboard(const QString &kb)
{
    if (m_selectedKeyboard != kb) {
        m_selectedKeyboard = kb;
        emit selectedKeyboardChanged();
    }
}

void SystemBackend::setSelectedAutofill(const QString &af)
{
    if (m_selectedAutofill != af) {
        m_selectedAutofill = af;
        emit selectedAutofillChanged();
    }
}

void SystemBackend::setPointerSpeed(int speed)
{
    speed = std::clamp(speed, 0, 100);
    if (m_pointerSpeed != speed) {
        m_pointerSpeed = speed;
        emit pointerSpeedChanged();
    }
}

void SystemBackend::playTtsSample(const QString &text, double rate, double pitch)
{
    Q_UNUSED(pitch);
    stopTts();

    // Natural speech rate: ~175 WPM (or adjusted if rate specified)
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
        emit unitsTemperatureChanged();
    }
}


