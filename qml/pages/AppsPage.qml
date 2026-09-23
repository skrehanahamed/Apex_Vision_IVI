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
            spacing: 28

            Text {
                text: "Applications"
                color: "#FFFFFF"
                font.pixelSize: 28
                font.weight: Font.DemiBold
            }

            Grid {
                columns: 4
                spacing: 32

                Repeater {
                    model: [
                        { name: "Navigation", icon: "qrc:/ApexVision/qml/assets/icons/nav_home.svg" },
                        { name: "Media Player", icon: "qrc:/ApexVision/qml/assets/icons/radio_source.svg" },
                        { name: "Vehicle Status", icon: "qrc:/ApexVision/qml/assets/icons/nav_vehicle.svg" },
                        { name: "Phone", icon: "qrc:/ApexVision/qml/assets/icons/nav_phone.svg" },
                        { name: "Weather", icon: "qrc:/ApexVision/qml/assets/icons/compass.svg" },
                        { name: "Settings", icon: "qrc:/ApexVision/qml/assets/icons/nav_settings.svg" }
                    ]

                    Rectangle {
                        width: 160
                        height: 140
                        radius: 18
                        color: appMouse.pressed ? Qt.rgba(255, 255, 255, 0.12) : "#131C2D"
                        border.color: Qt.rgba(255, 255, 255, 0.06)

                        Column {
                            anchors.centerIn: parent
                            spacing: 12

                            Image {
                                anchors.horizontalCenter: parent.horizontalCenter
                                width: 44
                                height: 44
                                fillMode: Image.PreserveAspectFit
                                source: modelData.icon
                            }

                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: modelData.name
                                color: "#F8FAFC"
                                font.pixelSize: 15
                                font.weight: Font.Medium
                            }
                        }

                        MouseArea {
                            id: appMouse
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                        }
                    }
                }
            }
        }
    }
}
