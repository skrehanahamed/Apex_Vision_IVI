import QtQuick
import QtQuick.Controls
import QtWebEngine
import ApexVision
import ".."

Item {
    id: root

    Rectangle {
        id: cardBg
        anchors.fill: parent
        radius: 20
        color: "#E2E8F0"
        border.color: Qt.rgba(255, 255, 255, 0.08)
        border.width: 1
        clip: true

        // 1. Live 3D Perspective WebGL Map View (3D Buildings, 56° Tilt, 100% Free, No Card Required)
        WebEngineView {
            id: webEngineView
            anchors.fill: parent
            url: Qt.resolvedUrl("../../web/map.html")
            backgroundColor: "#E2E8F0"

            settings.javascriptEnabled: true
            settings.localContentCanAccessRemoteUrls: true
            settings.localContentCanAccessFileUrls: true

            onLoadingChanged: function(loadRequest) {
                if (loadRequest.status === WebEngineView.LoadSucceededStatus) {
                    cardBg.updateVehiclePositionInMap();
                    cardBg.updateStreetNameInMap();
                }
            }
        }

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
                cardBg.updateVehiclePositionInMap();
            }
            function onCurrentStreetChanged() {
                cardBg.updateStreetNameInMap();
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
}
