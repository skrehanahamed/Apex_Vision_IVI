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
                text: "Arcade Games"
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

        // Right Status Pill (2 Games Available)
        Rectangle {
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            height: 36
            width: statusRow.width + 28
            radius: 18
            clip: true

            gradient: Gradient {
                GradientStop { position: 0.0; color: Qt.rgba(0, 210/255, 255/255, 0.22) }
                GradientStop { position: 1.0; color: Qt.rgba(0, 119/255, 182/255, 0.16) }
            }

            border.color: Qt.rgba(0, 210/255, 255/255, 0.55)
            border.width: 1

            Row {
                id: statusRow
                anchors.centerIn: parent
                spacing: 8

                Rectangle {
                    width: 8
                    height: 8
                    radius: 4
                    anchors.verticalCenter: parent.verticalCenter
                    color: "#00F0FF"
                }

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: "Retro Arcade Edition"
                    color: "#E0F2FE"
                    font.family: "Inter"
                    font.pixelSize: 13
                    font.weight: Font.DemiBold
                }
            }
        }
    }

    // =========================================================================
    // 3. MAIN GALLERY VIEW (2 RETRO GAME CARDS)
    // =========================================================================
    Item {
        id: galleryContentArea
        anchors.top: headerBar.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.topMargin: 20
        anchors.bottomMargin: 30
        visible: root.activeGame === ""
        z: 5

        Row {
            anchors.centerIn: parent
            spacing: 40

            // -------------------------------------------------------------
            // GAME CARD 1: APEX CYBER RACER
            // -------------------------------------------------------------
            Rectangle {
                id: racerCard
                width: 260
                height: 260
                radius: 28
                clip: true

                gradient: Gradient {
                    GradientStop {
                        position: 0.0
                        color: racerMouse.containsMouse ? Qt.rgba(0, 240/255, 255/255, 0.22) : Qt.rgba(215/255, 238/255, 255/255, 0.14)
                    }
                    GradientStop {
                        position: 1.0
                        color: racerMouse.containsMouse ? Qt.rgba(255/255, 0, 127/255, 0.18) : Qt.rgba(195/255, 225/255, 255/255, 0.08)
                    }
                }

                border.color: racerMouse.containsMouse ? "#00F0FF" : Qt.rgba(225/255, 242/255, 255/255, 0.32)
                border.width: racerMouse.containsMouse ? 2 : 1.2
                scale: racerMouse.pressed ? 0.95 : (racerMouse.containsMouse ? 1.03 : 1.0)
                Behavior on scale { NumberAnimation { duration: 130; easing.type: Easing.OutCubic } }
                Behavior on border.color { ColorAnimation { duration: 140 } }

                Column {
                    anchors.centerIn: parent
                    spacing: 16

                    Image {
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 124
                        height: 124
                        source: "qrc:/ApexVision/qml/assets/icons/game_retro_racer.svg"
                        fillMode: Image.PreserveAspectFit
                        smooth: true
                        mipmap: true
                    }

                    Column {
                        anchors.horizontalCenter: parent.horizontalCenter
                        spacing: 4

                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "Cyber Racer"
                            color: "#FFFFFF"
                            font.family: "Inter"
                            font.pixelSize: 18
                            font.weight: Font.Bold
                        }

                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "Arcade"
                            color: "#00F0FF"
                            font.family: "monospace"
                            font.pixelSize: 12
                            font.weight: Font.DemiBold
                        }
                    }
                }

                MouseArea {
                    id: racerMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        root.activeGame = "racer";
                    }
                }
            }

            // -------------------------------------------------------------
            // GAME CARD 2: 2048: CYBER FUSION
            // -------------------------------------------------------------
            Rectangle {
                id: puzzleCard
                width: 260
                height: 260
                radius: 28
                clip: true

                gradient: Gradient {
                    GradientStop {
                        position: 0.0
                        color: puzzleMouse.containsMouse ? Qt.rgba(139/255, 92/255, 246/255, 0.22) : Qt.rgba(215/255, 238/255, 255/255, 0.14)
                    }
                    GradientStop {
                        position: 1.0
                        color: puzzleMouse.containsMouse ? Qt.rgba(16/255, 185/255, 129/255, 0.18) : Qt.rgba(195/255, 225/255, 255/255, 0.08)
                    }
                }

                border.color: puzzleMouse.containsMouse ? "#8B5CF6" : Qt.rgba(225/255, 242/255, 255/255, 0.32)
                border.width: puzzleMouse.containsMouse ? 2 : 1.2
                scale: puzzleMouse.pressed ? 0.95 : (puzzleMouse.containsMouse ? 1.03 : 1.0)
                Behavior on scale { NumberAnimation { duration: 130; easing.type: Easing.OutCubic } }
                Behavior on border.color { ColorAnimation { duration: 140 } }

                Column {
                    anchors.centerIn: parent
                    spacing: 16

                    Image {
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 124
                        height: 124
                        source: "qrc:/ApexVision/qml/assets/icons/game_retro_2048.svg"
                        fillMode: Image.PreserveAspectFit
                        smooth: true
                        mipmap: true
                    }

                    Column {
                        anchors.horizontalCenter: parent.horizontalCenter
                        spacing: 4

                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "2048 Fusion"
                            color: "#FFFFFF"
                            font.family: "Inter"
                            font.pixelSize: 18
                            font.weight: Font.Bold
                        }

                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "Puzzle"
                            color: "#8B5CF6"
                            font.family: "monospace"
                            font.pixelSize: 12
                            font.weight: Font.DemiBold
                        }
                    }
                }

                MouseArea {
                    id: puzzleMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                }
            }
        }
    }

    // =========================================================================
    // 4. ACTIVE GAME CONTAINER: APEX CYBER RACER
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
}
