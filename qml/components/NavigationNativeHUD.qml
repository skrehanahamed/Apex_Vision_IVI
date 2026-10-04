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
    function recenterMap() {
        if (googleMapView) {
            googleMapView.panX = 0;
            googleMapView.panY = 0;
        }
    }
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

            // =================================================================
            // LIVE GOOGLE MAPS SLIPPY TILE ENGINE (Direct Google Maps Stream)
            // =================================================================
            Item {
                id: googleMapView
                anchors.fill: parent
                clip: true

                property real centerLat: (typeof NavigationBackend !== "undefined" && NavigationBackend.latitude !== 0) ? NavigationBackend.latitude : 13.06464
                property real centerLon: (typeof NavigationBackend !== "undefined" && NavigationBackend.longitude !== 0) ? NavigationBackend.longitude : 77.60159
                property int zoom: 16
                property string mapType: "m" // "m" = Google Road Map, "y" = Google Satellite Hybrid
                property real panX: 0
                property real panY: 0

                readonly property real centerTileX: (centerLon + 180) / 360 * Math.pow(2, zoom)
                readonly property real centerTileY: {
                    var rad = centerLat * Math.PI / 180;
                    var val = Math.tan(rad) + (1 / Math.cos(rad));
                    if (val <= 0) val = 0.0001;
                    return (1 - Math.log(val) / Math.PI) / 2 * Math.pow(2, zoom);
                }
                readonly property int baseTileX: Math.floor(centerTileX)
                readonly property int baseTileY: Math.floor(centerTileY)
                readonly property real fracX: (centerTileX - baseTileX) * 256
                readonly property real fracY: (centerTileY - baseTileY) * 256

                // Deep background while loading
                Rectangle {
                    anchors.fill: parent
                    color: googleMapView.mapType === "m" ? "#1A2234" : "#0A0E17"
                }

                // Slippy Tile Grid (7 horizontal x 5 vertical tiles)
                Item {
                    id: tileGrid
                    x: (googleMapView.width / 2) - googleMapView.fracX + googleMapView.panX
                    y: (googleMapView.height / 2) - googleMapView.fracY + googleMapView.panY

                    Repeater {
                        model: 35
                        delegate: Image {
                            property int col: index % 7 - 3
                            property int row: Math.floor(index / 7) - 2
                            property int tX: googleMapView.baseTileX + col
                            property int tY: googleMapView.baseTileY + row

                            x: col * 256
                            y: row * 256
                            width: 256
                            height: 256
                            asynchronous: true
                            cache: true
                            fillMode: Image.PreserveAspectFit

                            source: (tX >= 0 && tY >= 0) ?
                                ("https://mt" + (Math.abs(tX + tY) % 4) + ".google.com/vt/lyrs=" + googleMapView.mapType + "&x=" + tX + "&y=" + tY + "&z=" + googleMapView.zoom) : ""

                            opacity: status === Image.Ready ? 1.0 : 0.0
                            Behavior on opacity { NumberAnimation { duration: 180 } }
                        }
                    }
                }

                // Pan Gesture Area
                MouseArea {
                    anchors.fill: parent
                    property real lastX: 0
                    property real lastY: 0
                    onPressed: function(mouse) {
                        lastX = mouse.x;
                        lastY = mouse.y;
                    }
                    onPositionChanged: function(mouse) {
                        if (pressed) {
                            googleMapView.panX += (mouse.x - lastX);
                            googleMapView.panY += (mouse.y - lastY);
                            lastX = mouse.x;
                            lastY = mouse.y;
                        }
                    }
                }

                // Google Maps Branding Watermark (Bottom-Left)
                Row {
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    anchors.margins: 16
                    spacing: 8
                    z: 20
                    visible: false

                    Rectangle {
                        color: Qt.rgba(0, 0, 0, 0.70)
                        radius: 6
                        width: 72
                        height: 24
                        Text {
                            anchors.centerIn: parent
                            text: "Google"
                            font.family: "Inter"
                            font.pixelSize: 13
                            font.bold: true
                            color: "#FFFFFF"
                        }
                    }
                }

                // Interactive Map Controls (Bottom-Right: Zoom, Satellite toggle, Recenter)
                Column {
                    anchors.bottom: parent.bottom
                    anchors.right: parent.right
                    anchors.margins: 16
                    spacing: 8
                    z: 20

                    // Recenter Button
                    Rectangle {
                        width: 44
                        height: 44
                        radius: 22
                        color: Qt.rgba(15, 23, 42, 0.88)
                        border.color: Qt.rgba(255, 255, 255, 0.22)
                        border.width: 1

                        Text {
                            anchors.centerIn: parent
                            text: "⌖"
                            font.pixelSize: 22
                            color: "#00E5FF"
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                googleMapView.panX = 0;
                                googleMapView.panY = 0;
                            }
                        }
                    }

                    // Satellite / Road Map Toggle
                    Rectangle {
                        width: 44
                        height: 44
                        radius: 22
                        color: Qt.rgba(15, 23, 42, 0.88)
                        border.color: Qt.rgba(255, 255, 255, 0.22)
                        border.width: 1

                        Text {
                            anchors.centerIn: parent
                            text: googleMapView.mapType === "m" ? "🛰" : "🗺"
                            font.pixelSize: 18
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                googleMapView.mapType = (googleMapView.mapType === "m" ? "y" : "m");
                            }
                        }
                    }

                    // Zoom In
                    Rectangle {
                        width: 44
                        height: 44
                        radius: 22
                        color: Qt.rgba(15, 23, 42, 0.88)
                        border.color: Qt.rgba(255, 255, 255, 0.22)
                        border.width: 1

                        Text {
                            anchors.centerIn: parent
                            text: "+"
                            font.pixelSize: 22
                            font.bold: true
                            color: "#FFFFFF"
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: if (googleMapView.zoom < 19) googleMapView.zoom++
                        }
                    }

                    // Zoom Out
                    Rectangle {
                        width: 44
                        height: 44
                        radius: 22
                        color: Qt.rgba(15, 23, 42, 0.88)
                        border.color: Qt.rgba(255, 255, 255, 0.22)
                        border.width: 1

                        Text {
                            anchors.centerIn: parent
                            text: "-"
                            font.pixelSize: 22
                            font.bold: true
                            color: "#FFFFFF"
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: if (googleMapView.zoom > 10) googleMapView.zoom--
                        }
                    }
                }

                // GPS Vehicle Location Puck
                Item {
                    id: vehiclePuck
                    x: (googleMapView.width / 2) + googleMapView.panX - 24
                    y: (googleMapView.height / 2) + googleMapView.panY - 24
                    width: 48
                    height: 48
                    z: 15
                    rotation: (typeof NavigationBackend !== "undefined") ? NavigationBackend.heading : 0

                    // Pulse ring
                    Rectangle {
                        anchors.centerIn: parent
                        width: 46
                        height: 46
                        radius: 23
                        color: "transparent"
                        border.color: Qt.rgba(0/255, 229/255, 255/255, 0.5)
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
                        width: 30
                        height: 30
                        radius: 15
                        color: "#00E5FF"
                        border.color: "#FFFFFF"
                        border.width: 2.5

                        Text {
                            anchors.centerIn: parent
                            text: "▲"
                            color: "#080D1A"
                            font.pixelSize: 15
                            font.bold: true
                        }
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
                visible: false

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
                            text: (typeof NavigationBackend !== "undefined" && NavigationBackend.maneuverInstruction && NavigationBackend.maneuverInstruction !== "") ?
                                  NavigationBackend.maneuverInstruction : "Continue on Amruthahalli Main Road"
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
                                  String(NavigationBackend.speedLimit) : "60"
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
                visible: false

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
                                  NavigationBackend.remainingDistance : "3.2 km")
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
                              NavigationBackend.currentStreet : "Amruthahalli, 560092"
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
