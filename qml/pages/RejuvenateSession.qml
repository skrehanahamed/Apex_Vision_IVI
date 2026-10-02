/**
 * ==============================================================================
 * Project: Apex VISION IVI - Digital Cockpit & Infotainment System
 * File: RejuvenateSession.qml
 * Author / Developer: Sk Rehan Ahamed
 * License: MIT
 * ==============================================================================
 */

import QtQuick
import QtQuick.Controls
import QtMultimedia

Item {
    id: root

    signal exitSessionRequested()

    property bool hudVisible: true
    property bool showConfirmEnd: false

    // Preparation loading animation for dual tracks
    property bool prepRightToLeft: false
    property real prepProgress: 0.0
    NumberAnimation on prepProgress {
        id: prepAnim
        from: 0.0
        to: 1.0
        duration: 2800
        easing.type: Easing.InOutQuad
        running: typeof RejuvenateController !== "undefined" && RejuvenateController.isPreparing
    }

    Connections {
        target: RejuvenateController
        function onIsPreparingChanged() {
            if (RejuvenateController.isPreparing) {
                root.prepProgress = 0.0;
                prepAnim.restart();
            } else {
                prepAnim.stop();
                root.prepProgress = 0.0;
            }
        }
    }

    // Auto-hide timer: fades controls out after 4 seconds of inactivity
    Timer {
        id: hudAutoHideTimer
        interval: 4000
        repeat: false
        running: root.hudVisible && !RejuvenateController.paused && !root.showConfirmEnd
        onTriggered: {
            root.hudVisible = false;
        }
    }

    // 1. Background Video Playback with Qt Multimedia (4K UHD)
    MediaPlayer {
        id: player
        source: RejuvenateController.videoSource
        loops: MediaPlayer.Infinite
        audioOutput: audioOut
        videoOutput: videoOut

        onMediaStatusChanged: {
            if (mediaStatus === MediaPlayer.LoadedMedia || mediaStatus === MediaPlayer.BufferedMedia) {
                if (RejuvenateController.active && playbackState !== MediaPlayer.PlayingState) {
                    play();
                }
            }
        }

        onErrorOccurred: function(error, errorString) {
            console.warn("[RejuvenateSession] Video playback error:", error, errorString);
        }
    }

    AudioOutput {
        id: audioOut
        volume: RejuvenateController.audioVolume
        muted: false
    }

    // Bind playback state to RejuvenateController state
    Connections {
        target: RejuvenateController

        function onStateChanged() {
            if (RejuvenateController.active) {
                root.hudVisible = true;
                hudAutoHideTimer.restart();
                if (player.playbackState !== MediaPlayer.PlayingState) {
                    player.play();
                }
            } else if (RejuvenateController.paused) {
                root.hudVisible = true;
                player.pause();
            } else {
                player.stop();
            }
        }

        function onVideoSourceChanged() {
            if (RejuvenateController.active) {
                player.source = RejuvenateController.videoSource;
                player.play();
            }
        }
    }

    Component.onCompleted: {
        if (RejuvenateController.active) {
            player.play();
            hudAutoHideTimer.restart();
        }
    }

    Component.onDestruction: {
        player.stop();
    }

    // 2. Full-Screen Video Display (Edge-to-Edge)
    Rectangle {
        anchors.fill: parent
        color: "#000000"

        Image {
            id: sessionFallbackImage
            anchors.fill: parent
            source: {
                var th = RejuvenateController.currentTheme;
                return (th && th.previewUrl) ? th.previewUrl : "";
            }
            fillMode: Image.PreserveAspectCrop
            smooth: true
            asynchronous: true
            opacity: RejuvenateController.isPreparing ? 0.0 : RejuvenateController.videoOpacity

            Behavior on opacity {
                NumberAnimation { duration: 600; easing.type: Easing.InOutQuad }
            }
        }

        VideoOutput {
            id: videoOut
            anchors.fill: parent
            fillMode: VideoOutput.PreserveAspectCrop
            opacity: RejuvenateController.isPreparing ? 0.0 : RejuvenateController.videoOpacity

            Behavior on opacity {
                NumberAnimation { duration: 600; easing.type: Easing.InOutQuad }
            }
        }

        // Ambient lighting screen glow simulation overlay (dark during prep)
        Rectangle {
            anchors.fill: parent
            opacity: RejuvenateController.isPreparing ? 0.0 : ((AmbientLightBackend.brightness / 100.0) * 0.08)
            color: AmbientLightBackend.color

            Behavior on color { ColorAnimation { duration: 1500 } }
            Behavior on opacity { NumberAnimation { duration: 1500 } }
        }

        Rectangle {
            anchors.fill: parent
            color: "transparent"
            border.color: AmbientLightBackend.color
            border.width: 3
            opacity: RejuvenateController.isPreparing ? 0.0 : ((AmbientLightBackend.brightness / 100.0) * 0.40)

            Behavior on border.color { ColorAnimation { duration: 1500 } }
            Behavior on opacity { NumberAnimation { duration: 1500 } }
        }
    }

    // 3. FULL-SCREEN TAP-TO-REVEAL AREA ("once we tap once we get the icons and all")
    MouseArea {
        id: screenTapArea
        anchors.fill: parent
        z: 10
        onClicked: {
            root.hudVisible = !root.hudVisible;
            if (root.hudVisible) {
                hudAutoHideTimer.restart();
            }
        }
    }

    // 4. INTERACTIVE HUD OVERLAY (Stop Button, Center Header, Relax/Invigorate Timeline)
    Item {
        id: hudContainer
        anchors.fill: parent
        z: 20
        opacity: root.hudVisible ? 1.0 : 0.0
        enabled: root.hudVisible

        Behavior on opacity {
            NumberAnimation { duration: 250; easing.type: Easing.InOutQuad }
        }

        // Top Subtle Gradient for header readability
        Rectangle {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: 120
            gradient: Gradient {
                GradientStop { position: 0.0; color: Qt.rgba(0, 0, 0, 0.65) }
                GradientStop { position: 1.0; color: "transparent" }
            }
        }

        // Bottom Subtle Gradient for timeline readability
        Rectangle {
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            height: 160
            gradient: Gradient {
                GradientStop { position: 0.0; color: "transparent" }
                GradientStop { position: 1.0; color: Qt.rgba(0, 0, 0, 0.75) }
            }
        }

        // TOP LEFT: [ Stop ] BUTTON (Transparent glass styling, positioned clear of navigation rail)
        Rectangle {
            id: stopBtn
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.topMargin: 36
            anchors.leftMargin: 110
            width: 116
            height: 46
            radius: 12
            color: stopMouse.pressed ? Qt.rgba(255, 255, 255, 0.20) :
                   (stopMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.12) : Qt.rgba(255, 255, 255, 0.05))
            border.color: stopMouse.containsMouse ? "#00D2FF" : Qt.rgba(255, 255, 255, 0.35)
            border.width: 1.2

            Behavior on border.color { ColorAnimation { duration: 120 } }
            Behavior on color { ColorAnimation { duration: 120 } }

            Text {
                anchors.centerIn: parent
                text: "Stop"
                color: "#FFFFFF"
                font.family: "Inter"
                font.pixelSize: 18
                font.weight: Font.DemiBold
            }

            MouseArea {
                id: stopMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    RejuvenateController.endSession(true);
                }
            }
        }

        // CENTER TOP: "Preparing your experience..." OR "MM:SS remaining" (Matching Photo 2 & 3)
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 42
            text: {
                if (RejuvenateController.isPreparing) {
                    return "Preparing your experience...";
                } else {
                    return RejuvenateController.formattedRemaining + " remaining";
                }
            }
            color: "#FFFFFF"
            font.family: "Inter"
            font.pixelSize: 22
            font.weight: Font.DemiBold
            font.letterSpacing: 0.5
        }

        // BOTTOM: RELAX / INVIGORATE TIMELINE SLIDER (Precisely aligned to reference image)
        Item {
            id: timelineBox
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 150
            width: Math.min(parent.width - 240, 840)
            height: 90

            // LEFT SECTION: RELAX (6 Icons + Bar + "Relax" label)
            Item {
                id: relaxSection
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: (parent.width - 16) / 2

                // 6 Relax Icons precisely distributed covering the line length with space between each
                Item {
                    id: relaxIconsContainer
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    height: 32

                    Repeater {
                        model: [
                            "qrc:/ApexVision/qml/assets/icons/rejuvenate_ico_0.png",
                            "qrc:/ApexVision/qml/assets/icons/rejuvenate_ico_1.png",
                            "qrc:/ApexVision/qml/assets/icons/rejuvenate_ico_2.png",
                            "qrc:/ApexVision/qml/assets/icons/rejuvenate_ico_3.png",
                            "qrc:/ApexVision/qml/assets/icons/rejuvenate_ico_4.png",
                            "qrc:/ApexVision/qml/assets/icons/rejuvenate_ico_5.png"
                        ]

                        Item {
                            width: 26
                            height: 26
                            anchors.verticalCenter: parent.verticalCenter
                            x: index * (relaxIconsContainer.width - width) / 5

                            Image {
                                anchors.centerIn: parent
                                width: 22
                                height: 22
                                source: modelData
                                fillMode: Image.PreserveAspectFit
                                smooth: true
                                opacity: 0.95
                            }
                        }
                    }
                }

                // Left track (Relax loading bar)
                Rectangle {
                    id: leftTrack
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: relaxIconsContainer.bottom
                    anchors.topMargin: 8
                    height: 4.5
                    radius: 2.25
                    color: Qt.rgba(1, 1, 1, 0.28)

                    Rectangle {
                        id: leftFill
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        anchors.left: (root.prepRightToLeft && RejuvenateController.isPreparing) ? undefined : parent.left
                        anchors.right: (root.prepRightToLeft && RejuvenateController.isPreparing) ? parent.right : undefined
                        radius: 2.25
                        color: "#FFFFFF"
                        width: {
                            if (RejuvenateController.isPreparing) {
                                if (root.prepRightToLeft) {
                                    // In RTL: second half (0.5 to 1.0) fills left track
                                    var p = Math.min(1.0, Math.max(0.0, (root.prepProgress - 0.5) * 2.0));
                                    return parent.width * p;
                                } else {
                                    // In normal LTR: first half (0.0 to 0.5) fills left track completely
                                    var p = Math.min(1.0, Math.max(0.0, root.prepProgress * 2.0));
                                    return parent.width * p;
                                }
                            } else {
                                var p = Math.min(1.0, Math.max(0.0, RejuvenateController.progress * 2.0));
                                return parent.width * Math.max(p, 0.02);
                            }
                        }

                        Behavior on width {
                            enabled: !RejuvenateController.isPreparing
                            NumberAnimation { duration: 250 }
                        }
                    }
                }

                // "Relax" label (left-aligned directly under the left bar)
                Text {
                    anchors.left: parent.left
                    anchors.top: leftTrack.bottom
                    anchors.topMargin: 8
                    text: "Relax"
                    color: "#FFFFFF"
                    font.family: "Inter"
                    font.pixelSize: 17
                    font.weight: Font.DemiBold
                }
            }

            // RIGHT SECTION: INVIGORATE (6 Icons + Bar + "Invigorate" label)
            Item {
                id: invigorateSection
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: (parent.width - 16) / 2

                // 6 Invigorate Icons precisely distributed covering the line length with space between each
                Item {
                    id: invigorateIconsContainer
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    height: 32

                    Repeater {
                        model: [
                            "qrc:/ApexVision/qml/assets/icons/rejuvenate_ico_6.png",
                            "qrc:/ApexVision/qml/assets/icons/rejuvenate_ico_7.png",
                            "qrc:/ApexVision/qml/assets/icons/rejuvenate_ico_8.png",
                            "qrc:/ApexVision/qml/assets/icons/rejuvenate_ico_9.png",
                            "qrc:/ApexVision/qml/assets/icons/rejuvenate_ico_10.png",
                            "qrc:/ApexVision/qml/assets/icons/rejuvenate_ico_11.png"
                        ]

                        Item {
                            width: 26
                            height: 26
                            anchors.verticalCenter: parent.verticalCenter
                            x: index * (invigorateIconsContainer.width - width) / 5

                            Image {
                                anchors.centerIn: parent
                                width: 22
                                height: 22
                                source: modelData
                                fillMode: Image.PreserveAspectFit
                                smooth: true
                                opacity: 0.95
                            }
                        }
                    }
                }

                // Right track (Invigorate loading bar)
                Rectangle {
                    id: rightTrack
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: invigorateIconsContainer.bottom
                    anchors.topMargin: 8
                    height: 4.5
                    radius: 2.25
                    color: Qt.rgba(1, 1, 1, 0.28)

                    Rectangle {
                        id: rightFill
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        anchors.left: (root.prepRightToLeft && RejuvenateController.isPreparing) ? undefined : parent.left
                        anchors.right: (root.prepRightToLeft && RejuvenateController.isPreparing) ? parent.right : undefined
                        radius: 2.25
                        color: "#FFFFFF"
                        width: {
                            if (RejuvenateController.isPreparing) {
                                if (root.prepRightToLeft) {
                                    // In RTL: first half (0.0 to 0.5) fills right track completely
                                    var p = Math.min(1.0, Math.max(0.0, root.prepProgress * 2.0));
                                    return parent.width * p;
                                } else {
                                    // In normal LTR: second half (0.5 to 1.0) fills right track
                                    var p = Math.min(1.0, Math.max(0.0, (root.prepProgress - 0.5) * 2.0));
                                    return parent.width * p;
                                }
                            } else {
                                var p = Math.min(1.0, Math.max(0.0, (RejuvenateController.progress - 0.5) * 2.0));
                                return parent.width * p;
                            }
                        }

                        Behavior on width {
                            enabled: !RejuvenateController.isPreparing
                            NumberAnimation { duration: 250 }
                        }
                    }
                }

                // "Invigorate" label (left-aligned directly under the start of right bar!)
                Text {
                    anchors.left: parent.left
                    anchors.top: rightTrack.bottom
                    anchors.topMargin: 8
                    text: "Invigorate"
                    color: "#FFFFFF"
                    font.family: "Inter"
                    font.pixelSize: 17
                    font.weight: Font.DemiBold
                }
            }
        }
    }

    // 5. PAUSED SCREEN OVERLAY
    Rectangle {
        anchors.fill: parent
        color: Qt.rgba(0, 0, 0, 0.65)
        visible: RejuvenateController.paused && !root.showConfirmEnd && !RejuvenateController.safetyAlert && opacity > 0.01
        opacity: RejuvenateController.paused ? 1.0 : 0.0
        z: 30

        Column {
            anchors.centerIn: parent
            spacing: 20

            Text {
                text: "Session Paused"
                color: "#FFFFFF"
                font.family: "Inter"
                font.pixelSize: 32
                font.weight: Font.Bold
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 16

                Rectangle {
                    width: 140
                    height: 48
                    radius: 12
                    color: "#007AFF"

                    Text {
                        anchors.centerIn: parent
                        text: "Resume"
                        color: "#FFFFFF"
                        font.family: "Inter"
                        font.pixelSize: 16
                        font.weight: Font.DemiBold
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: RejuvenateController.resumeSession()
                    }
                }

                Rectangle {
                    width: 140
                    height: 48
                    radius: 12
                    color: Qt.rgba(1, 1, 1, 0.15)
                    border.color: Qt.rgba(1, 1, 1, 0.25)

                    Text {
                        anchors.centerIn: parent
                        text: "End"
                        color: "#FFFFFF"
                        font.family: "Inter"
                        font.pixelSize: 16
                        font.weight: Font.DemiBold
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: RejuvenateController.endSession(true)
                    }
                }
            }
        }
    }
}
