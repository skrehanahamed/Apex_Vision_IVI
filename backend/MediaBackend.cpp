#include "MediaBackend.h"
#include "VehicleSimulator.h"
#include <QMediaPlayer>
#include <QAudioOutput>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>
#include <QUrl>
#include <QDebug>
#include <QTimer>
#include <algorithm>

MediaBackend::MediaBackend(VehicleSimulator *simulator, QObject *parent)
    : QObject(parent)
{
    if (simulator) {
        connect(simulator, &VehicleSimulator::mediaProgressUpdated,
                this, &MediaBackend::onMediaProgressUpdated);
    }

    // Initialize Audio Engine
    m_audioOutput = new QAudioOutput(this);
    m_mediaPlayer = new QMediaPlayer(this);
    m_mediaPlayer->setAudioOutput(m_audioOutput);
    m_audioOutput->setVolume(static_cast<float>(m_volume) / 100.0f);

    connect(m_mediaPlayer, &QMediaPlayer::playbackStateChanged, this, [this](QMediaPlayer::PlaybackState state) {
        bool playing = (state == QMediaPlayer::PlayingState);
        if (m_isAmAudioPlaying != playing) {
            m_isAmAudioPlaying = playing;
            emit isAmAudioPlayingChanged();
        }
        if ((m_source == "AM" || m_source == "FM") && m_isPlaying != playing) {
            m_isPlaying = playing;
            emit isPlayingChanged();
        }
    });

    m_networkManager = new QNetworkAccessManager(this);

    initAmStations();
    initFmStations();
    updateActiveRadioPresetIndex();
    if (m_source == "AM") {
        syncAmWithMedia();
        playCurrentAmStation();
    } else if (m_source == "FM") {
        syncFmWithMedia();
        playCurrentFmStation();
    }
}

MediaBackend::~MediaBackend()
{
    if (m_mediaPlayer) {
        m_mediaPlayer->stop();
    }
}

void MediaBackend::initAmStations()
{
    m_amStations.clear();

    // 8 Curated Distinct Medium Wave (AM) All India Radio Stations
    auto addStation = [this](const QString &freq, const QString &name, const QString &city, const QString &streamUrl) {
        QVariantMap s;
        s["frequency"] = freq;
        s["name"] = name;
        s["city"] = city;
        s["streamUrl"] = streamUrl;
        m_amStations.append(s);
    };

    addStation("530", "AIR Vividh Bharati", "National / Mumbai", "https://air.pc.cdn.bitgravity.com/air/live/pbaudio001/playlist.m3u8");
    addStation("640", "AIR Berhampur", "Odisha Regional", "https://airhlspush.pc.cdn.bitgravity.com/httppush/hlspbaudio002/hlspbaudio00264kbps.m3u8");
    addStation("720", "AIR Cuttack", "Eastern Coast", "https://airhlspush.pc.cdn.bitgravity.com/httppush/hlspbaudio003/hlspbaudio00364kbps.m3u8");
    addStation("810", "AIR Jaipur", "Rajasthan Network", "https://airhlspush.pc.cdn.bitgravity.com/httppush/hlspbaudio004/hlspbaudio00464kbps.m3u8");
    addStation("900", "AIR Lucknow", "Uttar Pradesh Central", "https://airhlspush.pc.cdn.bitgravity.com/httppush/hlspbaudio008/hlspbaudio00864kbps.m3u8");
    addStation("990", "AIR Patna", "Bihar Regional", "https://airhlspush.pc.cdn.bitgravity.com/httppush/hlspbaudio009/hlspbaudio00964kbps.m3u8");
    addStation("1026", "AIR Shimla", "Himachal Pradesh", "https://airhlspush.pc.cdn.bitgravity.com/httppush/hlspbaudio010/hlspbaudio01064kbps.m3u8");
    addStation("1130", "AIR Bengaluru", "Karnataka Regional", "https://airhlspush.pc.cdn.bitgravity.com/httppush/hlspbaudio030/hlspbaudio03064kbps.m3u8");

    // Only user-saved presets show at the bottom - starts completely empty (pure black)
    m_amPresets.clear();

    m_currentAmStationIndex = 0;
    m_activeAmPresetIndex = -1;
    m_amFrequency = "530";
    m_amStationName = "AIR Vividh Bharati";
    m_amStationCity = "National / Mumbai";

    emit amStationsChanged();
    emit amPresetsChanged();
    emit amFrequencyChanged();
    emit amStationNameChanged();
    emit amStationCityChanged();
    emit activeAmPresetIndexChanged();
}

void MediaBackend::fetchOnlineAmStations()
{
    // 12 curated stable Bitgravity AIR stations are already loaded in initAmStations()
}

void MediaBackend::onAmStationsNetworkReply()
{
}

void MediaBackend::onMediaProgressUpdated(int pos, int dur)
{
    if (m_isPlaying) {
        m_progress = pos;
        m_duration = dur;
        emit progressChanged();
    }
}

void MediaBackend::setSource(const QString &source)
{
    if (m_source == source) {
        return; // Prevent duplicate triggers and sudden silence
    }

    m_source = source;
    emit sourceChanged();

    if (m_source == "AM") {
        syncAmWithMedia();
        playCurrentAmStation();
    } else if (m_source == "FM") {
        syncFmWithMedia();
        playCurrentFmStation();
    } else {
        if (m_mediaPlayer) {
            m_mediaPlayer->pause();
        }
        if (m_source == "Bluetooth") {
            m_frequency = "BT Audio";
            m_station = m_phoneConnected ? m_connectedPhoneName : "No Device";
            m_trackTitle = "Midnight Drive";
            m_artist = "Synthwave Collective";
            m_isHdRadio = false;
        } else if (m_source == "USB") {
            m_frequency = "USB 1";
            m_station = "Apex High-Res Audio";
            m_trackTitle = "Cyber City Lights";
            m_artist = "Starlight Sound";
            m_isHdRadio = true;
        }
        emit frequencyChanged();
        emit stationChanged();
        emit trackTitleChanged();
        emit artistChanged();
        emit isHdRadioChanged();
    }
    updateActiveRadioPresetIndex();
}

void MediaBackend::startAmPlayback()
{
    if (m_source != "AM") {
        setSource("AM");
    } else {
        if (!m_mediaPlayer) return;
        // If already playing audio, NEVER interrupt to avoid sudden silence
        if (m_mediaPlayer->playbackState() == QMediaPlayer::PlayingState) {
            return;
        }
        playCurrentAmStation();
    }
}

void MediaBackend::syncAmWithMedia()
{
    m_frequency = m_amFrequency;
    m_station = m_amStationName;
    m_trackTitle = m_amStationCity;
    m_artist = "All India Radio (AIR)";
    m_isHdRadio = false;

    emit frequencyChanged();
    emit stationChanged();
    emit trackTitleChanged();
    emit artistChanged();
    emit isHdRadioChanged();
}

void MediaBackend::syncFmWithMedia()
{
    if (m_currentFmStationIndex >= 0 && m_currentFmStationIndex < m_fmStations.size()) {
        QVariantMap s = m_fmStations[m_currentFmStationIndex].toMap();
        m_frequency = s["frequency"].toString();
        m_station = s["name"].toString();
        m_trackTitle = s["city"].toString();
    } else {
        m_frequency = "95.9";
        m_station = "Bollywood Hits Radio";
        m_trackTitle = "Top Bollywood Hits";
    }
    m_artist = "FM Stereo Broadcast";
    m_isHdRadio = true;

    emit frequencyChanged();
    emit stationChanged();
    emit trackTitleChanged();
    emit artistChanged();
    emit isHdRadioChanged();
}

void MediaBackend::playCurrentAmStation()
{
    if (m_currentAmStationIndex >= 0 && m_currentAmStationIndex < m_amStations.size()) {
        QVariantMap s = m_amStations[m_currentAmStationIndex].toMap();
        QString streamUrl = s["streamUrl"].toString();
        if (!streamUrl.isEmpty() && m_mediaPlayer) {
            QUrl targetUrl(streamUrl);
            // If already loaded with this exact stream, DO NOT reload it (avoids sudden silence)
            if (m_mediaPlayer->source() == targetUrl) {
                if (m_mediaPlayer->playbackState() != QMediaPlayer::PlayingState) {
                    m_mediaPlayer->play();
                }
                return;
            }
            m_mediaPlayer->setSource(targetUrl);
            m_mediaPlayer->play();
        }
    }
}

void MediaBackend::tuneAmFrequency(const QString &freq)
{
    QString cleanFreq = freq.trimmed();
    if (cleanFreq.isEmpty()) return;

    m_amFrequency = cleanFreq;
    emit amFrequencyChanged();

    // Check exact or numeric match in m_amStations
    int matchedIdx = -1;
    double inputVal = cleanFreq.toDouble();

    for (int i = 0; i < m_amStations.size(); ++i) {
        QString stFreq = m_amStations[i].toMap()["frequency"].toString();
        if (stFreq == cleanFreq || (inputVal > 0 && qFuzzyCompare(stFreq.toDouble(), inputVal))) {
            matchedIdx = i;
            break;
        }
    }

    if (matchedIdx >= 0) {
        selectAmStation(matchedIdx);
        // Retain user's typed string
        m_amFrequency = cleanFreq;
        emit amFrequencyChanged();
        if (m_source == "AM") syncAmWithMedia();
        updateActiveRadioPresetIndex();
        return;
    }

    // If not a main AM frequency -> SILENCE (Off-air / No signal)
    m_currentAmStationIndex = -1;
    emit currentAmStationIndexChanged();

    m_amStationName = "No Signal";
    m_amStationCity = QString("%1 kHz • Off-air").arg(cleanFreq);
    emit amStationNameChanged();
    emit amStationCityChanged();

    updateActiveRadioPresetIndex();

    if (m_source == "AM") {
        syncAmWithMedia();
        if (m_mediaPlayer) {
            m_mediaPlayer->stop();
        }
    }
}


void MediaBackend::setAmFrequency(const QString &freq)
{
    tuneAmFrequency(freq);
}

void MediaBackend::setAmStationName(const QString &name)
{
    if (m_amStationName != name) {
        m_amStationName = name;
        emit amStationNameChanged();
        if (m_source == "AM") syncAmWithMedia();
    }
}

void MediaBackend::selectAmStation(int index)
{
    if (index >= 0 && index < m_amStations.size()) {
        m_currentAmStationIndex = index;
        emit currentAmStationIndexChanged();

        QVariantMap s = m_amStations[index].toMap();
        m_amFrequency = s["frequency"].toString();
        m_amStationName = s["name"].toString();
        m_amStationCity = s["city"].toString();

        emit amFrequencyChanged();
        emit amStationNameChanged();
        emit amStationCityChanged();

        updateActiveRadioPresetIndex();

        if (m_source == "AM") {
            syncAmWithMedia();
            playCurrentAmStation();
        }
    }
}

void MediaBackend::initFmStations()
{
    m_fmStations.clear();

    auto addFm = [this](const QString &freq, const QString &name, const QString &city, const QString &streamUrl) {
        QVariantMap s;
        s["frequency"] = freq;
        s["name"] = name;
        s["city"] = city;
        s["streamUrl"] = streamUrl;
        m_fmStations.append(s);
    };

    addFm("91.1", "AIR FM Gold", "Delhi Capital Metro", "https://airhlspush.pc.cdn.bitgravity.com/httppush/hlspbaudio005/hlspbaudio00564kbps.m3u8");
    addFm("93.5", "Superhits FM 93.5", "South Non-Stop Hits", "https://centova.aarenworld.com/proxy/894tamilfm/stream");
    addFm("95.9", "Bollywood Hits Radio", "Top Bollywood Hits", "https://puma.streemlion.com:4130/stream");
    addFm("98.3", "Radio A9 Bollywood", "Modern Hindi Beats", "https://a9radio1-a9media.radioca.st/stream");
    addFm("100.7", "AIR FM Gold Kolkata", "Kolkata Eastern Metro", "https://airhlspush.pc.cdn.bitgravity.com/httppush/hlspbaudio011/hlspbaudio01164kbps.m3u8");
    addFm("101.4", "AIR FM Rainbow Chennai", "Chennai South Metro", "https://airhlspush.pc.cdn.bitgravity.com/httppush/hlspbaudio006/hlspbaudio00664kbps.m3u8");
    addFm("101.9", "AIR FM Rainbow Hyderabad", "Deccan Telangana Metro", "https://airhlspush.pc.cdn.bitgravity.com/httppush/hlspbaudio007/hlspbaudio00764kbps.m3u8");
    addFm("102.6", "AIR Rainbow Kannada", "Bengaluru Silicon Beats", "https://airhlspush.pc.cdn.bitgravity.com/httppush/hlspbaudio027/hlspbaudio02764kbps.m3u8");
    addFm("103.5", "Amruthavarshini Classical FM", "Classical Ragas & Melody", "https://airhlspush.pc.cdn.bitgravity.com/httppush/hlspbaudio028/hlspbaudio02864kbps.m3u8");
    addFm("104.0", "BBC World Service FM", "International News & Features", "http://stream.live.vc.bbcmedia.co.uk/bbc_world_service");

    m_currentFmStationIndex = 2; // Default to 95.9 (Bollywood Hits Radio)
    m_frequency = "95.9";
    m_station = "Bollywood Hits Radio";
    m_trackTitle = "Top Bollywood Hits";

    emit fmStationsChanged();
    emit currentFmStationIndexChanged();
    emit frequencyChanged();
    emit stationChanged();
    emit trackTitleChanged();
}

void MediaBackend::playCurrentFmStation()
{
    if (m_currentFmStationIndex >= 0 && m_currentFmStationIndex < m_fmStations.size()) {
        QVariantMap s = m_fmStations[m_currentFmStationIndex].toMap();
        QString streamUrl = s["streamUrl"].toString();
        if (!streamUrl.isEmpty() && m_mediaPlayer) {
            QUrl targetUrl(streamUrl);
            if (m_mediaPlayer->source() == targetUrl) {
                if (m_mediaPlayer->playbackState() != QMediaPlayer::PlayingState) {
                    m_mediaPlayer->play();
                }
                return;
            }
            m_mediaPlayer->setSource(targetUrl);
            m_mediaPlayer->play();
        }
    }
}

void MediaBackend::tuneFmFrequency(const QString &freq)
{
    QString cleanFreq = freq.trimmed();
    if (cleanFreq.isEmpty()) return;

    m_frequency = cleanFreq;
    emit frequencyChanged();

    int matchedIdx = -1;
    double inputVal = cleanFreq.toDouble();

    for (int i = 0; i < m_fmStations.size(); ++i) {
        QString stFreq = m_fmStations[i].toMap()["frequency"].toString();
        if (stFreq == cleanFreq || (inputVal > 0 && qFuzzyCompare(stFreq.toDouble(), inputVal))) {
            matchedIdx = i;
            break;
        }
    }

    if (matchedIdx >= 0) {
        selectFmStation(matchedIdx);
        m_frequency = cleanFreq;
        emit frequencyChanged();
        updateActiveRadioPresetIndex();
        return;
    }

    // Not a main FM frequency -> SILENCE (Off-air / No signal)
    m_currentFmStationIndex = -1;
    emit currentFmStationIndexChanged();

    m_station = "No Signal";
    m_trackTitle = QString("%1 MHz • Off-air").arg(cleanFreq);
    emit stationChanged();
    emit trackTitleChanged();

    updateActiveRadioPresetIndex();

    if (m_source == "FM" && m_mediaPlayer) {
        m_mediaPlayer->stop();
    }
}

void MediaBackend::selectFmStation(int index)
{
    if (index >= 0 && index < m_fmStations.size()) {
        m_currentFmStationIndex = index;
        emit currentFmStationIndexChanged();

        QVariantMap s = m_fmStations[index].toMap();
        m_frequency = s["frequency"].toString();
        m_station = s["name"].toString();
        m_trackTitle = s["city"].toString();

        emit frequencyChanged();
        emit stationChanged();
        emit trackTitleChanged();

        updateActiveRadioPresetIndex();

        if (m_source == "FM") {
            playCurrentFmStation();
        }
    }
}

void MediaBackend::nextFmStation()
{
    if (m_fmStations.isEmpty()) return;
    int nextIdx = (m_currentFmStationIndex + 1) % m_fmStations.size();
    if (nextIdx < 0) nextIdx = 0;
    selectFmStation(nextIdx);
}

void MediaBackend::prevFmStation()
{
    if (m_fmStations.isEmpty()) return;
    int prevIdx = (m_currentFmStationIndex - 1 + m_fmStations.size()) % m_fmStations.size();
    if (prevIdx < 0) prevIdx = m_fmStations.size() - 1;
    selectFmStation(prevIdx);
}

void MediaBackend::selectRadioPreset(int index)
{
    if (index >= 0 && index < m_radioPresets.size()) {
        QVariantMap p = m_radioPresets[index].toMap();
        QString band = p["band"].toString();
        QString freq = p["frequency"].toString();

        if (band == "AM") {
            if (m_source != "AM") {
                setSource("AM");
            }
            tuneAmFrequency(freq);
        } else if (band == "FM") {
            if (m_source != "FM") {
                setSource("FM");
            }
            tuneFmFrequency(freq);
        }
        m_activeRadioPresetIndex = index;
        emit activeRadioPresetIndexChanged();
        emit currentRadioPresetChanged();
    }
}

void MediaBackend::tuneRadioFrequency(const QString &freq)
{
    if (m_source == "AM") {
        tuneAmFrequency(freq);
    } else if (m_source == "FM") {
        tuneFmFrequency(freq);
    }
}

void MediaBackend::nextRadioStation()
{
    if (m_source == "AM") {
        nextAmStation();
    } else if (m_source == "FM") {
        nextFmStation();
    }
}

void MediaBackend::prevRadioStation()
{
    if (m_source == "AM") {
        prevAmStation();
    } else if (m_source == "FM") {
        prevFmStation();
    }
}

void MediaBackend::selectAmPreset(int presetIndex)
{
    selectRadioPreset(presetIndex);
}

bool MediaBackend::isCurrentRadioPreset() const
{
    QString currBand = m_source;
    QString currFreq = (m_source == "AM") ? m_amFrequency : m_frequency;
    for (const auto &item : m_radioPresets) {
        QVariantMap p = item.toMap();
        if (p["band"].toString().compare(currBand, Qt::CaseInsensitive) == 0) {
            QString pFreq = p["frequency"].toString();
            if (pFreq == currFreq) return true;
            bool ok1 = false, ok2 = false;
            double v1 = pFreq.toDouble(&ok1);
            double v2 = currFreq.toDouble(&ok2);
            if (ok1 && ok2 && qAbs(v1 - v2) < 0.05) return true;
        }
    }
    return false;
}

bool MediaBackend::isCurrentAmPreset() const
{
    return isCurrentRadioPreset();
}

void MediaBackend::updateActiveRadioPresetIndex()
{
    QString currBand = m_source;
    QString currFreq = (m_source == "AM") ? m_amFrequency : m_frequency;
    m_activeRadioPresetIndex = -1;
    for (int i = 0; i < m_radioPresets.size(); ++i) {
        QVariantMap p = m_radioPresets[i].toMap();
        if (p["band"].toString().compare(currBand, Qt::CaseInsensitive) == 0) {
            QString pFreq = p["frequency"].toString();
            bool match = (pFreq == currFreq);
            if (!match) {
                bool ok1 = false, ok2 = false;
                double v1 = pFreq.toDouble(&ok1);
                double v2 = currFreq.toDouble(&ok2);
                if (ok1 && ok2 && qAbs(v1 - v2) < 0.05) {
                    match = true;
                }
            }
            if (match) {
                m_activeRadioPresetIndex = i;
                break;
            }
        }
    }
    emit activeRadioPresetIndexChanged();
    emit currentRadioPresetChanged();
}

void MediaBackend::saveCurrentAsPreset()
{
    QString currBand = m_source;
    if (currBand != "AM" && currBand != "FM") return;

    QString currFreq = (currBand == "AM") ? m_amFrequency : m_frequency;
    QString currName = (currBand == "AM") ? m_amStationName : m_station;
    QString currCity = (currBand == "AM") ? m_amStationCity : m_trackTitle;

    int existingIdx = -1;
    for (int i = 0; i < m_radioPresets.size(); ++i) {
        QVariantMap p = m_radioPresets[i].toMap();
        if (p["band"].toString().compare(currBand, Qt::CaseInsensitive) == 0) {
            QString pFreq = p["frequency"].toString();
            bool match = (pFreq == currFreq);
            if (!match) {
                bool ok1 = false, ok2 = false;
                double v1 = pFreq.toDouble(&ok1);
                double v2 = currFreq.toDouble(&ok2);
                if (ok1 && ok2 && qAbs(v1 - v2) < 0.05) {
                    match = true;
                }
            }
            if (match) {
                existingIdx = i;
                break;
            }
        }
    }

    if (existingIdx >= 0) {
        // Toggle removal
        m_radioPresets.removeAt(existingIdx);
        m_activeRadioPresetIndex = -1;
    } else {
        if (m_radioPresets.size() >= 8) {
            m_radioPresets.removeFirst();
        }
        QVariantMap p;
        p["band"] = currBand;
        p["frequency"] = currFreq;
        p["name"] = currName;
        p["city"] = currCity;
        m_radioPresets.append(p);
        m_activeRadioPresetIndex = m_radioPresets.size() - 1;
    }
    emit radioPresetsChanged();
    emit activeRadioPresetIndexChanged();
    emit currentRadioPresetChanged();
    emit amPresetsChanged();
}

void MediaBackend::nextAmStation()
{
    if (m_amStations.isEmpty()) return;
    int nextIdx = (m_currentAmStationIndex + 1) % m_amStations.size();
    if (nextIdx < 0) nextIdx = 0;
    selectAmStation(nextIdx);
}

void MediaBackend::prevAmStation()
{
    if (m_amStations.isEmpty()) return;
    int prevIdx = (m_currentAmStationIndex - 1 + m_amStations.size()) % m_amStations.size();
    if (prevIdx < 0) prevIdx = m_amStations.size() - 1;
    selectAmStation(prevIdx);
}

void MediaBackend::toggleAmPlay()
{
    if (!m_mediaPlayer) return;

    if (m_mediaPlayer->playbackState() == QMediaPlayer::PlayingState) {
        m_mediaPlayer->pause();
    } else {
        if (m_mediaPlayer->source().isEmpty()) {
            if (m_source == "AM") playCurrentAmStation();
            else if (m_source == "FM") playCurrentFmStation();
        } else {
            m_mediaPlayer->play();
        }
    }
}

void MediaBackend::setPreset(const QString &preset)
{
    if (m_preset != preset) {
        m_preset = preset;
        emit presetChanged();
        updateStationForPreset(preset);
    }
}

void MediaBackend::updateStationForPreset(const QString &p)
{
    if (m_source == "AM") return;

    if (p == "P1") {
        selectFmStation(2); // 95.9
    } else if (p == "P2") {
        selectFmStation(8); // 102.1
    } else if (p == "P3") {
        selectFmStation(3); // 98.3
    } else if (p == "P4") {
        selectFmStation(0); // 91.1
    }
}

void MediaBackend::setFrequency(const QString &freq)
{
    if (m_frequency != freq) {
        m_frequency = freq;
        emit frequencyChanged();
        updateActiveRadioPresetIndex();
    }
}

void MediaBackend::setStation(const QString &st)
{
    if (m_station != st) {
        m_station = st;
        emit stationChanged();
    }
}

void MediaBackend::setTrackTitle(const QString &title)
{
    if (m_trackTitle != title) {
        m_trackTitle = title;
        emit trackTitleChanged();
    }
}

void MediaBackend::setArtist(const QString &art)
{
    if (m_artist != art) {
        m_artist = art;
        emit artistChanged();
    }
}

void MediaBackend::setIsPlaying(bool playing)
{
    if (m_isPlaying != playing) {
        m_isPlaying = playing;
        emit isPlayingChanged();

        if (m_source == "AM" || m_source == "FM") {
            if (m_isPlaying) {
                if (m_mediaPlayer && m_mediaPlayer->playbackState() != QMediaPlayer::PlayingState) {
                    m_mediaPlayer->play();
                }
            } else {
                if (m_mediaPlayer) {
                    m_mediaPlayer->pause();
                }
            }
        }
    }
}

void MediaBackend::togglePlay()
{
    if (m_source == "AM" || m_source == "FM") {
        toggleAmPlay();
    } else {
        setIsPlaying(!m_isPlaying);
    }
}

void MediaBackend::next()
{
    if (m_source == "AM") {
        nextAmStation();
    } else if (m_source == "FM") {
        nextFmStation();
    } else {
        if (m_preset == "P1") setPreset("P2");
        else if (m_preset == "P2") setPreset("P3");
        else if (m_preset == "P3") setPreset("P4");
        else setPreset("P1");
    }
}

void MediaBackend::previous()
{
    if (m_source == "AM") {
        prevAmStation();
    } else if (m_source == "FM") {
        prevFmStation();
    } else {
        if (m_preset == "P4") setPreset("P3");
        else if (m_preset == "P3") setPreset("P2");
        else if (m_preset == "P2") setPreset("P1");
        else setPreset("P4");
    }
}

void MediaBackend::setIsHdRadio(bool hd)
{
    if (m_isHdRadio != hd) {
        m_isHdRadio = hd;
        emit isHdRadioChanged();
    }
}

void MediaBackend::setVolume(int vol)
{
    vol = std::clamp(vol, 0, 100);
    if (m_volume != vol) {
        m_volume = vol;
        if (m_audioOutput) {
            m_audioOutput->setVolume(static_cast<float>(m_volume) / 100.0f);
        }
        emit volumeChanged();
    }
}

void MediaBackend::setPhoneConnected(bool connected)
{
    if (m_phoneConnected != connected) {
        m_phoneConnected = connected;
        emit phoneConnectedChanged();
    }
}

void MediaBackend::togglePhoneConnection()
{
    setPhoneConnected(!m_phoneConnected);
}

void MediaBackend::cyclePresetOrBand()
{
    if (!m_radioPresets.isEmpty()) {
        int nextPreset = (m_activeRadioPresetIndex + 1) % m_radioPresets.size();
        selectRadioPreset(nextPreset);
    } else {
        if (m_source == "FM") {
            setSource("AM");
        } else if (m_source == "AM") {
            setSource("FM");
        }
    }
}

void MediaBackend::fadeOutAndPause(int fadeDurationMs)
{
    if (!m_isPlaying && (!m_mediaPlayer || m_mediaPlayer->playbackState() != QMediaPlayer::PlayingState)) {
        return;
    }

    if (!m_mediaPlayer || !m_audioOutput || m_mediaPlayer->playbackState() != QMediaPlayer::PlayingState) {
        setIsPlaying(false);
        return;
    }

    float initialVol = m_audioOutput->volume();
    if (initialVol <= 0.01f) {
        setIsPlaying(false);
        if (m_mediaPlayer) {
            m_mediaPlayer->pause();
        }
        return;
    }

    // Smooth step-wise volume fade down
    int steps = 14;
    int stepInterval = qMax(20, fadeDurationMs / steps);
    auto timer = new QTimer(this);
    auto stepCount = std::make_shared<int>(0);

    connect(timer, &QTimer::timeout, this, [this, timer, stepCount, steps, initialVol]() {
        (*stepCount)++;
        float progress = static_cast<float>(*stepCount) / static_cast<float>(steps);
        float currentVol = qMax(0.0f, initialVol * (1.0f - progress));

        if (m_audioOutput) {
            m_audioOutput->setVolume(currentVol);
        }

        if (*stepCount >= steps) {
            timer->stop();
            timer->deleteLater();
            setIsPlaying(false);
            if (m_mediaPlayer) {
                m_mediaPlayer->pause();
            }
            // Restore configured volume level for future resumption
            if (m_audioOutput) {
                m_audioOutput->setVolume(static_cast<float>(m_volume) / 100.0f);
            }
        }
    });

    timer->start(stepInterval);
}

void MediaBackend::pausePlayback()
{
    if (m_mediaPlayer) {
        m_mediaPlayer->pause();
    }
}

