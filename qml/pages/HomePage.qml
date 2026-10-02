import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import ApexVision
import "../components"

Item {
    id: root

    property bool climateOpen: false
    property bool navExpanded: false
    property bool inNavTransition: false
    signal openPlayerRequested()

    function setNavExpanded(expanded, openSearch) {
        root.navExpanded = expanded;
        navPanel.isExpanded = expanded;
        navPanel.updateMapMode();
        if (expanded && openSearch) {
            navPanel.openSearch();
        }
    }

    function collapseNav() {
        navFadeAnimation.stop();
        root.inNavTransition = false;
        navFadeOverlay.opacity = 0.0;
        setNavExpanded(false, false);
    }

    onVisibleChanged: {
        if (!visible && root.navExpanded) {
            collapseNav();
        }
    }

    function triggerNavToggle(openSearch) {
        if (inNavTransition) return;
        navFadeAnimation.openSearchOnExpand = (openSearch === true);
        navFadeAnimation.start();
    }

    SequentialAnimation {
        id: navFadeAnimation
        property bool openSearchOnExpand: false
        running: false
        alwaysRunToEnd: true

        ScriptAction {
            script: {
                root.inNavTransition = true;
            }
        }

        // 1. Fade out current view (fade to dark cockpit tone)
        NumberAnimation {
            target: navFadeOverlay
            property: "opacity"
            to: 1.0
            duration: 180
            easing.type: Easing.InOutQuad
        }

        // 2. Switch state while concealed by the dark overlay
        ScriptAction {
            script: {
                root.setNavExpanded(!root.navExpanded, navFadeAnimation.openSearchOnExpand);
            }
        }

        // 3. Brief hold to let layout and WebEngine geometry settle cleanly
        PauseAnimation {
            duration: 40
        }

        // 4. Fade back in smoothly revealing the new state
        NumberAnimation {
            target: navFadeOverlay
            property: "opacity"
            to: 0.0
            duration: 220
            easing.type: Easing.OutQuad
        }

        ScriptAction {
            script: {
                root.inNavTransition = false;
            }
        }
    }

    RowLayout {
        anchors.fill: parent
        anchors.margins: root.navExpanded ? 0 : 16
        spacing: root.navExpanded ? 0 : 16

        // Navigation Area (Left / Center: ~62% width or full width when expanded)
        NavigationPanel {
            id: navPanel
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.preferredWidth: root.navExpanded ? 100 : 62
            isExpanded: root.navExpanded
            onToggleExpandRequested: function(openSearch) {
                root.triggerNavToggle(openSearch);
            }
        }

        // Media Card (Right: ~38% width, collapsed when navigation is expanded)
        MediaCard {
            id: mediaCard
            Layout.fillHeight: true
            Layout.fillWidth: !root.navExpanded
            Layout.preferredWidth: root.navExpanded ? 0 : 38
            visible: !root.navExpanded
            onOpenPlayerRequested: root.openPlayerRequested()
            onSourceMenuRequested: {
                sourceMenuModal.visible = true;
            }
        }
    }

    // -------------------------------------------------------------------------
    // FADE TRANSITION OVERLAY: Smooth crossfade between Homescreen & Fullscreen Map
    // -------------------------------------------------------------------------
    Rectangle {
        id: navFadeOverlay
        anchors.fill: parent
        color: "#070A0F"
        opacity: 0.0
        visible: opacity > 0.001
        z: 9999

        MouseArea {
            anchors.fill: parent
            enabled: navFadeOverlay.visible && navFadeOverlay.opacity > 0.05
        }
    }

    // -------------------------------------------------------------------------
    // FULL-SCREEN BLURRED / DIMMED BACKDROP FOR SOURCE MODAL
    // -------------------------------------------------------------------------
    Rectangle {
        id: sourceModalBackdrop
        anchors.fill: parent
        color: Qt.rgba(3/255, 7/255, 18/255, 0.74)
        visible: sourceMenuModal.visible
        z: 900

        MouseArea {
            anchors.fill: parent
            onClicked: {
                sourceMenuModal.visible = false;
            }
        }
    }

    // -------------------------------------------------------------------------
    // SOURCE MODAL POPUP (Centered in the exact middle of the screen)
    // NO dragger (all items fit on 1 page), Bigger icons and texts
    // -------------------------------------------------------------------------
    Rectangle {
        id: sourceMenuModal
        objectName: "cardSourceDropdown"
        anchors.centerIn: parent
        width: 360
        height: sourceMenuCol.implicitHeight + 24
        radius: 20
        color: Qt.rgba(11/255, 18/255, 34/255, 0.98)
        border.color: Qt.rgba(255, 255, 255, 0.20)
        border.width: 1.5
        visible: false
        z: 950

        Column {
            id: sourceMenuCol
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 12
            spacing: 2

            Repeater {
                model: [
                    { name: "OrbitXM", sourceKey: "OrbitXM", icon: "qrc:/ApexVision/qml/assets/radio_logos/orbitxm_logo.png" },
                    { name: "Apple CarPlay", sourceKey: "CarPlay", icon: "qrc:/ApexVision/qml/assets/icons/app_carplay.svg" },
                    { name: "FM", sourceKey: "FM", icon: "qrc:/ApexVision/qml/assets/icons/radio_source.svg" },
                    { name: "AM", sourceKey: "AM", icon: "qrc:/ApexVision/qml/assets/icons/radio_source.svg" },
                    { name: "USB DISK", sourceKey: "USB", icon: "qrc:/ApexVision/qml/assets/icons/usb_source.svg" },
                    { name: "Bluetooth Audio", sourceKey: "Bluetooth", icon: "qrc:/ApexVision/qml/assets/icons/bluetooth.svg" }
                ]

                Item {
                    width: sourceMenuCol.width
                    height: 60

                    Rectangle {
                        anchors.fill: parent
                        radius: 12
                        color: menuMouse.pressed ? Qt.rgba(255, 255, 255, 0.16) :
                               (menuMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.08) :
                               (MediaBackend.source === modelData.sourceKey ? Qt.rgba(30/255, 136/255, 229/255, 0.25) : "transparent"))
                        Behavior on color { ColorAnimation { duration: 120 } }
                    }

                    Row {
                        anchors.left: parent.left
                        anchors.leftMargin: 16
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 18

                        // Circular badge with Icon (OrbitXM renders directly without redundant outer blue background)
                        Rectangle {
                            width: 40
                            height: 40
                            radius: 20
                            color: modelData.sourceKey === "OrbitXM" ? "transparent" : "#1976D2"
                            anchors.verticalCenter: parent.verticalCenter

                            // Icon inside badge
                            Image {
                                anchors.centerIn: parent
                                width: modelData.sourceKey === "OrbitXM" ? 40 : 22
                                height: modelData.sourceKey === "OrbitXM" ? 40 : 22
                                source: modelData.icon
                                fillMode: Image.PreserveAspectFit
                                smooth: true
                                mipmap: true
                            }
                        }

                        // Bigger text
                        Text {
                            text: modelData.name
                            color: "#FFFFFF"
                            font.family: "Inter"
                            font.pixelSize: 18
                            font.weight: MediaBackend.source === modelData.sourceKey ? Font.Bold : Font.Medium
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    // Subtle divider line
                    Rectangle {
                        anchors.bottom: parent.bottom
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.leftMargin: 16
                        anchors.rightMargin: 16
                        height: 1
                        color: Qt.rgba(255, 255, 255, 0.08)
                        visible: index < 5
                    }

                    MouseArea {
                        id: menuMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            MediaBackend.setSource(modelData.sourceKey);
                            sourceMenuModal.visible = false;
                        }
                    }
                }
            }
        }
    }
}
