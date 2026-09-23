#include "VehicleSimulator.h"
#include <cmath>

VehicleSimulator::VehicleSimulator(QObject *parent)
    : QObject(parent)
{
    connect(&m_tickTimer, &QTimer::timeout, this, &VehicleSimulator::onTick);
    // 500ms simulation loop for smooth, lightweight updates on Raspberry Pi
    m_tickTimer.start(500);
}

void VehicleSimulator::setPosition(double lat, double lon, double heading)
{
    m_latitude = lat;
    m_longitude = lon;
    m_heading = heading;
}

void VehicleSimulator::onTick()
{
    m_tickCounter += 0.5;

    // Simulate realistic cruising speed around 65-72 km/h
    m_vehicleSpeed = 68.0 + 4.0 * std::sin(m_tickCounter * 0.1);
    m_engineRpm = 1900.0 + (m_vehicleSpeed - 68.0) * 45.0;

    // Keep vehicle position fixed at current location
    // (GPS coordinates remain stationary unless actual vehicle movement / hardware GPS updates occur)
    // m_latitude and m_longitude stay at the current location

    // Media position advancement
    m_mediaPosition++;
    if (m_mediaPosition > m_mediaDuration) {
        m_mediaPosition = 0;
    }

    emit telemetryUpdated(m_vehicleSpeed, m_engineRpm, m_gear, m_outsideTemp, m_batteryLevel);
    emit gpsUpdated(m_latitude, m_longitude, m_heading, m_vehicleSpeed);
    emit mediaProgressUpdated(m_mediaPosition, m_mediaDuration);
}
