import QtQuick
import QtQuick.Controls

Item {
    id: root

    signal appSelected(string name, string iconSource)

    // Subtle dark gradient vignette allowing the cockpit wallpaper to shine through
    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: Qt.rgba(7/255, 10/255, 18/255, 0.35) }
            GradientStop { position: 0.5; color: Qt.rgba(7/255, 10/255, 18/255, 0.45) }
            GradientStop { position: 1.0; color: Qt.rgba(7/255, 10/255, 18/255, 0.65) }
        }
    }

    // =========================================================================
    // TOP HEADER: Profile Badge & Name (Left) | Settings Button (Right)
    // =========================================================================
    Item {
        id: headerArea
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 64
        z: 10

        // Profile Badge & Title
        Row {
            id: profileRow
            anchors.left: parent.left
            anchors.leftMargin: 44
            anchors.verticalCenter: parent.verticalCenter
            spacing: 14

            // "P1" Badge Pill
            Rectangle {
                width: 34
                height: 24
                anchors.verticalCenter: parent.verticalCenter
                radius: 5
                color: Qt.rgba(255, 255, 255, 0.08)
                border.color: Qt.rgba(255, 255, 255, 0.55)
                border.width: 1.5

                Text {
                    anchors.centerIn: parent
                    text: "P1"
                    color: "#FFFFFF"
                    font.family: "Inter"
                    font.pixelSize: 12
                    font.weight: Font.Bold
                }
            }

            // "Profile 1" Text
            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: "Profile 1"
                color: "#FFFFFF"
                font.family: "Inter"
                font.pixelSize: 22
                font.weight: Font.DemiBold
            }
        }

        // Right Settings Button (White sliders icon matching reference image)
        Item {
            id: settingsBtn
            anchors.right: parent.right
            anchors.rightMargin: 36
            anchors.verticalCenter: parent.verticalCenter
            width: 44
            height: 44

            Rectangle {
                anchors.fill: parent
                radius: 22
                color: settingsMouse.pressed ? Qt.rgba(255, 255, 255, 0.18) : (settingsMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.08) : "transparent")
                scale: settingsMouse.pressed ? 0.92 : 1.0
                Behavior on scale { NumberAnimation { duration: 120 } }
                Behavior on color { ColorAnimation { duration: 150 } }
            }

            Image {
                anchors.centerIn: parent
                width: 28
                height: 28
                source: "qrc:/ApexVision/qml/assets/icons/setting_sliders_white.svg"
                fillMode: Image.PreserveAspectFit
                smooth: true
            }

            MouseArea {
                id: settingsMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    root.appSelected("Settings");
                }
            }
        }
    }

    // =========================================================================
    // DYNAMIC VERTICAL SCROLL INDICATOR (Matching Settings Dragger)
    // =========================================================================
    Item {
        id: scrollTrack
        anchors.left: parent.left
        anchors.leftMargin: 20
        anchors.top: headerArea.bottom
        anchors.bottom: parent.bottom
        anchors.topMargin: 16
        anchors.bottomMargin: 24
        width: 7
        z: 20
        visible: appsFlickable.contentHeight > appsFlickable.height

        // Track background line (Exact match with Settings leftMenuDraggerTrack)
        Rectangle {
            anchors.fill: parent
            radius: 3.5
            color: Qt.rgba(255, 255, 255, 0.08)
        }

        // Draggable thumb (Exact match with Settings leftMenuDraggerThumb)
        Rectangle {
            id: scrollIndicatorThumb
            width: parent.width
            radius: 3.5
            color: draggerMouse.pressed ? Qt.rgba(255, 255, 255, 0.48) :
                   (draggerMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.35) : Qt.rgba(255, 255, 255, 0.22))
            border.color: Qt.rgba(255, 255, 255, 0.40)
            border.width: 1

            // Dynamic height based on visible content ratio
            readonly property real visibleRatio: Math.min(1.0, appsFlickable.height / Math.max(1, appsFlickable.contentHeight))
            height: Math.max(48, parent.height * visibleRatio)

            // Position synced with appsFlickable.contentY
            readonly property real maxContentY: Math.max(1, appsFlickable.contentHeight - appsFlickable.height)
            readonly property real maxThumbY: Math.max(1, parent.height - height)
            y: Math.min(maxThumbY, Math.max(0, (appsFlickable.contentY / maxContentY) * maxThumbY))

            Behavior on color { ColorAnimation { duration: 120 } }

            MouseArea {
                id: draggerMouse
                anchors.fill: parent
                anchors.margins: -10
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                drag.target: scrollIndicatorThumb
                drag.axis: Drag.YAxis
                drag.minimumY: 0
                drag.maximumY: scrollTrack.height - scrollIndicatorThumb.height

                onPositionChanged: {
                    if (drag.active) {
                        var ratio = scrollIndicatorThumb.y / Math.max(1, scrollTrack.height - scrollIndicatorThumb.height);
                        appsFlickable.contentY = ratio * (appsFlickable.contentHeight - appsFlickable.height);
                    }
                }
            }
        }

        // Click-to-jump on track
        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            z: -1
            onClicked: function(mouse) {
                var targetThumbY = mouse.y - scrollIndicatorThumb.height / 2;
                var maxThumbY = scrollTrack.height - scrollIndicatorThumb.height;
                var clickRatio = Math.max(0, Math.min(1, targetThumbY / Math.max(1, maxThumbY)));
                appsFlickable.contentY = clickRatio * (appsFlickable.contentHeight - appsFlickable.height);
            }
        }
    }

    // =========================================================================
    // APPS GRID FLICKABLE (4 Columns, automotive circular app icons)
    // =========================================================================
    Flickable {
        id: appsFlickable
        anchors.top: headerArea.bottom
        anchors.bottom: parent.bottom
        anchors.left: scrollTrack.right
        anchors.leftMargin: 20
        anchors.right: parent.right
        anchors.rightMargin: 40
        anchors.topMargin: 10
        anchors.bottomMargin: 16
        contentWidth: width
        contentHeight: appsGrid.height + 36
        clip: true
        boundsBehavior: Flickable.DragAndOvershootBounds
        flickDeceleration: 1800

        Grid {
            id: appsGrid
            width: parent.width
            columns: 4
            rowSpacing: 34
            columnSpacing: 0

            // Full Comprehensive Apps Model without App Store
            Repeater {
                model: [
                    // ROW 1: Navigation, Voice Assistant, Rejuvenate, Phone
                    {
                        name: "Navigation",
                        action: "Navigation",
                        icon: "qrc:/ApexVision/qml/assets/icons/app_navigation.svg"
                    },
                    {
                        name: "Voice Assistant",
                        action: "Assistant",
                        icon: "qrc:/ApexVision/qml/assets/icons/app_assistant.svg"
                    },
                    {
                        name: "Rejuvenate",
                        action: "Rejuvenate",
                        icon: "qrc:/ApexVision/qml/assets/icons/app_rejuvenate.svg"
                    },
                    {
                        name: "Phone",
                        action: "Phone",
                        icon: "qrc:/ApexVision/qml/assets/icons/app_phone.svg"
                    },

                    // ROW 2: AM, FM, SiriusXM, Bluetooth Audio
                    {
                        name: "AM",
                        action: "RadioAM",
                        icon: "qrc:/ApexVision/qml/assets/icons/app_am.svg"
                    },
                    {
                        name: "FM",
                        action: "RadioFM",
                        icon: "qrc:/ApexVision/qml/assets/icons/app_fm.svg"
                    },
                    {
                        name: "OrbitXM",
                        action: "OrbitXM",
                        icon: "qrc:/ApexVision/qml/assets/radio_logos/orbitxm_logo.png"
                    },
                    {
                        name: "Bluetooth Audio",
                        action: "Bluetooth",
                        icon: "qrc:/ApexVision/qml/assets/icons/app_bluetooth.svg"
                    },

                    // ROW 3: Messages, Apple CarPlay, Towing, Wi-Fi Hotspot
                    {
                        name: "Messages",
                        action: "Messages",
                        icon: "qrc:/ApexVision/qml/assets/icons/app_messages.svg"
                    },
                    {
                        name: "Apple CarPlay",
                        action: "AppleCarPlay",
                        icon: "qrc:/ApexVision/qml/assets/icons/app_carplay.svg"
                    },
                    {
                        name: "Towing",
                        action: "Towing",
                        icon: "qrc:/ApexVision/qml/assets/icons/app_trailer.svg"
                    },
                    {
                        name: "Wi-Fi Hotspot",
                        action: "Hotspot",
                        icon: "qrc:/ApexVision/qml/assets/icons/app_hotspot.svg"
                    },

                    // ROW 4: Owner's Manual, Software Updates, Settings, Games
                    {
                        name: "Owner's Manual",
                        action: "Manual",
                        icon: "qrc:/ApexVision/qml/assets/icons/app_manual.svg"
                    },
                    {
                        name: "Software Updates",
                        action: "Updates",
                        icon: "qrc:/ApexVision/qml/assets/icons/app_updates.svg"
                    },
                    {
                        name: "Settings",
                        action: "Settings",
                        icon: "qrc:/ApexVision/qml/assets/icons/setting_sliders_logo.svg"
                    },
                    {
                        name: "Games",
                        action: "Games",
                        icon: "qrc:/ApexVision/qml/assets/icons/app_games.svg"
                    },

                    // ROW 5: News, Video, Android Auto
                    {
                        name: "News",
                        action: "News",
                        icon: "qrc:/ApexVision/qml/assets/icons/app_news.svg"
                    },
                    {
                        name: "YouTube",
                        action: "YouTube",
                        icon: "qrc:/ApexVision/qml/assets/icons/app_video.svg"
                    },
                    {
                        name: "Android Auto",
                        action: "AndroidAuto",
                        icon: "qrc:/ApexVision/qml/assets/icons/app_projection.svg"
                    }
                ]

                // Individual App Item Container
                Item {
                    width: appsGrid.width / 4
                    height: 114

                    Column {
                        anchors.centerIn: parent
                        spacing: 10

                        // Circular App Icon with smooth press/hover feedback
                        Item {
                            id: iconContainer
                            anchors.horizontalCenter: parent.horizontalCenter
                            width: 72
                            height: 72

                            scale: appItemMouse.pressed ? 0.90 : (appItemMouse.containsMouse ? 1.05 : 1.0)
                            Behavior on scale {
                                NumberAnimation {
                                    duration: 160
                                    easing.type: Easing.OutBack
                                    easing.overshoot: 1.2
                                }
                            }

                            Image {
                                anchors.fill: parent
                                source: modelData.icon
                                fillMode: Image.PreserveAspectFit
                                smooth: true
                                mipmap: true
                                sourceSize: Qt.size(256, 256)
                            }
                        }

                        // App Label beneath
                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: modelData.name
                            color: "#FFFFFF"
                            font.family: "Inter"
                            font.pixelSize: 15
                            font.weight: Font.Medium
                            horizontalAlignment: Text.AlignHCenter
                            opacity: appItemMouse.pressed ? 0.75 : 1.0
                            Behavior on opacity { NumberAnimation { duration: 120 } }
                        }
                    }

                    // Mouse Interaction Area
                    MouseArea {
                        id: appItemMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            handleAppClick(modelData.name, modelData.action, modelData.icon);
                        }
                    }
                }
            }
        }
    }

    // =========================================================================
    // APPS TOAST / INTERACTION NOTIFICATION
    // =========================================================================
    Rectangle {
        id: toastNotice
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 24
        anchors.horizontalCenter: parent.horizontalCenter
        width: toastText.implicitWidth + 48
        height: 42
        radius: 21
        color: Qt.rgba(14/255, 23/255, 42/255, 0.94)
        border.color: Qt.rgba(255, 255, 255, 0.2)
        border.width: 1
        opacity: 0.0
        visible: opacity > 0.01
        z: 99

        Behavior on opacity {
            NumberAnimation { duration: 200 }
        }

        Text {
            id: toastText
            anchors.centerIn: parent
            text: ""
            color: "#FFFFFF"
            font.family: "Inter"
            font.pixelSize: 14
            font.weight: Font.Medium
        }

        Timer {
            id: toastTimer
            interval: 2200
            onTriggered: {
                toastNotice.opacity = 0.0;
            }
        }
    }

    function showToast(msg) {
        toastText.text = msg;
        toastNotice.opacity = 1.0;
        toastTimer.restart();
    }

    function handleAppClick(name, action, icon) {
        root.appSelected(action || name, icon);
    }
}
