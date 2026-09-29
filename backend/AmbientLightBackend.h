#pragma once

#include <QObject>
#include <QColor>
#include <QTimer>
#include <QElapsedTimer>

class AmbientLightBackend : public QObject
{
    Q_OBJECT

    Q_PROPERTY(bool enabled READ enabled WRITE setEnabled NOTIFY enabledChanged)
    Q_PROPERTY(QString color READ color WRITE setColor NOTIFY colorChanged)
    Q_PROPERTY(int brightness READ brightness WRITE setBrightness NOTIFY brightnessChanged)
    Q_PROPERTY(QString profileName READ profileName WRITE setProfileName NOTIFY profileNameChanged)

public:
    explicit AmbientLightBackend(QObject *parent = nullptr);

    bool enabled() const { return m_enabled; }
    QString color() const { return m_color.name(QColor::HexRgb); }
    int brightness() const { return m_brightness; }
    QString profileName() const { return m_profileName; }

    Q_INVOKABLE void setEnabled(bool e);
    Q_INVOKABLE void setColor(const QString &hexColor);
    Q_INVOKABLE void setBrightness(int b);
    Q_INVOKABLE void setProfileName(const QString &name);
    Q_INVOKABLE void fadeTo(const QString &targetHex, int targetBrightness, int durationMs = 2500);
    Q_INVOKABLE void fadeOut(int durationMs = 2000);

signals:
    void enabledChanged();
    void colorChanged();
    void brightnessChanged();
    void profileNameChanged();

private slots:
    void onFadeStep();

private:
    bool m_enabled{true};
    QColor m_color{QColor("#24D9FF")};
    int m_brightness{75};
    QString m_profileName{"Default"};

    QTimer m_fadeTimer;
    QElapsedTimer m_elapsedTimer;
    int m_fadeDurationMs{0};
    QColor m_startColor;
    QColor m_endColor;
    int m_startBrightness{0};
    int m_endBrightness{0};
};
