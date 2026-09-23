#pragma once

#include <QObject>
#include <QString>

class ClimateBackend : public QObject
{
    Q_OBJECT

    // Temperature State and Target
    Q_PROPERTY(TemperatureMode driverTemperatureMode READ driverTemperatureMode NOTIFY driverTemperatureModeChanged)
    Q_PROPERTY(TemperatureMode passengerTemperatureMode READ passengerTemperatureMode NOTIFY passengerTemperatureModeChanged)
    Q_PROPERTY(QString driverTemperatureModeString READ driverTemperatureModeString NOTIFY driverTemperatureModeChanged)
    Q_PROPERTY(QString passengerTemperatureModeString READ passengerTemperatureModeString NOTIFY passengerTemperatureModeChanged)

    Q_PROPERTY(double driverTargetTemperature READ driverTargetTemperature WRITE setDriverTemperature NOTIFY driverTemperatureChanged)
    Q_PROPERTY(double passengerTargetTemperature READ passengerTargetTemperature WRITE setPassengerTemperature NOTIFY passengerTemperatureChanged)
    Q_PROPERTY(double driverTemperature READ driverTemperature WRITE setDriverTemperature NOTIFY driverTemperatureChanged)
    Q_PROPERTY(double passengerTemperature READ passengerTemperature WRITE setPassengerTemperature NOTIFY passengerTemperatureChanged)

    Q_PROPERTY(QString driverTemperatureDisplay READ driverTemperatureDisplay NOTIFY driverTemperatureChanged)
    Q_PROPERTY(QString passengerTemperatureDisplay READ passengerTemperatureDisplay NOTIFY passengerTemperatureChanged)

    Q_PROPERTY(bool driverPower READ driverPower WRITE setDriverPower NOTIFY driverPowerChanged)
    Q_PROPERTY(bool passengerPower READ passengerPower WRITE setPassengerPower NOTIFY passengerPowerChanged)

    // Presets & Modes
    Q_PROPERTY(ClimatePreset climatePreset READ climatePreset NOTIFY presetChanged)
    Q_PROPERTY(bool maxAcEnabled READ maxAcEnabled WRITE setMaxAcEnabled NOTIFY maxAcEnabledChanged)
    Q_PROPERTY(bool maxDefrostEnabled READ maxDefrostEnabled WRITE setMaxDefrostEnabled NOTIFY maxDefrostEnabledChanged)

    // Fan Controls
    Q_PROPERTY(int fanSpeed READ fanSpeed WRITE setFanSpeed NOTIFY fanSpeedChanged)
    Q_PROPERTY(bool fanAuto READ fanAuto WRITE setAutoMode NOTIFY autoModeChanged)
    Q_PROPERTY(bool autoMode READ autoMode WRITE setAutoMode NOTIFY autoModeChanged)

    // Airflow & AC
    Q_PROPERTY(bool acEnabled READ acEnabled WRITE setAcEnabled NOTIFY acEnabledChanged)
    Q_PROPERTY(bool recirculation READ recirculation WRITE setRecirculation NOTIFY recirculationChanged)
    Q_PROPERTY(int airflowMode READ airflowMode WRITE setAirflowMode NOTIFY airflowModeChanged)
    Q_PROPERTY(QString airflowModeName READ airflowModeName NOTIFY airflowModeChanged)

    // Defrost
    Q_PROPERTY(bool frontDefrost READ frontDefrost WRITE setFrontDefrost NOTIFY frontDefrostChanged)
    Q_PROPERTY(bool frontDefrostEnabled READ frontDefrost WRITE setFrontDefrost NOTIFY frontDefrostChanged)
    Q_PROPERTY(bool rearDefrost READ rearDefrost WRITE setRearDefrost NOTIFY rearDefrostChanged)
    Q_PROPERTY(bool rearDefrostEnabled READ rearDefrost WRITE setRearDefrost NOTIFY rearDefrostChanged)

    // Seats & Steering
    Q_PROPERTY(int driverSeatLevel READ driverSeatLevel WRITE setDriverSeatLevel NOTIFY driverSeatHeatChanged)
    Q_PROPERTY(int passengerSeatLevel READ passengerSeatLevel WRITE setPassengerSeatLevel NOTIFY passengerSeatHeatChanged)
    Q_PROPERTY(int driverSeatHeat READ driverSeatLevel WRITE setDriverSeatLevel NOTIFY driverSeatHeatChanged)
    Q_PROPERTY(int passengerSeatHeat READ passengerSeatLevel WRITE setPassengerSeatLevel NOTIFY passengerSeatHeatChanged)
    Q_PROPERTY(int driverSeatVentilation READ driverSeatVentilation WRITE setDriverSeatVentilation NOTIFY driverSeatVentilationChanged)
    Q_PROPERTY(int passengerSeatVentilation READ passengerSeatVentilation WRITE setPassengerSeatVentilation NOTIFY passengerSeatVentilationChanged)
    Q_PROPERTY(bool steeringHeat READ steeringHeat WRITE setSteeringHeat NOTIFY steeringHeatChanged)
    Q_PROPERTY(bool driverSeatAuto READ driverSeatAuto WRITE setDriverSeatAuto NOTIFY driverSeatAutoChanged)
    Q_PROPERTY(bool passengerSeatAuto READ passengerSeatAuto WRITE setPassengerSeatAuto NOTIFY passengerSeatAutoChanged)

    Q_PROPERTY(bool syncMode READ syncMode WRITE setSyncMode NOTIFY syncModeChanged)

public:
    enum class TemperatureMode {
        Off = 0,
        Lo = 1,
        Normal = 2,
        Hi = 3
    };
    Q_ENUM(TemperatureMode)

    enum class ClimatePreset {
        Normal = 0,
        MaxAc = 1,
        MaxDefrost = 2
    };
    Q_ENUM(ClimatePreset)

    explicit ClimateBackend(QObject *parent = nullptr);

    // Temperature State Getters
    TemperatureMode driverTemperatureMode() const { return m_driverTempMode; }
    TemperatureMode passengerTemperatureMode() const { return m_passengerTempMode; }
    QString driverTemperatureModeString() const;
    QString passengerTemperatureModeString() const;

    double driverTemperature() const { return m_driverTemperature; }
    double driverTargetTemperature() const { return m_driverTemperature; }
    double passengerTemperature() const { return m_passengerTemperature; }
    double passengerTargetTemperature() const { return m_passengerTemperature; }

    QString driverTemperatureDisplay() const;
    QString passengerTemperatureDisplay() const;

    bool driverPower() const { return m_driverPower && m_driverTempMode != TemperatureMode::Off; }
    bool passengerPower() const { return m_passengerPower && m_passengerTempMode != TemperatureMode::Off; }

    ClimatePreset climatePreset() const { return m_preset; }
    bool maxAcEnabled() const { return m_maxAcEnabled; }
    bool maxDefrostEnabled() const { return m_maxDefrostEnabled; }
    int fanSpeed() const { return m_fanSpeed; }
    bool fanAuto() const { return m_autoMode; }
    bool autoMode() const { return m_autoMode; }
    bool acEnabled() const { return m_acEnabled; }
    bool recirculation() const { return m_recirculation; }
    int airflowMode() const { return m_airflowMode; }
    QString airflowModeName() const;

    bool frontDefrost() const { return m_frontDefrost; }
    bool frontDefrostEnabled() const { return m_frontDefrost; }
    bool rearDefrost() const { return m_rearDefrost; }
    bool rearDefrostEnabled() const { return m_rearDefrost; }

    int driverSeatLevel() const { return m_driverSeatHeat; }
    int passengerSeatLevel() const { return m_passengerSeatHeat; }
    int driverSeatVentilation() const { return m_driverSeatVentilation; }
    int passengerSeatVentilation() const { return m_passengerSeatVentilation; }
    bool steeringHeat() const { return m_steeringHeat; }
    bool driverSeatAuto() const { return m_driverSeatAuto; }
    bool passengerSeatAuto() const { return m_passengerSeatAuto; }
    bool syncMode() const { return m_syncMode; }

    // Temperature Controls (Arrow Step & Explicit Set)
    Q_INVOKABLE void increaseDriverTemperature();
    Q_INVOKABLE void decreaseDriverTemperature();
    Q_INVOKABLE void increasePassengerTemperature();
    Q_INVOKABLE void decreasePassengerTemperature();

    Q_INVOKABLE void increaseDriverTemp() { increaseDriverTemperature(); }
    Q_INVOKABLE void decreaseDriverTemp() { decreaseDriverTemperature(); }
    Q_INVOKABLE void increasePassengerTemp() { increasePassengerTemperature(); }
    Q_INVOKABLE void decreasePassengerTemp() { decreasePassengerTemperature(); }

    Q_INVOKABLE void setDriverTemperature(double temp);
    Q_INVOKABLE void setPassengerTemperature(double temp);

    Q_INVOKABLE void setDriverPower(bool on);
    Q_INVOKABLE void setPassengerPower(bool on);
    Q_INVOKABLE void toggleDriverPower();
    Q_INVOKABLE void togglePassengerPower();

    // Fan Controls (0 to 7)
    Q_INVOKABLE void setFanSpeed(int speed);
    Q_INVOKABLE void increaseFanSpeed();
    Q_INVOKABLE void decreaseFanSpeed();

    // Modes & Toggles
    Q_INVOKABLE void setAutoMode(bool enabled);
    Q_INVOKABLE void toggleAuto();
    Q_INVOKABLE void toggleAutoMode() { toggleAuto(); }

    Q_INVOKABLE void setAcEnabled(bool enabled);
    Q_INVOKABLE void toggleAC();
    Q_INVOKABLE void toggleAc() { toggleAC(); }

    Q_INVOKABLE void setRecirculation(bool on);
    Q_INVOKABLE void toggleRecirculation();

    // Presets
    Q_INVOKABLE void setMaxAcEnabled(bool enabled);
    Q_INVOKABLE void toggleMaxAC();
    Q_INVOKABLE void toggleMaxAc() { toggleMaxAC(); }

    Q_INVOKABLE void setMaxDefrostEnabled(bool enabled);
    Q_INVOKABLE void toggleMaxDefrost();

    Q_INVOKABLE void setFrontDefrost(bool enabled);
    Q_INVOKABLE void toggleFrontDefrost();

    Q_INVOKABLE void setRearDefrost(bool enabled);
    Q_INVOKABLE void toggleRearDefrost();

    // Seat Comfort
    Q_INVOKABLE void setDriverSeatLevel(int level);
    Q_INVOKABLE void cycleDriverSeatLevel();
    Q_INVOKABLE void setDriverSeatHeat(int level) { setDriverSeatLevel(level); }
    Q_INVOKABLE void cycleDriverSeatHeat() { cycleDriverSeatLevel(); }

    Q_INVOKABLE void setPassengerSeatLevel(int level);
    Q_INVOKABLE void cyclePassengerSeatLevel();
    Q_INVOKABLE void setPassengerSeatHeat(int level) { setPassengerSeatLevel(level); }
    Q_INVOKABLE void cyclePassengerSeatHeat() { cyclePassengerSeatLevel(); }

    Q_INVOKABLE void setDriverSeatVentilation(int level);
    Q_INVOKABLE void cycleDriverSeatVent();
    Q_INVOKABLE void setPassengerSeatVentilation(int level);
    Q_INVOKABLE void cyclePassengerSeatVent();

    Q_INVOKABLE void setSteeringHeat(bool on);
    Q_INVOKABLE void toggleSteeringHeat();

    Q_INVOKABLE void setDriverSeatAuto(bool on);
    Q_INVOKABLE void toggleDriverSeatAuto();
    Q_INVOKABLE void setPassengerSeatAuto(bool on);
    Q_INVOKABLE void togglePassengerSeatAuto();

    // Airflow
    Q_INVOKABLE void setAirflowMode(int mode);
    Q_INVOKABLE void cycleAirflowMode();

    Q_INVOKABLE void setSyncMode(bool enabled);
    Q_INVOKABLE void toggleSyncMode();

signals:
    void driverTemperatureChanged();
    void passengerTemperatureChanged();
    void driverTemperatureModeChanged();
    void passengerTemperatureModeChanged();
    void driverPowerChanged();
    void passengerPowerChanged();
    void fanSpeedChanged();
    void autoModeChanged();
    void acEnabledChanged();
    void recirculationChanged();
    void maxAcEnabledChanged();
    void maxDefrostEnabledChanged();
    void presetChanged();
    void frontDefrostChanged();
    void rearDefrostChanged();
    void driverSeatHeatChanged();
    void passengerSeatHeatChanged();
    void driverSeatVentilationChanged();
    void passengerSeatVentilationChanged();
    void steeringHeatChanged();
    void driverSeatAutoChanged();
    void passengerSeatAutoChanged();
    void airflowModeChanged();
    void syncModeChanged();

private:
    void exitMaxPresets();
    void syncPassengerToDriver();

    TemperatureMode m_driverTempMode{TemperatureMode::Normal};
    TemperatureMode m_passengerTempMode{TemperatureMode::Normal};
    double m_driverTemperature{21.5};
    double m_passengerTemperature{22.0};
    bool m_driverPower{true};
    bool m_passengerPower{true};
    int m_fanSpeed{3};
    int m_savedFanSpeed{3};
    bool m_autoMode{true};
    bool m_acEnabled{true};
    bool m_recirculation{false};
    bool m_maxAcEnabled{false};
    bool m_maxDefrostEnabled{false};
    bool m_frontDefrost{false};
    bool m_rearDefrost{false};
    ClimatePreset m_preset{ClimatePreset::Normal};

    int m_driverSeatHeat{1};
    int m_passengerSeatHeat{0};
    int m_driverSeatVentilation{0};
    int m_passengerSeatVentilation{0};
    bool m_steeringHeat{false};
    bool m_driverSeatAuto{false};
    bool m_passengerSeatAuto{false};
    int m_airflowMode{1}; // 0: Face, 1: Face + Feet, 2: Feet, 3: Defrost + Feet
    bool m_syncMode{false};
};
