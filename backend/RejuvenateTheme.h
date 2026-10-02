/**
 * ==============================================================================
 * Project: Apex VISION IVI - Digital Cockpit & Infotainment System
 * File: RejuvenateTheme.h
 * Author / Developer: Sk Rehan Ahamed
 * License: MIT
 * ==============================================================================
 */

#pragma once

#include <QObject>
#include <QString>
#include <QUrl>
#include <QJsonObject>
#include <QVariantMap>
#include <memory>

class RejuvenateTheme : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString id READ id CONSTANT)
    Q_PROPERTY(QString name READ name CONSTANT)
    Q_PROPERTY(QString description READ description CONSTANT)
    Q_PROPERTY(QString longDescription READ longDescription CONSTANT)
    Q_PROPERTY(QString thumbnail READ thumbnail CONSTANT)
    Q_PROPERTY(QString previewImage READ previewImage CONSTANT)
    Q_PROPERTY(QString videoUrl READ videoUrlString CONSTANT)
    Q_PROPERTY(QString audioUrl READ audioUrlString CONSTANT)
    Q_PROPERTY(int duration READ duration CONSTANT)
    Q_PROPERTY(QString soundName READ soundName CONSTANT)
    Q_PROPERTY(double temperature READ temperature CONSTANT)
    Q_PROPERTY(QString fanMode READ fanMode CONSTANT)
    Q_PROPERTY(bool ac READ ac CONSTANT)
    Q_PROPERTY(QString ambientName READ ambientName CONSTANT)
    Q_PROPERTY(QString ambientColor READ ambientColor CONSTANT)
    Q_PROPERTY(int ambientBrightness READ ambientBrightness CONSTANT)
    Q_PROPERTY(QString seatPosition READ seatPosition CONSTANT)
    Q_PROPERTY(int massageLevel READ massageLevel CONSTANT)

public:
    explicit RejuvenateTheme(const QJsonObject &json, const QString &baseDir, QObject *parent = nullptr);
    RejuvenateTheme(const QString &id, const QString &name, const QString &description,
                    const QUrl &videoUrl, const QUrl &audioUrl, const QUrl &previewUrl,
                    int duration, double temp, const QString &fanMode, bool ac,
                    const QString &ambientColor, int ambientBrightness,
                    const QString &seatPos, int massageLevel, QObject *parent = nullptr);

    static std::shared_ptr<RejuvenateTheme> loadFromFile(const QString &filePath);

    QString id() const { return m_id; }
    QString name() const { return m_name; }
    QString description() const { return m_description; }
    QString longDescription() const { return m_longDescription; }
    QString thumbnail() const { return m_thumbnail; }
    QString previewImage() const { return m_previewImage; }
    QString videoUrlString() const { return m_videoUrl; }
    QString audioUrlString() const { return m_audioUrl; }
    QUrl videoUrl() const { return QUrl(m_videoUrl); }
    QUrl audioUrl() const { return QUrl(m_audioUrl); }
    int duration() const { return m_duration; }
    QString soundName() const { return m_soundName; }

    double temperature() const { return m_temperature; }
    double climateTemp() const { return m_temperature; }
    QString fanMode() const { return m_fanMode; }
    QString climateFanMode() const { return m_fanMode; }
    bool ac() const { return m_ac; }
    bool climateAc() const { return m_ac; }

    QString ambientName() const { return m_ambientName; }
    QString ambientColor() const { return m_ambientColor; }
    int ambientBrightness() const { return m_ambientBrightness; }
    QString seatPosition() const { return m_seatPosition; }
    int massageLevel() const { return m_massageLevel; }

    QVariantMap toVariantMap() const;
    QVariantMap toMap() const { return toVariantMap(); }

private:
    QString m_id;
    QString m_name;
    QString m_description;
    QString m_longDescription;
    QString m_thumbnail;
    QString m_previewImage;
    QString m_videoUrl;
    QString m_audioUrl;
    int m_duration{600};
    QString m_soundName{"Nature Mix"};
    double m_temperature{22.0};
    QString m_fanMode{"AUTO"};
    bool m_ac{true};
    QString m_ambientName{"Blue Aurora"};
    QString m_ambientColor{"#24D9FF"};
    int m_ambientBrightness{70};
    QString m_seatPosition{"Relax"};
    int m_massageLevel{2};
};
