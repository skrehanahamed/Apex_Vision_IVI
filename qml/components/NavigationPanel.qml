import QtQuick
import QtQuick.Controls
import QtWebEngine
import ApexVision
import ".."

import QtQuick.Effects

Item {
    id: root

    // QML to JavaScript position synchronization
    function updateVehiclePositionInMap() {
        if (!webEngineView.loading) {
            var script = "setVehiclePosition(" + 
                         NavigationBackend.latitude + ", " + 
                         NavigationBackend.longitude + ", " + 
                         NavigationBackend.heading + ");";
            webEngineView.runJavaScript(script);
        }
    }

    function updateStreetNameInMap() {
        if (!webEngineView.loading) {
            var script = "setStreetName('" + NavigationBackend.currentStreet + "');";
            webEngineView.runJavaScript(script);
        }
    }

    Connections {
        target: NavigationBackend
        function onPositionChanged() {
            root.updateVehiclePositionInMap();
        }
        function onCurrentStreetChanged() {
            root.updateStreetNameInMap();
        }
    }

    // Mask for true rounded corners
    Rectangle {
        id: mapMask
        anchors.fill: parent
        radius: 18
        color: "#000000"
        visible: false
        layer.enabled: true
    }

    // Map container with MultiEffect mask applied
    Item {
        id: mapContainer
        anchors.fill: parent
        layer.enabled: true
        layer.effect: MultiEffect {
            maskEnabled: true
            maskSource: mapMask
        }

        // 1. Live 3D Perspective WebGL Map View
        WebEngineView {
            id: webEngineView
            anchors.fill: parent
            url: Qt.resolvedUrl("../../web/map.html")
            backgroundColor: "transparent"

            settings.javascriptEnabled: true
            settings.localContentCanAccessRemoteUrls: true
            settings.localContentCanAccessFileUrls: true

            onLoadingChanged: function(loadRequest) {
                if (loadRequest.status === WebEngineView.LoadSucceededStatus) {
                    root.updateVehiclePositionInMap();
                    root.updateStreetNameInMap();
                }
            }
        }
    }

    // Glass Border Overlay on top of the rounded map (matching VehicleMenuCard)
    Rectangle {
        id: glassBorder
        anchors.fill: parent
        radius: 18
        color: "transparent"
        border.color: Qt.rgba(225/255, 242/255, 255/255, 0.36)
        border.width: 1
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
            color: Qt.rgba(255, 255, 255, 0.35)
            radius: 1
        }
    }

    // 2. Search Button (Only Search and Map in Navigation panel)
    Rectangle {
        id: searchButton
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.margins: 20
        width: 48
        height: 48
        radius: 24
        color: searchMouse.pressed ? Qt.rgba(255, 255, 255, 0.9) : "#FFFFFF"
        scale: searchMouse.pressed ? 0.92 : 1.0
        Behavior on scale { NumberAnimation { duration: 100 } }
        z: 100

        Image {
            anchors.centerIn: parent
            width: 22
            height: 22
            fillMode: Image.PreserveAspectFit
            source: "qrc:/ApexVision/qml/assets/icons/search.svg"
        }

        MouseArea {
            id: searchMouse
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                NavigationBackend.searchDestination("Park Street");
            }
        }
    }
}
