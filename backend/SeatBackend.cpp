#include "SeatBackend.h"
#include <QDebug>

SeatBackend::SeatBackend(QObject *parent)
    : QObject(parent)
{
    m_transitionTimer.setInterval(35);
    connect(&m_transitionTimer, &QTimer::timeout, this, &SeatBackend::onTransitionStep);
}

void SeatBackend::moveToRelaxPosition()
{
    moveToPosition("Relax", 45);
}

void SeatBackend::moveToPosition(const QString &pos, int angle)
{
    if (m_position != pos) {
        m_position = pos;
        emit positionChanged();
    }
    setReclineAngle(angle);
}

void SeatBackend::restorePreviousPosition(const QString &pos, int angle)
{
    moveToPosition(pos, angle);
}

void SeatBackend::startMassage(int level, const QString &mode)
{
    bool lvlChanged = (m_massageLevel != level);
    bool modeChanged = (m_massageMode != mode);
    bool actChanged = (!m_massageActive);

    m_massageLevel = level;
    m_massageMode = mode;
    m_massageActive = (level > 0);

    if (lvlChanged) emit massageLevelChanged();
    if (modeChanged) emit massageModeChanged();
    if (actChanged) emit massageActiveChanged();

    qInfo() << "[SeatBackend] Massage started:" << m_massageMode << "Level" << m_massageLevel;
}

void SeatBackend::stopMassage()
{
    if (m_massageActive || m_massageLevel != 0) {
        m_massageLevel = 0;
        m_massageActive = false;
        m_massageMode = "Off";
        emit massageLevelChanged();
        emit massageModeChanged();
        emit massageActiveChanged();
        qInfo() << "[SeatBackend] Massage stopped";
    }
}

void SeatBackend::setReclineAngle(int angle)
{
    m_targetAngle = qBound(15, angle, 65);
    if (m_reclineAngle != m_targetAngle && !m_transitionTimer.isActive()) {
        m_transitionTimer.start();
    }
}

void SeatBackend::onTransitionStep()
{
    if (m_reclineAngle == m_targetAngle) {
        m_transitionTimer.stop();
        return;
    }

    if (m_reclineAngle < m_targetAngle) {
        m_reclineAngle++;
    } else {
        m_reclineAngle--;
    }
    emit reclineAngleChanged();

    if (m_reclineAngle == m_targetAngle) {
        m_transitionTimer.stop();
        qInfo() << "[SeatBackend] Recline angle reached:" << m_reclineAngle << "degrees, position:" << m_position;
    }
}
