/**
 * ==============================================================================
 * Project: Apex VISION IVI - Digital Cockpit & Infotainment System
 * File: MobileDeviceConnectionPage.qml
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
    objectName: "mobileDeviceConnectionPage"

    signal backRequested()
    signal openBluetoothRequested()

    // Projection Type: "carplay" (Apple CarPlay) or "android_auto" (Android Auto)
    property string projectionType: "carplay"

    // Active Connection Tab: "wireless" or "usb"
    property string connectionTab: "wireless"

    // Real status from PhoneBackend
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

        // Projection Brand Logo after Back Button
        Image {
            id: headerBrandLogo
            anchors.left: backBtn.right
            anchors.leftMargin: 16
            anchors.verticalCenter: parent.verticalCenter
            width: 36
            height: 36
            source: root.projectionType === "carplay" ?
                    "qrc:/ApexVision/qml/assets/icons/app_carplay.svg" :
                    "qrc:/ApexVision/qml/assets/icons/app_projection.svg"
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
                text: root.projectionType === "carplay" ? "Apple CarPlay™" : "Android Auto™"
                color: "#FFFFFF"
                font.family: "Inter"
                font.pixelSize: 22
                font.weight: Font.DemiBold
            }

            Text {
                text: "Smartphone Projection"
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
                    color: Qt.rgba(215/255, 238/255, 255/255, 0.20)
                }
                GradientStop {
                    position: 1.0
                    color: Qt.rgba(195/255, 225/255, 255/255, 0.12)
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
    // 3. SEGMENTED TAB SWITCHER (VehicleMenuCard Light Frosted Glass Capsule)
    // =========================================================================
    Rectangle {
        id: tabSwitcher
        anchors.top: headerBar.bottom
        anchors.topMargin: 22
        anchors.horizontalCenter: parent.horizontalCenter
        width: 320
        height: 44
        radius: 22
        clip: true
        z: 10

        gradient: Gradient {
            GradientStop {
                position: 0.0
                color: Qt.rgba(215/255, 238/255, 255/255, 0.18)
            }
            GradientStop {
                position: 1.0
                color: Qt.rgba(195/255, 225/255, 255/255, 0.10)
            }
        }

        border.color: Qt.rgba(225/255, 242/255, 255/255, 0.36)
        border.width: 1


        // Active Tab Highlight Pill
        Rectangle {
            x: root.connectionTab === "wireless" ? 3 : 161
            y: 3
            width: 156
            height: 38
            radius: 19

            gradient: Gradient {
                GradientStop {
                    position: 0.0
                    color: Qt.rgba(225/255, 242/255, 255/255, 0.36)
                }
                GradientStop {
                    position: 1.0
                    color: Qt.rgba(195/255, 225/255, 255/255, 0.22)
                }
            }

            border.color: Qt.rgba(255, 255, 255, 0.55)
            border.width: 1

            Behavior on x {
                NumberAnimation { duration: 220; easing.type: Easing.OutCubic }
            }
        }

        Row {
            anchors.fill: parent

            // Wireless Tab Button
            Item {
                width: parent.width / 2
                height: parent.height

                Text {
                    anchors.centerIn: parent
                    text: "Wireless"
                    color: root.connectionTab === "wireless" ? "#FFFFFF" : Qt.rgba(225/255, 238/255, 255/255, 0.65)
                    font.family: "Inter"
                    font.pixelSize: 14
                    font.weight: root.connectionTab === "wireless" ? Font.DemiBold : Font.Normal
                    Behavior on color { ColorAnimation { duration: 180 } }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.connectionTab = "wireless"
                }
            }

            // USB Cable Tab Button
            Item {
                width: parent.width / 2
                height: parent.height

                Text {
                    anchors.centerIn: parent
                    text: "USB Cable"
                    color: root.connectionTab === "usb" ? "#FFFFFF" : Qt.rgba(225/255, 238/255, 255/255, 0.65)
                    font.family: "Inter"
                    font.pixelSize: 14
                    font.weight: root.connectionTab === "usb" ? Font.DemiBold : Font.Normal
                    Behavior on color { ColorAnimation { duration: 180 } }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.connectionTab = "usb"
                }
            }
        }
    }

    // =========================================================================
    // 4. MAIN CONTENT AREA (VehicleMenuCard Frosted Glass Aesthetic)
    // =========================================================================
    Item {
        id: contentArea
        anchors.top: tabSwitcher.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.topMargin: 24
        anchors.bottomMargin: 40
        z: 5

        // ====================================================================
        // VIEW A: WIRELESS PROJECTION MODE
        // ====================================================================
        Column {
            id: wirelessView
            visible: root.connectionTab === "wireless"
            anchors.centerIn: parent
            spacing: 20
            width: 520

            // Brand Logo (Clean, standalone projection icon without enclosing card)
            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                width: 76
                height: 76
                source: root.projectionType === "carplay" ?
                        "qrc:/ApexVision/qml/assets/icons/app_carplay.svg" :
                        "qrc:/ApexVision/qml/assets/icons/app_projection.svg"
                fillMode: Image.PreserveAspectFit
                smooth: true
                mipmap: true
                sourceSize: Qt.size(256, 256)
            }

            // Headlines
            Column {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 6
                width: parent.width

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: root.projectionType === "carplay" ?
                          "Connect to Apple CarPlay™" :
                          "Connect to Android Auto™"
                    color: "#FFFFFF"
                    font.family: "Inter"
                    font.pixelSize: 22
                    font.weight: Font.DemiBold
                }

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: root.projectionType === "carplay" ?
                          "To use Apple CarPlay, pair your iPhone via Bluetooth or connect via USB." :
                          "To use Android Auto, pair your Android phone via Bluetooth or connect via USB."
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

            // Connection Status Card (VehicleMenuCard Frosted Glass Theme)
            Rectangle {
                id: wirelessStatusCard
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
                            Qt.rgba(215/255, 238/255, 255/255, 0.32) :
                            (statusCardMouse.containsMouse ? Qt.rgba(225/255, 242/255, 255/255, 0.24) :
                            (root.isDeviceConnected ? Qt.rgba(225/255, 242/255, 255/255, 0.22) : Qt.rgba(215/255, 238/255, 255/255, 0.17)))
                    }
                    GradientStop {
                        position: 1.0
                        color: statusCardMouse.pressed ?
                            Qt.rgba(195/255, 225/255, 255/255, 0.26) :
                            (statusCardMouse.containsMouse ? Qt.rgba(205/255, 232/255, 255/255, 0.18) :
                            (root.isDeviceConnected ? Qt.rgba(205/255, 232/255, 255/255, 0.16) : Qt.rgba(195/255, 225/255, 255/255, 0.11)))
                    }
                }

                border.color: statusCardMouse.containsMouse ?
                    Qt.rgba(255, 255, 255, 0.65) :
                    (root.isDeviceConnected ? Qt.rgba(52/255, 211/255, 153/255, 0.50) : Qt.rgba(225/255, 242/255, 255/255, 0.36))
                border.width: 1

                Behavior on border.color { ColorAnimation { duration: 180 } }

                scale: statusCardMouse.pressed ? 0.98 : (statusCardMouse.containsMouse ? 1.015 : 1.0)
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
                            text: root.isDeviceConnected ? root.connectedDeviceName : "No Device Connected"
                            color: "#F2F5F7"
                            font.family: "Inter"
                            font.pixelSize: 16
                            font.weight: Font.DemiBold
                        }

                        Text {
                            text: root.isDeviceConnected ?
                                  "Bluetooth connected • Projection ready" :
                                  "No device detected for wireless projection"
                            color: root.isDeviceConnected ? "#34D399" : Qt.rgba(225/255, 238/255, 255/255, 0.70)
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
                                color: pairMouse.pressed ?
                                    Qt.rgba(215/255, 238/255, 255/255, 0.38) :
                                    (pairMouse.containsMouse ? Qt.rgba(225/255, 242/255, 255/255, 0.28) : Qt.rgba(215/255, 238/255, 255/255, 0.18))
                            }
                            GradientStop {
                                position: 1.0
                                color: pairMouse.pressed ?
                                    Qt.rgba(195/255, 225/255, 255/255, 0.30) :
                                    (pairMouse.containsMouse ? Qt.rgba(205/255, 232/255, 255/255, 0.20) : Qt.rgba(195/255, 225/255, 255/255, 0.12))
                            }
                        }

                        border.color: pairMouse.containsMouse ?
                            Qt.rgba(255, 255, 255, 0.65) :
                            Qt.rgba(225/255, 242/255, 255/255, 0.36)
                        border.width: 1

                        scale: pairMouse.pressed ? 0.96 : (pairMouse.containsMouse ? 1.03 : 1.0)
                        Behavior on scale { NumberAnimation { duration: 140 } }
                        Behavior on border.color { ColorAnimation { duration: 150 } }

                        Text {
                            anchors.centerIn: parent
                            text: root.isDeviceConnected ? "Manage Devices" : "Pair Device"
                            color: "#F2F5F7"
                            font.family: "Inter"
                            font.pixelSize: 13
                            font.weight: Font.DemiBold
                        }

                        MouseArea {
                            id: pairMouse
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
                    onClicked: root.openBluetoothRequested()
                }
            }

            // Setup Instructions Card (VehicleMenuCard Frosted Glass)
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
                            text: "1. Turn on Bluetooth and Wi-Fi on your phone."
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
                            text: root.projectionType === "carplay" ?
                                  "2. In your phone's Settings > General > CarPlay, select this vehicle." :
                                  "2. In your phone's Settings > Connected devices, pair with APEX IVI."
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
                            text: "3. Confirm the pairing prompt on your mobile screen."
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
                color: btLinkMouse.containsMouse ? "#38BDF8" : Qt.rgba(225/255, 238/255, 255/255, 0.75)
                font.family: "Inter"
                font.pixelSize: 13
                font.weight: Font.Medium
                Behavior on color { ColorAnimation { duration: 150 } }

                MouseArea {
                    id: btLinkMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.openBluetoothRequested()
                }
            }
        }

        // ====================================================================
        // VIEW B: USB-C CABLE PROJECTION MODE
        // ====================================================================
        Column {
            id: usbView
            visible: root.connectionTab === "usb"
            anchors.centerIn: parent
            spacing: 20
            width: 520

            // USB Port Icon (Clean standalone icon without enclosing card)
            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                width: 56
                height: 56
                source: "qrc:/ApexVision/qml/assets/icons/usb_source.svg"
                fillMode: Image.PreserveAspectFit
                smooth: true
                mipmap: true
                sourceSize: Qt.size(256, 256)
            }

            // Headlines
            Column {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 6
                width: parent.width

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Connect via USB-C"
                    color: "#FFFFFF"
                    font.family: "Inter"
                    font.pixelSize: 22
                    font.weight: Font.DemiBold
                }

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Plug your phone into the center console USB-C port to start."
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

            // USB Hardware Status Card (VehicleMenuCard Frosted Glass Theme)
            Rectangle {
                id: usbCard
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width
                height: 82
                radius: 18
                clip: true

                // VehicleMenuCard Frosted Glass Gradient Fill
                gradient: Gradient {
                    GradientStop {
                        position: 0.0
                        color: usbCardMouse.pressed ?
                            Qt.rgba(215/255, 238/255, 255/255, 0.32) :
                            (usbCardMouse.containsMouse ? Qt.rgba(225/255, 242/255, 255/255, 0.24) : Qt.rgba(215/255, 238/255, 255/255, 0.17))
                    }
                    GradientStop {
                        position: 1.0
                        color: usbCardMouse.pressed ?
                            Qt.rgba(195/255, 225/255, 255/255, 0.26) :
                            (usbCardMouse.containsMouse ? Qt.rgba(205/255, 232/255, 255/255, 0.18) : Qt.rgba(195/255, 225/255, 255/255, 0.11))
                    }
                }

                // Luminous Light Glass Border
                border.color: usbCardMouse.containsMouse ?
                    Qt.rgba(255, 255, 255, 0.65) :
                    Qt.rgba(225/255, 242/255, 255/255, 0.36)
                border.width: 1

                Behavior on border.color { ColorAnimation { duration: 180 } }

                scale: usbCardMouse.pressed ? 0.98 : (usbCardMouse.containsMouse ? 1.015 : 1.0)
                Behavior on scale { NumberAnimation { duration: 150; easing.type: Easing.OutQuad } }


                Row {
                    anchors.fill: parent
                    anchors.leftMargin: 20
                    anchors.rightMargin: 18
                    spacing: 16

                    // Active Green Indicator Dot in frosted container
                    Rectangle {
                        width: 44
                        height: 44
                        radius: 22
                        anchors.verticalCenter: parent.verticalCenter
                        color: Qt.rgba(52/255, 211/255, 153/255, 0.16)
                        border.color: Qt.rgba(52/255, 211/255, 153/255, 0.35)
                        border.width: 1

                        Rectangle {
                            anchors.centerIn: parent
                            width: 10
                            height: 10
                            radius: 5
                            color: "#10B981"
                        }
                    }

                    // Port Details
                    Column {
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 4
                        width: 290

                        Text {
                            text: "Front Center Console (Port 1)"
                            color: "#F2F5F7"
                            font.family: "Inter"
                            font.pixelSize: 16
                            font.weight: Font.DemiBold
                        }

                        Text {
                            text: "45W Fast Charging • Ready for connection"
                            color: "#34D399"
                            font.family: "Inter"
                            font.pixelSize: 12
                            font.weight: Font.Medium
                        }
                    }

                    Item { Layout.fillWidth: true; width: 1 }

                    // Ready Badge Pill
                    Rectangle {
                        anchors.verticalCenter: parent.verticalCenter
                        width: 72
                        height: 32
                        radius: 16
                        gradient: Gradient {
                            GradientStop {
                                position: 0.0
                                color: Qt.rgba(52/255, 211/255, 153/255, 0.24)
                            }
                            GradientStop {
                                position: 1.0
                                color: Qt.rgba(16/255, 185/255, 129/255, 0.14)
                            }
                        }
                        border.color: Qt.rgba(52/255, 211/255, 153/255, 0.45)
                        border.width: 1

                        Text {
                            anchors.centerIn: parent
                            text: "Ready"
                            color: "#34D399"
                            font.family: "Inter"
                            font.pixelSize: 13
                            font.weight: Font.DemiBold
                        }
                    }
                }

                MouseArea {
                    id: usbCardMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                }
            }

            // Cable Compatibility Card (VehicleMenuCard Frosted Glass)
            Rectangle {
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width
                height: 80
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


                Row {
                    anchors.centerIn: parent
                    spacing: 14
                    width: parent.width - 40

                    Rectangle {
                        width: 8; height: 8; radius: 4; color: "#38BDF8"
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Text {
                        width: parent.width - 24
                        text: "Use an original or certified data cable for optimal performance and mirroring capability."
                        color: Qt.rgba(225/255, 238/255, 255/255, 0.85)
                        font.family: "Inter"
                        font.pixelSize: 13
                        wrapMode: Text.WordWrap
                    }
                }
            }

            // Switch to Wireless Quick Link
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Switch to Wireless Connection"
                color: switchLinkMouse.containsMouse ? "#38BDF8" : Qt.rgba(225/255, 238/255, 255/255, 0.75)
                font.family: "Inter"
                font.pixelSize: 13
                font.weight: Font.Medium
                Behavior on color { ColorAnimation { duration: 150 } }

                MouseArea {
                    id: switchLinkMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.connectionTab = "wireless"
                }
            }
        }
    }
}
