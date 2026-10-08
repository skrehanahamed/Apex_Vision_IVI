/**
 * ==============================================================================
 * Project: Apex VISION IVI - Digital Cockpit & Infotainment System
 * File: GamesPage.qml
 * Author / Developer: Sk Rehan Ahamed
 * License: MIT
 * ==============================================================================
 */

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import ApexVision

Item {
    id: root
    objectName: "gamesPage"

    signal backRequested()

    property string activeGame: "" // "" = Gallery, "racer" = Apex Cyber Racer

    // =========================================================================
    // 1. MASTER DEFAULT BACKGROUND (Matches IVI system wallpaper)
    // =========================================================================
    Image {
        id: bgImage
        anchors.fill: parent
        source: "qrc:/ApexVision/qml/assets/default_background.png"
        fillMode: Image.PreserveAspectCrop
        smooth: true
        z: 0
    }

    // Subtle scrim so default background colors stay vibrant while ensuring high contrast
    Rectangle {
        anchors.fill: parent
        color: Qt.rgba(0, 0, 0, 0.18)
        z: 0
    }

    // =========================================================================
    // 2. TOP HEADER BAR (VehicleBar Theme & Clean Navigation)
    // =========================================================================
    Item {
        id: headerBar
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.topMargin: 28
        anchors.leftMargin: 36
        anchors.rightMargin: 36
        height: 52
        visible: root.activeGame === ""
        z: 10

        // Signature IVI Back Button
        Item {
            id: backBtn
            width: 38
            height: 38
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left

            Text {
                anchors.centerIn: parent
                text: "←"
                font.family: "Inter"
                font.pixelSize: 26
                font.weight: Font.DemiBold
                color: backMouse.pressed ? "#00D2FF" : (backMouse.containsMouse ? "#FFFFFF" : "#E2E8F0")
                scale: backMouse.pressed ? 0.90 : 1.0
                Behavior on scale { NumberAnimation { duration: 80 } }
                Behavior on color { ColorAnimation { duration: 100 } }
            }

            MouseArea {
                id: backMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: root.backRequested()
            }
        }

        // Logo after Back Button
        Image {
            id: headerBrandLogo
            anchors.left: backBtn.right
            anchors.leftMargin: 16
            anchors.verticalCenter: parent.verticalCenter
            width: 36
            height: 36
            source: "qrc:/ApexVision/qml/assets/icons/app_games.svg"
            fillMode: Image.PreserveAspectFit
            smooth: true
            mipmap: true
            sourceSize: Qt.size(128, 128)
        }

        // Title and Subtitle Column
        Column {
            anchors.left: headerBrandLogo.right
            anchors.leftMargin: 14
            anchors.verticalCenter: parent.verticalCenter
            spacing: 2

            Text {
                text: "Games"
                color: "#FFFFFF"
                font.family: "Inter"
                font.pixelSize: 22
                font.weight: Font.DemiBold
            }

            Text {
                text: "In-Cabin Cockpit Entertainment"
                color: Qt.rgba(225/255, 238/255, 255/255, 0.70)
                font.family: "Inter"
                font.pixelSize: 13
            }
        }
    }

    // =========================================================================
    // 3. MAIN GALLERY VIEW (APP-STYLE GAME ICONS & SHORT NAMES)
    // =========================================================================
    Item {
        id: galleryContentArea
        anchors.top: headerBar.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.topMargin: 28
        anchors.leftMargin: 48
        anchors.rightMargin: 48
        anchors.bottomMargin: 30
        visible: root.activeGame === ""
        z: 5

        Row {
            anchors.left: parent.left
            anchors.top: parent.top
            spacing: 40

            // -------------------------------------------------------------
            // GAME 1: RACER
            // -------------------------------------------------------------
            Item {
                id: racerItem
                width: 100
                height: 120

                Column {
                    anchors.centerIn: parent
                    spacing: 12

                    Item {
                        id: racerIconContainer
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 76
                        height: 76

                        scale: racerMouse.pressed ? 0.90 : (racerMouse.containsMouse ? 1.05 : 1.0)
                        Behavior on scale {
                            NumberAnimation {
                                duration: 160
                                easing.type: Easing.OutBack
                                easing.overshoot: 1.2
                            }
                        }

                        Image {
                            anchors.fill: parent
                            source: "qrc:/ApexVision/qml/assets/icons/game_retro_racer.svg"
                            fillMode: Image.PreserveAspectFit
                            smooth: true
                            mipmap: true
                            sourceSize: Qt.size(256, 256)
                        }
                    }

                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "Racer"
                        color: "#FFFFFF"
                        font.family: "Inter"
                        font.pixelSize: 15
                        font.weight: Font.Medium
                        horizontalAlignment: Text.AlignHCenter
                        opacity: racerMouse.pressed ? 0.75 : 1.0
                        Behavior on opacity { NumberAnimation { duration: 120 } }
                    }
                }

                MouseArea {
                    id: racerMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        if (typeof SystemBackend !== "undefined") {
                            SystemBackend.playTouchSound();
                        }
                        root.activeGame = "racer";
                    }
                }
            }

            // -------------------------------------------------------------
            // GAME 2: 2048
            // -------------------------------------------------------------
            Item {
                id: puzzleItem
                width: 100
                height: 120

                Column {
                    anchors.centerIn: parent
                    spacing: 12

                    Item {
                        id: puzzleIconContainer
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 76
                        height: 76

                        scale: puzzleMouse.pressed ? 0.90 : (puzzleMouse.containsMouse ? 1.05 : 1.0)
                        Behavior on scale {
                            NumberAnimation {
                                duration: 160
                                easing.type: Easing.OutBack
                                easing.overshoot: 1.2
                            }
                        }

                        Image {
                            anchors.fill: parent
                            source: "qrc:/ApexVision/qml/assets/icons/game_retro_2048.svg"
                            fillMode: Image.PreserveAspectFit
                            smooth: true
                            mipmap: true
                            sourceSize: Qt.size(256, 256)
                        }
                    }

                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "2048"
                        color: "#FFFFFF"
                        font.family: "Inter"
                        font.pixelSize: 15
                        font.weight: Font.Medium
                        horizontalAlignment: Text.AlignHCenter
                        opacity: puzzleMouse.pressed ? 0.75 : 1.0
                        Behavior on opacity { NumberAnimation { duration: 120 } }
                    }
                }

                MouseArea {
                    id: puzzleMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        if (typeof SystemBackend !== "undefined") {
                            SystemBackend.playTouchSound();
                        }
                    }
                }
            }

            // -------------------------------------------------------------
            // GAME 3: ENDLESS HELICOPTER
            // -------------------------------------------------------------
            Item {
                id: heliItem
                width: 100
                height: 120

                Column {
                    anchors.centerIn: parent
                    spacing: 12

                    Item {
                        id: heliIconContainer
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 76
                        height: 76

                        scale: heliMouse.pressed ? 0.90 : (heliMouse.containsMouse ? 1.05 : 1.0)
                        Behavior on scale {
                            NumberAnimation {
                                duration: 160
                                easing.type: Easing.OutBack
                                easing.overshoot: 1.2
                            }
                        }

                        Image {
                            anchors.fill: parent
                            source: "qrc:/ApexVision/qml/assets/icons/game_helicopter.png"
                            onStatusChanged: {
                                if (status === Image.Error && source.toString().indexOf(".svg") === -1) {
                                    source = "qrc:/ApexVision/qml/assets/icons/game_helicopter.svg";
                                }
                            }
                            fillMode: Image.PreserveAspectFit
                            smooth: true
                            mipmap: true
                            sourceSize: Qt.size(256, 256)
                        }
                    }

                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "Helicopter"
                        color: "#FFFFFF"
                        font.family: "Inter"
                        font.pixelSize: 15
                        font.weight: Font.Medium
                        horizontalAlignment: Text.AlignHCenter
                        opacity: heliMouse.pressed ? 0.75 : 1.0
                        Behavior on opacity { NumberAnimation { duration: 120 } }
                    }
                }

                MouseArea {
                    id: heliMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        if (typeof SystemBackend !== "undefined") {
                            SystemBackend.playTouchSound();
                        }
                        root.activeGame = "helicopter";
                    }
                }
            }
        }
    }

    // =========================================================================
    // 4. ACTIVE GAME CONTAINERS
    // =========================================================================
    Loader {
        id: racerGameLoader
        anchors.fill: parent
        active: root.activeGame === "racer"
        visible: root.activeGame === "racer"
        z: 50
        source: (root.activeGame === "racer") ? "ApexCyberRacer.qml" : ""

        onLoaded: {
            if (item) {
                item.exitRequested.connect(function() {
                    root.activeGame = "";
                });
                item.forceActiveFocus();
            }
        }
    }

    Loader {
        id: helicopterGameLoader
        anchors.fill: parent
        active: root.activeGame === "helicopter"
        visible: root.activeGame === "helicopter"
        z: 50
        source: (root.activeGame === "helicopter") ? "HelicopterGameView.qml" : ""

        onLoaded: {
            if (item) {
                item.exitRequested.connect(function() {
                    root.activeGame = "";
                });
                item.forceActiveFocus();
            }
        }
    }
}
