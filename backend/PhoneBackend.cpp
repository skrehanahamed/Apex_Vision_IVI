#include "PhoneBackend.h"

PhoneBackend::PhoneBackend(QObject *parent)
    : QObject(parent)
{
}

void PhoneBackend::toggleConnection()
{
    setConnected(!m_isConnected);
}

void PhoneBackend::setConnected(bool connected)
{
    if (m_isConnected != connected) {
        m_isConnected = connected;
        emit isConnectedChanged();
    }
}

void PhoneBackend::clearNotification()
{
    if (m_hasNotification) {
        m_hasNotification = false;
        emit hasNotificationChanged();
    }
}
