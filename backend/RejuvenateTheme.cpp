#include "RejuvenateTheme.h"
#include <QFile>
#include <QFileInfo>
#include <QJsonDocument>
#include <QJsonObject>
#include <QUrl>
#include <QDir>
#include <QCoreApplication>
#include <QDebug>

static QString resolveAssetPath(const QString &raw, const QString &baseDir)
{
    if (raw.isEmpty()) return QString();
    if (raw.startsWith("qrc:/") || raw.startsWith("file://")) return raw;

    QString clean = raw;
    while (clean.startsWith("/")) clean.remove(0, 1);

    QStringList candidates;
    // 1. Exact raw or direct relative
    candidates << raw;
    candidates << baseDir + "/" + raw;
    candidates << QFileInfo(baseDir).dir().path() + "/" + raw;
    candidates << QDir::currentPath() + "/" + raw;
    candidates << QCoreApplication::applicationDirPath() + "/" + raw;
    candidates << "/Users/reno/Projects/APEX_VISION_IVI/" + raw;

    // 2. Stripped prefix variations
    if (clean.startsWith("assets/rejuvenate/")) {
        QString sub = clean.mid(QString("assets/rejuvenate/").length());
        candidates << QFileInfo(baseDir).dir().path() + "/" + sub;
        candidates << baseDir + "/" + sub;
        candidates << QDir::currentPath() + "/" + clean;
        candidates << QDir::currentPath() + "/" + sub;
        candidates << QCoreApplication::applicationDirPath() + "/" + clean;
        candidates << QCoreApplication::applicationDirPath() + "/" + sub;
        candidates << "/Users/reno/Projects/APEX_VISION_IVI/assets/rejuvenate/" + sub;
    }

    for (const auto &cand : candidates) {
        if (QFile::exists(cand)) {
            QString absPath = QFileInfo(cand).absoluteFilePath();
            return QUrl::fromLocalFile(absPath).toString();
        }
    }

    qWarning() << "[RejuvenateTheme] Asset not found on disk:" << raw << "in baseDir:" << baseDir;
    return "qrc:/ApexVision/" + raw;
}

RejuvenateTheme::RejuvenateTheme(const QJsonObject &json, const QString &baseDir, QObject *parent)
    : QObject(parent)
{
    m_id = json["id"].toString();
    m_name = json["name"].toString();
    m_description = json["description"].toString();
    m_longDescription = json["longDescription"].toString();
    m_duration = json["duration"].toInt(600);
    m_soundName = json.contains("soundName") ? json["soundName"].toString() : "Nature Mix";

    // Resolve Image Paths
    m_thumbnail = resolveAssetPath(json["thumbnail"].toString(), baseDir);
    m_previewImage = resolveAssetPath(json["previewImage"].toString(), baseDir);

    // Resolve Video URL
    m_videoUrl = resolveAssetPath(json["video"].toString(), baseDir);

    // Resolve Audio URL
    m_audioUrl = resolveAssetPath(json["audio"].toString(), baseDir);

    // Parse Climate Profile
    if (json.contains("climate")) {
        QJsonObject clim = json["climate"].toObject();
        m_temperature = clim["temperature"].toDouble(22.0);
        m_fanMode = clim["fanMode"].toString("AUTO");
        m_ac = clim["ac"].toBool(true);
    }

    // Parse Ambient Profile
    if (json.contains("ambient")) {
        QJsonObject amb = json["ambient"].toObject();
        m_ambientName = amb["name"].toString("Ambient Light");
        m_ambientColor = amb["color"].toString("#24D9FF");
        m_ambientBrightness = amb["brightness"].toInt(70);
    }

    // Parse Seat Profile
    if (json.contains("seat")) {
        QJsonObject st = json["seat"].toObject();
        m_seatPosition = st["position"].toString("Relax");
        m_massageLevel = st["massageLevel"].toInt(2);
    }

    qInfo() << "[RejuvenateTheme] Loaded theme:" << m_name
            << "Thumb:" << m_thumbnail
            << "Video:" << m_videoUrl
            << "Audio:" << m_audioUrl;
}

RejuvenateTheme::RejuvenateTheme(const QString &id, const QString &name, const QString &description,
                                 const QUrl &videoUrl, const QUrl &audioUrl, const QUrl &previewUrl,
                                 int duration, double temp, const QString &fanMode, bool ac,
                                 const QString &ambientColor, int ambientBrightness,
                                 const QString &seatPos, int massageLevel, QObject *parent)
    : QObject(parent)
    , m_id(id)
    , m_name(name)
    , m_description(description)
    , m_videoUrl(videoUrl.toString())
    , m_audioUrl(audioUrl.toString())
    , m_previewImage(previewUrl.toString())
    , m_thumbnail(previewUrl.toString())
    , m_duration(duration)
    , m_temperature(temp)
    , m_fanMode(fanMode)
    , m_ac(ac)
    , m_ambientColor(ambientColor)
    , m_ambientBrightness(ambientBrightness)
    , m_seatPosition(seatPos)
    , m_massageLevel(massageLevel)
{
}

std::shared_ptr<RejuvenateTheme> RejuvenateTheme::loadFromFile(const QString &filePath)
{
    QFile file(filePath);
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        qWarning() << "[RejuvenateTheme] Failed to open:" << filePath;
        return nullptr;
    }

    QByteArray data = file.readAll();
    file.close();

    QJsonParseError error;
    QJsonDocument doc = QJsonDocument::fromJson(data, &error);
    if (error.error != QJsonParseError::NoError || !doc.isObject()) {
        qWarning() << "[RejuvenateTheme] JSON parse error in" << filePath << ":" << error.errorString();
        return nullptr;
    }

    QString baseDir = QFileInfo(filePath).dir().path();
    return std::make_shared<RejuvenateTheme>(doc.object(), baseDir);
}

QVariantMap RejuvenateTheme::toVariantMap() const
{
    QVariantMap map;
    map["id"] = m_id;
    map["name"] = m_name;
    map["description"] = m_description;
    map["longDescription"] = m_longDescription;
    map["thumbnail"] = m_thumbnail;
    map["thumbnailUrl"] = m_thumbnail;
    map["previewImage"] = m_previewImage;
    map["previewUrl"] = m_previewImage;
    map["videoUrl"] = m_videoUrl;
    map["audioUrl"] = m_audioUrl;
    map["duration"] = m_duration;
    map["soundName"] = m_soundName;
    map["audioName"] = m_soundName;

    QVariantMap clim;
    clim["temperature"] = m_temperature;
    clim["fanMode"] = m_fanMode;
    clim["ac"] = m_ac;
    map["climate"] = clim;

    QVariantMap amb;
    amb["name"] = m_ambientName;
    amb["colorName"] = m_ambientName;
    amb["color"] = m_ambientColor;
    amb["brightness"] = m_ambientBrightness;
    map["ambient"] = amb;

    QVariantMap st;
    st["position"] = m_seatPosition;
    st["massageLevel"] = m_massageLevel;
    map["seat"] = st;

    return map;
}
