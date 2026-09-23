#pragma once

#include <QObject>

class VehicleSimulator;

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

public:
    explicit VehicleBackend(VehicleSimulator *simulator, QObject *parent = nullptr);

    int vehicleSpeed() const { return m_vehicleSpeed; }
    int engineRpm() const { return m_engineRpm; }
    QString gear() const { return m_gear; }
    QString driveMode() const { return m_driveMode; }
    double outsideTemperature() const { return m_outsideTemperature; }
    int batteryLevel() const { return m_batteryLevel; }
    double tripDistance() const { return m_tripDistance; }
    bool headlights() const { return m_headlights; }

    Q_INVOKABLE void setGear(const QString &gear);
    Q_INVOKABLE void setDriveMode(const QString &mode);
    Q_INVOKABLE void cycleDriveMode();
    Q_INVOKABLE void setHeadlights(bool on);

signals:
    void vehicleSpeedChanged();
    void engineRpmChanged();
    void gearChanged();
    void driveModeChanged();
    void outsideTemperatureChanged();
    void batteryLevelChanged();
    void tripDistanceChanged();
    void headlightsChanged();

private slots:
    void onTelemetryUpdated(double speed, double rpm, const QString &gear, double temp, int battery);

private:
    int m_vehicleSpeed{68};
    int m_engineRpm{1900};
    QString m_gear{"D"};
    QString m_driveMode{"COMFORT"};
    double m_outsideTemperature{21.5};
    int m_batteryLevel{88};
    double m_tripDistance{142.6};
    bool m_headlights{true};
};
