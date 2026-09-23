#include "MediaBackend.h"
#include "VehicleSimulator.h"
#include <algorithm>

MediaBackend::MediaBackend(VehicleSimulator *simulator, QObject *parent)
    : QObject(parent)
{
    if (simulator) {
        connect(simulator, &VehicleSimulator::mediaProgressUpdated,
                this, &MediaBackend::onMediaProgressUpdated);
    }
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
    if (m_source != source) {
        m_source = source;
        emit sourceChanged();

        if (m_source == "FM") {
            m_frequency = "95.9";
            m_station = "GTA's #1 Country KX-96";
            m_isHdRadio = true;
        } else if (m_source == "AM") {
            m_frequency = "680";
            m_station = "680 News Weather & Traffic";
            m_isHdRadio = false;
        } else if (m_source == "Bluetooth") {
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
    if (p == "P1") {
        m_frequency = "95.9";
        m_station = "GTA's #1 Country KX-96";
        m_isHdRadio = true;
    } else if (p == "P2") {
        m_frequency = "102.1";
        m_station = "The Edge Alternative";
        m_isHdRadio = true;
    } else if (p == "P3") {
        m_frequency = "98.1";
        m_station = "CHFI Modern Hits";
        m_isHdRadio = false;
    } else if (p == "P4") {
        m_frequency = "104.5";
        m_station = "CHUM FM Top 40";
        m_isHdRadio = true;
    }
    emit frequencyChanged();
    emit stationChanged();
    emit isHdRadioChanged();
}

void MediaBackend::setFrequency(const QString &freq)
{
    if (m_frequency != freq) {
        m_frequency = freq;
        emit frequencyChanged();
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
    }
}

void MediaBackend::togglePlay()
{
    setIsPlaying(!m_isPlaying);
}

void MediaBackend::next()
{
    if (m_preset == "P1") setPreset("P2");
    else if (m_preset == "P2") setPreset("P3");
    else if (m_preset == "P3") setPreset("P4");
    else setPreset("P1");
}

void MediaBackend::previous()
{
    if (m_preset == "P4") setPreset("P3");
    else if (m_preset == "P3") setPreset("P2");
    else if (m_preset == "P2") setPreset("P1");
    else setPreset("P4");
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
