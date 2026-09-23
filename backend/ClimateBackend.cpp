#include "ClimateBackend.h"
#include <algorithm>

ClimateBackend::ClimateBackend(QObject *parent)
    : QObject(parent)
{
}

QString ClimateBackend::airflowModeName() const
{
    switch (m_airflowMode) {
    case 0: return QStringLiteral("Face");
    case 1: return QStringLiteral("Face + Feet");
    case 2: return QStringLiteral("Feet");
    case 3: return QStringLiteral("Defrost + Feet");
    default: return QStringLiteral("Face + Feet");
    }
}

QString ClimateBackend::driverTemperatureModeString() const
{
    switch (m_driverTempMode) {
    case TemperatureMode::Off: return QStringLiteral("OFF");
    case TemperatureMode::Lo: return QStringLiteral("LO");
    case TemperatureMode::Normal: return QStringLiteral("NORMAL");
    case TemperatureMode::Hi: return QStringLiteral("HI");
    default: return QStringLiteral("NORMAL");
    }
}

QString ClimateBackend::passengerTemperatureModeString() const
{
    switch (m_passengerTempMode) {
    case TemperatureMode::Off: return QStringLiteral("OFF");
    case TemperatureMode::Lo: return QStringLiteral("LO");
    case TemperatureMode::Normal: return QStringLiteral("NORMAL");
    case TemperatureMode::Hi: return QStringLiteral("HI");
    default: return QStringLiteral("NORMAL");
    }
}

QString ClimateBackend::driverTemperatureDisplay() const
{
    if (!m_driverPower || m_driverTempMode == TemperatureMode::Off) {
        return QStringLiteral("OFF");
    }
    if (m_driverTempMode == TemperatureMode::Lo) {
        return QStringLiteral("LO");
    }
    if (m_driverTempMode == TemperatureMode::Hi) {
        return QStringLiteral("HI");
    }
    return QString::asprintf("%.1f°C", m_driverTemperature);
}

QString ClimateBackend::passengerTemperatureDisplay() const
{
    if (!m_passengerPower || m_passengerTempMode == TemperatureMode::Off) {
        return QStringLiteral("OFF");
    }
    if (m_passengerTempMode == TemperatureMode::Lo) {
        return QStringLiteral("LO");
    }
    if (m_passengerTempMode == TemperatureMode::Hi) {
        return QStringLiteral("HI");
    }
    return QString::asprintf("%.1f°C", m_passengerTemperature);
}

void ClimateBackend::exitMaxPresets()
{
    bool changed = false;
    if (m_maxAcEnabled) {
        m_maxAcEnabled = false;
        emit maxAcEnabledChanged();
        changed = true;
    }
    if (m_maxDefrostEnabled) {
        m_maxDefrostEnabled = false;
        emit maxDefrostEnabledChanged();
        changed = true;
    }
    if (m_preset != ClimatePreset::Normal) {
        m_preset = ClimatePreset::Normal;
        changed = true;
    }
    if (changed) {
        emit presetChanged();
    }
}

void ClimateBackend::syncPassengerToDriver()
{
    m_passengerPower = m_driverPower;
    m_passengerTempMode = m_driverTempMode;
    m_passengerTemperature = m_driverTemperature;
    emit passengerPowerChanged();
    emit passengerTemperatureChanged();
    emit passengerTemperatureModeChanged();
}

void ClimateBackend::increaseDriverTemperature()
{
    exitMaxPresets();

    if (!m_driverPower || m_driverTempMode == TemperatureMode::Off) {
        // OFF -> LO (internal target 15.0°C)
        m_driverPower = true;
        m_driverTempMode = TemperatureMode::Lo;
        m_driverTemperature = 15.0;
        if (m_fanSpeed == 0) {
            m_fanSpeed = (m_savedFanSpeed > 0 ? m_savedFanSpeed : 3);
            emit fanSpeedChanged();
        }
        emit driverPowerChanged();
        emit driverTemperatureChanged();
        emit driverTemperatureModeChanged();

        // Both sides go LO
        m_passengerPower = true;
        m_passengerTempMode = TemperatureMode::Lo;
        m_passengerTemperature = 15.0;
        emit passengerPowerChanged();
        emit passengerTemperatureChanged();
        emit passengerTemperatureModeChanged();
    } else if (m_driverTempMode == TemperatureMode::Lo) {
        // LO -> 16.0°C
        m_driverTempMode = TemperatureMode::Normal;
        m_driverTemperature = 16.0;
        emit driverTemperatureChanged();
        emit driverTemperatureModeChanged();
    } else if (m_driverTempMode == TemperatureMode::Normal) {
        if (m_driverTemperature + 0.5 > 28.0 + 1e-4) {
            // 28.0°C -> HI (internal target 30.0°C)
            m_driverTempMode = TemperatureMode::Hi;
            m_driverTemperature = 30.0;
            emit driverTemperatureChanged();
            emit driverTemperatureModeChanged();

            // Both sides go HI
            m_passengerPower = true;
            m_passengerTempMode = TemperatureMode::Hi;
            m_passengerTemperature = 30.0;
            emit passengerPowerChanged();
            emit passengerTemperatureChanged();
            emit passengerTemperatureModeChanged();
        } else {
            m_driverTemperature += 0.5;
            emit driverTemperatureChanged();
        }
    } else if (m_driverTempMode == TemperatureMode::Hi) {
        // Stay at HI
    }

    if (m_syncMode) {
        syncPassengerToDriver();
    }
}

void ClimateBackend::decreaseDriverTemperature()
{
    exitMaxPresets();

    if (!m_driverPower || m_driverTempMode == TemperatureMode::Off) {
        // Stay at OFF
        return;
    }

    if (m_driverTempMode == TemperatureMode::Hi) {
        // HI -> 28.0°C
        m_driverTempMode = TemperatureMode::Normal;
        m_driverTemperature = 28.0;
        emit driverTemperatureChanged();
        emit driverTemperatureModeChanged();
    } else if (m_driverTempMode == TemperatureMode::Normal) {
        if (m_driverTemperature - 0.5 < 16.0 - 1e-4) {
            // 16.0°C -> LO (internal target 15.0°C)
            m_driverTempMode = TemperatureMode::Lo;
            m_driverTemperature = 15.0;
            emit driverTemperatureChanged();
            emit driverTemperatureModeChanged();

            // Both sides go LO
            m_passengerPower = true;
            m_passengerTempMode = TemperatureMode::Lo;
            m_passengerTemperature = 15.0;
            emit passengerPowerChanged();
            emit passengerTemperatureChanged();
            emit passengerTemperatureModeChanged();
        } else {
            m_driverTemperature -= 0.5;
            emit driverTemperatureChanged();
        }
    } else if (m_driverTempMode == TemperatureMode::Lo) {
        // LO -> OFF
        m_driverTempMode = TemperatureMode::Off;
        m_driverPower = false;
        if (m_fanSpeed > 0) {
            m_savedFanSpeed = m_fanSpeed;
        }
        m_fanSpeed = 0;
        emit fanSpeedChanged();
        if (m_autoMode) {
            m_autoMode = false;
            emit autoModeChanged();
        }
        if (m_acEnabled) {
            m_acEnabled = false;
            emit acEnabledChanged();
        }
        emit driverPowerChanged();
        emit driverTemperatureChanged();
        emit driverTemperatureModeChanged();
    }

    if (m_syncMode) {
        syncPassengerToDriver();
    }
}

void ClimateBackend::increasePassengerTemperature()
{
    if (m_syncMode) {
        setSyncMode(false);
    }
    exitMaxPresets();

    if (!m_passengerPower || m_passengerTempMode == TemperatureMode::Off) {
        // OFF -> LO
        m_passengerPower = true;
        m_passengerTempMode = TemperatureMode::Lo;
        m_passengerTemperature = 15.0;
        if (m_fanSpeed == 0) {
            m_fanSpeed = (m_savedFanSpeed > 0 ? m_savedFanSpeed : 3);
            emit fanSpeedChanged();
        }
        emit passengerPowerChanged();
        emit passengerTemperatureChanged();
        emit passengerTemperatureModeChanged();

        // Both sides go LO
        m_driverPower = true;
        m_driverTempMode = TemperatureMode::Lo;
        m_driverTemperature = 15.0;
        emit driverPowerChanged();
        emit driverTemperatureChanged();
        emit driverTemperatureModeChanged();
    } else if (m_passengerTempMode == TemperatureMode::Lo) {
        // LO -> 16.0°C
        m_passengerTempMode = TemperatureMode::Normal;
        m_passengerTemperature = 16.0;
        emit passengerTemperatureChanged();
        emit passengerTemperatureModeChanged();
    } else if (m_passengerTempMode == TemperatureMode::Normal) {
        if (m_passengerTemperature + 0.5 > 28.0 + 1e-4) {
            // 28.0°C -> HI
            m_passengerTempMode = TemperatureMode::Hi;
            m_passengerTemperature = 30.0;
            emit passengerTemperatureChanged();
            emit passengerTemperatureModeChanged();

            // Both sides go HI
            m_driverPower = true;
            m_driverTempMode = TemperatureMode::Hi;
            m_driverTemperature = 30.0;
            emit driverPowerChanged();
            emit driverTemperatureChanged();
            emit driverTemperatureModeChanged();
        } else {
            m_passengerTemperature += 0.5;
            emit passengerTemperatureChanged();
        }
    } else if (m_passengerTempMode == TemperatureMode::Hi) {
        // Stay at HI
    }
}

void ClimateBackend::decreasePassengerTemperature()
{
    if (m_syncMode) {
        setSyncMode(false);
    }
    exitMaxPresets();

    if (!m_passengerPower || m_passengerTempMode == TemperatureMode::Off) {
        // Stay at OFF
        return;
    }

    if (m_passengerTempMode == TemperatureMode::Hi) {
        // HI -> 28.0°C
        m_passengerTempMode = TemperatureMode::Normal;
        m_passengerTemperature = 28.0;
        emit passengerTemperatureChanged();
        emit passengerTemperatureModeChanged();
    } else if (m_passengerTempMode == TemperatureMode::Normal) {
        if (m_passengerTemperature - 0.5 < 16.0 - 1e-4) {
            // 16.0°C -> LO
            m_passengerTempMode = TemperatureMode::Lo;
            m_passengerTemperature = 15.0;
            emit passengerTemperatureChanged();
            emit passengerTemperatureModeChanged();

            // Both sides go LO
            m_driverPower = true;
            m_driverTempMode = TemperatureMode::Lo;
            m_driverTemperature = 15.0;
            emit driverPowerChanged();
            emit driverTemperatureChanged();
            emit driverTemperatureModeChanged();
        } else {
            m_passengerTemperature -= 0.5;
            emit passengerTemperatureChanged();
        }
    } else if (m_passengerTempMode == TemperatureMode::Lo) {
        // LO -> OFF
        m_passengerTempMode = TemperatureMode::Off;
        m_passengerPower = false;
        emit passengerPowerChanged();
        emit passengerTemperatureChanged();
        emit passengerTemperatureModeChanged();
    }
}

void ClimateBackend::setDriverTemperature(double temp)
{
    exitMaxPresets();

    if (temp <= 15.0 + 1e-4) {
        m_driverTemperature = 15.0;
        m_driverTempMode = TemperatureMode::Lo;
        m_driverPower = true;
        // Both sides go LO
        m_passengerTemperature = 15.0;
        m_passengerTempMode = TemperatureMode::Lo;
        m_passengerPower = true;
        emit passengerPowerChanged();
        emit passengerTemperatureChanged();
        emit passengerTemperatureModeChanged();
    } else if (temp >= 30.0 - 1e-4) {
        m_driverTemperature = 30.0;
        m_driverTempMode = TemperatureMode::Hi;
        m_driverPower = true;
        // Both sides go HI
        m_passengerTemperature = 30.0;
        m_passengerTempMode = TemperatureMode::Hi;
        m_passengerPower = true;
        emit passengerPowerChanged();
        emit passengerTemperatureChanged();
        emit passengerTemperatureModeChanged();
    } else {
        m_driverTemperature = std::clamp(temp, 16.0, 28.0);
        m_driverTempMode = TemperatureMode::Normal;
        m_driverPower = true;
    }
    emit driverPowerChanged();
    emit driverTemperatureChanged();
    emit driverTemperatureModeChanged();

    if (m_syncMode) {
        syncPassengerToDriver();
    }
}

void ClimateBackend::setPassengerTemperature(double temp)
{
    exitMaxPresets();

    if (temp <= 15.0 + 1e-4) {
        m_passengerTemperature = 15.0;
        m_passengerTempMode = TemperatureMode::Lo;
        m_passengerPower = true;
        // Both sides go LO
        m_driverTemperature = 15.0;
        m_driverTempMode = TemperatureMode::Lo;
        m_driverPower = true;
        emit driverPowerChanged();
        emit driverTemperatureChanged();
        emit driverTemperatureModeChanged();
    } else if (temp >= 30.0 - 1e-4) {
        m_passengerTemperature = 30.0;
        m_passengerTempMode = TemperatureMode::Hi;
        m_passengerPower = true;
        // Both sides go HI
        m_driverTemperature = 30.0;
        m_driverTempMode = TemperatureMode::Hi;
        m_driverPower = true;
        emit driverPowerChanged();
        emit driverTemperatureChanged();
        emit driverTemperatureModeChanged();
    } else {
        m_passengerTemperature = std::clamp(temp, 16.0, 28.0);
        m_passengerTempMode = TemperatureMode::Normal;
        m_passengerPower = true;
    }
    emit passengerPowerChanged();
    emit passengerTemperatureChanged();
    emit passengerTemperatureModeChanged();
}

void ClimateBackend::setDriverPower(bool on)
{
    if (on) {
        if (!m_driverPower || m_driverTempMode == TemperatureMode::Off) {
            m_driverPower = true;
            m_driverTempMode = TemperatureMode::Normal;
            if (m_driverTemperature < 16.0 || m_driverTemperature > 28.0) {
                m_driverTemperature = 21.5;
            }
            if (m_fanSpeed == 0) {
                m_fanSpeed = (m_savedFanSpeed > 0 ? m_savedFanSpeed : 3);
                emit fanSpeedChanged();
            }
            m_acEnabled = true;
            emit acEnabledChanged();
            emit driverPowerChanged();
            emit driverTemperatureChanged();
            emit driverTemperatureModeChanged();
        }
    } else {
        if (m_driverPower || m_driverTempMode != TemperatureMode::Off) {
            m_driverPower = false;
            m_driverTempMode = TemperatureMode::Off;
            if (m_fanSpeed > 0) {
                m_savedFanSpeed = m_fanSpeed;
            }
            m_fanSpeed = 0;
            emit fanSpeedChanged();
            if (m_autoMode) {
                m_autoMode = false;
                emit autoModeChanged();
            }
            if (m_acEnabled) {
                m_acEnabled = false;
                emit acEnabledChanged();
            }
            exitMaxPresets();
            emit driverPowerChanged();
            emit driverTemperatureChanged();
            emit driverTemperatureModeChanged();
        }
    }
}

void ClimateBackend::setPassengerPower(bool on)
{
    if (on) {
        if (!m_passengerPower || m_passengerTempMode == TemperatureMode::Off) {
            m_passengerPower = true;
            m_passengerTempMode = TemperatureMode::Normal;
            if (m_passengerTemperature < 16.0 || m_passengerTemperature > 28.0) {
                m_passengerTemperature = 22.0;
            }
            if (m_fanSpeed == 0) {
                m_fanSpeed = (m_savedFanSpeed > 0 ? m_savedFanSpeed : 3);
                emit fanSpeedChanged();
            }
            emit passengerPowerChanged();
            emit passengerTemperatureChanged();
            emit passengerTemperatureModeChanged();
        }
    } else {
        if (m_passengerPower || m_passengerTempMode != TemperatureMode::Off) {
            m_passengerPower = false;
            m_passengerTempMode = TemperatureMode::Off;
            if (m_driverTempMode == TemperatureMode::Off) {
                if (m_fanSpeed > 0) {
                    m_savedFanSpeed = m_fanSpeed;
                }
                m_fanSpeed = 0;
                emit fanSpeedChanged();
                if (m_autoMode) {
                    m_autoMode = false;
                    emit autoModeChanged();
                }
                if (m_acEnabled) {
                    m_acEnabled = false;
                    emit acEnabledChanged();
                }
            }
            emit passengerPowerChanged();
            emit passengerTemperatureChanged();
            emit passengerTemperatureModeChanged();
        }
    }
}

void ClimateBackend::toggleDriverPower()
{
    setDriverPower(!driverPower());
}

void ClimateBackend::togglePassengerPower()
{
    setPassengerPower(!passengerPower());
}

void ClimateBackend::setFanSpeed(int speed)
{
    speed = std::clamp(speed, 0, 7);
    if (m_fanSpeed != speed) {
        m_fanSpeed = speed;
        if (speed > 0) {
            m_savedFanSpeed = speed;
            if (!m_driverPower || m_driverTempMode == TemperatureMode::Off) {
                m_driverPower = true;
                m_driverTempMode = TemperatureMode::Normal;
                emit driverPowerChanged();
                emit driverTemperatureModeChanged();
                emit driverTemperatureChanged();
            }
        }
        emit fanSpeedChanged();
    }
}

void ClimateBackend::increaseFanSpeed()
{
    setFanSpeed(m_fanSpeed + 1);
}

void ClimateBackend::decreaseFanSpeed()
{
    setFanSpeed(m_fanSpeed - 1);
}

void ClimateBackend::setAutoMode(bool enabled)
{
    if (m_autoMode != enabled) {
        m_autoMode = enabled;
        emit autoModeChanged();
    }
}

void ClimateBackend::toggleAuto()
{
    setAutoMode(!m_autoMode);
}

void ClimateBackend::setAcEnabled(bool enabled)
{
    if (m_acEnabled != enabled) {
        m_acEnabled = enabled;
        emit acEnabledChanged();
    }
}

void ClimateBackend::toggleAC()
{
    setAcEnabled(!m_acEnabled);
}

void ClimateBackend::setRecirculation(bool on)
{
    if (m_recirculation != on) {
        m_recirculation = on;
        emit recirculationChanged();
    }
}

void ClimateBackend::toggleRecirculation()
{
    setRecirculation(!m_recirculation);
}

void ClimateBackend::setMaxAcEnabled(bool enabled)
{
    if (m_maxAcEnabled != enabled) {
        m_maxAcEnabled = enabled;
        emit maxAcEnabledChanged();

        if (enabled) {
            // Cancel max defrost if it was on
            if (m_maxDefrostEnabled) {
                m_maxDefrostEnabled = false;
                emit maxDefrostEnabledChanged();
            }
            m_preset = ClimatePreset::MaxAc;

            // Set LO for both driver and passenger
            m_driverPower = true;
            m_driverTempMode = TemperatureMode::Lo;
            m_driverTemperature = 15.0;
            emit driverPowerChanged();
            emit driverTemperatureChanged();
            emit driverTemperatureModeChanged();

            m_passengerPower = true;
            m_passengerTempMode = TemperatureMode::Lo;
            m_passengerTemperature = 15.0;
            emit passengerPowerChanged();
            emit passengerTemperatureChanged();
            emit passengerTemperatureModeChanged();

            setAcEnabled(true);
            setFanSpeed(7); // MAX fan
            setAirflowMode(0); // FACE
            setRecirculation(true);
        } else {
            if (m_preset == ClimatePreset::MaxAc) {
                m_preset = ClimatePreset::Normal;
            }
        }
        emit presetChanged();
    }
}

void ClimateBackend::toggleMaxAC()
{
    setMaxAcEnabled(!m_maxAcEnabled);
}

void ClimateBackend::setMaxDefrostEnabled(bool enabled)
{
    if (m_maxDefrostEnabled != enabled) {
        m_maxDefrostEnabled = enabled;
        emit maxDefrostEnabledChanged();

        if (enabled) {
            // Cancel max ac if it was on
            if (m_maxAcEnabled) {
                m_maxAcEnabled = false;
                emit maxAcEnabledChanged();
            }
            m_preset = ClimatePreset::MaxDefrost;

            // Set HI for both driver and passenger
            m_driverPower = true;
            m_driverTempMode = TemperatureMode::Hi;
            m_driverTemperature = 30.0;
            emit driverPowerChanged();
            emit driverTemperatureChanged();
            emit driverTemperatureModeChanged();

            m_passengerPower = true;
            m_passengerTempMode = TemperatureMode::Hi;
            m_passengerTemperature = 30.0;
            emit passengerPowerChanged();
            emit passengerTemperatureChanged();
            emit passengerTemperatureModeChanged();

            setFanSpeed(7); // MAX fan
            setAirflowMode(3); // DEFROST (+ Feet)
            setFrontDefrost(true);
            setRearDefrost(true);
        } else {
            if (m_preset == ClimatePreset::MaxDefrost) {
                m_preset = ClimatePreset::Normal;
            }
            setFrontDefrost(false);
            setRearDefrost(false);
        }
        emit presetChanged();
    }
}

void ClimateBackend::toggleMaxDefrost()
{
    setMaxDefrostEnabled(!m_maxDefrostEnabled);
}

void ClimateBackend::setFrontDefrost(bool enabled)
{
    if (m_frontDefrost != enabled) {
        m_frontDefrost = enabled;
        emit frontDefrostChanged();
        if (!enabled && m_maxDefrostEnabled) {
            m_maxDefrostEnabled = false;
            emit maxDefrostEnabledChanged();
            if (m_preset == ClimatePreset::MaxDefrost) {
                m_preset = ClimatePreset::Normal;
                emit presetChanged();
            }
        }
    }
}

void ClimateBackend::toggleFrontDefrost()
{
    setFrontDefrost(!m_frontDefrost);
}

void ClimateBackend::setRearDefrost(bool enabled)
{
    if (m_rearDefrost != enabled) {
        m_rearDefrost = enabled;
        emit rearDefrostChanged();
    }
}

void ClimateBackend::toggleRearDefrost()
{
    setRearDefrost(!m_rearDefrost);
}

void ClimateBackend::setDriverSeatLevel(int level)
{
    level = std::clamp(level, 0, 3);
    if (m_driverSeatHeat != level) {
        m_driverSeatHeat = level;
        emit driverSeatHeatChanged();
        if (level > 0 && m_driverSeatVentilation > 0) {
            setDriverSeatVentilation(0);
        }
    }
}

void ClimateBackend::cycleDriverSeatLevel()
{
    setDriverSeatLevel((m_driverSeatHeat + 1) % 4);
}

void ClimateBackend::setPassengerSeatLevel(int level)
{
    level = std::clamp(level, 0, 3);
    if (m_passengerSeatHeat != level) {
        m_passengerSeatHeat = level;
        emit passengerSeatHeatChanged();
        if (level > 0 && m_passengerSeatVentilation > 0) {
            setPassengerSeatVentilation(0);
        }
    }
}

void ClimateBackend::cyclePassengerSeatLevel()
{
    setPassengerSeatLevel((m_passengerSeatHeat + 1) % 4);
}

void ClimateBackend::setDriverSeatVentilation(int level)
{
    level = std::clamp(level, 0, 3);
    if (m_driverSeatVentilation != level) {
        m_driverSeatVentilation = level;
        emit driverSeatVentilationChanged();
        if (level > 0 && m_driverSeatHeat > 0) {
            setDriverSeatLevel(0);
        }
    }
}

void ClimateBackend::cycleDriverSeatVent()
{
    setDriverSeatVentilation((m_driverSeatVentilation + 1) % 4);
}

void ClimateBackend::setPassengerSeatVentilation(int level)
{
    level = std::clamp(level, 0, 3);
    if (m_passengerSeatVentilation != level) {
        m_passengerSeatVentilation = level;
        emit passengerSeatVentilationChanged();
        if (level > 0 && m_passengerSeatHeat > 0) {
            setPassengerSeatLevel(0);
        }
    }
}

void ClimateBackend::cyclePassengerSeatVent()
{
    setPassengerSeatVentilation((m_passengerSeatVentilation + 1) % 4);
}

void ClimateBackend::setSteeringHeat(bool on)
{
    if (m_steeringHeat != on) {
        m_steeringHeat = on;
        emit steeringHeatChanged();
    }
}

void ClimateBackend::toggleSteeringHeat()
{
    setSteeringHeat(!m_steeringHeat);
}

void ClimateBackend::setDriverSeatAuto(bool on)
{
    if (m_driverSeatAuto != on) {
        m_driverSeatAuto = on;
        emit driverSeatAutoChanged();
    }
}

void ClimateBackend::toggleDriverSeatAuto()
{
    setDriverSeatAuto(!m_driverSeatAuto);
}

void ClimateBackend::setPassengerSeatAuto(bool on)
{
    if (m_passengerSeatAuto != on) {
        m_passengerSeatAuto = on;
        emit passengerSeatAutoChanged();
    }
}

void ClimateBackend::togglePassengerSeatAuto()
{
    setPassengerSeatAuto(!m_passengerSeatAuto);
}

void ClimateBackend::setAirflowMode(int mode)
{
    mode = std::clamp(mode, 0, 3);
    if (m_airflowMode != mode) {
        m_airflowMode = mode;
        emit airflowModeChanged();
    }
}

void ClimateBackend::cycleAirflowMode()
{
    setAirflowMode((m_airflowMode + 1) % 4);
}

void ClimateBackend::setSyncMode(bool enabled)
{
    if (m_syncMode != enabled) {
        m_syncMode = enabled;
        emit syncModeChanged();
        if (enabled) {
            syncPassengerToDriver();
        }
    }
}

void ClimateBackend::toggleSyncMode()
{
    setSyncMode(!m_syncMode);
}
