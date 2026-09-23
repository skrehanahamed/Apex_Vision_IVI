#include "VehicleBackend.h"
#include "VehicleSimulator.h"
#include <cmath>

VehicleBackend::VehicleBackend(VehicleSimulator *simulator, QObject *parent)
    : QObject(parent)
{
    if (simulator) {
        connect(simulator, &VehicleSimulator::telemetryUpdated,
                this, &VehicleBackend::onTelemetryUpdated);
    }
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

void VehicleBackend::setHeadlights(bool on)
{
    if (m_headlights != on) {
        m_headlights = on;
        emit headlightsChanged();
    }
}
