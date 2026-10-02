/**
 * ==============================================================================
 * Project: Apex VISION IVI - Digital Cockpit & Infotainment System
 * File: VideoBackend.cpp
 * Author / Developer: Sk Rehan Ahamed
 * License: MIT
 * ==============================================================================
 */

#include "VideoBackend.h"
#include <QNetworkRequest>
#include <QUrl>
#include <QUrlQuery>
#include <QRegularExpression>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QTimer>
#include <QSet>
#include <QRandomGenerator>
#include <QDebug>

VideoBackend::VideoBackend(QObject *parent)
    : QObject(parent)
{
    m_networkManager = new QNetworkAccessManager(this);
    m_refreshSeed = QRandomGenerator::global()->bounded(1000);
    loadCategoryVideos(m_currentCategory);
}

VideoBackend::~VideoBackend()
{
    if (m_activeSearchReply) {
        QNetworkReply *reply = m_activeSearchReply.data();
        m_activeSearchReply = nullptr;
        reply->disconnect(this);
        reply->abort();
        reply->deleteLater();
    }
    if (m_activeCategoryReply) {
        QNetworkReply *reply = m_activeCategoryReply.data();
        m_activeCategoryReply = nullptr;
        reply->disconnect(this);
        reply->abort();
        reply->deleteLater();
    }
    if (m_activeLoadMoreReply) {
        QNetworkReply *reply = m_activeLoadMoreReply.data();
        m_activeLoadMoreReply = nullptr;
        reply->disconnect(this);
        reply->abort();
        reply->deleteLater();
    }
}

void VideoBackend::selectCategory(const QString &category)
{
    m_pageOffset = 0;
    m_currentCategory = category;
    emit currentCategoryChanged();
    if (m_currentCategory != "Search") {
        loadCategoryVideos(m_currentCategory);
    }
}

void VideoBackend::selectVideo(const QVariantMap &video)
{
    m_currentVideo = video;
    m_isPlayerOpen = true;
    emit currentVideoChanged();
    emit isPlayerOpenChanged();
    updateRelatedVideos();
}

void VideoBackend::closePlayer()
{
    if (m_isPlayerOpen) {
        m_isPlayerOpen = false;
        emit isPlayerOpenChanged();
    }
}

void VideoBackend::setSearchQuery(const QString &query)
{
    if (m_searchQuery != query) {
        m_searchQuery = query;
        emit searchQueryChanged();
    }
}

void VideoBackend::searchVideos(const QString &query)
{
    setSearchQuery(query);
    QString cleanQuery = query.trimmed();
    m_pageOffset = 0;

    if (cleanQuery.isEmpty()) {
        m_searchResults.clear();
        emit searchResultsChanged();
        return;
    }

    if (m_activeSearchReply) {
        QNetworkReply *reply = m_activeSearchReply.data();
        m_activeSearchReply = nullptr;
        reply->disconnect(this);
        reply->abort();
        reply->deleteLater();
    }

    m_isLoading = true;
    emit isLoadingChanged();

    QString searchUrl = QString("https://www.youtube.com/results?search_query=%1")
                            .arg(QString(QUrl::toPercentEncoding(cleanQuery)));

    QNetworkRequest request;
    request.setUrl(QUrl(searchUrl));
    request.setHeader(QNetworkRequest::UserAgentHeader, "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36");
    request.setRawHeader("Accept-Language", "en-US,en;q=0.9");
    request.setRawHeader("Cookie", "CONSENT=YES+cb.20210328-17-p0.en+FX+478; SOCS=CAISNQgDEitib3FfaWRlbnRpdHlmcm9udGVuZHVpc2VydmVyXzIwMjMwNjA2LjA3X3AwGgJlbiACGgYIgLCmpAY;");

    m_activeSearchReply = m_networkManager->get(request);
    connect(m_activeSearchReply, &QNetworkReply::finished, this, &VideoBackend::onSearchReplyFinished);
}

static void processVideoRenderer(const QJsonObject &v, QVariantList &results, QSet<QString> &seenIds)
{
    if (v.isEmpty()) return;
    QString videoId = v["videoId"].toString();
    if (videoId.isEmpty() || seenIds.contains(videoId)) return;

    QString title;
    QJsonArray runs = v["title"].toObject()["runs"].toArray();
    if (!runs.isEmpty()) {
        title = runs.first().toObject()["text"].toString();
    }
    if (title.isEmpty()) return;

    QString channel;
    QJsonArray bylineRuns = v["longBylineText"].toObject()["runs"].toArray();
    if (bylineRuns.isEmpty()) {
        bylineRuns = v["ownerText"].toObject()["runs"].toArray();
    }
    if (!bylineRuns.isEmpty()) {
        channel = bylineRuns.first().toObject()["text"].toString();
    }

    QString views = v["viewCountText"].toObject()["simpleText"].toString();
    if (views.isEmpty()) views = v["shortViewCountText"].toObject()["simpleText"].toString();
    QString duration = v["lengthText"].toObject()["simpleText"].toString();
    if (duration.isEmpty()) duration = "HD";

    QString thumbUrl = QString("https://i.ytimg.com/vi/%1/hqdefault.jpg").arg(videoId);

    QString channelAvatar;
    QJsonObject chanThumbRenderer = v["channelThumbnailSupportedRenderers"].toObject()["channelThumbnailWithLinkRenderer"].toObject();
    QJsonArray chanThumbnails = chanThumbRenderer["thumbnail"].toObject()["thumbnails"].toArray();
    if (!chanThumbnails.isEmpty()) {
        channelAvatar = chanThumbnails.first().toObject()["url"].toString();
        if (channelAvatar.startsWith("//")) {
            channelAvatar = "https:" + channelAvatar;
        }
    }

    QVariantMap item;
    item["videoId"] = videoId;
    item["title"] = title;
    item["channel"] = channel.isEmpty() ? "YouTube Creator" : channel;
    item["channelAvatar"] = channelAvatar;
    item["views"] = views.isEmpty() ? "1.2M views" : views;
    item["duration"] = duration;
    item["thumbnail"] = thumbUrl;
    item["channelInitial"] = channel.isEmpty() ? "YT" : channel.left(2).toUpper();
    item["channelColor"] = "#2563EB";
    item["subscribers"] = "Verified";
    item["verified"] = true;

    seenIds.insert(videoId);
    results.append(item);
}

QVariantList VideoBackend::parseYouTubeHtml(const QByteArray &html)
{
    QVariantList results;
    QSet<QString> seenIds;
    QString htmlStr = QString::fromUtf8(html);
    int startIdx = htmlStr.indexOf("var ytInitialData = ");
    if (startIdx == -1) {
        startIdx = htmlStr.indexOf("ytInitialData = ");
        if (startIdx != -1) startIdx += 16;
    } else {
        startIdx += 20; // length of "var ytInitialData = "
    }

    if (startIdx != -1) {
        int endIdx = htmlStr.indexOf(";</script>", startIdx);
        if (endIdx == -1) {
            endIdx = htmlStr.indexOf(";var ", startIdx);
        }
        if (endIdx != -1) {
            QString jsonStr = htmlStr.mid(startIdx, endIdx - startIdx).trimmed();
            QJsonDocument doc = QJsonDocument::fromJson(jsonStr.toUtf8());
            if (!doc.isNull() && doc.isObject()) {
                QJsonObject root = doc.object();
                QJsonArray contents = root["contents"].toObject()["twoColumnSearchResultsRenderer"].toObject()["primaryContents"].toObject()["sectionListRenderer"].toObject()["contents"].toArray();

                for (const QJsonValue &secVal : contents) {
                    QJsonArray items = secVal.toObject()["itemSectionRenderer"].toObject()["contents"].toArray();
                    for (const QJsonValue &itemVal : items) {
                        QJsonObject itemObj = itemVal.toObject();

                        // 1. Direct videoRenderer
                        if (itemObj.contains("videoRenderer")) {
                            processVideoRenderer(itemObj["videoRenderer"].toObject(), results, seenIds);
                        }

                        // 2. Shelves (Trending shelves, related shelves, popular shelves)
                        if (itemObj.contains("shelfRenderer")) {
                            QJsonObject shelfContent = itemObj["shelfRenderer"].toObject()["content"].toObject();
                            const QStringList subKeys = {"verticalListRenderer", "horizontalListRenderer", "expandedShelfContentsRenderer"};
                            for (const QString &sk : subKeys) {
                                if (shelfContent.contains(sk)) {
                                    QJsonArray subItems = shelfContent[sk].toObject()["items"].toArray();
                                    for (const QJsonValue &subVal : subItems) {
                                        QJsonObject subObj = subVal.toObject();
                                        if (subObj.contains("videoRenderer")) {
                                            processVideoRenderer(subObj["videoRenderer"].toObject(), results, seenIds);
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    return results;
}

void VideoBackend::onSearchReplyFinished()
{
    if (!m_activeSearchReply) return;

    m_isLoading = false;
    emit isLoadingChanged();

    if (m_activeSearchReply->error() == QNetworkReply::NoError) {
        QByteArray html = m_activeSearchReply->readAll();
        QVariantList results = parseYouTubeHtml(html);
        if (!results.isEmpty()) {
            m_searchResults = results;
            emit searchResultsChanged();
        }
    }

    if (m_activeSearchReply) {
        QNetworkReply *reply = m_activeSearchReply.data();
        m_activeSearchReply = nullptr;
        reply->deleteLater();
    }
}

void VideoBackend::onCategoryReplyFinished()
{
    if (!m_activeCategoryReply) return;

    m_isLoading = false;
    emit isLoadingChanged();

    if (m_activeCategoryReply->error() == QNetworkReply::NoError) {
        QByteArray html = m_activeCategoryReply->readAll();
        QVariantList liveList = parseYouTubeHtml(html);
        if (!liveList.isEmpty()) {
            m_videos = liveList;
            emit videosChanged();
            updateRelatedVideos();

            // Prefetch next batch so grid has 18+ videos and scrolling is immediately active
            if (m_videos.size() < 18) {
                QTimer::singleShot(300, this, &VideoBackend::loadMoreVideos);
            }
        }
    }

    if (m_activeCategoryReply) {
        QNetworkReply *reply = m_activeCategoryReply.data();
        m_activeCategoryReply = nullptr;
        reply->deleteLater();
    }
}

void VideoBackend::onLoadMoreReplyFinished()
{
    if (!m_activeLoadMoreReply) return;

    m_isLoadingMore = false;
    emit isLoadingMoreChanged();

    if (m_activeLoadMoreReply->error() == QNetworkReply::NoError) {
        QByteArray html = m_activeLoadMoreReply->readAll();
        QVariantList moreList = parseYouTubeHtml(html);

        if (!moreList.isEmpty()) {
            if (!m_searchQuery.trimmed().isEmpty()) {
                QSet<QString> existingIds;
                for (const QVariant &item : m_searchResults) {
                    existingIds.insert(item.toMap()["videoId"].toString());
                }
                bool added = false;
                for (const QVariant &item : moreList) {
                    QString vid = item.toMap()["videoId"].toString();
                    if (!existingIds.contains(vid)) {
                        m_searchResults.append(item);
                        existingIds.insert(vid);
                        added = true;
                    }
                }
                if (added) {
                    emit searchResultsChanged();
                }
            } else {
                QSet<QString> existingIds;
                for (const QVariant &item : m_videos) {
                    existingIds.insert(item.toMap()["videoId"].toString());
                }
                bool added = false;
                for (const QVariant &item : moreList) {
                    QString vid = item.toMap()["videoId"].toString();
                    if (!existingIds.contains(vid)) {
                        m_videos.append(item);
                        existingIds.insert(vid);
                        added = true;
                    }
                }
                if (added) {
                    emit videosChanged();
                    updateRelatedVideos();
                }
            }
        }
    }

    if (m_activeLoadMoreReply) {
        QNetworkReply *reply = m_activeLoadMoreReply.data();
        m_activeLoadMoreReply = nullptr;
        reply->deleteLater();
    }
}

QString VideoBackend::getCategoryQuery(const QString &cat, int offset)
{
    if (cat == "All") {
        // Diverse, random YouTube home feed topics
        static const QStringList allSeeds = {
            "trending popular videos",
            "top viral videos worldwide",
            "supercars 4k review",
            "fascinating science veritasium",
            "popular creators entertainment",
            "tech innovations 2026",
            "top billboard hits music",
            "interesting documentary highlights",
            "satisfying compilation 4k",
            "mrbeast challenges latest",
            "space cosmos exploration",
            "world news today highlights",
            "breakout viral videos",
            "nature wildlife 4k 60fps",
            "formula 1 racing moments",
            "top podcast conversation"
        };
        int idx = (m_refreshSeed + offset) % allSeeds.size();
        return allSeeds[idx];
    } else if (cat == "Trending") {
        // Real YouTube trending topics
        static const QStringList trendingSeeds = {
            "trending",
            "trending videos today",
            "top viral videos this week",
            "breakout trending videos",
            "popular trending entertainment",
            "trending music videos hits"
        };
        int idx = (m_refreshSeed + offset) % trendingSeeds.size();
        return trendingSeeds[idx];
    } else if (cat == "Music") {
        static const QStringList musicSeeds = {
            "official music video hits 2026",
            "top billboard songs playlist",
            "popular music videos trending",
            "live acoustic concerts hits"
        };
        int idx = (m_refreshSeed + offset) % musicSeeds.size();
        return musicSeeds[idx];
    } else if (cat == "Gaming") {
        static const QStringList gamingSeeds = {
            "gameplay 2026 4k",
            "new game release trailer",
            "trending gaming moments",
            "esports highlights 2026"
        };
        int idx = (m_refreshSeed + offset) % gamingSeeds.size();
        return gamingSeeds[idx];
    } else if (cat == "Movies") {
        static const QStringList movieSeeds = {
            "official movie trailer 2026",
            "new film trailer 4k",
            "upcoming movies teaser",
            "hollywood movie trailers 2026"
        };
        int idx = (m_refreshSeed + offset) % movieSeeds.size();
        return movieSeeds[idx];
    } else if (cat == "Podcasts") {
        static const QStringList podcastSeeds = {
            "full podcast episode 2026",
            "top interview podcast",
            "deep dive talk podcast",
            "lex fridman podcast latest"
        };
        int idx = (m_refreshSeed + offset) % podcastSeeds.size();
        return podcastSeeds[idx];
    } else if (cat == "Live") {
        static const QStringList liveSeeds = {
            "live stream 24/7",
            "live news stream",
            "lofi hip hop radio live stream",
            "live music stream"
        };
        int idx = (m_refreshSeed + offset) % liveSeeds.size();
        return liveSeeds[idx];
    }
    return "trending";
}

void VideoBackend::loadCategoryVideos(const QString &cat)
{
    m_pageOffset = 0;
    if (m_activeCategoryReply) {
        QNetworkReply *reply = m_activeCategoryReply.data();
        m_activeCategoryReply = nullptr;
        reply->disconnect(this);
        reply->abort();
        reply->deleteLater();
    }

    m_isLoading = true;
    emit isLoadingChanged();

    QString query = getCategoryQuery(cat, m_pageOffset);
    QString searchUrl = QString("https://www.youtube.com/results?search_query=%1%2")
                            .arg(QString(QUrl::toPercentEncoding(query)))
                            .arg(cat == "Live" ? "&sp=CAMSAkAB" : "");

    QNetworkRequest request;
    request.setUrl(QUrl(searchUrl));
    request.setHeader(QNetworkRequest::UserAgentHeader, "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36");
    request.setRawHeader("Accept-Language", "en-US,en;q=0.9");
    request.setRawHeader("Cookie", "CONSENT=YES+cb.20210328-17-p0.en+FX+478; SOCS=CAISNQgDEitib3FfaWRlbnRpdHlmcm9udGVuZHVpc2VydmVyXzIwMjMwNjA2LjA3X3AwGgJlbiACGgYIgLCmpAY;");

    m_activeCategoryReply = m_networkManager->get(request);
    connect(m_activeCategoryReply, &QNetworkReply::finished, this, &VideoBackend::onCategoryReplyFinished);
}

void VideoBackend::loadMoreVideos()
{
    if (m_isLoading || m_isLoadingMore) return;

    if (m_activeLoadMoreReply) {
        QNetworkReply *reply = m_activeLoadMoreReply.data();
        m_activeLoadMoreReply = nullptr;
        reply->disconnect(this);
        reply->abort();
        reply->deleteLater();
    }

    m_pageOffset++;
    m_isLoadingMore = true;
    emit isLoadingMoreChanged();

    QString query;
    QString urlStr;
    if (!m_searchQuery.trimmed().isEmpty()) {
        query = m_searchQuery.trimmed();
        urlStr = QString("https://www.youtube.com/results?search_query=%1")
                     .arg(QString(QUrl::toPercentEncoding(query)));
    } else {
        query = getCategoryQuery(m_currentCategory, m_pageOffset);
        urlStr = QString("https://www.youtube.com/results?search_query=%1%2")
                     .arg(QString(QUrl::toPercentEncoding(query)))
                     .arg(m_currentCategory == "Live" ? "&sp=CAMSAkAB" : "");
    }

    QNetworkRequest request;
    request.setUrl(QUrl(urlStr));
    request.setHeader(QNetworkRequest::UserAgentHeader, "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36");
    request.setRawHeader("Accept-Language", "en-US,en;q=0.9");
    request.setRawHeader("Cookie", "CONSENT=YES+cb.20210328-17-p0.en+FX+478; SOCS=CAISNQgDEitib3FfaWRlbnRpdHlmcm9udGVuZHVpc2VydmVyXzIwMjMwNjA2LjA3X3AwGgJlbiACGgYIgLCmpAY;");

    m_activeLoadMoreReply = m_networkManager->get(request);
    connect(m_activeLoadMoreReply, &QNetworkReply::finished, this, &VideoBackend::onLoadMoreReplyFinished);
}

void VideoBackend::refreshVideos()
{
    m_refreshSeed = QRandomGenerator::global()->bounded(1000);
    m_pageOffset = 0;
    loadCategoryVideos(m_currentCategory);
}

void VideoBackend::updateRelatedVideos()
{
    m_relatedVideos.clear();
    QString curId = m_currentVideo["videoId"].toString();
    const QVariantList &sourceList = (!m_searchResults.isEmpty() && !m_searchQuery.trimmed().isEmpty()) ? m_searchResults : m_videos;
    if (sourceList.isEmpty()) {
        emit relatedVideosChanged();
        return;
    }

    int curIdx = -1;
    for (int i = 0; i < sourceList.size(); ++i) {
        if (sourceList[i].toMap()["videoId"].toString() == curId) {
            curIdx = i;
            break;
        }
    }

    if (curIdx >= 0) {
        // Upcoming videos in sequence starting immediately after current video
        for (int i = curIdx + 1; i < sourceList.size(); ++i) {
            m_relatedVideos.append(sourceList[i]);
        }
        // Wrap around to beginning of playlist (excluding current)
        for (int i = 0; i < curIdx; ++i) {
            m_relatedVideos.append(sourceList[i]);
        }
    } else {
        // Fallback if current video is not in source list
        for (const QVariant &item : sourceList) {
            QVariantMap v = item.toMap();
            if (v["videoId"].toString() != curId) {
                m_relatedVideos.append(v);
            }
        }
    }
    emit relatedVideosChanged();
}

void VideoBackend::playNextRelated()
{
    if (!m_relatedVideos.isEmpty()) {
        selectVideo(m_relatedVideos.first().toMap());
    } else if (!m_videos.isEmpty()) {
        selectVideo(m_videos.first().toMap());
    }
}

void VideoBackend::playPrevRelated()
{
    if (!m_relatedVideos.isEmpty()) {
        selectVideo(m_relatedVideos.last().toMap());
    } else if (!m_videos.isEmpty()) {
        selectVideo(m_videos.last().toMap());
    }
}

