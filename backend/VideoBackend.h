/**
 * ==============================================================================
 * Project: Apex VISION IVI - Digital Cockpit & Infotainment System
 * File: VideoBackend.h
 * Author / Developer: Sk Rehan Ahamed
 * License: MIT
 * ==============================================================================
 */

#pragma once

#include <QObject>
#include <QVariantList>
#include <QVariantMap>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QPointer>

class VideoBackend : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QVariantList videos READ videos NOTIFY videosChanged)
    Q_PROPERTY(bool isLoading READ isLoading NOTIFY isLoadingChanged)
    Q_PROPERTY(bool isLoadingMore READ isLoadingMore NOTIFY isLoadingMoreChanged)
    Q_PROPERTY(QString currentCategory READ currentCategory NOTIFY currentCategoryChanged)
    Q_PROPERTY(QVariantMap currentVideo READ currentVideo NOTIFY currentVideoChanged)
    Q_PROPERTY(bool isPlayerOpen READ isPlayerOpen NOTIFY isPlayerOpenChanged)
    Q_PROPERTY(QString searchQuery READ searchQuery WRITE setSearchQuery NOTIFY searchQueryChanged)
    Q_PROPERTY(QVariantList searchResults READ searchResults NOTIFY searchResultsChanged)
    Q_PROPERTY(QVariantList relatedVideos READ relatedVideos NOTIFY relatedVideosChanged)

public:
    explicit VideoBackend(QObject *parent = nullptr);
    ~VideoBackend() override;

    QVariantList videos() const { return m_videos; }
    bool isLoading() const { return m_isLoading; }
    bool isLoadingMore() const { return m_isLoadingMore; }
    QString currentCategory() const { return m_currentCategory; }
    QVariantMap currentVideo() const { return m_currentVideo; }
    bool isPlayerOpen() const { return m_isPlayerOpen; }
    QString searchQuery() const { return m_searchQuery; }
    QVariantList searchResults() const { return m_searchResults; }
    QVariantList relatedVideos() const { return m_relatedVideos; }

    Q_INVOKABLE void selectCategory(const QString &category);
    Q_INVOKABLE void selectVideo(const QVariantMap &video);
    Q_INVOKABLE void closePlayer();
    Q_INVOKABLE void searchVideos(const QString &query);
    Q_INVOKABLE void loadMoreVideos();
    Q_INVOKABLE void setSearchQuery(const QString &query);
    Q_INVOKABLE void refreshVideos();
    Q_INVOKABLE void playNextRelated();
    Q_INVOKABLE void playPrevRelated();

signals:
    void videosChanged();
    void isLoadingChanged();
    void isLoadingMoreChanged();
    void currentCategoryChanged();
    void currentVideoChanged();
    void isPlayerOpenChanged();
    void searchQueryChanged();
    void searchResultsChanged();
    void relatedVideosChanged();

private slots:
    void onSearchReplyFinished();
    void onCategoryReplyFinished();
    void onLoadMoreReplyFinished();

private:
    void loadCategoryVideos(const QString &cat);
    QString getCategoryQuery(const QString &cat, int offset);
    void updateRelatedVideos();
    QVariantList parseYouTubeHtml(const QByteArray &html);

    QVariantList m_videos;
    bool m_isLoading{false};
    bool m_isLoadingMore{false};
    QString m_currentCategory{"All"};
    QVariantMap m_currentVideo;
    bool m_isPlayerOpen{false};
    QString m_searchQuery;
    QVariantList m_searchResults;
    QVariantList m_relatedVideos;

    QNetworkAccessManager *m_networkManager{nullptr};
    QPointer<QNetworkReply> m_activeSearchReply;
    QPointer<QNetworkReply> m_activeCategoryReply;
    QPointer<QNetworkReply> m_activeLoadMoreReply;
    int m_refreshSeed{0};
    int m_pageOffset{0};
};
