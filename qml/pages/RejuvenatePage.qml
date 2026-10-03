/**
 * ==============================================================================
 * Project: Apex VISION IVI - Digital Cockpit & Infotainment System
 * File: RejuvenatePage.qml
 * Author / Developer: Sk Rehan Ahamed
 * License: MIT
 * ==============================================================================
 */

import QtQuick
import QtQuick.Controls
import QtMultimedia
import QtQuick.Effects

Item {
    id: root

    signal backRequested()

    property bool showWarningDialog: false
    property int pendingDuration: 600
    property bool settingsOpen: false
    property string activeSettingsTab: "scent"
    property string selectedScent: "Mystic Forest"
    property bool autoScentWithTheme: true
    property bool driverSeatMovement: true
    property bool seatMassage: true
    property bool seatHeated: true
    property bool seatVentilated: true
    property bool ambientSync: true
    property bool cabinDimming: true
    property bool voiceGuidance: true
    property bool spatialAudio: true

    // In-Page Preview Mode (No fullscreen, no prepare phase, matching reference photo)
    property bool isPreviewMode: false
    property real previewProgress: 0.0
    property int previewActiveIndex: 0

    NumberAnimation on previewProgress {
        id: previewAnim
        from: 0.0
        to: 1.0
        duration: 20000
        running: root.isPreviewMode
        loops: Animation.Infinite
    }

    onPreviewProgressChanged: {
        if (root.isPreviewMode) {
            root.previewActiveIndex = Math.min(11, Math.floor(root.previewProgress * 12));
        }
    }

    onVisibleChanged: {
        if (visible) {
            if (typeof MediaBackend !== "undefined") {
                MediaBackend.setIsPlaying(false);
                MediaBackend.pausePlayback();
            }
        } else {
            if (root.isPreviewMode) {
                root.isPreviewMode = false;
            }
            if (typeof RejuvenateController !== "undefined" && !RejuvenateController.active) {
                RejuvenateController.stopPreviewAudio();
            }
        }
    }

    onIsPreviewModeChanged: {
        if (root.isPreviewMode) {
            if (typeof MediaBackend !== "undefined") {
                MediaBackend.setIsPlaying(false);
                MediaBackend.pausePlayback();
            }
            RejuvenateController.startPreviewAudio();
        } else if (!RejuvenateController.active) {
            RejuvenateController.stopPreviewAudio();
        }
    }

    Component.onDestruction: {
        RejuvenateController.stopPreviewAudio();
    }

    // 1. LIVE CONTINUOUS BACKGROUND VIDEO WITH ARTWORK FALLBACK
    AudioOutput {
        id: bgAudioOut
        volume: 0.0
        muted: true
    }

    MediaPlayer {
        id: bgVideoPlayer
        source: RejuvenateController.videoSource
        loops: MediaPlayer.Infinite
        audioOutput: bgAudioOut
        videoOutput: bgVideoOutput

        onMediaStatusChanged: {
            if (mediaStatus === MediaPlayer.LoadedMedia || mediaStatus === MediaPlayer.BufferedMedia) {
                if (!RejuvenateController.active && playbackState !== MediaPlayer.PlayingState) {
                    play();
                }
            }
        }

        Component.onCompleted: {
            play();
        }
    }

    // 1. DYNAMIC BACKGROUND VIDEO CONTAINER WITH SWIPE TRANSITION
    Item {
        id: bgVideoViewport
        anchors.fill: parent
        clip: true

        // Outgoing snapshot layer (slides out during theme change)
        Item {
            id: outgoingLayer
            width: bgVideoViewport.width
            height: bgVideoViewport.height
            visible: false
            x: 0

            Image {
                id: outgoingImage
                anchors.fill: parent
                fillMode: Image.PreserveAspectCrop
                smooth: true
            }
        }

        // Incoming video layer (slides in during theme change)
        Item {
            id: incomingLayer
            width: bgVideoViewport.width
            height: bgVideoViewport.height
            x: 0

            Image {
                id: bgFallbackImage
                anchors.fill: parent
                source: {
                    var th = RejuvenateController.currentTheme;
                    return (th && th.previewUrl) ? th.previewUrl : "";
                }
                fillMode: Image.PreserveAspectCrop
                smooth: true
                asynchronous: true
            }

            VideoOutput {
                id: bgVideoOutput
                anchors.fill: parent
                fillMode: VideoOutput.PreserveAspectCrop
            }
        }

        ParallelAnimation {
            id: swipeAnim
            property int direction: 1

            NumberAnimation {
                target: outgoingLayer
                property: "x"
                to: -swipeAnim.direction * bgVideoViewport.width
                duration: 380
                easing.type: Easing.OutCubic
            }
            NumberAnimation {
                target: incomingLayer
                property: "x"
                from: swipeAnim.direction * bgVideoViewport.width
                to: 0
                duration: 380
                easing.type: Easing.OutCubic
            }
            onFinished: {
                outgoingLayer.visible = false;
            }
        }
    }

    // Pause background video when full screen session is active or preparing, resume when session ends
    Connections {
        target: RejuvenateController
        function onActiveChanged() {
            if (RejuvenateController.active || RejuvenateController.isPreparing) {
                bgVideoPlayer.pause();
            } else {
                bgVideoPlayer.play();
            }
        }
        function onIsPreparingChanged() {
            if (RejuvenateController.isPreparing) {
                bgVideoPlayer.pause();
            }
        }
        function onVideoSourceChanged() {
            if (!RejuvenateController.active && !RejuvenateController.isPreparing) {
                bgVideoPlayer.play();
            }
        }
    }

    // 2. ELEGANT TRANSLUCENT OVERLAYS (Allows live video motion to shine through while keeping text crisp)
    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            orientation: Gradient.Horizontal
            GradientStop { position: 0.0; color: Qt.rgba(0.01, 0.03, 0.08, 0.65) }
            GradientStop { position: 0.45; color: Qt.rgba(0.01, 0.03, 0.08, 0.42) }
            GradientStop { position: 1.0; color: Qt.rgba(0.01, 0.03, 0.08, 0.18) }
        }
    }

    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: Qt.rgba(0.01, 0.03, 0.08, 0.45) }
            GradientStop { position: 0.25; color: "transparent" }
            GradientStop { position: 0.80; color: Qt.rgba(0.01, 0.03, 0.08, 0.45) }
            GradientStop { position: 1.0; color: Qt.rgba(0.01, 0.03, 0.08, 0.70) }
        }
    }

    // 3. TOP BAR (Default Return Arrow, Rejuvenate/Settings Title, Right Settings Slider)
    Item {
        id: headerItem
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.topMargin: 22
        anchors.leftMargin: 36
        anchors.rightMargin: 36
        height: 56
        z: 20

        Row {
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            spacing: 18

            // Back Arrow Button (Default one used in VehiclePage / vehiclebar)
            Item {
                width: 38
                height: 38
                anchors.verticalCenter: parent.verticalCenter

                Text {
                    anchors.centerIn: parent
                    text: "←"
                    font.family: "Inter"
                    font.pixelSize: 26
                    font.weight: Font.DemiBold
                    color: backMouse.pressed ? "#94A3B8" : (backMouse.containsMouse ? "#FFFFFF" : "#E2E8F0")
                }

                MouseArea {
                    id: backMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        if (root.isPreviewMode) {
                            root.isPreviewMode = false;
                        } else if (root.settingsOpen) {
                            root.settingsOpen = false;
                        } else {
                            if (RejuvenateController.active || RejuvenateController.paused) {
                                RejuvenateController.endSession(true);
                            }
                            root.backRequested();
                        }
                    }
                }
            }

            // Official Rejuvenate App Icon (visible in main view)
            Image {
                width: 38
                height: 38
                source: "qrc:/ApexVision/qml/assets/icons/app_rejuvenate.svg"
                fillMode: Image.PreserveAspectFit
                smooth: true
                anchors.verticalCenter: parent.verticalCenter
                visible: !root.settingsOpen && !root.isPreviewMode
            }

            // Title: "Preview of the 5-minute experience", "Settings", or "Rejuvenate"
            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: root.isPreviewMode ? "Preview of the 5-minute experience" :
                      (root.settingsOpen ? "Settings" : "Rejuvenate")
                color: "#FFFFFF"
                font.family: "Inter"
                font.pixelSize: 24
                font.weight: Font.DemiBold
            }
        }

        // Right Settings Button (same sliders icon used in vehicle bar setting)
        Item {
            id: settingsBtn
            width: 40
            height: 40
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            visible: !root.settingsOpen

            Rectangle {
                anchors.fill: parent
                radius: 10
                color: settingsMouse.pressed ? Qt.rgba(255, 255, 255, 0.20) :
                       (settingsMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.08) : "transparent")
                scale: settingsMouse.pressed ? 0.92 : 1.0
                Behavior on color { ColorAnimation { duration: 100 } }
                Behavior on scale { NumberAnimation { duration: 80 } }
            }

            Image {
                anchors.centerIn: parent
                width: 24
                height: 24
                source: "qrc:/ApexVision/qml/assets/icons/setting_sliders_white.svg"
                fillMode: Image.PreserveAspectFit
                smooth: true
            }

            MouseArea {
                id: settingsMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    root.settingsOpen = true;
                }
            }
        }
    }

    // Elegant divider line below header matching reference photo
    Rectangle {
        id: headerDividerLine
        anchors.top: headerItem.bottom
        anchors.topMargin: 12
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: 36
        anchors.rightMargin: 36
        height: 1
        color: Qt.rgba(1, 1, 1, 0.16)
    }

    // 4. MAIN CONTENT AREA (Centered and aligned exactly like reference photo)
    Item {
        id: mainSelectionArea
        anchors.top: headerDividerLine.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.topMargin: 40
        anchors.leftMargin: 80
        anchors.rightMargin: 60
        anchors.bottomMargin: 40
        visible: opacity > 0.001
        opacity: (root.settingsOpen || root.isPreviewMode) ? 0.0 : 1.0
        x: (root.settingsOpen || root.isPreviewMode) ? -36 : 0
        enabled: !root.settingsOpen && !root.isPreviewMode

        Behavior on opacity { NumberAnimation { duration: 250; easing.type: Easing.InOutQuad } }
        Behavior on x { NumberAnimation { duration: 250; easing.type: Easing.OutCubic } }

        // 3 CIRCULAR THEME BUTTONS (Waterfall, Ocean, Aurora)
        Row {
            id: themeCirclesRow
            anchors.left: parent.left
            anchors.top: parent.top
            spacing: 24

            Repeater {
                model: RejuvenateController.themes

                Item {
                    id: themeItem
                    width: 90
                    height: 90

                    readonly property bool isSelected: RejuvenateController.selectedThemeIndex === index

                    // Outer glowing selection ring
                    Rectangle {
                        id: outerRing
                        anchors.fill: parent
                        radius: width / 2
                        color: Qt.rgba(0.04, 0.08, 0.16, 0.6)
                        border.color: themeItem.isSelected ? "#00D2FF" : Qt.rgba(1, 1, 1, 0.35)
                        border.width: themeItem.isSelected ? 3.5 : 1.5
                        scale: themeItem.isSelected ? 1.06 : (circleMouse.containsMouse ? 1.02 : 1.0)

                        Behavior on border.color { ColorAnimation { duration: 150 } }
                        Behavior on scale { NumberAnimation { duration: 120 } }

                        // Circular thumbnail image with OpacityMask for flawless circular clipping
                        Item {
                            anchors.centerIn: parent
                            width: parent.width - 12
                            height: parent.height - 12

                            Image {
                                id: thumbImg
                                anchors.fill: parent
                                source: modelData.thumbnailUrl || ""
                                fillMode: Image.PreserveAspectCrop
                                smooth: true
                                asynchronous: true
                                visible: false
                            }

                            Rectangle {
                                id: roundMask
                                anchors.fill: parent
                                radius: width / 2
                                visible: false
                            }

                            MultiEffect {
                                anchors.fill: parent
                                source: thumbImg
                                maskEnabled: true
                                maskSource: roundMask
                            }
                        }
                    }

                    MouseArea {
                        id: circleMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            if (RejuvenateController.selectedThemeIndex !== index) {
                                var oldIdx = RejuvenateController.selectedThemeIndex;
                                var dir = (index > oldIdx) ? 1 : -1;
                                var curTh = RejuvenateController.currentTheme;

                                outgoingImage.source = (curTh && curTh.previewUrl) ? curTh.previewUrl : "";
                                outgoingLayer.x = 0;
                                outgoingLayer.visible = true;

                                swipeAnim.stop();
                                swipeAnim.direction = dir;

                                RejuvenateController.selectTheme(index);
                                bgVideoPlayer.stop();
                                bgVideoPlayer.source = RejuvenateController.videoSource;
                                bgVideoPlayer.play();

                                swipeAnim.restart();
                            }
                        }
                    }
                }
            }
        }

        // THEME TITLE AND BRANDING ROW (Theme Name + APEX Logo + | + Calm Logo)
        Row {
            id: titleRow
            anchors.left: parent.left
            anchors.top: themeCirclesRow.bottom
            anchors.topMargin: 28
            spacing: 16

            Text {
                text: RejuvenateController.themeName
                color: "#FFFFFF"
                font.family: "Inter"
                font.pixelSize: 34
                font.weight: Font.Bold
                anchors.verticalCenter: parent.verticalCenter
            }

            // APEX Official Metallic Logo
            Image {
                source: "qrc:/ApexVision/qml/assets/icons/apex_logo.png"
                height: 24
                fillMode: Image.PreserveAspectFit
                smooth: true
                anchors.verticalCenter: parent.verticalCenter
            }

            // Vertical Separator
            Rectangle {
                width: 1.5
                height: 24
                color: Qt.rgba(1, 1, 1, 0.45)
                anchors.verticalCenter: parent.verticalCenter
            }

            // Calm Official Wordmark Logo (Bigger)
            Image {
                source: "qrc:/ApexVision/qml/assets/icons/calm_wordmark.svg"
                height: 48
                fillMode: Image.PreserveAspectFit
                smooth: true
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        // DESCRIPTION TEXT
        Text {
            id: descText
            anchors.left: parent.left
            anchors.top: titleRow.bottom
            anchors.topMargin: 16
            width: Math.min(parent.width - 40, 780)
            text: {
                var th = RejuvenateController.currentTheme;
                return (th && th.description) ? th.description : "Find peace and get immersed in a meditation to provide immediate relief when overwhelmed or stressed.";
            }
            color: "#E2E8F0"
            font.family: "Inter"
            font.pixelSize: 18
            lineHeight: 1.35
            wrapMode: Text.WordWrap
        }

        // 5 MIN / 10 MIN / PREVIEW BUTTONS (No outer card background, clean borders on 5 & 10 min)
        Row {
            anchors.left: parent.left
            anchors.top: descText.bottom
            anchors.topMargin: 32
            spacing: 16

            // ▶ 5 min Button (Clean border, matching reference)
            Rectangle {
                width: 154
                height: 48
                radius: 12
                color: btn5Mouse.pressed ? Qt.rgba(0, 122, 255, 0.40) :
                       (btn5Mouse.containsMouse ? Qt.rgba(0, 122, 255, 0.22) : Qt.rgba(0, 10, 26, 0.35))
                border.color: btn5Mouse.containsMouse ? "#00D2FF" : "#38BDF8"
                border.width: 1.5

                Behavior on border.color { ColorAnimation { duration: 120 } }
                Behavior on color { ColorAnimation { duration: 120 } }

                Row {
                    anchors.centerIn: parent
                    spacing: 10

                    Text {
                        text: "▶"
                        color: "#FFFFFF"
                        font.pixelSize: 15
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Text {
                        text: "5 min"
                        color: "#FFFFFF"
                        font.family: "Inter"
                        font.pixelSize: 17
                        font.weight: Font.Bold
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                MouseArea {
                    id: btn5Mouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        if (typeof SystemBackend !== "undefined") SystemBackend.playTouchSound();
                        root.pendingDuration = 300;
                        root.showWarningDialog = true;
                    }
                }
            }

            // ▶ 10 min Button (Clean border, matching reference)
            Rectangle {
                width: 154
                height: 48
                radius: 12
                color: btn10Mouse.pressed ? Qt.rgba(0, 122, 255, 0.40) :
                       (btn10Mouse.containsMouse ? Qt.rgba(0, 122, 255, 0.22) : Qt.rgba(0, 10, 26, 0.35))
                border.color: btn10Mouse.containsMouse ? "#00D2FF" : "#38BDF8"
                border.width: 1.5

                Behavior on border.color { ColorAnimation { duration: 120 } }
                Behavior on color { ColorAnimation { duration: 120 } }

                Row {
                    anchors.centerIn: parent
                    spacing: 10

                    Text {
                        text: "▶"
                        color: "#FFFFFF"
                        font.pixelSize: 15
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Text {
                        text: "10 min"
                        color: "#FFFFFF"
                        font.family: "Inter"
                        font.pixelSize: 17
                        font.weight: Font.Bold
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                MouseArea {
                    id: btn10Mouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        if (typeof SystemBackend !== "undefined") SystemBackend.playTouchSound();
                        root.pendingDuration = 600;
                        root.showWarningDialog = true;
                    }
                }
            }

            // Preview Button (Translucent filled, no border)
            Rectangle {
                width: 154
                height: 48
                radius: 12
                color: previewMouse.pressed ? Qt.rgba(255, 255, 255, 0.32) :
                       (previewMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.24) : Qt.rgba(255, 255, 255, 0.16))
                border.width: 0

                Behavior on color { ColorAnimation { duration: 120 } }

                Text {
                    anchors.centerIn: parent
                    text: "Preview"
                    color: "#FFFFFF"
                    font.family: "Inter"
                    font.pixelSize: 16
                    font.weight: Font.DemiBold
                }

                MouseArea {
                    id: previewMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        if (typeof SystemBackend !== "undefined") SystemBackend.playTouchSound();
                        root.previewProgress = 0.0;
                        root.previewActiveIndex = 0;
                        root.isPreviewMode = true;
                        previewAnim.restart();
                    }
                }
            }
        }
    }

    // 4.5 IN-PAGE PREVIEW VIEW (No fullscreen, no prepare phase, matching reference photo)
    Item {
        id: previewView
        anchors.top: headerDividerLine.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        visible: opacity > 0.001
        opacity: root.isPreviewMode ? 1.0 : 0.0
        enabled: root.isPreviewMode

        Behavior on opacity { NumberAnimation { duration: 250; easing.type: Easing.InOutQuad } }

        // Timeline container anchored at the bottom of the page
        Item {
            id: previewTimelineBox
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 80
            width: Math.min(parent.width - 200, 860)
            height: 140

            // Interactive Tooltip / Callout Bubble
            Item {
                id: calloutBubbleContainer
                // Target center X relative to previewTimelineBox
                property real targetCenterX: {
                    var trackW = (previewTimelineBox.width - 16) / 2;
                    if (root.previewActiveIndex < 6) {
                        return root.previewActiveIndex * (trackW - 26) / 5 + 13;
                    } else {
                        var invIdx = root.previewActiveIndex - 6;
                        return (trackW + 16) + invIdx * (trackW - 26) / 5 + 13;
                    }
                }

                x: Math.max(10, Math.min(previewTimelineBox.width - calloutBubble.width - 10, targetCenterX - calloutBubble.width / 2))
                anchors.bottom: previewTimelineRow.top
                anchors.bottomMargin: 14
                width: calloutBubble.width
                height: calloutBubble.height

                Behavior on x { NumberAnimation { duration: 220; easing.type: Easing.OutCubic } }

                // The Bubble Body
                Rectangle {
                    id: calloutBubble
                    width: calloutText.implicitWidth + 36
                    height: 44
                    radius: 10
                    color: "#4361EE" // Vibrant blue matching reference screenshot

                    Text {
                        id: calloutText
                        anchors.centerIn: parent
                        text: {
                            var labels = [
                                "Fully reclined seat",
                                "Steering wheel moves away",
                                "Cabin climate warming",
                                "Seat heating activated",
                                "Wave massage begins",
                                "Digital scent diffused",
                                "Seat returns upright",
                                "Cabin climate cooling",
                                "Ventilated seat airflow",
                                "Invigorating massage pulses",
                                "Revitalizing scent burst",
                                "Energizing lighting & horizon glow"
                            ];
                            return labels[root.previewActiveIndex] || "Fully reclined seat";
                        }
                        color: "#FFFFFF"
                        font.family: "Inter"
                        font.pixelSize: 18
                        font.weight: Font.DemiBold
                    }

                    // Downward-pointing triangle pointer
                    Canvas {
                        id: trianglePointer
                        anchors.top: parent.bottom
                        anchors.topMargin: -1
                        x: Math.max(14, Math.min(parent.width - 24, (calloutBubbleContainer.targetCenterX - calloutBubbleContainer.x) - 7))
                        width: 14
                        height: 9
                        onPaint: {
                            var ctx = getContext("2d");
                            ctx.reset();
                            ctx.fillStyle = "#4361EE";
                            ctx.beginPath();
                            ctx.moveTo(0, 0);
                            ctx.lineTo(14, 0);
                            ctx.lineTo(7, 9);
                            ctx.closePath();
                            ctx.fill();
                        }
                    }

                    Connections {
                        target: root
                        function onPreviewActiveIndexChanged() {
                            trianglePointer.requestPaint();
                        }
                    }
                }
            }

            // Timeline Row with Dual Sections (Relax & Invigorate)
            Item {
                id: previewTimelineRow
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                height: 70

                // LEFT: RELAX SECTION
                Item {
                    id: prevRelaxSection
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: (parent.width - 16) / 2

                    // 6 Icons
                    Item {
                        id: prevRelaxIcons
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.top: parent.top
                        height: 30

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
                                x: index * (prevRelaxIcons.width - width) / 5
                                readonly property bool isActive: root.previewActiveIndex === index

                                Image {
                                    anchors.centerIn: parent
                                    width: 22
                                    height: 22
                                    source: modelData
                                    fillMode: Image.PreserveAspectFit
                                    smooth: true
                                    opacity: parent.isActive ? 1.0 : (iconMouse.containsMouse ? 0.90 : 0.65)
                                    scale: parent.isActive ? 1.18 : (iconMouse.containsMouse ? 1.08 : 1.0)
                                    Behavior on scale { NumberAnimation { duration: 140 } }
                                    Behavior on opacity { NumberAnimation { duration: 140 } }
                                }

                                MouseArea {
                                    id: iconMouse
                                    anchors.fill: parent
                                    anchors.margins: -8
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                        root.previewActiveIndex = index;
                                        root.previewProgress = (index + 0.5) / 12.0;
                                    }
                                }
                            }
                        }
                    }

                    // Track
                    Rectangle {
                        id: prevLeftTrack
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.top: prevRelaxIcons.bottom
                        anchors.topMargin: 8
                        height: 4.5
                        radius: 2.25
                        color: Qt.rgba(1, 1, 1, 0.28)

                        Rectangle {
                            anchors.left: parent.left
                            anchors.top: parent.top
                            anchors.bottom: parent.bottom
                            radius: 2.25
                            color: "#FFFFFF"
                            width: parent.width * Math.min(1.0, Math.max(0.0, root.previewProgress * 2.0))
                            Behavior on width { NumberAnimation { duration: 100 } }
                        }
                    }

                    // Label: "Relax"
                    Text {
                        anchors.left: parent.left
                        anchors.top: prevLeftTrack.bottom
                        anchors.topMargin: 8
                        text: "Relax"
                        color: "#FFFFFF"
                        font.family: "Inter"
                        font.pixelSize: 17
                        font.weight: Font.DemiBold
                    }
                }

                // RIGHT: INVIGORATE SECTION
                Item {
                    id: prevInvigorateSection
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: (parent.width - 16) / 2

                    // 6 Icons
                    Item {
                        id: prevInvigorateIcons
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.top: parent.top
                        height: 30

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
                                x: index * (prevInvigorateIcons.width - width) / 5
                                readonly property bool isActive: root.previewActiveIndex === (index + 6)

                                Image {
                                    anchors.centerIn: parent
                                    width: 22
                                    height: 22
                                    source: modelData
                                    fillMode: Image.PreserveAspectFit
                                    smooth: true
                                    opacity: parent.isActive ? 1.0 : (iconInvMouse.containsMouse ? 0.90 : 0.65)
                                    scale: parent.isActive ? 1.18 : (iconInvMouse.containsMouse ? 1.08 : 1.0)
                                    Behavior on scale { NumberAnimation { duration: 140 } }
                                    Behavior on opacity { NumberAnimation { duration: 140 } }
                                }

                                MouseArea {
                                    id: iconInvMouse
                                    anchors.fill: parent
                                    anchors.margins: -8
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                        root.previewActiveIndex = index + 6;
                                        root.previewProgress = (index + 6.5) / 12.0;
                                    }
                                }
                            }
                        }
                    }

                    // Track
                    Rectangle {
                        id: prevRightTrack
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.top: prevInvigorateIcons.bottom
                        anchors.topMargin: 8
                        height: 4.5
                        radius: 2.25
                        color: Qt.rgba(1, 1, 1, 0.28)

                        Rectangle {
                            anchors.left: parent.left
                            anchors.top: parent.top
                            anchors.bottom: parent.bottom
                            radius: 2.25
                            color: "#FFFFFF"
                            width: parent.width * Math.min(1.0, Math.max(0.0, (root.previewProgress - 0.5) * 2.0))
                            Behavior on width { NumberAnimation { duration: 100 } }
                        }
                    }

                    // Label: "Invigorate"
                    Text {
                        anchors.left: parent.left
                        anchors.top: prevRightTrack.bottom
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
    }

    // 5. REJUVENATE SETTINGS VIEW (Single continuous list with vertical dragger, matching reference photos 1, 2, 3)
    Item {
        id: settingsView
        anchors.top: headerDividerLine.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.topMargin: 10
        anchors.leftMargin: 60
        anchors.rightMargin: 60
        anchors.bottomMargin: 16
        visible: opacity > 0.001
        opacity: root.settingsOpen ? 1.0 : 0.0
        x: root.settingsOpen ? 0 : 36
        enabled: root.settingsOpen

        Behavior on opacity { NumberAnimation { duration: 250; easing.type: Easing.InOutQuad } }
        Behavior on x { NumberAnimation { duration: 250; easing.type: Easing.OutCubic } }

        // =========================================================================
        // LEFT VERTICAL DRAGGER (Matches reference photos 1, 2, 3)
        // =========================================================================
        Item {
            id: draggerContainer
            anchors.left: parent.left
            anchors.leftMargin: 20
            anchors.top: parent.top
            anchors.topMargin: 16
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 16
            width: 16

            // Subtle vertical background track line
            Rectangle {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: 1.5
                color: Qt.rgba(255, 255, 255, 0.12)
            }

            // Draggable Thumb Bar (moves dynamically as user scrolls, or can be dragged)
            Rectangle {
                id: draggerThumb
                anchors.horizontalCenter: parent.horizontalCenter
                width: 3.5
                radius: 1.75
                color: draggerMouse.pressed ? "#00D2FF" : (draggerMouse.containsMouse ? "#FFFFFF" : Qt.rgba(255, 255, 255, 0.65))

                // Height proportional to visible area
                height: Math.max(70, Math.min(160, draggerContainer.height * (settingsFlickable.height / Math.max(settingsFlickable.height + 1, settingsFlickable.contentHeight))))

                // Y position binds directly to flickable contentY
                y: {
                    var maxScroll = Math.max(1, settingsFlickable.contentHeight - settingsFlickable.height);
                    var maxThumbY = Math.max(1, draggerContainer.height - height);
                    return Math.max(0, Math.min(maxThumbY, (settingsFlickable.contentY / maxScroll) * maxThumbY));
                }

                Behavior on color { ColorAnimation { duration: 120 } }

                MouseArea {
                    id: draggerMouse
                    anchors.fill: parent
                    anchors.margins: -12
                    hoverEnabled: true
                    cursorShape: Qt.SizeVerCursor
                    drag.target: draggerThumb
                    drag.axis: Drag.YAxis
                    drag.minimumY: 0
                    drag.maximumY: draggerContainer.height - draggerThumb.height

                    onPositionChanged: {
                        if (drag.active) {
                            var maxThumbY = draggerContainer.height - draggerThumb.height;
                            if (maxThumbY > 0) {
                                var ratio = draggerThumb.y / maxThumbY;
                                var maxScroll = settingsFlickable.contentHeight - settingsFlickable.height;
                                settingsFlickable.contentY = ratio * maxScroll;
                            }
                        }
                    }
                }
            }
        }

        // =========================================================================
        // SINGLE SCROLLABLE SETTINGS LIST (No subcategory tabs, single unified list)
        // =========================================================================
        Flickable {
            id: settingsFlickable
            anchors.left: draggerContainer.right
            anchors.leftMargin: 28
            anchors.right: parent.right
            anchors.rightMargin: 20
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            contentWidth: width
            contentHeight: settingsListCol.height + 40
            clip: true
            boundsBehavior: Flickable.StopAtBounds

            Column {
                id: settingsListCol
                width: parent.width
                spacing: 0

                // =============================================================
                // SECTION 1: SCENT (Matching reference photos 1 & 2)
                // =============================================================
                Item {
                    width: parent.width
                    height: 52

                    Text {
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        text: "Scent"
                        color: "#FFFFFF"
                        font.family: "Inter"
                        font.pixelSize: 22
                        font.weight: Font.DemiBold
                    }

                    Rectangle {
                        anchors.bottom: parent.bottom
                        width: parent.width
                        height: 1
                        color: Qt.rgba(255, 255, 255, 0.10)
                    }
                }

                // Row: Mystic Forest
                Item {
                    width: parent.width
                    height: 58

                    Rectangle {
                        anchors.fill: parent
                        color: rowMfMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.04) : "transparent"
                        radius: 8
                    }

                    Text {
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        text: "Mystic Forest"
                        color: "#FFFFFF"
                        font.family: "Inter"
                        font.pixelSize: 21
                    }

                    Rectangle {
                        anchors.right: parent.right
                        anchors.rightMargin: 12
                        anchors.verticalCenter: parent.verticalCenter
                        width: 26
                        height: 26
                        radius: 13
                        color: "transparent"
                        border.color: root.selectedScent === "Mystic Forest" ? "#8EA8F5" : Qt.rgba(255, 255, 255, 0.40)
                        border.width: 2

                        Rectangle {
                            anchors.centerIn: parent
                            width: 14
                            height: 14
                            radius: 7
                            color: "#8EA8F5"
                            visible: root.selectedScent === "Mystic Forest"
                        }
                    }

                    Rectangle {
                        anchors.bottom: parent.bottom
                        width: parent.width
                        height: 1
                        color: Qt.rgba(255, 255, 255, 0.10)
                    }

                    MouseArea {
                        id: rowMfMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.selectedScent = "Mystic Forest"
                    }
                }

                // Row: Ozonic Azure
                Item {
                    width: parent.width
                    height: 58

                    Rectangle {
                        anchors.fill: parent
                        color: rowOaMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.04) : "transparent"
                        radius: 8
                    }

                    Text {
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        text: "Ozonic Azure"
                        color: "#FFFFFF"
                        font.family: "Inter"
                        font.pixelSize: 21
                    }

                    Rectangle {
                        anchors.right: parent.right
                        anchors.rightMargin: 12
                        anchors.verticalCenter: parent.verticalCenter
                        width: 26
                        height: 26
                        radius: 13
                        color: "transparent"
                        border.color: root.selectedScent === "Ozonic Azure" ? "#8EA8F5" : Qt.rgba(255, 255, 255, 0.40)
                        border.width: 2

                        Rectangle {
                            anchors.centerIn: parent
                            width: 14
                            height: 14
                            radius: 7
                            color: "#8EA8F5"
                            visible: root.selectedScent === "Ozonic Azure"
                        }
                    }

                    Rectangle {
                        anchors.bottom: parent.bottom
                        width: parent.width
                        height: 1
                        color: Qt.rgba(255, 255, 255, 0.10)
                    }

                    MouseArea {
                        id: rowOaMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.selectedScent = "Ozonic Azure"
                    }
                }

                // Row: Violet Cashmere
                Item {
                    width: parent.width
                    height: 58

                    Rectangle {
                        anchors.fill: parent
                        color: rowVcMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.04) : "transparent"
                        radius: 8
                    }

                    Text {
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        text: "Violet Cashmere"
                        color: "#FFFFFF"
                        font.family: "Inter"
                        font.pixelSize: 21
                    }

                    Rectangle {
                        anchors.right: parent.right
                        anchors.rightMargin: 12
                        anchors.verticalCenter: parent.verticalCenter
                        width: 26
                        height: 26
                        radius: 13
                        color: "transparent"
                        border.color: root.selectedScent === "Violet Cashmere" ? "#8EA8F5" : Qt.rgba(255, 255, 255, 0.40)
                        border.width: 2

                        Rectangle {
                            anchors.centerIn: parent
                            width: 14
                            height: 14
                            radius: 7
                            color: "#8EA8F5"
                            visible: root.selectedScent === "Violet Cashmere"
                        }
                    }

                    Rectangle {
                        anchors.bottom: parent.bottom
                        width: parent.width
                        height: 1
                        color: Qt.rgba(255, 255, 255, 0.10)
                    }

                    MouseArea {
                        id: rowVcMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.selectedScent = "Violet Cashmere"
                    }
                }

                // Row: Automatic with theme (Checkbox, matches photo 2)
                Item {
                    width: parent.width
                    height: 58

                    Rectangle {
                        anchors.fill: parent
                        color: rowAutoMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.04) : "transparent"
                        radius: 8
                    }

                    Text {
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        text: "Automatic with theme"
                        color: "#FFFFFF"
                        font.family: "Inter"
                        font.pixelSize: 21
                    }

                    Rectangle {
                        anchors.right: parent.right
                        anchors.rightMargin: 12
                        anchors.verticalCenter: parent.verticalCenter
                        width: 26
                        height: 26
                        radius: 5
                        color: root.autoScentWithTheme ? "#8EA8F5" : "transparent"
                        border.color: root.autoScentWithTheme ? "#8EA8F5" : Qt.rgba(255, 255, 255, 0.40)
                        border.width: 2

                        Text {
                            anchors.centerIn: parent
                            text: "✓"
                            color: "#070A0F"
                            font.family: "Inter"
                            font.pixelSize: 16
                            font.weight: Font.Bold
                            visible: root.autoScentWithTheme
                        }
                    }

                    Rectangle {
                        anchors.bottom: parent.bottom
                        width: parent.width
                        height: 1
                        color: Qt.rgba(255, 255, 255, 0.10)
                    }

                    MouseArea {
                        id: rowAutoMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.autoScentWithTheme = !root.autoScentWithTheme
                    }
                }

                // Row: None (Radio, matches photo 2)
                Item {
                    width: parent.width
                    height: 58

                    Rectangle {
                        anchors.fill: parent
                        color: rowNoneMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.04) : "transparent"
                        radius: 8
                    }

                    Text {
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        text: "None"
                        color: "#FFFFFF"
                        font.family: "Inter"
                        font.pixelSize: 21
                    }

                    Rectangle {
                        anchors.right: parent.right
                        anchors.rightMargin: 12
                        anchors.verticalCenter: parent.verticalCenter
                        width: 26
                        height: 26
                        radius: 13
                        color: "transparent"
                        border.color: root.selectedScent === "None" ? "#8EA8F5" : Qt.rgba(255, 255, 255, 0.40)
                        border.width: 2

                        Rectangle {
                            anchors.centerIn: parent
                            width: 14
                            height: 14
                            radius: 7
                            color: "#8EA8F5"
                            visible: root.selectedScent === "None"
                        }
                    }

                    Rectangle {
                        anchors.bottom: parent.bottom
                        width: parent.width
                        height: 1
                        color: Qt.rgba(255, 255, 255, 0.10)
                    }

                    MouseArea {
                        id: rowNoneMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.selectedScent = "None"
                    }
                }

                // =============================================================
                // SECTION 2: SEAT FEATURES (Matching reference photo 3)
                // =============================================================
                Item {
                    width: parent.width
                    height: 64

                    Text {
                        anchors.left: parent.left
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 14
                        text: "Seat features"
                        color: "#FFFFFF"
                        font.family: "Inter"
                        font.pixelSize: 22
                        font.weight: Font.DemiBold
                    }

                    Rectangle {
                        anchors.bottom: parent.bottom
                        width: parent.width
                        height: 1
                        color: Qt.rgba(255, 255, 255, 0.10)
                    }
                }

                // Row: Driver's seat movement (Toggle switch, matches photo 3)
                Item {
                    width: parent.width
                    height: 58

                    Rectangle {
                        anchors.fill: parent
                        color: rowDsmMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.04) : "transparent"
                        radius: 8
                    }

                    Text {
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        text: "Driver's seat movement"
                        color: "#FFFFFF"
                        font.family: "Inter"
                        font.pixelSize: 21
                    }

                    // Soft Blue Pill Toggle Switch (Matches photo 3)
                    Rectangle {
                        anchors.right: parent.right
                        anchors.rightMargin: 12
                        anchors.verticalCenter: parent.verticalCenter
                        width: 52
                        height: 30
                        radius: 15
                        color: root.driverSeatMovement ? "#8EA8F5" : Qt.rgba(255, 255, 255, 0.18)
                        Behavior on color { ColorAnimation { duration: 160 } }

                        Rectangle {
                            width: 24
                            height: 24
                            radius: 12
                            color: "#FFFFFF"
                            anchors.verticalCenter: parent.verticalCenter
                            x: root.driverSeatMovement ? parent.width - width - 3 : 3
                            Behavior on x { NumberAnimation { duration: 160; easing.type: Easing.OutQuad } }
                        }
                    }

                    Rectangle {
                        anchors.bottom: parent.bottom
                        width: parent.width
                        height: 1
                        color: Qt.rgba(255, 255, 255, 0.10)
                    }

                    MouseArea {
                        id: rowDsmMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.driverSeatMovement = !root.driverSeatMovement
                    }
                }

                // Row: Massage (Toggle switch, matches photo 3)
                Item {
                    width: parent.width
                    height: 58

                    Rectangle {
                        anchors.fill: parent
                        color: rowMsgMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.04) : "transparent"
                        radius: 8
                    }

                    Text {
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        text: "Massage"
                        color: "#FFFFFF"
                        font.family: "Inter"
                        font.pixelSize: 21
                    }

                    Rectangle {
                        anchors.right: parent.right
                        anchors.rightMargin: 12
                        anchors.verticalCenter: parent.verticalCenter
                        width: 52
                        height: 30
                        radius: 15
                        color: root.seatMassage ? "#8EA8F5" : Qt.rgba(255, 255, 255, 0.18)
                        Behavior on color { ColorAnimation { duration: 160 } }

                        Rectangle {
                            width: 24
                            height: 24
                            radius: 12
                            color: "#FFFFFF"
                            anchors.verticalCenter: parent.verticalCenter
                            x: root.seatMassage ? parent.width - width - 3 : 3
                            Behavior on x { NumberAnimation { duration: 160; easing.type: Easing.OutQuad } }
                        }
                    }

                    Rectangle {
                        anchors.bottom: parent.bottom
                        width: parent.width
                        height: 1
                        color: Qt.rgba(255, 255, 255, 0.10)
                    }

                    MouseArea {
                        id: rowMsgMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.seatMassage = !root.seatMassage
                    }
                }

                // Row: Heated seats (Toggle switch, matches photo 3)
                Item {
                    width: parent.width
                    height: 58

                    Rectangle {
                        anchors.fill: parent
                        color: rowHeatMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.04) : "transparent"
                        radius: 8
                    }

                    Text {
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        text: "Heated seats"
                        color: "#FFFFFF"
                        font.family: "Inter"
                        font.pixelSize: 21
                    }

                    Rectangle {
                        anchors.right: parent.right
                        anchors.rightMargin: 12
                        anchors.verticalCenter: parent.verticalCenter
                        width: 52
                        height: 30
                        radius: 15
                        color: root.seatHeated ? "#8EA8F5" : Qt.rgba(255, 255, 255, 0.18)
                        Behavior on color { ColorAnimation { duration: 160 } }

                        Rectangle {
                            width: 24
                            height: 24
                            radius: 12
                            color: "#FFFFFF"
                            anchors.verticalCenter: parent.verticalCenter
                            x: root.seatHeated ? parent.width - width - 3 : 3
                            Behavior on x { NumberAnimation { duration: 160; easing.type: Easing.OutQuad } }
                        }
                    }

                    Rectangle {
                        anchors.bottom: parent.bottom
                        width: parent.width
                        height: 1
                        color: Qt.rgba(255, 255, 255, 0.10)
                    }

                    MouseArea {
                        id: rowHeatMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.seatHeated = !root.seatHeated
                    }
                }

                // Row: Ventilated seats (Toggle switch, matches photo 3)
                Item {
                    width: parent.width
                    height: 58

                    Rectangle {
                        anchors.fill: parent
                        color: rowVentMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.04) : "transparent"
                        radius: 8
                    }

                    Text {
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        text: "Ventilated seats"
                        color: "#FFFFFF"
                        font.family: "Inter"
                        font.pixelSize: 21
                    }

                    Rectangle {
                        anchors.right: parent.right
                        anchors.rightMargin: 12
                        anchors.verticalCenter: parent.verticalCenter
                        width: 52
                        height: 30
                        radius: 15
                        color: root.seatVentilated ? "#8EA8F5" : Qt.rgba(255, 255, 255, 0.18)
                        Behavior on color { ColorAnimation { duration: 160 } }

                        Rectangle {
                            width: 24
                            height: 24
                            radius: 12
                            color: "#FFFFFF"
                            anchors.verticalCenter: parent.verticalCenter
                            x: root.seatVentilated ? parent.width - width - 3 : 3
                            Behavior on x { NumberAnimation { duration: 160; easing.type: Easing.OutQuad } }
                        }
                    }

                    Rectangle {
                        anchors.bottom: parent.bottom
                        width: parent.width
                        height: 1
                        color: Qt.rgba(255, 255, 255, 0.10)
                    }

                    MouseArea {
                        id: rowVentMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.seatVentilated = !root.seatVentilated
                    }
                }

                // =============================================================
                // SECTION 3: LIGHTING & ATMOSPHERE
                // =============================================================
                Item {
                    width: parent.width
                    height: 64

                    Text {
                        anchors.left: parent.left
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 14
                        text: "Lighting & Atmosphere"
                        color: "#FFFFFF"
                        font.family: "Inter"
                        font.pixelSize: 22
                        font.weight: Font.DemiBold
                    }

                    Rectangle {
                        anchors.bottom: parent.bottom
                        width: parent.width
                        height: 1
                        color: Qt.rgba(255, 255, 255, 0.10)
                    }
                }

                // Row: Ambient illumination sync
                Item {
                    width: parent.width
                    height: 58

                    Rectangle {
                        anchors.fill: parent
                        color: rowAmbMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.04) : "transparent"
                        radius: 8
                    }

                    Text {
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        text: "Ambient lighting synchronization"
                        color: "#FFFFFF"
                        font.family: "Inter"
                        font.pixelSize: 21
                    }

                    Rectangle {
                        anchors.right: parent.right
                        anchors.rightMargin: 12
                        anchors.verticalCenter: parent.verticalCenter
                        width: 52
                        height: 30
                        radius: 15
                        color: root.ambientSync ? "#8EA8F5" : Qt.rgba(255, 255, 255, 0.18)
                        Behavior on color { ColorAnimation { duration: 160 } }

                        Rectangle {
                            width: 24
                            height: 24
                            radius: 12
                            color: "#FFFFFF"
                            anchors.verticalCenter: parent.verticalCenter
                            x: root.ambientSync ? parent.width - width - 3 : 3
                            Behavior on x { NumberAnimation { duration: 160; easing.type: Easing.OutQuad } }
                        }
                    }

                    Rectangle {
                        anchors.bottom: parent.bottom
                        width: parent.width
                        height: 1
                        color: Qt.rgba(255, 255, 255, 0.10)
                    }

                    MouseArea {
                        id: rowAmbMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.ambientSync = !root.ambientSync
                    }
                }

                // Row: Dynamic horizon dimming
                Item {
                    width: parent.width
                    height: 58

                    Rectangle {
                        anchors.fill: parent
                        color: rowDimMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.04) : "transparent"
                        radius: 8
                    }

                    Text {
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        text: "Dynamic horizon dimming"
                        color: "#FFFFFF"
                        font.family: "Inter"
                        font.pixelSize: 21
                    }

                    Rectangle {
                        anchors.right: parent.right
                        anchors.rightMargin: 12
                        anchors.verticalCenter: parent.verticalCenter
                        width: 52
                        height: 30
                        radius: 15
                        color: root.cabinDimming ? "#8EA8F5" : Qt.rgba(255, 255, 255, 0.18)
                        Behavior on color { ColorAnimation { duration: 160 } }

                        Rectangle {
                            width: 24
                            height: 24
                            radius: 12
                            color: "#FFFFFF"
                            anchors.verticalCenter: parent.verticalCenter
                            x: root.cabinDimming ? parent.width - width - 3 : 3
                            Behavior on x { NumberAnimation { duration: 160; easing.type: Easing.OutQuad } }
                        }
                    }

                    Rectangle {
                        anchors.bottom: parent.bottom
                        width: parent.width
                        height: 1
                        color: Qt.rgba(255, 255, 255, 0.10)
                    }

                    MouseArea {
                        id: rowDimMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.cabinDimming = !root.cabinDimming
                    }
                }

                // =============================================================
                // SECTION 4: AUDIO
                // =============================================================
                Item {
                    width: parent.width
                    height: 64

                    Text {
                        anchors.left: parent.left
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 14
                        text: "Audio"
                        color: "#FFFFFF"
                        font.family: "Inter"
                        font.pixelSize: 22
                        font.weight: Font.DemiBold
                    }

                    Rectangle {
                        anchors.bottom: parent.bottom
                        width: parent.width
                        height: 1
                        color: Qt.rgba(255, 255, 255, 0.10)
                    }
                }

                // Row: Calm voice guidance
                Item {
                    width: parent.width
                    height: 58

                    Rectangle {
                        anchors.fill: parent
                        color: rowVgMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.04) : "transparent"
                        radius: 8
                    }

                    Text {
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        text: "Calm voice guidance"
                        color: "#FFFFFF"
                        font.family: "Inter"
                        font.pixelSize: 21
                    }

                    Rectangle {
                        anchors.right: parent.right
                        anchors.rightMargin: 12
                        anchors.verticalCenter: parent.verticalCenter
                        width: 52
                        height: 30
                        radius: 15
                        color: root.voiceGuidance ? "#8EA8F5" : Qt.rgba(255, 255, 255, 0.18)
                        Behavior on color { ColorAnimation { duration: 160 } }

                        Rectangle {
                            width: 24
                            height: 24
                            radius: 12
                            color: "#FFFFFF"
                            anchors.verticalCenter: parent.verticalCenter
                            x: root.voiceGuidance ? parent.width - width - 3 : 3
                            Behavior on x { NumberAnimation { duration: 160; easing.type: Easing.OutQuad } }
                        }
                    }

                    Rectangle {
                        anchors.bottom: parent.bottom
                        width: parent.width
                        height: 1
                        color: Qt.rgba(255, 255, 255, 0.10)
                    }

                    MouseArea {
                        id: rowVgMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.voiceGuidance = !root.voiceGuidance
                    }
                }

                // Row: Spatial sound immersion
                Item {
                    width: parent.width
                    height: 58

                    Rectangle {
                        anchors.fill: parent
                        color: rowSpaMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.04) : "transparent"
                        radius: 8
                    }

                    Text {
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        text: "Spatial sound immersion"
                        color: "#FFFFFF"
                        font.family: "Inter"
                        font.pixelSize: 21
                    }

                    Rectangle {
                        anchors.right: parent.right
                        anchors.rightMargin: 12
                        anchors.verticalCenter: parent.verticalCenter
                        width: 52
                        height: 30
                        radius: 15
                        color: root.spatialAudio ? "#8EA8F5" : Qt.rgba(255, 255, 255, 0.18)
                        Behavior on color { ColorAnimation { duration: 160 } }

                        Rectangle {
                            width: 24
                            height: 24
                            radius: 12
                            color: "#FFFFFF"
                            anchors.verticalCenter: parent.verticalCenter
                            x: root.spatialAudio ? parent.width - width - 3 : 3
                            Behavior on x { NumberAnimation { duration: 160; easing.type: Easing.OutQuad } }
                        }
                    }

                    Rectangle {
                        anchors.bottom: parent.bottom
                        width: parent.width
                        height: 1
                        color: Qt.rgba(255, 255, 255, 0.10)
                    }

                    MouseArea {
                        id: rowSpaMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.spatialAudio = !root.spatialAudio
                    }
                }
            }
        }
    }

    // 6. WARNING MODAL POPUP DIALOG (Matching Photo 1)
    Item {
        id: warningModal
        anchors.fill: parent
        z: 100
        visible: root.showWarningDialog

        // Dim backdrop (subtle dimming, keeping background visible as in photo)
        Rectangle {
            anchors.fill: parent
            color: Qt.rgba(0.0, 0.0, 0.0, 0.45)

            MouseArea {
                anchors.fill: parent
                onClicked: root.showWarningDialog = false
            }
        }

        // Modal Card: Authentic OEM Navy Blue Card scaled proportionally to screen
        Rectangle {
            anchors.centerIn: parent
            width: 720
            height: 310
            radius: 22
            color: "#213466" // Matching exact photo navy blue
            border.color: Qt.rgba(255, 255, 255, 0.14)
            border.width: 1.2

            Column {
                anchors.fill: parent
                anchors.margins: 34
                spacing: 18

                Text {
                    text: "Warning"
                    color: "#FFFFFF"
                    font.family: "Inter"
                    font.pixelSize: 32
                    font.weight: Font.Bold
                }

                Text {
                    width: parent.width
                    text: "While Rejuvenate is active your engine runs continuously. Only use the vehicle outside."
                    color: "#FFFFFF"
                    font.family: "Inter"
                    font.pixelSize: 22
                    font.weight: Font.DemiBold
                    lineHeight: 1.35
                    wrapMode: Text.WordWrap
                }

                Item { width: 1; height: 8 }

                // Buttons Row: Left-aligned [ Cancel ] [ Continue ], matching photo
                Row {
                    spacing: 16

                    // Cancel Button
                    Rectangle {
                        width: 154
                        height: 52
                        radius: 12
                        color: cancelMouse.pressed ? "#3C4E7C" :
                               (cancelMouse.containsMouse ? "#5E75AF" : "#51669A")

                        Behavior on color { ColorAnimation { duration: 100 } }

                        Text {
                            anchors.centerIn: parent
                            text: "Cancel"
                            color: "#FFFFFF"
                            font.family: "Inter"
                            font.pixelSize: 19
                            font.weight: Font.DemiBold
                        }

                        MouseArea {
                            id: cancelMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                if (typeof SystemBackend !== "undefined") SystemBackend.playTouchSound();
                                root.showWarningDialog = false;
                            }
                        }
                    }

                    // Continue Button
                    Rectangle {
                        width: 160
                        height: 52
                        radius: 12
                        color: continueMouse.pressed ? "#3C4E7C" :
                               (continueMouse.containsMouse ? "#5E75AF" : "#51669A")

                        Behavior on color { ColorAnimation { duration: 100 } }

                        Text {
                            anchors.centerIn: parent
                            text: "Continue"
                            color: "#FFFFFF"
                            font.family: "Inter"
                            font.pixelSize: 19
                            font.weight: Font.DemiBold
                        }

                        MouseArea {
                            id: continueMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                if (typeof SystemBackend !== "undefined") SystemBackend.playTouchSound();
                                root.showWarningDialog = false;
                                if (typeof MediaBackend !== "undefined") {
                                    MediaBackend.setIsPlaying(false);
                                    MediaBackend.pausePlayback();
                                }
                                RejuvenateController.startSession(root.pendingDuration);
                            }
                        }
                    }
                }
            }
        }
    }
}
