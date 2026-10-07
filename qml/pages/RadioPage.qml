/**
 * ==============================================================================
 * Project: Apex VISION IVI - Digital Cockpit & Infotainment System
 * File: RadioPage.qml
 * Author / Developer: Sk Rehan Ahamed
 * License: MIT
 * ==============================================================================
 */

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import QtMultimedia
import ApexVision
import ".."

Item {
    id: root

    signal openSettingsRequested()
    signal openAppsRequested()
    signal openBluetoothRequested()
    signal backRequested()

    SoundEffect {
        id: presetChimeSound
        source: "qrc:/ApexVision/qml/assets/sounds/preset_chime.wav"
        volume: 1.0
    }

    function formatTime(sec) {
        if (!sec || sec < 0) return "0:00";
        var m = Math.floor(sec / 60);
        var s = Math.floor(sec % 60);
        return m + ":" + (s < 10 ? "0" : "") + s;
    }

    Component.onCompleted: {
        if (MediaBackend.source === "AM" && MediaBackend.isPlaying && !MediaBackend.isAmAudioPlaying) {
            MediaBackend.startAmPlayback();
        }
        if (sxmPresetListView) sxmPresetListView.updatePaging();
        if (channelsFullListView) channelsFullListView.updatePaging();
    }

    Connections {
        target: MediaBackend
        function onSxmChannelChanged() {
            if (sxmPresetListView) sxmPresetListView.updatePaging();
            if (channelsFullListView) channelsFullListView.updatePaging();
        }
        function onActiveSxmPresetIndexChanged() {
            if (sxmPresetListView) sxmPresetListView.updatePaging();
        }
        function onCurrentSxmChannelIndexChanged() {
            if (channelsFullListView) channelsFullListView.updatePaging();
        }
    }

    // -------------------------------------------------------------------------
    // BACKGROUND GRADIENT (Matches OEM Cockpit Atmosphere)
    // -------------------------------------------------------------------------
    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: Qt.rgba(7/255, 14/255, 30/255, 0.40) }
            GradientStop { position: 0.5; color: Qt.rgba(9/255, 20/255, 42/255, 0.50) }
            GradientStop { position: 1.0; color: Qt.rgba(5/255, 12/255, 26/255, 0.70) }
        }
    }

    // -------------------------------------------------------------------------
    // FULL SCREEN BLURRED / DIMMED BACKDROP FOR SOURCE MODAL (Matches user requirement)
    // -------------------------------------------------------------------------
    Rectangle {
        id: sourceModalBackdrop
        anchors.fill: parent
        color: Qt.rgba(3/255, 7/255, 18/255, 0.74)
        visible: sourceDropdownMenu.visible
        z: 90

        MouseArea {
            anchors.fill: parent
            onClicked: {
                sourceDropdownMenu.visible = false;
            }
        }
    }

    // -------------------------------------------------------------------------
    // TOP BAR: Source Selector Pill (Left) | Settings Sliders Button (Right)
    // -------------------------------------------------------------------------
    Item {
        id: topBar
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 72
        z: 30

        // Signature IVI Circular "←" Back Button (Matching NewsPage, VideoPage, ManualPage)
        Item {
            id: topBackBtn
            width: 44
            height: 44
            anchors.left: parent.left
            anchors.leftMargin: 24
            anchors.verticalCenter: parent.verticalCenter

            Text {
                anchors.centerIn: parent
                text: "←"
                color: topBackMouse.pressed ? "#00D2FF" : (topBackMouse.containsMouse ? "#FFFFFF" : "#E2E8F0")
                font.family: "Inter"
                font.pixelSize: 28
                font.weight: Font.DemiBold
                scale: topBackMouse.pressed ? 0.90 : 1.0
                Behavior on scale { NumberAnimation { duration: 80 } }
                Behavior on color { ColorAnimation { duration: 100 } }
            }

            MouseArea {
                id: topBackMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: root.backRequested()
            }
        }

        // Source Dropdown Pill (Matches Screenshot 1 "(•) OrbitXM ▼")
        Rectangle {
            id: sourcePill
            anchors.left: topBackBtn.right
            anchors.leftMargin: 16
            anchors.verticalCenter: parent.verticalCenter
            width: sourceRow.width + 34
            height: 48
            radius: 24
            color: sourceMouse.pressed ? Qt.rgba(215/255, 238/255, 255/255, 0.28) :
                   (sourceMouse.containsMouse ? Qt.rgba(225/255, 242/255, 255/255, 0.22) : Qt.rgba(20/255, 40/255, 80/255, 0.65))
            border.color: Qt.rgba(255, 255, 255, 0.35)
            border.width: 1

            scale: sourceMouse.pressed ? 0.95 : 1.0
            Behavior on scale { NumberAnimation { duration: 100 } }

            Row {
                id: sourceRow
                anchors.centerIn: parent
                spacing: 10

                // Circular Badge with Icon (when not SXM)
                Rectangle {
                    width: 28
                    height: 28
                    radius: 14
                    color: "#1E88E5"
                    anchors.verticalCenter: parent.verticalCenter
                    visible: !MediaBackend.isSxm

                    Image {
                        anchors.centerIn: parent
                        width: 16
                        height: 16
                        source: MediaBackend.source === "AM" ? "qrc:/ApexVision/qml/assets/icons/radio_am.svg" : "qrc:/ApexVision/qml/assets/icons/radio_fm.svg"
                        fillMode: Image.PreserveAspectFit
                        smooth: true
                    }
                }

                // Pure OrbitXM Favicon Logo from image copy 4.png
                Image {
                    visible: MediaBackend.isSxm
                    width: 30
                    height: 30
                    anchors.verticalCenter: parent.verticalCenter
                    source: "qrc:/ApexVision/qml/assets/radio_logos/orbitxm_logo.png"
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                    mipmap: true
                }

                Text {
                    visible: MediaBackend.isSxm
                    text: "OrbitXM"
                    color: "#FFFFFF"
                    font.family: "Inter"
                    font.pixelSize: 18
                    font.weight: Font.Bold
                    anchors.verticalCenter: parent.verticalCenter
                }

                Text {
                    visible: !MediaBackend.isSxm
                    text: MediaBackend.source
                    color: "#FFFFFF"
                    font.family: "Inter"
                    font.pixelSize: 19
                    font.weight: Font.DemiBold
                    anchors.verticalCenter: parent.verticalCenter
                }

                Text {
                    text: "▼"
                    color: "#93C5FD"
                    font.family: "Inter"
                    font.pixelSize: 11
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            MouseArea {
                id: sourceMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    sourceDropdownMenu.visible = !sourceDropdownMenu.visible;
                }
            }
        }

        // Right Action Buttons: Profile Icon + Settings Sliders + Bell + Signal + Location (matches reference video frames 015/065)
        Row {
            anchors.right: parent.right
            anchors.rightMargin: 40
            anchors.verticalCenter: parent.verticalCenter
            spacing: 16

            // Profile Button (only in SXM / OrbitXM view)
            Item {
                id: profileBtn
                width: 40
                height: 40
                visible: MediaBackend.isSxm

                Rectangle {
                    anchors.fill: parent
                    radius: 20
                    color: profileMouse.pressed ? Qt.rgba(255, 255, 255, 0.16) :
                           (profileMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.08) : "transparent")
                }

                Image {
                    anchors.centerIn: parent
                    width: 22
                    height: 22
                    source: "qrc:/ApexVision/qml/assets/icons/setting_profile_white.png"
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                }

                MouseArea {
                    id: profileMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        driverProfileModal.visible = !driverProfileModal.visible;
                    }
                }
            }

            // Settings / Equalizer Sliders Button
            Item {
                id: dspBtn
                width: 40
                height: 40

                Rectangle {
                    anchors.fill: parent
                    radius: 20
                    color: settingsMouse.pressed ? Qt.rgba(255, 255, 255, 0.16) :
                           (settingsMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.08) : "transparent")
                    scale: settingsMouse.pressed ? 0.92 : 1.0
                    Behavior on scale { NumberAnimation { duration: 100 } }
                }

                Image {
                    anchors.centerIn: parent
                    width: 22
                    height: 22
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
                        audioDspModal.visible = !audioDspModal.visible;
                    }
                }
            }
        }
    }

    // =========================================================================
    // SOURCE MODAL POPUP (Centered in the MIDDLE with screen blur/dim as requested)
    // Options: OrbitXM, Apple CarPlay, FM, AM, USB DISK, Bluetooth Audio
    // =========================================================================
    Rectangle {
        id: sourceDropdownMenu
        objectName: "sourceDropdownMenu"
        anchors.centerIn: parent
        width: 360
        height: sourceListCol.implicitHeight + 24
        radius: 20
        color: Qt.rgba(11/255, 18/255, 34/255, 0.98)
        border.color: Qt.rgba(255, 255, 255, 0.20)
        border.width: 1.5
        visible: false
        z: 95

        readonly property var availableSources: {
            var list = [
                { name: "OrbitXM", sourceKey: "OrbitXM", icon: "qrc:/ApexVision/qml/assets/radio_logos/orbitxm_logo.png" },
                { name: "FM", sourceKey: "FM", icon: "qrc:/ApexVision/qml/assets/icons/radio_fm.svg" },
                { name: "AM", sourceKey: "AM", icon: "qrc:/ApexVision/qml/assets/icons/radio_am.svg" }
            ];
            if (typeof PhoneBackend !== "undefined" && PhoneBackend.isConnected) {
                list.push({ name: "Apple CarPlay", sourceKey: "CarPlay", icon: "qrc:/ApexVision/qml/assets/icons/app_carplay.svg" });
                list.push({ name: "Bluetooth Audio", sourceKey: "Bluetooth", icon: "qrc:/ApexVision/qml/assets/icons/bluetooth.svg" });
            }
            return list;
        }

        Column {
            id: sourceListCol
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 12
            spacing: 2

            Repeater {
                model: sourceDropdownMenu.availableSources

                Item {
                    width: sourceListCol.width
                    height: 60

                    // Row background hover/active
                    Rectangle {
                        anchors.fill: parent
                        radius: 12
                        color: itemMouse.pressed ? Qt.rgba(255, 255, 255, 0.16) :
                               (itemMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.08) :
                               (MediaBackend.source === modelData.sourceKey ? Qt.rgba(30/255, 136/255, 229/255, 0.25) : "transparent"))
                        Behavior on color { ColorAnimation { duration: 120 } }
                    }

                    // Content row: circular blue badge + title
                    Row {
                        anchors.left: parent.left
                        anchors.leftMargin: 16
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 18

                        // Circular Badge with Icon (OrbitXM renders directly without redundant outer background)
                        Rectangle {
                            width: 40
                            height: 40
                            radius: 20
                            color: modelData.sourceKey === "OrbitXM" ? "transparent" : "#1E88E5"
                            anchors.verticalCenter: parent.verticalCenter

                            Image {
                                anchors.centerIn: parent
                                width: modelData.sourceKey === "OrbitXM" ? 40 : 24
                                height: modelData.sourceKey === "OrbitXM" ? 40 : 24
                                source: modelData.icon
                                fillMode: Image.PreserveAspectFit
                                smooth: true
                                mipmap: true
                            }
                        }

                        // Bigger Text Label
                        Text {
                            text: modelData.name
                            color: "#FFFFFF"
                            font.family: "Inter"
                            font.pixelSize: 18
                            font.weight: MediaBackend.source === modelData.sourceKey ? Font.Bold : Font.Medium
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    // Subtle Divider Line (except last item)
                    Rectangle {
                        anchors.bottom: parent.bottom
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.leftMargin: 16
                        anchors.rightMargin: 16
                        height: 1
                        color: Qt.rgba(255, 255, 255, 0.08)
                        visible: index < 5
                    }

                    MouseArea {
                        id: itemMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            sourceDropdownMenu.visible = false;
                            MediaBackend.setSource(modelData.sourceKey);
                        }
                    }
                }
            }
        }
    }

    // -------------------------------------------------------------------------
    // MAIN CONTENT AREA: Radio Controls (Left) | Coral Music Note Visual (Right)
    // Text and icons enlarged to fill the cockpit space beautifully
    // -------------------------------------------------------------------------
    Item {
        id: mainContent
        anchors.top: topBar.bottom
        anchors.bottom: presetBar.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: 40
        anchors.rightMargin: 40
        anchors.topMargin: 10
        anchors.bottomMargin: 10

        // LEFT COLUMN: Station Frequency, Info, and Controls
        Item {
            id: leftCol
            anchors.left: parent.left
            anchors.right: rightCol.left
            anchors.rightMargin: 32
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            visible: !MediaBackend.isSxm && MediaBackend.source !== "Bluetooth"

            Column {
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                spacing: 20

                // Big Frequency Number & Unit (e.g. 530 kHz or 87.9 MHz)
                Row {
                    spacing: 12
                    Text {
                        id: bigFreqText
                        text: MediaBackend.source === "AM" ? MediaBackend.amFrequency : MediaBackend.frequency
                        color: "#FFFFFF"
                        font.family: "Inter"
                        font.pixelSize: 96
                        font.weight: Font.DemiBold
                        renderType: Text.NativeRendering
                    }

                    Text {
                        text: MediaBackend.source === "AM" ? "kHz" : "MHz"
                        color: "#94A3B8"
                        font.family: "Inter"
                        font.pixelSize: 26
                        font.weight: Font.Medium
                        anchors.baseline: bigFreqText.baseline
                    }
                }

                // Station Name & City (NO mention of "Live Broadcast" as requested)
                Column {
                    spacing: 6
                    Text {
                        text: MediaBackend.source === "AM" ? MediaBackend.amStationName : MediaBackend.station
                        color: "#E2E8F0"
                        font.family: "Inter"
                        font.pixelSize: 32
                        font.weight: Font.DemiBold
                    }

                    Text {
                        text: MediaBackend.source === "AM" ? MediaBackend.amStationCity : MediaBackend.trackTitle
                        color: "#94A3B8"
                        font.family: "Inter"
                        font.pixelSize: 18
                        font.weight: Font.Medium
                    }
                }

                Item { width: 1; height: 10 }

                // Transport Controls: |<<   ▶/❚❚   >>|   ::: Keypad   ☆+ Save as preset
                Row {
                    spacing: 24
                    anchors.left: parent.left

                    // Previous Station Button |<<
                    Item {
                        width: 56
                        height: 56
                        anchors.verticalCenter: parent.verticalCenter

                        Rectangle {
                            anchors.fill: parent
                            radius: 28
                            color: prevMouse.pressed ? Qt.rgba(255, 255, 255, 0.16) :
                                   (prevMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.08) : "transparent")
                            scale: prevMouse.pressed ? 0.9 : 1.0
                            Behavior on scale { NumberAnimation { duration: 80 } }
                        }

                        Image {
                            anchors.centerIn: parent
                            width: 30
                            height: 30
                            source: "qrc:/ApexVision/qml/assets/icons/skip_prev.svg"
                            fillMode: Image.PreserveAspectFit
                            smooth: true
                        }

                        MouseArea {
                            id: prevMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: MediaBackend.prevRadioStation()
                        }
                    }

                    // Primary Play / Pause Button ▶ / ❚❚ (Identical sleek style to OrbitXM)
                    Item {
                        width: 56
                        height: 56
                        anchors.verticalCenter: parent.verticalCenter

                        Rectangle {
                            anchors.fill: parent
                            radius: 28
                            color: playMouse.pressed ? Qt.rgba(255, 255, 255, 0.20) :
                                   (playMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.10) : "transparent")
                            scale: playMouse.pressed ? 0.92 : (playMouse.containsMouse ? 1.05 : 1.0)
                            Behavior on scale { NumberAnimation { duration: 80 } }
                        }

                        Image {
                            anchors.centerIn: parent
                            anchors.horizontalCenterOffset: MediaBackend.isPlaying ? 0 : 2
                            width: 28
                            height: 28
                            source: MediaBackend.isPlaying ?
                                    "qrc:/ApexVision/qml/assets/icons/pause.svg" :
                                    "qrc:/ApexVision/qml/assets/icons/play.svg"
                            fillMode: Image.PreserveAspectFit
                            smooth: true
                        }

                        MouseArea {
                            id: playMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: MediaBackend.togglePlay()
                        }
                    }

                    // Next Station Button >>|
                    Item {
                        width: 56
                        height: 56
                        anchors.verticalCenter: parent.verticalCenter

                        Rectangle {
                            anchors.fill: parent
                            radius: 28
                            color: nextMouse.pressed ? Qt.rgba(255, 255, 255, 0.16) :
                                   (nextMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.08) : "transparent")
                            scale: nextMouse.pressed ? 0.9 : 1.0
                            Behavior on scale { NumberAnimation { duration: 80 } }
                        }

                        Image {
                            anchors.centerIn: parent
                            width: 30
                            height: 30
                            source: "qrc:/ApexVision/qml/assets/icons/skip_next.svg"
                            fillMode: Image.PreserveAspectFit
                            smooth: true
                        }

                        MouseArea {
                            id: nextMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: MediaBackend.nextRadioStation()
                        }
                    }

                    // Direct Frequency Keypad Button :::
                    Item {
                        width: 56
                        height: 56
                        anchors.verticalCenter: parent.verticalCenter

                        Rectangle {
                            anchors.fill: parent
                            radius: 28
                            color: keypadMouse.pressed ? Qt.rgba(255, 255, 255, 0.16) :
                                   (keypadMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.08) : "transparent")
                            scale: keypadMouse.pressed ? 0.9 : 1.0
                            Behavior on scale { NumberAnimation { duration: 80 } }
                        }

                        Image {
                            anchors.centerIn: parent
                            width: 28
                            height: 28
                            source: "qrc:/ApexVision/qml/assets/icons/radio_keypad.svg"
                            fillMode: Image.PreserveAspectFit
                            smooth: true
                        }

                        MouseArea {
                            id: keypadMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: keypadModal.openKeypad()
                        }
                    }

                    // "Save as preset" Button:
                    // If saved/pressed: ONLY pure white glowing star icon (no text)
                    // If not saved: Star with + icon + "Save as preset" text
                    Item {
                        height: 56
                        width: MediaBackend.isCurrentRadioPreset ? 56 : (savePresetRow.width + 24)
                        anchors.verticalCenter: parent.verticalCenter

                        Rectangle {
                            anchors.fill: parent
                            radius: 28
                            color: savePresetMouse.pressed ? Qt.rgba(255, 255, 255, 0.16) :
                                   (savePresetMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.08) : "transparent")
                            scale: savePresetMouse.pressed ? 0.95 : 1.0
                            Behavior on scale { NumberAnimation { duration: 80 } }
                        }

                        Row {
                            id: savePresetRow
                            anchors.centerIn: parent
                            spacing: 10

                            Image {
                                width: MediaBackend.isCurrentRadioPreset ? 34 : 28
                                height: MediaBackend.isCurrentRadioPreset ? 34 : 28
                                source: MediaBackend.isCurrentRadioPreset ?
                                        "qrc:/ApexVision/qml/assets/icons/star_glow_filled.svg" :
                                        "qrc:/ApexVision/qml/assets/icons/preset_star_add.svg"
                                fillMode: Image.PreserveAspectFit
                                smooth: true
                                anchors.verticalCenter: parent.verticalCenter
                            }

                            Text {
                                text: "Save as preset"
                                color: "#E2E8F0"
                                font.family: "Inter"
                                font.pixelSize: 18
                                font.weight: Font.Medium
                                anchors.verticalCenter: parent.verticalCenter
                                visible: !MediaBackend.isCurrentRadioPreset
                            }
                        }

                        MouseArea {
                            id: savePresetMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                MediaBackend.saveCurrentAsPreset();
                                if (MediaBackend.isCurrentRadioPreset) {
                                    var currFreqStr = MediaBackend.source === "AM" ? (MediaBackend.amFrequency + " kHz") : (MediaBackend.frequency + " MHz");
                                    saveNotification.showToast("Preset saved: " + currFreqStr);
                                } else {
                                    saveNotification.showToast("Preset removed");
                                }
                            }
                        }
                    }
                }
            }
        }

        // RIGHT COLUMN: Music Note Visual Card (Enlarged, extreme right)
        Item {
            id: rightCol
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: 290
            visible: !MediaBackend.isSxm && MediaBackend.source !== "Bluetooth"

            Rectangle {
                id: musicCard
                anchors.right: parent.right
                anchors.rightMargin: 16
                anchors.verticalCenter: parent.verticalCenter
                width: 270
                height: 270
                radius: 32
                gradient: Gradient {
                    GradientStop { position: 0.0; color: Qt.rgba(20/255, 45/255, 95/255, 0.55) }
                    GradientStop { position: 1.0; color: Qt.rgba(10/255, 25/255, 60/255, 0.75) }
                }
                border.color: Qt.rgba(255, 255, 255, 0.20)
                border.width: 1.5

                // Coral Double Note Vector Icon (ONLY icon, extreme right card)
                Image {
                    id: coralNoteIcon
                    anchors.centerIn: parent
                    width: 135
                    height: 135
                    source: "qrc:/ApexVision/qml/assets/icons/music_note_coral.svg"
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                    mipmap: true
                }
            }
        }

        // =====================================================================
        // BLUETOOTH AUDIO VIEW (Matching MobileDeviceConnectionPage & PhonePage)
        // =====================================================================
        Item {
            id: btAudioContent
            anchors.fill: parent
            visible: MediaBackend.source === "Bluetooth"

            Column {
                anchors.centerIn: parent
                spacing: 20
                width: 520

                // Brand Logo (Clean, standalone Bluetooth icon without enclosing card)
                Image {
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: 76
                    height: 76
                    source: "qrc:/ApexVision/qml/assets/icons/bluetooth.svg"
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                    mipmap: true
                    sourceSize: Qt.size(256, 256)
                }

                // About Section / Headlines
                Column {
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 6
                    width: parent.width

                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "Bluetooth Audio"
                        color: "#FFFFFF"
                        font.family: "Inter"
                        font.pixelSize: 22
                        font.weight: Font.DemiBold
                    }

                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "To stream music, podcasts, and audio wirelessly, connect your device using Bluetooth."
                        color: Qt.rgba(225/255, 238/255, 255/255, 0.70)
                        font.family: "Inter"
                        font.pixelSize: 14
                        horizontalAlignment: Text.AlignHCenter
                    }
                }

                // Divider line after the about section
                Rectangle {
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: parent.width - 40
                    height: 1
                    color: Qt.rgba(255, 255, 255, 0.16)
                }

                // Connection Status Card (VehicleMenuCard Frosted Glass Theme - No straight line)
                Rectangle {
                    id: btAudioStatusCard
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: parent.width
                    height: 82
                    radius: 18
                    clip: true

                    // VehicleMenuCard Frosted Glass Gradient Fill
                    gradient: Gradient {
                        GradientStop {
                            position: 0.0
                            color: btAudioCardMouse.pressed ?
                                Qt.rgba(215/255, 238/255, 255/255, 0.32) :
                                (btAudioCardMouse.containsMouse ? Qt.rgba(225/255, 242/255, 255/255, 0.24) :
                                ((typeof PhoneBackend !== "undefined" && PhoneBackend.isConnected) ? Qt.rgba(225/255, 242/255, 255/255, 0.22) : Qt.rgba(215/255, 238/255, 255/255, 0.17)))
                        }
                        GradientStop {
                            position: 1.0
                            color: btAudioCardMouse.pressed ?
                                Qt.rgba(195/255, 225/255, 255/255, 0.26) :
                                (btAudioCardMouse.containsMouse ? Qt.rgba(205/255, 232/255, 255/255, 0.18) :
                                ((typeof PhoneBackend !== "undefined" && PhoneBackend.isConnected) ? Qt.rgba(205/255, 232/255, 255/255, 0.16) : Qt.rgba(195/255, 225/255, 255/255, 0.11)))
                        }
                    }

                    border.color: btAudioCardMouse.containsMouse ?
                        Qt.rgba(255, 255, 255, 0.65) :
                        ((typeof PhoneBackend !== "undefined" && PhoneBackend.isConnected) ? Qt.rgba(52/255, 211/255, 153/255, 0.50) : Qt.rgba(225/255, 242/255, 255/255, 0.36))
                    border.width: 1

                    Behavior on border.color { ColorAnimation { duration: 180 } }

                    scale: btAudioCardMouse.pressed ? 0.98 : (btAudioCardMouse.containsMouse ? 1.015 : 1.0)
                    Behavior on scale { NumberAnimation { duration: 150; easing.type: Easing.OutQuad } }

                    Row {
                        anchors.fill: parent
                        anchors.leftMargin: 20
                        anchors.rightMargin: 18
                        spacing: 16

                        // Bluetooth Icon in frosted circular badge
                        Rectangle {
                            width: 44
                            height: 44
                            radius: 22
                            anchors.verticalCenter: parent.verticalCenter
                            color: Qt.rgba(215/255, 238/255, 255/255, 0.16)
                            border.color: Qt.rgba(225/255, 242/255, 255/255, 0.30)
                            border.width: 1

                            Image {
                                anchors.centerIn: parent
                                source: "qrc:/ApexVision/qml/assets/icons/bluetooth.svg"
                                width: 20
                                height: 20
                                fillMode: Image.PreserveAspectFit
                            }
                        }

                        // Device Status Details
                        Column {
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: 4
                            width: 260

                            Text {
                                text: (typeof PhoneBackend !== "undefined" && PhoneBackend.isConnected) ? PhoneBackend.deviceName : "No Device Connected"
                                color: "#F2F5F7"
                                font.family: "Inter"
                                font.pixelSize: 16
                                font.weight: Font.DemiBold
                            }

                            Text {
                                text: (typeof PhoneBackend !== "undefined" && PhoneBackend.isConnected) ?
                                      "Bluetooth connected • Audio streaming ready" :
                                      "Bluetooth not connected for media playback"
                                color: (typeof PhoneBackend !== "undefined" && PhoneBackend.isConnected) ? "#34D399" : Qt.rgba(225/255, 238/255, 255/255, 0.70)
                                font.family: "Inter"
                                font.pixelSize: 12
                                font.weight: Font.Medium
                            }
                        }

                        Item { Layout.fillWidth: true; width: 1 }

                        // Action Button (Pair / Settings)
                        Rectangle {
                            anchors.verticalCenter: parent.verticalCenter
                            width: 130
                            height: 38
                            radius: 19
                            clip: true

                            gradient: Gradient {
                                GradientStop {
                                    position: 0.0
                                    color: btPairMouse.pressed ?
                                        Qt.rgba(215/255, 238/255, 255/255, 0.38) :
                                        (btPairMouse.containsMouse ? Qt.rgba(225/255, 242/255, 255/255, 0.28) : Qt.rgba(215/255, 238/255, 255/255, 0.18))
                                }
                                GradientStop {
                                    position: 1.0
                                    color: btPairMouse.pressed ?
                                        Qt.rgba(195/255, 225/255, 255/255, 0.30) :
                                        (btPairMouse.containsMouse ? Qt.rgba(205/255, 232/255, 255/255, 0.20) : Qt.rgba(195/255, 225/255, 255/255, 0.12))
                                }
                            }

                            border.color: btPairMouse.containsMouse ?
                                Qt.rgba(255, 255, 255, 0.65) :
                                Qt.rgba(225/255, 242/255, 255/255, 0.36)
                            border.width: 1

                            scale: btPairMouse.pressed ? 0.96 : (btPairMouse.containsMouse ? 1.03 : 1.0)
                            Behavior on scale { NumberAnimation { duration: 140 } }
                            Behavior on border.color { ColorAnimation { duration: 150 } }

                            Text {
                                anchors.centerIn: parent
                                text: (typeof PhoneBackend !== "undefined" && PhoneBackend.isConnected) ? "Manage Devices" : "Pair Device"
                                color: "#F2F5F7"
                                font.family: "Inter"
                                font.pixelSize: 13
                                font.weight: Font.DemiBold
                            }

                            MouseArea {
                                id: btPairMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: root.openBluetoothRequested()
                            }
                        }
                    }

                    MouseArea {
                        id: btAudioCardMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.openBluetoothRequested()
                    }
                }

                // Setup Instructions Card (VehicleMenuCard Frosted Glass - No straight line)
                Rectangle {
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: parent.width
                    height: 96
                    radius: 18
                    clip: true

                    gradient: Gradient {
                        GradientStop {
                            position: 0.0
                            color: Qt.rgba(215/255, 238/255, 255/255, 0.15)
                        }
                        GradientStop {
                            position: 1.0
                            color: Qt.rgba(195/255, 225/255, 255/255, 0.09)
                        }
                    }

                    border.color: Qt.rgba(225/255, 242/255, 255/255, 0.30)
                    border.width: 1

                    Column {
                        anchors.centerIn: parent
                        spacing: 8
                        width: parent.width - 40

                        Row {
                            spacing: 10
                            Rectangle {
                                width: 6; height: 6; radius: 3; color: "#38BDF8"
                                anchors.verticalCenter: parent.verticalCenter
                            }
                            Text {
                                text: "1. Turn on Bluetooth on your mobile phone."
                                color: Qt.rgba(225/255, 238/255, 255/255, 0.85)
                                font.family: "Inter"
                                font.pixelSize: 13
                            }
                        }

                        Row {
                            spacing: 10
                            Rectangle {
                                width: 6; height: 6; radius: 3; color: "#38BDF8"
                                anchors.verticalCenter: parent.verticalCenter
                            }
                            Text {
                                text: "2. Connect to APEX IVI in Bluetooth Settings."
                                color: Qt.rgba(225/255, 238/255, 255/255, 0.85)
                                font.family: "Inter"
                                font.pixelSize: 13
                            }
                        }

                        Row {
                            spacing: 10
                            Rectangle {
                                width: 6; height: 6; radius: 3; color: "#38BDF8"
                                anchors.verticalCenter: parent.verticalCenter
                            }
                            Text {
                                text: "3. Open your favorite music app on your phone and press Play."
                                color: Qt.rgba(225/255, 238/255, 255/255, 0.85)
                                font.family: "Inter"
                                font.pixelSize: 13
                            }
                        }
                    }
                }

                // Quick Link to Bluetooth Settings
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Open Bluetooth Settings"
                    color: btAudioLinkMouse.containsMouse ? "#38BDF8" : Qt.rgba(225/255, 238/255, 255/255, 0.75)
                    font.family: "Inter"
                    font.pixelSize: 13
                    font.weight: Font.Medium
                    Behavior on color { ColorAnimation { duration: 150 } }

                    MouseArea {
                        id: btAudioLinkMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.openBluetoothRequested()
                    }
                }
            }
        }

        // =====================================================================
        // ORBITXM SATELLITE RADIO PLAYER VIEW (SiriusXM Inspired Reference)
        // =====================================================================
        Item {
            id: sxmContent
            anchors.fill: parent
            visible: MediaBackend.isSxm

            // SXM LEFT COLUMN: Star, Channel Badge, "Ch 2", Artist, Title, Controls (<CH, |<<, ||, >>|, CH>, Bell)
            // SXM LEFT COLUMN: Star, Channel Badge, "Ch 2", Artist, Title, Controls (<CH, |<<, ||, LIVE, CH>, Bell)
            Item {
                id: sxmLeftCol
                anchors.left: parent.left
                anchors.right: sxmRightCol.left
                anchors.rightMargin: 32
                anchors.top: parent.top
                anchors.bottom: parent.bottom

                Column {
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 28

                    // Row 1: Favorite Star + Authentic Channel Logo Badge + "Ch 2"
                    Row {
                        spacing: 14
                        anchors.left: parent.left

                        // Favorite Star Button
                        Item {
                            width: 32
                            height: 32
                            anchors.verticalCenter: parent.verticalCenter

                            Text {
                                anchors.centerIn: parent
                                text: MediaBackend.isSxmFavorite ? "★" : "☆"
                                color: MediaBackend.isSxmFavorite ? "#FBBF24" : "#FFFFFF"
                                font.pixelSize: 26
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: MediaBackend.toggleSxmFavorite()
                            }
                        }

                        // Borderless Station Logo & Small Orbit Tag
                        Item {
                            height: 44
                            width: chPillRow.width + 12
                            anchors.verticalCenter: parent.verticalCenter

                            Row {
                                id: chPillRow
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: parent.left
                                spacing: 8

                                // Main Station Logo (Consistent normalized height across all channels)
                                Image {
                                    id: realLogoImg
                                    height: 54
                                    width: (implicitHeight > 0) ? Math.min(140, Math.round(height * implicitWidth / implicitHeight)) : 120
                                    source: MediaBackend.sxmChannelLogoUrl
                                    fillMode: Image.PreserveAspectFit
                                    smooth: true
                                    mipmap: true
                                    anchors.verticalCenter: parent.verticalCenter
                                    visible: source != ""
                                }

                                // Clean Non-clickable Channel Text (e.g. "Ch 2")
                                Text {
                                    text: "Ch " + MediaBackend.sxmChannelNumber
                                    color: "#94A3B8"
                                    font.family: "Inter"
                                    font.pixelSize: 15
                                    font.weight: 600
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                            }
                        }
                    }

                    // Row 2: Artist Name & Song Title (from reference video frames 015 & 030)
                    Column {
                        spacing: 8
                        width: sxmLeftCol.width

                        // Artist Name (e.g. "Sabrina Carpenter" or "@davisburleson")
                        Text {
                            text: MediaBackend.sxmArtist
                            color: "#FFFFFF"
                            font.family: "Inter"
                            font.pixelSize: 38
                            font.weight: Font.Bold
                            elide: Text.ElideRight
                            width: parent.width - 20
                        }

                        // Song Title (e.g. "Taste" or "@tiktokradio_siriusxm")
                        Text {
                            text: MediaBackend.sxmSongTitle
                            color: "#CBD5E1"
                            font.family: "Inter"
                            font.pixelSize: 22
                            font.weight: Font.Medium
                            elide: Text.ElideRight
                            width: parent.width - 20
                        }
                    }

                    Item { width: 1; height: 12 }

                    // Row 3: Transport Controls Row (Exact match from video: <CH  |<<  ||  LIVE  CH>  🔔)
                    Row {
                        spacing: 28
                        anchors.left: parent.left

                        // <CH (Previous Channel)
                        Item {
                            width: 60
                            height: 44
                            anchors.verticalCenter: parent.verticalCenter

                            Rectangle {
                                anchors.fill: parent
                                radius: 10
                                color: prevChMouse.pressed ? Qt.rgba(255, 255, 255, 0.16) :
                                       (prevChMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.08) : "transparent")
                            }

                            Text {
                                anchors.centerIn: parent
                                text: "<CH"
                                color: "#FFFFFF"
                                font.family: "Inter"
                                font.pixelSize: 19
                                font.weight: Font.Bold
                            }

                            Timer {
                                id: prevChClickTimer
                                interval: 320
                                onTriggered: MediaBackend.prevSxmChannel()
                            }

                            MouseArea {
                                id: prevChMouse
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    if (prevChClickTimer.running) {
                                        prevChClickTimer.stop();
                                        channelsViewModal.openModal();
                                    } else {
                                        prevChClickTimer.restart();
                                    }
                                }
                                onDoubleClicked: {
                                    prevChClickTimer.stop();
                                    channelsViewModal.openModal();
                                }
                            }
                        }

                        // |<< (Previous Track / Rewind)
                        Item {
                            width: 44
                            height: 44
                            anchors.verticalCenter: parent.verticalCenter

                            Rectangle {
                                anchors.fill: parent
                                radius: 22
                                color: prevTrackMouse.pressed ? Qt.rgba(255, 255, 255, 0.16) :
                                       (prevTrackMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.08) : "transparent")
                            }

                            Image {
                                anchors.centerIn: parent
                                width: 22
                                height: 22
                                source: "qrc:/ApexVision/qml/assets/icons/skip_prev.svg"
                                fillMode: Image.PreserveAspectFit
                                smooth: true
                            }

                            MouseArea {
                                id: prevTrackMouse
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: MediaBackend.prevSxmTrack()
                            }
                        }

                        // || / ▶ (Play/Pause)
                        Item {
                            width: 48
                            height: 48
                            anchors.verticalCenter: parent.verticalCenter

                            Rectangle {
                                anchors.fill: parent
                                radius: 24
                                color: playSxmMouse.pressed ? Qt.rgba(255, 255, 255, 0.20) :
                                       (playSxmMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.10) : "transparent")
                            }

                            Image {
                                anchors.centerIn: parent
                                width: 26
                                height: 26
                                source: MediaBackend.isPlaying ?
                                        "qrc:/ApexVision/qml/assets/icons/pause.svg" :
                                        "qrc:/ApexVision/qml/assets/icons/play.svg"
                                fillMode: Image.PreserveAspectFit
                                smooth: true
                            }

                            MouseArea {
                                id: playSxmMouse
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: MediaBackend.toggleSxmPlay()
                            }
                        }

                        // LIVE Status (Non-clickable broadcast indicator)
                        Item {
                            width: 58
                            height: 44
                            anchors.verticalCenter: parent.verticalCenter

                            Text {
                                anchors.centerIn: parent
                                text: "LIVE"
                                color: "#FFFFFF"
                                font.family: "Inter"
                                font.pixelSize: 16
                                font.weight: Font.Bold
                                opacity: 0.90
                            }
                        }

                        // CH> (Next Channel - Double Press opens Channel Guide)
                        Item {
                            width: 60
                            height: 44
                            anchors.verticalCenter: parent.verticalCenter

                            Rectangle {
                                anchors.fill: parent
                                radius: 10
                                color: nextChMouse.pressed ? Qt.rgba(255, 255, 255, 0.16) :
                                       (nextChMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.08) : "transparent")
                            }

                            Text {
                                anchors.centerIn: parent
                                text: "CH>"
                                color: "#FFFFFF"
                                font.family: "Inter"
                                font.pixelSize: 19
                                font.weight: Font.Bold
                            }

                            Timer {
                                id: nextChClickTimer
                                interval: 320
                                onTriggered: MediaBackend.nextSxmChannel()
                            }

                            MouseArea {
                                id: nextChMouse
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    if (nextChClickTimer.running) {
                                        nextChClickTimer.stop();
                                        channelsViewModal.openModal();
                                    } else {
                                        nextChClickTimer.restart();
                                    }
                                }
                                onDoubleClicked: {
                                    nextChClickTimer.stop();
                                    channelsViewModal.openModal();
                                }
                            }
                        }

                        // Bell Alert Icon 🔔 (Opens Song/Artist notification modal from video frames 030/040)
                        Item {
                            width: 44
                            height: 44
                            anchors.verticalCenter: parent.verticalCenter

                            Rectangle {
                                anchors.fill: parent
                                radius: 22
                                color: alertMouse.pressed ? Qt.rgba(255, 255, 255, 0.16) :
                                       (MediaBackend.isSxmAlertSet ? Qt.rgba(59/255, 130/255, 246/255, 0.25) : "transparent")
                            }

                            Image {
                                anchors.centerIn: parent
                                width: 22
                                height: 22
                                source: "qrc:/ApexVision/qml/assets/icons/setting_notifications_white.svg"
                                fillMode: Image.PreserveAspectFit
                                smooth: true
                            }

                            MouseArea {
                                id: alertMouse
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    sxmNotificationModal.openDialog();
                                }
                            }
                        }
                    }
                }
            }

            // SXM RIGHT COLUMN: Album Art Card + Glossy Reflection + "Related" Button
            Item {
                id: sxmRightCol
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: 280

                Column {
                    anchors.centerIn: parent
                    spacing: 20

                    // 1. Album Artwork Card (Square rounded card matching reference)
                    Rectangle {
                        id: sxmArtCard
                        width: 240
                        height: 240
                        radius: 18
                        color: Qt.rgba(15/255, 25/255, 45/255, 0.90)
                        border.color: Qt.rgba(255, 255, 255, 0.20)
                        border.width: 1.5

                        Item {
                            id: sxmArtContainer
                            anchors.fill: parent
                            layer.enabled: true
                            layer.effect: MultiEffect {
                                maskEnabled: true
                                maskSource: sxmArtMask
                            }

                            // Prior image retained during transitions to prevent black/emblem strobe
                            Image {
                                id: sxmArtImgPrev
                                anchors.fill: parent
                                source: ""
                                asynchronous: true
                                cache: true
                                fillMode: Image.PreserveAspectCrop
                                smooth: true
                                mipmap: true
                                visible: source !== "" && sxmArtImg.status !== Image.Ready
                            }

                            Image {
                                id: sxmArtImg
                                anchors.fill: parent
                                source: MediaBackend.sxmArtworkUrl
                                asynchronous: true
                                cache: true
                                fillMode: Image.PreserveAspectCrop
                                smooth: true
                                mipmap: true
                                opacity: status === Image.Ready ? 1.0 : 0.0
                                Behavior on opacity { NumberAnimation { duration: 180 } }
                                onStatusChanged: {
                                    if (status === Image.Ready) {
                                        sxmArtImgPrev.source = source;
                                    }
                                }
                            }
                        }

                        Rectangle {
                            id: sxmArtMask
                            anchors.fill: parent
                            radius: 18
                            visible: false
                            layer.enabled: true
                        }

                        // Fallback subtle emblem only if NO image is available
                        Item {
                            anchors.centerIn: parent
                            width: 80
                            height: 80
                            visible: sxmArtImg.status !== Image.Ready && sxmArtImgPrev.source === ""

                            Image {
                                anchors.centerIn: parent
                                width: 64
                                height: 64
                                source: "qrc:/ApexVision/qml/assets/radio_logos/orbitxm_emblem.png"
                                fillMode: Image.PreserveAspectFit
                                smooth: true
                                mipmap: true
                                opacity: 0.65
                            }
                        }

                        // Channel badge on album art removed as requested (clean artwork view)
                    }

                    // "Related" Pill Button (Shows all channels / Channel Guide as requested)
                    Rectangle {
                        id: relatedBtn
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 160
                        height: 40
                        radius: 20
                        color: relatedMouse.pressed ? Qt.rgba(255, 255, 255, 0.20) :
                               (relatedMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.12) : Qt.rgba(20/255, 35/255, 65/255, 0.75))
                        border.color: Qt.rgba(255, 255, 255, 0.25)
                        border.width: 1

                        scale: relatedMouse.pressed ? 0.96 : 1.0
                        Behavior on scale { NumberAnimation { duration: 80 } }

                        Text {
                            anchors.centerIn: parent
                            text: "Related"
                            color: "#FFFFFF"
                            font.family: "Inter"
                            font.pixelSize: 15
                            font.weight: Font.Medium
                        }

                        MouseArea {
                            id: relatedMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                relatedDrawer.openModal();
                            }
                        }
                    }
                }
            }
        }
    }

    // -------------------------------------------------------------------------
    // BOTTOM PRESET BAR: Supports Unified AM/FM and OrbitXM Satellite Presets
    // -------------------------------------------------------------------------
    Item {
        id: presetBar
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: MediaBackend.isSxm ? 24 : 40
        anchors.rightMargin: MediaBackend.isSxm ? 24 : 40
        anchors.bottomMargin: 14
        height: 72
        visible: MediaBackend.isRadio || MediaBackend.isSxm

        // Unified Radio Presets Bar (FM & AM)
        Item {
            id: radioPresetsContainer
            anchors.fill: parent
            visible: !MediaBackend.isSxm

            ListView {
                id: radioPresetListView
                anchors.fill: parent
                orientation: ListView.Horizontal
                spacing: 12
                clip: true
                boundsBehavior: Flickable.DragAndOvershootBounds
                flickDeceleration: 1600
                maximumFlickVelocity: 3500
                pixelAligned: true
                model: MediaBackend.radioPresets

                delegate: Item {
                    width: 148
                    height: 54

                    readonly property bool isActive: (MediaBackend.activeRadioPresetIndex === index)

                    // Preset Chip Container (Borderless Glass Tile matching OrbitXM)
                    Rectangle {
                        anchors.fill: parent
                        radius: 12
                        color: radioPresetMouse.pressed ? Qt.rgba(255, 255, 255, 0.16) :
                               (radioPresetMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.08) :
                               (isActive ? Qt.rgba(255, 255, 255, 0.12) : Qt.rgba(15/255, 25/255, 50/255, 0.45)))
                        border.width: 0

                        scale: radioPresetMouse.pressed ? 0.95 : 1.0
                        Behavior on scale { NumberAnimation { duration: 80 } }
                    }

                    Column {
                        anchors.centerIn: parent
                        spacing: 2

                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: (modelData.frequency || "") + " " + (modelData.band || "")
                            color: isActive ? "#FFFFFF" : "#CBD5E1"
                            font.family: "Inter"
                            font.pixelSize: 14
                            font.weight: Font.Bold
                        }

                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: modelData.name || "Preset"
                            color: isActive ? "#38BDF8" : "#94A3B8"
                            font.family: "Inter"
                            font.pixelSize: 12
                            font.weight: Font.Medium
                            elide: Text.ElideRight
                            width: 136
                            horizontalAlignment: Text.AlignHCenter
                        }
                    }

                    MouseArea {
                        id: radioPresetMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        preventStealing: false
                        onClicked: {
                            MediaBackend.selectRadioPreset(index);
                        }
                        onPressAndHold: {
                            if (typeof SystemBackend !== "undefined") {
                                SystemBackend.playSound("preset_chime");
                            } else {
                                presetChimeSound.play();
                            }
                            MediaBackend.saveCurrentAsPreset();
                            saveNotification.showToast("Preset " + (index + 1) + " updated");
                        }
                    }
                }
            }
        }

        // OrbitXM Presets Bar (Matches 10 PM reference image media_1790872779168.png with authentic channel logos)
        Item {
            anchors.fill: parent
            visible: MediaBackend.isSxm

            // Left scroll arrow
            Item {
                id: sxmPresetLeftArrow
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                width: 32
                height: 48

                Image {
                    anchors.centerIn: parent
                    width: 18
                    height: 18
                    source: "qrc:/ApexVision/qml/assets/icons/chevron_left_white.svg"
                    fillMode: Image.PreserveAspectFit
                    opacity: sxmPresetMouseLeft.pressed ? 0.4 : (sxmPresetMouseLeft.containsMouse ? 1.0 : 0.75)
                }

                MouseArea {
                    id: sxmPresetMouseLeft
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        sxmPresetListView.contentX = Math.max(0, sxmPresetListView.contentX - 280);
                    }
                }
            }

            // Horizontally Scrollable Presets ListView with Authentic Logos
            ListView {
                id: sxmPresetListView
                anchors.left: sxmPresetLeftArrow.right
                anchors.leftMargin: 8
                anchors.right: sxmPresetRightArrow.left
                anchors.rightMargin: 8
                anchors.verticalCenter: parent.verticalCenter
                height: 54
                orientation: ListView.Horizontal
                spacing: 12
                clip: true
                boundsBehavior: Flickable.DragAndOvershootBounds
                flickDeceleration: 1600
                maximumFlickVelocity: 3500
                pixelAligned: true
                model: MediaBackend.sxmPresets

                Behavior on contentX {
                    enabled: !sxmPresetListView.dragging && !sxmPresetListView.flicking
                    NumberAnimation { duration: 250; easing.type: Easing.OutQuad }
                }

                function updatePaging() {
                    if (width <= 0) return;
                    var chNum = MediaBackend.sxmChannelNumber;
                    var pIdx = -1;
                    if (MediaBackend.sxmPresets) {
                        for (var i = 0; i < MediaBackend.sxmPresets.length; ++i) {
                            if (MediaBackend.sxmPresets[i].number === chNum) {
                                pIdx = i;
                                break;
                            }
                        }
                    }
                    if (pIdx === -1) {
                        pIdx = MediaBackend.activeSxmPresetIndex;
                    }
                    if (pIdx < 0) return;
                    var slotWidth = 136 + 12; // 148
                    var itemsPerPage = Math.max(1, Math.floor((width + 12) / slotWidth));
                    var targetPage = Math.floor(pIdx / itemsPerPage);
                    var targetX = targetPage * itemsPerPage * slotWidth;
                    var maxX = Math.max(0, contentWidth - width);
                    contentX = Math.max(0, Math.min(maxX, targetX));
                }

                delegate: Item {
                    id: presetDelegate
                    width: 136
                    height: 54

                    readonly property bool isActive: (MediaBackend.activeSxmPresetIndex === index) || (modelData.number === MediaBackend.sxmChannelNumber && !modelData.isHoldToSet)

                    // Preset Chip Container (Borderless Glass Tile, No Underline)
                    Rectangle {
                        anchors.fill: parent
                        radius: 12
                        color: sxmPresetMouse.pressed ? Qt.rgba(255, 255, 255, 0.16) :
                               (sxmPresetMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.08) :
                               (presetDelegate.isActive ? Qt.rgba(255, 255, 255, 0.12) : Qt.rgba(15/255, 25/255, 50/255, 0.45)))
                        border.width: 0

                        scale: sxmPresetMouse.pressed ? 0.95 : 1.0
                        Behavior on scale { NumberAnimation { duration: 80 } }
                    }

                    // 1. Hold To Set
                    Item {
                        anchors.fill: parent
                        visible: modelData.isHoldToSet

                        Text {
                            anchors.centerIn: parent
                            text: "Hold To Set"
                            color: "#94A3B8"
                            font.family: "Inter"
                            font.pixelSize: 13
                            font.weight: Font.Medium
                        }
                    }

                    // 2. Real Channel Logo from Internet/SiriusXM Assets
                    Item {
                        anchors.fill: parent
                        visible: !modelData.isHoldToSet

                        Image {
                            id: presetLogoImg
                            anchors.centerIn: parent
                            width: parent.width - 16
                            height: 42
                            source: modelData.logoUrl || ""
                            fillMode: Image.PreserveAspectFit
                            smooth: true
                            mipmap: true
                            visible: source != ""
                        }

                        // Fallback text only if logo URL is absent
                        Text {
                            anchors.centerIn: parent
                            visible: !modelData.logoUrl || modelData.logoUrl === ""
                            text: modelData.name || ("Ch " + modelData.number)
                            color: parent.parent.isActive ? "#FFFFFF" : "#E2E8F0"
                            font.family: "Inter"
                            font.pixelSize: 13
                            font.weight: Font.Bold
                            elide: Text.ElideRight
                            width: parent.width - 16
                            horizontalAlignment: Text.AlignHCenter
                        }
                    }

                    MouseArea {
                        id: sxmPresetMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        preventStealing: false
                        onClicked: {
                            MediaBackend.selectSxmPreset(index);
                        }
                        onPressAndHold: {
                            if (typeof SystemBackend !== "undefined") {
                                SystemBackend.playSound("preset_chime");
                            } else {
                                presetChimeSound.play();
                            }
                            saveNotification.showToast("Preset " + (index + 1) + " saved: " + MediaBackend.sxmChannelName);
                        }
                    }
                }
            }

            // Right scroll arrow
            Item {
                id: sxmPresetRightArrow
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                width: 32
                height: 48

                Image {
                    anchors.centerIn: parent
                    width: 18
                    height: 18
                    source: "qrc:/ApexVision/qml/assets/icons/chevron_right_white.svg"
                    fillMode: Image.PreserveAspectFit
                    opacity: sxmPresetMouseRight.pressed ? 0.4 : (sxmPresetMouseRight.containsMouse ? 1.0 : 0.75)
                }

                MouseArea {
                    id: sxmPresetMouseRight
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        sxmPresetListView.contentX = Math.min(sxmPresetListView.contentWidth - sxmPresetListView.width, sxmPresetListView.contentX + 280);
                    }
                }
            }
        }
    }

    // =========================================================================
    // SXM SONG / ARTIST NOTIFICATION MODAL (Automotive Glassmorphism & Audio Meter Effect)
    // =========================================================================
    Item {
        id: sxmNotificationModal
        objectName: "sxmNotificationModal"
        anchors.fill: parent
        property bool isOpen: false
        visible: isOpen
        opacity: isOpen ? 1.0 : 0.0
        z: 150

        Behavior on opacity { NumberAnimation { duration: 200 } }

        property bool trackSong: true
        property bool trackArtist: false

        function openDialog() {
            trackSong = true;
            trackArtist = false;
            isOpen = true;
        }

        function closeDialog() {
            isOpen = false;
        }

        // Dark dim backdrop
        Rectangle {
            anchors.fill: parent
            color: Qt.rgba(0, 0, 0, 0.65)
            MouseArea {
                anchors.fill: parent
                onClicked: sxmNotificationModal.closeDialog()
            }
        }

        // OEM SiriusXM Modal Dialog (Matches reference photo exactly)
        Rectangle {
            id: sxmAlertBox
            anchors.centerIn: parent
            width: 530
            height: 350
            radius: 20
            color: "#0D1527"
            border.color: Qt.rgba(255, 255, 255, 0.18)
            border.width: 1.5

            MouseArea {
                anchors.fill: parent // Prevent click-through to backdrop
            }

            Column {
                anchors.fill: parent
                anchors.margins: 26
                spacing: 16

                // Top: Song and Artist Selection Cards
                Row {
                    spacing: 16

                    // Card 1: Song Card (Music Note + Title)
                    Rectangle {
                        width: 145
                        height: 110
                        radius: 12
                        color: sxmNotificationModal.trackSong ? Qt.rgba(56/255, 189/255, 248/255, 0.16) :
                               (songCardMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.08) : Qt.rgba(255, 255, 255, 0.04))
                        border.color: sxmNotificationModal.trackSong ? "#38BDF8" : Qt.rgba(255, 255, 255, 0.22)
                        border.width: sxmNotificationModal.trackSong ? 2 : 1

                        Column {
                            anchors.centerIn: parent
                            spacing: 8
                            width: parent.width - 16

                            Image {
                                anchors.horizontalCenter: parent.horizontalCenter
                                width: 28
                                height: 28
                                source: "qrc:/ApexVision/qml/assets/icons/sxm_note.svg"
                                fillMode: Image.PreserveAspectFit
                            }

                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: (MediaBackend.sxmSongTitle && MediaBackend.sxmSongTitle.length > 0) ?
                                      MediaBackend.sxmSongTitle : "Song"
                                color: "#FFFFFF"
                                font.family: "Inter"
                                font.pixelSize: 14
                                font.weight: Font.DemiBold
                                elide: Text.ElideRight
                                horizontalAlignment: Text.AlignHCenter
                                width: parent.width
                            }
                        }

                        MouseArea {
                            id: songCardMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                sxmNotificationModal.trackSong = !sxmNotificationModal.trackSong;
                            }
                        }
                    }

                    // Card 2: Artist Card (Microphone + Artist Name)
                    Rectangle {
                        width: 145
                        height: 110
                        radius: 12
                        color: sxmNotificationModal.trackArtist ? Qt.rgba(56/255, 189/255, 248/255, 0.16) :
                               (artCardMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.08) : Qt.rgba(255, 255, 255, 0.04))
                        border.color: sxmNotificationModal.trackArtist ? "#38BDF8" : Qt.rgba(255, 255, 255, 0.22)
                        border.width: sxmNotificationModal.trackArtist ? 2 : 1

                        Column {
                            anchors.centerIn: parent
                            spacing: 8
                            width: parent.width - 16

                            Image {
                                anchors.horizontalCenter: parent.horizontalCenter
                                width: 28
                                height: 28
                                source: "qrc:/ApexVision/qml/assets/icons/sxm_mic.svg"
                                fillMode: Image.PreserveAspectFit
                            }

                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: (MediaBackend.sxmArtist && MediaBackend.sxmArtist.length > 0) ?
                                      MediaBackend.sxmArtist : "Artist"
                                color: "#FFFFFF"
                                font.family: "Inter"
                                font.pixelSize: 13
                                font.weight: Font.DemiBold
                                wrapMode: Text.WordWrap
                                maximumLineCount: 2
                                horizontalAlignment: Text.AlignHCenter
                                width: parent.width
                            }
                        }

                        MouseArea {
                            id: artCardMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                sxmNotificationModal.trackArtist = !sxmNotificationModal.trackArtist;
                            }
                        }
                    }
                }

                // Middle: Title and Subtitle Text (Word for word matching OEM reference photo)
                Column {
                    width: parent.width
                    spacing: 6

                    Text {
                        text: "Set Song / Artist Notification?"
                        color: "#FFFFFF"
                        font.family: "Inter"
                        font.pixelSize: 20
                        font.weight: Font.Bold
                    }

                    Text {
                        text: "Tap the song and/or artist to get a notification every time the song/artist airs on OrbitXM."
                        color: "#94A3B8"
                        font.family: "Inter"
                        font.pixelSize: 14
                        lineHeight: 1.2
                        wrapMode: Text.WordWrap
                        width: parent.width
                    }
                }

                Item { Layout.fillHeight: true; height: 4 }

                // Bottom: [ Manage ]   [ Done ] Action Buttons
                Row {
                    spacing: 14

                    // [ Manage ] Button
                    Rectangle {
                        width: 120
                        height: 42
                        radius: 10
                        color: manageAlertMouse.pressed ? Qt.rgba(255, 255, 255, 0.18) :
                               (manageAlertMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.12) : Qt.rgba(255, 255, 255, 0.07))
                        border.color: Qt.rgba(255, 255, 255, 0.20)
                        border.width: 1

                        Text {
                            anchors.centerIn: parent
                            text: "Manage"
                            color: "#FFFFFF"
                            font.family: "Inter"
                            font.pixelSize: 15
                            font.weight: Font.DemiBold
                        }

                        MouseArea {
                            id: manageAlertMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                sxmNotificationModal.closeDialog();
                                saveNotification.showToast("Manage Alerts opened");
                            }
                        }
                    }

                    // [ Done ] Button
                    Rectangle {
                        width: 120
                        height: 42
                        radius: 10
                        color: doneAlertMouse.pressed ? Qt.rgba(255, 255, 255, 0.18) :
                               (doneAlertMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.12) : Qt.rgba(255, 255, 255, 0.07))
                        border.color: Qt.rgba(255, 255, 255, 0.20)
                        border.width: 1

                        Text {
                            anchors.centerIn: parent
                            text: "Done"
                            color: "#FFFFFF"
                            font.family: "Inter"
                            font.pixelSize: 15
                            font.weight: Font.DemiBold
                        }

                        MouseArea {
                            id: doneAlertMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                sxmNotificationModal.closeDialog();
                                if (sxmNotificationModal.trackSong || sxmNotificationModal.trackArtist) {
                                    var alertTarget = sxmNotificationModal.trackSong ?
                                        MediaBackend.sxmSongTitle : MediaBackend.sxmArtist;
                                    saveNotification.showToast("Alert saved for " + alertTarget);
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    // =========================================================================
    // ORBITXM "RELATED" FULL VIEW (Matching User Reference Images 1 & 2)
    // =========================================================================
    Rectangle {
        id: relatedDrawer
        objectName: "relatedDrawer"
        anchors.fill: parent
        color: "#080E1C"
        property bool isOpen: false
        visible: isOpen
        opacity: isOpen ? 1.0 : 0.0
        z: 110

        property int activeTab: 0 // 0: Related Content, 1: Available Shows

        function openModal() {
            activeTab = 0;
            isOpen = true;
        }

        function openShows() {
            activeTab = 1;
            isOpen = true;
        }

        function closeModal() {
            isOpen = false;
        }

        // Header Row with Signature IVI Back Button & Current Station Info
        Item {
            id: relatedHeader
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: 72

            // IVI Signature Back Button (Circular)
            Rectangle {
                id: relBackBtn
                width: 44
                height: 44
                radius: 22
                color: relBackMouse.pressed ? Qt.rgba(0, 229, 255, 0.25) :
                       (relBackMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.12) : Qt.rgba(255, 255, 255, 0.06))
                border.color: relBackMouse.pressed ? "#00E5FF" :
                              (relBackMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.3) : Qt.rgba(255, 255, 255, 0.12))
                border.width: 1
                anchors.left: parent.left
                anchors.leftMargin: 28
                anchors.verticalCenter: parent.verticalCenter

                Text {
                    anchors.centerIn: parent
                    text: "←"
                    color: relBackMouse.pressed ? "#00E5FF" : "#FFFFFF"
                    font.pixelSize: 22
                    font.weight: 600
                }

                MouseArea {
                    id: relBackMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: relatedDrawer.closeModal()
                }
            }

            // Current Station Logo + "More Like [Station]"
            Row {
                anchors.left: relBackBtn.right
                anchors.leftMargin: 18
                anchors.verticalCenter: parent.verticalCenter
                spacing: 14

                Image {
                    width: 76
                    height: 28
                    source: MediaBackend.sxmChannelLogoUrl
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                    mipmap: true
                    anchors.verticalCenter: parent.verticalCenter
                }

                Text {
                    text: "More Like " + MediaBackend.sxmChannelName
                    color: "#FFFFFF"
                    font.family: "Inter"
                    font.pixelSize: 20
                    font.weight: Font.Bold
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            // Right Action: Close Button
            Rectangle {
                id: relCloseBtn
                width: 40
                height: 40
                radius: 20
                anchors.right: parent.right
                anchors.rightMargin: 28
                anchors.verticalCenter: parent.verticalCenter
                color: relCloseMouse.pressed ? Qt.rgba(255, 255, 255, 0.20) :
                       (relCloseMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.10) : Qt.rgba(255, 255, 255, 0.05))
                border.color: Qt.rgba(255, 255, 255, 0.15)
                border.width: 1

                Text {
                    anchors.centerIn: parent
                    text: "✕"
                    color: "#FFFFFF"
                    font.pixelSize: 17
                    font.weight: Font.Bold
                }

                MouseArea {
                    id: relCloseMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: relatedDrawer.closeModal()
                }
            }
        }

        // Tabs Row: [ Related Content ] [ Available Shows ]
        Row {
            id: relatedTabsRow
            anchors.top: relatedHeader.bottom
            anchors.left: parent.left
            anchors.leftMargin: 28
            spacing: 14

            // Tab 1: Related Content
            Rectangle {
                width: 150
                height: 38
                radius: 10
                color: relatedDrawer.activeTab === 0 ? Qt.rgba(0, 229, 255, 0.15) : "transparent"
                border.color: relatedDrawer.activeTab === 0 ? "#00E5FF" : Qt.rgba(255, 255, 255, 0.15)
                border.width: relatedDrawer.activeTab === 0 ? 1.5 : 1

                Text {
                    anchors.centerIn: parent
                    text: "Related Content"
                    color: relatedDrawer.activeTab === 0 ? "#FFFFFF" : "#94A3B8"
                    font.family: "Inter"
                    font.pixelSize: 14
                    font.weight: 600
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: relatedDrawer.activeTab = 0
                }
            }

            // Tab 2: Available Shows
            Rectangle {
                width: 150
                height: 38
                radius: 10
                color: relatedDrawer.activeTab === 1 ? Qt.rgba(0, 229, 255, 0.15) : "transparent"
                border.color: relatedDrawer.activeTab === 1 ? "#00E5FF" : Qt.rgba(255, 255, 255, 0.15)
                border.width: relatedDrawer.activeTab === 1 ? 1.5 : 1

                Text {
                    anchors.centerIn: parent
                    text: "Available Shows"
                    color: relatedDrawer.activeTab === 1 ? "#FFFFFF" : "#94A3B8"
                    font.family: "Inter"
                    font.pixelSize: 14
                    font.weight: 600
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: relatedDrawer.activeTab = 1
                }
            }
        }

        // =====================================================================
        // TAB 0: RELATED CONTENT (Current Lineup: Bollywood, Mirchi, GTA, Retro, Punjabi)
        // =====================================================================
        Item {
            anchors.top: relatedTabsRow.bottom
            anchors.topMargin: 18
            anchors.left: parent.left
            anchors.leftMargin: 28
            anchors.right: parent.right
            anchors.rightMargin: 28
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 20
            visible: relatedDrawer.activeTab === 0

            Row {
                anchors.fill: parent
                spacing: 20

                // LEFT COLUMN
                Column {
                    width: (parent.width - 20) / 2
                    spacing: 14

                    // Card 1: Ch 2 Orbit Bollywood Hits
                    Rectangle {
                        width: parent.width
                        height: 84
                        radius: 14
                        color: relCard1Mouse.pressed ? Qt.rgba(255, 255, 255, 0.12) :
                               (relCard1Mouse.containsMouse ? Qt.rgba(255, 255, 255, 0.08) : "#0F182B")
                        border.color: relCard1Mouse.containsMouse ? "#00E5FF" : Qt.rgba(255, 255, 255, 0.12)
                        border.width: 1
                        scale: relCard1Mouse.pressed ? 0.98 : 1.0
                        Behavior on scale { NumberAnimation { duration: 80 } }

                        Row {
                            anchors.left: parent.left
                            anchors.leftMargin: 18
                            anchors.right: parent.right
                            anchors.rightMargin: 18
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: 16

                            Image {
                                width: 88
                                height: 42
                                source: "qrc:/ApexVision/qml/assets/radio_logos/sxm_bollywood.png"
                                fillMode: Image.PreserveAspectFit
                                smooth: true
                                mipmap: true
                                anchors.verticalCenter: parent.verticalCenter
                            }

                            Column {
                                anchors.verticalCenter: parent.verticalCenter
                                width: parent.width - 104
                                spacing: 3

                                Text {
                                    text: "India's Biggest Bollywood Hits"
                                    color: "#FFFFFF"
                                    font.family: "Inter"
                                    font.pixelSize: 15
                                    font.weight: Font.Bold
                                    elide: Text.ElideRight
                                    width: parent.width
                                }
                                Text {
                                    text: "Ch 2 • Arijit Singh, Shreya Ghoshal, Pritam"
                                    color: "#38BDF8"
                                    font.family: "Inter"
                                    font.pixelSize: 12
                                    font.weight: Font.Medium
                                    elide: Text.ElideRight
                                    width: parent.width
                                }
                            }
                        }

                        MouseArea {
                            id: relCard1Mouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                MediaBackend.tuneSxmChannelNumber(2);
                                relatedDrawer.closeModal();
                            }
                        }
                    }

                    // Card 2: Ch 3 Radio Mirchi 98.3 / Ishq
                    Rectangle {
                        width: parent.width
                        height: 84
                        radius: 14
                        color: relCard2Mouse.pressed ? Qt.rgba(255, 255, 255, 0.12) :
                               (relCard2Mouse.containsMouse ? Qt.rgba(255, 255, 255, 0.08) : "#0F182B")
                        border.color: relCard2Mouse.containsMouse ? "#00E5FF" : Qt.rgba(255, 255, 255, 0.12)
                        border.width: 1
                        scale: relCard2Mouse.pressed ? 0.98 : 1.0
                        Behavior on scale { NumberAnimation { duration: 80 } }

                        Row {
                            anchors.left: parent.left
                            anchors.leftMargin: 18
                            anchors.right: parent.right
                            anchors.rightMargin: 18
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: 16

                            Image {
                                width: 88
                                height: 42
                                source: "qrc:/ApexVision/qml/assets/radio_logos/sxm_ishq.png"
                                fillMode: Image.PreserveAspectFit
                                smooth: true
                                mipmap: true
                                anchors.verticalCenter: parent.verticalCenter
                            }

                            Column {
                                anchors.verticalCenter: parent.verticalCenter
                                width: parent.width - 104
                                spacing: 3

                                Text {
                                    text: "Radio Mirchi • Love Melodies"
                                    color: "#FFFFFF"
                                    font.family: "Inter"
                                    font.pixelSize: 15
                                    font.weight: Font.Bold
                                    elide: Text.ElideRight
                                    width: parent.width
                                }
                                Text {
                                    text: "Ch 3 • Pure Romantic Hindi Classics"
                                    color: "#38BDF8"
                                    font.family: "Inter"
                                    font.pixelSize: 12
                                    font.weight: Font.Medium
                                    elide: Text.ElideRight
                                    width: parent.width
                                }
                            }
                        }

                        MouseArea {
                            id: relCard2Mouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                MediaBackend.tuneSxmChannelNumber(3);
                                relatedDrawer.closeModal();
                            }
                        }
                    }

                    // Card 3: Ch 25 GTA Flash FM
                    Rectangle {
                        width: parent.width
                        height: 84
                        radius: 14
                        color: relCard3Mouse.pressed ? Qt.rgba(255, 255, 255, 0.12) :
                               (relCard3Mouse.containsMouse ? Qt.rgba(255, 255, 255, 0.08) : "#0F182B")
                        border.color: relCard3Mouse.containsMouse ? "#00E5FF" : Qt.rgba(255, 255, 255, 0.12)
                        border.width: 1
                        scale: relCard3Mouse.pressed ? 0.98 : 1.0
                        Behavior on scale { NumberAnimation { duration: 80 } }

                        Row {
                            anchors.left: parent.left
                            anchors.leftMargin: 18
                            anchors.right: parent.right
                            anchors.rightMargin: 18
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: 16

                            Image {
                                width: 88
                                height: 42
                                source: "qrc:/ApexVision/qml/assets/radio_logos/sxm_gtaflash.png"
                                fillMode: Image.PreserveAspectFit
                                smooth: true
                                mipmap: true
                                anchors.verticalCenter: parent.verticalCenter
                            }

                            Column {
                                anchors.verticalCenter: parent.verticalCenter
                                width: parent.width - 104
                                spacing: 3

                                Text {
                                    text: "GTA Vice City Flash FM"
                                    color: "#FFFFFF"
                                    font.family: "Inter"
                                    font.pixelSize: 15
                                    font.weight: Font.Bold
                                    elide: Text.ElideRight
                                    width: parent.width
                                }
                                Text {
                                    text: "Ch 25 • 80s Pop, Synth & Michael Jackson"
                                    color: "#F472B6"
                                    font.family: "Inter"
                                    font.pixelSize: 12
                                    font.weight: Font.Medium
                                    elide: Text.ElideRight
                                    width: parent.width
                                }
                            }
                        }

                        MouseArea {
                            id: relCard3Mouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                MediaBackend.tuneSxmChannelNumber(25);
                                relatedDrawer.closeModal();
                            }
                        }
                    }
                }

                // RIGHT COLUMN
                Column {
                    width: (parent.width - 20) / 2
                    spacing: 14

                    // Card 4: Ch 4 AIR Vividh Bharati / Retro Deewane
                    Rectangle {
                        width: parent.width
                        height: 84
                        radius: 14
                        color: relCard4Mouse.pressed ? Qt.rgba(255, 255, 255, 0.12) :
                               (relCard4Mouse.containsMouse ? Qt.rgba(255, 255, 255, 0.08) : "#0F182B")
                        border.color: relCard4Mouse.containsMouse ? "#00E5FF" : Qt.rgba(255, 255, 255, 0.12)
                        border.width: 1
                        scale: relCard4Mouse.pressed ? 0.98 : 1.0
                        Behavior on scale { NumberAnimation { duration: 80 } }

                        Row {
                            anchors.left: parent.left
                            anchors.leftMargin: 18
                            anchors.right: parent.right
                            anchors.rightMargin: 18
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: 16

                            Image {
                                width: 88
                                height: 42
                                source: "qrc:/ApexVision/qml/assets/radio_logos/sxm_retro.png"
                                fillMode: Image.PreserveAspectFit
                                smooth: true
                                mipmap: true
                                anchors.verticalCenter: parent.verticalCenter
                            }

                            Column {
                                anchors.verticalCenter: parent.verticalCenter
                                width: parent.width - 104
                                spacing: 3

                                Text {
                                    text: "Golden Classics of 60s, 70s & 80s"
                                    color: "#FFFFFF"
                                    font.family: "Inter"
                                    font.pixelSize: 15
                                    font.weight: Font.Bold
                                    elide: Text.ElideRight
                                    width: parent.width
                                }
                                Text {
                                    text: "Ch 4 • Kishore Kumar, Lata & RD Burman"
                                    color: "#FBBF24"
                                    font.family: "Inter"
                                    font.pixelSize: 12
                                    font.weight: Font.Medium
                                    elide: Text.ElideRight
                                    width: parent.width
                                }
                            }
                        }

                        MouseArea {
                            id: relCard4Mouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                MediaBackend.tuneSxmChannelNumber(4);
                                relatedDrawer.closeModal();
                            }
                        }
                    }

                    // Card 5: Ch 7 Punjabi Swag
                    Rectangle {
                        width: parent.width
                        height: 84
                        radius: 14
                        color: relCard5Mouse.pressed ? Qt.rgba(255, 255, 255, 0.12) :
                               (relCard5Mouse.containsMouse ? Qt.rgba(255, 255, 255, 0.08) : "#0F182B")
                        border.color: relCard5Mouse.containsMouse ? "#00E5FF" : Qt.rgba(255, 255, 255, 0.12)
                        border.width: 1
                        scale: relCard5Mouse.pressed ? 0.98 : 1.0
                        Behavior on scale { NumberAnimation { duration: 80 } }

                        Row {
                            anchors.left: parent.left
                            anchors.leftMargin: 18
                            anchors.right: parent.right
                            anchors.rightMargin: 18
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: 16

                            Image {
                                width: 88
                                height: 42
                                source: "qrc:/ApexVision/qml/assets/radio_logos/sxm_punjabi.png"
                                fillMode: Image.PreserveAspectFit
                                smooth: true
                                mipmap: true
                                anchors.verticalCenter: parent.verticalCenter
                            }

                            Column {
                                anchors.verticalCenter: parent.verticalCenter
                                width: parent.width - 104
                                spacing: 3

                                Text {
                                    text: "Punjabi Swag & Bhangra Hits"
                                    color: "#FFFFFF"
                                    font.family: "Inter"
                                    font.pixelSize: 15
                                    font.weight: Font.Bold
                                    elide: Text.ElideRight
                                    width: parent.width
                                }
                                Text {
                                    text: "Ch 7 • Diljit Dosanjh, Sidhu Moose Wala"
                                    color: "#FB923C"
                                    font.family: "Inter"
                                    font.pixelSize: 12
                                    font.weight: Font.Medium
                                    elide: Text.ElideRight
                                    width: parent.width
                                }
                            }
                        }

                        MouseArea {
                            id: relCard5Mouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                MediaBackend.tuneSxmChannelNumber(7);
                                relatedDrawer.closeModal();
                            }
                        }
                    }

                    // Card 6: Ch 26 GTA Los Santos Rock Radio
                    Rectangle {
                        width: parent.width
                        height: 84
                        radius: 14
                        color: relCard6Mouse.pressed ? Qt.rgba(255, 255, 255, 0.12) :
                               (relCard6Mouse.containsMouse ? Qt.rgba(255, 255, 255, 0.08) : "#0F182B")
                        border.color: relCard6Mouse.containsMouse ? "#00E5FF" : Qt.rgba(255, 255, 255, 0.12)
                        border.width: 1
                        scale: relCard6Mouse.pressed ? 0.98 : 1.0
                        Behavior on scale { NumberAnimation { duration: 80 } }

                        Row {
                            anchors.left: parent.left
                            anchors.leftMargin: 18
                            anchors.right: parent.right
                            anchors.rightMargin: 18
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: 16

                            Image {
                                width: 88
                                height: 42
                                source: "qrc:/ApexVision/qml/assets/radio_logos/sxm_gtalsrock.png"
                                fillMode: Image.PreserveAspectFit
                                smooth: true
                                mipmap: true
                                anchors.verticalCenter: parent.verticalCenter
                            }

                            Column {
                                anchors.verticalCenter: parent.verticalCenter
                                width: parent.width - 104
                                spacing: 3

                                Text {
                                    text: "GTA Los Santos Rock Radio"
                                    color: "#FFFFFF"
                                    font.family: "Inter"
                                    font.pixelSize: 15
                                    font.weight: Font.Bold
                                    elide: Text.ElideRight
                                    width: parent.width
                                }
                                Text {
                                    text: "Ch 26 • Kenny Loggins, Queen, The Cult"
                                    color: "#E879F9"
                                    font.family: "Inter"
                                    font.pixelSize: 12
                                    font.weight: Font.Medium
                                    elide: Text.ElideRight
                                    width: parent.width
                                }
                            }
                        }

                        MouseArea {
                            id: relCard6Mouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                MediaBackend.tuneSxmChannelNumber(26);
                                relatedDrawer.closeModal();
                            }
                        }
                    }
                }
            }
        }

        // =====================================================================
        // TAB 1: AVAILABLE SHOWS (Curated Authentic Shows from Channels)
        // =====================================================================
        Item {
            anchors.top: relatedTabsRow.bottom
            anchors.topMargin: 16
            anchors.left: parent.left
            anchors.leftMargin: 28
            anchors.right: parent.right
            anchors.rightMargin: 28
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 20
            visible: relatedDrawer.activeTab === 1

            Column {
                anchors.fill: parent
                spacing: 14

                // Shows Header Subtitle
                Column {
                    spacing: 2
                    Text {
                        text: "Featured Shows & Special Editions"
                        color: "#FFFFFF"
                        font.family: "Inter"
                        font.pixelSize: 18
                        font.weight: Font.Bold
                    }
                    Text {
                        text: "Curated live shows, morning editions, and legendary countdowns"
                        color: "#94A3B8"
                        font.family: "Inter"
                        font.pixelSize: 13
                    }
                }

                // 2-Column Shows Grid
                Row {
                    width: parent.width
                    spacing: 20

                    // Left Column
                    Column {
                        width: (parent.width - 20) / 2
                        spacing: 14

                        // Show 1: Mirchi Top 20 Countdown
                        Rectangle {
                            width: parent.width
                            height: 84
                            radius: 14
                            color: relShow1Mouse.pressed ? Qt.rgba(255, 255, 255, 0.12) :
                                   (relShow1Mouse.containsMouse ? Qt.rgba(255, 255, 255, 0.08) : "#0F182B")
                            border.color: relShow1Mouse.containsMouse ? "#00E5FF" : Qt.rgba(255, 255, 255, 0.12)
                            border.width: 1
                            scale: relShow1Mouse.pressed ? 0.98 : 1.0
                            Behavior on scale { NumberAnimation { duration: 80 } }

                            Row {
                                anchors.left: parent.left
                                anchors.leftMargin: 18
                                anchors.right: parent.right
                                anchors.rightMargin: 18
                                anchors.verticalCenter: parent.verticalCenter
                                spacing: 16

                                Image {
                                    width: 88
                                    height: 42
                                    source: "qrc:/ApexVision/qml/assets/radio_logos/sxm_ishq.png"
                                    fillMode: Image.PreserveAspectFit
                                    smooth: true
                                    mipmap: true
                                    anchors.verticalCenter: parent.verticalCenter
                                }

                                Column {
                                    anchors.verticalCenter: parent.verticalCenter
                                    width: parent.width - 104
                                    spacing: 3

                                    Text {
                                        text: "Mirchi Top 20 Countdown"
                                        color: "#FFFFFF"
                                        font.family: "Inter"
                                        font.pixelSize: 15
                                        font.weight: Font.Bold
                                        elide: Text.ElideRight
                                        width: parent.width
                                    }
                                    Text {
                                        text: "Weekly Mega Chart • Ch 3 Radio Mirchi"
                                        color: "#38BDF8"
                                        font.family: "Inter"
                                        font.pixelSize: 12
                                        font.weight: Font.Medium
                                        elide: Text.ElideRight
                                        width: parent.width
                                    }
                                }
                            }

                            MouseArea {
                                id: relShow1Mouse
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    MediaBackend.tuneSxmChannelNumber(3);
                                    relatedDrawer.closeModal();
                                }
                            }
                        }

                        // Show 2: Bhule Bisre Geet
                        Rectangle {
                            width: parent.width
                            height: 84
                            radius: 14
                            color: relShow2Mouse.pressed ? Qt.rgba(255, 255, 255, 0.12) :
                                   (relShow2Mouse.containsMouse ? Qt.rgba(255, 255, 255, 0.08) : "#0F182B")
                            border.color: relShow2Mouse.containsMouse ? "#00E5FF" : Qt.rgba(255, 255, 255, 0.12)
                            border.width: 1
                            scale: relShow2Mouse.pressed ? 0.98 : 1.0
                            Behavior on scale { NumberAnimation { duration: 80 } }

                            Row {
                                anchors.left: parent.left
                                anchors.leftMargin: 18
                                anchors.right: parent.right
                                anchors.rightMargin: 18
                                anchors.verticalCenter: parent.verticalCenter
                                spacing: 16

                                Image {
                                    width: 88
                                    height: 42
                                    source: "qrc:/ApexVision/qml/assets/radio_logos/sxm_retro.png"
                                    fillMode: Image.PreserveAspectFit
                                    smooth: true
                                    mipmap: true
                                    anchors.verticalCenter: parent.verticalCenter
                                }

                                Column {
                                    anchors.verticalCenter: parent.verticalCenter
                                    width: parent.width - 104
                                    spacing: 3

                                    Text {
                                        text: "Bhule Bisre Geet"
                                        color: "#FFFFFF"
                                        font.family: "Inter"
                                        font.pixelSize: 15
                                        font.weight: Font.Bold
                                        elide: Text.ElideRight
                                        width: parent.width
                                    }
                                    Text {
                                        text: "Morning Classics Edition • Ch 4 Vividh Bharati"
                                        color: "#FBBF24"
                                        font.family: "Inter"
                                        font.pixelSize: 12
                                        font.weight: Font.Medium
                                        elide: Text.ElideRight
                                        width: parent.width
                                    }
                                }
                            }

                            MouseArea {
                                id: relShow2Mouse
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    MediaBackend.tuneSxmChannelNumber(4);
                                    relatedDrawer.closeModal();
                                }
                            }
                        }

                        // Show 3: Desi Hip-Hop Cypher
                        Rectangle {
                            width: parent.width
                            height: 84
                            radius: 14
                            color: relShow3Mouse.pressed ? Qt.rgba(255, 255, 255, 0.12) :
                                   (relShow3Mouse.containsMouse ? Qt.rgba(255, 255, 255, 0.08) : "#0F182B")
                            border.color: relShow3Mouse.containsMouse ? "#00E5FF" : Qt.rgba(255, 255, 255, 0.12)
                            border.width: 1
                            scale: relShow3Mouse.pressed ? 0.98 : 1.0
                            Behavior on scale { NumberAnimation { duration: 80 } }

                            Row {
                                anchors.left: parent.left
                                anchors.leftMargin: 18
                                anchors.right: parent.right
                                anchors.rightMargin: 18
                                anchors.verticalCenter: parent.verticalCenter
                                spacing: 16

                                Image {
                                    width: 88
                                    height: 42
                                    source: "qrc:/ApexVision/qml/assets/radio_logos/sxm_desihiphop.png"
                                    fillMode: Image.PreserveAspectFit
                                    smooth: true
                                    mipmap: true
                                    anchors.verticalCenter: parent.verticalCenter
                                }

                                Column {
                                    anchors.verticalCenter: parent.verticalCenter
                                    width: parent.width - 104
                                    spacing: 3

                                    Text {
                                        text: "Gully Gang Street Showcase"
                                        color: "#FFFFFF"
                                        font.family: "Inter"
                                        font.pixelSize: 15
                                        font.weight: Font.Bold
                                        elide: Text.ElideRight
                                        width: parent.width
                                    }
                                    Text {
                                        text: "Indian Underground Rap • Ch 37 Desi Hip-Hop"
                                        color: "#A78BFA"
                                        font.family: "Inter"
                                        font.pixelSize: 12
                                        font.weight: Font.Medium
                                        elide: Text.ElideRight
                                        width: parent.width
                                    }
                                }
                            }

                            MouseArea {
                                id: relShow3Mouse
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    MediaBackend.tuneSxmChannelNumber(37);
                                    relatedDrawer.closeModal();
                                }
                            }
                        }
                    }

                    // Right Column
                    Column {
                        width: (parent.width - 20) / 2
                        spacing: 14

                        // Show 4: Vice City Sunset Drive
                        Rectangle {
                            width: parent.width
                            height: 84
                            radius: 14
                            color: relShow4Mouse.pressed ? Qt.rgba(255, 255, 255, 0.12) :
                                   (relShow4Mouse.containsMouse ? Qt.rgba(255, 255, 255, 0.08) : "#0F182B")
                            border.color: relShow4Mouse.containsMouse ? "#00E5FF" : Qt.rgba(255, 255, 255, 0.12)
                            border.width: 1
                            scale: relShow4Mouse.pressed ? 0.98 : 1.0
                            Behavior on scale { NumberAnimation { duration: 80 } }

                            Row {
                                anchors.left: parent.left
                                anchors.leftMargin: 18
                                anchors.right: parent.right
                                anchors.rightMargin: 18
                                anchors.verticalCenter: parent.verticalCenter
                                spacing: 16

                                Image {
                                    width: 88
                                    height: 42
                                    source: "qrc:/ApexVision/qml/assets/radio_logos/sxm_gtaflash.png"
                                    fillMode: Image.PreserveAspectFit
                                    smooth: true
                                    mipmap: true
                                    anchors.verticalCenter: parent.verticalCenter
                                }

                                Column {
                                    anchors.verticalCenter: parent.verticalCenter
                                    width: parent.width - 104
                                    spacing: 3

                                    Text {
                                        text: "Vice City Sunset Drive with Toni"
                                        color: "#FFFFFF"
                                        font.family: "Inter"
                                        font.pixelSize: 15
                                        font.weight: Font.Bold
                                        elide: Text.ElideRight
                                        width: parent.width
                                    }
                                    Text {
                                        text: "80s Synth Mega Mix • Ch 25 GTA Vice City"
                                        color: "#F472B6"
                                        font.family: "Inter"
                                        font.pixelSize: 12
                                        font.weight: Font.Medium
                                        elide: Text.ElideRight
                                        width: parent.width
                                    }
                                }
                            }

                            MouseArea {
                                id: relShow4Mouse
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    MediaBackend.tuneSxmChannelNumber(25);
                                    relatedDrawer.closeModal();
                                }
                            }
                        }

                        // Show 5: Los Santos Rock Hour
                        Rectangle {
                            width: parent.width
                            height: 84
                            radius: 14
                            color: relShow5Mouse.pressed ? Qt.rgba(255, 255, 255, 0.12) :
                                   (relShow5Mouse.containsMouse ? Qt.rgba(255, 255, 255, 0.08) : "#0F182B")
                            border.color: relShow5Mouse.containsMouse ? "#00E5FF" : Qt.rgba(255, 255, 255, 0.12)
                            border.width: 1
                            scale: relShow5Mouse.pressed ? 0.98 : 1.0
                            Behavior on scale { NumberAnimation { duration: 80 } }

                            Row {
                                anchors.left: parent.left
                                anchors.leftMargin: 18
                                anchors.right: parent.right
                                anchors.rightMargin: 18
                                anchors.verticalCenter: parent.verticalCenter
                                spacing: 16

                                Image {
                                    width: 88
                                    height: 42
                                    source: "qrc:/ApexVision/qml/assets/radio_logos/sxm_gtalsrock.png"
                                    fillMode: Image.PreserveAspectFit
                                    smooth: true
                                    mipmap: true
                                    anchors.verticalCenter: parent.verticalCenter
                                }

                                Column {
                                    anchors.verticalCenter: parent.verticalCenter
                                    width: parent.width - 104
                                    spacing: 3

                                    Text {
                                        text: "Los Santos Rock Hour"
                                        color: "#FFFFFF"
                                        font.family: "Inter"
                                        font.pixelSize: 15
                                        font.weight: Font.Bold
                                        elide: Text.ElideRight
                                        width: parent.width
                                    }
                                    Text {
                                        text: "Hosted by Kenny Loggins • Ch 26 GTA V Rock"
                                        color: "#E879F9"
                                        font.family: "Inter"
                                        font.pixelSize: 12
                                        font.weight: Font.Medium
                                        elide: Text.ElideRight
                                        width: parent.width
                                    }
                                }
                            }

                            MouseArea {
                                id: relShow5Mouse
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    MediaBackend.tuneSxmChannelNumber(26);
                                    relatedDrawer.closeModal();
                                }
                            }
                        }

                        // Show 6: AIR National Samachar Bulletin
                        Rectangle {
                            width: parent.width
                            height: 84
                            radius: 14
                            color: relShow6Mouse.pressed ? Qt.rgba(255, 255, 255, 0.12) :
                                   (relShow6Mouse.containsMouse ? Qt.rgba(255, 255, 255, 0.08) : "#0F182B")
                            border.color: relShow6Mouse.containsMouse ? "#00E5FF" : Qt.rgba(255, 255, 255, 0.12)
                            border.width: 1
                            scale: relShow6Mouse.pressed ? 0.98 : 1.0
                            Behavior on scale { NumberAnimation { duration: 80 } }

                            Row {
                                anchors.left: parent.left
                                anchors.leftMargin: 18
                                anchors.right: parent.right
                                anchors.rightMargin: 18
                                anchors.verticalCenter: parent.verticalCenter
                                spacing: 16

                                Image {
                                    width: 88
                                    height: 42
                                    source: "qrc:/ApexVision/qml/assets/radio_logos/sxm_samachar.png"
                                    fillMode: Image.PreserveAspectFit
                                    smooth: true
                                    mipmap: true
                                    anchors.verticalCenter: parent.verticalCenter
                                }

                                Column {
                                    anchors.verticalCenter: parent.verticalCenter
                                    width: parent.width - 104
                                    spacing: 3

                                    Text {
                                        text: "AIR National Samachar Bulletin"
                                        color: "#FFFFFF"
                                        font.family: "Inter"
                                        font.pixelSize: 15
                                        font.weight: Font.Bold
                                        elide: Text.ElideRight
                                        width: parent.width
                                    }
                                    Text {
                                        text: "Hourly News & Current Affairs • Ch 114"
                                        color: "#38BDF8"
                                        font.family: "Inter"
                                        font.pixelSize: 12
                                        font.weight: Font.Medium
                                        elide: Text.ElideRight
                                        width: parent.width
                                    }
                                }
                            }

                            MouseArea {
                                id: relShow6Mouse
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    MediaBackend.tuneSxmChannelNumber(114);
                                    relatedDrawer.closeModal();
                                }
                            }
                        }
                    }
                }
            }
        }

        // Floating Mini Player Pill in Bottom Right Corner
        Rectangle {
            anchors.right: parent.right
            anchors.rightMargin: 28
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 20
            width: 290
            height: 56
            radius: 28
            color: Qt.rgba(12/255, 20/255, 36/255, 0.95)
            border.color: Qt.rgba(0, 229, 255, 0.35)
            border.width: 1
            z: 20

            Row {
                anchors.left: parent.left
                anchors.leftMargin: 14
                anchors.right: parent.right
                anchors.rightMargin: 12
                anchors.verticalCenter: parent.verticalCenter
                spacing: 12

                // Mini Station Logo
                Image {
                    width: 44
                    height: 24
                    source: MediaBackend.sxmChannelLogoUrl
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                    mipmap: true
                    anchors.verticalCenter: parent.verticalCenter
                }

                Column {
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width - 100
                    spacing: 2

                    Text {
                        text: MediaBackend.sxmArtist
                        color: "#FFFFFF"
                        font.family: "Inter"
                        font.pixelSize: 13
                        font.weight: Font.Bold
                        elide: Text.ElideRight
                        width: parent.width
                    }
                    Text {
                        text: MediaBackend.sxmSongTitle
                        color: "#94A3B8"
                        font.family: "Inter"
                        font.pixelSize: 11
                        elide: Text.ElideRight
                        width: parent.width
                    }
                }

                // Pause/Play Button Circle
                Rectangle {
                    width: 36
                    height: 36
                    radius: 18
                    color: relPlayMouse.pressed ? Qt.rgba(0, 229, 255, 0.3) : Qt.rgba(255, 255, 255, 0.15)
                    border.color: Qt.rgba(255, 255, 255, 0.25)
                    border.width: 1
                    anchors.verticalCenter: parent.verticalCenter

                    Text {
                        anchors.centerIn: parent
                        text: MediaBackend.isPlaying ? "❚❚" : "▶"
                        color: "#FFFFFF"
                        font.pixelSize: 12
                    }

                    MouseArea {
                        id: relPlayMouse
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: MediaBackend.togglePlay()
                    }
                }
            }
        }
    }

    // =========================================================================
    // SIRIUSXM CHANNELS VIEW (Exact Match to User Reference Image 3)
    // =========================================================================
    Rectangle {
        id: channelsViewModal
        objectName: "channelsViewModal"
        anchors.fill: parent
        color: "#070C18"
        property bool isOpen: false
        visible: isOpen
        opacity: isOpen ? 1.0 : 0.0
        z: 100

        function openModal() {
            isOpen = true;
            if (channelsFullListView) channelsFullListView.updatePaging();
        }

        function closeModal() {
            isOpen = false;
        }

        Behavior on opacity { NumberAnimation { duration: 200 } }

        // 1. Top Header Row: Back Arrow + "SiriusXM Channels"
        Item {
            id: channelsHeader
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: 76

            Row {
                anchors.left: parent.left
                anchors.leftMargin: 28
                anchors.verticalCenter: parent.verticalCenter
                spacing: 18

                // Signature IVI Back Button
                Item {
                    width: 44
                    height: 44
                    anchors.verticalCenter: parent.verticalCenter

                    Text {
                        anchors.centerIn: parent
                        text: "←"
                        color: channelsBackMouse.pressed ? "#00D2FF" : (channelsBackMouse.containsMouse ? "#FFFFFF" : "#E2E8F0")
                        font.family: "Inter"
                        font.pixelSize: 28
                        font.weight: Font.DemiBold
                        scale: channelsBackMouse.pressed ? 0.90 : 1.0
                        Behavior on scale { NumberAnimation { duration: 80 } }
                        Behavior on color { ColorAnimation { duration: 100 } }
                    }

                    MouseArea {
                        id: channelsBackMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: channelsViewModal.closeModal()
                    }
                }

                Text {
                    text: "OrbitXM Channels"
                    color: "#FFFFFF"
                    font.family: "Inter"
                    font.pixelSize: 22
                    font.weight: Font.Bold
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }

        // 2. Horizontal Channels Carousel
        Item {
            id: channelsCarouselArea
            anchors.top: channelsHeader.bottom
            anchors.topMargin: 28
            anchors.left: parent.left
            anchors.right: parent.right
            height: 250

            ListView {
                id: channelsFullListView
                anchors.fill: parent
                anchors.leftMargin: 36
                anchors.rightMargin: 36
                orientation: ListView.Horizontal
                spacing: 18
                clip: true
                boundsBehavior: Flickable.DragAndOvershootBounds
                flickDeceleration: 1600
                maximumFlickVelocity: 3500
                pixelAligned: true
                model: MediaBackend.sxmChannels

                Behavior on contentX {
                    enabled: !channelsFullListView.dragging && !channelsFullListView.flicking
                    NumberAnimation { duration: 320; easing.type: Easing.OutCubic }
                }

                function updatePaging() {
                    if (width <= 0) return;
                    var idx = MediaBackend.currentSxmChannelIndex;
                    if (idx < 0) return;
                    var slotWidth = 175 + 18; // 193
                    var itemsPerPage = Math.max(1, Math.floor((width + 18) / slotWidth));
                    var targetPage = Math.floor(idx / itemsPerPage);
                    var targetX = targetPage * itemsPerPage * slotWidth;
                    var maxX = Math.max(0, contentWidth - width);
                    contentX = Math.max(0, Math.min(maxX, targetX));
                }

                delegate: Item {
                    width: 175
                    height: 250

                    readonly property bool isCurrent: modelData.number === MediaBackend.sxmChannelNumber

                    Column {
                        anchors.centerIn: parent
                        spacing: 14

                        // Channel Card
                        Rectangle {
                            width: 175
                            height: 165
                            radius: 16
                            color: isCurrent ? Qt.rgba(255, 109, 0, 0.12) : "#0F182B"

                            // SIGNATURE CORAL / ORANGE BORDER ON ACTIVE CARD (from Image 3)
                            border.color: isCurrent ? "#FF6D00" : Qt.rgba(255, 255, 255, 0.14)
                            border.width: isCurrent ? 2.5 : 1

                            scale: chCardMouse.pressed ? 0.95 : (chCardMouse.containsMouse ? 1.02 : 1.0)
                            Behavior on scale { NumberAnimation { duration: 100 } }
                            Behavior on border.color { ColorAnimation { duration: 150 } }

                            Column {
                                anchors.centerIn: parent
                                spacing: 14
                                width: parent.width - 24

                                // Channel Official Logo (Normalized identical size container for all channels)
                                Image {
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    width: 150
                                    height: 62
                                    source: modelData.logoUrl || ""
                                    fillMode: Image.PreserveAspectFit
                                    smooth: true
                                    mipmap: true
                                }

                                // Station Tagline (e.g. "Today's pop hits", "Acoustic, stripped down songs")
                                Text {
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    text: modelData.tagline || modelData.name
                                    color: "#FFFFFF"
                                    font.family: "Inter"
                                    font.pixelSize: 13
                                    font.weight: Font.Medium
                                    horizontalAlignment: Text.AlignHCenter
                                    wrapMode: Text.WordWrap
                                    maximumLineCount: 2
                                    elide: Text.ElideRight
                                    width: parent.width
                                }
                            }

                            MouseArea {
                                id: chCardMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                preventStealing: false
                                onClicked: {
                                    MediaBackend.tuneSxmChannelNumber(modelData.number);
                                    channelsViewModal.closeModal();
                                }
                            }
                        }

                        // Channel Number Below Card (from Image 3: "1", "2", "3", "4", "5")
                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: modelData.number
                            color: isCurrent ? "#FFFFFF" : "#94A3B8"
                            font.family: "Inter"
                            font.pixelSize: 22
                            font.weight: Font.Bold
                        }
                    }
                }
            }
        }

        // 3. Currently Playing Track Line Below Cards (from Image 3: "Gigi Perez - Sailor Song")
        Text {
            anchors.top: channelsCarouselArea.bottom
            anchors.topMargin: 20
            anchors.horizontalCenter: parent.horizontalCenter
            text: (MediaBackend.sxmArtist && MediaBackend.sxmSongTitle) ?
                  (MediaBackend.sxmArtist + " - " + MediaBackend.sxmSongTitle) :
                  (MediaBackend.sxmChannelName + " • Live Broadcast")
            color: "#FFFFFF"
            font.family: "Inter"
            font.pixelSize: 20
            font.weight: Font.DemiBold
            elide: Text.ElideRight
            width: parent.width - 80
            horizontalAlignment: Text.AlignHCenter
        }

        // 4. Bottom Controls Row (from Image 3: <CH, CH>, Categories, Direct Tune)
        Row {
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 32
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 24

            // <CH Button
            Rectangle {
                width: 90
                height: 44
                radius: 22
                color: modalPrevChMouse.pressed ? Qt.rgba(255, 255, 255, 0.20) : Qt.rgba(255, 255, 255, 0.08)
                border.color: Qt.rgba(255, 255, 255, 0.18)
                border.width: 1

                Row {
                    anchors.centerIn: parent
                    spacing: 4
                    Image {
                        width: 14
                        height: 14
                        source: "qrc:/ApexVision/qml/assets/icons/chevron_left_white.svg"
                        fillMode: Image.PreserveAspectFit
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    Text {
                        text: "CH"
                        color: "#FFFFFF"
                        font.family: "Inter"
                        font.pixelSize: 14
                        font.weight: Font.Bold
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                MouseArea {
                    id: modalPrevChMouse
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: MediaBackend.prevSxmChannel()
                }
            }

            // CH> Button
            Rectangle {
                width: 90
                height: 44
                radius: 22
                color: modalNextChMouse.pressed ? Qt.rgba(255, 255, 255, 0.20) : Qt.rgba(255, 255, 255, 0.08)
                border.color: Qt.rgba(255, 255, 255, 0.18)
                border.width: 1

                Row {
                    anchors.centerIn: parent
                    spacing: 4
                    Text {
                        text: "CH"
                        color: "#FFFFFF"
                        font.family: "Inter"
                        font.pixelSize: 14
                        font.weight: Font.Bold
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    Image {
                        width: 14
                        height: 14
                        source: "qrc:/ApexVision/qml/assets/icons/chevron_right_white.svg"
                        fillMode: Image.PreserveAspectFit
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                MouseArea {
                    id: modalNextChMouse
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: MediaBackend.nextSxmChannel()
                }
            }

            // Categories Button
            Rectangle {
                width: 130
                height: 44
                radius: 22
                color: catBtnMouse.pressed ? Qt.rgba(255, 255, 255, 0.20) : Qt.rgba(255, 255, 255, 0.08)
                border.color: Qt.rgba(255, 255, 255, 0.18)
                border.width: 1

                Text {
                    anchors.centerIn: parent
                    text: "Categories"
                    color: "#FFFFFF"
                    font.family: "Inter"
                    font.pixelSize: 14
                    font.weight: Font.Medium
                }

                MouseArea {
                    id: catBtnMouse
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        saveNotification.showToast("Category: " + MediaBackend.sxmCategory);
                    }
                }
            }

            // Direct Tune Button
            Rectangle {
                width: 140
                height: 44
                radius: 22
                color: tuneBtnMouse.pressed ? Qt.rgba(255, 255, 255, 0.20) : Qt.rgba(255, 255, 255, 0.08)
                border.color: Qt.rgba(255, 255, 255, 0.18)
                border.width: 1

                Row {
                    anchors.centerIn: parent
                    spacing: 8
                    Image {
                        width: 16
                        height: 16
                        source: "qrc:/ApexVision/qml/assets/icons/radio_keypad.svg"
                        fillMode: Image.PreserveAspectFit
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    Text {
                        text: "Direct Tune"
                        color: "#FFFFFF"
                        font.family: "Inter"
                        font.pixelSize: 14
                        font.weight: Font.Medium
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                MouseArea {
                    id: tuneBtnMouse
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        keypadModal.openModal();
                    }
                }
            }
        }
    }

    // -------------------------------------------------------------------------
    // DIRECT TUNE FULL VIEW (Matches Screenshot 1 & 2 exactly with centered Enter button)
    // -------------------------------------------------------------------------
    Item {
        id: keypadModal
        objectName: "keypadModal"
        anchors.fill: parent
        visible: opacity > 0.001
        opacity: 0.0
        z: 200

        property string enteredFreq: ""

        Behavior on opacity { NumberAnimation { duration: 220 } }

        function openKeypad() {
            enteredFreq = "";
            opacity = 1.0;
        }

        function closeKeypad() {
            opacity = 0.0;
        }

        // Master Default Background (Matches OEM Default Background)
        Image {
            anchors.fill: parent
            source: "qrc:/ApexVision/qml/assets/default_background.png"
            fillMode: Image.PreserveAspectCrop
            smooth: true
            z: 0
        }

        // Dark Cockpit Tint
        Rectangle {
            anchors.fill: parent
            color: Qt.rgba(5/255, 11/255, 22/255, 0.48)
            z: 1
        }

        // Mouse blocker: prevents clicks from leaking to AM screen below
        MouseArea {
            anchors.fill: parent
            z: 2
            onClicked: {}
        }

        // Header: Back Arrow, Blue Antenna Badge, "Direct Tune"
        Item {
            id: directTuneHeader
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: 72
            z: 10

            Row {
                anchors.left: parent.left
                anchors.leftMargin: 36
                anchors.verticalCenter: parent.verticalCenter
                spacing: 18

                // Back Arrow Button
                Item {
                    width: 44
                    height: 44
                    anchors.verticalCenter: parent.verticalCenter

                    Rectangle {
                        anchors.fill: parent
                        radius: 22
                        color: backMouse.pressed ? Qt.rgba(255, 255, 255, 0.16) :
                               (backMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.08) : "transparent")
                    }

                    Text {
                        anchors.centerIn: parent
                        text: "←"
                        color: "#FFFFFF"
                        font.family: "Inter"
                        font.pixelSize: 28
                        font.weight: Font.DemiBold
                    }

                    MouseArea {
                        id: backMouse
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: keypadModal.closeKeypad()
                    }
                }

                // Circular Badge with FM/AM Icon
                Rectangle {
                    width: 32
                    height: 32
                    radius: 16
                    color: "#1E88E5"
                    anchors.verticalCenter: parent.verticalCenter

                    Image {
                        anchors.centerIn: parent
                        width: 18
                        height: 18
                        source: MediaBackend.source === "AM" ? "qrc:/ApexVision/qml/assets/icons/radio_am.svg" : "qrc:/ApexVision/qml/assets/icons/radio_fm.svg"
                        fillMode: Image.PreserveAspectFit
                        smooth: true
                    }
                }

                // "Direct Tune" Title
                Text {
                    text: "Direct Tune"
                    color: "#FFFFFF"
                    font.family: "Inter"
                    font.pixelSize: 22
                    font.weight: Font.DemiBold
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }

        // MAIN BODY: Keypad + Centered Enter Button (Left) | Frequency Display with Underline & (X) (Right)
        Item {
            anchors.top: directTuneHeader.bottom
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.topMargin: 10
            z: 10

            // LEFT SIDE: Keypad + Enter Pill Button
            Item {
                id: keypadSection
                anchors.left: parent.left
                anchors.leftMargin: 100
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: 10
                width: 340
                height: 430

                // 3-column Numeric Keypad
                Grid {
                    id: keypadGrid
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    columns: 3
                    rowSpacing: 14
                    columnSpacing: 14

                    Repeater {
                        model: [
                            "1", "2", "3",
                            "4", "5", "6",
                            "7", "8", "9",
                            ".", "0", "⌫"
                        ]

                        Item {
                            width: (keypadGrid.width - 28) / 3
                            height: 68

                            visible: modelData !== ""

                            Rectangle {
                                anchors.centerIn: parent
                                width: 68
                                height: 68
                                radius: 34
                                color: keyPressMouse.pressed ? Qt.rgba(255, 255, 255, 0.22) :
                                       (keyPressMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.08) : "transparent")
                                Behavior on color { ColorAnimation { duration: 100 } }
                            }

                            Text {
                                anchors.centerIn: parent
                                text: modelData === "⌫" ? "⌫" : modelData
                                color: "#FFFFFF"
                                font.family: "Inter"
                                font.pixelSize: 32
                                font.weight: Font.DemiBold
                            }

                            MouseArea {
                                id: keyPressMouse
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    if (modelData === "⌫") {
                                        if (keypadModal.enteredFreq.length > 0) {
                                            keypadModal.enteredFreq = keypadModal.enteredFreq.slice(0, -1);
                                        }
                                    } else if (modelData === ".") {
                                        if (!MediaBackend.isSxm && keypadModal.enteredFreq.indexOf(".") === -1 && keypadModal.enteredFreq.length > 0 && keypadModal.enteredFreq.length < 6) {
                                            keypadModal.enteredFreq += ".";
                                        }
                                    } else {
                                        if (keypadModal.enteredFreq.length < 6) {
                                            keypadModal.enteredFreq += modelData;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                // Centered "Enter" Button (Matches Screenshot 1 & 2: pill button right below keypad)
                Rectangle {
                    id: enterButton
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 8
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: 250
                    height: 52
                    radius: 14
                    color: keypadModal.enteredFreq.length > 0 ?
                           (enterMouse.pressed ? Qt.rgba(226/255, 169/255, 107/255, 0.25) : Qt.rgba(226/255, 169/255, 107/255, 0.12)) :
                           Qt.rgba(255, 255, 255, 0.05)
                    border.color: keypadModal.enteredFreq.length > 0 ? "#E2A96B" : Qt.rgba(255, 255, 255, 0.18)
                    border.width: keypadModal.enteredFreq.length > 0 ? 1.5 : 1

                    scale: enterMouse.pressed ? 0.95 : 1.0
                    Behavior on scale { NumberAnimation { duration: 80 } }
                    Behavior on border.color { ColorAnimation { duration: 150 } }

                    Text {
                        anchors.centerIn: parent
                        text: "Enter"
                        color: keypadModal.enteredFreq.length > 0 ? "#FFFFFF" : "#64748B"
                        font.family: "Inter"
                        font.pixelSize: 21
                        font.weight: Font.DemiBold
                    }

                    MouseArea {
                        id: enterMouse
                        anchors.fill: parent
                        enabled: keypadModal.enteredFreq.length > 0
                        cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
                        onClicked: {
                            if (MediaBackend.isSxm) {
                                MediaBackend.tuneSxmChannelNumber(parseInt(keypadModal.enteredFreq));
                            } else {
                                MediaBackend.tuneRadioFrequency(keypadModal.enteredFreq);
                            }
                            keypadModal.closeKeypad();
                        }
                    }
                }
            }

            // RIGHT SIDE: Frequency Display Line & Clear (X) Button (Matching Screenshot 1 & 2)
            Item {
                id: displayContainer
                anchors.left: keypadSection.right
                anchors.leftMargin: 120
                anchors.right: parent.right
                anchors.rightMargin: 80
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: -40
                height: 100

                Column {
                    anchors.fill: parent
                    spacing: 10

                    // Input Text and Clear Button Row
                    Item {
                        width: parent.width
                        height: 54

                        // Display text (Placeholder "Frequency" or Typed number with cursor)
                        Row {
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: 4

                            Text {
                                text: keypadModal.enteredFreq.length > 0 ? keypadModal.enteredFreq : (MediaBackend.isSxm ? "Channel #" : "Frequency")
                                color: keypadModal.enteredFreq.length > 0 ? "#FFFFFF" : "#94A3B8"
                                font.family: "Inter"
                                font.pixelSize: keypadModal.enteredFreq.length > 0 ? 40 : 32
                                font.weight: keypadModal.enteredFreq.length > 0 ? Font.Bold : Font.Normal
                                anchors.verticalCenter: parent.verticalCenter
                            }

                            // Blinking cursor | when typing
                            Rectangle {
                                width: 2
                                height: 36
                                color: "#E2A96B"
                                visible: keypadModal.enteredFreq.length > 0
                                anchors.verticalCenter: parent.verticalCenter

                                SequentialAnimation on opacity {
                                    loops: Animation.Infinite
                                    running: keypadModal.enteredFreq.length > 0
                                    NumberAnimation { to: 1.0; duration: 500 }
                                    NumberAnimation { to: 0.0; duration: 500 }
                                }
                            }
                        }

                        // Circular (X) Clear Button (Always visible on right side of underline)
                        Item {
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            width: 36
                            height: 36

                            Rectangle {
                                anchors.fill: parent
                                radius: 18
                                color: clearMouse.pressed ? Qt.rgba(255, 255, 255, 0.20) : "transparent"
                                border.color: Qt.rgba(255, 255, 255, 0.50)
                                border.width: 1.5
                            }

                            Text {
                                anchors.centerIn: parent
                                text: "✕"
                                color: "#FFFFFF"
                                font.family: "Inter"
                                font.pixelSize: 14
                                font.weight: Font.Bold
                            }

                            MouseArea {
                                id: clearMouse
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    keypadModal.enteredFreq = "";
                                }
                            }
                        }
                    }

                    // Clean Underline Line across the right display
                    Rectangle {
                        width: parent.width
                        height: 1.5
                        color: "#CBD5E1"
                    }
                }
            }
        }
    }

    // =========================================================================
    // 1. ORBITXM FULL CHANNEL GUIDE DRAWER (Real-time category & live online search)
    // =========================================================================
    Rectangle {
        id: channelGuideModal
        objectName: "channelGuideModal"
        anchors.left: parent.left
        anchors.leftMargin: 20
        anchors.top: topBar.bottom
        anchors.topMargin: 12
        anchors.bottom: presetBar.top
        anchors.bottomMargin: 12
        width: 460
        radius: 20
        color: Qt.rgba(11/255, 18/255, 34/255, 0.98)
        border.color: Qt.rgba(255, 255, 255, 0.22)
        border.width: 1.5
        visible: opacity > 0.001
        opacity: 0.0
        z: 110

        property string activeCategory: "All"
        property string filterText: ""
        readonly property bool isOnlineMode: activeCategory === "Online Radio" || (filterText.length > 0 && MediaBackend.onlineSearchResults.length > 0)

        Timer {
            id: onlineSearchDebounce
            interval: 400
            repeat: false
            onTriggered: {
                if (guideSearchInput.text.trim().length >= 2) {
                    MediaBackend.searchOnlineRadioStations(guideSearchInput.text.trim());
                }
            }
        }

        function openGuide() {
            channelGuideModal.opacity = 1.0;
            guideSearchInput.text = "";
            channelGuideModal.filterText = "";
        }

        function closeGuide() {
            channelGuideModal.opacity = 0.0;
        }

        Behavior on opacity { NumberAnimation { duration: 200 } }

        Column {
            anchors.fill: parent
            anchors.margins: 18
            spacing: 12

            // Top Header: Satellite Icon, Title & Close Button
            Row {
                width: parent.width

                Row {
                    spacing: 8
                    anchors.verticalCenter: parent.verticalCenter
                    Image {
                        width: 22
                        height: 22
                        source: "qrc:/ApexVision/qml/assets/radio_logos/orbitxm_logo.png"
                        fillMode: Image.PreserveAspectFit
                        smooth: true
                        mipmap: true
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    Text {
                        text: channelGuideModal.isOnlineMode ? "Worldwide Live Radio" : "OrbitXM Channel Guide"
                        color: "#FFFFFF"
                        font.family: "Inter"
                        font.pixelSize: 19
                        font.weight: Font.Bold
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                Item {
                    width: parent.width - 280
                    height: 1
                }

                Rectangle {
                    width: 32
                    height: 32
                    radius: 16
                    color: closeGuideMouse.pressed ? Qt.rgba(255, 255, 255, 0.20) : "transparent"
                    anchors.verticalCenter: parent.verticalCenter

                    Text {
                        anchors.centerIn: parent
                        text: "✕"
                        color: "#94A3B8"
                        font.pixelSize: 16
                        font.weight: Font.Bold
                    }

                    MouseArea {
                        id: closeGuideMouse
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: channelGuideModal.closeGuide()
                    }
                }
            }

            // Search Bar with Real-time Live Station Search
            Rectangle {
                width: parent.width
                height: 42
                radius: 21
                color: Qt.rgba(255, 255, 255, 0.08)
                border.color: guideSearchInput.activeFocus ? "#38BDF8" : Qt.rgba(255, 255, 255, 0.15)
                border.width: 1

                Row {
                    anchors.fill: parent
                    anchors.leftMargin: 14
                    anchors.rightMargin: 8
                    spacing: 8

                    Text {
                        text: "🔍"
                        font.pixelSize: 14
                        color: "#94A3B8"
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    TextInput {
                        id: guideSearchInput
                        width: parent.width - 150
                        height: parent.height
                        color: "#FFFFFF"
                        font.family: "Inter"
                        font.pixelSize: 14
                        verticalAlignment: TextInput.AlignVCenter
                        clip: true

                        Text {
                            text: "Search live stations, rock, bbc, hits..."
                            color: "#64748B"
                            font.family: "Inter"
                            font.pixelSize: 13
                            visible: guideSearchInput.text.length === 0
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        onTextChanged: {
                            channelGuideModal.filterText = guideSearchInput.text.trim();
                            if (guideSearchInput.text.trim().length >= 2) {
                                onlineSearchDebounce.restart();
                            }
                        }

                        onAccepted: {
                            if (guideSearchInput.text.trim().length > 0) {
                                MediaBackend.searchAndPlaySxm(guideSearchInput.text.trim());
                                MediaBackend.searchOnlineRadioStations(guideSearchInput.text.trim());
                                saveNotification.showToast("Searching live radio: " + guideSearchInput.text.trim());
                            }
                        }
                    }

                    // Online Search Button
                    Rectangle {
                        width: 78
                        height: 28
                        radius: 14
                        color: searchOnlineMouse.pressed ? Qt.rgba(56/255, 189/255, 248/255, 0.40) : Qt.rgba(56/255, 189/255, 248/255, 0.20)
                        border.color: "#38BDF8"
                        border.width: 1
                        anchors.verticalCenter: parent.verticalCenter

                        Text {
                            anchors.centerIn: parent
                            text: "Online"
                            color: "#38BDF8"
                            font.family: "Inter"
                            font.pixelSize: 11
                            font.weight: Font.Bold
                        }

                        MouseArea {
                            id: searchOnlineMouse
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                if (guideSearchInput.text.trim().length > 0) {
                                    MediaBackend.searchAndPlaySxm(guideSearchInput.text.trim());
                                    MediaBackend.searchOnlineRadioStations(guideSearchInput.text.trim());
                                    channelGuideModal.activeCategory = "Online Radio";
                                    saveNotification.showToast("Searching live radio: " + guideSearchInput.text.trim());
                                } else {
                                    channelGuideModal.activeCategory = "Online Radio";
                                    MediaBackend.searchOnlineRadioStations("Hits");
                                }
                            }
                        }
                    }
                }
            }

            // Categories Filter Chips
            Flickable {
                width: parent.width
                height: 34
                contentWidth: catRow.width
                clip: true
                boundsBehavior: Flickable.StopAtBounds

                Row {
                    id: catRow
                    spacing: 8
                    height: parent.height

                    Repeater {
                        model: ["All", "Online Radio", "Pop", "Rock", "80s", "Country", "EDM", "Hip-Hop", "Acoustic", "Jazz"]

                        Rectangle {
                            height: 30
                            width: catChipText.implicitWidth + 20
                            radius: 15
                            readonly property bool isSelected: channelGuideModal.activeCategory === modelData
                            color: isSelected ? "#38BDF8" :
                                   (catChipMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.12) : Qt.rgba(255, 255, 255, 0.06))
                            border.color: isSelected ? "#38BDF8" : Qt.rgba(255, 255, 255, 0.15)
                            border.width: 1
                            anchors.verticalCenter: parent.verticalCenter

                            Text {
                                id: catChipText
                                anchors.centerIn: parent
                                text: modelData === "Online Radio" ? "🌐 Live Radio" : modelData
                                color: parent.isSelected ? "#000000" : (modelData === "Online Radio" ? "#38BDF8" : "#E2E8F0")
                                font.family: "Inter"
                                font.pixelSize: 12
                                font.weight: parent.isSelected ? Font.Bold : Font.Medium
                            }

                            MouseArea {
                                id: catChipMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    channelGuideModal.activeCategory = modelData;
                                    if (modelData === "Online Radio" && MediaBackend.onlineSearchResults.length === 0) {
                                        MediaBackend.searchOnlineRadioStations("Hits");
                                    }
                                }
                            }
                        }
                    }
                }
            }

            Rectangle { width: parent.width; height: 1; color: Qt.rgba(255, 255, 255, 0.10) }

            // Searching indicator
            Row {
                width: parent.width
                height: 18
                visible: MediaBackend.isSearchingOnline
                spacing: 8

                Rectangle {
                    width: 10
                    height: 10
                    radius: 5
                    color: "#38BDF8"
                    anchors.verticalCenter: parent.verticalCenter
                    SequentialAnimation on opacity {
                        loops: Animation.Infinite
                        NumberAnimation { from: 0.3; to: 1.0; duration: 500 }
                        NumberAnimation { from: 1.0; to: 0.3; duration: 500 }
                    }
                }

                Text {
                    text: "Searching live radio stations around the world..."
                    color: "#38BDF8"
                    font.family: "Inter"
                    font.pixelSize: 12
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            // Channels List
            ListView {
                id: guideList
                width: parent.width
                height: parent.height - (MediaBackend.isSearchingOnline ? 172 : 146)
                clip: true
                spacing: 8
                model: channelGuideModal.isOnlineMode ? MediaBackend.onlineSearchResults : MediaBackend.sxmChannels

                delegate: Item {
                    id: channelItem
                    width: guideList.width

                    readonly property bool isOnlineItem: channelGuideModal.isOnlineMode
                    readonly property bool matchesCat: isOnlineItem ? true : (
                        channelGuideModal.activeCategory === "All" ||
                        modelData.category.toLowerCase().indexOf(channelGuideModal.activeCategory.toLowerCase()) !== -1 ||
                        modelData.name.toLowerCase().indexOf(channelGuideModal.activeCategory.toLowerCase()) !== -1
                    )

                    readonly property bool matchesSearch: isOnlineItem ? true : (
                        channelGuideModal.filterText === "" ||
                        modelData.name.toLowerCase().indexOf(channelGuideModal.filterText.toLowerCase()) !== -1 ||
                        modelData.category.toLowerCase().indexOf(channelGuideModal.filterText.toLowerCase()) !== -1 ||
                        ("" + modelData.number).indexOf(channelGuideModal.filterText) !== -1
                    )

                    readonly property bool isCurrent: isOnlineItem ? (MediaBackend.station === modelData.name) : (modelData.number === MediaBackend.sxmChannelNumber)

                    visible: matchesCat && matchesSearch
                    height: (matchesCat && matchesSearch) ? 62 : 0

                    Rectangle {
                        anchors.fill: parent
                        radius: 12
                        color: guideItemMouse.pressed ? Qt.rgba(255, 255, 255, 0.16) :
                               (guideItemMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.08) :
                               (isCurrent ? Qt.rgba(56/255, 189/255, 248/255, 0.14) : "transparent"))
                        border.color: isCurrent ? "#38BDF8" : Qt.rgba(255, 255, 255, 0.08)
                        border.width: isCurrent ? 1.5 : 1
                    }

                    Row {
                        anchors.left: parent.left
                        anchors.leftMargin: 12
                        anchors.right: parent.right
                        anchors.rightMargin: 12
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 12

                        // Badge Number or LIVE Badge
                        Rectangle {
                            width: isOnlineItem ? 46 : 38
                            height: 28
                            radius: 6
                            color: isOnlineItem ? "#10B981" : (modelData.badgeColor ? modelData.badgeColor : "#0284C7")
                            anchors.verticalCenter: parent.verticalCenter
                            Text {
                                anchors.centerIn: parent
                                text: isOnlineItem ? "LIVE" : modelData.number
                                color: "#FFFFFF"
                                font.weight: Font.Bold
                                font.pixelSize: isOnlineItem ? 11 : 13
                            }
                        }

                        // Info Column
                        Column {
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: 3
                            width: parent.width - (isOnlineItem ? 138 : 130)

                            Row {
                                spacing: 8
                                Text {
                                    text: modelData.name || "Station"
                                    color: "#FFFFFF"
                                    font.family: "Inter"
                                    font.pixelSize: 15
                                    font.weight: Font.Bold
                                    elide: Text.ElideRight
                                    width: Math.min(implicitWidth, channelItem.width - 200)
                                }
                                Rectangle {
                                    height: 18
                                    width: badgeText.width + 10
                                    radius: 9
                                    color: Qt.rgba(255, 255, 255, 0.10)
                                    anchors.verticalCenter: parent.verticalCenter
                                    Text {
                                        id: badgeText
                                        anchors.centerIn: parent
                                        text: isOnlineItem ? (modelData.bitrate ? (modelData.bitrate + " kbps") : "Online") : modelData.category
                                        color: "#94A3B8"
                                        font.pixelSize: 10
                                        font.weight: Font.Medium
                                    }
                                }
                            }

                            Text {
                                text: isOnlineItem ?
                                      ((modelData.country ? (modelData.country + " • ") : "") + (modelData.category || "Internet Radio")) :
                                      (modelData.tracks && modelData.tracks.length > 0 ?
                                       (modelData.tracks[0].title + " - " + modelData.tracks[0].artist) : "Live Broadcast")
                                color: "#CBD5E1"
                                font.family: "Inter"
                                font.pixelSize: 12
                                elide: Text.ElideRight
                                width: parent.width
                            }
                        }

                        // Tuned indicator / Play icon
                        Rectangle {
                            width: 24
                            height: 24
                            radius: 12
                            color: isCurrent ? "#38BDF8" : "transparent"
                            anchors.verticalCenter: parent.verticalCenter

                            Text {
                                anchors.centerIn: parent
                                text: isCurrent ? "▶" : ""
                                color: "#000000"
                                font.pixelSize: 11
                                font.weight: Font.Bold
                            }
                        }
                    }

                    MouseArea {
                        id: guideItemMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            if (isOnlineItem) {
                                MediaBackend.tuneOnlineStation(modelData.name, modelData.streamUrl, modelData.category);
                                channelGuideModal.closeGuide();
                                saveNotification.showToast("Streaming live: " + modelData.name);
                            } else {
                                MediaBackend.tuneSxmChannelNumber(modelData.number);
                                channelGuideModal.closeGuide();
                                saveNotification.showToast("Tuned to Ch " + modelData.number + " " + modelData.name);
                            }
                        }
                    }
                }
            }
        }
    }

    // =========================================================================
    // 2. AUDIO DSP / EQUALIZER DRAWER (Sound sliders from reference image)
    // =========================================================================
    Rectangle {
        id: audioDspModal
        objectName: "audioDspModal"
        anchors.right: parent.right
        anchors.rightMargin: 20
        anchors.top: topBar.bottom
        anchors.topMargin: 12
        anchors.bottom: presetBar.top
        anchors.bottomMargin: 12
        width: 410
        radius: 20
        color: Qt.rgba(11/255, 18/255, 34/255, 0.98)
        border.color: Qt.rgba(255, 255, 255, 0.22)
        border.width: 1.5
        visible: opacity > 0.001
        opacity: 0.0
        z: 110

        property int bassVal: 2
        property int midVal: 0
        property int trebleVal: 3
        property bool surroundEnabled: true
        property bool speedCompEnabled: true
        property string activePreset: "Studio"

        Behavior on opacity { NumberAnimation { duration: 200 } }

        Column {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 16

            // Header
            Row {
                width: parent.width
                Row {
                    spacing: 8
                    anchors.verticalCenter: parent.verticalCenter
                    Text {
                        text: "🎚"
                        font.pixelSize: 18
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    Text {
                        text: "Audio DSP & Equalizer"
                        color: "#FFFFFF"
                        font.family: "Inter"
                        font.pixelSize: 19
                        font.weight: Font.Bold
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                Item { width: parent.width - 270; height: 1 }

                Rectangle {
                    width: 32
                    height: 32
                    radius: 16
                    color: closeDspMouse.pressed ? Qt.rgba(255, 255, 255, 0.20) : "transparent"
                    anchors.verticalCenter: parent.verticalCenter

                    Text {
                        anchors.centerIn: parent
                        text: "✕"
                        color: "#94A3B8"
                        font.pixelSize: 16
                        font.weight: Font.Bold
                    }

                    MouseArea {
                        id: closeDspMouse
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: audioDspModal.opacity = 0.0
                    }
                }
            }

            Text {
                text: "Apex Studio Hi-Fi DSP Processing"
                color: "#94A3B8"
                font.family: "Inter"
                font.pixelSize: 13
            }

            Rectangle { width: parent.width; height: 1; color: Qt.rgba(255, 255, 255, 0.10) }

            // Preset Chips
            Row {
                spacing: 8
                Repeater {
                    model: ["Studio", "Concert", "Acoustic", "Bass+", "Flat"]

                    Rectangle {
                        height: 28
                        width: dspChipText.implicitWidth + 16
                        radius: 14
                        readonly property bool isSelected: audioDspModal.activePreset === modelData
                        color: isSelected ? "#38BDF8" : Qt.rgba(255, 255, 255, 0.08)
                        border.color: isSelected ? "#38BDF8" : Qt.rgba(255, 255, 255, 0.15)
                        border.width: 1

                        Text {
                            id: dspChipText
                            anchors.centerIn: parent
                            text: modelData
                            color: parent.isSelected ? "#000000" : "#FFFFFF"
                            font.family: "Inter"
                            font.pixelSize: 12
                            font.weight: parent.isSelected ? Font.Bold : Font.Medium
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                audioDspModal.activePreset = modelData;
                                if (modelData === "Studio") {
                                    audioDspModal.bassVal = 2; audioDspModal.midVal = 0; audioDspModal.trebleVal = 3;
                                } else if (modelData === "Concert") {
                                    audioDspModal.bassVal = 4; audioDspModal.midVal = 1; audioDspModal.trebleVal = 4;
                                } else if (modelData === "Acoustic") {
                                    audioDspModal.bassVal = 1; audioDspModal.midVal = 3; audioDspModal.trebleVal = 2;
                                } else if (modelData === "Bass+") {
                                    audioDspModal.bassVal = 6; audioDspModal.midVal = -1; audioDspModal.trebleVal = 2;
                                } else {
                                    audioDspModal.bassVal = 0; audioDspModal.midVal = 0; audioDspModal.trebleVal = 0;
                                }
                                saveNotification.showToast("Audio Profile: " + modelData);
                            }
                        }
                    }
                }
            }

            // Equalizer Sliders: Bass, Mid, Treble
            Column {
                width: parent.width
                spacing: 14

                // Bass Slider
                Column {
                    width: parent.width
                    spacing: 6
                    Row {
                        width: parent.width
                        Text { text: "Bass"; color: "#E2E8F0"; font.family: "Inter"; font.pixelSize: 14; font.weight: Font.DemiBold }
                        Item { width: parent.width - 90; height: 1 }
                        Text {
                            text: (audioDspModal.bassVal > 0 ? "+" : "") + audioDspModal.bassVal + " dB"
                            color: "#38BDF8"
                            font.family: "Inter"
                            font.pixelSize: 14
                            font.weight: Font.Bold
                        }
                    }
                    Rectangle {
                        width: parent.width; height: 8; radius: 4; color: Qt.rgba(255, 255, 255, 0.15)
                        Rectangle {
                            height: parent.height; radius: 4
                            width: parent.width * ((audioDspModal.bassVal + 6) / 12.0)
                            color: "#38BDF8"
                        }
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: function(mouse) {
                                audioDspModal.bassVal = Math.round((mouse.x / width) * 12) - 6;
                            }
                        }
                    }
                }

                // Midrange Slider
                Column {
                    width: parent.width
                    spacing: 6
                    Row {
                        width: parent.width
                        Text { text: "Midrange"; color: "#E2E8F0"; font.family: "Inter"; font.pixelSize: 14; font.weight: Font.DemiBold }
                        Item { width: parent.width - 120; height: 1 }
                        Text {
                            text: (audioDspModal.midVal > 0 ? "+" : "") + audioDspModal.midVal + " dB"
                            color: "#38BDF8"
                            font.family: "Inter"
                            font.pixelSize: 14
                            font.weight: Font.Bold
                        }
                    }
                    Rectangle {
                        width: parent.width; height: 8; radius: 4; color: Qt.rgba(255, 255, 255, 0.15)
                        Rectangle {
                            height: parent.height; radius: 4
                            width: parent.width * ((audioDspModal.midVal + 6) / 12.0)
                            color: "#38BDF8"
                        }
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: function(mouse) {
                                audioDspModal.midVal = Math.round((mouse.x / width) * 12) - 6;
                            }
                        }
                    }
                }

                // Treble Slider
                Column {
                    width: parent.width
                    spacing: 6
                    Row {
                        width: parent.width
                        Text { text: "Treble"; color: "#E2E8F0"; font.family: "Inter"; font.pixelSize: 14; font.weight: Font.DemiBold }
                        Item { width: parent.width - 100; height: 1 }
                        Text {
                            text: (audioDspModal.trebleVal > 0 ? "+" : "") + audioDspModal.trebleVal + " dB"
                            color: "#38BDF8"
                            font.family: "Inter"
                            font.pixelSize: 14
                            font.weight: Font.Bold
                        }
                    }
                    Rectangle {
                        width: parent.width; height: 8; radius: 4; color: Qt.rgba(255, 255, 255, 0.15)
                        Rectangle {
                            height: parent.height; radius: 4
                            width: parent.width * ((audioDspModal.trebleVal + 6) / 12.0)
                            color: "#38BDF8"
                        }
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: function(mouse) {
                                audioDspModal.trebleVal = Math.round((mouse.x / width) * 12) - 6;
                            }
                        }
                    }
                }
            }

            Rectangle { width: parent.width; height: 1; color: Qt.rgba(255, 255, 255, 0.10) }

            // Spatial 3D Audio Toggle
            Row {
                width: parent.width
                Column {
                    width: parent.width - 60
                    spacing: 2
                    Text { text: "3D Spatial Surround"; color: "#FFFFFF"; font.family: "Inter"; font.pixelSize: 14; font.weight: Font.DemiBold }
                    Text { text: "Simulates immersive acoustic staging"; color: "#94A3B8"; font.family: "Inter"; font.pixelSize: 12 }
                }

                Rectangle {
                    width: 44; height: 24; radius: 12
                    color: audioDspModal.surroundEnabled ? "#10B981" : Qt.rgba(255, 255, 255, 0.20)
                    Rectangle {
                        width: 20; height: 20; radius: 10; color: "#FFFFFF"
                        x: audioDspModal.surroundEnabled ? 22 : 2
                        anchors.verticalCenter: parent.verticalCenter
                        Behavior on x { NumberAnimation { duration: 150 } }
                    }
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: audioDspModal.surroundEnabled = !audioDspModal.surroundEnabled
                    }
                }
            }

            // Speed-Compensated Volume Toggle
            Row {
                width: parent.width
                Column {
                    width: parent.width - 60
                    spacing: 2
                    Text { text: "Speed-Compensated Volume"; color: "#FFFFFF"; font.family: "Inter"; font.pixelSize: 14; font.weight: Font.DemiBold }
                    Text { text: "Adapts audio output to highway road noise"; color: "#94A3B8"; font.family: "Inter"; font.pixelSize: 12 }
                }

                Rectangle {
                    width: 44; height: 24; radius: 12
                    color: audioDspModal.speedCompEnabled ? "#10B981" : Qt.rgba(255, 255, 255, 0.20)
                    Rectangle {
                        width: 20; height: 20; radius: 10; color: "#FFFFFF"
                        x: audioDspModal.speedCompEnabled ? 22 : 2
                        anchors.verticalCenter: parent.verticalCenter
                        Behavior on x { NumberAnimation { duration: 150 } }
                    }
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: audioDspModal.speedCompEnabled = !audioDspModal.speedCompEnabled
                    }
                }
            }
        }
    }

    // =========================================================================
    // 3. DRIVER PROFILE MODAL (From top-right profile icon)
    // =========================================================================
    Rectangle {
        id: driverProfileModal
        anchors.right: parent.right
        anchors.rightMargin: 40
        anchors.top: topBar.bottom
        anchors.topMargin: 8
        width: 280
        height: 190
        radius: 18
        color: Qt.rgba(11/255, 18/255, 34/255, 0.98)
        border.color: Qt.rgba(255, 255, 255, 0.22)
        border.width: 1.5
        visible: false
        z: 120

        Column {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 10

            Row {
                spacing: 10
                anchors.left: parent.left
                Rectangle {
                    width: 36; height: 36; radius: 18; color: "#0284C7"
                    Image {
                        anchors.centerIn: parent
                        width: 20; height: 20
                        source: "qrc:/ApexVision/qml/assets/icons/setting_profile_white.png"
                        fillMode: Image.PreserveAspectFit
                    }
                }
                Column {
                    anchors.verticalCenter: parent.verticalCenter
                    Text { text: "Driver 1 (Active)"; color: "#FFFFFF"; font.family: "Inter"; font.pixelSize: 15; font.weight: Font.Bold }
                    Text { text: "Custom Audio Presets Synced"; color: "#10B981"; font.family: "Inter"; font.pixelSize: 11 }
                }
            }

            Rectangle { width: parent.width; height: 1; color: Qt.rgba(255, 255, 255, 0.10) }

            Text { text: "• OrbitXM VIP Subscription: Active"; color: "#38BDF8"; font.family: "Inter"; font.pixelSize: 12 }
            Text { text: "• Hi-Res AAC Studio Streaming: 320 kbps"; color: "#CBD5E1"; font.family: "Inter"; font.pixelSize: 12 }
            Text { text: "• Cloud Saved Favorites: 12 Stations"; color: "#CBD5E1"; font.family: "Inter"; font.pixelSize: 12 }

            Rectangle {
                width: parent.width; height: 28; radius: 14
                color: Qt.rgba(255, 255, 255, 0.10)
                Text { anchors.centerIn: parent; text: "Close Profile"; color: "#FFFFFF"; font.family: "Inter"; font.pixelSize: 12; font.weight: Font.Medium }
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: driverProfileModal.visible = false
                }
            }
        }
    }

    // -------------------------------------------------------------------------
    // PRESET TOAST NOTIFICATION
    // -------------------------------------------------------------------------
    Rectangle {
        id: saveNotification
        anchors.bottom: presetBar.top
        anchors.bottomMargin: 16
        anchors.horizontalCenter: parent.horizontalCenter
        width: notifText.implicitWidth + 36
        height: 38
        radius: 19
        color: Qt.rgba(15/255, 23/255, 42/255, 0.95)
        border.color: Qt.rgba(255, 255, 255, 0.25)
        border.width: 1
        opacity: 0.0
        z: 999

        Behavior on opacity { NumberAnimation { duration: 180 } }

        Text {
            id: notifText
            anchors.centerIn: parent
            text: ""
            color: "#FFFFFF"
            font.family: "Inter"
            font.pixelSize: 14
            font.weight: Font.Medium
        }

        Timer {
            id: notifTimer
            interval: 1800
            onTriggered: saveNotification.opacity = 0.0
        }

        function showToast(msg) {
            notifText.text = msg;
            saveNotification.opacity = 1.0;
            notifTimer.restart();
        }
    }
}
