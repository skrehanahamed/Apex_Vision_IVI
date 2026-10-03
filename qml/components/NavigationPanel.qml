/**
 * ==============================================================================
 * Project: Apex VISION IVI - Digital Cockpit & Infotainment System
 * File: NavigationPanel.qml
 * Description: Adaptive 3D Navigation Coordinator (WebEngine Three.js / Native Cockpit HUD)
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

    property bool isExpanded: false
    signal toggleExpandRequested(bool openSearch)

    function openSearch() {
        if (mapLoader.item && typeof mapLoader.item.openSearch === "function") {
            mapLoader.item.openSearch();
        }
    }

    function updateApiKeyInMap() {
        if (mapLoader.item && typeof mapLoader.item.updateApiKeyInMap === "function") {
            mapLoader.item.updateApiKeyInMap();
        }
    }

    function updateVehiclePositionInMap() {
        if (mapLoader.item && typeof mapLoader.item.updateVehiclePositionInMap === "function") {
            mapLoader.item.updateVehiclePositionInMap();
        }
    }

    function updateStreetNameInMap() {
        if (mapLoader.item && typeof mapLoader.item.updateStreetNameInMap === "function") {
            mapLoader.item.updateStreetNameInMap();
        }
    }

    function searchInMap(query) {
        if (mapLoader.item && typeof mapLoader.item.searchInMap === "function") {
            mapLoader.item.searchInMap(query);
        }
    }

    function recenterMap() {
        if (mapLoader.item && typeof mapLoader.item.recenterMap === "function") {
            mapLoader.item.recenterMap();
        }
    }

    function updateMapMode() {
        if (mapLoader.item && typeof mapLoader.item.updateMapMode === "function") {
            mapLoader.item.updateMapMode();
        }
    }

    onIsExpandedChanged: {
        if (mapLoader.item) {
            mapLoader.item.isExpanded = root.isExpanded;
        }
    }

    onWidthChanged: {
        if (root.isExpanded && mapLoader.item) {
            root.updateMapMode();
        }
    }

    onVisibleChanged: {
        if (visible && mapLoader.item) {
            root.updateMapMode();
        }
    }

    // Mask for true rounded corners in compact mode (squared off in expanded mode)
    Rectangle {
        id: mapMask
        anchors.fill: parent
        radius: root.isExpanded ? 0 : 18
        color: "#000000"
        visible: false
        layer.enabled: true
    }

    // Map container with MultiEffect mask applied
    Item {
        id: mapContainer
        anchors.fill: parent
        enabled: root.isExpanded
        layer.enabled: true
        layer.effect: MultiEffect {
            maskEnabled: true
            maskSource: mapMask
        }

        Loader {
            id: mapLoader
            anchors.fill: parent
            source: "NavigationWebEngine.qml"
            asynchronous: false
            onLoaded: {
                if (item) {
                    item.isExpanded = root.isExpanded;
                }
            }
            onStatusChanged: {
                if (status === Loader.Error) {
                    console.log("[Navigation] WebEngine unavailable on target platform. Activating Native Digital Cockpit HUD.");
                    source = "NavigationNativeHUD.qml";
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

        // Top Specular Glass Reflection
        Rectangle {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.topMargin: 1
            anchors.leftMargin: 20
            anchors.rightMargin: 20
            height: 1
            color: Qt.rgba(255, 255, 255, 0.30)
            radius: 1
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
