/**
 * ==============================================================================
 * Project: Apex VISION IVI - Digital Cockpit & Infotainment System
 * File: RejuvenateController.h
 * Author / Developer: Sk Rehan Ahamed
 * License: MIT
 * ==============================================================================
 */

#pragma once

#include <QObject>
#include <QString>
#include <QUrl>
#include <QTimer>
#include <QVariantList>
#include <QVariantMap>
#include <memory>

class ClimateBackend;
class AmbientLightBackend;
class SeatBackend;
class VehicleBackend;
class MediaBackend;
class RejuvenateTheme;
class QMediaPlayer;
class QAudioOutput;

class RejuvenateController : public QObject
{
    Q_OBJECT

public:
    enum SessionState {
        Idle = 0,
        Preparing,
        Active,
        Paused,
        Cooldown,
        Completed,
        Cancelled
    };
    Q_ENUM(SessionState)

    // State & Phase properties
    Q_PROPERTY(SessionState state READ state NOTIFY stateChanged)
    Q_PROPERTY(QString stateString READ stateString NOTIFY stateChanged)
    Q_PROPERTY(QString phaseName READ phaseName NOTIFY phaseChanged)
    Q_PROPERTY(bool active READ active NOTIFY activeChanged)
    Q_PROPERTY(bool paused READ paused NOTIFY pausedChanged)
    Q_PROPERTY(bool isPreparing READ isPreparing NOTIFY stateChanged)
    Q_PROPERTY(bool isCompleted READ isCompleted NOTIFY stateChanged)

    // Timer & Progress properties
    Q_PROPERTY(int remainingSeconds READ remainingSeconds NOTIFY remainingSecondsChanged)
    Q_PROPERTY(int totalSeconds READ totalSeconds NOTIFY totalSecondsChanged)
    Q_PROPERTY(double progress READ progress NOTIFY progressChanged)
    Q_PROPERTY(QString formattedRemaining READ formattedRemaining NOTIFY remainingSecondsChanged)

    // Theme properties
    Q_PROPERTY(QVariantList themes READ themes NOTIFY themesChanged)
    Q_PROPERTY(int selectedThemeIndex READ selectedThemeIndex WRITE setSelectedThemeIndex NOTIFY selectedThemeChanged)
    Q_PROPERTY(QVariantMap currentTheme READ currentTheme NOTIFY selectedThemeChanged)
    Q_PROPERTY(QString themeName READ themeName NOTIFY selectedThemeChanged)
    Q_PROPERTY(QUrl videoSource READ videoSource NOTIFY videoSourceChanged)
    Q_PROPERTY(QUrl audioSource READ audioSource NOTIFY audioSourceChanged)

    // AV Transitions
    Q_PROPERTY(double audioVolume READ audioVolume NOTIFY audioVolumeChanged)
    Q_PROPERTY(double videoOpacity READ videoOpacity NOTIFY videoOpacityChanged)

    // Safety Interlock properties
    Q_PROPERTY(bool vehicleStationary READ vehicleStationary WRITE setVehicleStationary NOTIFY vehicleStationaryChanged)
    Q_PROPERTY(bool vehicleMoving READ vehicleMoving WRITE setVehicleMoving NOTIFY vehicleMovingChanged)
    Q_PROPERTY(bool parkingBrakeApplied READ parkingBrakeApplied WRITE setParkingBrakeApplied NOTIFY parkingBrakeAppliedChanged)
    Q_PROPERTY(QString ignitionState READ ignitionState WRITE setIgnitionState NOTIFY ignitionStateChanged)
    Q_PROPERTY(bool safetyAlert READ safetyAlert NOTIFY safetyAlertChanged)
    Q_PROPERTY(QString safetyAlertMessage READ safetyAlertMessage NOTIFY safetyAlertChanged)

public:
    explicit RejuvenateController(ClimateBackend *climate,
                                 AmbientLightBackend *ambient,
                                 SeatBackend *seat,
                                 VehicleBackend *vehicle,
                                 MediaBackend *media = nullptr,
                                 QObject *parent = nullptr);
    ~RejuvenateController() override;

    SessionState state() const { return m_state; }
    QString stateString() const;
    QString phaseName() const { return m_phaseName; }
    bool active() const { return m_state == Active || m_state == Preparing || m_state == Cooldown; }
    bool paused() const { return m_state == Paused; }
    bool isPreparing() const { return m_state == Preparing; }
    bool isCompleted() const { return m_state == Completed; }

    int remainingSeconds() const { return m_remainingSeconds; }
    int totalSeconds() const { return m_totalSeconds; }
    double progress() const;
    QString formattedRemaining() const;

    QVariantList themes() const;
    int selectedThemeIndex() const { return m_selectedThemeIndex; }
    void setSelectedThemeIndex(int index);
    QVariantMap currentTheme() const;
    QString themeName() const;
    QUrl videoSource() const;
    QUrl audioSource() const;

    double audioVolume() const { return m_audioVolume; }
    double videoOpacity() const { return m_videoOpacity; }

    bool vehicleStationary() const { return m_vehicleStationary; }
    void setVehicleStationary(bool stationary);
    bool vehicleMoving() const { return m_vehicleMoving; }
    void setVehicleMoving(bool moving);
    bool parkingBrakeApplied() const { return m_parkingBrakeApplied; }
    void setParkingBrakeApplied(bool applied);
    QString ignitionState() const { return m_ignitionState; }
    void setIgnitionState(const QString &state);
    bool safetyAlert() const { return m_safetyAlert; }
    QString safetyAlertMessage() const { return m_safetyAlertMessage; }

    // QML-invokable session controls
    Q_INVOKABLE void selectTheme(int index);
    Q_INVOKABLE bool startSession(int durationSeconds = 0);
    Q_INVOKABLE void pauseSession();
    Q_INVOKABLE void resumeSession();
    Q_INVOKABLE void endSession(bool confirmed = true);
    Q_INVOKABLE void startPreviewAudio();
    Q_INVOKABLE void stopPreviewAudio();
    Q_INVOKABLE void dismissSafetyAlert();
    Q_INVOKABLE void reloadThemes();

    // Simulation helpers for demonstration/testing
    Q_INVOKABLE void simulateDriveMotion(bool moving);
    Q_INVOKABLE void simulateParkingBrake(bool applied);

signals:
    void stateChanged();
    void phaseChanged();
    void activeChanged();
    void pausedChanged();
    void remainingSecondsChanged();
    void totalSecondsChanged();
    void progressChanged();
    void themesChanged();
    void selectedThemeChanged();
    void videoSourceChanged();
    void audioSourceChanged();
    void audioVolumeChanged();
    void videoOpacityChanged();
    void vehicleStationaryChanged();
    void vehicleMovingChanged();
    void parkingBrakeAppliedChanged();
    void ignitionStateChanged();
    void safetyAlertChanged();

private slots:
    void onTickSecond();
    void onFadeStep();

private:
    struct PreviousVehicleState {
        double driverTemp{22.0};
        double passengerTemp{22.0};
        int fanSpeed{3};
        bool autoMode{true};
        bool acEnabled{true};
        bool recirculation{false};
        QString ambientColor{"#70C5F5"};
        double ambientBrightness{0.85};
        QString seatPosition{"Standard"};
        int seatRecline{18};
        int massageLevel{0};
        QString massageMode{"Off"};
        bool saved{false};
    };

    void setState(SessionState newState);
    void updatePhase();
    void capturePreviousVehicleState();
    void restorePreviousVehicleState();
    void applyThemeTargets();
    void startFade(double targetAudio, double targetVideo, int durationMs);

    ClimateBackend *m_climate{nullptr};
    AmbientLightBackend *m_ambient{nullptr};
    SeatBackend *m_seat{nullptr};
    VehicleBackend *m_vehicle{nullptr};
    MediaBackend *m_media{nullptr};

    SessionState m_state{Idle};
    QString m_phaseName{"Idle"};

    int m_remainingSeconds{600};
    int m_totalSeconds{600};
    int m_selectedThemeIndex{0};

    double m_audioVolume{0.0};
    double m_videoOpacity{0.0};
    double m_targetAudioVolume{0.0};
    double m_targetVideoOpacity{0.0};
    double m_audioStep{0.0};
    double m_videoStep{0.0};

    bool m_overrideMotion{true};
    bool m_vehicleStationary{true};
    bool m_vehicleMoving{false};
    bool m_parkingBrakeApplied{true};
    QString m_ignitionState{"ON"};
    bool m_safetyAlert{false};
    QString m_safetyAlertMessage{""};

    PreviousVehicleState m_savedState;

    QTimer m_sessionTimer;
    QTimer m_fadeTimer;
    QList<std::shared_ptr<RejuvenateTheme>> m_themeList;
    QMediaPlayer *m_audioPlayer{nullptr};
    QAudioOutput *m_audioOutput{nullptr};
};
