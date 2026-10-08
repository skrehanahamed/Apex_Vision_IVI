/**
 * ==============================================================================
 * Project: Apex VISION IVI - Digital Cockpit & Infotainment System
 * File: SystemBackend.cpp
 * Author / Developer: Sk Rehan Ahamed
 * License: MIT
 * ==============================================================================
 */

#include "SystemBackend.h"
#include "PersistenceManager.h"
#include <algorithm>
#include <cmath>
#include <QProcess>
#include <QCoreApplication>
#include <QFile>
#include <QElapsedTimer>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QJsonDocument>
#include <QJsonObject>
#include <QRegularExpression>
#include <QSet>
#include <QMap>
#include <QStorageInfo>
#include <QDirIterator>
#include <QThreadPool>
#include <QDebug>

int SystemBackend::parseGmtOffset(const QString &tzStr)
{
    static QRegularExpression re(QStringLiteral("(?:GMT|UTC)([+-])(\\d{1,2}):(\\d{2})"));
    auto match = re.match(tzStr);
    if (match.hasMatch()) {
        int sign = (match.captured(1) == QLatin1String("-")) ? -1 : 1;
        int hours = match.captured(2).toInt();
        int mins = match.captured(3).toInt();
        return sign * (hours * 3600 + mins * 60);
    }
    return 0;
}

SystemBackend::SystemBackend(PersistenceManager *persistence, QObject *parent)
    : QObject(parent)
    , m_persistence(persistence)
{
    if (m_persistence) {
        m_is24HourFormat = m_persistence->getSetting(QStringLiteral("sys_is24HourFormat"), true).toBool();
        m_autoTimeEnabled = m_persistence->getSetting(QStringLiteral("sys_autoTimeEnabled"), true).toBool();
        m_autoTimeZoneEnabled = m_persistence->getSetting(QStringLiteral("sys_autoTimeZoneEnabled"), true).toBool();
        m_selectedTimeZone = m_persistence->getSetting(QStringLiteral("sys_selectedTimeZone"), QStringLiteral("GMT+05:30 India Standard Time (IST)")).toString();
        m_selectedLanguage = m_persistence->getSetting(QStringLiteral("sys_selectedLanguage"), QStringLiteral("English")).toString();
        m_selectedKeyboard = m_persistence->getSetting(QStringLiteral("sys_selectedKeyboard"), QStringLiteral("Apex Touch Keyboard")).toString();
        m_selectedAutofill = m_persistence->getSetting(QStringLiteral("sys_selectedAutofill"), QStringLiteral("Apex Cloud")).toString();
        m_pointerSpeed = m_persistence->getSetting(QStringLiteral("sys_pointerSpeed"), 50).toInt();
        m_unitsTemperature = m_persistence->getSetting(QStringLiteral("sys_unitsTemperature"), QStringLiteral("Celsius (°C)")).toString();
        m_brightness = m_persistence->getSetting(QStringLiteral("sys_brightness"), 85).toInt();
        m_touchSoundsEnabled = m_persistence->getSetting(QStringLiteral("sys_touchSoundsEnabled"), true).toBool();
        m_volumePrompts = m_persistence->getSetting(QStringLiteral("sys_vol_prompts"), 10).toInt();
        m_volumePhone = m_persistence->getSetting(QStringLiteral("sys_vol_phone"), 30).toInt();
        m_volumeCallRing = m_persistence->getSetting(QStringLiteral("sys_vol_ring"), 10).toInt();
    }

    m_networkManager = new QNetworkAccessManager(this);

    updateClock();
    connect(&m_clockTimer, &QTimer::timeout, this, &SystemBackend::updateClock);
    m_clockTimer.start(1000);

    // Initial internet time and timezone detection shortly after startup
    QTimer::singleShot(1500, this, &SystemBackend::syncTimeFromInternet);

    // Periodic synchronization every 15 minutes
    connect(&m_internetSyncTimer, &QTimer::timeout, this, &SystemBackend::syncTimeFromInternet);
    m_internetSyncTimer.start(15 * 60 * 1000);

    // Wi-Fi band & signal monitoring
#if defined(Q_OS_LINUX)
    QProcess::execute(QStringLiteral("wpa_cli"), {QStringLiteral("-i"), QStringLiteral("wlan0"), QStringLiteral("set"), QStringLiteral("country"), QStringLiteral("IN")});
    QProcess::execute(QStringLiteral("iw"), {QStringLiteral("reg"), QStringLiteral("set"), QStringLiteral("IN")});
#endif
    connect(&m_wifiStatusTimer, &QTimer::timeout, this, &SystemBackend::updateWifiStatus);
    m_wifiStatusTimer.start(4000);
    QTimer::singleShot(300, this, &SystemBackend::updateWifiStatus);
    QTimer::singleShot(800, this, [this]() { scanWifiNetworks(); });

    // Automatic periodic background Wi-Fi scan every 25 seconds (silent, no on-screen scanning animation)
    connect(&m_wifiScanTimer, &QTimer::timeout, this, [this]() {
        if (m_wifiEnabled && !m_wifiScanning) {
            scanWifiNetworks(false);
        }
    });
    m_wifiScanTimer.start(25000);

    // Real-time network throughput polling (every 1000 ms)
    connect(&m_netSpeedTimer, &QTimer::timeout, this, &SystemBackend::updateNetworkSpeed);
    m_netSpeedTimer.start(1000);
    QTimer::singleShot(250, this, &SystemBackend::updateNetworkSpeed);

    // Live storage telemetry polling (every 60s)
    connect(&m_storageTimer, &QTimer::timeout, this, &SystemBackend::refreshStorageInfo);
    m_storageTimer.start(60000);
    QTimer::singleShot(400, this, &SystemBackend::refreshStorageInfo);
}

SystemBackend::~SystemBackend()
{
    stopTts();
}

void SystemBackend::updateClock()
{
    QDateTime now;
    if (!m_autoTimeZoneEnabled && !m_selectedTimeZone.isEmpty()) {
        int offsetSec = parseGmtOffset(m_selectedTimeZone);
        now = QDateTime::currentDateTimeUtc().addSecs(offsetSec);
    } else {
        now = QDateTime::currentDateTime();
    }

    if (!m_autoTimeEnabled && m_hasManualOffset) {
        now = now.addSecs(m_manualTimeOffsetSec);
    }

    QString timeStr;
    if (m_is24HourFormat) {
        timeStr = now.toString("HH:mm");
    } else {
        int h = now.time().hour() % 12;
        if (h == 0) h = 12;
        timeStr = QString("%1:%2").arg(h).arg(now.time().minute(), 2, 10, QChar('0'));
    }
    const QString dateStr = now.toString("dddd, MMM d");

    bool changed = false;
    if (m_currentTime != timeStr) {
        m_currentTime = timeStr;
        changed = true;
    }
    if (m_currentDate != dateStr) {
        m_currentDate = dateStr;
        changed = true;
    }
    if (changed) {
        emit timeChanged();
    }
}

void SystemBackend::setIs24HourFormat(bool is24)
{
    if (m_is24HourFormat != is24) {
        m_is24HourFormat = is24;
        if (m_persistence) {
            m_persistence->setSetting(QStringLiteral("sys_is24HourFormat"), is24);
        }
        updateClock();
        emit is24HourFormatChanged();
    }
}

void SystemBackend::setAutoTimeEnabled(bool enabled)
{
    if (m_autoTimeEnabled != enabled) {
        m_autoTimeEnabled = enabled;
        if (m_autoTimeEnabled) {
            m_hasManualOffset = false;
            m_manualTimeOffsetSec = 0;
            syncTimeFromInternet();
        }
        if (m_persistence) {
            m_persistence->setSetting(QStringLiteral("sys_autoTimeEnabled"), enabled);
        }
        updateClock();
        emit autoTimeEnabledChanged();
    }
}

void SystemBackend::setAutoTimeZoneEnabled(bool enabled)
{
    if (m_autoTimeZoneEnabled != enabled) {
        m_autoTimeZoneEnabled = enabled;
        if (m_autoTimeZoneEnabled) {
            syncTimeFromInternet();
        }
        if (m_persistence) {
            m_persistence->setSetting(QStringLiteral("sys_autoTimeZoneEnabled"), enabled);
        }
        updateClock();
        emit autoTimeZoneEnabledChanged();
    }
}

void SystemBackend::setSelectedTimeZone(const QString &tz)
{
    if (m_selectedTimeZone != tz) {
        m_selectedTimeZone = tz;
        if (m_persistence) {
            m_persistence->setSetting(QStringLiteral("sys_selectedTimeZone"), tz);
        }
        updateClock();
        emit selectedTimeZoneChanged();
    }
}

void SystemBackend::syncTimeFromInternet()
{
    if (!m_networkManager) {
        m_networkManager = new QNetworkAccessManager(this);
    }

    // Step 1: Query IP Geolocation for timezone, country, and offset
    QNetworkRequest req(QUrl(QStringLiteral("http://ip-api.com/json/?fields=status,country,city,timezone,offset")));
    req.setAttribute(QNetworkRequest::Http2AllowedAttribute, false);
    req.setTransferTimeout(5000);

    QNetworkReply *reply = m_networkManager->get(req);
    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        reply->deleteLater();
        if (reply->error() != QNetworkReply::NoError) {
            qWarning() << "[SystemBackend] IP Geolocation lookup error:" << reply->errorString();
            return;
        }

        const QByteArray body = reply->readAll();
        QJsonDocument doc = QJsonDocument::fromJson(body);
        if (!doc.isObject()) return;
        QJsonObject root = doc.object();

        if (root.value(QStringLiteral("status")).toString() == QLatin1String("success")) {
            QString detectedTz = root.value(QStringLiteral("timezone")).toString();
            int offsetSec = root.value(QStringLiteral("offset")).toInt();

            qInfo() << "[SystemBackend] Detected internet timezone:" << detectedTz << "offset:" << offsetSec;

            if (m_autoTimeZoneEnabled && !detectedTz.isEmpty()) {
                QProcess::startDetached(QStringLiteral("timedatectl"), QStringList() << QStringLiteral("set-timezone") << detectedTz);

                int absOffset = std::abs(offsetSec);
                int h = absOffset / 3600;
                int m = (absOffset % 3600) / 60;
                QString sign = (offsetSec >= 0) ? QStringLiteral("+") : QStringLiteral("-");
                QString gmtPrefix = QString("GMT%1%2:%3").arg(sign).arg(h, 2, 10, QChar('0')).arg(m, 2, 10, QChar('0'));

                QString country = root.value(QStringLiteral("country")).toString();
                QString city = root.value(QStringLiteral("city")).toString();
                QString displayTz = QString("%1 %2 (%3)").arg(gmtPrefix, detectedTz, city.isEmpty() ? country : city);

                if (m_selectedTimeZone != displayTz) {
                    m_selectedTimeZone = displayTz;
                    if (m_persistence) {
                        m_persistence->setSetting(QStringLiteral("sys_selectedTimeZone"), displayTz);
                    }
                    emit selectedTimeZoneChanged();
                }
            }

            // Step 2: Fetch exact date & time from timeapi.io
            QString timeApiUrl = QString("https://timeapi.io/api/time/current/zone?timeZone=%1").arg(detectedTz);
            QNetworkRequest timeReq;
            timeReq.setUrl(QUrl(timeApiUrl));
            timeReq.setTransferTimeout(5000);
            QNetworkReply *timeReply = m_networkManager->get(timeReq);
            connect(timeReply, &QNetworkReply::finished, this, [this, timeReply]() {
                timeReply->deleteLater();
                if (timeReply->error() == QNetworkReply::NoError) {
                    QJsonDocument tDoc = QJsonDocument::fromJson(timeReply->readAll());
                    if (tDoc.isObject()) {
                        QJsonObject tObj = tDoc.object();
                        int year = tObj.value(QStringLiteral("year")).toInt();
                        int month = tObj.value(QStringLiteral("month")).toInt();
                        int day = tObj.value(QStringLiteral("day")).toInt();
                        int hour = tObj.value(QStringLiteral("hour")).toInt();
                        int minute = tObj.value(QStringLiteral("minute")).toInt();
                        int seconds = tObj.value(QStringLiteral("seconds")).toInt();

                        if (year >= 2024 && month >= 1 && day >= 1) {
                            QDateTime netTime(QDate(year, month, day), QTime(hour, minute, seconds));
                            QDateTime localNow = QDateTime::currentDateTime();
                            qint64 diff = std::abs(localNow.secsTo(netTime));
                            qInfo() << "[SystemBackend] Internet time:" << netTime.toString(Qt::ISODate)
                                    << "local:" << localNow.toString(Qt::ISODate)
                                    << "diff:" << diff << "s";

                            if (m_autoTimeEnabled && diff > 2) {
                                QString timeArg = netTime.toString(QStringLiteral("yyyy-MM-dd HH:mm:ss"));
                                QProcess::startDetached(QStringLiteral("timedatectl"), QStringList() << QStringLiteral("set-time") << timeArg);
                                m_hasManualOffset = false;
                                m_manualTimeOffsetSec = 0;
                            }
                        }
                    }
                }
                updateClock();
            });
        }
    });
}


void SystemBackend::setManualTime(int hour, int minute)
{
    QDateTime now = QDateTime::currentDateTime();
    QDateTime target(now.date(), QTime(hour, minute, 0));
    m_manualTimeOffsetSec = now.secsTo(target);
    m_hasManualOffset = true;
    m_autoTimeEnabled = false;
    emit autoTimeEnabledChanged();
    updateClock();
}

void SystemBackend::setManualDate(int year, int month, int day)
{
    QDateTime now = QDateTime::currentDateTime();
    if (m_hasManualOffset) {
        now = now.addSecs(m_manualTimeOffsetSec);
    }
    QDateTime target(QDate(year, month, day), now.time());
    m_manualTimeOffsetSec = QDateTime::currentDateTime().secsTo(target);
    m_hasManualOffset = true;
    m_autoTimeEnabled = false;
    emit autoTimeEnabledChanged();
    updateClock();
}

void SystemBackend::setWifiEnabled(bool enabled)
{
    if (m_wifiEnabled != enabled) {
        m_wifiEnabled = enabled;
        emit wifiEnabledChanged();
        if (m_wifiEnabled) {
            QProcess::execute(QStringLiteral("wpa_cli"), {QStringLiteral("-i"), QStringLiteral("wlan0"), QStringLiteral("reconnect")});
            updateWifiStatus();
            scanWifiNetworks();
        } else {
            QProcess::execute(QStringLiteral("wpa_cli"), {QStringLiteral("-i"), QStringLiteral("wlan0"), QStringLiteral("disconnect")});
            setWifiConnected(false);
            if (m_wifiSignalBars != 0) {
                m_wifiSignalBars = 0;
                emit wifiSignalBarsChanged();
            }
        }
    }
}

void SystemBackend::setWifiConnected(bool connected)
{
    if (m_wifiConnected != connected) {
        m_wifiConnected = connected;
        emit wifiConnectedChanged();
    }
}

void SystemBackend::setWifiBand(const QString &band)
{
    if (m_wifiBand != band) {
        m_wifiBand = band;
        emit wifiBandChanged();
    }
}

void SystemBackend::setWifiSignalBars(int bars)
{
    bars = std::clamp(bars, 0, 4);
    if (m_wifiSignalBars != bars) {
        m_wifiSignalBars = bars;
        emit wifiSignalBarsChanged();
    }
}

void SystemBackend::refreshWifiStatus()
{
    updateWifiStatus();
}

void SystemBackend::updateWifiStatus()
{
#if defined(Q_OS_LINUX)
    // 1. Query wpa_cli status (provides SSID, connection state, IP, MAC address, security)
    QProcess wpaProcess;
    wpaProcess.start(QStringLiteral("wpa_cli"), {QStringLiteral("-i"), QStringLiteral("wlan0"), QStringLiteral("status")});
    if (wpaProcess.waitForFinished(800)) {
        const QString wpaOut = QString::fromUtf8(wpaProcess.readAllStandardOutput());
        if (wpaOut.contains(QStringLiteral("wpa_state=COMPLETED"))) {
            setWifiConnected(true);

            // Line-by-line exact prefix parsing to avoid matching bssid= as ssid=
            const QStringList lines = wpaOut.split(QLatin1Char('\n'), Qt::SkipEmptyParts);
            for (const QString &rawLine : lines) {
                const QString trimmed = rawLine.trimmed();
                if (trimmed.startsWith(QLatin1String("ssid="))) {
                    QString ssid = trimmed.mid(5).trimmed();
                    if (m_wifiSsid != ssid) {
                        m_wifiSsid = ssid;
                        emit wifiSsidChanged();
                    }
                } else if (trimmed.startsWith(QLatin1String("freq="))) {
                    int freq = trimmed.mid(5).toInt();
                    QString detectedBand = (freq >= 4900) ? QStringLiteral("5G") : QStringLiteral("2.4G");
                    if (m_wifiBand != detectedBand) {
                        m_wifiBand = detectedBand;
                        emit wifiBandChanged();
                    }
                } else if (trimmed.startsWith(QLatin1String("ip_address="))) {
                    QString ip = trimmed.mid(11).trimmed();
                    if (m_wifiIpAddress != ip) {
                        m_wifiIpAddress = ip;
                        emit wifiIpAddressChanged();
                    }
                } else if (trimmed.startsWith(QLatin1String("address="))) {
                    QString mac = trimmed.mid(8).trimmed();
                    if (m_wifiMacAddress != mac) {
                        m_wifiMacAddress = mac;
                        emit wifiMacAddressChanged();
                    }
                } else if (trimmed.startsWith(QLatin1String("key_mgmt="))) {
                    QString sec = trimmed.mid(9).trimmed();
                    if (m_wifiSecurity != sec) {
                        m_wifiSecurity = sec;
                        emit wifiSecurityChanged();
                    }
                }
            }

            // 2. Query signal_poll for live RSSI (dBm) and calculate bars
            QProcess pollProcess;
            pollProcess.start(QStringLiteral("wpa_cli"), {QStringLiteral("-i"), QStringLiteral("wlan0"), QStringLiteral("signal_poll")});
            if (pollProcess.waitForFinished(600)) {
                const QString pollOut = QString::fromUtf8(pollProcess.readAllStandardOutput());
                static const QRegularExpression rssiRe(QStringLiteral("RSSI=(-?[0-9]+)"));
                auto rssiMatch = rssiRe.match(pollOut);
                if (rssiMatch.hasMatch()) {
                    int dbm = rssiMatch.captured(1).toInt();
                    if (m_wifiSignalDbm != dbm) {
                        m_wifiSignalDbm = dbm;
                        emit wifiSignalDbmChanged();
                    }
                    int bars = 1;
                    if (dbm >= -58) bars = 4;
                    else if (dbm >= -68) bars = 3;
                    else if (dbm >= -78) bars = 2;
                    setWifiSignalBars(bars);
                }
            }
            return;
        } else if (wpaOut.contains(QStringLiteral("wpa_state=DISCONNECTED")) || wpaOut.contains(QStringLiteral("wpa_state=INACTIVE"))) {
            setWifiConnected(false);
            if (m_wifiSignalBars != 0) {
                m_wifiSignalBars = 0;
                emit wifiSignalBarsChanged();
            }
            return;
        }
    }

    // Fallback: try iw dev wlan0 link
    QProcess iwProcess;
    iwProcess.start(QStringLiteral("iw"), {QStringLiteral("dev"), QStringLiteral("wlan0"), QStringLiteral("link")});
    if (iwProcess.waitForFinished(800)) {
        const QString output = QString::fromUtf8(iwProcess.readAllStandardOutput());
        if (output.contains(QStringLiteral("Connected to"), Qt::CaseInsensitive)) {
            setWifiConnected(true);
            static const QRegularExpression ssidRe(QStringLiteral("SSID:\\s*(.+)"));
            auto ssidMatch = ssidRe.match(output);
            if (ssidMatch.hasMatch()) {
                QString ssid = ssidMatch.captured(1).trimmed();
                if (m_wifiSsid != ssid) {
                    m_wifiSsid = ssid;
                    emit wifiSsidChanged();
                }
            }
            static const QRegularExpression sigRe(QStringLiteral("signal:\\s*(-?[0-9]+)\\s*dBm"));
            auto sigMatch = sigRe.match(output);
            if (sigMatch.hasMatch()) {
                int dbm = sigMatch.captured(1).toInt();
                int bars = 1;
                if (dbm >= -58) bars = 4;
                else if (dbm >= -68) bars = 3;
                else if (dbm >= -78) bars = 2;
                setWifiSignalBars(bars);
            }
        } else if (output.contains(QStringLiteral("Not connected"), Qt::CaseInsensitive)) {
            setWifiConnected(false);
            if (m_wifiSignalBars != 0) {
                m_wifiSignalBars = 0;
                emit wifiSignalBarsChanged();
            }
        }
    }
#endif
}

void SystemBackend::scanWifiNetworks()
{
    scanWifiNetworks(true);
}

void SystemBackend::scanWifiNetworks(bool userInitiated)
{
#if defined(Q_OS_LINUX)
    if (userInitiated) {
        // Delay and restart the auto-scan timer when the user manually presses Scan
        m_wifiScanTimer.start(25000);

        if (!m_wifiScanning) {
            m_wifiScanning = true;
            emit wifiScanningChanged();
        }
    }

    // Trigger Wi-Fi scan via wpa_cli
    QProcess::execute(QStringLiteral("wpa_cli"), {QStringLiteral("-i"), QStringLiteral("wlan0"), QStringLiteral("scan")});

    // Wait 3500ms for full dual-band (2.4GHz + 5GHz) channel sweep to complete on Pi 5
    QTimer::singleShot(3500, this, [this, userInitiated]() {
        // Prune stale BSS entries older than 30s that did not respond during this scan
        QProcess::execute(QStringLiteral("wpa_cli"), {QStringLiteral("-i"), QStringLiteral("wlan0"), QStringLiteral("bss_flush"), QStringLiteral("30")});

        QProcess resultsProc;
        resultsProc.start(QStringLiteral("wpa_cli"), {QStringLiteral("-i"), QStringLiteral("wlan0"), QStringLiteral("scan_results")});
        resultsProc.waitForFinished(1000);
        const QString scanOut = QString::fromUtf8(resultsProc.readAllStandardOutput());

        QProcess listProc;
        listProc.start(QStringLiteral("wpa_cli"), {QStringLiteral("-i"), QStringLiteral("wlan0"), QStringLiteral("list_networks")});
        listProc.waitForFinished(600);
        const QString listOut = QString::fromUtf8(listProc.readAllStandardOutput());

        parseScanResults(scanOut, listOut);

        if (userInitiated && m_wifiScanning) {
            m_wifiScanning = false;
            emit wifiScanningChanged();
        }
    });
#endif
}

void SystemBackend::parseScanResults(const QString &scanOutput, const QString &listOutput)
{
    // 1. Saved SSIDs from list_networks
    QSet<QString> savedSsids;
    const QStringList listLines = listOutput.split(QLatin1Char('\n'), Qt::SkipEmptyParts);
    for (int i = 1; i < listLines.size(); ++i) {
        const QStringList parts = listLines.at(i).split(QLatin1Char('\t'));
        if (parts.size() >= 2) {
            savedSsids.insert(parts.at(1).trimmed());
        }
    }

    // 2. Parse access points from scan_results (bssid \t freq \t signal \t flags \t ssid)
    QMap<QString, QVariantMap> apMap;
    const QStringList scanLines = scanOutput.split(QLatin1Char('\n'), Qt::SkipEmptyParts);
    for (int i = 1; i < scanLines.size(); ++i) {
        const QStringList parts = scanLines.at(i).split(QLatin1Char('\t'));
        if (parts.size() < 5) continue;

        QString bssid = parts.at(0).trimmed();
        int freq = parts.at(1).trimmed().toInt();
        int dbm = parts.at(2).trimmed().toInt();
        QString flags = parts.at(3).trimmed();
        QString ssid = parts.at(4).trimmed();

        if (ssid.isEmpty()) continue; // skip hidden SSIDs

        QString band = (freq >= 4900) ? QStringLiteral("5 GHz") : QStringLiteral("2.4 GHz");

        QString sec = QStringLiteral("Open");
        if (flags.contains(QStringLiteral("WPA3"), Qt::CaseInsensitive) || flags.contains(QStringLiteral("SAE"), Qt::CaseInsensitive)) {
            sec = QStringLiteral("WPA3");
        } else if (flags.contains(QStringLiteral("WPA2"), Qt::CaseInsensitive)) {
            sec = QStringLiteral("WPA2");
        } else if (flags.contains(QStringLiteral("WPA"), Qt::CaseInsensitive)) {
            sec = QStringLiteral("WPA");
        } else if (flags.contains(QStringLiteral("WEP"), Qt::CaseInsensitive)) {
            sec = QStringLiteral("WEP");
        }

        int bars = 1;
        if (dbm >= -58) bars = 4;
        else if (dbm >= -68) bars = 3;
        else if (dbm >= -78) bars = 2;

        bool isConnected = (m_wifiConnected && ssid == m_wifiSsid);
        bool isSaved = savedSsids.contains(ssid);

        if (apMap.contains(ssid)) {
            const QVariantMap existing = apMap.value(ssid);
            int existDbm = existing.value(QStringLiteral("signalDbm")).toInt();
            if (dbm <= existDbm && existing.value(QStringLiteral("band")).toString() == QStringLiteral("5 GHz")) {
                continue;
            }
        }

        QVariantMap ap;
        ap[QStringLiteral("ssid")] = ssid;
        ap[QStringLiteral("bssid")] = bssid;
        ap[QStringLiteral("frequency")] = freq;
        ap[QStringLiteral("band")] = band;
        ap[QStringLiteral("signalDbm")] = dbm;
        ap[QStringLiteral("signalBars")] = bars;
        ap[QStringLiteral("security")] = sec;
        bool isSecured = (sec != QStringLiteral("Open"));
        ap[QStringLiteral("isSecured")] = isSecured;
        ap[QStringLiteral("secured")] = isSecured;
        ap[QStringLiteral("isConnected")] = isConnected;
        ap[QStringLiteral("connected")] = isConnected;
        ap[QStringLiteral("isSaved")] = isSaved;
        ap[QStringLiteral("saved")] = isSaved;

        apMap[ssid] = ap;
    }

    // Ensure the currently connected network is present even if missed in scan
    if (m_wifiConnected && !m_wifiSsid.isEmpty() && !apMap.contains(m_wifiSsid)) {
        QVariantMap ap;
        ap[QStringLiteral("ssid")] = m_wifiSsid;
        ap[QStringLiteral("bssid")] = QStringLiteral("");
        ap[QStringLiteral("frequency")] = (m_wifiBand == QStringLiteral("5G")) ? 5320 : 2412;
        ap[QStringLiteral("band")] = (m_wifiBand == QStringLiteral("5G")) ? QStringLiteral("5 GHz") : QStringLiteral("2.4 GHz");
        ap[QStringLiteral("signalDbm")] = m_wifiSignalDbm;
        ap[QStringLiteral("signalBars")] = m_wifiSignalBars > 0 ? m_wifiSignalBars : 4;
        QString sec = m_wifiSecurity.isEmpty() ? QStringLiteral("WPA2") : m_wifiSecurity;
        ap[QStringLiteral("security")] = sec;
        bool isSecured = (sec != QStringLiteral("Open"));
        ap[QStringLiteral("isSecured")] = isSecured;
        ap[QStringLiteral("secured")] = isSecured;
        ap[QStringLiteral("isConnected")] = true;
        ap[QStringLiteral("connected")] = true;
        ap[QStringLiteral("isSaved")] = true;
        ap[QStringLiteral("saved")] = true;
        apMap[m_wifiSsid] = ap;
    }

    QVariantList list;
    for (auto it = apMap.begin(); it != apMap.end(); ++it) {
        list.append(it.value());
    }

    std::sort(list.begin(), list.end(), [](const QVariant &a, const QVariant &b) {
        const QVariantMap ma = a.toMap();
        const QVariantMap mb = b.toMap();
        if (ma.value(QStringLiteral("connected")).toBool() != mb.value(QStringLiteral("connected")).toBool()) {
            return ma.value(QStringLiteral("connected")).toBool();
        }
        if (ma.value(QStringLiteral("saved")).toBool() != mb.value(QStringLiteral("saved")).toBool()) {
            return ma.value(QStringLiteral("saved")).toBool();
        }
        return ma.value(QStringLiteral("signalDbm")).toInt() > mb.value(QStringLiteral("signalDbm")).toInt();
    });

    m_wifiNetworks = list;
    emit wifiNetworksChanged();
}

void SystemBackend::connectToNetwork(const QString &ssid, const QString &password)
{
    qInfo() << "[SystemBackend] Connect to Wi-Fi requested for:" << ssid;
#if defined(Q_OS_LINUX)
    // Check if network already exists in saved networks
    QProcess listProc;
    listProc.start(QStringLiteral("wpa_cli"), {QStringLiteral("-i"), QStringLiteral("wlan0"), QStringLiteral("list_networks")});
    listProc.waitForFinished(600);
    const QString listOut = QString::fromUtf8(listProc.readAllStandardOutput());

    int targetNetId = -1;
    const QStringList lines = listOut.split(QLatin1Char('\n'), Qt::SkipEmptyParts);
    for (int i = 1; i < lines.size(); ++i) {
        const QStringList parts = lines.at(i).split(QLatin1Char('\t'));
        if (parts.size() >= 2 && parts.at(1).trimmed() == ssid) {
            targetNetId = parts.at(0).trimmed().toInt();
            break;
        }
    }

    if (targetNetId >= 0) {
        if (!password.isEmpty()) {
            QProcess::execute(QStringLiteral("wpa_cli"), {QStringLiteral("-i"), QStringLiteral("wlan0"), QStringLiteral("set_network"), QString::number(targetNetId), QStringLiteral("psk"), QStringLiteral("\"%1\"").arg(password)});
        }
        QProcess::execute(QStringLiteral("wpa_cli"), {QStringLiteral("-i"), QStringLiteral("wlan0"), QStringLiteral("bssid_ignore"), QStringLiteral("clear")});
        QProcess::execute(QStringLiteral("wpa_cli"), {QStringLiteral("-i"), QStringLiteral("wlan0"), QStringLiteral("enable_network"), QString::number(targetNetId)});
        QProcess::execute(QStringLiteral("wpa_cli"), {QStringLiteral("-i"), QStringLiteral("wlan0"), QStringLiteral("select_network"), QString::number(targetNetId)});
        QProcess::execute(QStringLiteral("wpa_cli"), {QStringLiteral("-i"), QStringLiteral("wlan0"), QStringLiteral("reconnect")});
        QProcess::execute(QStringLiteral("wpa_cli"), {QStringLiteral("-i"), QStringLiteral("wlan0"), QStringLiteral("save_config")});
        QProcess::execute(QStringLiteral("cp"), {QStringLiteral("/etc/wpa_supplicant/wpa_supplicant-wlan0.conf"), QStringLiteral("/etc/wpa_supplicant.conf")});
    } else {
        QProcess addProc;
        addProc.start(QStringLiteral("wpa_cli"), {QStringLiteral("-i"), QStringLiteral("wlan0"), QStringLiteral("add_network")});
        addProc.waitForFinished(600);
        QString newIdStr = QString::fromUtf8(addProc.readAllStandardOutput()).trimmed();
        bool ok = false;
        int newId = newIdStr.toInt(&ok);
        if (ok && newId >= 0) {
            QProcess::execute(QStringLiteral("wpa_cli"), {QStringLiteral("-i"), QStringLiteral("wlan0"), QStringLiteral("set_network"), QString::number(newId), QStringLiteral("ssid"), QStringLiteral("\"%1\"").arg(ssid)});
            if (password.isEmpty()) {
                QProcess::execute(QStringLiteral("wpa_cli"), {QStringLiteral("-i"), QStringLiteral("wlan0"), QStringLiteral("set_network"), QString::number(newId), QStringLiteral("key_mgmt"), QStringLiteral("NONE")});
            } else {
                QProcess::execute(QStringLiteral("wpa_cli"), {QStringLiteral("-i"), QStringLiteral("wlan0"), QStringLiteral("set_network"), QString::number(newId), QStringLiteral("psk"), QStringLiteral("\"%1\"").arg(password)});
            }
            QProcess::execute(QStringLiteral("wpa_cli"), {QStringLiteral("-i"), QStringLiteral("wlan0"), QStringLiteral("bssid_ignore"), QStringLiteral("clear")});
            QProcess::execute(QStringLiteral("wpa_cli"), {QStringLiteral("-i"), QStringLiteral("wlan0"), QStringLiteral("enable_network"), QString::number(newId)});
            QProcess::execute(QStringLiteral("wpa_cli"), {QStringLiteral("-i"), QStringLiteral("wlan0"), QStringLiteral("select_network"), QString::number(newId)});
            QProcess::execute(QStringLiteral("wpa_cli"), {QStringLiteral("-i"), QStringLiteral("wlan0"), QStringLiteral("reconnect")});
            QProcess::execute(QStringLiteral("wpa_cli"), {QStringLiteral("-i"), QStringLiteral("wlan0"), QStringLiteral("save_config")});
            QProcess::execute(QStringLiteral("cp"), {QStringLiteral("/etc/wpa_supplicant/wpa_supplicant-wlan0.conf"), QStringLiteral("/etc/wpa_supplicant.conf")});
        }
    }
    // Enforce power save off on wlan0 to eliminate packet loss and handshake latency
    QProcess::execute(QStringLiteral("iw"), {QStringLiteral("dev"), QStringLiteral("wlan0"), QStringLiteral("set"), QStringLiteral("power_save"), QStringLiteral("off")});

    // Trigger networkctl reconfigure so systemd-networkd obtains a DHCP lease promptly
    QTimer::singleShot(2500, this, []() {
        QProcess::execute(QStringLiteral("networkctl"), {QStringLiteral("reconfigure"), QStringLiteral("wlan0")});
    });

    // Immediately mark as saved in memory so UI reflects saved state
    bool updated = false;
    for (int i = 0; i < m_wifiNetworks.size(); ++i) {
        QVariantMap ap = m_wifiNetworks.at(i).toMap();
        if (ap.value(QStringLiteral("ssid")).toString() == ssid) {
            ap[QStringLiteral("isSaved")] = true;
            ap[QStringLiteral("saved")] = true;
            m_wifiNetworks[i] = ap;
            updated = true;
            break;
        }
    }
    if (updated) {
        emit wifiNetworksChanged();
    }

    QTimer::singleShot(2500, this, &SystemBackend::updateWifiStatus);
    QTimer::singleShot(4000, this, [this]() { scanWifiNetworks(); });
#endif
}

void SystemBackend::disconnectWifi()
{
    qInfo() << "[SystemBackend] Disconnecting Wi-Fi";
#if defined(Q_OS_LINUX)
    QProcess::execute(QStringLiteral("wpa_cli"), {QStringLiteral("-i"), QStringLiteral("wlan0"), QStringLiteral("disconnect")});
    setWifiConnected(false);
    updateWifiStatus();
#endif
}

void SystemBackend::forgetNetwork(const QString &ssid)
{
    qInfo() << "[SystemBackend] Forgetting Wi-Fi network:" << ssid;
#if defined(Q_OS_LINUX)
    // 1. If currently connected to this network, cleanly disconnect
    if (m_wifiConnected && (m_wifiSsid == ssid || ssid.isEmpty())) {
        disconnectWifi();
    }

    // 2. Remove all network IDs matching this SSID from wpa_supplicant
    QProcess listProc;
    listProc.start(QStringLiteral("wpa_cli"), {QStringLiteral("-i"), QStringLiteral("wlan0"), QStringLiteral("list_networks")});
    listProc.waitForFinished(600);
    const QString listOut = QString::fromUtf8(listProc.readAllStandardOutput());

    const QStringList lines = listOut.split(QLatin1Char('\n'), Qt::SkipEmptyParts);
    for (int i = 1; i < lines.size(); ++i) {
        const QStringList parts = lines.at(i).split(QLatin1Char('\t'));
        if (parts.size() >= 2 && parts.at(1).trimmed() == ssid) {
            int netId = parts.at(0).trimmed().toInt();
            QProcess::execute(QStringLiteral("wpa_cli"), {QStringLiteral("-i"), QStringLiteral("wlan0"), QStringLiteral("remove_network"), QString::number(netId)});
        }
    }
    // Re-enable all remaining saved networks so none stay disabled, and trigger reconnect
    QProcess::execute(QStringLiteral("wpa_cli"), {QStringLiteral("-i"), QStringLiteral("wlan0"), QStringLiteral("enable_network"), QStringLiteral("all")});
    QProcess::execute(QStringLiteral("wpa_cli"), {QStringLiteral("-i"), QStringLiteral("wlan0"), QStringLiteral("save_config")});
    QProcess::execute(QStringLiteral("cp"), {QStringLiteral("/etc/wpa_supplicant/wpa_supplicant-wlan0.conf"), QStringLiteral("/etc/wpa_supplicant.conf")});
    QProcess::execute(QStringLiteral("wpa_cli"), {QStringLiteral("-i"), QStringLiteral("wlan0"), QStringLiteral("reconnect")});

    // 3. Immediately mark network as unsaved & disconnected in memory so QML transitions to password prompt on next tap
    bool updated = false;
    for (int i = 0; i < m_wifiNetworks.size(); ++i) {
        QVariantMap ap = m_wifiNetworks.at(i).toMap();
        if (ap.value(QStringLiteral("ssid")).toString() == ssid) {
            ap[QStringLiteral("isSaved")] = false;
            ap[QStringLiteral("saved")] = false;
            ap[QStringLiteral("isConnected")] = false;
            ap[QStringLiteral("connected")] = false;
            m_wifiNetworks[i] = ap;
            updated = true;
        }
    }
    if (updated) {
        emit wifiNetworksChanged();
    }

    scanWifiNetworks();
#endif
}


void SystemBackend::setBrightness(int b)
{
    b = std::clamp(b, 10, 100);
    if (m_brightness != b) {
        m_brightness = b;
        if (m_persistence) {
            m_persistence->setSetting(QStringLiteral("sys_brightness"), b);
        }

        // Hardware backlight check for DSI/eDP/PWM panels if attached
        QDir blDir(QStringLiteral("/sys/class/backlight"));
        if (blDir.exists()) {
            const QStringList entries = blDir.entryList(QDir::Dirs | QDir::NoDotAndDotDot);
            for (const QString &dev : entries) {
                QString maxPath = QStringLiteral("/sys/class/backlight/%1/max_brightness").arg(dev);
                QString curPath = QStringLiteral("/sys/class/backlight/%1/brightness").arg(dev);
                QFile maxFile(maxPath);
                if (maxFile.open(QIODevice::ReadOnly | QIODevice::Text)) {
                    int maxVal = maxFile.readAll().trimmed().toInt();
                    maxFile.close();
                    if (maxVal > 0) {
                        int hwVal = std::clamp((b * maxVal) / 100, (10 * maxVal) / 100, maxVal);
                        QFile curFile(curPath);
                        if (curFile.open(QIODevice::WriteOnly | QIODevice::Text)) {
                            curFile.write(QByteArray::number(hwVal));
                            curFile.close();
                        }
                    }
                }
            }
        }

        emit brightnessChanged();
    }
}

void SystemBackend::setSelectedLanguage(const QString &lang)
{
    if (m_selectedLanguage != lang) {
        m_selectedLanguage = lang;
        if (m_persistence) {
            m_persistence->setSetting(QStringLiteral("sys_selectedLanguage"), lang);
        }
        emit selectedLanguageChanged();
    }
}

void SystemBackend::setSelectedKeyboard(const QString &kb)
{
    if (m_selectedKeyboard != kb) {
        m_selectedKeyboard = kb;
        if (m_persistence) {
            m_persistence->setSetting(QStringLiteral("sys_selectedKeyboard"), kb);
        }
        emit selectedKeyboardChanged();
    }
}

void SystemBackend::setSelectedAutofill(const QString &af)
{
    if (m_selectedAutofill != af) {
        m_selectedAutofill = af;
        if (m_persistence) {
            m_persistence->setSetting(QStringLiteral("sys_selectedAutofill"), af);
        }
        emit selectedAutofillChanged();
    }
}

void SystemBackend::setPointerSpeed(int speed)
{
    speed = std::clamp(speed, 0, 100);
    if (m_pointerSpeed != speed) {
        m_pointerSpeed = speed;
        if (m_persistence) {
            m_persistence->setSetting(QStringLiteral("sys_pointerSpeed"), speed);
        }
        emit pointerSpeedChanged();
    }
}

void SystemBackend::playTtsSample(const QString &text, double rate, double pitch)
{
    Q_UNUSED(pitch);
    stopTts();

    int wpm = (rate > 10.0) ? static_cast<int>(110 + (rate / 100.0) * 140) : 175;

    m_ttsProcess = new QProcess(this);
    connect(m_ttsProcess, QOverload<int, QProcess::ExitStatus>::of(&QProcess::finished),
            this, [this](int exitCode, QProcess::ExitStatus exitStatus) {
        Q_UNUSED(exitCode);
        if (m_ttsProcess) {
            m_ttsProcess->deleteLater();
            m_ttsProcess = nullptr;
        }
        if (exitStatus == QProcess::NormalExit) {
            emit ttsFinished();
        }
    });

#if defined(Q_OS_MACOS)
    QStringList args;
    args << "-r" << QString::number(wpm) << text;
    m_ttsProcess->start("say", args);
#else
    QString scriptPath = QCoreApplication::applicationDirPath() + "/scripts/apex_news_tts.py";
    if (!QFile::exists(scriptPath)) {
        scriptPath = "/opt/apex_vision_ivi/scripts/apex_news_tts.py";
    }
    QStringList args;
    args << scriptPath << "--play" << "--text" << text << "--rate" << QString::number(rate);
    m_ttsProcess->start("python3", args);
#endif
}

void SystemBackend::stopTts()
{
    if (m_ttsProcess) {
        m_ttsProcess->disconnect(this);
        m_ttsProcess->kill();
        m_ttsProcess->waitForFinished(300);
        m_ttsProcess->deleteLater();
        m_ttsProcess = nullptr;
    }
#if !defined(Q_OS_MACOS)
    QProcess::execute("pkill", QStringList() << "-9" << "-f" << "apex_news_tts.py");
    QProcess::execute("pkill", QStringList() << "-9" << "-f" << "gst-launch-1.0.*playbin");
#endif
}

void SystemBackend::setUnitsTemperature(const QString &unit)
{
    if (m_unitsTemperature != unit) {
        m_unitsTemperature = unit;
        if (m_persistence) {
            m_persistence->setSetting(QStringLiteral("sys_unitsTemperature"), unit);
        }
        emit unitsTemperatureChanged();
    }
}

void SystemBackend::setVolumePrompts(int vol)
{
    vol = std::clamp(vol, 0, 30);
    if (m_volumePrompts != vol) {
        m_volumePrompts = vol;
        if (m_persistence) {
            m_persistence->setSetting(QStringLiteral("sys_vol_prompts"), m_volumePrompts);
        }
        emit volumePromptsChanged();
    }
}

void SystemBackend::setVolumePhone(int vol)
{
    vol = std::clamp(vol, 0, 30);
    if (m_volumePhone != vol) {
        m_volumePhone = vol;
        if (m_persistence) {
            m_persistence->setSetting(QStringLiteral("sys_vol_phone"), m_volumePhone);
        }
        emit volumePhoneChanged();
    }
}

void SystemBackend::setVolumeCallRing(int vol)
{
    vol = std::clamp(vol, 0, 30);
    if (m_volumeCallRing != vol) {
        m_volumeCallRing = vol;
        if (m_persistence) {
            m_persistence->setSetting(QStringLiteral("sys_vol_ring"), m_volumeCallRing);
        }
        emit volumeCallRingChanged();
    }
}

void SystemBackend::setTouchSoundsEnabled(bool enabled)
{
    if (m_touchSoundsEnabled != enabled) {
        m_touchSoundsEnabled = enabled;
        if (m_persistence) {
            m_persistence->setSetting(QStringLiteral("sys_touchSoundsEnabled"), enabled);
        }
        emit touchSoundsEnabledChanged();
    }
}

void SystemBackend::playTouchSound()
{
    if (!m_touchSoundsEnabled) return;

    static QElapsedTimer lastTouchTimer;
    static bool timerStarted = false;
    if (timerStarted && lastTouchTimer.elapsed() < 50) {
        return;
    }
    lastTouchTimer.restart();
    timerStarted = true;

    static QString soundPath;
    if (soundPath.isEmpty()) {
        const QStringList candidates = {
            QStringLiteral("/opt/apex_vision_ivi/qml/assets/sounds/touch_click.wav"),
            QStringLiteral("/Users/reno/Projects/APEX_VISION_IVI/qml/assets/sounds/touch_click.wav"),
            QDir::currentPath() + QStringLiteral("/qml/assets/sounds/touch_click.wav"),
            QCoreApplication::applicationDirPath() + QStringLiteral("/qml/assets/sounds/touch_click.wav"),
            QCoreApplication::applicationDirPath() + QStringLiteral("/../Resources/qml/assets/sounds/touch_click.wav")
        };
        for (const QString &p : candidates) {
            if (QFile::exists(p)) {
                soundPath = p;
                break;
            }
        }
        if (soundPath.isEmpty() && QFile::exists(QStringLiteral(":/ApexVision/qml/assets/sounds/touch_click.wav"))) {
            QString tmpPath = QDir::tempPath() + QStringLiteral("/apex_touch_click.wav");
            QFile::remove(tmpPath);
            if (QFile::copy(QStringLiteral(":/ApexVision/qml/assets/sounds/touch_click.wav"), tmpPath)) {
                soundPath = tmpPath;
            }
        }
    }

    if (!soundPath.isEmpty()) {
#if defined(Q_OS_MACOS)
        QProcess::startDetached(QStringLiteral("afplay"), {QStringLiteral("-v"), QStringLiteral("0.35"), soundPath});
#elif defined(Q_OS_LINUX)
        QProcess::startDetached(QStringLiteral("aplay"), {QStringLiteral("-D"), QStringLiteral("pipewire"), QStringLiteral("-q"), soundPath});
#endif
    }
}

void SystemBackend::playSound(const QString &soundName)
{
    QString baseName = soundName.trimmed();
    if (!baseName.endsWith(QStringLiteral(".wav"))) {
        baseName += QStringLiteral(".wav");
    }

    const QStringList candidates = {
        QCoreApplication::applicationDirPath() + QStringLiteral("/qml/assets/sounds/") + baseName,
        QStringLiteral("/opt/apex_vision_ivi/qml/assets/sounds/") + baseName,
        QDir::currentPath() + QStringLiteral("/qml/assets/sounds/") + baseName,
        QCoreApplication::applicationDirPath() + QStringLiteral("/../Resources/qml/assets/sounds/") + baseName
    };

    QString targetPath;
    for (const QString &p : candidates) {
        if (QFile::exists(p)) {
            targetPath = p;
            break;
        }
    }

    if (targetPath.isEmpty()) {
        const QString resPath = QStringLiteral(":/ApexVision/qml/assets/sounds/") + baseName;
        if (QFile::exists(resPath)) {
            QString tmpPath = QDir::tempPath() + QStringLiteral("/apex_") + baseName;
            QFile::remove(tmpPath);
            if (QFile::copy(resPath, tmpPath)) {
                targetPath = tmpPath;
            }
        }
    }

    if (!targetPath.isEmpty()) {
#if defined(Q_OS_MACOS)
        QProcess::startDetached(QStringLiteral("afplay"), {QStringLiteral("-v"), QStringLiteral("0.5"), targetPath});
#elif defined(Q_OS_LINUX)
        QProcess::startDetached(QStringLiteral("aplay"), {QStringLiteral("-D"), QStringLiteral("pipewire"), QStringLiteral("-q"), targetPath});
#endif
    }
}

void SystemBackend::updateNetworkSpeed()
{
    qint64 currentRx = 0;
    qint64 currentTx = 0;
    bool found = false;

#if defined(Q_OS_LINUX)
    QFile file(QStringLiteral("/proc/net/dev"));
    if (file.open(QIODevice::ReadOnly)) {
        const QByteArray data = file.readAll();
        const QString content = QString::fromUtf8(data);
        const QStringList lines = content.split(QLatin1Char('\n'), Qt::SkipEmptyParts);
        for (const QString &line : lines) {
            if (line.contains(QLatin1String("wlan0:")) || line.contains(QLatin1String("eth0:"))) {
                const QStringList tokens = line.split(QRegularExpression(QStringLiteral("\\s+")), Qt::SkipEmptyParts);
                if (tokens.size() >= 10) {
                    qint64 rx = tokens[1].toLongLong();
                    qint64 tx = tokens[9].toLongLong();
                    currentRx += rx;
                    currentTx += tx;
                    found = true;
                }
            }
        }
    }
#endif

    const qint64 now = QDateTime::currentMSecsSinceEpoch();
    if (found && m_lastNetTime > 0 && now > m_lastNetTime) {
        const double deltaSec = (now - m_lastNetTime) / 1000.0;
        if (deltaSec > 0.1) {
            m_downloadBytesPerSec = qMax(0.0, static_cast<double>(currentRx - m_lastRxBytes) / deltaSec);
            m_uploadBytesPerSec = qMax(0.0, static_cast<double>(currentTx - m_lastTxBytes) / deltaSec);
        }
    } else if (!m_wifiConnected) {
        m_downloadBytesPerSec = 0.0;
        m_uploadBytesPerSec = 0.0;
    }

    if (found) {
        m_lastRxBytes = currentRx;
        m_lastTxBytes = currentTx;
        m_lastNetTime = now;
    }

    auto formatRate = [](double bytesPerSec) -> QString {
        if (bytesPerSec <= 0.0) return QStringLiteral("0 B");
        if (bytesPerSec < 1024.0) return QString::number(qRound(bytesPerSec)) + QStringLiteral(" B");
        if (bytesPerSec < 1024.0 * 1024.0) {
            double kb = bytesPerSec / 1024.0;
            return QString::number(kb, 'f', (kb < 10.0) ? 1 : 0) + QStringLiteral(" kB");
        }
        double mb = bytesPerSec / (1024.0 * 1024.0);
        return QString::number(mb, 'f', 1) + QStringLiteral(" MB");
    };

    m_downloadSpeed = formatRate(m_downloadBytesPerSec);
    m_uploadSpeed = formatRate(m_uploadBytesPerSec);
    emit netSpeedChanged();
}

void SystemBackend::refreshStorageInfo()
{
    QThreadPool::globalInstance()->start([this]() {
        // 1. Physical root filesystem storage metrics
        QStorageInfo storage = QStorageInfo::root();
        if (!storage.isValid() || storage.bytesTotal() <= 0) {
            storage = QStorageInfo(QDir::currentPath());
        }

        qint64 totalBytes = storage.bytesTotal();
        qint64 freeBytes = storage.bytesAvailable();
        qint64 usedBytes = (totalBytes > freeBytes) ? (totalBytes - freeBytes) : 0;

        double totalGb = (totalBytes > 0) ? ((double)totalBytes / (1024.0 * 1024.0 * 1024.0)) : 115.3;
        double freeGb = (freeBytes > 0) ? ((double)freeBytes / (1024.0 * 1024.0 * 1024.0)) : 108.6;
        double usedGb = (usedBytes > 0) ? ((double)usedBytes / (1024.0 * 1024.0 * 1024.0)) : 1.9;
        int percentUsed = (totalGb > 0.0) ? qBound(1, (int)std::round((usedGb / totalGb) * 100.0), 99) : 2;

        // 2. Component breakdown in /opt/apex_vision_ivi
        QString baseDir = QStringLiteral("/opt/apex_vision_ivi");
        if (!QDir(baseDir).exists()) {
            baseDir = QCoreApplication::applicationDirPath();
        }

        auto dirSizeBytes = [](const QString &path) -> qint64 {
            qint64 sz = 0;
            QDir dir(path);
            if (!dir.exists()) return 0;
            QDirIterator it(path, QDir::Files | QDir::Hidden | QDir::NoSymLinks, QDirIterator::Subdirectories);
            while (it.hasNext()) {
                it.next();
                sz += it.fileInfo().size();
            }
            return sz;
        };

        qint64 mediaBytes = dirSizeBytes(baseDir + QStringLiteral("/assets"));
        qint64 mapsBytes = dirSizeBytes(baseDir + QStringLiteral("/web"));
        qint64 qmlBytes = dirSizeBytes(baseDir + QStringLiteral("/qml"));
        qint64 binBytes = QFileInfo(baseDir + QStringLiteral("/apex_vision_ivi")).size()
                        + QFileInfo(baseDir + QStringLiteral("/assets.rcc")).size();
        qint64 appBytes = qmlBytes + binBytes;

        double mediaGb = (double)mediaBytes / (1024.0 * 1024.0 * 1024.0);
        double mapsGb = (double)mapsBytes / (1024.0 * 1024.0 * 1024.0);
        double appGb = (double)appBytes / (1024.0 * 1024.0 * 1024.0);

        // System OS / Linux firmware is the remainder of used storage
        double sysGb = usedGb - (mediaGb + mapsGb + appGb);
        if (sysGb < 0.2) sysGb = 1.35;

        QString summary = QStringLiteral("%1 GB used of %2 GB (%3 GB available)")
                            .arg(QString::number(usedGb, 'f', 1))
                            .arg(QString::number(totalGb, 'f', 0))
                            .arg(QString::number(freeGb, 'f', 1));

        QMetaObject::invokeMethod(this, [this, totalGb, usedGb, freeGb, sysGb, appGb, mediaGb, mapsGb, percentUsed, summary]() {
            m_storageTotalGb = totalGb;
            m_storageUsedGb = usedGb;
            m_storageFreeGb = freeGb;
            m_storageSystemGb = sysGb;
            m_storageAppGb = appGb;
            m_storageMediaGb = mediaGb;
            m_storageMapsGb = mapsGb;
            m_storagePercentUsed = percentUsed;
            m_storageSummaryText = summary;
            emit storageChanged();
        }, Qt::QueuedConnection);
    });
}


