/**
 * ==============================================================================
 * Project: Apex VISION IVI - Digital Cockpit & Infotainment System
 * File: MessagesPage.qml
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
    objectName: "messagesPage"

    signal backRequested()
    signal openBluetoothRequested()

    readonly property bool isDeviceConnected: typeof PhoneBackend !== "undefined" && PhoneBackend.isConnected
    readonly property string connectedDeviceName: (typeof PhoneBackend !== "undefined" && PhoneBackend.isConnected) ? PhoneBackend.deviceName : ""

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

        // Messages Logo after Back Button
        Image {
            id: headerBrandLogo
            anchors.left: backBtn.right
            anchors.leftMargin: 16
            anchors.verticalCenter: parent.verticalCenter
            width: 36
            height: 36
            source: "qrc:/ApexVision/qml/assets/icons/app_messages.svg"
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
                text: "Messages"
                color: "#FFFFFF"
                font.family: "Inter"
                font.pixelSize: 22
                font.weight: Font.DemiBold
            }

            Text {
                text: "Smartphone Communication"
                color: Qt.rgba(225/255, 238/255, 255/255, 0.70)
                font.family: "Inter"
                font.pixelSize: 13
            }
        }

        // Right Status Pill (VehicleMenuCard Frosted Glass)
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
                    color: root.isDeviceConnected ?
                        Qt.rgba(16/255, 185/255, 129/255, 0.22) :
                        Qt.rgba(215/255, 238/255, 255/255, 0.17)
                }
                GradientStop {
                    position: 1.0
                    color: root.isDeviceConnected ?
                        Qt.rgba(5/255, 150/255, 105/255, 0.16) :
                        Qt.rgba(195/255, 225/255, 255/255, 0.11)
                }
            }

            border.color: root.isDeviceConnected ?
                Qt.rgba(52/255, 211/255, 153/255, 0.55) :
                Qt.rgba(225/255, 242/255, 255/255, 0.36)
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
                    color: root.isDeviceConnected ? "#34D399" : Qt.rgba(255, 255, 255, 0.40)
                }

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: root.isDeviceConnected ? "Connected" : "Not Connected"
                    color: "#F2F5F7"
                    font.family: "Inter"
                    font.pixelSize: 13
                    font.weight: Font.Medium
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

        // =====================================================================
        // VIEW A: DISCONNECTED STATE
        // =====================================================================
        Column {
            anchors.centerIn: parent
            spacing: 20
            width: 520
            visible: !root.isDeviceConnected

            // Brand Logo (Clean, standalone icon without enclosing card)
            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                width: 76
                height: 76
                source: "qrc:/ApexVision/qml/assets/icons/app_messages.svg"
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
                    text: "Messages"
                    color: "#FFFFFF"
                    font.family: "Inter"
                    font.pixelSize: 22
                    font.weight: Font.DemiBold
                }

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "To view and listen to text messages, connect your phone using Bluetooth."
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
                id: messagesStatusCard
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width
                height: 82
                radius: 18
                clip: true

                // VehicleMenuCard Frosted Glass Gradient Fill
                gradient: Gradient {
                    GradientStop {
                        position: 0.0
                        color: statusCardMouse.pressed ?
                            Qt.rgba(215/255, 238/255, 255/255, 0.28) :
                            (statusCardMouse.containsMouse ? Qt.rgba(225/255, 242/255, 255/255, 0.22) : Qt.rgba(215/255, 238/255, 255/255, 0.17))
                    }
                    GradientStop {
                        position: 1.0
                        color: statusCardMouse.pressed ?
                            Qt.rgba(195/255, 225/255, 255/255, 0.22) :
                            (statusCardMouse.containsMouse ? Qt.rgba(205/255, 232/255, 255/255, 0.16) : Qt.rgba(195/255, 225/255, 255/255, 0.11))
                    }
                }

                border.color: statusCardMouse.containsMouse ?
                    Qt.rgba(255, 255, 255, 0.55) :
                    Qt.rgba(225/255, 242/255, 255/255, 0.36)
                border.width: 1

                Behavior on border.color { ColorAnimation { duration: 150 } }

                Row {
                    anchors.fill: parent
                    anchors.leftMargin: 20
                    anchors.rightMargin: 20
                    spacing: 16

                    // Bluetooth Status Icon
                    Image {
                        width: 32
                        height: 32
                        anchors.verticalCenter: parent.verticalCenter
                        source: "qrc:/ApexVision/qml/assets/icons/bluetooth.svg"
                        fillMode: Image.PreserveAspectFit
                        opacity: 0.85
                    }

                    // Status Label Column
                    Column {
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 2
                        width: parent.width - 240

                        Text {
                            text: "Bluetooth Not Connected"
                            color: "#FFFFFF"
                            font.family: "Inter"
                            font.pixelSize: 15
                            font.weight: Font.DemiBold
                        }

                        Text {
                            text: "Pair your smartphone in Bluetooth settings"
                            color: Qt.rgba(225/255, 238/255, 255/255, 0.65)
                            font.family: "Inter"
                            font.pixelSize: 12
                            elide: Text.ElideRight
                            width: parent.width
                        }
                    }

                    // Open Bluetooth Settings Action Button
                    Rectangle {
                        anchors.verticalCenter: parent.verticalCenter
                        height: 38
                        width: 150
                        radius: 12
                        clip: true

                        gradient: Gradient {
                            GradientStop {
                                position: 0.0
                                color: settingsBtnMouse.pressed ?
                                    Qt.rgba(215/255, 238/255, 255/255, 0.34) :
                                    (settingsBtnMouse.containsMouse ? Qt.rgba(225/255, 242/255, 255/255, 0.25) : Qt.rgba(215/255, 238/255, 255/255, 0.18))
                            }
                            GradientStop {
                                position: 1.0
                                color: settingsBtnMouse.pressed ?
                                    Qt.rgba(195/255, 225/255, 255/255, 0.28) :
                                    (settingsBtnMouse.containsMouse ? Qt.rgba(205/255, 232/255, 255/255, 0.19) : Qt.rgba(195/255, 225/255, 255/255, 0.12))
                            }
                        }

                        border.color: settingsBtnMouse.containsMouse ?
                            Qt.rgba(255, 255, 255, 0.65) :
                            Qt.rgba(225/255, 242/255, 255/255, 0.38)
                        border.width: 1

                        Text {
                            anchors.centerIn: parent
                            text: "Bluetooth Settings"
                            color: "#FFFFFF"
                            font.family: "Inter"
                            font.pixelSize: 13
                            font.weight: Font.Medium
                        }

                        MouseArea {
                            id: settingsBtnMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: root.openBluetoothRequested()
                        }
                    }
                }

                MouseArea {
                    id: statusCardMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    z: -1
                    onClicked: root.openBluetoothRequested()
                }
            }

            // Quick Info Card
            Rectangle {
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width
                height: 120
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
                        text: "Features while connected:"
                        color: "#E2E8F0"
                        font.family: "Inter"
                        font.pixelSize: 13
                        font.weight: Font.DemiBold
                    }

                    Row {
                        spacing: 12
                        Rectangle {
                            width: 6; height: 6; radius: 3
                            color: "#38BDF8"
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        Text {
                            text: "Audible message readout through vehicle sound system"
                            color: Qt.rgba(225/255, 238/255, 255/255, 0.80)
                            font.family: "Inter"
                            font.pixelSize: 12
                        }
                    }

                    Row {
                        spacing: 12
                        Rectangle {
                            width: 6; height: 6; radius: 3
                            color: "#38BDF8"
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        Text {
                            text: "Hands-free voice replies with steering wheel voice button"
                            color: Qt.rgba(225/255, 238/255, 255/255, 0.80)
                            font.family: "Inter"
                            font.pixelSize: 12
                        }
                    }
                }
            }
        }

        // =====================================================================
        // VIEW B: CONNECTED STATE
        // =====================================================================
        Column {
            anchors.centerIn: parent
            spacing: 20
            width: 580
            visible: root.isDeviceConnected

            // Connected Device Status Header Card
            Rectangle {
                width: parent.width
                height: 72
                radius: 18
                clip: true

                gradient: Gradient {
                    GradientStop { position: 0.0; color: Qt.rgba(215/255, 238/255, 255/255, 0.20) }
                    GradientStop { position: 1.0; color: Qt.rgba(195/255, 225/255, 255/255, 0.12) }
                }

                border.color: Qt.rgba(225/255, 242/255, 255/255, 0.36)
                border.width: 1

                Row {
                    anchors.fill: parent
                    anchors.leftMargin: 20
                    anchors.rightMargin: 20
                    spacing: 14

                    Image {
                        width: 28
                        height: 28
                        anchors.verticalCenter: parent.verticalCenter
                        source: "qrc:/ApexVision/qml/assets/icons/bluetooth.svg"
                        fillMode: Image.PreserveAspectFit
                    }

                    Column {
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 2
                        width: parent.width - 180

                        Text {
                            text: root.connectedDeviceName !== "" ? root.connectedDeviceName : "Connected Smartphone"
                            color: "#FFFFFF"
                            font.family: "Inter"
                            font.pixelSize: 16
                            font.weight: Font.DemiBold
                        }

                        Text {
                            text: "Bluetooth Synchronized • SMS & Text Services Active"
                            color: "#34D399"
                            font.family: "Inter"
                            font.pixelSize: 12
                        }
                    }

                    // Settings pill
                    Rectangle {
                        anchors.verticalCenter: parent.verticalCenter
                        height: 34
                        width: 120
                        radius: 10

                        gradient: Gradient {
                            GradientStop { position: 0.0; color: Qt.rgba(215/255, 238/255, 255/255, 0.18) }
                            GradientStop { position: 1.0; color: Qt.rgba(195/255, 225/255, 255/255, 0.12) }
                        }
                        border.color: Qt.rgba(225/255, 242/255, 255/255, 0.36)
                        border.width: 1

                        Text {
                            anchors.centerIn: parent
                            text: "Manage"
                            color: "#FFFFFF"
                            font.family: "Inter"
                            font.pixelSize: 12
                            font.weight: Font.Medium
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: root.openBluetoothRequested()
                        }
                    }
                }
            }

            // Messages Container Card
            Rectangle {
                width: parent.width
                height: 240
                radius: 18
                clip: true

                gradient: Gradient {
                    GradientStop { position: 0.0; color: Qt.rgba(215/255, 238/255, 255/255, 0.16) }
                    GradientStop { position: 1.0; color: Qt.rgba(195/255, 225/255, 255/255, 0.10) }
                }

                border.color: Qt.rgba(225/255, 242/255, 255/255, 0.32)
                border.width: 1

                Column {
                    anchors.centerIn: parent
                    spacing: 12

                    Image {
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 48
                        height: 48
                        source: "qrc:/ApexVision/qml/assets/icons/app_messages.svg"
                        fillMode: Image.PreserveAspectFit
                        opacity: 0.75
                    }

                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "No New Messages"
                        color: "#FFFFFF"
                        font.family: "Inter"
                        font.pixelSize: 18
                        font.weight: Font.DemiBold
                    }

                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "Incoming text messages will be announced here while driving."
                        color: Qt.rgba(225/255, 238/255, 255/255, 0.65)
                        font.family: "Inter"
                        font.pixelSize: 13
                    }
                }
            }
        }
    }
}
