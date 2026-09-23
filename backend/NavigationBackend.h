#pragma once

#include <QObject>
#include <QString>
#include <QUrl>

class VehicleSimulator;

class NavigationBackend : public QObject
{
    Q_OBJECT

    // Position & Coordinates
    Q_PROPERTY(double latitude READ latitude WRITE setLatitude NOTIFY positionChanged)
    Q_PROPERTY(double longitude READ longitude WRITE setLongitude NOTIFY positionChanged)
    Q_PROPERTY(double heading READ heading WRITE setHeading NOTIFY positionChanged)
    Q_PROPERTY(double speed READ speed NOTIFY gpsUpdated)

    // Configuration & Map Resources
    Q_PROPERTY(QString apiKey READ apiKey WRITE setApiKey NOTIFY apiKeyChanged)
    Q_PROPERTY(QUrl mapUrl READ mapUrl CONSTANT)

    // Street, Routing & Telemetry
    Q_PROPERTY(QString currentStreet READ currentStreet WRITE setCurrentStreet NOTIFY currentStreetChanged)
    Q_PROPERTY(QString nextStreet READ nextStreet WRITE setNextStreet NOTIFY nextStreetChanged)
    Q_PROPERTY(QString destination READ destination WRITE setDestination NOTIFY destinationChanged)
    Q_PROPERTY(QString eta READ eta WRITE setEta NOTIFY etaChanged)
    Q_PROPERTY(QString remainingDistance READ remainingDistance WRITE setRemainingDistance NOTIFY remainingDistanceChanged)
    Q_PROPERTY(QString maneuverInstruction READ maneuverInstruction NOTIFY maneuverInstructionChanged)
    Q_PROPERTY(int zoomLevel READ zoomLevel WRITE setZoomLevel NOTIFY zoomLevelChanged)

public:
    explicit NavigationBackend(VehicleSimulator *simulator, QObject *parent = nullptr);

    double latitude() const { return m_latitude; }
    double longitude() const { return m_longitude; }
    double heading() const { return m_heading; }
    double speed() const { return m_speed; }
    QString apiKey() const { return m_apiKey; }
    QUrl mapUrl() const;
    QString currentStreet() const { return m_currentStreet; }
    QString nextStreet() const { return m_nextStreet; }
    QString destination() const { return m_destination; }
    QString eta() const { return m_eta; }
    QString remainingDistance() const { return m_remainingDistance; }
    QString maneuverInstruction() const { return m_maneuverInstruction; }
    int zoomLevel() const { return m_zoomLevel; }

    Q_INVOKABLE void setLatitude(double lat);
    Q_INVOKABLE void setLongitude(double lon);
    Q_INVOKABLE void setHeading(double heading);
    Q_INVOKABLE void setVehiclePosition(double lat, double lon, double heading = 0.0);
    Q_INVOKABLE void setApiKey(const QString &key);

    Q_INVOKABLE void setCurrentStreet(const QString &street);
    Q_INVOKABLE void setNextStreet(const QString &street);
    Q_INVOKABLE void setDestination(const QString &dest);
    Q_INVOKABLE void setEta(const QString &eta);
    Q_INVOKABLE void setRemainingDistance(const QString &dist);
    Q_INVOKABLE void setZoomLevel(int zoom);
    Q_INVOKABLE void zoomIn();
    Q_INVOKABLE void zoomOut();
    Q_INVOKABLE void searchDestination(const QString &query);
    Q_INVOKABLE void requestReverseGeocode(double lat, double lon);
    Q_INVOKABLE void fetchRealLocation();

signals:
    void positionChanged();
    void gpsUpdated();
    void apiKeyChanged();
    void currentStreetChanged();
    void nextStreetChanged();
    void destinationChanged();
    void etaChanged();
    void remainingDistanceChanged();
    void maneuverInstructionChanged();
    void zoomLevelChanged();

private slots:
    void onGpsUpdated(double lat, double lon, double heading, double speed);

private:
    VehicleSimulator *m_simulator{nullptr};
    double m_latitude{12.9719445};
    double m_longitude{77.5936873};
    double m_heading{42.0};
    double m_speed{68.0};
    bool m_hasRealLocation{false};
    QString m_apiKey{""};
    QString m_currentStreet{"Kasturba Road"};
    QString m_nextStreet{"Cubbon Park Rd"};
    QString m_destination{"Vidhana Soudha"};
    QString m_eta{"12:48"};
    QString m_remainingDistance{"3.2 km"};
    QString m_maneuverInstruction{"In 400m, turn left"};
    int m_zoomLevel{16};

    double m_lastGeocodedLat{0.0};
    double m_lastGeocodedLon{0.0};
};
