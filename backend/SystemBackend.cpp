#include "SystemBackend.h"
#include <algorithm>

SystemBackend::SystemBackend(QObject *parent)
    : QObject(parent)
{
    updateClock();
    connect(&m_clockTimer, &QTimer::timeout, this, &SystemBackend::updateClock);
    m_clockTimer.start(1000);
}

void SystemBackend::updateClock()
{
    const QDateTime now = QDateTime::currentDateTime();
    const QString timeStr = now.toString("hh:mm");
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
