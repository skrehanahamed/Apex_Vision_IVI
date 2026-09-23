import QtQuick
import QtQuick.Controls

Item {
    id: root

    Rectangle {
        anchors.fill: parent
        anchors.margins: 16
        radius: 20
        color: "#0E1522"
        border.color: Qt.rgba(255, 255, 255, 0.08)
        border.width: 1

        Column {
            anchors.fill: parent
            anchors.margins: 36
            spacing: 24

            Text {
                text: "System Settings"
                color: "#FFFFFF"
                font.pixelSize: 28
                font.weight: Font.DemiBold
            }

            Rectangle {
                width: 480
                height: 72
                radius: 14
                color: "#131C2D"
                border.color: Qt.rgba(255, 255, 255, 0.06)

                Row {
                    anchors.fill: parent
                    anchors.leftMargin: 20
                    anchors.rightMargin: 20

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: "Display Brightness"
                        color: "#F8FAFC"
                        font.pixelSize: 18
                    }

                    Item { width: 40; height: 1 }

                    Slider {
                        id: brightnessSlider
                        anchors.verticalCenter: parent.verticalCenter
                        from: 20
                        to: 100
                        value: SystemBackend.brightness
                        onMoved: SystemBackend.setBrightness(value)
                    }
                }
            }

            Rectangle {
                width: 480
                height: 72
                radius: 14
                color: "#131C2D"
                border.color: Qt.rgba(255, 255, 255, 0.06)

                Row {
                    anchors.fill: parent
                    anchors.leftMargin: 20
                    anchors.rightMargin: 20

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: "APEX VISION IVI Version"
                        color: "#F8FAFC"
                        font.pixelSize: 18
                    }

                    Item { width: 80; height: 1 }

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: "v1.0.0-PROD"
                        color: "#00D2FF"
                        font.pixelSize: 16
                        font.weight: Font.DemiBold
                    }
                }
            }
        }
    }
}
