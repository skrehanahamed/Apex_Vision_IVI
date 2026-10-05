/**
 * ==============================================================================
 * Project: Apex VISION IVI - Digital Cockpit & Infotainment System
 * File: CabinAirRefreshOverlay.qml
 * Author / Developer: Sk Rehan Ahamed
 * License: MIT
 * ==============================================================================
 */

import QtQuick
import QtQuick.Controls

Item {
    id: airOverlay
    objectName: "airQualityOverlay"

    signal closeRequested()

    property int currentPm25: 3
    property bool isRefreshing: false
    property bool infoPopupOpen: false
    property int timeOffsetMinutes: 0

    // Prevent clicks from passing through to underlying items
    MouseArea {
        anchors.fill: parent
        onClicked: {
            if (airOverlay.infoPopupOpen) {
                airOverlay.infoPopupOpen = false;
            }
        }
    }

    // =========================================================================
    // 0. DEFAULT BACKGROUND (Matching OEM Screen & Project Master Wallpaper)
    // =========================================================================
    Image {
        id: defaultBgImage
        anchors.fill: parent
        source: "qrc:/ApexVision/qml/assets/default_background.png"
        fillMode: Image.PreserveAspectCrop
        smooth: true
        z: 0
    }

    // Subtle dark glass scrim for text contrast matching the user's reference photo
    Rectangle {
        anchors.fill: parent
        color: Qt.rgba(4/255, 10/255, 22/255, 0.42)
        z: 1
    }

    // Top edge glass highlight
    Rectangle {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 1
        color: Qt.rgba(255, 255, 255, 0.16)
        z: 2
    }

    // =========================================================================
    // 1. TOP HEADER: [✕] [PM 2.5: 3 µg / m³] ............... [ⓘ]
    // =========================================================================
    Item {
        id: topHeader
        anchors.top: parent.top
        anchors.topMargin: 36
        anchors.left: parent.left
        anchors.leftMargin: 48
        anchors.right: parent.right
        anchors.rightMargin: 48
        height: 48
        z: 10

        // Close Button (✕)
        Item {
            id: closeBtn
            width: 44
            height: 44
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter

            Rectangle {
                anchors.centerIn: parent
                width: 38
                height: 38
                radius: 19
                color: closeMouse.pressed ? Qt.rgba(255, 255, 255, 0.18) :
                       (closeMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.10) : "transparent")
                border.color: closeMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.25) : "transparent"
                border.width: 1
                Behavior on color { ColorAnimation { duration: 150 } }
            }

            Text {
                anchors.centerIn: parent
                text: "✕"
                font.family: "Inter"
                font.pixelSize: 22
                font.weight: Font.DemiBold
                color: closeMouse.pressed ? "#94A3B8" : (closeMouse.containsMouse ? "#FFFFFF" : "#E2E8F0")
            }

            MouseArea {
                id: closeMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: airOverlay.closeRequested()
            }
        }

        // PM 2.5 Title & Measurement
        Row {
            anchors.left: closeBtn.right
            anchors.leftMargin: 24
            anchors.verticalCenter: parent.verticalCenter
            spacing: 6

            Text {
                text: "PM 2.5:"
                font.family: "Inter"
                font.pixelSize: 26
                font.weight: Font.Bold
                color: "#FFFFFF"
                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                text: airOverlay.currentPm25.toString()
                font.family: "Inter"
                font.pixelSize: 26
                font.weight: Font.Bold
                color: airOverlay.currentPm25 <= 12 ? "#22C55E" : "#F59E0B"
                anchors.verticalCenter: parent.verticalCenter
                Behavior on color { ColorAnimation { duration: 300 } }
            }

            Text {
                text: "µg / m³"
                font.family: "Inter"
                font.pixelSize: 21
                font.weight: Font.Normal
                color: "#94A3B8"
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: 1
            }
        }

        // Info Button (ⓘ)
        Item {
            id: infoBtn
            width: 44
            height: 44
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter

            Rectangle {
                anchors.centerIn: parent
                width: 36
                height: 36
                radius: 18
                color: infoMouse.pressed ? Qt.rgba(255, 255, 255, 0.20) :
                       (infoMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.12) : Qt.rgba(255, 255, 255, 0.06))
                border.color: infoMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.40) : Qt.rgba(255, 255, 255, 0.20)
                border.width: 1
                Behavior on color { ColorAnimation { duration: 150 } }

                Rectangle {
                    anchors.centerIn: parent
                    width: 20
                    height: 20
                    radius: 10
                    color: "transparent"
                    border.color: infoMouse.containsMouse ? "#FFFFFF" : "#CBD5E1"
                    border.width: 1.6

                    Text {
                        anchors.centerIn: parent
                        anchors.verticalCenterOffset: -0.5
                        text: "i"
                        font.family: "Inter"
                        font.pixelSize: 12
                        font.weight: Font.Bold
                        color: infoMouse.containsMouse ? "#FFFFFF" : "#CBD5E1"
                    }
                }
            }

            MouseArea {
                id: infoMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: airOverlay.infoPopupOpen = !airOverlay.infoPopupOpen
            }
        }
    }

    // =========================================================================
    // 2. TIMELINE RANGE & Y-AXIS SCALE
    // =========================================================================
    Item {
        id: chartArea
        anchors.left: parent.left
        anchors.leftMargin: 84
        anchors.right: parent.right
        anchors.rightMargin: 84
        anchors.top: topHeader.bottom
        anchors.topMargin: 24
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 130
        z: 10

        // Start Time (03:12 PM) - Left Aligned
        Text {
            id: startTimeText
            anchors.left: parent.left
            anchors.leftMargin: 36
            anchors.top: parent.top
            text: "03:12 PM"
            font.family: "Inter"
            font.pixelSize: 20
            font.weight: Font.Medium
            color: "#94A3B8"
        }

        // End Time (05:55 PM) - Aligned with Rightmost Track
        Text {
            id: endTimeText
            anchors.right: yAxisScale.left
            anchors.rightMargin: 40
            anchors.top: parent.top
            text: "05:55 PM"
            font.family: "Inter"
            font.pixelSize: 20
            font.weight: Font.Medium
            color: "#94A3B8"
        }

        // Right Y-Axis Scale: 500, 250, 0
        Item {
            id: yAxisScale
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.topMargin: 56
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 40
            width: 48

            // Top: 500
            Text {
                anchors.top: parent.top
                anchors.right: parent.right
                text: "500"
                font.family: "Inter"
                font.pixelSize: 15
                font.weight: Font.Medium
                color: "#64748B"
            }

            // Middle: 250
            Text {
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                text: "250"
                font.family: "Inter"
                font.pixelSize: 15
                font.weight: Font.Medium
                color: "#64748B"
            }

            // Bottom: 0
            Text {
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                text: "0"
                font.family: "Inter"
                font.pixelSize: 15
                font.weight: Font.Medium
                color: "#64748B"
            }
        }

        // Reference Lines
        Item {
            id: gridLines
            anchors.left: parent.left
            anchors.leftMargin: 36
            anchors.right: yAxisScale.left
            anchors.rightMargin: 20
            anchors.top: parent.top
            anchors.topMargin: 64
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 48

            // Top Reference line (500)
            Rectangle {
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                height: 1
                color: Qt.rgba(255, 255, 255, 0.07)
            }

            // Mid Reference line (250)
            Rectangle {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.right: parent.right
                height: 1
                color: Qt.rgba(255, 255, 255, 0.07)
            }

            // Bottom Baseline (0)
            Rectangle {
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                height: 1
                color: Qt.rgba(255, 255, 255, 0.15)
            }
        }

        // =====================================================================
        // 3. THE 12 TIMELINE VERTICAL TRACKS & PILLS
        // =====================================================================
        // Left History Chevron (<)
        Item {
            id: leftChevronBtn
            anchors.left: parent.left
            anchors.verticalCenter: gridLines.verticalCenter
            width: 36
            height: 36

            Rectangle {
                anchors.centerIn: parent
                width: 32
                height: 32
                radius: 16
                color: chevronMouse.pressed ? Qt.rgba(255, 255, 255, 0.16) :
                       (chevronMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.08) : "transparent")
                border.color: chevronMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.30) : "transparent"
                border.width: 1
            }

            Text {
                anchors.centerIn: parent
                text: "‹"
                font.family: "Inter"
                font.pixelSize: 28
                font.weight: Font.Bold
                color: chevronMouse.containsMouse ? "#FFFFFF" : "#94A3B8"
            }

            MouseArea {
                id: chevronMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    airOverlay.timeOffsetMinutes += 30;
                }
            }
        }

        // Row of 12 Vertical Rails
        Item {
            id: railsContainer
            anchors.left: parent.left
            anchors.leftMargin: 64
            anchors.right: yAxisScale.left
            anchors.rightMargin: 40
            anchors.top: gridLines.top
            anchors.bottom: gridLines.bottom

            // 12 tracks: indexes 0-5 empty/past, indexes 6-11 active (14, 8, 5, 4, 3, current)
            readonly property var trackData: [
                { val: -1, color: "" },
                { val: -1, color: "" },
                { val: -1, color: "" },
                { val: -1, color: "" },
                { val: -1, color: "" },
                { val: -1, color: "" },
                { val: 14, color: "#EAB308" },
                { val: 8,  color: "#22C55E" },
                { val: 5,  color: "#22C55E" },
                { val: 4,  color: "#22C55E" },
                { val: 3,  color: "#22C55E" },
                { val: airOverlay.currentPm25, color: airOverlay.currentPm25 <= 12 ? "#22C55E" : "#EAB308" }
            ]

            Repeater {
                model: 12

                Item {
                    id: trackItem
                    property int colIndex: index
                    property var dataEntry: railsContainer.trackData[index]
                    property bool hasData: dataEntry.val > 0

                    x: Math.round(index * (railsContainer.width / 11) - width / 2)
                    y: 0
                    width: 44
                    height: railsContainer.height

                    // Vertical Track Rail
                    Rectangle {
                        id: rail
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        width: 11
                        radius: 5.5
                        color: Qt.rgba(255, 255, 255, 0.12)
                        border.color: Qt.rgba(255, 255, 255, 0.05)
                        border.width: 1
                    }

                    // Value Pill (at the base of the track line)
                    Rectangle {
                        id: valuePill
                        visible: trackItem.hasData
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottom: parent.bottom
                        width: 11
                        height: trackItem.hasData ? Math.max(22, Math.min(railsContainer.height - 20, Math.round((trackItem.dataEntry.val / 500.0) * railsContainer.height * 2.8))) : 0
                        radius: 5.5
                        color: trackItem.hasData ? trackItem.dataEntry.color : "transparent"

                        // Soft Neon Glow effect around active pill
                        Rectangle {
                            anchors.fill: parent
                            anchors.margins: -4
                            radius: parent.radius + 4
                            color: trackItem.hasData ? Qt.rgba(trackItem.dataEntry.color === "#EAB308" ? 0.92 : 0.13,
                                                               trackItem.dataEntry.color === "#EAB308" ? 0.70 : 0.77,
                                                               trackItem.dataEntry.color === "#EAB308" ? 0.03 : 0.37, 0.35) : "transparent"
                            z: -1
                        }

                        Behavior on height {
                            NumberAnimation { duration: 400; easing.type: Easing.OutCubic }
                        }
                    }

                    // Numeric Value label beside the pill
                    Text {
                        visible: trackItem.hasData
                        anchors.left: rail.right
                        anchors.leftMargin: 8
                        anchors.verticalCenter: valuePill.top
                        anchors.verticalCenterOffset: 6
                        text: trackItem.hasData ? trackItem.dataEntry.val.toString() : ""
                        font.family: "Inter"
                        font.pixelSize: 17
                        font.weight: Font.DemiBold
                        color: "#FFFFFF"
                    }
                }
            }
        }
    }

    // =========================================================================
    // 4. BOTTOM BAR: [Refresh cabin] Button, [Active] Pill, & Filter Status
    // =========================================================================
    Item {
        id: bottomControlsRow
        anchors.left: parent.left
        anchors.leftMargin: 84
        anchors.right: parent.right
        anchors.rightMargin: 84
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 32
        height: 60
        z: 10

        // [ Refresh cabin ] Floating Action Button (Matches Photo 1 & Photo 2)
        Rectangle {
            id: refreshCabinBtn
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            width: 220
            height: 52
            radius: 16
            clip: true

            // Clean Frosted Glass Fill
            gradient: Gradient {
                GradientStop {
                    position: 0.0
                    color: refreshMouseArea.pressed ? Qt.rgba(255, 255, 255, 0.24) :
                           (refreshMouseArea.containsMouse ? Qt.rgba(255, 255, 255, 0.18) :
                           (airOverlay.isRefreshing ? Qt.rgba(255, 255, 255, 0.18) : Qt.rgba(255, 255, 255, 0.11)))
                }
                GradientStop {
                    position: 1.0
                    color: refreshMouseArea.pressed ? Qt.rgba(255, 255, 255, 0.18) :
                           (refreshMouseArea.containsMouse ? Qt.rgba(255, 255, 255, 0.12) :
                           (airOverlay.isRefreshing ? Qt.rgba(255, 255, 255, 0.12) : Qt.rgba(255, 255, 255, 0.06)))
                }
            }

            // Selected in yellow when active per user instruction!
            border.color: airOverlay.isRefreshing ? "#F59E0B" :
                          (refreshMouseArea.containsMouse ? Qt.rgba(255, 255, 255, 0.55) : Qt.rgba(255, 255, 255, 0.28))
            border.width: airOverlay.isRefreshing ? 2.0 : 1.2

            Behavior on border.color { ColorAnimation { duration: 180 } }
            Behavior on border.width { NumberAnimation { duration: 180 } }

            Text {
                anchors.centerIn: parent
                text: "Refresh cabin"
                font.family: "Inter"
                font.pixelSize: 18
                font.weight: Font.Medium
                color: "#FFFFFF"
                renderType: Text.NativeRendering
            }

            MouseArea {
                id: refreshMouseArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    if (!airOverlay.isRefreshing) {
                        airOverlay.isRefreshing = true;
                        airOverlay.currentPm25 = 2; // Cleanest filtered air reading
                        autoDeactivateTimer.restart();
                    } else {
                        airOverlay.isRefreshing = false;
                        autoDeactivateTimer.stop();
                    }
                }
            }
        }

        // [ Active ] Dark Button Pill (Matches Photo 2, positioned directly under tracks 7-8)
        Rectangle {
            id: activeBadgeBtn
            visible: airOverlay.isRefreshing
            opacity: airOverlay.isRefreshing ? 1.0 : 0.0
            x: railsContainer.x + Math.round((7.2 / 11.0) * railsContainer.width) - width / 2
            anchors.verticalCenter: parent.verticalCenter
            width: 108
            height: 46
            radius: 11
            color: "#0C1728" // Deep cockpit card dark blue/slate
            border.color: activeMouseArea.containsMouse ? Qt.rgba(255, 255, 255, 0.45) : Qt.rgba(255, 255, 255, 0.22)
            border.width: 1.2

            Behavior on opacity { NumberAnimation { duration: 200 } }

            Text {
                anchors.centerIn: parent
                text: "Active"
                font.family: "Inter"
                font.pixelSize: 16
                font.weight: Font.DemiBold
                color: "#FFFFFF"
            }

            MouseArea {
                id: activeMouseArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    airOverlay.isRefreshing = false;
                    autoDeactivateTimer.stop();
                }
            }
        }

        // Status Badge: (✓) Cabin air is filtered (Exact icon used in 3D climate!)
        Row {
            id: filterStatusRow
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            spacing: 10
            visible: !airOverlay.isRefreshing
            opacity: !airOverlay.isRefreshing ? 1.0 : 0.0
            Behavior on opacity { NumberAnimation { duration: 200 } }

            // 3D Climate Refresh Icon (Green checkmark with airflow breeze from 3D climate)
            Image {
                source: "qrc:/ApexVision/qml/assets/icons/icon_right_refresh.png"
                width: 38
                height: 28
                fillMode: Image.PreserveAspectFit
                smooth: true
                mipmap: true
                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: "Cabin air is filtered"
                font.family: "Inter"
                font.pixelSize: 17
                font.weight: Font.Medium
                color: "#E2E8F0"
                renderType: Text.NativeRendering
            }
        }
    }

    // Auto-deactivate timer: stays active for 4 seconds then returns to normal
    Timer {
        id: autoDeactivateTimer
        interval: 4000
        repeat: false
        onTriggered: {
            airOverlay.isRefreshing = false;
        }
    }

    // =========================================================================
    // 5. INFO POPUP (Air Quality Index Guidelines)
    // =========================================================================
    Rectangle {
        id: infoCard
        visible: airOverlay.infoPopupOpen
        anchors.right: topHeader.right
        anchors.top: topHeader.bottom
        anchors.topMargin: 12
        width: 320
        height: 190
        radius: 16
        z: 30
        clip: true

        gradient: Gradient {
            GradientStop { position: 0.0; color: Qt.rgba(20/255, 30/255, 48/255, 0.96) }
            GradientStop { position: 1.0; color: Qt.rgba(12/255, 20/255, 34/255, 0.98) }
        }

        border.color: Qt.rgba(255, 255, 255, 0.25)
        border.width: 1.2

        Column {
            anchors.fill: parent
            anchors.margins: 18
            spacing: 10

            Text {
                text: "Air Quality Index (PM 2.5)"
                font.family: "Inter"
                font.pixelSize: 16
                font.weight: Font.Bold
                color: "#FFFFFF"
            }

            Rectangle {
                width: parent.width
                height: 1
                color: Qt.rgba(255, 255, 255, 0.12)
            }

            Row {
                spacing: 8
                Rectangle { width: 10; height: 10; radius: 5; color: "#22C55E"; anchors.verticalCenter: parent.verticalCenter }
                Text { text: "0 – 12 µg/m³ : Good (Clean air)"; font.family: "Inter"; font.pixelSize: 13; color: "#CBD5E1" }
            }

            Row {
                spacing: 8
                Rectangle { width: 10; height: 10; radius: 5; color: "#EAB308"; anchors.verticalCenter: parent.verticalCenter }
                Text { text: "13 – 35 µg/m³ : Moderate"; font.family: "Inter"; font.pixelSize: 13; color: "#CBD5E1" }
            }

            Row {
                spacing: 8
                Rectangle { width: 10; height: 10; radius: 5; color: "#EF4444"; anchors.verticalCenter: parent.verticalCenter }
                Text { text: "36+ µg/m³ : High / Filter recommended"; font.family: "Inter"; font.pixelSize: 13; color: "#CBD5E1" }
            }
        }
    }
}
