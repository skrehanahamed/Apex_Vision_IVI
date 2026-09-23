import QtQuick
import QtQuick.Controls

Item {
    id: root

    property real temperature: 21.5
    property bool powerOn: true
    property string zoneLabel: "DRIVER"
    property string displayText: ""

    signal increaseRequested()
    signal decreaseRequested()
    signal togglePowerRequested()

    implicitWidth: 160
    implicitHeight: 52

    Row {
        anchors.centerIn: parent
        spacing: 12

        // Left Chevron (Cool / Blue)
        Item {
            id: decBtn
            width: 38
            height: 48
            anchors.verticalCenter: parent.verticalCenter

            Text {
                anchors.centerIn: parent
                text: "‹"
                color: "#38BDF8" // Crisp automotive blue/cyan
                font.pixelSize: 32
                font.bold: true
                opacity: decArea.pressed ? 0.6 : 1.0
                scale: decArea.pressed ? 0.9 : 1.0
                Behavior on scale { NumberAnimation { duration: 80 } }
            }

            MouseArea {
                id: decArea
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: root.decreaseRequested()
            }
        }

        // Center Temperature / Status display
        Item {
            id: tempDisplay
            width: 76
            height: 48
            anchors.verticalCenter: parent.verticalCenter

            Text {
                id: tempText
                anchors.centerIn: parent
                text: root.displayText !== "" ? root.displayText : (root.powerOn ? root.temperature.toFixed(1) + "°C" : "OFF")
                color: (root.powerOn && root.displayText !== "OFF") ? "#F8FAFC" : "#64748B"
                font.pixelSize: (root.powerOn && root.displayText !== "OFF") ? 22 : 20
                font.weight: Font.DemiBold
                font.letterSpacing: 0.5

                Behavior on text {
                    // Smooth visual transition when temp changes
                    SequentialAnimation {
                        NumberAnimation { target: tempText; property: "opacity"; to: 0.4; duration: 60 }
                        NumberAnimation { target: tempText; property: "opacity"; to: 1.0; duration: 80 }
                    }
                }
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: root.togglePowerRequested()
            }
        }

        // Right Chevron (Warm / Red)
        Item {
            id: incBtn
            width: 38
            height: 48
            anchors.verticalCenter: parent.verticalCenter

            Text {
                anchors.centerIn: parent
                text: "›"
                color: "#F87171" // Crisp automotive warm red
                font.pixelSize: 32
                font.bold: true
                opacity: incArea.pressed ? 0.6 : 1.0
                scale: incArea.pressed ? 0.9 : 1.0
                Behavior on scale { NumberAnimation { duration: 80 } }
            }

            MouseArea {
                id: incArea
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: root.increaseRequested()
            }
        }
    }
}
