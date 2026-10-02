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
#include <QPointer>
#include <QRegularExpression>
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
    m_audioOutput->setMuted(false);
    m_volume = 80;
    m_audioOutput->setVolume(0.80f);

    connect(m_mediaPlayer, &QMediaPlayer::errorOccurred, this, [this](QMediaPlayer::Error error, const QString &errorString) {
        qWarning() << "[MediaBackend] MediaPlayer error:" << error << errorString;
    });

    connect(m_mediaPlayer, &QMediaPlayer::mediaStatusChanged, this, [](QMediaPlayer::MediaStatus /*status*/) {
    });

    connect(m_mediaPlayer, &QMediaPlayer::playbackStateChanged, this, [this](QMediaPlayer::PlaybackState state) {
        bool playing = (state == QMediaPlayer::PlayingState);
        if (m_isAmAudioPlaying != playing) {
            m_isAmAudioPlaying = playing;
            emit isAmAudioPlayingChanged();
        }
        if (state == QMediaPlayer::PlayingState) {
            m_isPlaying = true;
            emit isPlayingChanged();
        } else if (state == QMediaPlayer::PausedState) {
            m_isPlaying = false;
            emit isPlayingChanged();
        }
    });

    m_networkManager = new QNetworkAccessManager(this);

    initAmStations();
    initFmStations();
    initSxmChannels();
    initDefaultRadioPresets();
    updateActiveRadioPresetIndex();
    updateActiveSxmPresetIndex();

    m_sxmProgressionTimer = new QTimer(this);
    connect(m_sxmProgressionTimer, &QTimer::timeout, this, [this]() {
        if ((m_source == "OrbitXM" || m_source == "SXM") && m_isPlaying) {
            m_progress++;
            emit progressChanged();
            if (m_progress >= m_duration) {
                nextSxmTrack();
            }
        }
    });
    m_sxmProgressionTimer->start(1000);

    // Initialize 20-second live Icecast ICY metadata poll timer for real-time song title tracking
    m_icyPollTimer = new QTimer(this);
    connect(m_icyPollTimer, &QTimer::timeout, this, [this]() {
        if ((m_source == "OrbitXM" || m_source == "SXM") && m_isPlaying) {
            if (m_currentSxmChannelIndex >= 0 && m_currentSxmChannelIndex < m_sxmChannels.size()) {
                QString url = m_sxmChannels[m_currentSxmChannelIndex].toMap()["streamUrl"].toString();
                if (!url.isEmpty()) {
                    fetchLiveIcyMetadata(url);
                }
            }
        }
    });
    m_icyPollTimer->start(20000);

    if (m_source == "AM") {
        syncAmWithMedia();
        playCurrentAmStation();
    } else if (m_source == "FM") {
        syncFmWithMedia();
        playCurrentFmStation();
    } else if (m_source == "OrbitXM" || m_source == "SXM") {
        syncSxmWithMedia();
        playCurrentSxmChannel();
    }
}

MediaBackend::~MediaBackend()
{
    if (m_icyMetadataReply) {
        m_icyMetadataReply->abort();
        m_icyMetadataReply->deleteLater();
        m_icyMetadataReply = nullptr;
    }
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
    } else if (m_source == "OrbitXM" || m_source == "SXM") {
        syncSxmWithMedia();
        playCurrentSxmChannel();
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
    updateActiveSxmPresetIndex();
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

void MediaBackend::initDefaultRadioPresets()
{
    m_radioPresets.clear();

    // Curated broadcast stations with authentic logos/badges
    m_radioPresets.append(QVariantMap{
        {"band", "FM"},
        {"frequency", "95.9"},
        {"name", "Bollywood Hits"},
        {"logoText", "BOLLYWOOD"},
        {"logoColor", "#FFFFFF"},
        {"logoBg", "#EC4899"},
        {"isHoldToSet", false}
    });
    m_radioPresets.append(QVariantMap{
        {"band", "FM"},
        {"frequency", "91.1"},
        {"name", "AIR FM Gold"},
        {"logoText", "GOLD"},
        {"logoColor", "#FFFFFF"},
        {"logoBg", "#F59E0B"},
        {"isHoldToSet", false}
    });
    m_radioPresets.append(QVariantMap{
        {"band", "FM"},
        {"frequency", "93.5"},
        {"name", "Superhits FM"},
        {"logoText", "SUPERHITS"},
        {"logoColor", "#FFFFFF"},
        {"logoBg", "#EF4444"},
        {"isHoldToSet", false}
    });
    m_radioPresets.append(QVariantMap{
        {"band", "FM"},
        {"frequency", "104.0"},
        {"name", "BBC World"},
        {"logoText", "BBC"},
        {"logoColor", "#FFFFFF"},
        {"logoBg", "#DC2626"},
        {"isHoldToSet", false}
    });
    m_radioPresets.append(QVariantMap{
        {"band", "AM"},
        {"frequency", "530"},
        {"name", "AIR Vividh"},
        {"logoText", "AIR"},
        {"logoColor", "#FFFFFF"},
        {"logoBg", "#0284C7"},
        {"isHoldToSet", false}
    });
    m_radioPresets.append(QVariantMap{
        {"band", "FM"},
        {"frequency", "98.3"},
        {"name", "Radio A9"},
        {"logoText", "A9 HITS"},
        {"logoColor", "#FFFFFF"},
        {"logoBg", "#8B5CF6"},
        {"isHoldToSet", false}
    });
    m_radioPresets.append(QVariantMap{
        {"band", ""},
        {"frequency", ""},
        {"name", "Hold To Set"},
        {"logoText", ""},
        {"logoColor", ""},
        {"logoBg", ""},
        {"isHoldToSet", true}
    });

    emit radioPresetsChanged();
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
        if (p["isHoldToSet"].toBool()) {
            p["isHoldToSet"] = false;
            p["band"] = m_source == "AM" ? "AM" : "FM";
            p["frequency"] = m_source == "AM" ? m_amFrequency : m_frequency;
            p["name"] = m_station;
            p["logoText"] = m_station.left(8).toUpper();
            p["logoColor"] = "#FFFFFF";
            p["logoBg"] = m_source == "AM" ? "#0284C7" : "#EC4899";
            m_radioPresets[index] = p;
            m_activeRadioPresetIndex = index;
            emit radioPresetsChanged();
            emit activeRadioPresetIndexChanged();
            emit currentRadioPresetChanged();
            return;
        }

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
    } else if (m_source == "OrbitXM" || m_source == "SXM") {
        toggleSxmPlay();
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
    } else if (m_source == "OrbitXM" || m_source == "SXM") {
        nextSxmTrack();
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
    } else if (m_source == "OrbitXM" || m_source == "SXM") {
        prevSxmTrack();
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

// =========================================================================
// OrbitXM Satellite Radio Implementation (SiriusXM Inspired)
// =========================================================================

void MediaBackend::initSxmChannels()
{
    m_sxmChannels.clear();

    auto createTrack = [](const QString &title, const QString &artist, const QString &album, int duration, const QString &art) {
        QVariantMap t;
        t["title"] = title;
        t["artist"] = artist;
        t["album"] = album;
        t["duration"] = duration;
        t["artwork"] = art;
        return t;
    };

    // Ch 2: Orbit Bollywood Hits
    {
        QVariantMap ch;
        ch["number"] = 2;
        ch["name"] = "Orbit Bollywood Hits";
        ch["tagline"] = "India's Biggest Bollywood Hits";
        ch["category"] = "Bollywood / Top 40";
        ch["badgeText"] = "BOLLYWOOD";
        ch["badgeColor"] = "#E11D48";
        ch["logoUrl"] = "qrc:/ApexVision/qml/assets/radio_logos/sxm_bollywood.png";
        ch["streamUrl"] = "https://drive.uber.radio/uber/bollywoodnow/icecast.audio";
        QVariantList tr;
        tr.append(createTrack("O Maahi (From \"Dunki\")", "Pritam, Arijit Singh & Irshad Kamil", "Dunki (Original Soundtrack)", 233,
            "https://is1-ssl.mzstatic.com/image/thumb/Music116/v4/9e/fb/28/9efb2892-c3b1-0c1c-f7a3-3bcccce6346e/8903431975058_cover.jpg/600x600bb.jpg"));
        tr.append(createTrack("Satranga (From \"Animal\")", "Arijit Singh, Shreyas Puranik & Siddharth-Garima", "Animal (Original Soundtrack)", 271,
            "https://is1-ssl.mzstatic.com/image/thumb/Music126/v4/a4/09/25/a409252c-7b06-ee06-d0ae-b86f481c8567/8903431969644_cover.jpg/600x600bb.jpg"));
        tr.append(createTrack("Pehle Bhi Main", "Vishal Mishra & Raj Shekhar", "Animal (Original Soundtrack)", 250,
            "https://is1-ssl.mzstatic.com/image/thumb/Music126/v4/a4/09/25/a409252c-7b06-ee06-d0ae-b86f481c8567/8903431969644_cover.jpg/600x600bb.jpg"));
        ch["tracks"] = tr;
        m_sxmChannels.append(ch);
    }

    // Ch 3: Orbit Ishq & Melodies
    {
        QVariantMap ch;
        ch["number"] = 3;
        ch["name"] = "Orbit Ishq & Melodies";
        ch["tagline"] = "Pure Romantic Hindi Melodies";
        ch["category"] = "Love Melodies & Ballads";
        ch["badgeText"] = "ISHQ";
        ch["badgeColor"] = "#EC4899";
        ch["logoUrl"] = "qrc:/ApexVision/qml/assets/radio_logos/sxm_ishq.png";
        ch["streamUrl"] = "https://drive.uber.radio/uber/bollywoodlove/icecast.audio";
        QVariantList tr;
        tr.append(createTrack("Tum Hi Ho", "Arijit Singh & Mithoon", "Aashiqui 2", 262,
            "https://is1-ssl.mzstatic.com/image/thumb/Music115/v4/80/47/31/804731ea-1f41-01f1-b9ea-fef1cf530f28/8902894354228_cover.jpg/600x600bb.jpg"));
        tr.append(createTrack("Raataan Lambiyan", "Tanishk Bagchi, Jubin Nautiyal & Asees Kaur", "Shershaah", 230,
            "https://is1-ssl.mzstatic.com/image/thumb/Music125/v4/71/84/c4/7184c478-f7b5-276e-3fa1-a7b6cf3c14d6/22UMGIM70025.rgb.jpg/600x600bb.jpg"));
        tr.append(createTrack("Pee Loon", "Mohit Chauhan & Pritam", "Once Upon a Time in Mumbaai", 287,
            "https://is1-ssl.mzstatic.com/image/thumb/Music124/v4/5a/8e/58/5a8e5831-2921-5a21-7170-0ea52e79603e/8902894350114_cover.jpg/600x600bb.jpg"));
        ch["tracks"] = tr;
        m_sxmChannels.append(ch);
    }

    // Ch 4: Orbit Retro Deewane
    {
        QVariantMap ch;
        ch["number"] = 4;
        ch["name"] = "Orbit Retro Deewane";
        ch["tagline"] = "Golden Classics of 60s, 70s & 80s";
        ch["category"] = "Golden Era Classics";
        ch["badgeText"] = "RETRO";
        ch["badgeColor"] = "#F59E0B";
        ch["logoUrl"] = "qrc:/ApexVision/qml/assets/radio_logos/sxm_retro.png";
        ch["streamUrl"] = "https://azuracast.vibesounds.in:8010/radio.mp3";
        QVariantList tr;
        tr.append(createTrack("Pal Pal Dil Ke Paas", "Kishore Kumar & Kalyanji-Anandji", "Blackmail", 329,
            "https://is1-ssl.mzstatic.com/image/thumb/Music126/v4/18/2c/fd/182cfdb1-c27a-8d41-d58a-fca4ff017c69/06UMGIM37432.rgb.jpg/600x600bb.jpg"));
        tr.append(createTrack("Lag Jaa Gale", "Lata Mangeshkar & Madan Mohan", "Woh Kaun Thi", 259,
            "https://is1-ssl.mzstatic.com/image/thumb/Music115/v4/ca/87/42/ca8742b7-a36c-9407-e85c-1ec71ebcf2b5/886443315714.jpg/600x600bb.jpg"));
        tr.append(createTrack("Chura Liya Hai Tumne Jo Dil Ko", "Asha Bhosle, Mohd. Rafi & R.D. Burman", "Yaadon Ki Baaraat", 288,
            "https://is1-ssl.mzstatic.com/image/thumb/Music125/v4/8e/3c/6e/8e3c6e9d-16a8-21d9-5e92-3ef80fbe9182/074643811224.jpg/600x600bb.jpg"));
        ch["tracks"] = tr;
        m_sxmChannels.append(ch);
    }

    // Ch 5: Orbit 90s & 2000s Rewind
    {
        QVariantMap ch;
        ch["number"] = 5;
        ch["name"] = "Orbit 90s & 2000s Rewind";
        ch["tagline"] = "Nostalgic 90s & Millennium Anthems";
        ch["category"] = "90s & 2000s Nostalgia";
        ch["badgeText"] = "90s HITS";
        ch["badgeColor"] = "#06B6D4";
        ch["logoUrl"] = "qrc:/ApexVision/qml/assets/radio_logos/sxm_90srewind.png";
        ch["streamUrl"] = "https://drive.uber.radio/uber/bollywood2010s/icecast.audio";
        QVariantList tr;
        tr.append(createTrack("O Sanam", "Lucky Ali", "Sunoh", 228,
            "https://is1-ssl.mzstatic.com/image/thumb/Music115/v4/5a/bd/a1/5abda1be-3897-4402-9bc3-c3c13ff9d5fe/081227845323.jpg/600x600bb.jpg"));
        tr.append(createTrack("Chaiyya Chaiyya", "Sukhwinder Singh, Sapna Awasthi & A.R. Rahman", "Dil Se", 394,
            "https://is1-ssl.mzstatic.com/image/thumb/Music125/v4/a4/c8/f5/a4c8f5d0-94cb-5e76-0aa7-11e4bf5bdfbd/00008811082025.rgb.jpg/600x600bb.jpg"));
        tr.append(createTrack("Tujhe Dekha Toh", "Kumar Sanu, Lata Mangeshkar & Jatin-Lalit", "Dilwale Dulhania Le Jayenge", 302,
            "https://is1-ssl.mzstatic.com/image/thumb/Music126/v4/05/88/48/0588484e-cb50-1361-b4ec-ca359b8a8b13/23UMGIM08253.rgb.jpg/600x600bb.jpg"));
        ch["tracks"] = tr;
        m_sxmChannels.append(ch);
    }

    // Ch 7: Orbit Punjabi Swag
    {
        QVariantMap ch;
        ch["number"] = 7;
        ch["name"] = "Orbit Punjabi Swag";
        ch["tagline"] = "High-Octane Punjabi & Bhangra Hits";
        ch["category"] = "Punjabi & Desi Beats";
        ch["badgeText"] = "PUNJABI";
        ch["badgeColor"] = "#EA580C";
        ch["logoUrl"] = "qrc:/ApexVision/qml/assets/radio_logos/sxm_punjabi.png";
        ch["streamUrl"] = "https://bolpunjabi-ekamsoftware.radioca.st/stream";
        QVariantList tr;
        tr.append(createTrack("Lover", "Diljit Dosanjh", "MoonChild Era", 188,
            "https://is1-ssl.mzstatic.com/image/thumb/Music126/v4/8a/89/e4/8a89e445-d2c6-f8ac-a828-27818b0c1afe/859749638209_cover.jpg/600x600bb.jpg"));
        tr.append(createTrack("Excuses", "AP Dhillon & Gurinder Gill", "Hidden Gems", 176,
            "https://is1-ssl.mzstatic.com/image/thumb/Music126/v4/21/5d/47/215d4705-7243-7f28-b996-5fc7a303664d/23UMGIM92186.rgb.jpg/600x600bb.jpg"));
        tr.append(createTrack("Softly", "Karan Aujla & Ikky", "Making Memories", 154,
            "https://is1-ssl.mzstatic.com/image/thumb/Music116/v4/0d/bb/9d/0dbb9d5c-d784-a162-8178-50608fa8fa70/24UMGIM56461.rgb.jpg/600x600bb.jpg"));
        ch["tracks"] = tr;
        m_sxmChannels.append(ch);
    }

    // Ch 8: Orbit South Hits
    {
        QVariantMap ch;
        ch["number"] = 8;
        ch["name"] = "Orbit South Hits";
        ch["tagline"] = "Tamil, Telugu & South Superhits";
        ch["category"] = "Tamil & Telugu Hits";
        ch["badgeText"] = "SOUTH";
        ch["badgeColor"] = "#0284C7";
        ch["logoUrl"] = "qrc:/ApexVision/qml/assets/radio_logos/sxm_southwave.png";
        ch["streamUrl"] = "http://s2.voscast.com:12084/;stream1619441439791/1";
        QVariantList tr;
        tr.append(createTrack("Hukum - Thalaivar Alappara", "Anirudh Ravichander & Super Subu", "Jailer", 207,
            "https://is1-ssl.mzstatic.com/image/thumb/Music116/v4/2c/df/14/2cdf140e-6d11-a98d-bfbf-bc5e30c3c4a1/197189528187.jpg/600x600bb.jpg"));
        tr.append(createTrack("Badass", "Anirudh Ravichander", "Leo", 229,
            "https://is1-ssl.mzstatic.com/image/thumb/Music126/v4/38/20/df/3820df38-04fb-16d7-ff0d-7cae1279a0eb/191404130026.png/600x600bb.jpg"));
        tr.append(createTrack("Naatu Naatu", "M.M. Keeravaani, Rahul Sipligunj & Kaala Bhairava", "RRR", 215,
            "https://is1-ssl.mzstatic.com/image/thumb/Music116/v4/55/7c/f8/557cf897-4fa5-ef80-1a73-95804ca4cba2/886444391694.jpg/600x600bb.jpg"));
        ch["tracks"] = tr;
        m_sxmChannels.append(ch);
    }

    // Ch 25: GTA Flash FM
    {
        QVariantMap ch;
        ch["number"] = 25;
        ch["name"] = "GTA Flash FM";
        ch["tagline"] = "Vice City 80s Pop & Synth Anthems";
        ch["category"] = "GTA 80s Pop & Synth";
        ch["badgeText"] = "FLASH FM";
        ch["badgeColor"] = "#D946EF";
        ch["logoUrl"] = "qrc:/ApexVision/qml/assets/radio_logos/sxm_gtaflash.png";
        ch["streamUrl"] = "http://stream.laut.fm/gta-classics";
        QVariantList tr;
        tr.append(createTrack("Out of Touch", "Daryl Hall & John Oates", "Vice City Flash FM", 261,
            "qrc:/ApexVision/qml/assets/station_art/art_gtaflash.jpg"));
        tr.append(createTrack("Billie Jean", "Michael Jackson", "Vice City Flash FM", 294,
            "qrc:/ApexVision/qml/assets/station_art/art_gtaflash.jpg"));
        tr.append(createTrack("Self Control", "Laura Branigan", "Vice City Flash FM", 248,
            "qrc:/ApexVision/qml/assets/station_art/art_gtaflash.jpg"));
        ch["tracks"] = tr;
        m_sxmChannels.append(ch);
    }

    // Ch 26: GTA Los Santos Rock
    {
        QVariantMap ch;
        ch["number"] = 26;
        ch["name"] = "GTA Los Santos Rock";
        ch["tagline"] = "Classic Driving Rock & Anthems";
        ch["category"] = "GTA Classic Rock";
        ch["badgeText"] = "LS ROCK";
        ch["badgeColor"] = "#D97706";
        ch["logoUrl"] = "qrc:/ApexVision/qml/assets/radio_logos/sxm_gtalsrock.png";
        ch["streamUrl"] = "https://icecast.walmradio.com:8443/classic";
        QVariantList tr;
        tr.append(createTrack("Radio Ga Ga", "Queen", "Los Santos Rock Radio", 344,
            "qrc:/ApexVision/qml/assets/station_art/art_gtalsrock.jpg"));
        tr.append(createTrack("Hold the Line", "Toto", "Los Santos Rock Radio", 236,
            "qrc:/ApexVision/qml/assets/station_art/art_gtalsrock.jpg"));
        tr.append(createTrack("Danger Zone", "Kenny Loggins", "Los Santos Rock Radio", 215,
            "qrc:/ApexVision/qml/assets/station_art/art_gtalsrock.jpg"));
        ch["tracks"] = tr;
        m_sxmChannels.append(ch);
    }

    // Ch 34: GTA Non-Stop-Pop FM
    {
        QVariantMap ch;
        ch["number"] = 34;
        ch["name"] = "GTA Non-Stop-Pop FM";
        ch["tagline"] = "Pop Anthems Hosted by Cara Delevingne";
        ch["category"] = "GTA Pop & Dance";
        ch["badgeText"] = "NON STOP";
        ch["badgeColor"] = "#14B8A6";
        ch["logoUrl"] = "qrc:/ApexVision/qml/assets/radio_logos/sxm_gtanonstoppop.png";
        ch["streamUrl"] = "https://dancewave.online/dance.mp3";
        QVariantList tr;
        tr.append(createTrack("Midnight City", "M83", "Non-Stop-Pop FM", 243,
            "qrc:/ApexVision/qml/assets/station_art/art_gtanonstop.jpg"));
        tr.append(createTrack("Lady (Hear Me Tonight)", "Modjo", "Non-Stop-Pop FM", 306,
            "qrc:/ApexVision/qml/assets/station_art/art_gtanonstop.jpg"));
        tr.append(createTrack("Music Sounds Better with You", "Stardust", "Non-Stop-Pop FM", 262,
            "qrc:/ApexVision/qml/assets/station_art/art_gtanonstop.jpg"));
        ch["tracks"] = tr;
        m_sxmChannels.append(ch);
    }

    // Ch 36: GTA Radio Los Santos
    {
        QVariantMap ch;
        ch["number"] = 36;
        ch["name"] = "GTA Radio Los Santos";
        ch["tagline"] = "West Coast Rap & Modern Hip-Hop";
        ch["category"] = "GTA West Coast Rap";
        ch["badgeText"] = "LOS SANTOS";
        ch["badgeColor"] = "#64748B";
        ch["logoUrl"] = "qrc:/ApexVision/qml/assets/radio_logos/sxm_gtaradiols.png";
        ch["streamUrl"] = "http://listen.181fm.com/181-oldschool_128k.mp3";
        QVariantList tr;
        tr.append(createTrack("The Next Episode", "Dr. Dre ft. Snoop Dogg", "Radio Los Santos", 161,
            "qrc:/ApexVision/qml/assets/station_art/art_gtaradiols.jpg"));
        tr.append(createTrack("It Was a Good Day", "Ice Cube", "Radio Los Santos", 260,
            "qrc:/ApexVision/qml/assets/station_art/art_gtaradiols.jpg"));
        tr.append(createTrack("Ambitionz Az a Ridah", "2Pac", "Radio Los Santos", 279,
            "qrc:/ApexVision/qml/assets/station_art/art_gtaradiols.jpg"));
        ch["tracks"] = tr;
        m_sxmChannels.append(ch);
    }

    // Ch 37: Orbit Desi Hip-Hop
    {
        QVariantMap ch;
        ch["number"] = 37;
        ch["name"] = "Orbit Desi Hip-Hop";
        ch["tagline"] = "Authentic Gully Rap & Indian Hip-Hop";
        ch["category"] = "Indian Street Rap";
        ch["badgeText"] = "DESI RAP";
        ch["badgeColor"] = "#DC2626";
        ch["logoUrl"] = "qrc:/ApexVision/qml/assets/radio_logos/sxm_desihiphop.png";
        ch["streamUrl"] = "https://drive.uber.radio/uber/bollywooddance/icecast.audio";
        QVariantList tr;
        tr.append(createTrack("Kohinoor", "DIVINE", "Kohinoor", 192,
            "https://is1-ssl.mzstatic.com/image/thumb/Music126/v4/21/5d/47/215d4705-7243-7f28-b996-5fc7a303664d/23UMGIM92186.rgb.jpg/600x600bb.jpg"));
        tr.append(createTrack("Maan Meri Jaan", "King", "Champagne Talk", 194,
            "https://is1-ssl.mzstatic.com/image/thumb/Music126/v4/05/88/48/0588484e-cb50-1361-b4ec-ca359b8a8b13/23UMGIM08253.rgb.jpg/600x600bb.jpg"));
        tr.append(createTrack("Prarthana", "KR$NA", "Far From Over", 175,
            "https://is1-ssl.mzstatic.com/image/thumb/Music211/v4/31/76/89/3176892e-1317-09f1-325b-ae293b6e76cf/093624844395.jpg/600x600bb.jpg"));
        ch["tracks"] = tr;
        m_sxmChannels.append(ch);
    }

    // Ch 44: Orbit Indie & Acoustic
    {
        QVariantMap ch;
        ch["number"] = 44;
        ch["name"] = "Orbit Indie & Acoustic";
        ch["tagline"] = "Independent Indian Music & Acoustic Vibes";
        ch["category"] = "Acoustic & Indie Pop";
        ch["badgeText"] = "INDIE";
        ch["badgeColor"] = "#10B981";
        ch["logoUrl"] = "qrc:/ApexVision/qml/assets/radio_logos/sxm_indie.png";
        ch["streamUrl"] = "http://novazz.ice.infomaniak.ch/novazz-128.mp3";
        QVariantList tr;
        tr.append(createTrack("Husn", "Anuv Jain", "Husn - Single", 217,
            "https://is1-ssl.mzstatic.com/image/thumb/Music211/v4/e5/5a/09/e55a0928-8d5f-8367-ee19-21df348e35cf/5054197943015.jpg/600x600bb.jpg"));
        tr.append(createTrack("cold/mess", "Prateek Kuhad", "cold/mess", 278,
            "https://is1-ssl.mzstatic.com/image/thumb/Music116/v4/fb/04/c2/fb04c2c5-555e-2f7d-080c-a61f22e70757/5054197873831.jpg/600x600bb.jpg"));
        tr.append(createTrack("Liggi", "Ritviz", "DEV", 181,
            "https://is1-ssl.mzstatic.com/image/thumb/Music125/v4/5f/85/3b/5f853b06-e69c-bc06-a05e-ff6fa40590a9/19UMGIM53909.rgb.jpg/600x600bb.jpg"));
        ch["tracks"] = tr;
        m_sxmChannels.append(ch);
    }

    // Ch 45: Orbit Bangla Modern
    {
        QVariantMap ch;
        ch["number"] = 45;
        ch["name"] = "Orbit Bangla Modern";
        ch["tagline"] = "Modern Bengali Hits & Contemporary Rock";
        ch["category"] = "Modern Bengali & Rock";
        ch["badgeText"] = "BANGLA";
        ch["badgeColor"] = "#7C3AED";
        ch["logoUrl"] = "qrc:/ApexVision/qml/assets/radio_logos/sxm_bangla.png";
        ch["streamUrl"] = "https://server.mixify.in/listen/bangla/radio.mp3";
        QVariantList tr;
        tr.append(createTrack("Amake Amar Moto (Original)", "Anupam Roy", "Durbine Chokh Rakhbo Na", 318,
            "https://is1-ssl.mzstatic.com/image/thumb/Music122/v4/50/53/91/505391c7-53c2-2488-e97d-0003c47fe3d4/840123901446.png/600x600bb.jpg"));
        tr.append(createTrack("Bojhena Shey Bojhena", "Arijit Singh", "Bojhena Shey Bojhena Soundtrack", 270,
            "https://is1-ssl.mzstatic.com/image/thumb/Music221/v4/0f/38/b3/0f38b370-6900-5ee0-5d2b-a88dce220c7e/840123902955.png/600x600bb.jpg"));
        tr.append(createTrack("Hasnuhana", "Fossils", "Fossils 2", 295,
            "https://is1-ssl.mzstatic.com/image/thumb/Music115/v4/ca/87/42/ca8742b7-a36c-9407-e85c-1ec71ebcf2b5/886443315714.jpg/600x600bb.jpg"));
        ch["tracks"] = tr;
        m_sxmChannels.append(ch);
    }

    // Ch 51: Orbit Acoustic Sessions (Radio Paradise Stream)
    {
        QVariantMap ch;
        ch["number"] = 51;
        ch["name"] = "Orbit Acoustic Sessions";
        ch["tagline"] = "Acoustic, Indie Folk, Singer-Songwriters & Soul";
        ch["category"] = "Acoustic & Folk";
        ch["badgeText"] = "ACOUSTIC";
        ch["badgeColor"] = "#0D9488";
        ch["logoUrl"] = "qrc:/ApexVision/qml/assets/radio_logos/sxm_acoustic.png";
        ch["streamUrl"] = "http://stream-uk1.radioparadise.com/aac-320";
        QVariantList tr;
        tr.append(createTrack("The Sound of Silence", "Simon & Garfunkel", "Wednesday Morning, 3 A.M.", 185,
            "https://is1-ssl.mzstatic.com/image/thumb/Music115/v4/bf/fb/fb/bfffb34c-6229-28c0-5eb8-2895f573efea/886443422201.jpg/600x600bb.jpg"));
        tr.append(createTrack("Fast Car", "Tracy Chapman", "Tracy Chapman", 296,
            "https://is1-ssl.mzstatic.com/image/thumb/Music118/v4/4b/32/34/4b3234d8-7967-b5bb-41a4-ae28f2dbd162/075596077468.jpg/600x600bb.jpg"));
        tr.append(createTrack("Heart of Gold", "Neil Young", "Harvest", 187,
            "https://is1-ssl.mzstatic.com/image/thumb/Music114/v4/80/f3/f0/80f3f01b-9e45-d419-74d4-2826cfcbb612/093624979357.jpg/600x600bb.jpg"));
        tr.append(createTrack("Skinny Love", "Bon Iver", "For Emma, Forever Ago", 239,
            "https://is1-ssl.mzstatic.com/image/thumb/Music115/v4/ff/c2/be/ffc2be5c-a521-42e1-45df-9226cbb1734a/656605211563.jpg/600x600bb.jpg"));
        ch["tracks"] = tr;
        m_sxmChannels.append(ch);
    }

    // Ch 56: Orbit Bhakti & Dhyan
    {
        QVariantMap ch;
        ch["number"] = 56;
        ch["name"] = "Orbit Bhakti & Dhyan";
        ch["tagline"] = "Morning Mantras, Sacred Bhajans & Peace";
        ch["category"] = "Devotional & Meditation";
        ch["badgeText"] = "BHAKTI";
        ch["badgeColor"] = "#F97316";
        ch["logoUrl"] = "qrc:/ApexVision/qml/assets/radio_logos/sxm_bhakti.png";
        ch["streamUrl"] = "http://radio2bindia.out.airtime.pro:8000/radio2bindia_a";
        QVariantList tr;
        tr.append(createTrack("Gayatri Mantra", "Anuradha Paudwal", "Sacred Morning Chants", 312,
            "qrc:/ApexVision/qml/assets/station_art/art_bhakti.jpg"));
        tr.append(createTrack("Hanuman Chalisa", "Hariharan & Gulshan Kumar", "Shree Hanuman Chalisa", 580,
            "qrc:/ApexVision/qml/assets/station_art/art_bhakti.jpg"));
        tr.append(createTrack("Achyutam Keshavam", "Vikram Hazra", "Art of Living Bhajans", 330,
            "qrc:/ApexVision/qml/assets/station_art/art_bhakti.jpg"));
        ch["tracks"] = tr;
        m_sxmChannels.append(ch);
    }

    // Ch 66: Orbit Classical Ragas
    {
        QVariantMap ch;
        ch["number"] = 66;
        ch["name"] = "Orbit Classical Ragas";
        ch["tagline"] = "Archival Sitar, Sarod & Raga Masters";
        ch["category"] = "Indian Classical Instrumental";
        ch["badgeText"] = "RAGAS";
        ch["badgeColor"] = "#0284C7";
        ch["logoUrl"] = "qrc:/ApexVision/qml/assets/radio_logos/sxm_ragas.png";
        ch["streamUrl"] = "https://airhlspush.pc.cdn.bitgravity.com/httppush/hlspbaudio028/hlspbaudio02864kbps.m3u8";
        QVariantList tr;
        tr.append(createTrack("Raga Yaman (Sitar Drut)", "Pt. Ravi Shankar & Ustad Alla Rakha", "Masterworks of Sitar", 480,
            "https://is1-ssl.mzstatic.com/image/thumb/Music125/v4/a4/c8/f5/a4c8f5d0-94cb-5e76-0aa7-11e4bf5bdfbd/00008811082025.rgb.jpg/600x600bb.jpg"));
        tr.append(createTrack("Raga Bhairavi", "Ustad Bismillah Khan", "Shehnai Maestro", 420,
            "https://is1-ssl.mzstatic.com/image/thumb/Music115/v4/5a/bd/a1/5abda1be-3897-4402-9bc3-c3c13ff9d5fe/081227845323.jpg/600x600bb.jpg"));
        tr.append(createTrack("Teental Solo", "Ustad Zakir Hussain", "Tabla Beat Science", 360,
            "https://is1-ssl.mzstatic.com/image/thumb/Music115/v4/3d/8b/6e/3d8b6e22-e421-4f93-0182-4467d30c5e3d/081227970933.jpg/600x600bb.jpg"));
        ch["tracks"] = tr;
        m_sxmChannels.append(ch);
    }

    // Ch 80: Orbit Cricket Live
    {
        QVariantMap ch;
        ch["number"] = 80;
        ch["name"] = "Orbit Cricket Live";
        ch["tagline"] = "Live Ball-by-Ball Match Audio & Talk";
        ch["category"] = "Live Sports & Cricket";
        ch["badgeText"] = "CRICKET";
        ch["badgeColor"] = "#B91C1C";
        ch["logoUrl"] = "qrc:/ApexVision/qml/assets/radio_logos/sxm_cricket.png";
        ch["streamUrl"] = "https://live.amperwave.net/direct/goodkarma-wmvpammp3-ibc1";
        QVariantList tr;
        tr.append(createTrack("India Match Center Live", "AIR Cricket & Sports Network", "Live Commentary", 3600,
            "qrc:/ApexVision/qml/assets/station_art/art_cricket_live.jpg"));
        tr.append(createTrack("Pitch Report & Analysis", "Harsha Bhogle & Cricket Experts", "Daily Match Preview", 3600,
            "qrc:/ApexVision/qml/assets/station_art/art_cricket_live.jpg"));
        ch["tracks"] = tr;
        m_sxmChannels.append(ch);
    }

    // Ch 114: Orbit Samachar 24/7
    {
        QVariantMap ch;
        ch["number"] = 114;
        ch["name"] = "Orbit Samachar 24/7";
        ch["tagline"] = "National Breaking News & Current Affairs";
        ch["category"] = "National News & Headlines";
        ch["badgeText"] = "SAMACHAR";
        ch["badgeColor"] = "#1D4ED8";
        ch["logoUrl"] = "qrc:/ApexVision/qml/assets/radio_logos/sxm_samachar.png";
        ch["streamUrl"] = "https://airhlspush.pc.cdn.bitgravity.com/httppush/hlspbaudio005/hlspbaudio00564kbps.m3u8";
        QVariantList tr;
        tr.append(createTrack("AIR National Samachar Bulletin", "All India Radio News", "Hourly National Headlines", 3600,
            "qrc:/ApexVision/qml/assets/station_art/art_news_air.jpg"));
        tr.append(createTrack("Current Affairs & Spotlight", "National Broadcast Desk", "Daily In-Depth Report", 3600,
            "qrc:/ApexVision/qml/assets/station_art/art_news_air.jpg"));
        ch["tracks"] = tr;
        m_sxmChannels.append(ch);
    }

    // OrbitXM Presets (Bottom preset bar with authentic logos downloaded from the internet)
    m_sxmPresets.clear();
    m_sxmPresets.append(QVariantMap{{"number", 0}, {"name", "Hold To Set"}, {"isHoldToSet", true}, {"logoUrl", ""}});
    m_sxmPresets.append(QVariantMap{{"number", 2}, {"name", "Bollywood Hits"}, {"isHoldToSet", false}, {"logoUrl", "qrc:/ApexVision/qml/assets/radio_logos/sxm_bollywood.png"}});
    m_sxmPresets.append(QVariantMap{{"number", 3}, {"name", "Ishq & Melodies"}, {"isHoldToSet", false}, {"logoUrl", "qrc:/ApexVision/qml/assets/radio_logos/sxm_ishq.png"}});
    m_sxmPresets.append(QVariantMap{{"number", 4}, {"name", "Retro Deewane"}, {"isHoldToSet", false}, {"logoUrl", "qrc:/ApexVision/qml/assets/radio_logos/sxm_retro.png"}});
    m_sxmPresets.append(QVariantMap{{"number", 5}, {"name", "90s Rewind"}, {"isHoldToSet", false}, {"logoUrl", "qrc:/ApexVision/qml/assets/radio_logos/sxm_90srewind.png"}});
    m_sxmPresets.append(QVariantMap{{"number", 7}, {"name", "Punjabi Swag"}, {"isHoldToSet", false}, {"logoUrl", "qrc:/ApexVision/qml/assets/radio_logos/sxm_punjabi.png"}});
    m_sxmPresets.append(QVariantMap{{"number", 8}, {"name", "South Hits"}, {"isHoldToSet", false}, {"logoUrl", "qrc:/ApexVision/qml/assets/radio_logos/sxm_southwave.png"}});
    m_sxmPresets.append(QVariantMap{{"number", 25}, {"name", "Flash FM"}, {"isHoldToSet", false}, {"logoUrl", "qrc:/ApexVision/qml/assets/radio_logos/sxm_gtaflash.png"}});
    m_sxmPresets.append(QVariantMap{{"number", 26}, {"name", "LS Rock Radio"}, {"isHoldToSet", false}, {"logoUrl", "qrc:/ApexVision/qml/assets/radio_logos/sxm_gtalsrock.png"}});
    m_sxmPresets.append(QVariantMap{{"number", 34}, {"name", "Non-Stop-Pop"}, {"isHoldToSet", false}, {"logoUrl", "qrc:/ApexVision/qml/assets/radio_logos/sxm_gtanonstoppop.png"}});
    m_sxmPresets.append(QVariantMap{{"number", 36}, {"name", "Radio Los Santos"}, {"isHoldToSet", false}, {"logoUrl", "qrc:/ApexVision/qml/assets/radio_logos/sxm_gtaradiols.png"}});
    m_sxmPresets.append(QVariantMap{{"number", 37}, {"name", "Desi Hip-Hop"}, {"isHoldToSet", false}, {"logoUrl", "qrc:/ApexVision/qml/assets/radio_logos/sxm_desihiphop.png"}});
    m_sxmPresets.append(QVariantMap{{"number", 44}, {"name", "Orbit Indie"}, {"isHoldToSet", false}, {"logoUrl", "qrc:/ApexVision/qml/assets/radio_logos/sxm_indie.png"}});
    m_sxmPresets.append(QVariantMap{{"number", 45}, {"name", "Bangla Modern"}, {"isHoldToSet", false}, {"logoUrl", "qrc:/ApexVision/qml/assets/radio_logos/sxm_bangla.png"}});
    m_sxmPresets.append(QVariantMap{{"number", 51}, {"name", "Acoustic Sessions"}, {"isHoldToSet", false}, {"logoUrl", "qrc:/ApexVision/qml/assets/radio_logos/sxm_acoustic.png"}});
    m_sxmPresets.append(QVariantMap{{"number", 56}, {"name", "Bhakti & Dhyan"}, {"isHoldToSet", false}, {"logoUrl", "qrc:/ApexVision/qml/assets/radio_logos/sxm_bhakti.png"}});
    m_sxmPresets.append(QVariantMap{{"number", 66}, {"name", "Classical Ragas"}, {"isHoldToSet", false}, {"logoUrl", "qrc:/ApexVision/qml/assets/radio_logos/sxm_ragas.png"}});
    m_sxmPresets.append(QVariantMap{{"number", 80}, {"name", "Cricket Live"}, {"isHoldToSet", false}, {"logoUrl", "qrc:/ApexVision/qml/assets/radio_logos/sxm_cricket.png"}});
    m_sxmPresets.append(QVariantMap{{"number", 114}, {"name", "Samachar 24/7"}, {"isHoldToSet", false}, {"logoUrl", "qrc:/ApexVision/qml/assets/radio_logos/sxm_samachar.png"}});

    m_currentSxmChannelIndex = 0; // Start on Ch 2: Orbit Bollywood Hits
    m_currentSxmTrackIndex = 0;
    m_activeSxmPresetIndex = 1; // Orbit Bollywood Hits is Preset 1

    emit sxmChannelsChanged();
    emit sxmPresetsChanged();
    emit activeSxmPresetIndexChanged();
}

void MediaBackend::syncSxmWithMedia()
{
    if (m_currentSxmChannelIndex < 0 || m_currentSxmChannelIndex >= m_sxmChannels.size()) {
        m_currentSxmChannelIndex = 0;
    }

    QVariantMap ch = m_sxmChannels[m_currentSxmChannelIndex].toMap();
    m_sxmChannelNumber = ch["number"].toInt();
    m_sxmChannelName = ch["name"].toString();
    m_sxmChannelLogoUrl = ch["logoUrl"].toString();
    m_sxmCategory = ch["category"].toString();
    m_sxmTagline = ch["tagline"].toString();

    QVariantList tr = ch["tracks"].toList();
    if (!tr.isEmpty()) {
        if (m_currentSxmTrackIndex < 0 || m_currentSxmTrackIndex >= tr.size()) {
            m_currentSxmTrackIndex = 0;
        }
        QVariantMap t = tr[m_currentSxmTrackIndex].toMap();
        m_sxmSongTitle = t["title"].toString();
        m_sxmArtist = t["artist"].toString();
        m_sxmAlbum = t["album"].toString();
        m_duration = t["duration"].toInt() > 0 ? t["duration"].toInt() : 180;
        m_progress = 42; // standard progress offset
        if (!t["artwork"].toString().isEmpty()) {
            m_sxmArtworkUrl = t["artwork"].toString();
        }
    }

    // Synchronize generic media fields for home cards & top bar
    m_frequency = QString("Ch %1").arg(m_sxmChannelNumber);
    m_station = m_sxmChannelName;
    m_trackTitle = m_sxmSongTitle;
    m_artist = m_sxmArtist;
    m_isHdRadio = true;

    emit sxmChannelChanged();
    emit sxmTrackChanged();
    emit frequencyChanged();
    emit stationChanged();
    emit trackTitleChanged();
    emit artistChanged();
    emit isHdRadioChanged();
    emit progressChanged();
    emit durationChanged();
}

void MediaBackend::playCurrentSxmChannel()
{
    syncSxmWithMedia();

    if (m_currentSxmChannelIndex >= 0 && m_currentSxmChannelIndex < m_sxmChannels.size()) {
        QVariantMap ch = m_sxmChannels[m_currentSxmChannelIndex].toMap();
        QString streamUrl = ch["streamUrl"].toString();
        if (!streamUrl.isEmpty() && m_mediaPlayer) {
            QUrl targetUrl(streamUrl);
            if (m_mediaPlayer->source() != targetUrl) {
                m_mediaPlayer->setSource(targetUrl);
            }
            m_mediaPlayer->play();
            m_isPlaying = true;
            emit isPlayingChanged();
        }
        if (!streamUrl.isEmpty()) {
            fetchLiveIcyMetadata(streamUrl);
        }
    }

    // Always fetch fresh album art online as well
    fetchOnlineSxmArt(m_sxmArtist, m_sxmSongTitle);
}

void MediaBackend::fetchLiveIcyMetadata(const QString &streamUrl)
{
    if (!m_networkManager || streamUrl.isEmpty()) return;

    // Skip ICY probing on HLS m3u8 streams
    if (streamUrl.endsWith(".m3u8", Qt::CaseInsensitive)) {
        return;
    }

    if (m_icyMetadataReply) {
        m_icyMetadataReply->abort();
        m_icyMetadataReply->deleteLater();
        m_icyMetadataReply = nullptr;
    }

    QNetworkRequest req((QUrl(streamUrl)));
    req.setRawHeader("Icy-MetaData", "1");
    req.setRawHeader("User-Agent", "VLC/3.0.18");

    m_icyMetadataReply = m_networkManager->get(req);
    QPointer<QNetworkReply> replyPtr(m_icyMetadataReply);

    // Timeout safety: close probe after 4 seconds
    QTimer::singleShot(4000, this, [this, replyPtr]() {
        if (replyPtr) {
            if (replyPtr == m_icyMetadataReply) {
                m_icyMetadataReply = nullptr;
            }
            replyPtr->abort();
            replyPtr->deleteLater();
        }
    });

    auto buffer = std::make_shared<QByteArray>();

    connect(m_icyMetadataReply, &QNetworkReply::readyRead, this, [this, replyPtr, buffer]() {
        if (!replyPtr) return;

        buffer->append(replyPtr->readAll());
        int metaint = replyPtr->rawHeader("icy-metaint").toInt();
        if (metaint <= 0) {
            if (buffer->size() > 48 * 1024) {
                if (replyPtr == m_icyMetadataReply) {
                    m_icyMetadataReply = nullptr;
                }
                replyPtr->abort();
                replyPtr->deleteLater();
            }
            return;
        }

        if (buffer->size() >= metaint + 1) {
            unsigned char lenByte = static_cast<unsigned char>((*buffer)[metaint]);
            int metaLen = lenByte * 16;
            if (metaLen > 0 && buffer->size() >= metaint + 1 + metaLen) {
                QString metaStr = QString::fromUtf8(buffer->mid(metaint + 1, metaLen));
                int titleStart = metaStr.indexOf("StreamTitle='");
                if (titleStart != -1) {
                    titleStart += 13;
                    int titleEnd = metaStr.indexOf("';", titleStart);
                    if (titleEnd == -1) titleEnd = metaStr.indexOf("'", titleStart);
                    if (titleEnd != -1) {
                        QString rawTitle = metaStr.mid(titleStart, titleEnd - titleStart).trimmed();
                        rawTitle.remove(QRegularExpression("§\\d+"));
                        rawTitle = rawTitle.simplified();

                        if (!rawTitle.isEmpty()) {
                            QString artist;
                            QString song;
                            int sep = rawTitle.indexOf(" - ");
                            if (sep != -1) {
                                artist = rawTitle.left(sep).trimmed();
                                song = rawTitle.mid(sep + 3).trimmed();
                            } else {
                                song = rawTitle;
                                artist = m_sxmChannelName;
                            }

                            artist.remove(QRegularExpression("^\\d+\\s+"));
                            song.remove(QRegularExpression("^\\d+\\s+"));

                            if (!song.isEmpty() && !song.startsWith("http", Qt::CaseInsensitive) && !song.contains("Tracklist", Qt::CaseInsensitive)) {
                                m_sxmArtist = artist;
                                m_sxmSongTitle = song;
                                m_trackTitle = song;
                                m_artist = artist;
                                emit sxmTrackChanged();
                                emit trackTitleChanged();
                                emit artistChanged();

                                // Automatically fetch online Apple Music album artwork for this real track
                                fetchOnlineSxmArt(artist, song);
                            }
                        }
                    }
                }
                if (replyPtr == m_icyMetadataReply) {
                    m_icyMetadataReply = nullptr;
                }
                replyPtr->abort();
                replyPtr->deleteLater();
            } else if (metaLen == 0 && buffer->size() >= metaint * 2) {
                if (replyPtr == m_icyMetadataReply) {
                    m_icyMetadataReply = nullptr;
                }
                replyPtr->abort();
                replyPtr->deleteLater();
            }
        }
    });
}

void MediaBackend::fetchOnlineSxmArt(const QString &artist, const QString &title)
{
    if (!m_networkManager) return;

    // News & Sports talk channels (ESPN Radio Ch 80, Fox News Ch 114) have official high-res broadcast tiles
    if (m_sxmChannelNumber == 80 || m_sxmChannelNumber == 114) {
        return;
    }

    QString query = QString("%1 %2").arg(artist, title);
    QUrl url(QString("https://itunes.apple.com/search?term=%1&entity=song&limit=1")
                 .arg(QString(QUrl::toPercentEncoding(query))));

    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::UserAgentHeader, "ApexVisionIVI/1.0");

    QNetworkReply *reply = m_networkManager->get(request);
    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        reply->deleteLater();
        if (reply->error() == QNetworkReply::NoError) {
            QByteArray data = reply->readAll();
            QJsonDocument doc = QJsonDocument::fromJson(data);
            if (doc.isObject()) {
                QJsonObject root = doc.object();
                QJsonArray results = root["results"].toArray();
                if (!results.isEmpty()) {
                    QJsonObject item = results[0].toObject();
                    QString art = item["artworkUrl100"].toString();
                    art.replace("100x100bb", "600x600bb");
                    if (!art.isEmpty()) {
                        m_sxmArtworkUrl = art;
                    }
                    if (item.contains("trackName")) {
                        m_sxmSongTitle = item["trackName"].toString();
                        m_trackTitle = m_sxmSongTitle;
                    }
                    if (item.contains("artistName")) {
                        m_sxmArtist = item["artistName"].toString();
                        m_artist = m_sxmArtist;
                    }
                    if (item.contains("collectionName")) {
                        m_sxmAlbum = item["collectionName"].toString();
                    }
                    if (item.contains("primaryGenreName")) {
                        m_sxmGenre = item["primaryGenreName"].toString();
                    }
                    if (item.contains("releaseDate")) {
                        QString rel = item["releaseDate"].toString();
                        if (rel.length() >= 4) {
                            m_sxmReleaseYear = rel.left(4);
                        }
                    }
                    if (item.contains("trackTimeMillis")) {
                        int dur = item["trackTimeMillis"].toInt() / 1000;
                        if (dur > 15) {
                            m_duration = dur;
                            emit durationChanged();
                        }
                    }

                    emit sxmTrackChanged();
                    emit trackTitleChanged();
                    emit artistChanged();
                }
            }
        }
    });
}

void MediaBackend::searchAndPlaySxm(const QString &query)
{
    QString q = query.trimmed();
    if (q.isEmpty() || !m_networkManager) return;

    m_isSearchingOnline = true;
    emit isSearchingOnlineChanged();

    // 1. Query worldwide live radio stations first
    QUrl radioUrl(QString("https://all.api.radio-browser.info/json/stations/byname/%1?limit=25")
                      .arg(QString(QUrl::toPercentEncoding(q))));

    QNetworkRequest radioReq(radioUrl);
    radioReq.setHeader(QNetworkRequest::UserAgentHeader, "ApexVisionIVI/1.0");

    QNetworkReply *radioReply = m_networkManager->get(radioReq);
    connect(radioReply, &QNetworkReply::finished, this, [this, radioReply, q]() {
        radioReply->deleteLater();
        m_isSearchingOnline = false;
        emit isSearchingOnlineChanged();

        if (radioReply->error() == QNetworkReply::NoError) {
            QByteArray data = radioReply->readAll();
            QJsonDocument doc = QJsonDocument::fromJson(data);
            if (doc.isArray()) {
                m_onlineSearchResults.clear();
                QJsonArray arr = doc.array();
                for (const QJsonValue &val : arr) {
                    QJsonObject obj = val.toObject();
                    QString stUrl = obj["url_resolved"].toString();
                    if (stUrl.isEmpty()) stUrl = obj["url"].toString();
                    if (!stUrl.startsWith("http")) continue;

                    QVariantMap res;
                    res["name"] = obj["name"].toString().trimmed();
                    res["streamUrl"] = stUrl;
                    res["category"] = obj["tags"].toString().isEmpty() ? "Internet Radio" : obj["tags"].toString();
                    res["country"] = obj["country"].toString();
                    res["favicon"] = obj["favicon"].toString();
                    res["bitrate"] = obj["bitrate"].toInt();
                    m_onlineSearchResults.append(res);
                }
                emit onlineSearchResultsChanged();

                if (!m_onlineSearchResults.isEmpty()) {
                    // Automatically tune and play the top live radio stream!
                    QVariantMap top = m_onlineSearchResults.first().toMap();
                    tuneOnlineStation(top["name"].toString(), top["streamUrl"].toString(), top["category"].toString());
                    return;
                }
            }
        }

        // 2. Fallback: Search iTunes for song / track metadata
        QUrl itunesUrl(QString("https://itunes.apple.com/search?term=%1&entity=song&limit=1")
                           .arg(QString(QUrl::toPercentEncoding(q))));
        QNetworkRequest itReq(itunesUrl);
        itReq.setHeader(QNetworkRequest::UserAgentHeader, "ApexVisionIVI/1.0");

        QNetworkReply *itReply = m_networkManager->get(itReq);
        connect(itReply, &QNetworkReply::finished, this, [this, itReply]() {
            itReply->deleteLater();
            if (itReply->error() == QNetworkReply::NoError) {
                QByteArray itData = itReply->readAll();
                QJsonDocument itDoc = QJsonDocument::fromJson(itData);
                if (itDoc.isObject()) {
                    QJsonObject root = itDoc.object();
                    QJsonArray results = root["results"].toArray();
                    if (!results.isEmpty()) {
                        QJsonObject item = results[0].toObject();
                        if (item.contains("trackName")) {
                            m_sxmSongTitle = item["trackName"].toString();
                            m_trackTitle = m_sxmSongTitle;
                        }
                        if (item.contains("artistName")) {
                            m_sxmArtist = item["artistName"].toString();
                            m_artist = m_sxmArtist;
                        }
                        if (item.contains("collectionName")) {
                            m_sxmAlbum = item["collectionName"].toString();
                        }
                        if (item.contains("primaryGenreName")) {
                            m_sxmGenre = item["primaryGenreName"].toString();
                        }
                        if (item.contains("releaseDate")) {
                            QString rel = item["releaseDate"].toString();
                            if (rel.length() >= 4) {
                                m_sxmReleaseYear = rel.left(4);
                            }
                        }
                        if (item.contains("trackTimeMillis")) {
                            int dur = item["trackTimeMillis"].toInt() / 1000;
                            if (dur > 15) {
                                m_duration = dur;
                                emit durationChanged();
                            }
                        }
                        QString art = item["artworkUrl100"].toString();
                        art.replace("100x100bb", "600x600bb");
                        if (!art.isEmpty()) {
                            m_sxmArtworkUrl = art;
                        }

                        m_progress = 0;
                        emit sxmTrackChanged();
                        emit trackTitleChanged();
                        emit artistChanged();
                        emit progressChanged();

                        QString preview = item["previewUrl"].toString();
                        if (!preview.isEmpty() && m_mediaPlayer) {
                            m_mediaPlayer->setSource(QUrl(preview));
                            if (m_isPlaying) {
                                m_mediaPlayer->play();
                            }
                        }
                    }
                }
            }
        });
    });
}

void MediaBackend::seekProgress(int seconds)
{
    m_progress = qBound(0, seconds, m_duration);
    emit progressChanged();
    if (m_mediaPlayer) {
        m_mediaPlayer->setPosition(static_cast<qint64>(m_progress) * 1000);
    }
}

void MediaBackend::updateActiveSxmPresetIndex()
{
    m_activeSxmPresetIndex = -1;
    for (int i = 0; i < m_sxmPresets.size(); ++i) {
        QVariantMap p = m_sxmPresets[i].toMap();
        if (p["number"].toInt() == m_sxmChannelNumber) {
            m_activeSxmPresetIndex = i;
            break;
        }
    }
    emit activeSxmPresetIndexChanged();
}

void MediaBackend::selectSxmChannel(int channelIndex)
{
    if (channelIndex >= 0 && channelIndex < m_sxmChannels.size()) {
        m_currentSxmChannelIndex = channelIndex;
        m_currentSxmTrackIndex = 0;
        playCurrentSxmChannel();
        updateActiveSxmPresetIndex();
    }
}

void MediaBackend::tuneSxmChannelNumber(int chNum)
{
    for (int i = 0; i < m_sxmChannels.size(); ++i) {
        QVariantMap ch = m_sxmChannels[i].toMap();
        if (ch["number"].toInt() == chNum) {
            selectSxmChannel(i);
            return;
        }
    }
}

void MediaBackend::nextSxmChannel()
{
    if (m_sxmChannels.isEmpty()) return;
    int nextIdx = (m_currentSxmChannelIndex + 1) % m_sxmChannels.size();
    selectSxmChannel(nextIdx);
}

void MediaBackend::prevSxmChannel()
{
    if (m_sxmChannels.isEmpty()) return;
    int prevIdx = (m_currentSxmChannelIndex - 1 + m_sxmChannels.size()) % m_sxmChannels.size();
    selectSxmChannel(prevIdx);
}

void MediaBackend::nextSxmTrack()
{
    if (m_currentSxmChannelIndex >= 0 && m_currentSxmChannelIndex < m_sxmChannels.size()) {
        QVariantMap ch = m_sxmChannels[m_currentSxmChannelIndex].toMap();
        QVariantList tr = ch["tracks"].toList();
        if (!tr.isEmpty()) {
            m_currentSxmTrackIndex = (m_currentSxmTrackIndex + 1) % tr.size();
            m_progress = 0;
            playCurrentSxmChannel();
        }
    }
}

void MediaBackend::prevSxmTrack()
{
    if (m_currentSxmChannelIndex >= 0 && m_currentSxmChannelIndex < m_sxmChannels.size()) {
        QVariantMap ch = m_sxmChannels[m_currentSxmChannelIndex].toMap();
        QVariantList tr = ch["tracks"].toList();
        if (!tr.isEmpty()) {
            m_currentSxmTrackIndex = (m_currentSxmTrackIndex - 1 + tr.size()) % tr.size();
            m_progress = 0;
            playCurrentSxmChannel();
        }
    }
}

void MediaBackend::selectSxmPreset(int presetIndex)
{
    if (presetIndex < 0 || presetIndex >= m_sxmPresets.size()) return;
    QVariantMap p = m_sxmPresets[presetIndex].toMap();
    if (p["isHoldToSet"].toBool() || p["number"].toInt() == 0) {
        saveCurrentSxmPreset(presetIndex);
        return;
    }
    tuneSxmChannelNumber(p["number"].toInt());
}

void MediaBackend::saveCurrentSxmPreset(int presetIndex)
{
    if (presetIndex < 0 || presetIndex >= m_sxmPresets.size()) return;
    QVariantMap p;
    p["number"] = m_sxmChannelNumber;
    p["name"] = m_sxmChannelName;
    p["isHoldToSet"] = false;
    if (m_sxmChannelNumber == 2) {
        p["logoType"] = "hits1";
    } else if (m_sxmChannelNumber == 8) {
        p["logoType"] = "80son8";
    } else if (m_sxmChannelNumber == 25) {
        p["logoType"] = "rewind";
    } else if (m_sxmChannelNumber == 56) {
        p["logoType"] = "highway";
    } else if (m_sxmChannelNumber == 37) {
        p["logoType"] = "octane";
    } else if (m_sxmChannelNumber == 51) {
        p["logoType"] = "bpm";
    } else {
        p["logoType"] = "generic";
    }
    p["badgeText"] = m_sxmChannelName;
    m_sxmPresets[presetIndex] = p;
    emit sxmPresetsChanged();
    updateActiveSxmPresetIndex();
}

void MediaBackend::toggleSxmFavorite()
{
    m_isSxmFavorite = !m_isSxmFavorite;
    emit sxmFavoriteChanged();
}

void MediaBackend::toggleSxmAlert()
{
    m_isSxmAlertSet = !m_isSxmAlertSet;
    emit sxmAlertChanged();
}

void MediaBackend::toggleSxmPlay()
{
    if (m_isPlaying) {
        setIsPlaying(false);
        if (m_mediaPlayer) {
            m_mediaPlayer->pause();
        }
    } else {
        setIsPlaying(true);
        if (m_mediaPlayer) {
            if (m_mediaPlayer->playbackState() == QMediaPlayer::PausedState) {
                m_mediaPlayer->play();
            } else {
                playCurrentSxmChannel();
            }
        }
    }
}

void MediaBackend::searchOnlineRadioStations(const QString &query)
{
    QString q = query.trimmed();
    if (q.isEmpty() || !m_networkManager) return;

    m_isSearchingOnline = true;
    emit isSearchingOnlineChanged();

    QUrl url(QString("https://all.api.radio-browser.info/json/stations/byname/%1?limit=30")
                 .arg(QString(QUrl::toPercentEncoding(q))));

    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::UserAgentHeader, "ApexVisionIVI/1.0");

    QNetworkReply *reply = m_networkManager->get(request);
    connect(reply, &QNetworkReply::finished, this, [this, reply, q]() {
        reply->deleteLater();
        m_isSearchingOnline = false;
        emit isSearchingOnlineChanged();

        if (reply->error() == QNetworkReply::NoError) {
            QByteArray data = reply->readAll();
            QJsonDocument doc = QJsonDocument::fromJson(data);
            if (doc.isArray()) {
                m_onlineSearchResults.clear();
                QJsonArray arr = doc.array();
                for (const QJsonValue &val : arr) {
                    QJsonObject obj = val.toObject();
                    QString stUrl = obj["url_resolved"].toString();
                    if (stUrl.isEmpty()) stUrl = obj["url"].toString();
                    if (!stUrl.startsWith("http")) continue;

                    QVariantMap res;
                    res["name"] = obj["name"].toString().trimmed();
                    res["streamUrl"] = stUrl;
                    res["category"] = obj["tags"].toString().isEmpty() ? "Internet Radio" : obj["tags"].toString();
                    res["country"] = obj["country"].toString();
                    res["favicon"] = obj["favicon"].toString();
                    res["bitrate"] = obj["bitrate"].toInt();
                    m_onlineSearchResults.append(res);
                }
                qDebug() << "[MediaBackend] Found" << m_onlineSearchResults.size() << "online radio stations for:" << q;
                emit onlineSearchResultsChanged();
            }
        }
    });
}

void MediaBackend::tuneOnlineStation(const QString &name, const QString &streamUrl, const QString &category)
{
    if (streamUrl.isEmpty()) return;

    m_sxmChannelName = name;
    m_sxmCategory = category;
    m_sxmSongTitle = name;
    m_sxmArtist = "Live Internet Radio Broadcast";
    m_station = name;
    m_trackTitle = name;
    m_artist = "Live Internet Radio Broadcast";
    m_source = "OrbitXM";

    if (m_mediaPlayer) {
        m_mediaPlayer->setSource(QUrl(streamUrl));
        m_mediaPlayer->play();
        m_isPlaying = true;
        emit isPlayingChanged();
    }

    emit sxmChannelChanged();
    emit sxmTrackChanged();
    emit stationChanged();
    emit trackTitleChanged();
    emit artistChanged();
    emit sourceChanged();

    fetchOnlineSxmArt(name, "");
}

