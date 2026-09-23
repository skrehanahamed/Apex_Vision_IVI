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
                text: "Phone & Connectivity"
                color: "#FFFFFF"
                font.pixelSize: 28
                font.weight: Font.DemiBold
            }

            Rectangle {
                width: 420
                height: 90
                radius: 16
                color: "#131C2D"
                border.color: PhoneBackend.isConnected ? Qt.rgba(0, 210, 255, 0.4) : Qt.rgba(255, 255, 255, 0.06)

                Row {
                    anchors.centerIn: parent
                    spacing: 20

                    Image {
                        width: 36
                        height: 36
                        fillMode: Image.PreserveAspectFit
                        source: "qrc:/ApexVision/qml/assets/icons/bluetooth.svg"
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Column {
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 4

                        Text {
                            text: PhoneBackend.isConnected ? PhoneBackend.deviceName : "No Connected Device"
                            color: "#FFFFFF"
                            font.pixelSize: 18
                            font.weight: Font.Medium
                        }

                        Text {
                            text: PhoneBackend.isConnected ? "Bluetooth 5.3 • Connected" : "Tap to Pair Device"
                            color: PhoneBackend.isConnected ? "#00D2FF" : "#94A3B8"
                            font.pixelSize: 14
                        }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: PhoneBackend.toggleConnection()
                }
            }
        }
    }
}
