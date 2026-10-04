/**
 * ==============================================================================
 * Project: Apex VISION IVI - Digital Cockpit & Infotainment System
 * File: StatusBar.qml
 * Author / Developer: Sk Rehan Ahamed
 * License: MIT
 * ==============================================================================
 */

import QtQuick
import QtQuick.Controls

Rectangle {
    id: root

    implicitWidth: 44
    implicitHeight: 120
    color: "#070A0F"

    // Seamless vertical left divider matching left navigation rail
    Rectangle {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: 1
        color: Qt.rgba(255, 255, 255, 0.025)
        z: 10
    }

    Column {
        anchors.top: parent.top
        anchors.topMargin: 16
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 12

        // 1. Notification Bell with badge (1 notification from image.png)
        Item {
            width: 26
            height: 26
            anchors.horizontalCenter: parent.horizontalCenter

            Image {
                anchors.centerIn: parent
                width: 24
                height: 24
                fillMode: Image.PreserveAspectFit
                source: "qrc:/ApexVision/qml/assets/icons/status_notification.png"
                smooth: true
                mipmap: true
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: PhoneBackend.clearNotification()
            }
        }

        // 2. Cellular / Wi-Fi Signal ("5G" or "2.5G" followed by signal lines)
        Item {
            id: networkSignalItem
            width: 38
            height: 26
            anchors.horizontalCenter: parent.horizontalCenter

            readonly property string currentBand: {
                if (typeof SystemBackend !== "undefined" && SystemBackend.wifiBand) {
                    return SystemBackend.wifiBand;
                }
                return "5G";
            }
            readonly property bool isConnected: (typeof SystemBackend !== "undefined") ? SystemBackend.wifiConnected : true
            readonly property int signalBars: (typeof SystemBackend !== "undefined") ? SystemBackend.wifiSignalBars : 4

            Row {
                anchors.centerIn: parent
                spacing: 3
                opacity: networkSignalItem.isConnected ? 1.0 : 0.35
                Behavior on opacity { NumberAnimation { duration: 250 } }

                // "5G" or "2.5G" Text Badge (smaller than the signal lines)
                Text {
                    anchors.bottom: barsRow.bottom
                    anchors.bottomMargin: 0.5
                    text: networkSignalItem.currentBand
                    color: "#FFFFFF"
                    font.pixelSize: (networkSignalItem.currentBand.length > 2) ? 8 : 8.5
                    font.bold: true
                    font.weight: Font.Bold
                    font.family: "Inter"
                    smooth: true
                }

                // Signal Lines (4 ascending bars)
                Row {
                    id: barsRow
                    spacing: 1.8
                    anchors.bottom: parent.bottom

                    Repeater {
                        model: [4, 7, 10, 13]

                        Rectangle {
                            width: 2.2
                            height: modelData
                            anchors.bottom: parent.bottom
                            radius: 1
                            antialiasing: true
                            smooth: true
                            color: (index < networkSignalItem.signalBars) ? "#FFFFFF" : Qt.rgba(255, 255, 255, 0.22)
                            Behavior on color { ColorAnimation { duration: 150 } }
                        }
                    }
                }
            }

            // Click to refresh / double-click to toggle band
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    if (typeof SystemBackend !== "undefined" && SystemBackend.refreshWifiStatus) {
                        SystemBackend.refreshWifiStatus();
                    }
                }
                onDoubleClicked: {
                    if (typeof SystemBackend !== "undefined" && SystemBackend.setWifiBand) {
                        SystemBackend.setWifiBand(SystemBackend.wifiBand === "5G" ? "2.5G" : "5G");
                    }
                }
            }
        }

        // 3. GPS Location Arrow
        Item {
            width: 26
            height: 26
            anchors.horizontalCenter: parent.horizontalCenter

            Image {
                anchors.centerIn: parent
                width: 24
                height: 24
                fillMode: Image.PreserveAspectFit
                source: "qrc:/ApexVision/qml/assets/icons/status_gps.png"
                smooth: true
                mipmap: true
            }
        }
    }
}
