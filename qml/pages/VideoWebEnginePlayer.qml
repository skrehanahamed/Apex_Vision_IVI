/**
 * ==============================================================================
 * Project: Apex VISION IVI - Digital Cockpit & Infotainment System
 * File: VideoWebEnginePlayer.qml
 * Description: YouTube WebEngine Embedded Player
 * Author / Developer: Sk Rehan Ahamed
 * License: MIT
 * ==============================================================================
 */

import QtQuick
import QtQuick.Controls
import QtWebEngine

Item {
    id: root
    anchors.fill: parent

    property alias audioMuted: ytWebEngine.audioMuted
    property alias url: ytWebEngine.url
    property alias title: ytWebEngine.title

    signal loadingChanged(var loadRequest)
    signal videoEnded()
    signal fullScreenRequested(bool toggleOn)

    function runJavaScript(script, callback) {
        if (callback) {
            ytWebEngine.runJavaScript(script, callback);
        } else {
            ytWebEngine.runJavaScript(script);
        }
    }

    function loadHtml(html, baseUrl) {
        ytWebEngine.loadHtml(html, baseUrl);
    }

    function stop() {
        ytWebEngine.stop();
    }

    WebEngineView {
        id: ytWebEngine
        anchors.fill: parent
        backgroundColor: "#000000"

        onLoadingChanged: function(loadRequest) {
            root.loadingChanged(loadRequest);
        }

        onTitleChanged: {
            if (ytWebEngine.title.indexOf("YT_VIDEO_ENDED") !== -1) {
                ytWebEngine.runJavaScript("if (window.resetVideoEnded) window.resetVideoEnded();");
                root.videoEnded();
            }
        }

        onFullScreenRequested: function(request) {
            root.fullScreenRequested(request.toggleOn);
            request.accept();
        }
    }
}
