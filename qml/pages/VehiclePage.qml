import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: root

    Rectangle {
        anchors.fill: parent
        anchors.margins: 16
        radius: 20
        color: "#0E1522"
        border.color: Qt.rgba(255, 255, 255, 0.08)
        border.width: 1

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 36
            spacing: 24

            Text {
                text: "Vehicle Telemetry & Status"
                color: "#FFFFFF"
                font.pixelSize: 28
                font.weight: Font.DemiBold
            }

            RowLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 24

                // Speed & Drive Mode Card
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    radius: 16
                    color: "#111A29"
                    border.color: Qt.rgba(255, 255, 255, 0.06)

                    Column {
                        anchors.centerIn: parent
                        spacing: 12

                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: VehicleBackend.vehicleSpeed.toString()
                            color: "#00D2FF"
                            font.pixelSize: 72
                            font.bold: true
                        }
                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "KM / H"
                            color: "#94A3B8"
                            font.pixelSize: 16
                            font.weight: Font.Medium
                        }
                        Rectangle {
                            anchors.horizontalCenter: parent.horizontalCenter
                            width: 120
                            height: 36
                            radius: 18
                            color: Qt.rgba(0, 210, 255, 0.15)
                            border.color: "#00D2FF"
                            border.width: 1

                            Text {
                                anchors.centerIn: parent
                                text: VehicleBackend.driveMode
                                color: "#00D2FF"
                                font.pixelSize: 14
                                font.bold: true
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: VehicleBackend.cycleDriveMode()
                            }
                        }
                    }
                }

                // Battery & Efficiency Card
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    radius: 16
                    color: "#111A29"
                    border.color: Qt.rgba(255, 255, 255, 0.06)

                    Column {
                        anchors.centerIn: parent
                        spacing: 16

                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: VehicleBackend.batteryLevel + "%"
                            color: "#10B981"
                            font.pixelSize: 56
                            font.bold: true
                        }
                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "State of Charge"
                            color: "#94A3B8"
                            font.pixelSize: 16
                        }
                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "Trip: " + VehicleBackend.tripDistance + " km"
                            color: "#CBD5E1"
                            font.pixelSize: 18
                        }
                    }
                }

                // Transmission & Engine
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    radius: 16
                    color: "#111A29"
                    border.color: Qt.rgba(255, 255, 255, 0.06)

                    Column {
                        anchors.centerIn: parent
                        spacing: 16

                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: VehicleBackend.gear
                            color: "#FFFFFF"
                            font.pixelSize: 64
                            font.bold: true
                        }
                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "Gear Selection"
                            color: "#94A3B8"
                            font.pixelSize: 16
                        }
                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "RPM: " + VehicleBackend.engineRpm
                            color: "#CBD5E1"
                            font.pixelSize: 18
                        }
                    }
                }
            }
        }
    }
}
