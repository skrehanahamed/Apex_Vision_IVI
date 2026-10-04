/**
 * ==============================================================================
 * Project: Apex VISION IVI - Digital Cockpit & Infotainment System
 * File: MediaBackend.h
 * Author / Developer: Sk Rehan Ahamed
 * License: MIT
 * ==============================================================================
 */

#pragma once

#include <QObject>
#include <QStringList>
#include <QVariantList>
#include <QVariantMap>
#include <QPointer>

class VehicleSimulator;
class QMediaPlayer;
class QAudioOutput;
class QNetworkAccessManager;
class QNetworkReply;
class QTimer;

class PersistenceManager;

class MediaBackend : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString source READ source WRITE setSource NOTIFY sourceChanged)
    Q_PROPERTY(bool isAm READ isAm NOTIFY sourceChanged)
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

    // AM Radio Properties (Matching Screenshot 1)
    Q_PROPERTY(QString amFrequency READ amFrequency WRITE setAmFrequency NOTIFY amFrequencyChanged)
    Q_PROPERTY(QString amStationName READ amStationName NOTIFY amStationNameChanged)
    Q_PROPERTY(QString amStationCity READ amStationCity NOTIFY amStationCityChanged)
    Q_PROPERTY(QVariantList amPresets READ amPresets NOTIFY amPresetsChanged)
    Q_PROPERTY(int activeAmPresetIndex READ activeAmPresetIndex NOTIFY activeAmPresetIndexChanged)
    Q_PROPERTY(QVariantList amStations READ amStations NOTIFY amStationsChanged)
    Q_PROPERTY(int currentAmStationIndex READ currentAmStationIndex NOTIFY currentAmStationIndexChanged)
    Q_PROPERTY(bool isAmAudioPlaying READ isAmAudioPlaying NOTIFY isAmAudioPlayingChanged)
    Q_PROPERTY(bool isCurrentAmPreset READ isCurrentAmPreset NOTIFY currentRadioPresetChanged)

    // Unified Radio & FM Properties
    Q_PROPERTY(bool isRadio READ isRadio NOTIFY sourceChanged)
    Q_PROPERTY(QString currentRadioBand READ currentRadioBand NOTIFY sourceChanged)
    Q_PROPERTY(QVariantList radioPresets READ radioPresets NOTIFY radioPresetsChanged)
    Q_PROPERTY(int activeRadioPresetIndex READ activeRadioPresetIndex NOTIFY activeRadioPresetIndexChanged)
    Q_PROPERTY(bool isCurrentRadioPreset READ isCurrentRadioPreset NOTIFY currentRadioPresetChanged)
    Q_PROPERTY(QVariantList fmStations READ fmStations NOTIFY fmStationsChanged)
    Q_PROPERTY(int currentFmStationIndex READ currentFmStationIndex NOTIFY currentFmStationIndexChanged)

    // OrbitXM Satellite Radio Properties (Matching SiriusXM Player Reference)
    Q_PROPERTY(bool isSxm READ isSxm NOTIFY sourceChanged)
    Q_PROPERTY(int sxmChannelNumber READ sxmChannelNumber NOTIFY sxmChannelChanged)
    Q_PROPERTY(QString sxmChannelName READ sxmChannelName NOTIFY sxmChannelChanged)
    Q_PROPERTY(QString sxmChannelLogoUrl READ sxmChannelLogoUrl NOTIFY sxmChannelChanged)
    Q_PROPERTY(QString sxmCategory READ sxmCategory NOTIFY sxmChannelChanged)
    Q_PROPERTY(QString sxmTagline READ sxmTagline NOTIFY sxmChannelChanged)
    Q_PROPERTY(QString sxmArtist READ sxmArtist NOTIFY sxmTrackChanged)
    Q_PROPERTY(QString sxmSongTitle READ sxmSongTitle NOTIFY sxmTrackChanged)
    Q_PROPERTY(QString sxmAlbum READ sxmAlbum NOTIFY sxmTrackChanged)
    Q_PROPERTY(QString sxmArtworkUrl READ sxmArtworkUrl NOTIFY sxmTrackChanged)
    Q_PROPERTY(QVariantList sxmChannels READ sxmChannels NOTIFY sxmChannelsChanged)
    Q_PROPERTY(QVariantList sxmPresets READ sxmPresets NOTIFY sxmPresetsChanged)
    Q_PROPERTY(int activeSxmPresetIndex READ activeSxmPresetIndex NOTIFY activeSxmPresetIndexChanged)
    Q_PROPERTY(bool isSxmFavorite READ isSxmFavorite NOTIFY sxmFavoriteChanged)
    Q_PROPERTY(bool isSxmAlertSet READ isSxmAlertSet NOTIFY sxmAlertChanged)
    Q_PROPERTY(QString sxmGenre READ sxmGenre NOTIFY sxmTrackChanged)
    Q_PROPERTY(QString sxmReleaseYear READ sxmReleaseYear NOTIFY sxmTrackChanged)
    Q_PROPERTY(bool isSxmLive READ isSxmLive NOTIFY sxmTrackChanged)
    Q_PROPERTY(QVariantList onlineSearchResults READ onlineSearchResults NOTIFY onlineSearchResultsChanged)
    Q_PROPERTY(bool isSearchingOnline READ isSearchingOnline NOTIFY isSearchingOnlineChanged)
    Q_PROPERTY(int currentSxmChannelIndex READ currentSxmChannelIndex NOTIFY sxmChannelChanged)
    Q_PROPERTY(bool bootComplete READ bootComplete WRITE setBootComplete NOTIFY bootCompleteChanged)

public:
    explicit MediaBackend(VehicleSimulator *simulator, PersistenceManager *persistence = nullptr, QObject *parent = nullptr);
    ~MediaBackend() override;

    bool bootComplete() const { return m_bootComplete; }
    void setBootComplete(bool c);
    Q_INVOKABLE void startPlaybackAfterBoot();

    QString source() const { return m_source; }
    bool isAm() const { return m_source == "AM"; }
    bool isRadio() const { return m_source == "AM" || m_source == "FM"; }
    QString currentRadioBand() const { return (m_source == "FM") ? "FM" : "AM"; }
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

    QString amFrequency() const { return m_amFrequency; }
    QString amStationName() const { return m_amStationName; }
    QString amStationCity() const { return m_amStationCity; }
    QVariantList amPresets() const { return m_amPresets; }
    int activeAmPresetIndex() const { return m_activeAmPresetIndex; }
    QVariantList amStations() const { return m_amStations; }
    int currentAmStationIndex() const { return m_currentAmStationIndex; }
    bool isAmAudioPlaying() const { return m_isAmAudioPlaying; }
    bool isCurrentAmPreset() const;

    QVariantList radioPresets() const { return m_radioPresets; }
    int activeRadioPresetIndex() const { return m_activeRadioPresetIndex; }
    bool isCurrentRadioPreset() const;
    QVariantList fmStations() const { return m_fmStations; }
    int currentFmStationIndex() const { return m_currentFmStationIndex; }

    // OrbitXM Satellite Radio Getters
    bool isSxm() const { return m_source == "OrbitXM" || m_source == "SXM"; }
    int sxmChannelNumber() const { return m_sxmChannelNumber; }
    QString sxmChannelName() const { return m_sxmChannelName; }
    QString sxmChannelLogoUrl() const { return m_sxmChannelLogoUrl; }
    QString sxmCategory() const { return m_sxmCategory; }
    QString sxmTagline() const { return m_sxmTagline; }
    QString sxmArtist() const { return m_sxmArtist; }
    QString sxmSongTitle() const { return m_sxmSongTitle; }
    QString sxmAlbum() const { return m_sxmAlbum; }
    QString sxmArtworkUrl() const { return m_sxmArtworkUrl; }
    QVariantList sxmChannels() const { return m_sxmChannels; }
    QVariantList sxmPresets() const { return m_sxmPresets; }
    int activeSxmPresetIndex() const { return m_activeSxmPresetIndex; }
    bool isSxmFavorite() const { return m_isSxmFavorite; }
    bool isSxmAlertSet() const { return m_isSxmAlertSet; }
    QString sxmGenre() const { return m_sxmGenre; }
    QString sxmReleaseYear() const { return m_sxmReleaseYear; }
    bool isSxmLive() const { return m_isSxmLive; }
    QVariantList onlineSearchResults() const { return m_onlineSearchResults; }
    bool isSearchingOnline() const { return m_isSearchingOnline; }
    int currentSxmChannelIndex() const { return m_currentSxmChannelIndex; }

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
    Q_INVOKABLE void fadeOutAndPause(int fadeDurationMs = 700);
    Q_INVOKABLE void pausePlayback();

    // Unified Radio Operations (Cross-Band AM & FM)
    Q_INVOKABLE void selectRadioPreset(int index);
    Q_INVOKABLE void tuneRadioFrequency(const QString &freq);
    Q_INVOKABLE void nextRadioStation();
    Q_INVOKABLE void prevRadioStation();

    // AM Radio Operations
    Q_INVOKABLE void tuneAmFrequency(const QString &freq);
    Q_INVOKABLE void setAmFrequency(const QString &freq);
    Q_INVOKABLE void setAmStationName(const QString &name);
    Q_INVOKABLE void selectAmStation(int index);
    Q_INVOKABLE void selectAmPreset(int presetIndex);
    Q_INVOKABLE void saveCurrentAsPreset();
    Q_INVOKABLE void nextAmStation();
    Q_INVOKABLE void prevAmStation();
    Q_INVOKABLE void toggleAmPlay();
    Q_INVOKABLE void startAmPlayback();
    Q_INVOKABLE void fetchOnlineAmStations();

    // FM Radio Operations
    Q_INVOKABLE void tuneFmFrequency(const QString &freq);
    Q_INVOKABLE void selectFmStation(int index);
    Q_INVOKABLE void nextFmStation();
    Q_INVOKABLE void prevFmStation();
    Q_INVOKABLE void cyclePresetOrBand();

    // OrbitXM Operations (Matching SiriusXM Player Reference)
    Q_INVOKABLE void selectSxmChannel(int channelIndex);
    Q_INVOKABLE void tuneSxmChannelNumber(int chNum);
    Q_INVOKABLE void nextSxmChannel();
    Q_INVOKABLE void prevSxmChannel();
    Q_INVOKABLE void nextSxmTrack();
    Q_INVOKABLE void prevSxmTrack();
    Q_INVOKABLE void selectSxmPreset(int presetIndex);
    Q_INVOKABLE void saveCurrentSxmPreset(int presetIndex);
    Q_INVOKABLE void toggleSxmFavorite();
    Q_INVOKABLE void toggleSxmAlert();
    Q_INVOKABLE void toggleSxmPlay();
    Q_INVOKABLE void searchAndPlaySxm(const QString &query);
    Q_INVOKABLE void searchOnlineRadioStations(const QString &query);
    Q_INVOKABLE void tuneOnlineStation(const QString &name, const QString &streamUrl, const QString &category);
    Q_INVOKABLE void seekProgress(int seconds);

signals:
    void sourceChanged();
    void presetChanged();
    void frequencyChanged();
    void stationChanged();
    void trackTitleChanged();
    void artistChanged();
    void isPlayingChanged();
    void bootCompleteChanged();
    void isHdRadioChanged();
    void progressChanged();
    void durationChanged();
    void volumeChanged();
    void phoneConnectedChanged();
    void connectedPhoneNameChanged();

    void amFrequencyChanged();
    void amStationNameChanged();
    void amStationCityChanged();
    void amPresetsChanged();
    void activeAmPresetIndexChanged();
    void amStationsChanged();
    void currentAmStationIndexChanged();
    void isAmAudioPlayingChanged();

    void radioPresetsChanged();
    void activeRadioPresetIndexChanged();
    void currentRadioPresetChanged();
    void fmStationsChanged();
    void currentFmStationIndexChanged();

    void sxmChannelChanged();
    void sxmTrackChanged();
    void sxmChannelsChanged();
    void sxmPresetsChanged();
    void activeSxmPresetIndexChanged();
    void sxmFavoriteChanged();
    void sxmAlertChanged();
    void onlineSearchResultsChanged();
    void isSearchingOnlineChanged();

private slots:
    void onMediaProgressUpdated(int pos, int dur);
    void onAmStationsNetworkReply();

private:
    void updateStationForPreset(const QString &p);
    void playCurrentAmStation();
    void playCurrentFmStation();
    void initAmStations();
    void initFmStations();
    void initDefaultRadioPresets();
    void syncAmWithMedia();
    void syncFmWithMedia();
    void updateActiveRadioPresetIndex();

    void initSxmChannels();
    void syncSxmWithMedia();
    void playCurrentSxmChannel();
    void fetchOnlineSxmArt(const QString &artist, const QString &title);
    void fetchLiveIcyMetadata(const QString &streamUrl);
    void updateActiveSxmPresetIndex();
    void switchAudioStream();

    QString m_source{"OrbitXM"};
    QString m_preset{"P1"};
    QString m_frequency{"95.9"};
    QString m_station{"AIR FM Rainbow"};
    QString m_trackTitle{"Cuttack / Eastern Coast"};
    QString m_artist{"All India Radio (AIR)"};
    bool m_isPlaying{true};
    bool m_isHdRadio{true};
    int m_progress{142};
    int m_duration{245};
    int m_volume{100};
    bool m_phoneConnected{false};
    QString m_connectedPhoneName{"iPhone 16 Pro"};

    // AM State
    QString m_amFrequency{"530"};
    QString m_amStationName{"AIR Vividh Bharati"};
    QString m_amStationCity{"National / Mumbai"};
    QVariantList m_amPresets;
    int m_activeAmPresetIndex{0};
    QVariantList m_amStations;
    int m_currentAmStationIndex{0};
    bool m_isAmAudioPlaying{false};

    // Unified Radio Presets & FM State
    QVariantList m_radioPresets;
    int m_activeRadioPresetIndex{-1};
    QVariantList m_fmStations;
    int m_currentFmStationIndex{2};

    // OrbitXM State
    int m_sxmChannelNumber{2};
    QString m_sxmChannelName{"Orbit Bollywood Hits"};
    QString m_sxmChannelLogoUrl{"qrc:/ApexVision/qml/assets/radio_logos/sxm_bollywood.png"};
    QString m_sxmCategory{"Bollywood / Top 40"};
    QString m_sxmTagline{"India's Biggest Bollywood Hits"};
    QString m_sxmArtist{"Pritam, Arijit Singh & Irshad Kamil"};
    QString m_sxmSongTitle{"O Maahi (From \"Dunki\")"};
    QString m_sxmAlbum{"Dunki (Original Soundtrack)"};
    QString m_sxmArtworkUrl{"https://is1-ssl.mzstatic.com/image/thumb/Music116/v4/9e/fb/28/9efb2892-c3b1-0c1c-f7a3-3bcccce6346e/8903431975058_cover.jpg/600x600bb.jpg"};
    QString m_sxmGenre{"Bollywood"};
    QString m_sxmReleaseYear{"2023"};
    bool m_isSxmLive{true};
    QVariantList m_sxmChannels;
    QVariantList m_sxmPresets;
    int m_activeSxmPresetIndex{1};
    bool m_isSxmFavorite{false};
    bool m_isSxmAlertSet{false};
    int m_currentSxmChannelIndex{0};
    int m_currentSxmTrackIndex{0};
    QTimer *m_sxmProgressionTimer{nullptr};
    QVariantList m_onlineSearchResults;
    bool m_isSearchingOnline{false};

    QMediaPlayer *m_mediaPlayer{nullptr};
    QAudioOutput *m_audioOutput{nullptr};
    QNetworkAccessManager *m_networkManager{nullptr};
    QNetworkReply *m_icyMetadataReply{nullptr};
    QPointer<QNetworkReply> m_onlineArtReply{nullptr};
    int m_artRequestChannelIndex{-1};
    QString m_lastIcyTitle;
    QTimer *m_icyPollTimer{nullptr};
    QTimer *m_audioSwitchTimer{nullptr};
    PersistenceManager *m_persistence{nullptr};
    bool m_bootComplete{false};
};
