/**
 * ==============================================================================
 * Project: Apex VISION IVI - Digital Cockpit & Infotainment System
 * File: NavigationPanel.qml
 * Author / Developer: Sk Rehan Ahamed
 * License: MIT
 * ==============================================================================
 */

import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import ApexVision
import ".."

Item {
    id: root
    objectName: "navPanelComponent"

    property bool isExpanded: false
    signal toggleExpandRequested(bool openSearch)

    function openSearch() {
        searchOverlay.visible = true;
    }

    function updateApiKeyInMap() {}
    function updateVehiclePositionInMap() {}
    function updateStreetNameInMap() {}
    function searchInMap(query) {}
    function recenterMap() {}
    function updateMapTheme() {}

    readonly property bool isNightMode: true

    // Mask for true rounded corners in compact mode (squared off in expanded mode)
    Rectangle {
        id: mapMask
        anchors.fill: parent
        radius: root.isExpanded ? 0 : 18
        color: "#000000"
        visible: false
        layer.enabled: true
    }

    // Map container
    Item {
        id: mapContainer
        anchors.fill: parent
        layer.enabled: true
        layer.effect: MultiEffect {
            maskEnabled: true
            maskSource: mapMask
        }

        // =====================================================================
        // 1. DIGITAL COCKPIT VECTOR NAVIGATION BACKGROUND
        // =====================================================================
        Rectangle {
            anchors.fill: parent
            color: "#080D1A" // Deep navy dark mode

            // Stylized Road Grid / Perspective Lines
            Canvas {
                id: mapCanvas
                anchors.fill: parent
                onPaint: {
                    var ctx = getContext("2d");
                    ctx.clearRect(0, 0, width, height);

                    // Background ambient terrain blocks
                    ctx.fillStyle = "#0D1527";
                    ctx.fillRect(0, 0, width * 0.45, height * 0.35);
                    ctx.fillRect(width * 0.55, 0, width * 0.45, height * 0.4);
                    ctx.fillRect(0, height * 0.65, width * 0.4, height * 0.35);
                    ctx.fillRect(width * 0.6, height * 0.6, width * 0.4, height * 0.4);

                    // Secondary roads (subtle dark blue lines)
                    ctx.strokeStyle = "rgba(30, 48, 80, 0.75)";
                    ctx.lineWidth = 14;
                    ctx.beginPath();
                    // Horizontal crossing
                    ctx.moveTo(0, height * 0.42);
                    ctx.lineTo(width, height * 0.42);
                    // Diagonal arterial
                    ctx.moveTo(0, height * 0.85);
                    ctx.lineTo(width * 0.6, 0);
                    ctx.stroke();

                    // Secondary road inner line
                    ctx.strokeStyle = "rgba(45, 70, 115, 0.4)";
                    ctx.lineWidth = 8;
                    ctx.beginPath();
                    ctx.moveTo(0, height * 0.42);
                    ctx.lineTo(width, height * 0.42);
                    ctx.moveTo(0, height * 0.85);
                    ctx.lineTo(width * 0.6, 0);
                    ctx.stroke();

                    // Main Expressway Route (Glowing Cyan / Teal)
                    var startX = width * 0.48;
                    var startY = height * 0.88;
                    var midX = width * 0.48;
                    var midY = height * 0.48;
                    var bendX = width * 0.72;
                    var bendY = height * 0.22;

                    // Route Outer Glow
                    ctx.strokeStyle = "rgba(0, 229, 255, 0.18)";
                    ctx.lineWidth = 26;
                    ctx.lineCap = "round";
                    ctx.lineJoin = "round";
                    ctx.beginPath();
                    ctx.moveTo(startX, startY);
                    ctx.lineTo(midX, midY);
                    ctx.bezierCurveTo(midX, midY - 60, bendX - 60, bendY, bendX, bendY);
                    ctx.lineTo(width * 0.78, height * 0.12);
                    ctx.stroke();

                    // Route Core
                    ctx.strokeStyle = "#00E5FF";
                    ctx.lineWidth = 10;
                    ctx.beginPath();
                    ctx.moveTo(startX, startY);
                    ctx.lineTo(midX, midY);
                    ctx.bezierCurveTo(midX, midY - 60, bendX - 60, bendY, bendX, bendY);
                    ctx.lineTo(width * 0.78, height * 0.12);
                    ctx.stroke();

                    // Route Centerline Dots
                    ctx.strokeStyle = "#FFFFFF";
                    ctx.lineWidth = 2;
                    ctx.setLineDash([8, 12]);
                    ctx.beginPath();
                    ctx.moveTo(startX, startY);
                    ctx.lineTo(midX, midY);
                    ctx.bezierCurveTo(midX, midY - 60, bendX - 60, bendY, bendX, bendY);
                    ctx.lineTo(width * 0.78, height * 0.12);
                    ctx.stroke();
                    ctx.setLineDash([]);
                }
            }

            // Destination Flag Pin at (width * 0.78, height * 0.12)
            Item {
                x: parent.width * 0.78 - 18
                y: parent.height * 0.12 - 36
                width: 36
                height: 36

                Rectangle {
                    width: 32
                    height: 32
                    radius: 16
                    color: "#00E5FF"
                    border.color: "#FFFFFF"
                    border.width: 2
                    anchors.centerIn: parent

                    Text {
                        anchors.centerIn: parent
                        text: "★"
                        color: "#070A0F"
                        font.pixelSize: 16
                        font.bold: true
                    }
                }
            }

            // GPS Vehicle Location Puck (Pulsing Apex Arrow)
            Item {
                id: vehiclePuck
                x: parent.width * 0.48 - 24
                y: parent.height * 0.88 - 24
                width: 48
                height: 48

                // Pulse ring
                Rectangle {
                    anchors.centerIn: parent
                    width: 44
                    height: 44
                    radius: 22
                    color: "transparent"
                    border.color: Qt.rgba(0/255, 229/255, 255/255, 0.4)
                    border.width: 2

                    SequentialAnimation on scale {
                        loops: Animation.Infinite
                        NumberAnimation { from: 0.8; to: 1.5; duration: 1800; easing.type: Easing.OutQuad }
                    }
                    SequentialAnimation on opacity {
                        loops: Animation.Infinite
                        NumberAnimation { from: 0.8; to: 0.0; duration: 1800; easing.type: Easing.OutQuad }
                    }
                }

                // Center core puck
                Rectangle {
                    anchors.centerIn: parent
                    width: 28
                    height: 28
                    radius: 14
                    color: "#00E5FF"
                    border.color: "#FFFFFF"
                    border.width: 2.5

                    // Vehicle arrowhead pointing up along route
                    Text {
                        anchors.centerIn: parent
                        text: "▲"
                        color: "#080D1A"
                        font.pixelSize: 14
                        font.bold: true
                    }
                }
            }

            // =================================================================
            // 2. TURN-BY-TURN HUD MANEUVER CARD (Top-Left)
            // =================================================================
            Rectangle {
                x: 16
                y: 16
                width: Math.min(320, parent.width - 32)
                height: 84
                radius: 14
                color: Qt.rgba(11/255, 18/255, 34/255, 0.88)
                border.color: Qt.rgba(0/255, 229/255, 255/255, 0.35)
                border.width: 1.5

                Row {
                    anchors.fill: parent
                    anchors.margins: 12
                    spacing: 14

                    // Turn maneuver icon container
                    Rectangle {
                        width: 56
                        height: 56
                        radius: 12
                        color: Qt.rgba(0/255, 229/255, 255/255, 0.15)
                        anchors.verticalCenter: parent.verticalCenter

                        Text {
                            anchors.centerIn: parent
                            text: "↱"
                            font.pixelSize: 32
                            font.bold: true
                            color: "#00E5FF"
                        }
                    }

                    // Maneuver text
                    Column {
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 2
                        width: parent.width - 70

                        Text {
                            text: (typeof NavigationBackend !== "undefined" && NavigationBackend.remainingDistance) ?
                                  NavigationBackend.remainingDistance : "800 ft"
                            color: "#FFFFFF"
                            font.pixelSize: 20
                            font.bold: true
                            font.family: "Inter"
                        }

                        Text {
                            text: (typeof NavigationBackend !== "undefined" && NavigationBackend.maneuverInstruction) ?
                                  NavigationBackend.maneuverInstruction : "Bear right onto Tech Blvd"
                            color: Qt.rgba(255/255, 255/255, 255/255, 0.75)
                            font.pixelSize: 13
                            font.family: "Inter"
                            elide: Text.ElideRight
                            width: parent.width
                        }
                    }
                }
            }

            // =================================================================
            // 3. SPEED LIMIT & COMPASS WIDGET (Top-Right)
            // =================================================================
            Row {
                anchors.top: parent.top
                anchors.right: parent.right
                anchors.topMargin: 16
                anchors.rightMargin: 16
                spacing: 10

                // Speed Limit Sign
                Rectangle {
                    width: 44
                    height: 56
                    radius: 8
                    color: "#FFFFFF"
                    border.color: "#000000"
                    border.width: 2.5

                    Column {
                        anchors.centerIn: parent
                        spacing: 0
                        Text {
                            text: "SPEED"
                            font.pixelSize: 8
                            font.bold: true
                            color: "#000000"
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                        Text {
                            text: "LIMIT"
                            font.pixelSize: 8
                            font.bold: true
                            color: "#000000"
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                        Text {
                            text: (typeof NavigationBackend !== "undefined" && NavigationBackend.speedLimit > 0) ?
                                  String(NavigationBackend.speedLimit) : "65"
                            font.pixelSize: 16
                            font.bold: true
                            color: "#000000"
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }
                }

                // Compass Rose
                Rectangle {
                    width: 44
                    height: 56
                    radius: 8
                    color: Qt.rgba(11/255, 18/255, 34/255, 0.88)
                    border.color: Qt.rgba(255/255, 255/255, 255/255, 0.2)
                    border.width: 1

                    Column {
                        anchors.centerIn: parent
                        spacing: 2
                        Text {
                            text: "▲"
                            font.pixelSize: 14
                            color: "#EF4444" // Red north pointer
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                        Text {
                            text: "N"
                            font.pixelSize: 13
                            font.bold: true
                            color: "#FFFFFF"
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }
                }
            }

            // =================================================================
            // 4. BOTTOM TRIP INFO BAR (ETA, Distance, Destination)
            // =================================================================
            Rectangle {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.margins: 14
                height: 52
                radius: 14
                color: Qt.rgba(11/255, 18/255, 34/255, 0.92)
                border.color: Qt.rgba(255, 255, 255, 0.18)
                border.width: 1

                Row {
                    anchors.fill: parent
                    anchors.leftMargin: 16
                    anchors.rightMargin: 16
                    spacing: 20

                    Row {
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 6
                        Text {
                            text: (typeof NavigationBackend !== "undefined" && NavigationBackend.eta) ?
                                  NavigationBackend.eta : "18 min"
                            color: "#00E5FF"
                            font.pixelSize: 17
                            font.bold: true
                            font.family: "Inter"
                        }
                        Text {
                            text: "• " + ((typeof NavigationBackend !== "undefined" && NavigationBackend.remainingDistance !== "") ?
                                  NavigationBackend.remainingDistance : "11.4 mi")
                            color: Qt.rgba(255/255, 255/255, 255/255, 0.7)
                            font.pixelSize: 14
                            font.family: "Inter"
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    Item { width: 10 }

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: (typeof NavigationBackend !== "undefined" && NavigationBackend.currentStreet !== "") ?
                              NavigationBackend.currentStreet : "Innovation Pkwy"
                        color: "#FFFFFF"
                        font.pixelSize: 14
                        font.weight: Font.DemiBold
                        font.family: "Inter"
                        elide: Text.ElideRight
                    }
                }
            }
        }
    }

    // Glass Border Overlay on top of the rounded map (only in compact card mode)
    Rectangle {
        id: glassBorder
        anchors.fill: parent
        radius: root.isExpanded ? 0 : 18
        color: "transparent"
        border.color: root.isExpanded ? "transparent" : Qt.rgba(0/255, 229/255, 255/255, 0.28)
        border.width: root.isExpanded ? 0 : 1
        visible: !root.isExpanded
        z: 50
    }

    // Search overlay dialog placeholder
    Item {
        id: searchOverlay
        anchors.fill: parent
        visible: false
        z: 200

        Rectangle {
            anchors.fill: parent
            color: Qt.rgba(0, 0, 0, 0.7)
            MouseArea { anchors.fill: parent; onClicked: searchOverlay.visible = false; }
        }

        Rectangle {
            anchors.centerIn: parent
            width: Math.min(480, parent.width - 40)
            height: 60
            radius: 16
            color: "#0F172A"
            border.color: "#00E5FF"
            border.width: 1.5

            Row {
                anchors.fill: parent
                anchors.margins: 14
                spacing: 12
                Text { text: "🔍"; font.pixelSize: 20; anchors.verticalCenter: parent.verticalCenter }
                TextInput {
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width - 60
                    color: "#FFFFFF"
                    font.pixelSize: 16
                    font.family: "Inter"
                    clip: true
                    focus: searchOverlay.visible
                    onAccepted: { searchOverlay.visible = false; }
                }
            }
        }
    }

    // Full-card tap handler for Compact Home Screen Mode:
    // Tapping inside the map expands it into the full workspace
    MouseArea {
        id: compactCardTapArea
        anchors.fill: parent
        enabled: !root.isExpanded
        cursorShape: Qt.PointingHandCursor
        z: 100
        onClicked: function(mouse) {
            var isSearchIcon = (mouse.x < 85 && mouse.y < 85);
            root.toggleExpandRequested(isSearchIcon);
        }
    }
}
