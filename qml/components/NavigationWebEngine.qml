/**
 * ==============================================================================
 * Project: Apex VISION IVI - Digital Cockpit & Infotainment System
 * File: NavigationWebEngine.qml
 * Description: Hardware-Accelerated Three.js & MapLibre 3D Cockpit Google Maps
 * Author / Developer: Sk Rehan Ahamed
 * License: MIT
 * ==============================================================================
 */

import QtQuick
import QtQuick.Controls
import QtWebEngine
import ApexVision
import ".."

Item {
    id: root
    anchors.fill: parent

    property bool isExpanded: false

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

    function updateMapMode() {
        if (!webEngineView.loading) {
            webEngineView.runJavaScript("if (typeof window.setCompactMode === 'function') { window.setCompactMode(" + (!root.isExpanded) + "); }");
        }
    }

    onIsExpandedChanged: {
        updateMapMode();
    }

    Connections {
        target: NavigationBackend
        function onApiKeyChanged() { root.updateApiKeyInMap(); }
        function onPositionChanged() { root.updateVehiclePositionInMap(); }
        function onCurrentStreetChanged() { root.updateStreetNameInMap(); }
    }

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
