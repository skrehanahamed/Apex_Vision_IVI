#pragma once

#include <QObject>

class PhoneBackend : public QObject
{
    Q_OBJECT

    Q_PROPERTY(bool isConnected READ isConnected NOTIFY isConnectedChanged)
    Q_PROPERTY(QString deviceName READ deviceName NOTIFY deviceNameChanged)
    Q_PROPERTY(int signalBars READ signalBars NOTIFY signalBarsChanged)
    Q_PROPERTY(int batteryPercent READ batteryPercent NOTIFY batteryPercentChanged)
    Q_PROPERTY(bool hasNotification READ hasNotification NOTIFY hasNotificationChanged)

public:
    explicit PhoneBackend(QObject *parent = nullptr);

    bool isConnected() const { return m_isConnected; }
    QString deviceName() const { return m_deviceName; }
    int signalBars() const { return m_signalBars; }
    int batteryPercent() const { return m_batteryPercent; }
    bool hasNotification() const { return m_hasNotification; }

    Q_INVOKABLE void toggleConnection();
    Q_INVOKABLE void setConnected(bool connected);
    Q_INVOKABLE void clearNotification();

signals:
    void isConnectedChanged();
    void deviceNameChanged();
    void signalBarsChanged();
    void batteryPercentChanged();
    void hasNotificationChanged();

private:
    bool m_isConnected{false};
    QString m_deviceName{"iPhone 16 Pro"};
    int m_signalBars{4};
    int m_batteryPercent{92};
    bool m_hasNotification{true};
};
