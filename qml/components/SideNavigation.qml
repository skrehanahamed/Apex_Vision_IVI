/**
 * ==============================================================================
 * Project: Apex VISION IVI - Digital Cockpit & Infotainment System
 * File: SideNavigation.qml
 * Author / Developer: Sk Rehan Ahamed
 * License: MIT
 * ==============================================================================
 */

import QtQuick
import QtQuick.Controls
import ApexVision
import ".."

Rectangle {
    id: root

    property int currentIndex: 0
    property bool climateActive: false
    property bool isRearView: false
    signal pageSelected(int index)
    signal climateCloseRequested()

    width: 84
    color: "#070A0F" // Deep automotive cockpit black, matching main theme

    // Seamless vertical right divider matching cockpit aesthetic
    Rectangle {
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: 1
        color: Qt.rgba(255, 255, 255, 0.025)
        z: 100
    }

    // =========================================================================
    // 1. NORMAL MODE CONTAINER: Digital Clock, APEX logo, and Navigation Icons
    // =========================================================================
    Item {
        id: normalNavContent
        anchors.fill: parent
        visible: !root.climateActive || opacity > 0.001
        opacity: root.climateActive ? 0.0 : 1.0
        enabled: !root.climateActive

        Behavior on opacity {
            NumberAnimation { duration: 350; easing.type: Easing.InOutQuad }
        }

        // Top Clock & APEX Branding
        Column {
            id: topSection
            anchors.top: parent.top
            anchors.topMargin: 18
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 8

            Text {
                id: clockText
                anchors.horizontalCenter: parent.horizontalCenter
                text: SystemBackend.currentTime
                color: "#FFFFFF"
                font.family: "Inter"
                font.pixelSize: 20
                font.weight: Font.DemiBold
                font.letterSpacing: 0.2
                renderType: Text.NativeRendering
            }

            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                width: 52
                height: 15
                fillMode: Image.PreserveAspectFit
                source: "qrc:/ApexVision/qml/assets/icons/apex_logo.png"
                smooth: true
                mipmap: true
                opacity: 0.85
            }
        }

        // Center Navigation Icons (Home, Car, Menu)
        Column {
            id: navIconsColumn
            anchors.centerIn: parent
            spacing: 14

            ApexNavItem {
                icon: "qrc:/ApexVision/qml/assets/icons/icon_home.png"
                iconWidth: 32
                iconHeight: 30
                isSelected: root.currentIndex === 0
                onClicked: {
                    root.currentIndex = 0;
                    root.pageSelected(0);
                }
            }

            ApexNavItem {
                icon: "qrc:/ApexVision/qml/assets/icons/icon_car.png"
                iconWidth: 36
                iconHeight: 27
                isSelected: root.currentIndex === 1
                onClicked: {
                    root.currentIndex = 1;
                    root.pageSelected(1);
                }
            }

            ApexNavItem {
                icon: "qrc:/ApexVision/qml/assets/icons/icon_menu.png"
                iconWidth: 32
                iconHeight: 23
                isSelected: root.currentIndex === 2
                onClicked: {
                    root.currentIndex = 2;
                    root.pageSelected(2);
                }
            }
        }
    }

    // =========================================================================
    // 2. CLIMATE MODE CONTAINER: Close, Power, Airflow Pod, SYNC
    // Fades and slides in from down to up when in climate mode
    // =========================================================================
    Item {
        id: climateNavContent
        anchors.fill: parent
        visible: root.climateActive || opacity > 0.001
        opacity: root.climateActive ? 1.0 : 0.0
        enabled: root.climateActive

        Behavior on opacity {
            NumberAnimation { duration: 350; easing.type: Easing.InOutQuad }
        }

        transform: Translate {
            y: root.climateActive ? 0 : 28
            Behavior on y {
                NumberAnimation {
                    duration: 350
                    easing.type: Easing.OutCubic
                }
            }
        }

        // 1. Close Button (✕)
        Item {
            id: closeBtn
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 24
            width: 38
            height: 38

            Image {
                anchors.centerIn: parent
                source: "qrc:/ApexVision/qml/assets/icons/icon_left_close.png"
                width: 24
                height: 24
                fillMode: Image.PreserveAspectFit
            }

            MouseArea {
                id: closeMouse
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: true
                onClicked: root.climateCloseRequested()
            }

            opacity: closeMouse.pressed ? 0.6 : (closeMouse.containsMouse ? 0.85 : 1.0)
        }

        // =====================================================================
        // FRONT CLIMATE CONTROLS (Power, Airflow Pod, Sync)
        // =====================================================================
        Item {
            id: frontClimateControls
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: closeBtn.bottom
            anchors.bottom: parent.bottom
            visible: opacity > 0.001
            opacity: !root.isRearView ? 1.0 : 0.0
            enabled: !root.isRearView

            Behavior on opacity {
                NumberAnimation { duration: 250; easing.type: Easing.InOutQuad }
            }

            // Power Button (icon stays permanently stationary, yellow line appears underneath)
            Item {
                id: powerBtn
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 24
                width: 44
                height: 48

                Image {
                    id: powerIcon
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    anchors.topMargin: 2
                    source: "qrc:/ApexVision/qml/assets/icons/icon_left_power.png"
                    width: 30
                    height: 32
                    fillMode: Image.PreserveAspectFit
                    opacity: ClimateBackend.driverPower ? 1.0 : 0.40
                    Behavior on opacity { NumberAnimation { duration: 150 } }
                }

                // Little yellow line: ONLY visible when activated (stays fixed below icon, zero shift)
                Rectangle {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: powerIcon.bottom
                    anchors.topMargin: 5
                    width: 18
                    height: 3
                    radius: 1.5
                    color: "#FFA63D"
                    opacity: ClimateBackend.driverPower ? 1.0 : 0.0
                    Behavior on opacity { NumberAnimation { duration: 150 } }
                }

                MouseArea {
                    id: powerMouse
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: ClimateBackend.toggleDriverPower()
                }
            }

            // Airflow Mode Pod (Vertical Pill Container - aligned with cockpit dash)
            Rectangle {
                id: airflowPod
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                width: 58
                height: 168
                radius: 16
                color: "#350A1220"
                border.color: "#22FFFFFF"
                border.width: 1

                Column {
                    anchors.centerIn: parent
                    spacing: 4

                    // Windshield / Defrost Button
                    Rectangle {
                        id: frontDefrostBtn
                        property bool active: ClimateBackend.frontDefrost || ClimateBackend.airflowMode === 3
                        width: 50
                        height: 48
                        radius: 10
                        color: active ? "#253BF0FF" : (defrostMouse.containsMouse ? "#15FFFFFF" : "transparent")
                        border.color: active ? "#3BF0FF" : "transparent"
                        border.width: 1

                        Image {
                            anchors.centerIn: parent
                            source: frontDefrostBtn.active ? "qrc:/ApexVision/qml/assets/icons/icon_left_defrost_yellow.png" : "qrc:/ApexVision/qml/assets/icons/icon_left_defrost.png"
                            width: 28
                            height: 28
                            fillMode: Image.PreserveAspectFit
                            opacity: frontDefrostBtn.active ? 1.0 : (defrostMouse.containsMouse ? 0.80 : 0.45)
                            Behavior on opacity { NumberAnimation { duration: 150 } }
                        }

                        MouseArea {
                            id: defrostMouse
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            hoverEnabled: true
                            onClicked: ClimateBackend.toggleFrontDefrost()
                        }
                    }

                    // Face Vents Button (shows amber 'A' when Auto)
                    Rectangle {
                        id: frontFaceBtn
                        property bool active: ClimateBackend.airflowMode === 0 || ClimateBackend.airflowMode === 1
                        width: 50
                        height: 48
                        radius: 10
                        color: active ? "#253BF0FF" : (faceMouse.containsMouse ? "#15FFFFFF" : "transparent")
                        border.color: active ? "#3BF0FF" : "transparent"
                        border.width: 1

                        Image {
                            anchors.centerIn: parent
                            source: frontFaceBtn.active ? "qrc:/ApexVision/qml/assets/icons/icon_left_face_yellow.png" : "qrc:/ApexVision/qml/assets/icons/icon_left_face.png"
                            width: 40
                            height: 22
                            fillMode: Image.PreserveAspectFit
                            opacity: frontFaceBtn.active ? 1.0 : (faceMouse.containsMouse ? 0.80 : 0.45)
                            Behavior on opacity { NumberAnimation { duration: 150 } }
                        }

                        MouseArea {
                            id: faceMouse
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            hoverEnabled: true
                            onClicked: ClimateBackend.setAirflowMode(0)
                        }
                    }

                    // Floor / Feet Vents Button
                    Rectangle {
                        id: frontFeetBtn
                        property bool active: ClimateBackend.airflowMode === 2 || ClimateBackend.airflowMode === 1
                        width: 50
                        height: 48
                        radius: 10
                        color: active ? "#253BF0FF" : (feetMouse.containsMouse ? "#15FFFFFF" : "transparent")
                        border.color: active ? "#3BF0FF" : "transparent"
                        border.width: 1

                        Image {
                            anchors.centerIn: parent
                            source: frontFeetBtn.active ? "qrc:/ApexVision/qml/assets/icons/icon_left_feet_yellow.png" : "qrc:/ApexVision/qml/assets/icons/icon_left_feet.png"
                            width: 26
                            height: 26
                            fillMode: Image.PreserveAspectFit
                            opacity: frontFeetBtn.active ? 1.0 : (feetMouse.containsMouse ? 0.80 : 0.45)
                            Behavior on opacity { NumberAnimation { duration: 150 } }
                        }

                        MouseArea {
                            id: feetMouse
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            hoverEnabled: true
                            onClicked: ClimateBackend.setAirflowMode(2)
                        }
                    }
                }
            }

            // SYNC (Chains) Button (icon stays permanently stationary, yellow line appears underneath)
            Item {
                id: syncBtn
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: airflowPod.bottom
                anchors.topMargin: 24
                width: 48
                height: 42

                Image {
                    id: syncIcon
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    anchors.topMargin: 2
                    source: "qrc:/ApexVision/qml/assets/icons/icon_left_sync.png"
                    width: 38
                    height: 23
                    fillMode: Image.PreserveAspectFit
                    opacity: ClimateBackend.syncMode ? 1.0 : 0.40
                    Behavior on opacity { NumberAnimation { duration: 150 } }
                }

                // Little yellow line: ONLY visible when activated (stays fixed below icon, zero shift)
                Rectangle {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: syncIcon.bottom
                    anchors.topMargin: 5
                    width: 18
                    height: 3
                    radius: 1.5
                    color: "#FFA63D"
                    opacity: ClimateBackend.syncMode ? 1.0 : 0.0
                    Behavior on opacity { NumberAnimation { duration: 150 } }
                }

                MouseArea {
                    id: syncMouse
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: ClimateBackend.setSyncMode(!ClimateBackend.syncMode)
                }
            }
        }

        // =====================================================================
        // REAR CLIMATE CONTROLS (Power 2/3, AUTO, Face 2/3, Feet 2/3, Rear Lock)
        // =====================================================================
        Item {
            id: rearClimateControls
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: closeBtn.bottom
            anchors.bottom: parent.bottom
            visible: opacity > 0.001
            opacity: root.isRearView ? 1.0 : 0.0
            enabled: root.isRearView

            Behavior on opacity {
                NumberAnimation { duration: 250; easing.type: Easing.InOutQuad }
            }

            // 1. Power Button with Row Number ("⏻ 2" or "⏻ 3")
            // Positioned at the exact same location as the front power button
            Item {
                id: rearPowerBtn
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 24
                width: 44
                height: 48

                Image {
                    id: rearPowerIcon
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    anchors.topMargin: 2
                    source: "qrc:/ApexVision/qml/assets/icons/icon_left_power.png"
                    width: 30
                    height: 32
                    fillMode: Image.PreserveAspectFit
                    opacity: ClimateBackend.rearPower ? 1.0 : 0.40
                    Behavior on opacity { NumberAnimation { duration: 150 } }
                }

                Text {
                    anchors.left: rearPowerIcon.right
                    anchors.leftMargin: 2
                    anchors.verticalCenter: rearPowerIcon.verticalCenter
                    text: ClimateBackend.rearSelectedRow.toString()
                    color: "#FFFFFF"
                    font.family: "Inter"
                    font.pixelSize: 13
                    font.weight: Font.Bold
                    opacity: ClimateBackend.rearPower ? 1.0 : 0.40
                    Behavior on opacity { NumberAnimation { duration: 150 } }
                }

                // Amber active indicator bar (identical position and size as front power button)
                Rectangle {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: rearPowerIcon.bottom
                    anchors.topMargin: 5
                    width: 18
                    height: 3
                    radius: 1.5
                    color: "#FFA63D"
                    opacity: ClimateBackend.rearPower ? 1.0 : 0.0
                    Behavior on opacity { NumberAnimation { duration: 150 } }
                }

                MouseArea {
                    id: rearPowerMouse
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: ClimateBackend.toggleRearPower()
                }
            }

            Column {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                spacing: 24

                // 2. AUTO Mode Button
                Item {
                    id: rearAutoBtn
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: 52
                    height: 38

                    Column {
                        anchors.centerIn: parent
                        spacing: 5

                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "AUTO"
                            color: "#FFFFFF"
                            font.family: "Inter"
                            font.pixelSize: 13
                            font.weight: Font.Bold
                            font.letterSpacing: 0.6
                            opacity: ClimateBackend.rearAutoMode ? 1.0 : (rearAutoMouse.containsMouse ? 0.85 : 0.45)
                            Behavior on opacity { NumberAnimation { duration: 150 } }
                        }

                        // Amber indicator bar when active
                        Rectangle {
                            anchors.horizontalCenter: parent.horizontalCenter
                            width: 16
                            height: 3
                            radius: 1.5
                            color: "#FFA63D"
                            opacity: ClimateBackend.rearAutoMode ? 1.0 : 0.0
                            Behavior on opacity { NumberAnimation { duration: 150 } }
                        }
                    }

                    MouseArea {
                        id: rearAutoMouse
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true
                        onClicked: ClimateBackend.toggleRearAuto()
                    }
                }

                // 3. Face Airflow Button ("→ 👤 2") - Previous logo with yellow arrow when active, no border
                Item {
                    id: rearFaceBtn
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: 54
                    height: 40
                    property bool active: ClimateBackend.rearAirflowMode === 0

                    Row {
                        anchors.centerIn: parent
                        spacing: 3

                        Image {
                            anchors.verticalCenter: parent.verticalCenter
                            source: rearFaceBtn.active ? "qrc:/ApexVision/qml/assets/icons/icon_rear_face_yellow.png" : "qrc:/ApexVision/qml/assets/icons/icon_rear_face.png"
                            width: 25
                            height: 22
                            fillMode: Image.PreserveAspectFit
                            opacity: rearFaceBtn.active ? 1.0 : (rearFaceMouse.containsMouse ? 0.80 : 0.45)
                            Behavior on opacity { NumberAnimation { duration: 150 } }
                        }

                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            text: ClimateBackend.rearSelectedRow.toString()
                            color: "#FFFFFF"
                            font.family: "Inter"
                            font.pixelSize: 13
                            font.weight: Font.DemiBold
                            opacity: rearFaceBtn.active ? 1.0 : (rearFaceMouse.containsMouse ? 0.80 : 0.45)
                            Behavior on opacity { NumberAnimation { duration: 150 } }
                        }
                    }

                    MouseArea {
                        id: rearFaceMouse
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true
                        onClicked: ClimateBackend.setRearAirflowMode(0)
                    }
                }

                // 4. Feet Airflow Button ("↘ 👤 2") - Previous logo with yellow arrow when active, no border
                Item {
                    id: rearFeetBtn
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: 54
                    height: 40
                    property bool active: ClimateBackend.rearAirflowMode === 1

                    Row {
                        anchors.centerIn: parent
                        spacing: 3

                        Image {
                            anchors.verticalCenter: parent.verticalCenter
                            source: rearFeetBtn.active ? "qrc:/ApexVision/qml/assets/icons/icon_left_feet_yellow.png" : "qrc:/ApexVision/qml/assets/icons/icon_left_feet.png"
                            width: 23
                            height: 23
                            fillMode: Image.PreserveAspectFit
                            opacity: rearFeetBtn.active ? 1.0 : (rearFeetMouse.containsMouse ? 0.80 : 0.45)
                            Behavior on opacity { NumberAnimation { duration: 150 } }
                        }

                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            text: ClimateBackend.rearSelectedRow.toString()
                            color: "#FFFFFF"
                            font.family: "Inter"
                            font.pixelSize: 13
                            font.weight: Font.DemiBold
                            opacity: rearFeetBtn.active ? 1.0 : (rearFeetMouse.containsMouse ? 0.80 : 0.45)
                            Behavior on opacity { NumberAnimation { duration: 150 } }
                        }
                    }

                    MouseArea {
                        id: rearFeetMouse
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true
                        onClicked: ClimateBackend.setRearAirflowMode(1)
                    }
                }

                // 4. Rear Lockout Button ("🔒 R" with amber bar)
                Item {
                    id: rearLockBtn
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: 48
                    height: 44

                    Column {
                        anchors.centerIn: parent
                        spacing: 5

                        Row {
                            anchors.horizontalCenter: parent.horizontalCenter
                            spacing: 4

                            // Vector crisp padlock
                            Item {
                                width: 14
                                height: 16
                                anchors.verticalCenter: parent.verticalCenter
                                opacity: ClimateBackend.rearLock ? 1.0 : 0.50

                                Rectangle {
                                    anchors.top: parent.top
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    width: 10
                                    height: 8
                                    radius: 5
                                    color: "transparent"
                                    border.color: "#FFFFFF"
                                    border.width: 1.5
                                }

                                Rectangle {
                                    anchors.bottom: parent.bottom
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    width: 14
                                    height: 9
                                    radius: 2
                                    color: "#FFFFFF"
                                }
                            }

                            Text {
                                text: "R"
                                color: "#FFFFFF"
                                font.family: "Inter"
                                font.pixelSize: 14
                                font.weight: Font.Bold
                                opacity: ClimateBackend.rearLock ? 1.0 : 0.50
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }

                        // Amber indicator bar
                        Rectangle {
                            anchors.horizontalCenter: parent.horizontalCenter
                            width: 18
                            height: 3
                            radius: 1.5
                            color: "#FFA63D"
                            opacity: ClimateBackend.rearLock ? 1.0 : 0.0
                            Behavior on opacity { NumberAnimation { duration: 150 } }
                        }
                    }

                    MouseArea {
                        id: rearLockMouse
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: ClimateBackend.toggleRearLock()
                    }
                }
            }
        }
    }

    // Pure borderless automotive navigation item:
    component ApexNavItem: Item {
        id: navItem
        property string icon: ""
        property real iconWidth: 32
        property real iconHeight: 32
        property bool isSelected: false
        signal clicked()

        width: 60
        height: 48
        anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined

        Image {
            id: iconImg
            anchors.centerIn: parent
            width: navItem.iconWidth
            height: navItem.iconHeight
            fillMode: Image.PreserveAspectFit
            source: navItem.icon
            smooth: true
            mipmap: true

            opacity: navMouse.pressed ? 1.0 :
                     (navItem.isSelected ? 1.0 : 0.38)

            scale: navMouse.pressed ? 0.92 :
                   (navItem.isSelected ? 1.10 : 1.0)

            Behavior on opacity {
                NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
            }
            Behavior on scale {
                NumberAnimation { duration: 220; easing.type: Easing.OutCubic }
            }
        }

        MouseArea {
            id: navMouse
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: navItem.clicked()
        }
    }
}
