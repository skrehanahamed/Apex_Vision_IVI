#include "NavigationBackend.h"
#include "VehicleSimulator.h"
#include <algorithm>
#include <cstdlib>
#include <cmath>
#include <QCoreApplication>
#include <QFileInfo>
#include <QDir>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QJsonDocument>
#include <QJsonObject>

NavigationBackend::NavigationBackend(VehicleSimulator *simulator, QObject *parent)
    : QObject(parent)
    , m_simulator(simulator)
{
    // Check environment variable for runtime API key override
    const char *envKey = std::getenv("GOOGLE_MAPS_API_KEY");
    if (envKey && envKey[0] != '\0') {
        m_apiKey = QString::fromUtf8(envKey);
    }

    if (m_simulator) {
        connect(m_simulator, &VehicleSimulator::gpsUpdated,
                this, &NavigationBackend::onGpsUpdated);
    }

    // Automatically detect and acquire the user's real current location via live GPS/IP
    fetchRealLocation();

    // Initial reverse geocode lookup
    requestReverseGeocode(m_latitude, m_longitude);
}

QUrl NavigationBackend::mapUrl() const
{
    // Try local filesystem web/map.html first if running in dev mode
    QString appDir = QCoreApplication::applicationDirPath();
    QString localPath = appDir + "/../web/map.html";
    if (QFileInfo::exists(localPath)) {
        return QUrl::fromLocalFile(QFileInfo(localPath).canonicalFilePath());
    }

    // Try relative to current working directory
    if (QFileInfo::exists("web/map.html")) {
        return QUrl::fromLocalFile(QFileInfo("web/map.html").canonicalFilePath());
    }

    // Fallback to embedded resource
    return QUrl(QStringLiteral("qrc:/ApexVision/web/map.html"));
}

void NavigationBackend::onGpsUpdated(double lat, double lon, double heading, double speed)
{
    bool posChanged = (m_latitude != lat || m_longitude != lon || m_heading != heading);
    m_latitude = lat;
    m_longitude = lon;
    m_heading = heading;
    m_speed = speed;
    if (posChanged) {
        emit positionChanged();
    }
    emit gpsUpdated();
}

void NavigationBackend::setLatitude(double lat)
{
    if (m_latitude != lat) {
        m_latitude = lat;
        emit positionChanged();
        emit gpsUpdated();
    }
}

void NavigationBackend::setLongitude(double lon)
{
    if (m_longitude != lon) {
        m_longitude = lon;
        emit positionChanged();
        emit gpsUpdated();
    }
}

void NavigationBackend::setHeading(double heading)
{
    if (m_heading != heading) {
        m_heading = heading;
        emit positionChanged();
        emit gpsUpdated();
    }
}

void NavigationBackend::setVehiclePosition(double lat, double lon, double heading)
{
    m_latitude = lat;
    m_longitude = lon;
    m_heading = heading;
    emit positionChanged();
    emit gpsUpdated();
}

void NavigationBackend::setApiKey(const QString &key)
{
    if (m_apiKey != key) {
        m_apiKey = key;
        emit apiKeyChanged();
    }
}

void NavigationBackend::setCurrentStreet(const QString &street)
{
    if (m_currentStreet != street) {
        m_currentStreet = street;
        emit currentStreetChanged();
    }
}

void NavigationBackend::setNextStreet(const QString &street)
{
    if (m_nextStreet != street) {
        m_nextStreet = street;
        emit nextStreetChanged();
    }
}

void NavigationBackend::setDestination(const QString &dest)
{
    if (m_destination != dest) {
        m_destination = dest;
        emit destinationChanged();
    }
}

void NavigationBackend::setEta(const QString &eta)
{
    if (m_eta != eta) {
        m_eta = eta;
        emit etaChanged();
    }
}

void NavigationBackend::setRemainingDistance(const QString &dist)
{
    if (m_remainingDistance != dist) {
        m_remainingDistance = dist;
        emit remainingDistanceChanged();
    }
}

void NavigationBackend::setZoomLevel(int zoom)
{
    zoom = std::clamp(zoom, 1, 21);
    if (m_zoomLevel != zoom) {
        m_zoomLevel = zoom;
        emit zoomLevelChanged();
    }
}

void NavigationBackend::zoomIn()
{
    setZoomLevel(m_zoomLevel + 1);
}

void NavigationBackend::zoomOut()
{
    setZoomLevel(m_zoomLevel - 1);
}

void NavigationBackend::searchDestination(const QString &query)
{
    setDestination(query);
    setRemainingDistance("3.2 km");
    setEta("13:10");
}

void NavigationBackend::fetchRealLocation()
{
    QNetworkAccessManager *manager = new QNetworkAccessManager(this);
    QNetworkRequest request{QUrl("https://ipwho.is/")};
    request.setHeader(QNetworkRequest::UserAgentHeader, "ApexVisionIVI/1.0");

    QNetworkReply *reply = manager->get(request);
    connect(reply, &QNetworkReply::finished, this, [this, manager, reply]() {
        reply->deleteLater();
        manager->deleteLater();

        bool success = false;
        if (reply->error() == QNetworkReply::NoError) {
            QByteArray data = reply->readAll();
            QJsonDocument doc = QJsonDocument::fromJson(data);
            if (doc.isObject()) {
                QJsonObject root = doc.object();
                if (root.value("success").toBool(true) && root.contains("latitude") && root.contains("longitude")) {
                    double lat = root.value("latitude").toDouble();
                    double lon = root.value("longitude").toDouble();
                    if (lat != 0.0 && lon != 0.0) {
                        m_hasRealLocation = true;
                        m_latitude = lat;
                        m_longitude = lon;
                        if (m_simulator) {
                            m_simulator->setPosition(m_latitude, m_longitude, m_heading);
                        }
                        emit positionChanged();
                        emit gpsUpdated();
                        requestReverseGeocode(m_latitude, m_longitude);
                        success = true;
                    }
                }
            }
        }

        // Secondary fallback to ipapi.co if ipwho.is was unreachable
        if (!success) {
            QNetworkAccessManager *fallbackMgr = new QNetworkAccessManager(this);
            QNetworkRequest fallbackReq{QUrl("https://ipapi.co/json/")};
            fallbackReq.setHeader(QNetworkRequest::UserAgentHeader, "ApexVisionIVI/1.0");
            QNetworkReply *fallbackReply = fallbackMgr->get(fallbackReq);
            connect(fallbackReply, &QNetworkReply::finished, this, [this, fallbackMgr, fallbackReply]() {
                fallbackReply->deleteLater();
                fallbackMgr->deleteLater();
                if (fallbackReply->error() == QNetworkReply::NoError) {
                    QByteArray fData = fallbackReply->readAll();
                    QJsonDocument fDoc = QJsonDocument::fromJson(fData);
                    if (fDoc.isObject()) {
                        QJsonObject fRoot = fDoc.object();
                        double lat = fRoot.value("latitude").toDouble();
                        double lon = fRoot.value("longitude").toDouble();
                        if (lat != 0.0 && lon != 0.0) {
                            m_hasRealLocation = true;
                            m_latitude = lat;
                            m_longitude = lon;
                            if (m_simulator) {
                                m_simulator->setPosition(m_latitude, m_longitude, m_heading);
                            }
                            emit positionChanged();
                            emit gpsUpdated();
                            requestReverseGeocode(m_latitude, m_longitude);
                        }
                    }
                }
            });
        }
    });
}

void NavigationBackend::requestReverseGeocode(double lat, double lon)
{
    if (std::abs(m_lastGeocodedLat - lat) < 0.0001 && std::abs(m_lastGeocodedLon - lon) < 0.0001 && !m_currentStreet.isEmpty() && m_currentStreet != "Merritton Rd") {
        return;
    }
    m_lastGeocodedLat = lat;
    m_lastGeocodedLon = lon;
    QString urlStr = QString("https://nominatim.openstreetmap.org/reverse?lat=%1&lon=%2&format=json&zoom=18&addressdetails=1")
        .arg(lat, 0, 'f', 6)
        .arg(lon, 0, 'f', 6);
    QNetworkRequest request{QUrl(urlStr)};
    request.setHeader(QNetworkRequest::UserAgentHeader, "ApexVisionIVI/1.0 (Automotive Cockpit)");

    QNetworkAccessManager *manager = new QNetworkAccessManager(this);
    QNetworkReply *reply = manager->get(request);
    connect(reply, &QNetworkReply::finished, this, [this, manager, reply]() {
        reply->deleteLater();
        manager->deleteLater();
        if (reply->error() == QNetworkReply::NoError) {
            QByteArray data = reply->readAll();
            QJsonDocument doc = QJsonDocument::fromJson(data);
            if (doc.isObject()) {
                QJsonObject root = doc.object();
                QJsonObject addr = root.value("address").toObject();
                QString street = addr.value("road").toString();
                if (street.isEmpty()) street = addr.value("pedestrian").toString();
                if (street.isEmpty()) street = addr.value("suburb").toString();
                if (street.isEmpty()) street = addr.value("neighbourhood").toString();
                if (street.isEmpty()) street = root.value("name").toString();
                if (!street.isEmpty()) {
                    setCurrentStreet(street);
                }
            }
        }
    });
}

