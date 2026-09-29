#pragma once

#include <QObject>
#include <QString>
#include <QTimer>

class SeatBackend : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString position READ position NOTIFY positionChanged)
    Q_PROPERTY(int reclineAngle READ reclineAngle NOTIFY reclineAngleChanged)
    Q_PROPERTY(int massageLevel READ massageLevel NOTIFY massageLevelChanged)
    Q_PROPERTY(bool massageActive READ massageActive NOTIFY massageActiveChanged)
    Q_PROPERTY(QString massageMode READ massageMode NOTIFY massageModeChanged)

public:
    explicit SeatBackend(QObject *parent = nullptr);

    QString position() const { return m_position; }
    int reclineAngle() const { return m_reclineAngle; }
    int massageLevel() const { return m_massageLevel; }
    bool massageActive() const { return m_massageActive; }
    QString massageMode() const { return m_massageMode; }

    Q_INVOKABLE void moveToRelaxPosition();
    Q_INVOKABLE void moveToPosition(const QString &pos, int angle = 45);
    Q_INVOKABLE void restorePreviousPosition(const QString &pos = "Standard", int angle = 18);
    Q_INVOKABLE void startMassage(int level = 2, const QString &mode = "Wave");
    Q_INVOKABLE void stopMassage();
    Q_INVOKABLE void setReclineAngle(int angle);

signals:
    void positionChanged();
    void reclineAngleChanged();
    void massageLevelChanged();
    void massageActiveChanged();
    void massageModeChanged();

private slots:
    void onTransitionStep();

private:
    QString m_position{"Standard"};
    int m_reclineAngle{18};
    int m_massageLevel{0};
    bool m_massageActive{false};
    QString m_massageMode{"Off"};

    int m_targetAngle{18};
    QTimer m_transitionTimer;
};
