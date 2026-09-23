import QtQuick
import QtQuick.Controls
import ApexVision
import ".."

Rectangle {
    id: root

    property int currentIndex: 0
    signal pageSelected(int index)

    width: 78
    color: "#070A0F" // Deep automotive cockpit black, completely borderless

    // 1. TOP HEADER: TIME & APEX LOGO
    Column {
        id: topSection
        anchors.top: parent.top
        anchors.topMargin: 18
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 8

        // Digital Clock (Clean, perfectly balanced automotive display)
        Text {
            id: clockText
            anchors.horizontalCenter: parent.horizontalCenter
            text: SystemBackend.currentTime
            color: "#FFFFFF"
            font.family: "Inter"
            font.pixelSize: 20
            font.weight: Font.DemiBold
            font.letterSpacing: 0.2
            renderType: Text.NativeRendering
        }

        // APEX Logo (Transparent)
        Image {
            anchors.horizontalCenter: parent.horizontalCenter
            width: 52
            height: 15
            fillMode: Image.PreserveAspectFit
            source: "qrc:/ApexVision/qml/assets/icons/apex_logo.png"
            smooth: true
            mipmap: true
            opacity: 0.85
        }
    }

    // 2. CENTER NAVIGATION ICONS (Vertically centered in the screen)
    Column {
        id: navIconsColumn
        anchors.centerIn: parent
        spacing: 32

        // Item 0: Home
        LincolnNavItem {
            icon: "qrc:/ApexVision/qml/assets/icons/icon_home.png"
            iconWidth: 32
            iconHeight: 30
            isSelected: root.currentIndex === 0
            onClicked: {
                root.currentIndex = 0;
                root.pageSelected(0);
            }
        }

        // Item 1: Car / Vehicle
        LincolnNavItem {
            icon: "qrc:/ApexVision/qml/assets/icons/icon_car.png"
            iconWidth: 36
            iconHeight: 27
            isSelected: root.currentIndex === 1
            onClicked: {
                root.currentIndex = 1;
                root.pageSelected(1);
            }
        }

        // Item 2: Menu (6-circle Grid)
        LincolnNavItem {
            icon: "qrc:/ApexVision/qml/assets/icons/icon_menu.png"
            iconWidth: 32
            iconHeight: 23
            isSelected: root.currentIndex === 2
            onClicked: {
                root.currentIndex = 2;
                root.pageSelected(2);
            }
        }
    }

    // Pure borderless automotive navigation item:
    // Zero background box, zero border, zero glow disc.
    // Becomes radiantly brighter and expands fluidly on press/selection.
    component LincolnNavItem: Item {
        id: navItem
        property string icon: ""
        property real iconWidth: 32
        property real iconHeight: 32
        property bool isSelected: false
        signal clicked()

        width: 60
        height: 60
        anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined

        // Icon with luminous brightness and scale transition
        Image {
            id: iconImg
            anchors.centerIn: parent
            width: navItem.iconWidth
            height: navItem.iconHeight
            fillMode: Image.PreserveAspectFit
            source: navItem.icon
            smooth: true
            mipmap: true

            // Pure brightness transition: elegant 0.38 when idle, radiant 1.0 when active/pressed
            opacity: navMouse.pressed ? 1.0 :
                     (navItem.isSelected ? 1.0 : 0.38)

            // Lincoln subtle scale expansion for active item
            scale: navMouse.pressed ? 0.92 :
                   (navItem.isSelected ? 1.10 : 1.0)

            Behavior on opacity {
                NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
            }
            Behavior on scale {
                NumberAnimation { duration: 220; easing.type: Easing.OutCubic }
            }
        }

        MouseArea {
            id: navMouse
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: navItem.clicked()
        }
    }
}
