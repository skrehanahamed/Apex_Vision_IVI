/**
 * ==============================================================================
 * Project: Apex VISION IVI - Digital Cockpit & Infotainment System
 * File: HelicopterGameView.qml
 * Description: Endless Helicopter Reborn Hardware-Accelerated WebEngine Container
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

    signal exitRequested()

    WebEngineView {
        id: webEngine
        anchors.fill: parent
        backgroundColor: "#000000"

        // Load local game files: checks /opt/apex_vision_ivi on Pi 5 or local development path
        url: (Qt.platform.os === "osx" || Qt.platform.os === "macos")
            ? "file:///Users/reno/Projects/APEX_VISION_IVI_PI5/web/helicopter/index.html"
            : "file:///opt/apex_vision_ivi/web/helicopter/index.html"

        settings.javascriptEnabled: true
        settings.localContentCanAccessRemoteUrls: true
        settings.localContentCanAccessFileUrls: true
        settings.playbackRequiresUserGesture: false
        settings.webGLEnabled: true
        settings.accelerated2dCanvasEnabled: true

        onJavaScriptConsoleMessage: function(level, message, lineNumber, sourceID) {
            console.log("[Heli JS Console] (" + lineNumber + ") " + message);
        }

        onLoadingChanged: function(loadRequest) {
            console.log("[Heli WebEngine Loading] status: " + loadRequest.status + " url: " + loadRequest.url);
        }

        onTitleChanged: {
            if (webEngine.title === "APEX_GAME_EXIT" || webEngine.title.indexOf("APEX_GAME_EXIT") !== -1) {
                root.exitRequested();
            }
        }
    }

    // Top-Left Floating Safe Exit Button (In case touch intercepts canvas)
    Rectangle {
        id: safeBackBtn
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.topMargin: 20
        anchors.leftMargin: 24
        width: 110
        height: 42
        radius: 12
        color: safeBackMouse.pressed ? Qt.rgba(0, 210/255, 255/255, 0.35) : Qt.rgba(10/255, 16/255, 26/255, 0.78)
        border.color: safeBackMouse.containsMouse ? "#00D2FF" : Qt.rgba(255, 255, 255, 0.20)
        border.width: 1
        z: 99

        Row {
            anchors.centerIn: parent
            spacing: 8

            Text {
                text: "←"
                color: "#00D2FF"
                font.family: "Inter"
                font.pixelSize: 18
                font.bold: true
            }

            Text {
                text: "EXIT"
                color: "#FFFFFF"
                font.family: "Inter"
                font.pixelSize: 14
                font.bold: true
                font.letterSpacing: 1.2
            }
        }

        MouseArea {
            id: safeBackMouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                if (typeof SystemBackend !== "undefined") {
                    SystemBackend.playTouchSound();
                }
                root.exitRequested();
            }
        }
    }
}
