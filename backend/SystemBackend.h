#pragma once

#include <QObject>
#include <QTimer>
#include <QDateTime>

class SystemBackend : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString currentTime READ currentTime NOTIFY timeChanged)
    Q_PROPERTY(QString currentDate READ currentDate NOTIFY timeChanged)
    Q_PROPERTY(bool wifiConnected READ wifiConnected WRITE setWifiConnected NOTIFY wifiConnectedChanged)
    Q_PROPERTY(int brightness READ brightness WRITE setBrightness NOTIFY brightnessChanged)

public:
    explicit SystemBackend(QObject *parent = nullptr);

    QString currentTime() const { return m_currentTime; }
    QString currentDate() const { return m_currentDate; }
    bool wifiConnected() const { return m_wifiConnected; }
    int brightness() const { return m_brightness; }

    Q_INVOKABLE void setWifiConnected(bool connected);
    Q_INVOKABLE void setBrightness(int b);

signals:
    void timeChanged();
    void wifiConnectedChanged();
    void brightnessChanged();

private slots:
    void updateClock();

private:
    QTimer m_clockTimer;
    QString m_currentTime{"12:35"};
    QString m_currentDate{"Wednesday, Sep 23"};
    bool m_wifiConnected{true};
    int m_brightness{85};
};
