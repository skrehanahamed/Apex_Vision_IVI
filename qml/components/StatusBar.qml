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

        // 2. Cellular Tower
        Item {
            width: 26
            height: 26
            anchors.horizontalCenter: parent.horizontalCenter

            Image {
                anchors.centerIn: parent
                width: 24
                height: 24
                fillMode: Image.PreserveAspectFit
                source: "qrc:/ApexVision/qml/assets/icons/status_tower.png"
                smooth: true
                mipmap: true
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
