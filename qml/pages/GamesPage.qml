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
        color: Qt.rgba(0, 0, 0, 0.12)
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
        z: 10

        // Signature IVI Back Button (Card removed as requested)
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
                text: "In-Cabin Entertainment"
                color: Qt.rgba(225/255, 238/255, 255/255, 0.70)
                font.family: "Inter"
                font.pixelSize: 13
            }
        }

        // Right Status Pill (Coming Soon badge)
        Rectangle {
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            height: 36
            width: statusRow.width + 28
            radius: 18
            clip: true

            gradient: Gradient {
                GradientStop {
                    position: 0.0
                    color: Qt.rgba(245/255, 158/255, 11/255, 0.22)
                }
                GradientStop {
                    position: 1.0
                    color: Qt.rgba(217/255, 119/255, 6/255, 0.16)
                }
            }

            border.color: Qt.rgba(245/255, 158/255, 11/255, 0.55)
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
                    color: "#F59E0B"
                }

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: "Coming Soon"
                    color: "#FDE68A"
                    font.family: "Inter"
                    font.pixelSize: 13
                    font.weight: Font.DemiBold
                }
            }
        }
    }

    // =========================================================================
    // 3. MAIN CONTENT AREA (VehicleMenuCard Frosted Glass Aesthetic)
    // =========================================================================
    Item {
        id: contentArea
        anchors.top: headerBar.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.topMargin: 28
        anchors.bottomMargin: 40
        z: 5

        Column {
            anchors.centerIn: parent
            spacing: 20
            width: 540

            // Clean standalone Games logo without enclosing card
            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                width: 80
                height: 80
                source: "qrc:/ApexVision/qml/assets/icons/app_games.svg"
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
                    text: "Games"
                    color: "#FFFFFF"
                    font.family: "Inter"
                    font.pixelSize: 24
                    font.weight: Font.DemiBold
                }

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "In-cabin interactive gaming and entertainment experiences are coming soon in a future over-the-air software update."
                    color: Qt.rgba(225/255, 238/255, 255/255, 0.70)
                    font.family: "Inter"
                    font.pixelSize: 14
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: Text.WordWrap
                    width: parent.width - 40
                }
            }

            // Divider line after the about section
            Rectangle {
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width - 40
                height: 1
                color: Qt.rgba(255, 255, 255, 0.16)
            }

            // Status Card (VehicleMenuCard Frosted Glass Theme - No straight line)
            Rectangle {
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width
                height: 82
                radius: 18
                clip: true

                gradient: Gradient {
                    GradientStop {
                        position: 0.0
                        color: Qt.rgba(215/255, 238/255, 255/255, 0.17)
                    }
                    GradientStop {
                        position: 1.0
                        color: Qt.rgba(195/255, 225/255, 255/255, 0.11)
                    }
                }

                border.color: Qt.rgba(225/255, 242/255, 255/255, 0.36)
                border.width: 1

                Row {
                    anchors.fill: parent
                    anchors.leftMargin: 20
                    anchors.rightMargin: 20
                    spacing: 16

                    Rectangle {
                        width: 40
                        height: 40
                        radius: 20
                        color: Qt.rgba(245/255, 158/255, 11/255, 0.20)
                        border.color: Qt.rgba(245/255, 158/255, 11/255, 0.45)
                        border.width: 1
                        anchors.verticalCenter: parent.verticalCenter

                        Image {
                            anchors.centerIn: parent
                            width: 22
                            height: 22
                            source: "qrc:/ApexVision/qml/assets/icons/app_games.svg"
                            fillMode: Image.PreserveAspectFit
                        }
                    }

                    Column {
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 2
                        width: parent.width - 70

                        Text {
                            text: "Feature in Active Development"
                            color: "#FFFFFF"
                            font.family: "Inter"
                            font.pixelSize: 15
                            font.weight: Font.DemiBold
                        }

                        Text {
                            text: "Requires vehicle in Park (P) • Coming in version 2.2 OTA"
                            color: Qt.rgba(225/255, 238/255, 255/255, 0.65)
                            font.family: "Inter"
                            font.pixelSize: 12
                            elide: Text.ElideRight
                            width: parent.width
                        }
                    }
                }
            }

            // Feature Highlights Preview Card (VehicleMenuCard Theme - No straight line)
            Rectangle {
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width
                height: 140
                radius: 18
                clip: true

                gradient: Gradient {
                    GradientStop { position: 0.0; color: Qt.rgba(215/255, 238/255, 255/255, 0.14) }
                    GradientStop { position: 1.0; color: Qt.rgba(195/255, 225/255, 255/255, 0.09) }
                }

                border.color: Qt.rgba(225/255, 242/255, 255/255, 0.26)
                border.width: 1

                Column {
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 10

                    Text {
                        text: "Planned in-cabin gaming features:"
                        color: "#E2E8F0"
                        font.family: "Inter"
                        font.pixelSize: 13
                        font.weight: Font.DemiBold
                    }

                    Row {
                        spacing: 12
                        Rectangle {
                            width: 6; height: 6; radius: 3
                            color: "#F59E0B"
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        Text {
                            text: "Touchscreen arcade classics and puzzle titles while parked"
                            color: Qt.rgba(225/255, 238/255, 255/255, 0.80)
                            font.family: "Inter"
                            font.pixelSize: 12
                        }
                    }

                    Row {
                        spacing: 12
                        Rectangle {
                            width: 6; height: 6; radius: 3
                            color: "#F59E0B"
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        Text {
                            text: "Bluetooth wireless game controller synchronization"
                            color: Qt.rgba(225/255, 238/255, 255/255, 0.80)
                            font.family: "Inter"
                            font.pixelSize: 12
                        }
                    }

                    Row {
                        spacing: 12
                        Rectangle {
                            width: 6; height: 6; radius: 3
                            color: "#F59E0B"
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        Text {
                            text: "Driver profile high scores and cloud save backup"
                            color: Qt.rgba(225/255, 238/255, 255/255, 0.80)
                            font.family: "Inter"
                            font.pixelSize: 12
                        }
                    }
                }
            }
        }
    }
}
