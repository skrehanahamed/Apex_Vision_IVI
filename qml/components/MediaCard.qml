import QtQuick
import QtQuick.Controls
import ApexVision
import ".."

Item {
    id: root

    Column {
        anchors.fill: parent
        spacing: 16

        // ----------------------------------------------------
        // TOP ROW: Preset ("P1") + Phone Connection Card
        // ----------------------------------------------------
        Row {
            width: parent.width
            height: 96
            spacing: 16

            // Preset Box ("P1")
            Rectangle {
                id: presetBox
                width: 96
                height: 96
                radius: 20
                color: presetMouse.pressed ? Qt.rgba(255, 255, 255, 0.12) : "#101726"
                border.color: Qt.rgba(255, 255, 255, 0.08)
                border.width: 1

                scale: presetMouse.pressed ? 0.94 : 1.0
                Behavior on scale { NumberAnimation { duration: 100 } }

                Text {
                    anchors.centerIn: parent
                    text: MediaBackend.preset
                    color: "#FFFFFF"
                    font: Typography.heading
                }

                MouseArea {
                    id: presetMouse
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        MediaBackend.next();
                    }
                }
            }

            // Phone Connection Card ("Add phone" or Connected state)
            Rectangle {
                id: phoneCard
                width: parent.width - 96 - 16
                height: 96
                radius: 20
                color: phoneMouse.pressed ? Qt.rgba(255, 255, 255, 0.12) : "#101726"
                border.color: MediaBackend.phoneConnected ?
                              Qt.rgba(0, 210, 255, 0.4) : Qt.rgba(255, 255, 255, 0.08)
                border.width: 1

                scale: phoneMouse.pressed ? 0.96 : 1.0
                Behavior on scale { NumberAnimation { duration: 100 } }

                Row {
                    anchors.centerIn: parent
                    spacing: 14

                    Image {
                        width: 28
                        height: 28
                        fillMode: Image.PreserveAspectFit
                        source: MediaBackend.phoneConnected ?
                                "qrc:/ApexVision/qml/assets/icons/bluetooth.svg" :
                                "qrc:/ApexVision/qml/assets/icons/phone_add.svg"
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Text {
                        text: MediaBackend.phoneConnected ?
                              MediaBackend.connectedPhoneName : "Add phone"
                        color: "#FFFFFF"
                        font: Typography.bodyMedium
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                MouseArea {
                    id: phoneMouse
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        MediaBackend.togglePhoneConnection();
                    }
                }
            }
        }

        // ----------------------------------------------------
        // MAIN MEDIA CARD
        // ----------------------------------------------------
        Rectangle {
            id: mainMediaCard
            width: parent.width
            height: parent.height - 96 - 16
            radius: 20
            color: "#101726" // Rich dark automotive card matching reference
            border.color: Qt.rgba(255, 255, 255, 0.08)
            border.width: 1

            // Source Selector Pill on Top-Left: ((•)) ▾
            Rectangle {
                id: sourcePill
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.margins: 24
                width: 90
                height: 48
                radius: 24
                color: sourceMouse.pressed ? Qt.rgba(255, 255, 255, 0.18) : Qt.rgba(255, 255, 255, 0.08)
                scale: sourceMouse.pressed ? 0.94 : 1.0
                Behavior on scale { NumberAnimation { duration: 100 } }

                Row {
                    anchors.centerIn: parent
                    spacing: 8

                    Image {
                        width: 22
                        height: 22
                        fillMode: Image.PreserveAspectFit
                        source: "qrc:/ApexVision/qml/assets/icons/radio_source.svg"
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Text {
                        text: "▾"
                        color: "#FFFFFF"
                        font: Typography.button
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                MouseArea {
                    id: sourceMouse
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        // Cycle through sources: FM -> AM -> Bluetooth -> USB -> FM
                        if (MediaBackend.source === "FM") MediaBackend.setSource("AM");
                        else if (MediaBackend.source === "AM") MediaBackend.setSource("Bluetooth");
                        else if (MediaBackend.source === "Bluetooth") MediaBackend.setSource("USB");
                        else MediaBackend.setSource("FM");
                    }
                }
            }

            // Center Content: Frequency & HD Badge
            Item {
                id: frequencySection
                anchors.top: sourcePill.bottom
                anchors.topMargin: 20
                anchors.left: parent.left
                anchors.right: parent.right
                height: 120

                Row {
                    anchors.centerIn: parent
                    spacing: 16

                    // Big Frequency Readout (Matches reference: "95.9")
                    Text {
                        id: freqText
                        text: MediaBackend.frequency
                        color: "#FFFFFF"
                        font: Typography.displayLarge
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    // Amber "HD" Badge (Matches reference)
                    Rectangle {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.verticalCenterOffset: -4
                        width: 44
                        height: 32
                        radius: 8
                        color: "transparent"
                        border.color: "#F59E0B" // Amber HD color
                        border.width: 2
                        visible: MediaBackend.isHdRadio

                        Text {
                            anchors.centerIn: parent
                            text: "HD"
                            color: "#F59E0B"
                            font: Typography.button
                        }
                    }
                }
            }

            // Station Name / Track Title (Matches reference: "GTA's #1 Country KX-96")
            Text {
                id: stationText
                anchors.top: frequencySection.bottom
                anchors.topMargin: 8
                anchors.horizontalCenter: parent.horizontalCenter
                text: MediaBackend.station
                color: "#CBD5E1"
                font: Typography.heading
                elide: Text.ElideRight
                width: parent.width - 64
                horizontalAlignment: Text.AlignHCenter
            }

            // Bottom Transport Controls: |<< (Prev) and >>| (Next)
            Item {
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 40
                anchors.horizontalCenter: parent.horizontalCenter
                width: 260
                height: 64

                Row {
                    anchors.centerIn: parent
                    spacing: 60

                    // Previous Button |<<
                    Item {
                        width: 56
                        height: 56
                        anchors.verticalCenter: parent.verticalCenter

                        Image {
                            anchors.centerIn: parent
                            width: 32
                            height: 32
                            fillMode: Image.PreserveAspectFit
                            source: "qrc:/ApexVision/qml/assets/icons/skip_prev.svg"
                            opacity: prevMouse.pressed ? 0.6 : 0.95
                        }

                        scale: prevMouse.pressed ? 0.9 : 1.0
                        Behavior on scale { NumberAnimation { duration: 80 } }

                        MouseArea {
                            id: prevMouse
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: MediaBackend.previous()
                        }
                    }

                    // Play/Pause Center Button
                    Item {
                        width: 56
                        height: 56
                        anchors.verticalCenter: parent.verticalCenter

                        Image {
                            anchors.centerIn: parent
                            width: 34
                            height: 34
                            fillMode: Image.PreserveAspectFit
                            source: MediaBackend.isPlaying ?
                                    "qrc:/ApexVision/qml/assets/icons/pause.svg" :
                                    "qrc:/ApexVision/qml/assets/icons/play.svg"
                            opacity: playMouse.pressed ? 0.6 : 1.0
                        }

                        scale: playMouse.pressed ? 0.9 : 1.0
                        Behavior on scale { NumberAnimation { duration: 80 } }

                        MouseArea {
                            id: playMouse
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: MediaBackend.togglePlay()
                        }
                    }

                    // Next Button >>|
                    Item {
                        width: 56
                        height: 56
                        anchors.verticalCenter: parent.verticalCenter

                        Image {
                            anchors.centerIn: parent
                            width: 32
                            height: 32
                            fillMode: Image.PreserveAspectFit
                            source: "qrc:/ApexVision/qml/assets/icons/skip_next.svg"
                            opacity: nextMouse.pressed ? 0.6 : 0.95
                        }

                        scale: nextMouse.pressed ? 0.9 : 1.0
                        Behavior on scale { NumberAnimation { duration: 80 } }

                        MouseArea {
                            id: nextMouse
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: MediaBackend.next()
                        }
                    }
                }
            }
        }
    }
}
