/**
 * ==============================================================================
 * Project: Apex VISION IVI - Digital Cockpit & Infotainment System
 * File: RejuvenateController.cpp
 * Author / Developer: Sk Rehan Ahamed
 * License: MIT
 * ==============================================================================
 */

#include "RejuvenateController.h"
#include "RejuvenateTheme.h"
#include "ClimateBackend.h"
#include "AmbientLightBackend.h"
#include "SeatBackend.h"
#include "VehicleBackend.h"

#include <QDir>
#include <QCoreApplication>
#include <QDebug>
#include <QtMath>

RejuvenateController::RejuvenateController(ClimateBackend *climate,
                                           AmbientLightBackend *ambient,
                                           SeatBackend *seat,
                                           VehicleBackend *vehicle,
                                           QObject *parent)
    : QObject(parent)
    , m_climate(climate)
    , m_ambient(ambient)
    , m_seat(seat)
    , m_vehicle(vehicle)
{
    m_sessionTimer.setInterval(1000);
    connect(&m_sessionTimer, &QTimer::timeout, this, &RejuvenateController::onTickSecond);

    m_fadeTimer.setInterval(40);
    connect(&m_fadeTimer, &QTimer::timeout, this, &RejuvenateController::onFadeStep);

    // Test bench mode: drive simulation checks disabled
    m_vehicleStationary = true;
    m_vehicleMoving = false;

    reloadThemes();
}

RejuvenateController::~RejuvenateController()
{
    if (m_sessionTimer.isActive()) {
        m_sessionTimer.stop();
    }
    if (m_fadeTimer.isActive()) {
        m_fadeTimer.stop();
    }
}

QString RejuvenateController::stateString() const
{
    switch (m_state) {
    case Idle: return "Idle";
    case Preparing: return "Preparing";
    case Active: return "Active";
    case Paused: return "Paused";
    case Cooldown: return "Cooldown";
    case Completed: return "Completed";
    case Cancelled: return "Cancelled";
    }
    return "Idle";
}

double RejuvenateController::progress() const
{
    if (m_totalSeconds <= 0) return 0.0;
    double elapsed = static_cast<double>(m_totalSeconds - m_remainingSeconds);
    return qBound(0.0, elapsed / m_totalSeconds, 1.0);
}

QString RejuvenateController::formattedRemaining() const
{
    int mins = m_remainingSeconds / 60;
    int secs = m_remainingSeconds % 60;
    return QString("%1:%2")
        .arg(mins, 2, 10, QChar('0'))
        .arg(secs, 2, 10, QChar('0'));
}

QVariantList RejuvenateController::themes() const
{
    QVariantList list;
    for (const auto &th : m_themeList) {
        if (th) {
            list.append(th->toMap());
        }
    }
    return list;
}

void RejuvenateController::setSelectedThemeIndex(int index)
{
    if (index >= 0 && index < m_themeList.size() && index != m_selectedThemeIndex) {
        m_selectedThemeIndex = index;
        emit selectedThemeChanged();
        emit videoSourceChanged();
        emit audioSourceChanged();
    }
}

QVariantMap RejuvenateController::currentTheme() const
{
    if (m_selectedThemeIndex >= 0 && m_selectedThemeIndex < m_themeList.size()) {
        return m_themeList[m_selectedThemeIndex]->toMap();
    }
    return QVariantMap();
}

QString RejuvenateController::themeName() const
{
    if (m_selectedThemeIndex >= 0 && m_selectedThemeIndex < m_themeList.size()) {
        return m_themeList[m_selectedThemeIndex]->name();
    }
    return QString();
}

QUrl RejuvenateController::videoSource() const
{
    if (m_selectedThemeIndex >= 0 && m_selectedThemeIndex < m_themeList.size()) {
        return m_themeList[m_selectedThemeIndex]->videoUrl();
    }
    return QUrl();
}

QUrl RejuvenateController::audioSource() const
{
    if (m_selectedThemeIndex >= 0 && m_selectedThemeIndex < m_themeList.size()) {
        return m_themeList[m_selectedThemeIndex]->audioUrl();
    }
    return QUrl();
}

void RejuvenateController::setVehicleStationary(bool stationary)
{
    if (m_vehicleStationary != stationary) {
        m_vehicleStationary = stationary;
        m_vehicleMoving = !stationary;
        emit vehicleStationaryChanged();
        emit vehicleMovingChanged();
        if (!stationary && (active() || m_state == Paused)) {
            simulateDriveMotion(true);
        }
    }
}

void RejuvenateController::setVehicleMoving(bool moving)
{
    if (m_vehicleMoving != moving) {
        m_vehicleMoving = moving;
        m_vehicleStationary = !moving;
        emit vehicleMovingChanged();
        emit vehicleStationaryChanged();
        if (moving && (active() || m_state == Paused)) {
            simulateDriveMotion(true);
        }
    }
}

void RejuvenateController::setParkingBrakeApplied(bool applied)
{
    if (m_parkingBrakeApplied != applied) {
        m_parkingBrakeApplied = applied;
        emit parkingBrakeAppliedChanged();
    }
}

void RejuvenateController::setIgnitionState(const QString &state)
{
    if (m_ignitionState != state) {
        m_ignitionState = state;
        emit ignitionStateChanged();
    }
}

void RejuvenateController::selectTheme(int index)
{
    setSelectedThemeIndex(index);
}

bool RejuvenateController::startSession(int durationSeconds)
{
    if (m_themeList.isEmpty()) {
        qWarning() << "[RejuvenateController] No themes available";
        return false;
    }

    auto theme = m_themeList.value(m_selectedThemeIndex);
    if (!theme) return false;

    // 1. Capture current vehicle settings before session changes them
    capturePreviousVehicleState();

    // 2. Setup session timer
    if (durationSeconds > 0) {
        m_totalSeconds = durationSeconds;
    } else {
        m_totalSeconds = theme->duration() > 0 ? theme->duration() : 600;
    }
    m_remainingSeconds = m_totalSeconds;
    emit totalSecondsChanged();
    emit remainingSecondsChanged();
    emit progressChanged();

    // 3. Transition IDLE -> PREPARING
    setState(Preparing);
    updatePhase();

    // 4. Begin smooth 3-second AV fade in
    m_videoOpacity = 0.0;
    m_audioVolume = 0.0;
    emit videoOpacityChanged();
    emit audioVolumeChanged();
    startFade(1.0, 1.0, 3000);

    // 5. Apply targets to backends (Climate, Ambient Lighting, Seat)
    applyThemeTargets();

    // 6. Start the session countdown ticker
    m_sessionTimer.start();

    qInfo() << "[RejuvenateController] Started session for theme:" << theme->name()
            << "Duration:" << m_totalSeconds << "s";
    return true;
}

void RejuvenateController::pauseSession()
{
    if (m_state == Active || m_state == Preparing) {
        setState(Paused);
        m_sessionTimer.stop();
        if (m_seat) {
            m_seat->stopMassage();
        }
        // Lower audio during pause
        startFade(0.15, m_videoOpacity, 800);
        qInfo() << "[RejuvenateController] Session paused";
    }
}

void RejuvenateController::resumeSession()
{
    if (m_state == Paused) {
        setState(Active);
        updatePhase();
        m_sessionTimer.start();

        // Restore massage
        auto theme = m_themeList.value(m_selectedThemeIndex);
        if (theme && m_seat) {
            m_seat->startMassage(theme->massageLevel(), "Wave");
        }
        // Resume full audio
        startFade(1.0, 1.0, 1000);
        qInfo() << "[RejuvenateController] Session resumed";
    }
}

void RejuvenateController::endSession(bool confirmed)
{
    Q_UNUSED(confirmed);
    if (m_state == Idle) return;

    m_sessionTimer.stop();
    startFade(0.0, 0.0, 1200);

    if (m_seat) {
        m_seat->stopMassage();
    }

    restorePreviousVehicleState();
    setState(Cancelled);

    QTimer::singleShot(1300, this, [this]() {
        setState(Idle);
    });

    qInfo() << "[RejuvenateController] Session ended by user";
}

void RejuvenateController::dismissSafetyAlert()
{
    if (m_safetyAlert) {
        m_safetyAlert = false;
        m_safetyAlertMessage.clear();
        emit safetyAlertChanged();
    }
}

void RejuvenateController::reloadThemes()
{
    m_themeList.clear();

    QStringList candidateDirs = {
        QDir::currentPath() + "/assets/rejuvenate/themes",
        QCoreApplication::applicationDirPath() + "/assets/rejuvenate/themes",
        QCoreApplication::applicationDirPath() + "/../assets/rejuvenate/themes",
        "/Users/reno/Projects/APEX_VISION_IVI/assets/rejuvenate/themes"
    };

    QString foundDir;
    for (const auto &dirPath : candidateDirs) {
        QDir dir(dirPath);
        if (dir.exists()) {
            foundDir = dirPath;
            break;
        }
    }

    if (!foundDir.isEmpty()) {
        QDir dir(foundDir);
        QStringList filters;
        filters << "*.json";
        QFileInfoList files = dir.entryInfoList(filters, QDir::Files, QDir::Name);
        for (const auto &fi : files) {
            auto theme = RejuvenateTheme::loadFromFile(fi.absoluteFilePath());
            if (theme) {
                m_themeList.append(theme);
            }
        }
    }

    // Fallback if none found
    if (m_themeList.isEmpty()) {
        qWarning() << "[RejuvenateController] Themes dir not found, using internal defaults";
        m_themeList.append(std::make_shared<RejuvenateTheme>(
            "aurora", "Aurora", "Calm your mind with soothing lights and sounds",
            QUrl("qrc:/assets/rejuvenate/video/aurora.mp4"),
            QUrl("qrc:/assets/rejuvenate/audio/aurora.mp3"),
            QUrl(), 600, 22.0, "AUTO", true, "#24D9FF", 80, "Relax", 2
        ));
    }

    if (m_selectedThemeIndex >= m_themeList.size()) {
        m_selectedThemeIndex = 0;
    }

    emit themesChanged();
    emit selectedThemeChanged();
    emit videoSourceChanged();
    emit audioSourceChanged();
    qInfo() << "[RejuvenateController] Loaded" << m_themeList.size() << "themes.";
}

void RejuvenateController::simulateDriveMotion(bool moving)
{
    m_overrideMotion = true;
    m_vehicleMoving = moving;
    m_vehicleStationary = !moving;
    emit vehicleMovingChanged();
    emit vehicleStationaryChanged();

    if (moving) {
        qWarning() << "[RejuvenateController] CRITICAL: Vehicle motion detected!";
        if (m_state == Active || m_state == Preparing || m_state == Cooldown || m_state == Paused) {
            m_sessionTimer.stop();
            if (m_seat) {
                m_seat->stopMassage();
            }
            startFade(0.0, 0.0, 500);
            restorePreviousVehicleState();
            setState(Cancelled);

            m_safetyAlert = true;
            m_safetyAlertMessage = "Rejuvenate paused while driving.";
            emit safetyAlertChanged();
        }
    }
}

void RejuvenateController::simulateParkingBrake(bool applied)
{
    m_parkingBrakeApplied = applied;
    emit parkingBrakeAppliedChanged();
    if (!applied && (m_state == Active || m_state == Preparing)) {
        simulateDriveMotion(true);
    }
}

void RejuvenateController::setState(SessionState newState)
{
    if (m_state != newState) {
        m_state = newState;
        emit stateChanged();
        emit activeChanged();
        emit pausedChanged();
        qInfo() << "[RejuvenateController] State transition ->" << stateString();
    }
}

void RejuvenateController::updatePhase()
{
    int elapsed = m_totalSeconds - m_remainingSeconds;
    QString newPhase;

    if (elapsed < 30) {
        newPhase = "Preparing";
    } else if (elapsed < 120) {
        newPhase = "Settling";
    } else if (m_remainingSeconds > 150) {
        newPhase = "Immersion";
    } else if (m_remainingSeconds > 60) {
        newPhase = "Calming";
    } else if (m_remainingSeconds > 0) {
        newPhase = "Cooldown";
    } else {
        newPhase = "Complete";
    }

    if (m_phaseName != newPhase) {
        m_phaseName = newPhase;
        emit phaseChanged();
        qInfo() << "[RejuvenateController] Timeline Phase ->" << m_phaseName;

        // Active immersion adjustment based on phase:
        if (m_phaseName == "Immersion" && m_state == Preparing) {
            setState(Active);
        } else if (m_phaseName == "Calming") {
            // Calm down audio slightly to 75%
            startFade(0.75, 1.0, 3000);
            if (m_ambient) {
                m_ambient->setBrightness(m_ambient->brightness() * 0.75);
            }
        } else if (m_phaseName == "Cooldown" && m_state != Cooldown) {
            setState(Cooldown);
            startFade(0.15, 0.5, 4000);
            if (m_seat) {
                m_seat->stopMassage();
            }
        }
    }
}

void RejuvenateController::capturePreviousVehicleState()
{
    m_savedState.saved = true;

    if (m_climate) {
        m_savedState.driverTemp = m_climate->driverTargetTemperature();
        m_savedState.passengerTemp = m_climate->passengerTargetTemperature();
        m_savedState.fanSpeed = m_climate->fanSpeed();
        m_savedState.autoMode = m_climate->autoMode();
        m_savedState.acEnabled = m_climate->acEnabled();
        m_savedState.recirculation = m_climate->recirculation();
    }

    if (m_ambient) {
        m_savedState.ambientColor = m_ambient->color();
        m_savedState.ambientBrightness = m_ambient->brightness();
    }

    if (m_seat) {
        m_savedState.seatPosition = m_seat->position();
        m_savedState.seatRecline = m_seat->reclineAngle();
        m_savedState.massageLevel = m_seat->massageLevel();
        m_savedState.massageMode = m_seat->massageMode();
    }

    qInfo() << "[RejuvenateController] Captured baseline vehicle state:"
            << "Temp:" << m_savedState.driverTemp << "C, Ambient:" << m_savedState.ambientColor
            << "Seat:" << m_savedState.seatPosition << "(" << m_savedState.seatRecline << "deg)";
}

void RejuvenateController::restorePreviousVehicleState()
{
    if (!m_savedState.saved) return;

    qInfo() << "[RejuvenateController] Restoring previous vehicle settings...";

    if (m_climate) {
        m_climate->setDriverTemperature(m_savedState.driverTemp);
        m_climate->setPassengerTemperature(m_savedState.passengerTemp);
        m_climate->setFanSpeed(m_savedState.fanSpeed);
        m_climate->setAutoMode(m_savedState.autoMode);
        m_climate->setAcEnabled(m_savedState.acEnabled);
        m_climate->setRecirculation(m_savedState.recirculation);
    }

    if (m_ambient) {
        m_ambient->fadeTo(m_savedState.ambientColor, m_savedState.ambientBrightness, 2500);
    }

    if (m_seat) {
        m_seat->stopMassage();
        m_seat->restorePreviousPosition(m_savedState.seatPosition, m_savedState.seatRecline);
    }

    m_savedState.saved = false;
}

void RejuvenateController::applyThemeTargets()
{
    auto theme = m_themeList.value(m_selectedThemeIndex);
    if (!theme) return;

    if (m_climate) {
        m_climate->setDriverTemperature(theme->climateTemp());
        m_climate->setPassengerTemperature(theme->climateTemp());
        m_climate->setAcEnabled(theme->climateAc());
        if (theme->climateFanMode().toUpper() == "AUTO") {
            m_climate->setAutoMode(true);
        }
    }

    if (m_ambient) {
        m_ambient->fadeTo(theme->ambientColor(), theme->ambientBrightness(), 3000);
    }

    if (m_seat) {
        m_seat->moveToRelaxPosition();
        m_seat->startMassage(theme->massageLevel(), "Wave");
    }
}

void RejuvenateController::startFade(double targetAudio, double targetVideo, int durationMs)
{
    m_targetAudioVolume = qBound(0.0, targetAudio, 1.0);
    m_targetVideoOpacity = qBound(0.0, targetVideo, 1.0);

    int steps = qMax(1, durationMs / 40);
    m_audioStep = (m_targetAudioVolume - m_audioVolume) / steps;
    m_videoStep = (m_targetVideoOpacity - m_videoOpacity) / steps;

    if (!m_fadeTimer.isActive()) {
        m_fadeTimer.start();
    }
}

void RejuvenateController::onFadeStep()
{
    bool audioDone = false;
    bool videoDone = false;

    // Advance audio volume
    m_audioVolume += m_audioStep;
    if ((m_audioStep >= 0.0 && m_audioVolume >= m_targetAudioVolume) ||
        (m_audioStep <= 0.0 && m_audioVolume <= m_targetAudioVolume)) {
        m_audioVolume = m_targetAudioVolume;
        audioDone = true;
    }
    emit audioVolumeChanged();

    // Advance video opacity
    m_videoOpacity += m_videoStep;
    if ((m_videoStep >= 0.0 && m_videoOpacity >= m_targetVideoOpacity) ||
        (m_videoStep <= 0.0 && m_videoOpacity <= m_targetVideoOpacity)) {
        m_videoOpacity = m_targetVideoOpacity;
        videoDone = true;
    }
    emit videoOpacityChanged();

    if (audioDone && videoDone) {
        m_fadeTimer.stop();
    }
}

void RejuvenateController::onTickSecond()
{
    if (m_remainingSeconds > 0) {
        m_remainingSeconds--;
        emit remainingSecondsChanged();
        emit progressChanged();

        // 3 seconds in, switch from Preparing to Active
        int elapsed = m_totalSeconds - m_remainingSeconds;
        if (m_state == Preparing && elapsed >= 3) {
            setState(Active);
        }

        updatePhase();

        if (m_remainingSeconds == 0) {
            m_sessionTimer.stop();
            setState(Completed);
            m_phaseName = "Complete";
            emit phaseChanged();

            startFade(0.0, 0.0, 2000);
            if (m_seat) {
                m_seat->stopMassage();
            }
            restorePreviousVehicleState();
            qInfo() << "[RejuvenateController] 10-Minute Rejuvenate session completed!";
        }
    }
}
