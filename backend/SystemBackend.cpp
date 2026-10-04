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
#include <QElapsedTimer>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QJsonDocument>
#include <QJsonObject>
#include <QRegularExpression>
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
    connect(&m_wifiStatusTimer, &QTimer::timeout, this, &SystemBackend::updateWifiStatus);
    m_wifiStatusTimer.start(4000);
    QTimer::singleShot(300, this, &SystemBackend::updateWifiStatus);
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
    // Run "iw dev wlan0 link" to fetch live Wi-Fi SSID, frequency, and signal
    QProcess process;
    process.start(QStringLiteral("iw"), {QStringLiteral("dev"), QStringLiteral("wlan0"), QStringLiteral("link")});
    if (process.waitForFinished(800)) {
        const QString output = QString::fromUtf8(process.readAllStandardOutput());
        if (output.contains(QStringLiteral("Connected to"), Qt::CaseInsensitive)) {
            setWifiConnected(true);

            // Parse SSID
            static const QRegularExpression ssidRe(QStringLiteral("SSID:\\s*(.+)"));
            auto ssidMatch = ssidRe.match(output);
            if (ssidMatch.hasMatch()) {
                QString ssid = ssidMatch.captured(1).trimmed();
                if (m_wifiSsid != ssid) {
                    m_wifiSsid = ssid;
                    emit wifiSsidChanged();
                }
            }

            // Parse Frequency: 5GHz vs 2.4/2.5GHz band
            static const QRegularExpression freqRe(QStringLiteral("freq:\\s*([0-9]+)"));
            auto freqMatch = freqRe.match(output);
            if (freqMatch.hasMatch()) {
                int freq = freqMatch.captured(1).toInt();
                QString detectedBand;
                if (freq >= 4900) {
                    detectedBand = QStringLiteral("5G");
                } else if (freq > 0) {
                    detectedBand = QStringLiteral("2.5G");
                }
                if (!detectedBand.isEmpty() && m_wifiBand != detectedBand) {
                    m_wifiBand = detectedBand;
                    emit wifiBandChanged();
                }
            }

            // Parse Signal dBm into 1-4 bars
            static const QRegularExpression sigRe(QStringLiteral("signal:\\s*(-?[0-9]+)\\s*dBm"));
            auto sigMatch = sigRe.match(output);
            if (sigMatch.hasMatch()) {
                int dbm = sigMatch.captured(1).toInt();
                int bars = 1;
                if (dbm >= -58) bars = 4;
                else if (dbm >= -68) bars = 3;
                else if (dbm >= -78) bars = 2;
                if (m_wifiSignalBars != bars) {
                    m_wifiSignalBars = bars;
                    emit wifiSignalBarsChanged();
                }
            }
            return;
        } else if (output.contains(QStringLiteral("Not connected"), Qt::CaseInsensitive)) {
            setWifiConnected(false);
            if (m_wifiSignalBars != 0) {
                m_wifiSignalBars = 0;
                emit wifiSignalBarsChanged();
            }
            return;
        }
    }

    // Fallback: try wpa_cli if iw produced no output
    QProcess wpaProcess;
    wpaProcess.start(QStringLiteral("wpa_cli"), {QStringLiteral("-i"), QStringLiteral("wlan0"), QStringLiteral("status")});
    if (wpaProcess.waitForFinished(800)) {
        const QString wpaOut = QString::fromUtf8(wpaProcess.readAllStandardOutput());
        if (wpaOut.contains(QStringLiteral("wpa_state=COMPLETED"))) {
            setWifiConnected(true);
            static const QRegularExpression freqRe(QStringLiteral("freq=([0-9]+)"));
            auto freqMatch = freqRe.match(wpaOut);
            if (freqMatch.hasMatch()) {
                int freq = freqMatch.captured(1).toInt();
                QString detectedBand = (freq >= 4900) ? QStringLiteral("5G") : QStringLiteral("2.5G");
                if (m_wifiBand != detectedBand) {
                    m_wifiBand = detectedBand;
                    emit wifiBandChanged();
                }
            }
            return;
        }
    }
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

    QStringList args;
    args << "-r" << QString::number(wpm) << text;
    m_ttsProcess->start("say", args);
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
