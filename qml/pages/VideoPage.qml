/**
 * ==============================================================================
 * Project: Apex VISION IVI - Digital Cockpit & Infotainment System
 * File: VideoPage.qml
 * Author / Developer: Sk Rehan Ahamed
 * License: MIT
 * ==============================================================================
 */

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtWebEngine
import ApexVision

Item {
    id: videoPage

    signal backRequested()
    signal fullScreenRequested(bool toggleOn)
    property bool isFullScreen: false
    property bool searchActive: false
    property bool showTouchKeyboard: false
    property bool shiftActive: true
    property string activeVideoId: ""

    focus: isFullScreen
    Keys.onEscapePressed: {
        videoPage.exitFullScreen()
    }

    function enterFullScreen() {
        videoPage.isFullScreen = true
        videoPage.fullScreenRequested(true)
        ytWebEngine.runJavaScript(
            "try {" +
            "  var ifr = document.getElementById('ytIframe');" +
            "  if (ifr && ifr.contentWindow) {" +
            "    ifr.blur();" +
            "  }" +
            "} catch(e) {}"
        )
    }

    function exitFullScreen() {
        videoPage.isFullScreen = false
        videoPage.fullScreenRequested(false)
    }

    Timer {
        id: loadingOverlayTimeout
        interval: 1200
        repeat: false
        onTriggered: {
            loadingOverlay.visible = false
        }
    }

    // Automatic transition to next video when current video completes
    function playNextVideo() {
        if (!VideoBackend.isPlayerOpen) return
        console.log("[VideoPage] Advancing to next video automatically...")
        VideoBackend.playNextRelated()
    }

    Timer {
        id: videoEndDebounceTimer
        interval: 350
        repeat: false
        onTriggered: {
            videoPage.playNextVideo()
        }
    }

    // Proactive background monitor to detect when video finishes
    Timer {
        id: videoPlaybackMonitor
        interval: 1000
        running: VideoBackend.isPlayerOpen && videoPage.activeVideoId !== "" && !loadingOverlay.visible
        repeat: true
        onTriggered: {
            ytWebEngine.runJavaScript(
                "(function() {" +
                "  if (window.__ytVideoEnded) {" +
                "    window.__ytVideoEnded = false;" +
                "    return true;" +
                "  }" +
                "  try {" +
                "    var ifr = document.getElementById('ytIframe');" +
                "    if (ifr && ifr.contentDocument) {" +
                "      var v = ifr.contentDocument.querySelector('video');" +
                "      if (v && (v.ended || (v.duration > 0 && v.currentTime > 0 && (v.duration - v.currentTime <= 0.8)))) {" +
                "        return true;" +
                "      }" +
                "    }" +
                "  } catch(e) {}" +
                "  return false;" +
                "})();",
                function(isEnded) {
                    if (isEnded) {
                        videoEndDebounceTimer.restart()
                    }
                }
            )
        }
    }

    function playVideo(videoId) {
        if (!videoId || videoId.length === 0) return
        activeVideoId = videoId
        videoEndDebounceTimer.stop()
        loadingOverlay.visible = true
        loadingOverlayTimeout.restart()
        ytWebEngine.audioMuted = false
        MediaBackend.fadeOutAndPause(700)

        // Try direct iframe update first for seamless instant switching (like YouTube)
        var jsCmd = 
            "(function() {" +
            "  if (window.resetVideoEnded) window.resetVideoEnded();" +
            "  var ifr = document.getElementById('ytIframe');" +
            "  if (ifr) {" +
            "    ifr.src = 'https://www.youtube-nocookie.com/embed/' + " + JSON.stringify(videoId) + " + '?autoplay=1&controls=1&rel=0&modestbranding=1&playsinline=1&enablejsapi=1&fs=1';" +
            "    try {" +
            "      ifr.contentWindow.postMessage(JSON.stringify({" +
            "        event: 'command'," +
            "        func: 'loadVideoById'," +
            "        args: [" + JSON.stringify(videoId) + "]" +
            "      }), '*');" +
            "    } catch(e) {}" +
            "    return true;" +
            "  }" +
            "  return false;" +
            "})();"

        ytWebEngine.runJavaScript(jsCmd, function(updated) {
            if (!updated) {
                var html = '<!DOCTYPE html><html><head>'
                    + '<meta charset="utf-8">'
                    + '<meta name="viewport" content="width=device-width, initial-scale=1.0">'
                    + '<meta name="referrer" content="strict-origin-when-cross-origin">'
                    + '<title>YouTube</title>'
                    + '<style>'
                    + '* { margin: 0; padding: 0; box-sizing: border-box; }'
                    + 'html, body { width: 100%; height: 100%; background: #000000; overflow: hidden; }'
                    + 'iframe { width: 100%; height: 100%; border: 0; display: block; }'
                    + '</style>'
                    + '<script src="https://www.youtube.com/iframe_api"></script>'
                    + '</head><body>'
                    + '<iframe id="ytIframe" src="https://www.youtube-nocookie.com/embed/' + videoId + '?autoplay=1&controls=1&rel=0&modestbranding=1&playsinline=1&enablejsapi=1&fs=1"'
                    + ' frameborder="0"'
                    + ' referrerpolicy="strict-origin-when-cross-origin"'
                    + ' allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"'
                    + ' allowfullscreen>'
                    + '</iframe>'
                    + '<script>'
                    + 'window.__ytVideoEnded = false;'
                    + 'function triggerVideoEnded() {'
                    + '  if (window.__ytVideoEnded) return;'
                    + '  window.__ytVideoEnded = true;'
                    + '  document.title = "YT_VIDEO_ENDED_" + Date.now();'
                    + '}'
                    + 'window.resetVideoEnded = function() {'
                    + '  window.__ytVideoEnded = false;'
                    + '  document.title = "YouTube";'
                    + '};'
                    + 'var ytPlayer = null;'
                    + 'function onYouTubeIframeAPIReady() {'
                    + '  try {'
                    + '    ytPlayer = new YT.Player("ytIframe", {'
                    + '      events: {'
                    + '        "onStateChange": function(event) {'
                    + '          if (event && event.data === 0) {'
                    + '            triggerVideoEnded();'
                    + '          }'
                    + '        }'
                    + '      }'
                    + '    });'
                    + '  } catch(e) {}'
                    + '}'
                    + 'window.addEventListener("message", function(event) {'
                    + '  try {'
                    + '    var data = event.data;'
                    + '    if (typeof data === "string") { data = JSON.parse(data); }'
                    + '    if (!data) return;'
                    + '    var isEnded = false;'
                    + '    if (data.event === "onStateChange" && (data.info === 0 || data.data === 0)) {'
                    + '      isEnded = true;'
                    + '    } else if (data.event === "infoDelivery" && data.info && data.info.playerState === 0) {'
                    + '      isEnded = true;'
                    + '    }'
                    + '    if (isEnded) {'
                    + '      triggerVideoEnded();'
                    + '    }'
                    + '  } catch(err) {}'
                    + '});'
                    + 'setInterval(function() {'
                    + '  try {'
                    + '    var ifr = document.getElementById("ytIframe");'
                    + '    if (ifr && ifr.contentWindow) {'
                    + '      ifr.contentWindow.postMessage(JSON.stringify({ event: "command", func: "addEventListener", args: ["onStateChange"] }), "*");'
                    + '      ifr.contentWindow.postMessage(JSON.stringify({ event: "listening" }), "*");'
                    + '    }'
                    + '  } catch(e) {}'
                    + '}, 1500);'
                    + 'setInterval(function() {'
                    + '  try {'
                    + '    var ifr = document.getElementById("ytIframe");'
                    + '    if (ifr && ifr.contentDocument) {'
                    + '      var v = ifr.contentDocument.querySelector("video");'
                    + '      if (v && (v.ended || (v.duration > 0 && v.currentTime > 0 && (v.duration - v.currentTime <= 0.8)))) {'
                    + '        triggerVideoEnded();'
                    + '      }'
                    + '    }'
                    + '  } catch(e) {}'
                    + '}, 800);'
                    + '</script>'
                    + '</body></html>'
                ytWebEngine.loadHtml(html, "https://www.youtube-nocookie.com")
            }
        })
    }

    function stopVideo() {
        videoEndDebounceTimer.stop()
        if (isFullScreen) {
            exitFullScreen()
        }
        ytWebEngine.audioMuted = true
        ytWebEngine.stop()
        ytWebEngine.runJavaScript(
            "try {" +
            "  var ifr = document.querySelectorAll('iframe');" +
            "  for (var i = 0; i < ifr.length; i++) {" +
            "    try { ifr[i].contentWindow.postMessage('{\"event\":\"command\",\"func\":\"stopVideo\",\"args\":\"\"}', '*'); } catch(e){}" +
            "    ifr[i].src = 'about:blank';" +
            "    ifr[i].remove();" +
            "  }" +
            "  var v = document.querySelectorAll('video');" +
            "  for (var j = 0; j < v.length; j++) {" +
            "    v[j].pause();" +
            "    v[j].src = '';" +
            "  }" +
            "} catch(e) {}"
        )
        ytWebEngine.url = "about:blank"
        activeVideoId = ""
    }

    onVisibleChanged: {
        if (!visible) {
            stopVideo()
            VideoBackend.closePlayer()
        }
    }

    onOpacityChanged: {
        if (opacity < 0.99 && pageStack && pageStack.currentIndex !== 8) {
            stopVideo()
            VideoBackend.closePlayer()
        }
    }

    Component.onDestruction: {
        stopVideo()
        VideoBackend.closePlayer()
    }

    // ── Category data (7 clean categories, vector SVG icons prominent to IVI theme) ──
    readonly property var categories: [
        { id: "All",       name: "All",       icon: "qrc:/ApexVision/qml/assets/icons/yt_cat_all.svg" },
        { id: "Trending",  name: "Trending",  icon: "qrc:/ApexVision/qml/assets/icons/yt_cat_trending.svg" },
        { id: "Music",     name: "Music",     icon: "qrc:/ApexVision/qml/assets/icons/yt_cat_music.svg" },
        { id: "Gaming",    name: "Gaming",    icon: "qrc:/ApexVision/qml/assets/icons/yt_cat_gaming.svg" },
        { id: "Movies",    name: "Movies",    icon: "qrc:/ApexVision/qml/assets/icons/yt_cat_movies.svg" },
        { id: "Podcasts",  name: "Podcasts",  icon: "qrc:/ApexVision/qml/assets/icons/yt_cat_podcasts.svg" },
        { id: "Live",      name: "Live",      icon: "qrc:/ApexVision/qml/assets/icons/yt_cat_live.svg" }
    ]

    readonly property var searchChips: [
        "MrBeast",
        "Lofi Beats",
        "MKBHD",
        "Top Music 2025",
        "Car Reviews",
        "Gaming Highlights",
        "Podcasts",
        "Formula 1",
        "Science & Tech"
    ]

    // ── React to backend signals ─────────────────────────────────────────
    Connections {
        target: VideoBackend

        function onIsPlayerOpenChanged() {
            if (VideoBackend.isPlayerOpen) {
                if (VideoBackend.currentVideo && VideoBackend.currentVideo.videoId) {
                    if (videoPage.activeVideoId !== VideoBackend.currentVideo.videoId) {
                        videoPage.playVideo(VideoBackend.currentVideo.videoId)
                    }
                }
            } else {
                videoPage.stopVideo()
            }
        }

        function onCurrentVideoChanged() {
            if (VideoBackend.isPlayerOpen && VideoBackend.currentVideo && VideoBackend.currentVideo.videoId) {
                if (videoPage.activeVideoId !== VideoBackend.currentVideo.videoId) {
                    videoPage.playVideo(VideoBackend.currentVideo.videoId)
                }
            }
        }
    }

    // =====================================================================
    //  BACKGROUND (Pure Default IVI Cockpit Background - Zero darkening)
    // =====================================================================
    // The master default_background.png shines through from Main.qml with zero dimming


    // =====================================================================
    //  TOP HEADER BAR (VehiclePage Styling)
    // =====================================================================
    Item {
        id: topBar
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 64
        z: 30
        visible: !videoPage.isFullScreen

        // Subtle bottom border
        Rectangle {
            anchors.bottom: parent.bottom
            width: parent.width
            height: 1
            color: Qt.rgba(255, 255, 255, 0.08)
        }

        // ── Back Button (Signature IVI Circular "←" Button: Zero border on hover, radiant glow on press) ──
        Item {
            id: backBtn
            width: 44
            height: 44
            anchors.left: parent.left
            anchors.leftMargin: 24
            anchors.verticalCenter: parent.verticalCenter

            Text {
                anchors.centerIn: parent
                text: "←"
                color: backMouse.pressed ? "#00D2FF" : (backMouse.containsMouse ? "#FFFFFF" : "#E2E8F0")
                font.family: "Inter"
                font.pixelSize: 28
                font.weight: Font.DemiBold
                scale: backMouse.pressed ? 0.90 : 1.0
                Behavior on scale { NumberAnimation { duration: 80 } }
                Behavior on color { ColorAnimation { duration: 100 } }
            }

            MouseArea {
                id: backMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    if (videoPage.showTouchKeyboard) {
                        videoPage.showTouchKeyboard = false
                    } else if (videoPage.searchActive) {
                        videoPage.searchActive = false
                        searchInput.text = ""
                        VideoBackend.searchVideos("")
                    } else if (VideoBackend.isPlayerOpen) {
                        videoPage.stopVideo()
                        VideoBackend.closePlayer()
                    } else {
                        videoPage.stopVideo()
                        VideoBackend.closePlayer()
                        videoPage.backRequested()
                    }
                }
            }
        }

        // ── YouTube logo badge ───────────────────────────────────────────
        Row {
            anchors.left: backBtn.right
            anchors.leftMargin: 16
            anchors.verticalCenter: parent.verticalCenter
            spacing: 10

            Image {
                width: 32
                height: 22
                source: "qrc:/ApexVision/qml/assets/icons/app_video.svg"
                fillMode: Image.PreserveAspectFit
                smooth: true
                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                text: "YouTube"
                color: "#FFFFFF"
                font.family: "Inter"
                font.pixelSize: 19
                font.weight: Font.Bold
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        // ── Right Action Controls: Search Toggle Button + Category Tabs ──
        Row {
            anchors.right: parent.right
            anchors.rightMargin: 24
            anchors.verticalCenter: parent.verticalCenter
            spacing: 10
            visible: !VideoBackend.isPlayerOpen

            // Search Toggle Button: Search only comes when this is pressed
            Rectangle {
                id: searchToggleBtn
                width: videoPage.searchActive ? 104 : 40
                height: 36
                radius: 18
                clip: true

                gradient: Gradient {
                    GradientStop {
                        position: 0.0
                        color: videoPage.searchActive ?
                            Qt.rgba(255, 255, 255, 0.28) :
                            (_sToggleMa.containsMouse ? Qt.rgba(255, 255, 255, 0.20) : Qt.rgba(255, 255, 255, 0.10))
                    }
                    GradientStop {
                        position: 1.0
                        color: videoPage.searchActive ?
                            Qt.rgba(255, 255, 255, 0.18) :
                            (_sToggleMa.containsMouse ? Qt.rgba(255, 255, 255, 0.14) : Qt.rgba(255, 255, 255, 0.05))
                    }
                }

                border.color: videoPage.searchActive ? "#FFFFFF" : (_sToggleMa.containsMouse ? Qt.rgba(255, 255, 255, 0.50) : Qt.rgba(255, 255, 255, 0.22))
                border.width: videoPage.searchActive ? 1.5 : 1
                Behavior on width { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }

                scale: _sToggleMa.pressed ? 0.94 : (_sToggleMa.containsMouse ? 1.02 : 1.0)
                Behavior on scale { NumberAnimation { duration: 120 } }

                Row {
                    anchors.centerIn: parent
                    spacing: 6

                    Image {
                        source: "qrc:/ApexVision/qml/assets/icons/yt_cat_search.svg"
                        width: 16
                        height: 16
                        sourceSize: Qt.size(16, 16)
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Text {
                        text: "Search"
                        color: "#FFFFFF"
                        font.family: "Inter"
                        font.pixelSize: 13
                        font.weight: Font.DemiBold
                        visible: videoPage.searchActive
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                MouseArea {
                    id: _sToggleMa
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        videoPage.searchActive = !videoPage.searchActive
                        if (videoPage.searchActive) {
                            videoPage.showTouchKeyboard = true
                            searchInput.forceActiveFocus()
                        } else {
                            videoPage.showTouchKeyboard = false
                            searchInput.text = ""
                            VideoBackend.searchVideos("")
                        }
                    }
                }
            }

            // Category chip tabs
            Repeater {
                model: videoPage.categories

                Rectangle {
                    readonly property bool isSelected: !videoPage.searchActive && VideoBackend.currentCategory === modelData.id
                    width: _tabRow.implicitWidth + 24
                    height: 36
                    radius: 18
                    clip: true

                    // Frosted Glass Fill matching VehiclePage cards
                    gradient: Gradient {
                        GradientStop {
                            position: 0.0
                            color: _tabMa.pressed ?
                                Qt.rgba(215/255, 238/255, 255/255, 0.32) :
                                (_tabMa.containsMouse ? Qt.rgba(225/255, 242/255, 255/255, 0.24) :
                                (isSelected ? Qt.rgba(225/255, 242/255, 255/255, 0.22) : Qt.rgba(215/255, 238/255, 255/255, 0.12)))
                        }
                        GradientStop {
                            position: 1.0
                            color: _tabMa.pressed ?
                                Qt.rgba(195/255, 225/255, 255/255, 0.26) :
                                (_tabMa.containsMouse ? Qt.rgba(205/255, 232/255, 255/255, 0.18) :
                                (isSelected ? Qt.rgba(205/255, 232/255, 255/255, 0.16) : Qt.rgba(195/255, 225/255, 255/255, 0.06)))
                        }
                    }

                    // Border: Crisp white border when selected (no yellow border), luminous glass when unselected
                    border.color: isSelected ?
                        "#FFFFFF" :
                        (_tabMa.containsMouse ? Qt.rgba(255, 255, 255, 0.65) : Qt.rgba(225/255, 242/255, 255/255, 0.28))
                    border.width: isSelected ? 1.5 : 1
                    Behavior on border.color { ColorAnimation { duration: 180 } }

                    scale: _tabMa.pressed ? 0.94 : (_tabMa.containsMouse ? 1.02 : 1.0)
                    Behavior on scale { NumberAnimation { duration: 120 } }

                    Row {
                        id: _tabRow
                        anchors.centerIn: parent
                        spacing: 7

                        Image {
                            source: modelData.icon
                            width: 15
                            height: 15
                            sourceSize: Qt.size(15, 15)
                            anchors.verticalCenter: parent.verticalCenter
                            opacity: isSelected ? 1.0 : (_tabMa.containsMouse ? 1.0 : 0.85)
                        }

                        Text {
                            text: modelData.name
                            color: isSelected ? "#FFFFFF" : "#CBD5E1"
                            font.family: "Inter"
                            font.pixelSize: 13
                            font.weight: isSelected ? Font.Bold : Font.DemiBold
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    MouseArea {
                        id: _tabMa
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            videoPage.searchActive = false
                            videoPage.showTouchKeyboard = false
                            searchInput.text = ""
                            VideoBackend.selectCategory(modelData.id)
                            if (modelData.id === "All") {
                                VideoBackend.refreshVideos()
                            }
                        }
                    }
                }
            }
        }
    }

    // =====================================================================
    //  VIEW 1 – VIDEO BROWSER  (player closed)
    // =====================================================================
    Item {
        id: browserView
        anchors.top: topBar.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        visible: !VideoBackend.isPlayerOpen

        // ── Single Long Search Bar Container (Only comes when search is pressed) ──
        Item {
            id: searchContainer
            anchors.top: parent.top
            anchors.topMargin: videoPage.searchActive ? 10 : 0
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: 24
            anchors.rightMargin: 24
            height: videoPage.searchActive ? _searchColLayout.height : 0
            opacity: videoPage.searchActive ? 1.0 : 0.0
            visible: opacity > 0.001
            clip: true

            Behavior on height {
                NumberAnimation { duration: 220; easing.type: Easing.OutCubic }
            }
            Behavior on opacity {
                NumberAnimation { duration: 180 }
            }
            Behavior on anchors.topMargin {
                NumberAnimation { duration: 200 }
            }

            Column {
                id: _searchColLayout
                width: parent.width
                spacing: 8

                // Unified Long Search Bar (Spanning Full Available Width)
                Rectangle {
                    id: searchBarBox
                    width: parent.width
                    height: 48
                    radius: 24
                    clip: true

                    // VehiclePage frosted glass fill
                    gradient: Gradient {
                        GradientStop {
                            position: 0.0
                            color: (searchInput.activeFocus || videoPage.showTouchKeyboard) ?
                                Qt.rgba(215/255, 238/255, 255/255, 0.28) : Qt.rgba(215/255, 238/255, 255/255, 0.16)
                        }
                        GradientStop {
                            position: 1.0
                            color: (searchInput.activeFocus || videoPage.showTouchKeyboard) ?
                                Qt.rgba(195/255, 225/255, 255/255, 0.20) : Qt.rgba(195/255, 225/255, 255/255, 0.08)
                        }
                    }

                    // Border: Clean white border when focused/active (no yellow)
                    border.color: (searchInput.activeFocus || videoPage.showTouchKeyboard) ?
                        "#FFFFFF" : Qt.rgba(225/255, 242/255, 255/255, 0.28)
                    border.width: (searchInput.activeFocus || videoPage.showTouchKeyboard) ? 1.5 : 1
                    Behavior on border.color { ColorAnimation { duration: 180 } }

                    // Top specular highlight
                    Rectangle {
                        anchors.top: parent.top
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.topMargin: 1
                        anchors.leftMargin: 16
                        anchors.rightMargin: 16
                        height: 1
                        color: Qt.rgba(255, 255, 255, 0.35)
                        radius: 1
                    }

                    Row {
                        anchors.left: parent.left
                        anchors.leftMargin: 18
                        anchors.right: searchControlsRow.left
                        anchors.rightMargin: 12
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 12

                        Image {
                            source: "qrc:/ApexVision/qml/assets/icons/yt_cat_search.svg"
                            width: 20
                            height: 20
                            sourceSize: Qt.size(20, 20)
                            anchors.verticalCenter: parent.verticalCenter
                            opacity: 0.95
                        }

                        TextInput {
                            id: searchInput
                            width: parent.width - 32
                            anchors.verticalCenter: parent.verticalCenter
                            color: "#FFFFFF"
                            font.family: "Inter"
                            font.pixelSize: 15
                            font.weight: Font.Medium
                            clip: true
                            selectByMouse: true
                            selectionColor: Qt.rgba(56/255, 189/255, 248/255, 0.4)
                            selectedTextColor: "#FFFFFF"

                            Text {
                                text: "Search YouTube videos, topics, creators..."
                                color: "#94A3B8"
                                font.family: "Inter"
                                font.pixelSize: 15
                                visible: !searchInput.text && !searchInput.inputMethodComposing
                                anchors.verticalCenter: parent.verticalCenter
                            }

                            onAccepted: {
                                videoPage.showTouchKeyboard = false
                                VideoBackend.searchVideos(searchInput.text)
                            }

                            onActiveFocusChanged: {
                                if (activeFocus) {
                                    videoPage.showTouchKeyboard = true
                                }
                            }
                        }
                    }

                    // Search action buttons on right side of search bar
                    Row {
                        id: searchControlsRow
                        anchors.right: parent.right
                        anchors.rightMargin: 14
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 8

                        // Clear input button (Vector SVG icon)
                        Rectangle {
                            width: 32
                            height: 32
                            radius: 16
                            color: _clearMa.pressed ? Qt.rgba(255, 255, 255, 0.22) :
                                   (_clearMa.containsMouse ? Qt.rgba(255, 255, 255, 0.14) : Qt.rgba(255, 255, 255, 0.08))
                            border.color: Qt.rgba(255, 255, 255, 0.18)
                            border.width: 1
                            visible: searchInput.text.length > 0
                            anchors.verticalCenter: parent.verticalCenter

                            Image {
                                anchors.centerIn: parent
                                source: "qrc:/ApexVision/qml/assets/icons/yt_close.svg"
                                width: 12
                                height: 12
                                sourceSize: Qt.size(12, 12)
                            }

                            MouseArea {
                                id: _clearMa
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    searchInput.text = ""
                                    VideoBackend.searchVideos("")
                                }
                            }
                        }

                        // Touch Keyboard Toggle Button (Vector SVG Keyboard Icon)
                        Rectangle {
                            width: 38
                            height: 32
                            radius: 16
                            color: videoPage.showTouchKeyboard ? Qt.rgba(255, 255, 255, 0.28) :
                                   (_keyToggleMa.pressed ? Qt.rgba(255, 255, 255, 0.20) :
                                   (_keyToggleMa.containsMouse ? Qt.rgba(255, 255, 255, 0.14) : Qt.rgba(255, 255, 255, 0.08)))
                            border.color: videoPage.showTouchKeyboard ? "#FFFFFF" : Qt.rgba(255, 255, 255, 0.18)
                            border.width: 1
                            anchors.verticalCenter: parent.verticalCenter

                            Image {
                                anchors.centerIn: parent
                                source: "qrc:/ApexVision/qml/assets/icons/yt_keyboard.svg"
                                width: 18
                                height: 18
                                sourceSize: Qt.size(18, 18)
                            }

                            MouseArea {
                                id: _keyToggleMa
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    videoPage.showTouchKeyboard = !videoPage.showTouchKeyboard
                                    if (videoPage.showTouchKeyboard) {
                                        searchInput.forceActiveFocus()
                                    }
                                }
                            }
                        }

                        // Close Search Bar Button
                        Rectangle {
                            width: 32
                            height: 32
                            radius: 16
                            color: _closeSearchMa.pressed ? Qt.rgba(255, 255, 255, 0.22) :
                                   (_closeSearchMa.containsMouse ? Qt.rgba(255, 255, 255, 0.14) : Qt.rgba(255, 255, 255, 0.08))
                            border.color: Qt.rgba(255, 255, 255, 0.18)
                            border.width: 1
                            anchors.verticalCenter: parent.verticalCenter

                            Image {
                                anchors.centerIn: parent
                                source: "qrc:/ApexVision/qml/assets/icons/yt_close.svg"
                                width: 12
                                height: 12
                                sourceSize: Qt.size(12, 12)
                            }

                            MouseArea {
                                id: _closeSearchMa
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    videoPage.searchActive = false
                                    videoPage.showTouchKeyboard = false
                                    searchInput.text = ""
                                    VideoBackend.searchVideos("")
                                }
                            }
                        }
                    }
                }
            }
        }

        // ── Pull-to-Refresh Indicator ────────────────────────────────────
        Item {
            id: refreshIndicator
            anchors.top: videoPage.searchActive ? searchContainer.bottom : parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            height: Math.max(0, -videoFlickable.contentY)
            visible: height > 8 || VideoBackend.isLoading
            clip: true
            z: 20

            Row {
                anchors.centerIn: parent
                spacing: 10
                opacity: Math.min(1.0, Math.max(0.2, (-videoFlickable.contentY) / 50.0))

                Rectangle {
                    width: 24
                    height: 24
                    radius: 12
                    color: "transparent"
                    border.color: "#FFFFFF"
                    border.width: 2
                    anchors.verticalCenter: parent.verticalCenter

                    Rectangle {
                        width: 5
                        height: 5
                        radius: 2.5
                        color: "#FFFFFF"
                        anchors.top: parent.top
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.topMargin: -1
                    }

                    RotationAnimation on rotation {
                        from: 0
                        to: 360
                        duration: 800
                        loops: Animation.Infinite
                        running: VideoBackend.isLoading || videoFlickable.contentY < -40
                    }
                }

                Text {
                    text: VideoBackend.isLoading ? "Refreshing YouTube..." : (videoFlickable.contentY < -60 ? "Release to refresh" : "Pull down to refresh")
                    color: "#CBD5E1"
                    font.family: "Inter"
                    font.pixelSize: 13
                    font.weight: Font.Medium
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }

        // ── Video grid ───────────────────────────────────────────────────
        Flickable {
            id: videoFlickable
            anchors.top: videoPage.searchActive ? searchContainer.bottom : parent.top
            anchors.topMargin: videoPage.searchActive ? 10 : 12
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.leftMargin: 24
            anchors.rightMargin: 24
            anchors.bottomMargin: videoPage.showTouchKeyboard ? 285 : 16
            Behavior on anchors.bottomMargin { NumberAnimation { duration: 240; easing.type: Easing.OutCubic } }
            Behavior on anchors.topMargin { NumberAnimation { duration: 200 } }
            clip: true
            contentWidth: width
            contentHeight: videoContentCol.height + 30
            boundsBehavior: Flickable.DragAndOvershootBounds
            onContentYChanged: {
                if ((contentY + height >= contentHeight - 250) || (contentHeight <= height && contentY > 15)) {
                    if (!VideoBackend.isLoading && !VideoBackend.isLoadingMore) {
                        VideoBackend.loadMoreVideos()
                    }
                }
            }
            onMovementEnded: {
                if (contentY < -55 && !VideoBackend.isLoading) {
                    VideoBackend.refreshVideos()
                } else if ((contentY + height >= contentHeight - 250) || (contentHeight <= height && contentY > 10) || atYEnd) {
                    if (!VideoBackend.isLoading && !VideoBackend.isLoadingMore) {
                        VideoBackend.loadMoreVideos()
                    }
                }
            }
            onFlickEnded: {
                if ((contentY + height >= contentHeight - 250) || (contentHeight <= height && contentY > 10) || atYEnd) {
                    if (!VideoBackend.isLoading && !VideoBackend.isLoadingMore) {
                        VideoBackend.loadMoreVideos()
                    }
                }
            }

            ScrollBar.vertical: ScrollBar {
                policy: ScrollBar.AsNeeded
            }

            Column {
                id: videoContentCol
                width: videoFlickable.width
                spacing: 24

                Grid {
                    id: videoGrid
                    width: parent.width
                    columns: 3
                    spacing: 24

                Repeater {
                    model: (videoPage.searchActive && VideoBackend.searchQuery.length > 0) ? VideoBackend.searchResults : VideoBackend.videos

                    // Clean Borderless YouTube Video Card with Generous Spacing
                    Rectangle {
                        id: videoCard
                        width: (videoGrid.width - 48) / 3
                        height: _cardCol.height + 12
                        radius: 14
                        clip: true
                        color: _cardMa.containsMouse ? Qt.rgba(255, 255, 255, 0.04) : "transparent"
                        border.width: 0
                        border.color: "transparent"

                        scale: _cardMa.pressed ? 0.98 : (_cardMa.containsMouse ? 1.015 : 1.0)
                        Behavior on scale { NumberAnimation { duration: 140; easing.type: Easing.OutCubic } }

                        Column {
                            id: _cardCol
                            anchors.top: parent.top
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.margins: 4
                            spacing: 10

                            // 16:9 Thumbnail Container
                            Rectangle {
                                width: parent.width
                                height: width * 9 / 16
                                radius: 12
                                clip: true
                                color: "#111827"
                                border.width: 0

                                Image {
                                    anchors.fill: parent
                                    source: modelData.thumbnail || ""
                                    fillMode: Image.PreserveAspectCrop
                                    smooth: true
                                    asynchronous: true
                                }

                                // Dark gradient vignette at bottom of thumbnail
                                Rectangle {
                                    anchors.left: parent.left
                                    anchors.right: parent.right
                                    anchors.bottom: parent.bottom
                                    height: 36
                                    gradient: Gradient {
                                        GradientStop { position: 0.0; color: "transparent" }
                                        GradientStop { position: 1.0; color: Qt.rgba(0, 0, 0, 0.75) }
                                    }
                                }

                                // Duration pill
                                Rectangle {
                                    anchors.right: parent.right
                                    anchors.bottom: parent.bottom
                                    anchors.margins: 6
                                    height: 20
                                    width: _durTxt.implicitWidth + 10
                                    radius: 4
                                    color: Qt.rgba(0, 0, 0, 0.82)
                                    visible: (modelData.duration || "").length > 0

                                    Text {
                                        id: _durTxt
                                        anchors.centerIn: parent
                                        text: modelData.duration || ""
                                        color: "#FFFFFF"
                                        font.family: "Inter"
                                        font.pixelSize: 11
                                        font.weight: Font.Medium
                                    }
                                }

                                // Play button overlay on hover (Vector SVG play icon)
                                Rectangle {
                                    anchors.centerIn: parent
                                    width: 44
                                    height: 44
                                    radius: 22
                                    color: Qt.rgba(0, 0, 0, 0.70)
                                    border.color: "#FFFFFF"
                                    border.width: 1.5
                                    visible: _cardMa.containsMouse
                                    scale: _cardMa.containsMouse ? 1.0 : 0.8
                                    Behavior on scale { NumberAnimation { duration: 150 } }

                                    Image {
                                        anchors.centerIn: parent
                                        anchors.horizontalCenterOffset: 1
                                        source: "qrc:/ApexVision/qml/assets/icons/yt_play.svg"
                                        width: 18
                                        height: 18
                                        sourceSize: Qt.size(18, 18)
                                    }
                                }
                            }

                            // Metadata row
                            Row {
                                width: parent.width
                                spacing: 10

                                // Channel Logo / Avatar (Shows actual YouTube channel logo)
                                Rectangle {
                                    width: 36
                                    height: 36
                                    radius: 18
                                    clip: true
                                    color: modelData.channelColor || "#4F46E5"
                                    anchors.top: parent.top
                                    anchors.topMargin: 2

                                    // Fallback Initial
                                    Text {
                                        anchors.centerIn: parent
                                        text: modelData.channelInitial || (modelData.channel ? modelData.channel.substring(0, 2).toUpperCase() : "YT")
                                        color: "#FFFFFF"
                                        font.family: "Inter"
                                        font.pixelSize: 12
                                        font.weight: Font.Bold
                                        visible: !chanAvatarImg.visible || chanAvatarImg.status !== Image.Ready
                                    }

                                    // Actual Channel Avatar Image
                                    Image {
                                        id: chanAvatarImg
                                        anchors.fill: parent
                                        source: modelData.channelAvatar || ""
                                        fillMode: Image.PreserveAspectCrop
                                        smooth: true
                                        asynchronous: true
                                        visible: (modelData.channelAvatar || "").length > 0 && status === Image.Ready
                                    }
                                }

                                Column {
                                    width: parent.width - 46
                                    spacing: 3

                                    Text {
                                        width: parent.width
                                        text: modelData.title || ""
                                        color: "#FFFFFF"
                                        font.family: "Inter"
                                        font.pixelSize: 14
                                        font.weight: Font.DemiBold
                                        elide: Text.ElideRight
                                        maximumLineCount: 2
                                        wrapMode: Text.WordWrap
                                    }

                                    Row {
                                        spacing: 5
                                        Text {
                                            text: modelData.channel || ""
                                            color: "#94A3B8"
                                            font.family: "Inter"
                                            font.pixelSize: 12
                                            font.weight: Font.Medium
                                            elide: Text.ElideRight
                                        }
                                        Text {
                                            text: "•"
                                            color: "#64748B"
                                            font.pixelSize: 11
                                            anchors.verticalCenter: parent.verticalCenter
                                            visible: (modelData.views || "").length > 0
                                        }
                                        Text {
                                            text: modelData.views || ""
                                            color: "#94A3B8"
                                            font.family: "Inter"
                                            font.pixelSize: 11
                                        }
                                    }
                                }
                            }
                        }

                        MouseArea {
                            id: _cardMa
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                videoPage.showTouchKeyboard = false
                                MediaBackend.fadeOutAndPause(700)
                                VideoBackend.selectVideo(modelData)
                            }
                        }
                    }
                }
            }

            // ── Loading More Indicator (Infinite Scroll) ────────────────
                Item {
                    id: loadMoreIndicator
                    width: parent.width
                    height: 44
                    visible: VideoBackend.isLoadingMore

                    Rectangle {
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 240
                        height: 44
                        radius: 22
                        color: Qt.rgba(215/255, 238/255, 255/255, 0.12)
                        border.color: Qt.rgba(255, 255, 255, 0.25)
                        border.width: 1

                        Row {
                            anchors.centerIn: parent
                            spacing: 10

                            Rectangle {
                                width: 18
                                height: 18
                                radius: 9
                                color: "transparent"
                                border.color: "#FFFFFF"
                                border.width: 2
                                anchors.verticalCenter: parent.verticalCenter

                                Rectangle {
                                    width: 4
                                    height: 4
                                    radius: 2
                                    color: "#FFFFFF"
                                    anchors.top: parent.top
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    anchors.topMargin: -1
                                }

                                RotationAnimation on rotation {
                                    from: 0
                                    to: 360
                                    duration: 700
                                    loops: Animation.Infinite
                                    running: VideoBackend.isLoadingMore
                                }
                            }

                            Text {
                                text: "Loading more videos..."
                                color: "#FFFFFF"
                                font.family: "Inter"
                                font.pixelSize: 13
                                font.weight: Font.Medium
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }
                    }
                }
            }
        }

        // =====================================================================
        //  GOOGLE ANDROID (GBOARD) TOUCH KEYBOARD DOCKED AT BOTTOM
        // =====================================================================
        Rectangle {
            id: googleKeyboardContainer
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            height: 275
            z: 50

            // Smooth slide-up transition from bottom
            y: videoPage.showTouchKeyboard ? (parent.height - height) : parent.height
            visible: opacity > 0.01
            opacity: videoPage.showTouchKeyboard ? 1.0 : 0.0

            Behavior on y {
                NumberAnimation { duration: 240; easing.type: Easing.OutCubic }
            }
            Behavior on opacity {
                NumberAnimation { duration: 200 }
            }

            // Gboard Dark Cockpit Glass Background
            gradient: Gradient {
                GradientStop { position: 0.0; color: Qt.rgba(17/255, 24/255, 39/255, 0.98) }
                GradientStop { position: 1.0; color: Qt.rgba(7/255, 10/255, 15/255, 0.99) }
            }

            // Top highlight border
            Rectangle {
                anchors.top: parent.top
                width: parent.width
                height: 1
                color: Qt.rgba(255, 255, 255, 0.22)
            }

            Column {
                anchors.fill: parent
                anchors.margins: 6
                spacing: 5

                // Top topic suggestions strip with dismiss chevron
                Row {
                    width: parent.width
                    height: 34
                    spacing: 8

                    Flickable {
                        width: parent.width - 48
                        height: parent.height
                        contentWidth: suggestRow.width
                        clip: true
                        boundsBehavior: Flickable.StopAtBounds

                        Row {
                            id: suggestRow
                            spacing: 8
                            Repeater {
                                model: videoPage.searchChips
                                Rectangle {
                                    height: 30
                                    width: _sugTxt.implicitWidth + 22
                                    radius: 15
                                    color: _sugMa.pressed ? Qt.rgba(255, 255, 255, 0.24) :
                                           (_sugMa.containsMouse ? Qt.rgba(255, 255, 255, 0.16) : Qt.rgba(255, 255, 255, 0.08))
                                    border.color: Qt.rgba(255, 255, 255, 0.18)
                                    border.width: 1

                                    Text {
                                        id: _sugTxt
                                        anchors.centerIn: parent
                                        text: modelData
                                        color: "#FFFFFF"
                                        font.family: "Inter"
                                        font.pixelSize: 12
                                        font.weight: Font.Medium
                                    }

                                    MouseArea {
                                        id: _sugMa
                                        anchors.fill: parent
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: {
                                            searchInput.text = modelData
                                            videoPage.showTouchKeyboard = false
                                            VideoBackend.searchVideos(modelData)
                                        }
                                    }
                                }
                            }
                        }
                    }

                    // Hide keyboard dismiss button (Vector SVG down chevron)
                    Rectangle {
                        width: 38
                        height: 30
                        radius: 8
                        color: _hideKeyMa.pressed ? Qt.rgba(255, 255, 255, 0.22) :
                               (_hideKeyMa.containsMouse ? Qt.rgba(255, 255, 255, 0.14) : Qt.rgba(255, 255, 255, 0.08))
                        border.color: Qt.rgba(255, 255, 255, 0.18)
                        border.width: 1

                        Image {
                            anchors.centerIn: parent
                            source: "qrc:/ApexVision/qml/assets/icons/yt_chevron_down.svg"
                            width: 14
                            height: 14
                            sourceSize: Qt.size(14, 14)
                        }

                        MouseArea {
                            id: _hideKeyMa
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: videoPage.showTouchKeyboard = false
                        }
                    }
                }

                // Row 0: Numbers 1 2 3 4 5 6 7 8 9 0
                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 6
                    Repeater {
                        model: ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]
                        Rectangle {
                            width: (googleKeyboardContainer.width - 24 - 9 * 6) / 10
                            height: 38
                            radius: 8
                            color: _numMa.pressed ? Qt.rgba(255, 255, 255, 0.24) :
                                   (_numMa.containsMouse ? Qt.rgba(255, 255, 255, 0.15) : Qt.rgba(255, 255, 255, 0.09))
                            border.color: Qt.rgba(255, 255, 255, 0.16)
                            border.width: 1

                            Text {
                                anchors.centerIn: parent
                                text: modelData
                                color: "#FFFFFF"
                                font.family: "Inter"
                                font.pixelSize: 17
                                font.weight: Font.DemiBold
                            }

                            MouseArea {
                                id: _numMa
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: searchInput.text += modelData
                            }
                        }
                    }
                }

                // Row 1: Q W E R T Y U I O P
                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 6
                    Repeater {
                        model: ["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"]
                        Rectangle {
                            width: (googleKeyboardContainer.width - 24 - 9 * 6) / 10
                            height: 42
                            radius: 8
                            color: _qMa.pressed ? Qt.rgba(255, 255, 255, 0.24) :
                                   (_qMa.containsMouse ? Qt.rgba(255, 255, 255, 0.15) : Qt.rgba(255, 255, 255, 0.09))
                            border.color: Qt.rgba(255, 255, 255, 0.16)
                            border.width: 1

                            Text {
                                anchors.centerIn: parent
                                text: videoPage.shiftActive ? modelData : modelData.toLowerCase()
                                color: "#FFFFFF"
                                font.family: "Inter"
                                font.pixelSize: 17
                                font.weight: Font.DemiBold
                            }

                            MouseArea {
                                id: _qMa
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: searchInput.text += (videoPage.shiftActive ? modelData : modelData.toLowerCase())
                            }
                        }
                    }
                }

                // Row 2: A S D F G H J K L
                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 6
                    Repeater {
                        model: ["A", "S", "D", "F", "G", "H", "J", "K", "L"]
                        Rectangle {
                            width: (googleKeyboardContainer.width - 24 - 9 * 6) / 10
                            height: 42
                            radius: 8
                            color: _aMa.pressed ? Qt.rgba(255, 255, 255, 0.24) :
                                   (_aMa.containsMouse ? Qt.rgba(255, 255, 255, 0.15) : Qt.rgba(255, 255, 255, 0.09))
                            border.color: Qt.rgba(255, 255, 255, 0.16)
                            border.width: 1

                            Text {
                                anchors.centerIn: parent
                                text: videoPage.shiftActive ? modelData : modelData.toLowerCase()
                                color: "#FFFFFF"
                                font.family: "Inter"
                                font.pixelSize: 17
                                font.weight: Font.DemiBold
                            }

                            MouseArea {
                                id: _aMa
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: searchInput.text += (videoPage.shiftActive ? modelData : modelData.toLowerCase())
                            }
                        }
                    }
                }

                // Row 3: Shift + Z X C V B N M + Backspace
                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 6

                    // Shift key (Vector SVG icon, clean white active style)
                    Rectangle {
                        width: ((googleKeyboardContainer.width - 24 - 9 * 6) / 10) * 1.35
                        height: 42
                        radius: 8
                        color: videoPage.shiftActive ? Qt.rgba(255, 255, 255, 0.32) :
                               (_shMa.pressed ? Qt.rgba(255, 255, 255, 0.24) : Qt.rgba(255, 255, 255, 0.12))
                        border.color: videoPage.shiftActive ? "#FFFFFF" : Qt.rgba(255, 255, 255, 0.18)
                        border.width: 1

                        Image {
                            anchors.centerIn: parent
                            source: "qrc:/ApexVision/qml/assets/icons/yt_shift.svg"
                            width: 16
                            height: 16
                            sourceSize: Qt.size(16, 16)
                        }

                        MouseArea {
                            id: _shMa
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: videoPage.shiftActive = !videoPage.shiftActive
                        }
                    }

                    Repeater {
                        model: ["Z", "X", "C", "V", "B", "N", "M"]
                        Rectangle {
                            width: (googleKeyboardContainer.width - 24 - 9 * 6) / 10
                            height: 42
                            radius: 8
                            color: _zMa.pressed ? Qt.rgba(255, 255, 255, 0.24) :
                                   (_zMa.containsMouse ? Qt.rgba(255, 255, 255, 0.15) : Qt.rgba(255, 255, 255, 0.09))
                            border.color: Qt.rgba(255, 255, 255, 0.16)
                            border.width: 1

                            Text {
                                anchors.centerIn: parent
                                text: videoPage.shiftActive ? modelData : modelData.toLowerCase()
                                color: "#FFFFFF"
                                font.family: "Inter"
                                font.pixelSize: 17
                                font.weight: Font.DemiBold
                            }

                            MouseArea {
                                id: _zMa
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: searchInput.text += (videoPage.shiftActive ? modelData : modelData.toLowerCase())
                            }
                        }
                    }

                    // Backspace key (Vector SVG icon)
                    Rectangle {
                        width: ((googleKeyboardContainer.width - 24 - 9 * 6) / 10) * 1.55
                        height: 42
                        radius: 8
                        color: _bsMa.pressed ? Qt.rgba(239/255, 68/255, 68/255, 0.8) :
                               (_bsMa.containsMouse ? Qt.rgba(255, 255, 255, 0.20) : Qt.rgba(255, 255, 255, 0.12))
                        border.color: Qt.rgba(255, 255, 255, 0.18)
                        border.width: 1

                        Image {
                            anchors.centerIn: parent
                            source: "qrc:/ApexVision/qml/assets/icons/yt_backspace.svg"
                            width: 18
                            height: 18
                            sourceSize: Qt.size(18, 18)
                        }

                        MouseArea {
                            id: _bsMa
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                if (searchInput.text.length > 0) {
                                    searchInput.text = searchInput.text.substring(0, searchInput.text.length - 1)
                                }
                            }
                        }
                    }
                }

                // Row 4: Clear + Spacebar + Period + Search
                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 8

                    // Clear Key
                    Rectangle {
                        width: 80
                        height: 42
                        radius: 8
                        color: _clrMa.pressed ? Qt.rgba(239/255, 68/255, 68/255, 0.8) : Qt.rgba(255, 255, 255, 0.10)
                        border.color: Qt.rgba(255, 255, 255, 0.16)
                        border.width: 1

                        Text {
                            anchors.centerIn: parent
                            text: "Clear"
                            color: "#FFFFFF"
                            font.family: "Inter"
                            font.pixelSize: 13
                            font.weight: Font.Medium
                        }

                        MouseArea {
                            id: _clrMa
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: searchInput.text = ""
                        }
                    }

                    // Spacebar (Google Gboard style: "English")
                    Rectangle {
                        width: googleKeyboardContainer.width * 0.48
                        height: 42
                        radius: 8
                        color: _spMa.pressed ? Qt.rgba(255, 255, 255, 0.24) :
                               (_spMa.containsMouse ? Qt.rgba(255, 255, 255, 0.15) : Qt.rgba(255, 255, 255, 0.10))
                        border.color: Qt.rgba(255, 255, 255, 0.16)
                        border.width: 1

                        Text {
                            anchors.centerIn: parent
                            text: "English"
                            color: _spMa.pressed ? "#FFFFFF" : "#94A3B8"
                            font.family: "Inter"
                            font.pixelSize: 14
                            font.weight: Font.Medium
                        }

                        MouseArea {
                            id: _spMa
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: searchInput.text += " "
                        }
                    }

                    // Period key
                    Rectangle {
                        width: 50
                        height: 42
                        radius: 8
                        color: _dotMa.pressed ? Qt.rgba(255, 255, 255, 0.24) : Qt.rgba(255, 255, 255, 0.10)
                        border.color: Qt.rgba(255, 255, 255, 0.16)
                        border.width: 1

                        Text {
                            anchors.centerIn: parent
                            text: "."
                            color: "#FFFFFF"
                            font.pixelSize: 18
                            font.weight: Font.Bold
                        }

                        MouseArea {
                            id: _dotMa
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: searchInput.text += "."
                        }
                    }

                    // Touch Search Action Key (Google Blue #1A73E8, Vector SVG search icon)
                    Rectangle {
                        width: 120
                        height: 42
                        radius: 8
                        color: _kSearchMa.pressed ? "#1557B0" : "#1A73E8"
                        border.color: "#4285F4"
                        border.width: 1

                        Row {
                            anchors.centerIn: parent
                            spacing: 6

                            Image {
                                source: "qrc:/ApexVision/qml/assets/icons/yt_cat_search.svg"
                                width: 14
                                height: 14
                                sourceSize: Qt.size(14, 14)
                                anchors.verticalCenter: parent.verticalCenter
                            }

                            Text {
                                text: "Search"
                                color: "#FFFFFF"
                                font.family: "Inter"
                                font.pixelSize: 14
                                font.weight: Font.DemiBold
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }

                        MouseArea {
                            id: _kSearchMa
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                videoPage.showTouchKeyboard = false
                                VideoBackend.searchVideos(searchInput.text)
                            }
                        }
                    }
                }
            }
        }
    }

    // =====================================================================
    //  VIEW 2 – THEATER PLAYER  (video selected)
    // =====================================================================
    Item {
        id: playerView
        anchors.top: videoPage.isFullScreen ? parent.top : topBar.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.leftMargin: videoPage.isFullScreen ? 0 : 24
        anchors.rightMargin: videoPage.isFullScreen ? 0 : 24
        anchors.topMargin: videoPage.isFullScreen ? 0 : 12
        anchors.bottomMargin: videoPage.isFullScreen ? 0 : 20
        visible: VideoBackend.isPlayerOpen

        Row {
            anchors.fill: parent
            spacing: 20

            // ── LEFT: primary video player (68%) ─────────────────────────
            Column {
                width: parent.width * 0.68
                height: parent.height
                spacing: 14

                // Player container
                Rectangle {
                    id: playerContainer
                    width: parent.width
                    height: parent.width * 9 / 16
                    radius: 14
                    clip: true
                    color: "#000000"

                    WebEngineView {
                        id: ytWebEngine
                        anchors.fill: parent
                        backgroundColor: "#000000"

                        settings.javascriptEnabled: true
                        settings.playbackRequiresUserGesture: false
                        settings.localContentCanAccessRemoteUrls: true
                        settings.localContentCanAccessFileUrls: true
                        settings.pluginsEnabled: true
                        settings.fullScreenSupportEnabled: true
                        settings.allowRunningInsecureContent: true

                        profile.httpUserAgent: "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"

                        onLoadingChanged: function(loadRequest) {
                            if (loadRequest.status === WebEngineView.LoadSucceededStatus) {
                                loadingOverlay.visible = false
                            } else if (loadRequest.status === WebEngineView.LoadStartedStatus) {
                                loadingOverlay.visible = true
                            } else if (loadRequest.status === WebEngineView.LoadFailedStatus) {
                                loadingOverlay.visible = false
                                console.log("[VideoPage] Load failed:", loadRequest.errorString)
                            }
                        }

                        onTitleChanged: {
                            if (ytWebEngine.title.indexOf("YT_VIDEO_ENDED") !== -1) {
                                ytWebEngine.runJavaScript("if (window.resetVideoEnded) window.resetVideoEnded();")
                                videoEndDebounceTimer.restart()
                            }
                        }

                        onFullScreenRequested: function(request) {
                            if (request.toggleOn) {
                                videoPage.isFullScreen = true
                                videoPage.fullScreenRequested(true)
                            } else {
                                videoPage.isFullScreen = false
                                videoPage.fullScreenRequested(false)
                            }
                            request.accept()
                        }
                    }

                    // Floating Exit Fullscreen Button in top corner (placed lower so it does not overlap channel name)
                    Rectangle {
                        id: floatingExitFullscreenBtn
                        visible: videoPage.isFullScreen
                        z: 2000
                        width: 44
                        height: 44
                        radius: 22
                        anchors.top: parent.top
                        anchors.left: parent.left
                        anchors.topMargin: 76
                        anchors.leftMargin: 24
                        color: Qt.rgba(15/255, 23/255, 42/255, 0.85)
                        border.color: Qt.rgba(255, 255, 255, 0.3)
                        border.width: 1

                        Image {
                            anchors.centerIn: parent
                            source: "qrc:/ApexVision/qml/assets/icons/yt_close.svg"
                            width: 16
                            height: 16
                            sourceSize: Qt.size(16, 16)
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                videoPage.exitFullScreen()
                            }
                        }
                    }

                    // Loading overlay
                    Rectangle {
                        id: loadingOverlay
                        anchors.fill: parent
                        color: "#000000"
                        visible: false
                        z: 10

                        Column {
                            anchors.centerIn: parent
                            spacing: 14

                            Rectangle {
                                width: 44
                                height: 44
                                radius: 22
                                color: "transparent"
                                border.color: "#CC0000"
                                border.width: 3
                                anchors.horizontalCenter: parent.horizontalCenter

                                Rectangle {
                                    width: 10
                                    height: 10
                                    radius: 5
                                    color: "#CC0000"
                                    anchors.top: parent.top
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    anchors.topMargin: -2
                                }

                                RotationAnimation on rotation {
                                    from: 0
                                    to: 360
                                    duration: 1000
                                    loops: Animation.Infinite
                                    running: loadingOverlay.visible
                                }
                            }

                            Text {
                                text: "Loading video…"
                                color: "#AAAAAA"
                                font.family: "Inter"
                                font.pixelSize: 13
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }
                    }
                }

                // Video title & metadata
                Column {
                    width: parent.width
                    spacing: 10

                    Text {
                        width: parent.width
                        text: VideoBackend.currentVideo ? (VideoBackend.currentVideo.title || "") : ""
                        color: "#F1F1F1"
                        font.family: "Inter"
                        font.pixelSize: 20
                        font.weight: Font.Bold
                        elide: Text.ElideRight
                        maximumLineCount: 2
                        wrapMode: Text.WordWrap
                    }

                    Row {
                        width: parent.width
                        spacing: 14

                        // Channel avatar (Shows actual YouTube channel logo)
                        Rectangle {
                            width: 42
                            height: 42
                            radius: 21
                            clip: true
                            color: (VideoBackend.currentVideo && VideoBackend.currentVideo.channelColor) ? VideoBackend.currentVideo.channelColor : "#717171"
                            anchors.verticalCenter: parent.verticalCenter

                            Text {
                                anchors.centerIn: parent
                                text: (VideoBackend.currentVideo && VideoBackend.currentVideo.channelInitial)
                                    ? VideoBackend.currentVideo.channelInitial
                                    : (VideoBackend.currentVideo && VideoBackend.currentVideo.channel ? VideoBackend.currentVideo.channel.substring(0, 2).toUpperCase() : "YT")
                                color: "#FFFFFF"
                                font.family: "Inter"
                                font.pixelSize: 14
                                font.weight: Font.Bold
                                visible: !playerAvatarImg.visible || playerAvatarImg.status !== Image.Ready
                            }

                            Image {
                                id: playerAvatarImg
                                anchors.fill: parent
                                source: (VideoBackend.currentVideo && VideoBackend.currentVideo.channelAvatar) ? VideoBackend.currentVideo.channelAvatar : ""
                                fillMode: Image.PreserveAspectCrop
                                smooth: true
                                asynchronous: true
                                visible: (source !== "") && status === Image.Ready
                            }
                        }

                        // Channel name + subscribers
                        Column {
                            spacing: 2
                            anchors.verticalCenter: parent.verticalCenter

                            Row {
                                spacing: 5
                                Text {
                                    text: VideoBackend.currentVideo ? (VideoBackend.currentVideo.channel || "") : ""
                                    color: "#F1F1F1"
                                    font.family: "Inter"
                                    font.pixelSize: 15
                                    font.weight: Font.DemiBold
                                }
                                Text {
                                    text: "✓"
                                    color: "#AAAAAA"
                                    font.pixelSize: 11
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                            }

                            Text {
                                text: (VideoBackend.currentVideo && VideoBackend.currentVideo.subscribers) ? VideoBackend.currentVideo.subscribers : ""
                                color: "#AAAAAA"
                                font.family: "Inter"
                                font.pixelSize: 12
                            }
                        }

                        Item { width: 10; height: 1 }

                        // Views pill
                        Rectangle {
                            height: 34
                            width: _viewsTxt.implicitWidth + 20
                            radius: 17
                            color: Qt.rgba(1, 1, 1, 0.08)
                            anchors.verticalCenter: parent.verticalCenter

                            Text {
                                id: _viewsTxt
                                anchors.centerIn: parent
                                text: VideoBackend.currentVideo ? (VideoBackend.currentVideo.views || "") : ""
                                color: "#F1F1F1"
                                font.family: "Inter"
                                font.pixelSize: 13
                            }
                        }
                    }
                }
            }

            // ── RIGHT: Up Next sidebar (32%) ─────────────────────────────
            Column {
                width: parent.width * 0.32 - 20
                height: parent.height
                spacing: 12

                Text {
                    text: "Up next"
                    color: "#F1F1F1"
                    font.family: "Inter"
                    font.pixelSize: 16
                    font.weight: Font.Bold
                }

                Flickable {
                    id: upNextFlickable
                    width: parent.width
                    height: parent.height - 36
                    clip: true
                    contentWidth: width
                    contentHeight: upNextCol.height
                    boundsBehavior: Flickable.StopAtBounds

                    Column {
                        id: upNextCol
                        width: parent.width
                        spacing: 10

                        Repeater {
                            model: VideoBackend.relatedVideos

                            Rectangle {
                                width: parent.width
                                height: 86
                                radius: 8
                                clip: true
                                color: _sideMa.containsMouse ? Qt.rgba(255, 255, 255, 0.05) : "transparent"
                                border.width: 0
                                border.color: "transparent"

                                scale: _sideMa.pressed ? 0.98 : (_sideMa.containsMouse ? 1.01 : 1.0)
                                Behavior on scale { NumberAnimation { duration: 120 } }

                                Row {
                                    anchors.fill: parent
                                    anchors.margins: 4
                                    spacing: 10

                                    Rectangle {
                                        width: 104
                                        height: parent.height
                                        radius: 8
                                        clip: true
                                        color: "#1F2937"

                                        Image {
                                            anchors.fill: parent
                                            source: modelData.thumbnail || ""
                                            fillMode: Image.PreserveAspectCrop
                                            smooth: true
                                            asynchronous: true
                                        }

                                        Rectangle {
                                            anchors.right: parent.right
                                            anchors.bottom: parent.bottom
                                            anchors.margins: 4
                                            height: 16
                                            width: _durSideTxt.implicitWidth + 6
                                            radius: 3
                                            color: Qt.rgba(0, 0, 0, 0.8)
                                            visible: (modelData.duration || "").length > 0

                                            Text {
                                                id: _durSideTxt
                                                anchors.centerIn: parent
                                                text: modelData.duration || ""
                                                color: "#FFFFFF"
                                                font.pixelSize: 9
                                                font.weight: Font.Medium
                                            }
                                        }
                                    }

                                    Column {
                                        width: parent.width - 114
                                        anchors.verticalCenter: parent.verticalCenter
                                        spacing: 3

                                        Text {
                                            width: parent.width
                                            text: modelData.title || ""
                                            color: "#FFFFFF"
                                            font.family: "Inter"
                                            font.pixelSize: 12
                                            font.weight: Font.DemiBold
                                            elide: Text.ElideRight
                                            maximumLineCount: 2
                                            wrapMode: Text.WordWrap
                                        }

                                        Text {
                                            text: modelData.channel || ""
                                            color: "#94A3B8"
                                            font.family: "Inter"
                                            font.pixelSize: 11
                                            elide: Text.ElideRight
                                        }

                                        Text {
                                            text: modelData.views || ""
                                            color: "#64748B"
                                            font.family: "Inter"
                                            font.pixelSize: 10
                                        }
                                    }
                                }

                                MouseArea {
                                    id: _sideMa
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                        MediaBackend.fadeOutAndPause(700)
                                        videoPage.playVideo(modelData.videoId)
                                        VideoBackend.selectVideo(modelData)
                                    }
                                }

                                // Subtle divider line between items (replaces border)
                                Rectangle {
                                    anchors.bottom: parent.bottom
                                    anchors.left: parent.left
                                    anchors.right: parent.right
                                    height: 1
                                    color: Qt.rgba(255, 255, 255, 0.08)
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    states: [
        State {
            name: "fullscreen"
            when: videoPage.isFullScreen
            ParentChange {
                target: playerContainer
                parent: videoPage
                x: 0
                y: 0
                width: videoPage.width
                height: videoPage.height
            }
            PropertyChanges {
                target: playerContainer
                radius: 0
                z: 999
            }
        }
    ]
}
