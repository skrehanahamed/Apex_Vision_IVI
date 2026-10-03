/**
 * ==============================================================================
 * Project: Apex VISION IVI - Digital Cockpit & Infotainment System
 * File: PhonePage.qml
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
    objectName: "phonePage"

    signal backRequested()
    signal openBluetoothRequested()

    readonly property bool isDeviceConnected: typeof PhoneBackend !== "undefined" && PhoneBackend.isConnected
    readonly property string connectedDeviceName: (typeof PhoneBackend !== "undefined" && PhoneBackend.isConnected) ? PhoneBackend.deviceName : ""

    property string dialedNumber: ""
    property bool inCall: false
    property int callSeconds: 0

    Timer {
        id: callTimer
        interval: 1000
        running: root.inCall
        repeat: true
        onTriggered: root.callSeconds += 1
    }

    function formatCallDuration(sec) {
        var m = Math.floor(sec / 60);
        var s = sec % 60;
        return (m < 10 ? "0" + m : m) + ":" + (s < 10 ? "0" + s : s);
    }

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

        // Phone / Call Logo after Back Button
        Image {
            id: headerBrandLogo
            anchors.left: backBtn.right
            anchors.leftMargin: 16
            anchors.verticalCenter: parent.verticalCenter
            width: 36
            height: 36
            source: "qrc:/ApexVision/qml/assets/icons/app_phone.svg"
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
                text: "Phone"
                color: "#FFFFFF"
                font.family: "Inter"
                font.pixelSize: 22
                font.weight: Font.DemiBold
            }

            Text {
                text: "Hands-Free Calling"
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
        anchors.topMargin: 20
        anchors.bottomMargin: 30
        z: 5

        // =====================================================================
        // VIEW A: DISCONNECTED STATE
        // =====================================================================
        Column {
            anchors.centerIn: parent
            spacing: 20
            width: 520
            visible: !root.isDeviceConnected

            // Brand Logo (Clean, standalone phone icon without enclosing card)
            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                width: 76
                height: 76
                source: "qrc:/ApexVision/qml/assets/icons/app_phone.svg"
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
                    text: "Phone"
                    color: "#FFFFFF"
                    font.family: "Inter"
                    font.pixelSize: 22
                    font.weight: Font.DemiBold
                }

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "To make and receive hands-free phone calls, connect your phone using Bluetooth."
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
                id: phoneStatusCard
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width
                height: 82
                radius: 18
                clip: true

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
                            color: "#34D399"
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        Text {
                            text: "Hands-free voice calls with cabin noise cancellation"
                            color: Qt.rgba(225/255, 238/255, 255/255, 0.80)
                            font.family: "Inter"
                            font.pixelSize: 12
                        }
                    }

                    Row {
                        spacing: 12
                        Rectangle {
                            width: 6; height: 6; radius: 3
                            color: "#34D399"
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        Text {
                            text: "Access to contacts, recent call history, and numerical dialpad"
                            color: Qt.rgba(225/255, 238/255, 255/255, 0.80)
                            font.family: "Inter"
                            font.pixelSize: 12
                        }
                    }
                }
            }
        }

        // =====================================================================
        // VIEW B: CONNECTED STATE (Interactive Dialer Keypad & Active Call Interface)
        // =====================================================================
        Row {
            anchors.centerIn: parent
            spacing: 28
            visible: root.isDeviceConnected

            // Left Column: Connected Device & Call Status Card
            Rectangle {
                width: 340
                height: 380
                radius: 18
                clip: true

                gradient: Gradient {
                    GradientStop { position: 0.0; color: Qt.rgba(215/255, 238/255, 255/255, 0.18) }
                    GradientStop { position: 1.0; color: Qt.rgba(195/255, 225/255, 255/255, 0.11) }
                }

                border.color: Qt.rgba(225/255, 242/255, 255/255, 0.36)
                border.width: 1

                Column {
                    anchors.fill: parent
                    anchors.margins: 24
                    spacing: 16

                    // Device row
                    Row {
                        spacing: 14
                        anchors.horizontalCenter: parent.horizontalCenter

                        Image {
                            width: 32
                            height: 32
                            source: "qrc:/ApexVision/qml/assets/icons/app_phone.svg"
                            fillMode: Image.PreserveAspectFit
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Column {
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: 2

                            Text {
                                text: root.connectedDeviceName !== "" ? root.connectedDeviceName : "Connected Phone"
                                color: "#FFFFFF"
                                font.family: "Inter"
                                font.pixelSize: 16
                                font.weight: Font.DemiBold
                            }

                            Text {
                                text: "Bluetooth • Ready for Calls"
                                color: "#34D399"
                                font.family: "Inter"
                                font.pixelSize: 12
                            }
                        }
                    }

                    // Divider
                    Rectangle {
                        width: parent.width
                        height: 1
                        color: Qt.rgba(255, 255, 255, 0.14)
                    }

                    // Active Call or Standby Display
                    Item {
                        width: parent.width
                        height: 140

                        Column {
                            anchors.centerIn: parent
                            spacing: 8
                            visible: !root.inCall

                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: "Ready to Dial"
                                color: Qt.rgba(225/255, 238/255, 255/255, 0.60)
                                font.family: "Inter"
                                font.pixelSize: 14
                            }

                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: root.dialedNumber === "" ? "Enter number" : root.dialedNumber
                                color: root.dialedNumber === "" ? Qt.rgba(255, 255, 255, 0.35) : "#FFFFFF"
                                font.family: "Inter"
                                font.pixelSize: 22
                                font.weight: Font.DemiBold
                            }
                        }

                        Column {
                            anchors.centerIn: parent
                            spacing: 8
                            visible: root.inCall

                            Rectangle {
                                width: 10
                                height: 10
                                radius: 5
                                color: "#34D399"
                                anchors.horizontalCenter: parent.horizontalCenter
                            }

                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: "Call in Progress"
                                color: "#34D399"
                                font.family: "Inter"
                                font.pixelSize: 14
                                font.weight: Font.Medium
                            }

                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: root.dialedNumber !== "" ? root.dialedNumber : "Voicemail / Service"
                                color: "#FFFFFF"
                                font.family: "Inter"
                                font.pixelSize: 20
                                font.weight: Font.Bold
                            }

                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: root.formatCallDuration(root.callSeconds)
                                color: Qt.rgba(225/255, 238/255, 255/255, 0.85)
                                font.family: "Inter"
                                font.pixelSize: 16
                            }
                        }
                    }

                    // Call Action Button (Call / End Call)
                    Rectangle {
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: parent.width - 20
                        height: 48
                        radius: 14
                        clip: true

                        gradient: Gradient {
                            GradientStop {
                                position: 0.0
                                color: root.inCall ?
                                    (callActMouse.pressed ? "#DC2626" : "#EF4444") :
                                    (callActMouse.pressed ? "#059669" : "#10B981")
                            }
                            GradientStop {
                                position: 1.0
                                color: root.inCall ?
                                    (callActMouse.pressed ? "#B91C1C" : "#DC2626") :
                                    (callActMouse.pressed ? "#047857" : "#059669")
                            }
                        }

                        border.color: root.inCall ? Qt.rgba(248/255, 113/255, 113/255, 0.5) : Qt.rgba(52/255, 211/255, 153/255, 0.5)
                        border.width: 1

                        Row {
                            anchors.centerIn: parent
                            spacing: 10

                            Text {
                                text: root.inCall ? "End Call" : "Place Call"
                                color: "#FFFFFF"
                                font.family: "Inter"
                                font.pixelSize: 15
                                font.weight: Font.DemiBold
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }

                        MouseArea {
                            id: callActMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                if (root.inCall) {
                                    root.inCall = false;
                                    root.callSeconds = 0;
                                } else {
                                    root.inCall = true;
                                    root.callSeconds = 0;
                                }
                            }
                        }
                    }

                    // Manage in Bluetooth settings link
                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "Manage in Bluetooth Settings"
                        color: Qt.rgba(225/255, 238/255, 255/255, 0.65)
                        font.family: "Inter"
                        font.pixelSize: 12
                        font.underline: true

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: root.openBluetoothRequested()
                        }
                    }
                }
            }

            // Right Column: Keypad Card
            Rectangle {
                width: 320
                height: 380
                radius: 18
                clip: true

                gradient: Gradient {
                    GradientStop { position: 0.0; color: Qt.rgba(215/255, 238/255, 255/255, 0.18) }
                    GradientStop { position: 1.0; color: Qt.rgba(195/255, 225/255, 255/255, 0.11) }
                }

                border.color: Qt.rgba(225/255, 242/255, 255/255, 0.36)
                border.width: 1

                Column {
                    anchors.centerIn: parent
                    spacing: 10

                    // Keypad Grid
                    Grid {
                        columns: 3
                        spacing: 12
                        anchors.horizontalCenter: parent.horizontalCenter

                        Repeater {
                            model: [
                                { num: "1", sub: "" },
                                { num: "2", sub: "ABC" },
                                { num: "3", sub: "DEF" },
                                { num: "4", sub: "GHI" },
                                { num: "5", sub: "JKL" },
                                { num: "6", sub: "MNO" },
                                { num: "7", sub: "PQRS" },
                                { num: "8", sub: "TUV" },
                                { num: "9", sub: "WXYZ" },
                                { num: "*", sub: "" },
                                { num: "0", sub: "+" },
                                { num: "#", sub: "" }
                            ]

                            delegate: Rectangle {
                                width: 78
                                height: 56
                                radius: 14
                                clip: true

                                gradient: Gradient {
                                    GradientStop {
                                        position: 0.0
                                        color: keyMouse.pressed ?
                                            Qt.rgba(215/255, 238/255, 255/255, 0.35) :
                                            (keyMouse.containsMouse ? Qt.rgba(225/255, 242/255, 255/255, 0.22) : Qt.rgba(215/255, 238/255, 255/255, 0.14))
                                    }
                                    GradientStop {
                                        position: 1.0
                                        color: keyMouse.pressed ?
                                            Qt.rgba(195/255, 225/255, 255/255, 0.28) :
                                            (keyMouse.containsMouse ? Qt.rgba(205/255, 232/255, 255/255, 0.17) : Qt.rgba(195/255, 225/255, 255/255, 0.09))
                                    }
                                }

                                border.color: keyMouse.containsMouse ?
                                    Qt.rgba(255, 255, 255, 0.60) :
                                    Qt.rgba(225/255, 242/255, 255/255, 0.30)
                                border.width: 1

                                Column {
                                    anchors.centerIn: parent
                                    spacing: 1

                                    Text {
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        text: modelData.num
                                        color: "#FFFFFF"
                                        font.family: "Inter"
                                        font.pixelSize: 18
                                        font.weight: Font.DemiBold
                                    }

                                    Text {
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        text: modelData.sub
                                        color: Qt.rgba(225/255, 238/255, 255/255, 0.55)
                                        font.family: "Inter"
                                        font.pixelSize: 9
                                        font.weight: Font.Medium
                                        visible: modelData.sub !== ""
                                    }
                                }

                                MouseArea {
                                    id: keyMouse
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                        if (root.dialedNumber.length < 15) {
                                            root.dialedNumber += modelData.num;
                                        }
                                    }
                                }
                            }
                        }
                    }

                    // Keypad bottom control: Backspace / Clear
                    Item {
                        width: parent.width
                        height: 38

                        Rectangle {
                            anchors.centerIn: parent
                            width: 120
                            height: 32
                            radius: 8
                            visible: root.dialedNumber.length > 0

                            color: delMouse.pressed ? Qt.rgba(255, 255, 255, 0.22) :
                                   (delMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.14) : Qt.rgba(255, 255, 255, 0.08))
                            border.color: Qt.rgba(255, 255, 255, 0.24)
                            border.width: 1

                            Text {
                                anchors.centerIn: parent
                                text: "⌫ Clear"
                                color: "#FFFFFF"
                                font.family: "Inter"
                                font.pixelSize: 12
                                font.weight: Font.Medium
                            }

                            MouseArea {
                                id: delMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    if (root.dialedNumber.length > 0) {
                                        root.dialedNumber = root.dialedNumber.slice(0, -1);
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
