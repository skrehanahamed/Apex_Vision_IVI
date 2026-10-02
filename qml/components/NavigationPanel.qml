import QtQuick
import QtQuick.Controls
import QtWebEngine
import ApexVision
import ".."

import QtQuick.Effects

Item {
    id: root

    property bool isExpanded: false
    signal toggleExpandRequested(bool openSearch)

    function openSearch() {
        if (!webEngineView.loading) {
            webEngineView.runJavaScript("openSearchModal();");
        }
    }

    function updateApiKeyInMap() {
        if (!webEngineView.loading && NavigationBackend.apiKey && NavigationBackend.apiKey !== "") {
            var script = "if (typeof window.setGoogleApiKey === 'function') { window.setGoogleApiKey('" + NavigationBackend.apiKey + "'); }";
            webEngineView.runJavaScript(script);
        }
    }

    // Synchronize vehicle position with 3D map engine
    function updateVehiclePositionInMap() {
        if (!webEngineView.loading) {
            var script = "if (typeof window.setVehiclePosition === 'function') { window.setVehiclePosition(" + 
                         NavigationBackend.latitude + ", " + 
                         NavigationBackend.longitude + ", " + 
                         NavigationBackend.heading + ", " + 
                         NavigationBackend.speed + "); }";
            webEngineView.runJavaScript(script);
        }
    }

    function updateStreetNameInMap() {
        if (!webEngineView.loading) {
            var script = "if (typeof window.setStreetName === 'function') { window.setStreetName('" + NavigationBackend.currentStreet + "'); }";
            webEngineView.runJavaScript(script);
        }
    }

    function searchInMap(query) {
        if (!webEngineView.loading) {
            var script = "if (typeof window.handleSearchInput === 'function') { window.handleSearchInput('" + query + "'); }";
            webEngineView.runJavaScript(script);
        }
    }

    function recenterMap() {
        if (!webEngineView.loading) {
            webEngineView.runJavaScript("if (typeof window.recenterMap === 'function') { window.recenterMap(); }");
        }
    }

    onIsExpandedChanged: {
        updateMapMode();
    }

    onWidthChanged: {
        if (root.isExpanded) {
            updateMapMode();
        }
    }

    onVisibleChanged: {
        if (visible) {
            updateMapMode();
        }
    }

    function updateMapMode() {
        if (!webEngineView.loading) {
            webEngineView.runJavaScript("if (typeof window.setCompactMode === 'function') { window.setCompactMode(" + (!root.isExpanded) + "); }");
        }
    }

    Connections {
        target: NavigationBackend
        function onApiKeyChanged() {
            root.updateApiKeyInMap();
        }
        function onPositionChanged() {
            root.updateVehiclePositionInMap();
        }
        function onCurrentStreetChanged() {
            root.updateStreetNameInMap();
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

        // Live Perspective WebGL Map View (Stadia Maps 3D Vector Engine)
        WebEngineView {
            id: webEngineView
            anchors.fill: parent
            url: NavigationBackend.mapUrl
            backgroundColor: "#F1F5F9"

            settings.javascriptEnabled: true
            settings.localContentCanAccessRemoteUrls: true
            settings.localContentCanAccessFileUrls: true
            settings.pluginsEnabled: true

            onJavaScriptConsoleMessage: function(level, message, lineNumber, sourceID) {
                if (level > 1 && !message.includes("TileCache")) {
                    console.warn("[Map JS Error] " + message + " (line " + lineNumber + ")");
                }
            }

            onLoadingChanged: function(loadRequest) {
                if (loadRequest.status === WebEngineView.LoadSucceededStatus) {
                    root.updateApiKeyInMap();
                    root.updateVehiclePositionInMap();
                    root.updateStreetNameInMap();
                    root.updateMapMode();
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
