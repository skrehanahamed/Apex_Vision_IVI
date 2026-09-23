import QtQuick
import QtQuick.Controls

Item {
    id: root

    property alias iconSource: iconImage.source
    property string text: ""
    property color iconColor: "#FFFFFF"
    property color activeColor: "#00D2FF"
    property color backgroundColor: "transparent"
    property color activeBackgroundColor: Qt.rgba(0, 0.82, 1.0, 0.15)
    property bool isActive: false
    property bool isPill: false
    property real iconSize: 28
    property real radius: 14

    signal clicked()

    implicitWidth: 56
    implicitHeight: 56

    Rectangle {
        id: bg
        anchors.fill: parent
        radius: root.radius
        color: root.isActive ? root.activeBackgroundColor :
               (mouseArea.pressed ? Qt.rgba(1, 1, 1, 0.12) : root.backgroundColor)
        border.color: root.isActive ? Qt.rgba(0, 0.82, 1.0, 0.5) : "transparent"
        border.width: root.isActive ? 1.5 : 0

        Behavior on color {
            ColorAnimation { duration: 150 }
        }
        Behavior on border.color {
            ColorAnimation { duration: 150 }
        }

        scale: mouseArea.pressed ? 0.94 : 1.0
        Behavior on scale {
            NumberAnimation { duration: 100; easing.type: Easing.OutQuad }
        }

        Row {
            anchors.centerIn: parent
            spacing: 8

            Image {
                id: iconImage
                width: root.iconSize
                height: root.iconSize
                fillMode: Image.PreserveAspectFit
                sourceSize.width: root.iconSize * 2
                sourceSize.height: root.iconSize * 2
                anchors.verticalCenter: parent.verticalCenter
                opacity: root.isActive ? 1.0 : (mouseArea.pressed ? 0.9 : 0.8)
                visible: root.iconSource != ""
            }

            Text {
                id: labelText
                text: root.text
                color: root.isActive ? root.activeColor : root.iconColor
                font.pixelSize: 16
                font.weight: Font.Medium
                anchors.verticalCenter: parent.verticalCenter
                visible: root.text !== ""
            }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}
