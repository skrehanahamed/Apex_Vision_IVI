#pragma once

#include <QObject>
#include <QStringList>

class VehicleSimulator;

class MediaBackend : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString source READ source WRITE setSource NOTIFY sourceChanged)
    Q_PROPERTY(QString preset READ preset WRITE setPreset NOTIFY presetChanged)
    Q_PROPERTY(QString frequency READ frequency WRITE setFrequency NOTIFY frequencyChanged)
    Q_PROPERTY(QString station READ station WRITE setStation NOTIFY stationChanged)
    Q_PROPERTY(QString trackTitle READ trackTitle WRITE setTrackTitle NOTIFY trackTitleChanged)
    Q_PROPERTY(QString artist READ artist WRITE setArtist NOTIFY artistChanged)
    Q_PROPERTY(bool isPlaying READ isPlaying WRITE setIsPlaying NOTIFY isPlayingChanged)
    Q_PROPERTY(bool isHdRadio READ isHdRadio WRITE setIsHdRadio NOTIFY isHdRadioChanged)
    Q_PROPERTY(int progress READ progress NOTIFY progressChanged)
    Q_PROPERTY(int duration READ duration NOTIFY durationChanged)
    Q_PROPERTY(int volume READ volume WRITE setVolume NOTIFY volumeChanged)
    Q_PROPERTY(bool phoneConnected READ phoneConnected WRITE setPhoneConnected NOTIFY phoneConnectedChanged)
    Q_PROPERTY(QString connectedPhoneName READ connectedPhoneName NOTIFY connectedPhoneNameChanged)

public:
    explicit MediaBackend(VehicleSimulator *simulator, QObject *parent = nullptr);

    QString source() const { return m_source; }
    QString preset() const { return m_preset; }
    QString frequency() const { return m_frequency; }
    QString station() const { return m_station; }
    QString trackTitle() const { return m_trackTitle; }
    QString artist() const { return m_artist; }
    bool isPlaying() const { return m_isPlaying; }
    bool isHdRadio() const { return m_isHdRadio; }
    int progress() const { return m_progress; }
    int duration() const { return m_duration; }
    int volume() const { return m_volume; }
    bool phoneConnected() const { return m_phoneConnected; }
    QString connectedPhoneName() const { return m_connectedPhoneName; }

    Q_INVOKABLE void setSource(const QString &source);
    Q_INVOKABLE void setPreset(const QString &preset);
    Q_INVOKABLE void setFrequency(const QString &freq);
    Q_INVOKABLE void setStation(const QString &st);
    Q_INVOKABLE void setTrackTitle(const QString &title);
    Q_INVOKABLE void setArtist(const QString &art);
    Q_INVOKABLE void setIsPlaying(bool playing);
    Q_INVOKABLE void togglePlay();
    Q_INVOKABLE void next();
    Q_INVOKABLE void previous();
    Q_INVOKABLE void setIsHdRadio(bool hd);
    Q_INVOKABLE void setVolume(int vol);
    Q_INVOKABLE void setPhoneConnected(bool connected);
    Q_INVOKABLE void togglePhoneConnection();

signals:
    void sourceChanged();
    void presetChanged();
    void frequencyChanged();
    void stationChanged();
    void trackTitleChanged();
    void artistChanged();
    void isPlayingChanged();
    void isHdRadioChanged();
    void progressChanged();
    void durationChanged();
    void volumeChanged();
    void phoneConnectedChanged();
    void connectedPhoneNameChanged();

private slots:
    void onMediaProgressUpdated(int pos, int dur);

private:
    void updateStationForPreset(const QString &p);

    QString m_source{"FM"};
    QString m_preset{"P1"};
    QString m_frequency{"95.9"};
    QString m_station{"GTA's #1 Country KX-96"};
    QString m_trackTitle{"Neon Horizon"};
    QString m_artist{"APEX Audio"};
    bool m_isPlaying{true};
    bool m_isHdRadio{true};
    int m_progress{142};
    int m_duration{245};
    int m_volume{45};
    bool m_phoneConnected{false};
    QString m_connectedPhoneName{"iPhone 16 Pro"};
};
