/**
 * ==============================================================================
 * Project: Apex VISION IVI - Digital Cockpit & Infotainment System
 * File: MediaCard.qml
 * Author / Developer: Sk Rehan Ahamed
 * License: MIT
 * ==============================================================================
 */

import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import ApexVision
import ".."

Item {
    id: root

    signal openPlayerRequested()
    signal sourceMenuRequested()
    signal openProfileRequested()

    Column {
        anchors.fill: parent
        spacing: 16

        // ----------------------------------------------------
        // TOP ROW: Phone Connection Card + Preset ("P1")
        // ----------------------------------------------------
        Row {
            width: parent.width
            height: 96
            spacing: 16

            // 1. Phone Connection Card ("Add phone" or Connected state) - Left side
            Rectangle {
                id: phoneCard
                width: parent.width - 96 - 16
                height: 96
                radius: 18
                clip: true
                gradient: Gradient {
                    GradientStop {
                        position: 0.0
                        color: phoneMouse.pressed ?
                            Qt.rgba(215/255, 238/255, 255/255, 0.32) :
                            (phoneMouse.containsMouse ? Qt.rgba(225/255, 242/255, 255/255, 0.24) : Qt.rgba(215/255, 238/255, 255/255, 0.17))
                    }
                    GradientStop {
                        position: 1.0
                        color: phoneMouse.pressed ?
                            Qt.rgba(195/255, 225/255, 255/255, 0.26) :
                            (phoneMouse.containsMouse ? Qt.rgba(205/255, 232/255, 255/255, 0.18) : Qt.rgba(195/255, 225/255, 255/255, 0.11))
                    }
                }
                border.color: MediaBackend.phoneConnected ?
                              Qt.rgba(56, 189, 248, 0.65) :
                              (phoneMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.65) : Qt.rgba(225/255, 242/255, 255/255, 0.36))
                border.width: 1

                scale: phoneMouse.pressed ? 0.98 : (phoneMouse.containsMouse ? 1.015 : 1.0)
                Behavior on scale { NumberAnimation { duration: 150; easing.type: Easing.OutQuad } }

                Column {
                    anchors.centerIn: parent
                    spacing: 8

                    Image {
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 26
                        height: 26
                        fillMode: Image.PreserveAspectFit
                        source: MediaBackend.phoneConnected ?
                                "qrc:/ApexVision/qml/assets/icons/bluetooth.svg" :
                                "qrc:/ApexVision/qml/assets/icons/phone_add.svg"
                    }

                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: MediaBackend.phoneConnected ?
                              MediaBackend.connectedPhoneName : "Add phone"
                        color: "#F2F5F7"
                        font.family: "Inter"
                        font.pixelSize: 16
                        font.weight: Font.DemiBold
                        renderType: Text.NativeRendering
                    }
                }

                MouseArea {
                    id: phoneMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        MediaBackend.togglePhoneConnection();
                    }
                }
            }

            // 2. Driver Profile Box ("P1") - Right side
            Rectangle {
                id: profileBox
                width: 96
                height: 96
                radius: 18
                clip: true
                gradient: Gradient {
                    GradientStop {
                        position: 0.0
                        color: profileMouse.pressed ?
                            Qt.rgba(215/255, 238/255, 255/255, 0.32) :
                            (profileMouse.containsMouse ? Qt.rgba(225/255, 242/255, 255/255, 0.24) : Qt.rgba(215/255, 238/255, 255/255, 0.17))
                    }
                    GradientStop {
                        position: 1.0
                        color: profileMouse.pressed ?
                            Qt.rgba(195/255, 225/255, 255/255, 0.26) :
                            (profileMouse.containsMouse ? Qt.rgba(205/255, 232/255, 255/255, 0.18) : Qt.rgba(195/255, 225/255, 255/255, 0.11))
                    }
                }
                border.color: profileMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.65) : Qt.rgba(225/255, 242/255, 255/255, 0.36)
                border.width: 1

                scale: profileMouse.pressed ? 0.98 : (profileMouse.containsMouse ? 1.015 : 1.0)
                Behavior on scale { NumberAnimation { duration: 150; easing.type: Easing.OutQuad } }

                Column {
                    anchors.centerIn: parent
                    spacing: 4

                    // Profile Avatar / Monogram (52x52)
                    Item {
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 52
                        height: 52

                        // Image Avatar
                        Item {
                            anchors.fill: parent
                            visible: VehicleBackend.driverProfileAvatarPath !== ""

                            Image {
                                id: cardAvatarImg
                                anchors.fill: parent
                                source: VehicleBackend.driverProfileAvatarPath
                                fillMode: Image.PreserveAspectCrop
                                visible: false
                            }
                            Rectangle {
                                id: cardAvatarMask
                                anchors.fill: parent
                                radius: 26
                                visible: false
                                layer.enabled: true
                            }
                            MultiEffect {
                                anchors.fill: parent
                                source: cardAvatarImg
                                maskEnabled: true
                                maskSource: cardAvatarMask
                            }
                            Rectangle {
                                anchors.fill: parent
                                radius: 26
                                color: "transparent"
                                border.color: Qt.rgba(255, 255, 255, 0.45)
                                border.width: 1.5
                            }
                        }

                        // Monogram Circle (when avatar is monogram or empty)
                        Rectangle {
                            anchors.fill: parent
                            radius: 26
                            visible: VehicleBackend.driverProfileAvatarPath === ""
                            gradient: Gradient {
                                GradientStop { position: 0.0; color: "#2563EB" }
                                GradientStop { position: 1.0; color: "#1D4ED8" }
                            }
                            border.color: Qt.rgba(255, 255, 255, 0.40)
                            border.width: 1.5

                            Text {
                                anchors.centerIn: parent
                                text: VehicleBackend.driverProfile
                                color: "#F2F5F7"
                                font.family: "Inter"
                                font.pixelSize: VehicleBackend.driverProfile.length > 2 ? 14 : 18
                                font.weight: Font.DemiBold
                                renderType: Text.NativeRendering
                            }
                        }
                    }

                    // Profile Name Text below avatar
                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 84
                        text: VehicleBackend.driverProfileName
                        color: "#E2E8F0"
                        font.family: "Inter"
                        font.pixelSize: 11
                        font.weight: Font.Medium
                        horizontalAlignment: Text.AlignHCenter
                        elide: Text.ElideRight
                        renderType: Text.NativeRendering
                    }
                }

                MouseArea {
                    id: profileMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        root.openProfileRequested();
                    }
                }
            }
        }

        // ----------------------------------------------------
        // MAIN MEDIA CARD
        // ----------------------------------------------------
        Rectangle {
            id: mainMediaCard
            width: parent.width
            height: parent.height - 96 - 16
            radius: 18
            clip: true
            gradient: Gradient {
                GradientStop {
                    position: 0.0
                    color: cardClickMouse.pressed ? Qt.rgba(215/255, 238/255, 255/255, 0.22) : Qt.rgba(215/255, 238/255, 255/255, 0.17)
                }
                GradientStop {
                    position: 1.0
                    color: cardClickMouse.pressed ? Qt.rgba(195/255, 225/255, 255/255, 0.15) : Qt.rgba(195/255, 225/255, 255/255, 0.11)
                }
            }
            border.color: Qt.rgba(225/255, 242/255, 255/255, 0.36)
            border.width: 1

            // Click card to open full player (RadioPage for AM)
            MouseArea {
                id: cardClickMouse
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    root.openPlayerRequested();
                }
            }

            // Source Selector Pill on Top-Left: ((•)) ▾ (Matching Screenshot 2)
            Rectangle {
                id: sourcePill
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.margins: 20
                width: sourceRow.width + 24
                height: 44
                radius: 22
                color: sourceMouse.pressed ? Qt.rgba(215/255, 238/255, 255/255, 0.30) : Qt.rgba(215/255, 238/255, 255/255, 0.18)
                border.color: Qt.rgba(225/255, 242/255, 255/255, 0.36)
                border.width: 1
                scale: sourceMouse.pressed ? 0.94 : 1.0
                Behavior on scale { NumberAnimation { duration: 100 } }
                z: 20

                Row {
                    id: sourceRow
                    anchors.centerIn: parent
                    spacing: 8

                    // Circular Icon (OrbitXM Favicon replaces satellite icon)
                    Rectangle {
                        width: 24
                        height: 24
                        radius: 12
                        color: MediaBackend.isSxm ? "transparent" : "#1E88E5"
                        anchors.verticalCenter: parent.verticalCenter

                        Image {
                            anchors.centerIn: parent
                            width: MediaBackend.isSxm ? 24 : 14
                            height: MediaBackend.isSxm ? 24 : 14
                            fillMode: Image.PreserveAspectFit
                            smooth: true
                            mipmap: true
                            source: MediaBackend.isSxm ? "qrc:/ApexVision/qml/assets/radio_logos/orbitxm_logo.png" :
                                   (MediaBackend.source === "AM" ? "qrc:/ApexVision/qml/assets/icons/radio_am.svg" :
                                   (MediaBackend.source === "FM" ? "qrc:/ApexVision/qml/assets/icons/radio_fm.svg" :
                                   (MediaBackend.source === "USB" ? "qrc:/ApexVision/qml/assets/icons/usb_source.svg" :
                                   (MediaBackend.source === "Bluetooth" ? "qrc:/ApexVision/qml/assets/icons/bluetooth.svg" :
                                   "qrc:/ApexVision/qml/assets/icons/radio_source.svg"))))
                        }
                    }

                    Text {
                        visible: MediaBackend.isSxm
                        text: "OrbitXM"
                        color: "#FFFFFF"
                        font.family: "Inter"
                        font.pixelSize: 14
                        font.weight: Font.DemiBold
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Text {
                        visible: !MediaBackend.isSxm
                        text: MediaBackend.source === "Bluetooth" ? "BT" : (MediaBackend.source === "USB" ? "USB" : MediaBackend.source)
                        color: "#FFFFFF"
                        font.family: "Inter"
                        font.pixelSize: 14
                        font.weight: Font.DemiBold
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Text {
                        text: "▾"
                        color: "#93C5FD"
                        font.pixelSize: 12
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                MouseArea {
                    id: sourceMouse
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        root.sourceMenuRequested();
                    }
                }
            }

            // Center Content: Artwork + Track / Station Info
            Column {
                anchors.top: sourcePill.bottom
                anchors.topMargin: 10
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: transportRow.top
                spacing: 12

                // 1. Artwork Card with Soft Glow and Glass Sheen
                Item {
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: 136
                    height: 136

                    // Ambient glow behind artwork (Sleek cyan glow matching OrbitXM)
                    Rectangle {
                        anchors.centerIn: parent
                        width: 144
                        height: 144
                        radius: 28
                        color: Qt.rgba(0, 180/255, 255/255, 0.20)
                        visible: MediaBackend.isPlaying
                    }

                    // True Rounded Corner Mask for Artwork
                    Rectangle {
                        id: mediaCardMask
                        anchors.fill: parent
                        radius: 24
                        visible: false
                        layer.enabled: true
                    }

                    Item {
                        anchors.fill: parent
                        layer.enabled: true
                        layer.effect: MultiEffect {
                            maskEnabled: true
                            maskSource: mediaCardMask
                        }

                        Rectangle {
                            anchors.fill: parent
                            color: MediaBackend.isSxm ? Qt.rgba(15/255, 30/255, 70/255, 0.7) : Qt.rgba(20/255, 45/255, 95/255, 0.55)
                            gradient: Gradient {
                                GradientStop { position: 0.0; color: MediaBackend.isSxm ? Qt.rgba(15/255, 30/255, 70/255, 0.7) : Qt.rgba(20/255, 45/255, 95/255, 0.55) }
                                GradientStop { position: 1.0; color: MediaBackend.isSxm ? Qt.rgba(15/255, 30/255, 70/255, 0.7) : Qt.rgba(10/255, 25/255, 60/255, 0.75) }
                            }
                            border.color: Qt.rgba(255, 255, 255, 0.20)
                            border.width: 1.5
                        }

                        Image {
                            id: cardArtImgPrev
                            anchors.fill: parent
                            source: ""
                            fillMode: Image.PreserveAspectCrop
                            smooth: true
                            mipmap: true
                            visible: MediaBackend.isSxm && source !== "" && cardArtImg.status !== Image.Ready
                        }

                        Image {
                            id: cardArtImg
                            anchors.fill: parent
                            visible: MediaBackend.isSxm && source != ""
                            source: MediaBackend.sxmArtworkUrl
                            fillMode: Image.PreserveAspectCrop
                            smooth: true
                            mipmap: true
                            opacity: status === Image.Ready ? 1.0 : 0.0
                            Behavior on opacity { NumberAnimation { duration: 180 } }
                            onStatusChanged: {
                                if (status === Image.Ready) {
                                    cardArtImgPrev.source = source;
                                }
                            }
                        }

                        Image {
                            anchors.centerIn: parent
                            width: 72
                            height: 72
                            visible: !MediaBackend.isSxm || (MediaBackend.sxmArtworkUrl === "" && cardArtImgPrev.source === "")
                            source: (MediaBackend.isRadio || MediaBackend.source === "AM" || MediaBackend.source === "FM") ?
                                    "qrc:/ApexVision/qml/assets/icons/music_note_coral.svg" :
                                    "qrc:/ApexVision/qml/assets/icons/radio_source.svg"
                            fillMode: Image.PreserveAspectFit
                            smooth: true
                            mipmap: true
                        }
                    }
                }

                // 2. Channel Logo / Live Pill Row (ONLY for OrbitXM)
                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 8
                    visible: MediaBackend.isSxm

                    // OrbitXM Logo
                    Image {
                        visible: MediaBackend.isSxm
                        height: 40
                        width: (implicitHeight > 0) ? Math.min(110, Math.round(height * implicitWidth / implicitHeight)) : 90
                        source: MediaBackend.sxmChannelLogoUrl
                        fillMode: Image.PreserveAspectFit
                        smooth: true
                        mipmap: true
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    // Modern Live Pill (Glowing Glass + Radiating Waves SVG + Pulsing Signal + Bold White Text)
                    Rectangle {
                        width: 68
                        height: 24
                        radius: 12
                        gradient: Gradient {
                            orientation: Gradient.Horizontal
                            GradientStop { position: 0.0; color: Qt.rgba(255/255, 46/255, 76/255, 0.28) }
                            GradientStop { position: 1.0; color: Qt.rgba(220/255, 38/255, 38/255, 0.20) }
                        }
                        border.color: Qt.rgba(255/255, 77/255, 106/255, 0.80)
                        border.width: 1
                        anchors.verticalCenter: parent.verticalCenter

                        Row {
                            anchors.centerIn: parent
                            spacing: 5

                            // Radiating Waves Broadcast SVG Icon with live pulse animation
                            Item {
                                width: 14
                                height: 14
                                anchors.verticalCenter: parent.verticalCenter

                                Image {
                                    anchors.fill: parent
                                    source: "qrc:/ApexVision/qml/assets/icons/icon_live_broadcast.svg"
                                    fillMode: Image.PreserveAspectFit
                                }

                                SequentialAnimation on opacity {
                                    loops: Animation.Infinite
                                    running: true
                                    NumberAnimation { to: 0.35; duration: 850; easing.type: Easing.InOutQuad }
                                    NumberAnimation { to: 1.0; duration: 850; easing.type: Easing.InOutQuad }
                                }
                            }

                            Text {
                                text: "LIVE"
                                color: "#FFFFFF"
                                font.family: "Inter"
                                font.pixelSize: 10
                                font.weight: Font.Bold
                                font.letterSpacing: 0.8
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }
                    }
                }

                // 3. Station Name / Track Title
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: MediaBackend.isSxm ? (MediaBackend.sxmSongTitle || "") :
                          (MediaBackend.isAm ? MediaBackend.amStationName : MediaBackend.station)
                    color: "#FFFFFF"
                    font.family: "Inter"
                    font.pixelSize: MediaBackend.isSxm ? 22 : 26
                    font.weight: MediaBackend.isSxm ? Font.Bold : Font.DemiBold
                    elide: Text.ElideRight
                    width: parent.width - 32
                    horizontalAlignment: Text.AlignHCenter
                }

                // 4. Artist Name (High-Contrast Crisp Bright Silver-White - OrbitXM only)
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    visible: MediaBackend.isSxm
                    text: MediaBackend.sxmArtist || ""
                    color: "#F8FAFC"
                    font.family: "Inter"
                    font.pixelSize: 16
                    font.weight: 600
                    elide: Text.ElideRight
                    width: parent.width - 32
                    horizontalAlignment: Text.AlignHCenter
                }

                // 5. Channel Badge / Frequency Info (Electric Sky Cyan for OrbitXM, Silver-Slate for AM/FM)
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: MediaBackend.isSxm ? ("Ch " + MediaBackend.sxmChannelNumber + " • " + MediaBackend.sxmChannelName) :
                          (MediaBackend.isAm ?
                           (MediaBackend.amFrequency + " kHz • " + MediaBackend.amStationCity) :
                           (MediaBackend.source === "FM" ?
                            (MediaBackend.frequency + " MHz" + (MediaBackend.trackTitle && MediaBackend.trackTitle !== MediaBackend.station ? " • " + MediaBackend.trackTitle : "")) :
                            (MediaBackend.frequency + " MHz")))
                    color: MediaBackend.isSxm ? "#38BDF8" : "#94A3B8"
                    font.family: "Inter"
                    font.pixelSize: MediaBackend.isSxm ? 13 : 17
                    font.weight: MediaBackend.isSxm ? 600 : Font.Medium
                    elide: Text.ElideRight
                    width: parent.width - 32
                    horizontalAlignment: Text.AlignHCenter
                }
            }

            // Bottom Transport Controls: |<< (Prev) and >>| (Next)
            Item {
                id: transportRow
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 32
                anchors.horizontalCenter: parent.horizontalCenter
                width: 260
                height: 64
                z: 20

                Row {
                    anchors.centerIn: parent
                    spacing: (MediaBackend.isRadio && !MediaBackend.isSxm) ? 110 : 60

                    // Previous Button |<<
                    Item {
                        width: 56
                        height: 56
                        anchors.verticalCenter: parent.verticalCenter

                        Image {
                            anchors.centerIn: parent
                            width: 32
                            height: 32
                            fillMode: Image.PreserveAspectFit
                            source: "qrc:/ApexVision/qml/assets/icons/skip_prev.svg"
                            opacity: prevMouse.pressed ? 0.6 : 0.95
                        }

                        scale: prevMouse.pressed ? 0.9 : 1.0
                        Behavior on scale { NumberAnimation { duration: 80 } }

                        MouseArea {
                            id: prevMouse
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: MediaBackend.isSxm ? MediaBackend.prevSxmChannel() : MediaBackend.previous()
                        }
                    }

                    // Play/Pause Center Button (Hidden for AM and FM radio)
                    Item {
                        width: MediaBackend.isRadio ? 0 : 56
                        height: 56
                        anchors.verticalCenter: parent.verticalCenter
                        visible: !MediaBackend.isRadio

                        Image {
                            anchors.centerIn: parent
                            width: 34
                            height: 34
                            fillMode: Image.PreserveAspectFit
                            source: MediaBackend.isPlaying ?
                                    "qrc:/ApexVision/qml/assets/icons/pause.svg" :
                                    "qrc:/ApexVision/qml/assets/icons/play.svg"
                            opacity: playMouse.pressed ? 0.6 : 1.0
                        }

                        scale: playMouse.pressed ? 0.9 : 1.0
                        Behavior on scale { NumberAnimation { duration: 80 } }

                        MouseArea {
                            id: playMouse
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: MediaBackend.togglePlay()
                        }
                    }

                    // Next Button >>|
                    Item {
                        width: 56
                        height: 56
                        anchors.verticalCenter: parent.verticalCenter

                        Image {
                            anchors.centerIn: parent
                            width: 32
                            height: 32
                            fillMode: Image.PreserveAspectFit
                            source: "qrc:/ApexVision/qml/assets/icons/skip_next.svg"
                            opacity: nextMouse.pressed ? 0.6 : 0.95
                        }

                        scale: nextMouse.pressed ? 0.9 : 1.0
                        Behavior on scale { NumberAnimation { duration: 80 } }

                        MouseArea {
                            id: nextMouse
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: MediaBackend.isSxm ? MediaBackend.nextSxmChannel() : MediaBackend.next()
                        }
                    }
                }
            }
        }
    }
}
