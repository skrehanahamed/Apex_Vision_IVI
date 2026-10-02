/**
 * ==============================================================================
 * Project: Apex VISION IVI - Digital Cockpit & Infotainment System
 * File: ValetLockOverlay.qml
 * Author / Developer: Sk Rehan Ahamed
 * License: MIT
 * ==============================================================================
 */

import QtQuick
import QtQuick.Controls
import ApexVision

Item {
    id: root

    property bool isLocked: false
    property string targetPin: "1234"
    property string enteredPin: ""
    property string errorMessage: ""
    property bool isError: false

    signal unlocked()

    visible: isLocked || opacity > 0.001
    opacity: isLocked ? 1.0 : 0.0
    enabled: isLocked

    Behavior on opacity {
        NumberAnimation {
            duration: 300
            easing.type: Easing.InOutQuad
        }
    }

    // Intercept all mouse/touch events so nothing behind can be clicked
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        preventStealing: true
    }

    // Master Project Default Background (Matching IVI system wallpaper)
    Image {
        id: lockBgImage
        anchors.fill: parent
        source: "qrc:/ApexVision/qml/assets/default_background.png"
        fillMode: Image.PreserveAspectCrop
        smooth: true
        z: 0
    }

    // Very light scrim so default background stays bright and vibrant
    Rectangle {
        anchors.fill: parent
        color: Qt.rgba(0, 0, 0, 0.15)
        z: 1
    }

    // Top Bar (Time & Status)
    Item {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: 64

        Text {
            anchors.left: parent.left
            anchors.leftMargin: 40
            anchors.verticalCenter: parent.verticalCenter
            text: (typeof SystemBackend !== "undefined" && SystemBackend.currentTime) ? SystemBackend.currentTime : "4:22"
            font.family: "Inter"
            font.pixelSize: 22
            font.weight: Font.DemiBold
            color: "#FFFFFF"
        }

        // Valet Mode Active Pill Badge
        Rectangle {
            anchors.centerIn: parent
            width: 156
            height: 34
            radius: 17
            color: Qt.rgba(245/255, 158/255, 11/255, 0.15)
            border.color: "#F59E0B"
            border.width: 1.2

            Row {
                anchors.centerIn: parent
                spacing: 8

                Rectangle {
                    width: 7
                    height: 7
                    radius: 3.5
                    color: "#F59E0B"
                    anchors.verticalCenter: parent.verticalCenter
                }

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: "VALET MODE"
                    font.family: "Inter"
                    font.pixelSize: 12
                    font.weight: Font.Bold
                    font.letterSpacing: 1.0
                    color: "#F59E0B"
                }
            }
        }
    }

    // Central Card Container
    Item {
        id: cardContainer
        anchors.centerIn: parent
        width: 440
        height: 520

        Column {
            anchors.centerIn: parent
            spacing: 18
            width: parent.width

            // Lock & Screen Icon
            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                source: "qrc:/ApexVision/qml/assets/icons/icon_valet_mode.png"
                width: 64
                height: 52
                fillMode: Image.PreserveAspectFit
                smooth: true
            }

            // Headings
            Column {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 6

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Valet mode active"
                    font.family: "Inter"
                    font.pixelSize: 22
                    font.weight: Font.Bold
                    color: "#FFFFFF"
                }

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: root.errorMessage !== "" ? root.errorMessage : "Enter PIN to unlock and exit Valet mode"
                    font.family: "Inter"
                    font.pixelSize: 15
                    font.weight: Font.Medium
                    color: root.errorMessage !== "" ? "#FF4D4D" : "#FFFFFF"
                    Behavior on color { ColorAnimation { duration: 150 } }
                }
            }

            // 4 PIN Dots / Rings with Shake Animation
            Item {
                id: pinDotsRow
                anchors.horizontalCenter: parent.horizontalCenter
                width: 140
                height: 32

                Row {
                    anchors.centerIn: parent
                    spacing: 20

                    Repeater {
                        model: 4
                        Rectangle {
                            width: 18
                            height: 18
                            radius: 9
                            color: index < root.enteredPin.length ?
                                   (root.isError ? "#EF4444" : "#F59E0B") : "transparent"
                            border.color: index < root.enteredPin.length ?
                                          (root.isError ? "#EF4444" : "#F59E0B") : Qt.rgba(255, 255, 255, 0.35)
                            border.width: 2
                            Behavior on color { ColorAnimation { duration: 120 } }
                            Behavior on border.color { ColorAnimation { duration: 120 } }
                        }
                    }
                }

                SequentialAnimation {
                    id: shakeAnim
                    NumberAnimation { target: pinDotsRow; property: "x"; to: (cardContainer.width - pinDotsRow.width) / 2 - 12; duration: 50 }
                    NumberAnimation { target: pinDotsRow; property: "x"; to: (cardContainer.width - pinDotsRow.width) / 2 + 12; duration: 50 }
                    NumberAnimation { target: pinDotsRow; property: "x"; to: (cardContainer.width - pinDotsRow.width) / 2 - 8; duration: 50 }
                    NumberAnimation { target: pinDotsRow; property: "x"; to: (cardContainer.width - pinDotsRow.width) / 2 + 8; duration: 50 }
                    NumberAnimation { target: pinDotsRow; property: "x"; to: (cardContainer.width - pinDotsRow.width) / 2; duration: 50 }
                }
            }

            // 3x4 Luxury Glass Keypad
            Grid {
                anchors.horizontalCenter: parent.horizontalCenter
                columns: 3
                spacing: 14

                Repeater {
                    model: [
                        { label: "1", val: "1" },
                        { label: "2", val: "2" },
                        { label: "3", val: "3" },
                        { label: "4", val: "4" },
                        { label: "5", val: "5" },
                        { label: "6", val: "6" },
                        { label: "7", val: "7" },
                        { label: "8", val: "8" },
                        { label: "9", val: "9" },
                        { label: "Clear", val: "clear" },
                        { label: "0", val: "0" },
                        { label: "⌫", val: "back" }
                    ]

                    Rectangle {
                        width: 86
                        height: 54
                        radius: 16
                        color: unlockKeyMouse.pressed ? Qt.rgba(255, 255, 255, 0.22) :
                               (unlockKeyMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.14) : Qt.rgba(255, 255, 255, 0.07))
                        border.color: Qt.rgba(255, 255, 255, 0.16)
                        border.width: 1
                        Behavior on color { ColorAnimation { duration: 120 } }

                        Text {
                            anchors.centerIn: parent
                            text: modelData.label
                            font.family: "Inter"
                            font.pixelSize: modelData.val === "clear" ? 14 : 20
                            font.weight: Font.DemiBold
                            color: "#FFFFFF"
                        }

                        MouseArea {
                            id: unlockKeyMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                root.handleInput(modelData.val);
                            }
                        }
                    }
                }
            }
        }
    }

    function handleInput(val) {
        if (isError) return;

        errorMessage = "";
        if (val === "clear") {
            enteredPin = "";
        } else if (val === "back") {
            if (enteredPin.length > 0) {
                enteredPin = enteredPin.substring(0, enteredPin.length - 1);
            }
        } else {
            if (enteredPin.length < 4) {
                enteredPin += val;
                if (enteredPin.length === 4) {
                    verifyTimer.start();
                }
            }
        }
    }

    Timer {
        id: verifyTimer
        interval: 180
        repeat: false
        onTriggered: {
            if (root.enteredPin === root.targetPin || root.targetPin === "") {
                // Correct PIN -> unlock!
                root.isLocked = false;
                root.enteredPin = "";
                root.errorMessage = "";
                root.isError = false;
                if (typeof VehicleBackend !== "undefined") {
                    VehicleBackend.setValetMode(false);
                }
                root.unlocked();
            } else {
                // Incorrect PIN
                root.isError = true;
                root.errorMessage = "Incorrect PIN. Please try again.";
                shakeAnim.restart();
                resetTimer.start();
            }
        }
    }

    Timer {
        id: resetTimer
        interval: 900
        repeat: false
        onTriggered: {
            root.enteredPin = "";
            root.isError = false;
            root.errorMessage = "";
        }
    }
}
