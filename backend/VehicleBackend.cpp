#include "VehicleBackend.h"
#include "VehicleSimulator.h"
#include <cmath>
#include <QFile>
#include <QJsonDocument>
#include <QJsonObject>
#include <QDebug>

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

void VehicleBackend::setAutoHold(bool on)
{
    if (m_autoHold != on) {
        m_autoHold = on;
        emit autoHoldChanged();
    }
}

void VehicleBackend::toggleAutoHold()
{
    setAutoHold(!m_autoHold);
}

void VehicleBackend::setValetMode(bool on)
{
    if (m_valetMode != on) {
        m_valetMode = on;
        emit valetModeChanged();
    }
}

void VehicleBackend::toggleValetMode()
{
    setValetMode(!m_valetMode);
}

void VehicleBackend::setAmbientLighting(bool on)
{
    if (m_ambientLighting != on) {
        m_ambientLighting = on;
        emit ambientLightingChanged();
    }
}

void VehicleBackend::toggleAmbientLighting()
{
    setAmbientLighting(!m_ambientLighting);
}

void VehicleBackend::setAmbientColor(const QString &color)
{
    if (m_ambientColor != color) {
        m_ambientColor = color;
        emit ambientColorChanged();
    }
}

void VehicleBackend::setAmbientBrightness(double brightness)
{
    if (qAbs(m_ambientBrightness - brightness) > 0.001) {
        m_ambientBrightness = qBound(0.0, brightness, 1.0);
        emit ambientBrightnessChanged();
    }
}

void VehicleBackend::setTrunkOpen(bool on)
{
    if (m_trunkOpen != on) {
        m_trunkOpen = on;
        emit trunkOpenChanged();
    }
}

void VehicleBackend::toggleTrunk()
{
    setTrunkOpen(!m_trunkOpen);
}

void VehicleBackend::saveVehicleStudioPose(double yaw, double pitch, double cameraZ, double posX, double posY)
{
    QJsonObject obj;
    obj["yaw"] = yaw;
    obj["pitch"] = pitch;
    obj["cameraZ"] = cameraZ;
    obj["posX"] = posX;
    obj["posY"] = posY;

    QJsonDocument doc(obj);
    const QStringList paths = {
        "/Users/reno/Projects/APEX_VISION_IVI/vehicle_studio_pose.json",
        "vehicle_studio_pose.json"
    };
    for (const QString &p : paths) {
        QFile file(p);
        if (file.open(QIODevice::WriteOnly | QIODevice::Truncate)) {
            file.write(doc.toJson());
            file.close();
        }
    }
    qDebug() << "[APEX STUDIO POSE SAVED] yaw:" << yaw << "pitch:" << pitch << "cameraZ:" << cameraZ << "posX:" << posX << "posY:" << posY;
}

QVariantMap VehicleBackend::loadVehicleStudioPose() const
{
    QVariantMap map;
    const QStringList paths = {
        "/Users/reno/Projects/APEX_VISION_IVI/vehicle_studio_pose.json",
        "vehicle_studio_pose.json"
    };
    for (const QString &p : paths) {
        QFile file(p);
        if (file.open(QIODevice::ReadOnly)) {
            QJsonDocument doc = QJsonDocument::fromJson(file.readAll());
            file.close();
            if (doc.isObject()) {
                QJsonObject obj = doc.object();
                map["yaw"] = obj.value("yaw").toDouble(64.0);
                map["pitch"] = obj.value("pitch").toDouble(-5.0);
                map["cameraZ"] = obj.value("cameraZ").toDouble(11.5);
                map["posX"] = obj.value("posX").toDouble(0.0);
                map["posY"] = obj.value("posY").toDouble(0.65);
                return map;
            }
        }
    }
    return map;
}
