import QtQuick
import QtQuick.Controls

Item {
    id: root

    property string themeId: ""
    property string title: ""
    property string subtitle: ""
    property url thumbnailSource: ""
    property bool isSelected: false

    signal clicked()

    width: parent ? parent.width : 400
    height: 104

    Rectangle {
        id: bg
        anchors.fill: parent
        radius: 18
        color: root.isSelected 
            ? Qt.rgba(0.08, 0.22, 0.45, 0.55) 
            : (mouseArea.containsMouse ? Qt.rgba(0.06, 0.14, 0.28, 0.45) : Qt.rgba(0.04, 0.09, 0.18, 0.40))
        border.color: root.isSelected ? "#24D9FF" : (mouseArea.containsMouse ? Qt.rgba(0.2, 0.6, 1.0, 0.3) : Qt.rgba(1, 1, 1, 0.08))
        border.width: root.isSelected ? 2 : 1

        Behavior on color {
            ColorAnimation { duration: 180 }
        }
        Behavior on border.color {
            ColorAnimation { duration: 180 }
        }

        // Inner glowing ambient halo for selected card
        Rectangle {
            anchors.fill: parent
            anchors.margins: -1
            radius: 19
            color: "transparent"
            border.color: "#24D9FF"
            border.width: 1
            opacity: root.isSelected ? 0.35 : 0.0
            visible: opacity > 0.01
            Behavior on opacity {
                NumberAnimation { duration: 250 }
            }
        }

        Row {
            anchors.fill: parent
            anchors.leftMargin: 16
            anchors.rightMargin: 18
            spacing: 16
            clip: true

            // Thumbnail container
            Item {
                width: 114
                height: 72
                anchors.verticalCenter: parent.verticalCenter

                Rectangle {
                    id: thumbMask
                    anchors.fill: parent
                    radius: 12
                    color: "#0B1526"
                    clip: true

                    Image {
                        id: thumbImg
                        anchors.fill: parent
                        source: root.thumbnailSource
                        fillMode: Image.PreserveAspectCrop
                        asynchronous: true
                        smooth: true
                        cache: true

                        // Fallback gradient if thumbnail still loading or missing
                        Rectangle {
                            anchors.fill: parent
                            visible: thumbImg.status !== Image.Ready
                            gradient: Gradient {
                                GradientStop { position: 0.0; color: "#162846" }
                                GradientStop { position: 1.0; color: "#0B1526" }
                            }
                        }
                    }

                    // Subtle inner vignette
                    Rectangle {
                        anchors.fill: parent
                        radius: 12
                        color: "transparent"
                        border.color: Qt.rgba(1, 1, 1, 0.12)
                        border.width: 1
                    }
                }
            }

            // Text Info Column
            Column {
                width: parent.width - 114 - 16 - 28
                anchors.verticalCenter: parent.verticalCenter
                spacing: 4

                Text {
                    text: root.title
                    color: root.isSelected ? "#FFFFFF" : "#E2EEFC"
                    font.family: "Inter"
                    font.pixelSize: 18
                    font.weight: Font.DemiBold
                    elide: Text.ElideRight
                    width: parent.width
                }

                Text {
                    text: root.subtitle
                    color: root.isSelected ? "#94BCE8" : "#728AA8"
                    font.family: "Inter"
                    font.pixelSize: 13
                    font.weight: Font.Normal
                    wrapMode: Text.WordWrap
                    maximumLineCount: 2
                    lineHeight: 1.15
                    elide: Text.ElideRight
                    width: parent.width
                }
            }

            // Right Chevron Arrow
            Item {
                width: 24
                height: 24
                anchors.verticalCenter: parent.verticalCenter

                Text {
                    anchors.centerIn: parent
                    text: "›"
                    color: root.isSelected ? "#24D9FF" : Qt.rgba(0.5, 0.65, 0.85, 0.45)
                    font.family: "Inter"
                    font.pixelSize: 26
                    font.weight: Font.Light
                }
            }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}
