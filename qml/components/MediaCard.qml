import QtQuick
import QtQuick.Controls
import ApexVision
import ".."

Item {
    id: root

    signal openPlayerRequested()
    signal sourceMenuRequested()

    Column {
        anchors.fill: parent
        spacing: 16

        // ----------------------------------------------------
        // TOP ROW: Phone Connection Card + Preset ("P1")
        // ----------------------------------------------------
        Row {
            width: parent.width
            height: 96
            spacing: 16

            // 1. Phone Connection Card ("Add phone" or Connected state) - Left side
            Rectangle {
                id: phoneCard
                width: parent.width - 96 - 16
                height: 96
                radius: 18
                clip: true
                gradient: Gradient {
                    GradientStop {
                        position: 0.0
                        color: phoneMouse.pressed ?
                            Qt.rgba(215/255, 238/255, 255/255, 0.32) :
                            (phoneMouse.containsMouse ? Qt.rgba(225/255, 242/255, 255/255, 0.24) : Qt.rgba(215/255, 238/255, 255/255, 0.17))
                    }
                    GradientStop {
                        position: 1.0
                        color: phoneMouse.pressed ?
                            Qt.rgba(195/255, 225/255, 255/255, 0.26) :
                            (phoneMouse.containsMouse ? Qt.rgba(205/255, 232/255, 255/255, 0.18) : Qt.rgba(195/255, 225/255, 255/255, 0.11))
                    }
                }
                border.color: MediaBackend.phoneConnected ?
                              Qt.rgba(56, 189, 248, 0.65) :
                              (phoneMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.65) : Qt.rgba(225/255, 242/255, 255/255, 0.36))
                border.width: 1

                scale: phoneMouse.pressed ? 0.98 : (phoneMouse.containsMouse ? 1.015 : 1.0)
                Behavior on scale { NumberAnimation { duration: 150; easing.type: Easing.OutQuad } }

                // Top Specular Glass Reflection
                Rectangle {
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.topMargin: 1
                    anchors.leftMargin: 16
                    anchors.rightMargin: 16
                    height: 1
                    color: phoneMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.60) : Qt.rgba(255, 255, 255, 0.35)
                    radius: 1
                }

                Column {
                    anchors.centerIn: parent
                    spacing: 8

                    Image {
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 26
                        height: 26
                        fillMode: Image.PreserveAspectFit
                        source: MediaBackend.phoneConnected ?
                                "qrc:/ApexVision/qml/assets/icons/bluetooth.svg" :
                                "qrc:/ApexVision/qml/assets/icons/phone_add.svg"
                    }

                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: MediaBackend.phoneConnected ?
                              MediaBackend.connectedPhoneName : "Add phone"
                        color: "#F2F5F7"
                        font.family: "Inter"
                        font.pixelSize: 16
                        font.weight: Font.DemiBold
                        renderType: Text.NativeRendering
                    }
                }

                MouseArea {
                    id: phoneMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        MediaBackend.togglePhoneConnection();
                    }
                }
            }

            // 2. Driver Profile Box ("P1") - Right side
            Rectangle {
                id: profileBox
                width: 96
                height: 96
                radius: 18
                clip: true
                gradient: Gradient {
                    GradientStop {
                        position: 0.0
                        color: profileMouse.pressed ?
                            Qt.rgba(215/255, 238/255, 255/255, 0.32) :
                            (profileMouse.containsMouse ? Qt.rgba(225/255, 242/255, 255/255, 0.24) : Qt.rgba(215/255, 238/255, 255/255, 0.17))
                    }
                    GradientStop {
                        position: 1.0
                        color: profileMouse.pressed ?
                            Qt.rgba(195/255, 225/255, 255/255, 0.26) :
                            (profileMouse.containsMouse ? Qt.rgba(205/255, 232/255, 255/255, 0.18) : Qt.rgba(195/255, 225/255, 255/255, 0.11))
                    }
                }
                border.color: profileMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.65) : Qt.rgba(225/255, 242/255, 255/255, 0.36)
                border.width: 1

                scale: profileMouse.pressed ? 0.98 : (profileMouse.containsMouse ? 1.015 : 1.0)
                Behavior on scale { NumberAnimation { duration: 150; easing.type: Easing.OutQuad } }

                // Top Specular Glass Reflection
                Rectangle {
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.topMargin: 1
                    anchors.leftMargin: 12
                    anchors.rightMargin: 12
                    height: 1
                    color: profileMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.60) : Qt.rgba(255, 255, 255, 0.35)
                    radius: 1
                }

                Rectangle {
                    anchors.centerIn: parent
                    width: 54
                    height: 54
                    radius: 27
                    color: Qt.rgba(255, 255, 255, 0.12)
                    border.color: Qt.rgba(225/255, 242/255, 255/255, 0.36)
                    border.width: 1

                    Text {
                        anchors.centerIn: parent
                        text: VehicleBackend.driverProfile
                        color: "#F2F5F7"
                        font.family: "Inter"
                        font.pixelSize: VehicleBackend.driverProfile.length > 2 ? 14 : 18
                        font.weight: Font.DemiBold
                        renderType: Text.NativeRendering
                    }
                }

                MouseArea {
                    id: profileMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        VehicleBackend.cycleDriverProfile();
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
            radius: 18
            clip: true
            gradient: Gradient {
                GradientStop {
                    position: 0.0
                    color: cardClickMouse.pressed ? Qt.rgba(215/255, 238/255, 255/255, 0.22) : Qt.rgba(215/255, 238/255, 255/255, 0.17)
                }
                GradientStop {
                    position: 1.0
                    color: cardClickMouse.pressed ? Qt.rgba(195/255, 225/255, 255/255, 0.15) : Qt.rgba(195/255, 225/255, 255/255, 0.11)
                }
            }
            border.color: Qt.rgba(225/255, 242/255, 255/255, 0.36)
            border.width: 1

            // Click card to open full player (RadioPage for AM)
            MouseArea {
                id: cardClickMouse
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    root.openPlayerRequested();
                }
            }

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

            // Source Selector Pill on Top-Left: ((•)) ▾ (Matching Screenshot 2)
            Rectangle {
                id: sourcePill
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.margins: 20
                width: sourceRow.width + 24
                height: 44
                radius: 22
                color: sourceMouse.pressed ? Qt.rgba(215/255, 238/255, 255/255, 0.30) : Qt.rgba(215/255, 238/255, 255/255, 0.18)
                border.color: Qt.rgba(225/255, 242/255, 255/255, 0.36)
                border.width: 1
                scale: sourceMouse.pressed ? 0.94 : 1.0
                Behavior on scale { NumberAnimation { duration: 100 } }
                z: 20

                Row {
                    id: sourceRow
                    anchors.centerIn: parent
                    spacing: 8

                    // AM Radio Blue Circular Icon or FM Wave Icon
                    Rectangle {
                        width: 24
                        height: 24
                        radius: 12
                        color: "#1E88E5"
                        anchors.verticalCenter: parent.verticalCenter

                        Image {
                            anchors.centerIn: parent
                            width: 14
                            height: 14
                            fillMode: Image.PreserveAspectFit
                            source: MediaBackend.source === "USB" ? "qrc:/ApexVision/qml/assets/icons/usb_source.svg" :
                                   (MediaBackend.source === "Bluetooth" ? "qrc:/ApexVision/qml/assets/icons/bluetooth.svg" :
                                   "qrc:/ApexVision/qml/assets/icons/radio_source.svg")
                        }
                    }

                    Text {
                        text: MediaBackend.source === "Bluetooth" ? "BT" : (MediaBackend.source === "USB" ? "USB" : MediaBackend.source)
                        color: "#FFFFFF"
                        font.family: "Inter"
                        font.pixelSize: 14
                        font.weight: Font.DemiBold
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Text {
                        text: "▾"
                        color: "#93C5FD"
                        font.pixelSize: 12
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                MouseArea {
                    id: sourceMouse
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        root.sourceMenuRequested();
                    }
                }
            }

            // Center Content: When AM is ON, display Coral Note Card + Indian AM Station (Screenshot 2 style)
            Column {
                anchors.top: sourcePill.bottom
                anchors.topMargin: 10
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: transportRow.top
                spacing: 14

                // 1. Artwork Card (Enlarged to fill space beautifully)
                Rectangle {
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: 130
                    height: 130
                    radius: 26
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: Qt.rgba(20/255, 45/255, 95/255, 0.65) }
                        GradientStop { position: 1.0; color: Qt.rgba(10/255, 25/255, 60/255, 0.85) }
                    }
                    border.color: Qt.rgba(255, 255, 255, 0.25)
                    border.width: 1.5

                    Image {
                        anchors.centerIn: parent
                        width: 72
                        height: 72
                        source: MediaBackend.isRadio ?
                                "qrc:/ApexVision/qml/assets/icons/music_note_coral.svg" :
                                "qrc:/ApexVision/qml/assets/icons/radio_source.svg"
                        fillMode: Image.PreserveAspectFit
                        smooth: true
                        mipmap: true
                    }
                }

                // 2. Station Name / Title (Bigger font for clear readability)
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: MediaBackend.isAm ? MediaBackend.amStationName : MediaBackend.station
                    color: "#FFFFFF"
                    font.family: "Inter"
                    font.pixelSize: 26
                    font.weight: Font.DemiBold
                    elide: Text.ElideRight
                    width: parent.width - 40
                    horizontalAlignment: Text.AlignHCenter
                }

                // 3. Frequency & Subtitle (Bigger subtitle)
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: MediaBackend.isAm ?
                          (MediaBackend.amFrequency + " kHz • " + MediaBackend.amStationCity) :
                          (MediaBackend.source === "FM" ? (MediaBackend.frequency + " MHz • " + MediaBackend.trackTitle) : (MediaBackend.frequency + " MHz"))
                    color: "#94A3B8"
                    font.family: "Inter"
                    font.pixelSize: 17
                    font.weight: Font.Medium
                    elide: Text.ElideRight
                    width: parent.width - 40
                    horizontalAlignment: Text.AlignHCenter
                }
            }

            // Bottom Transport Controls: |<< (Prev) and >>| (Next)
            Item {
                id: transportRow
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 32
                anchors.horizontalCenter: parent.horizontalCenter
                width: 260
                height: 64
                z: 20

                Row {
                    anchors.centerIn: parent
                    spacing: MediaBackend.isRadio ? 110 : 60

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

                    // Play/Pause Center Button (Hidden for AM and FM radio)
                    Item {
                        width: MediaBackend.isRadio ? 0 : 56
                        height: 56
                        anchors.verticalCenter: parent.verticalCenter
                        visible: !MediaBackend.isRadio

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
