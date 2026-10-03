/**
 * ==============================================================================
 * Project: Apex VISION IVI - Digital Cockpit & Infotainment System
 * File: AppsPage.qml
 * Author / Developer: Sk Rehan Ahamed
 * License: MIT
 * ==============================================================================
 */

import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import ApexVision

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

        // Profile Container (Left)
        Item {
            id: profileContainer
            anchors.left: parent.left
            anchors.leftMargin: 44
            anchors.verticalCenter: parent.verticalCenter
            width: profileRow.width
            height: 44

            Row {
                id: profileRow
                anchors.verticalCenter: parent.verticalCenter
                spacing: 14

                // Profile Picture / Monogram Badge
                Item {
                    width: 38
                    height: 38
                    anchors.verticalCenter: parent.verticalCenter

                    // Image Avatar if avatarPath is set
                    Item {
                        anchors.fill: parent
                        visible: VehicleBackend.driverProfileAvatarPath !== ""

                        Image {
                            id: appHeaderAvatarImg
                            anchors.fill: parent
                            source: VehicleBackend.driverProfileAvatarPath
                            fillMode: Image.PreserveAspectCrop
                            visible: false
                        }
                        Rectangle {
                            id: appHeaderAvatarMask
                            anchors.fill: parent
                            radius: 19
                            visible: false
                            layer.enabled: true
                        }
                        MultiEffect {
                            anchors.fill: parent
                            source: appHeaderAvatarImg
                            maskEnabled: true
                            maskSource: appHeaderAvatarMask
                        }
                        Rectangle {
                            anchors.fill: parent
                            radius: 19
                            color: "transparent"
                            border.color: Qt.rgba(255, 255, 255, 0.40)
                            border.width: 1.5
                        }
                    }

                    // Monogram Badge Pill if no image avatar
                    Rectangle {
                        anchors.fill: parent
                        radius: 8
                        visible: VehicleBackend.driverProfileAvatarPath === ""
                        color: Qt.rgba(37/255, 99/255, 235/255, 0.35)
                        border.color: Qt.rgba(56/255, 189/255, 248/255, 0.65)
                        border.width: 1.5

                        Text {
                            anchors.centerIn: parent
                            text: VehicleBackend.driverProfile
                            color: "#FFFFFF"
                            font.family: "Inter"
                            font.pixelSize: 13
                            font.weight: Font.Bold
                        }
                    }
                }

                // Profile Name Text
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: VehicleBackend.driverProfileName
                    color: "#FFFFFF"
                    font.family: "Inter"
                    font.pixelSize: 22
                    font.weight: Font.DemiBold
                }
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    if (typeof SystemBackend !== "undefined") SystemBackend.playTouchSound();
                    root.appSelected("ProfileSwitcher", "qrc:/ApexVision/qml/assets/icons/setting_profile.png");
                }
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
                    if (typeof SystemBackend !== "undefined") SystemBackend.playTouchSound();
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

    property bool isDraggingAny: false
    property int dragIndex: -1
    property string dragAction: ""

    ListModel {
        id: appsModel
    }

    function loadApps() {
        appsModel.clear();
        var defaultApps = [
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

            // ROW 2: AM, FM, OrbitXM (Default media sources)
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
            }
        ];

        if (typeof PhoneBackend !== "undefined" && PhoneBackend.isConnected) {
            defaultApps.push({
                name: "Bluetooth Audio",
                action: "Bluetooth",
                icon: "qrc:/ApexVision/qml/assets/icons/app_bluetooth.svg"
            });
        }

        defaultApps = defaultApps.concat([
            // ROW 3: Messages, Apple CarPlay, Towing
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
        ]);

        var savedOrderRaw = (typeof PersistenceManager !== "undefined") ? PersistenceManager.getSetting("app_order", "") : "";
        var orderedList = [];
        var map = {};
        for (var i = 0; i < defaultApps.length; ++i) {
            map[defaultApps[i].action] = defaultApps[i];
        }

        if (savedOrderRaw && typeof savedOrderRaw === "string" && savedOrderRaw.length > 2) {
            try {
                var savedActions = JSON.parse(savedOrderRaw);
                if (Array.isArray(savedActions)) {
                    for (var j = 0; j < savedActions.length; ++j) {
                        var act = savedActions[j];
                        if (map[act]) {
                            orderedList.push(map[act]);
                            delete map[act];
                        }
                    }
                }
            } catch(e) {
                console.warn("Failed parsing saved app order:", e);
            }
        }

        // Append remaining apps that weren't in saved order
        for (var k = 0; k < defaultApps.length; ++k) {
            if (map[defaultApps[k].action]) {
                orderedList.push(defaultApps[k]);
            }
        }

        for (var m = 0; m < orderedList.length; ++m) {
            appsModel.append(orderedList[m]);
        }
    }

    function saveAppOrder() {
        if (typeof PersistenceManager === "undefined") return;
        var order = [];
        for (var i = 0; i < appsModel.count; ++i) {
            order.push(appsModel.get(i).action);
        }
        PersistenceManager.setSetting("app_order", JSON.stringify(order));
    }

    Connections {
        target: typeof PhoneBackend !== "undefined" ? PhoneBackend : null
        function onIsConnectedChanged() {
            root.loadApps();
        }
    }

    Component.onCompleted: {
        root.loadApps();
    }

    // =========================================================================
    // FLOATING DRAG GHOST (Android elevation effect)
    // =========================================================================
    Item {
        id: dragGhost
        width: appsFlickable.cellWidth
        height: appsFlickable.cellHeight
        z: 1000
        visible: root.isDraggingAny
        scale: 1.15

        property string ghostName: ""
        property string ghostIcon: ""

        Behavior on scale {
            NumberAnimation { duration: 150; easing.type: Easing.OutBack; easing.overshoot: 1.3 }
        }

        Column {
            anchors.centerIn: parent
            spacing: 10

            Item {
                id: ghostIconContainer
                anchors.horizontalCenter: parent.horizontalCenter
                width: 72
                height: 72

                // Android Drop Shadow / Elevation Halo
                Rectangle {
                    anchors.centerIn: parent
                    width: 86
                    height: 86
                    radius: 43
                    color: Qt.rgba(0, 210, 255, 0.32)
                    border.color: "#00D2FF"
                    border.width: 2.5
                }

                Image {
                    anchors.fill: parent
                    source: dragGhost.ghostIcon
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                    mipmap: true
                    sourceSize: Qt.size(256, 256)
                }
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: dragGhost.ghostName
                color: "#00D2FF"
                font.family: "Inter"
                font.pixelSize: 15
                font.weight: Font.DemiBold
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }

    // =========================================================================
    // APPS GRID FLICKABLE (4 Columns, automotive circular app icons, draggable)
    // =========================================================================
    GridView {
        id: appsFlickable
        anchors.top: headerArea.bottom
        anchors.bottom: parent.bottom
        anchors.left: scrollTrack.right
        anchors.leftMargin: 20
        anchors.right: parent.right
        anchors.rightMargin: 40
        anchors.topMargin: 10
        anchors.bottomMargin: 16
        cellWidth: width / 4
        cellHeight: 120
        clip: true
        interactive: !root.isDraggingAny
        boundsBehavior: Flickable.DragAndOvershootBounds
        flickDeceleration: 1800

        model: appsModel

        displaced: Transition {
            NumberAnimation {
                properties: "x,y"
                duration: 250
                easing.type: Easing.OutCubic
            }
        }

        delegate: Item {
            id: delegateRoot
            width: appsFlickable.cellWidth
            height: appsFlickable.cellHeight

            readonly property bool isThisHeld: root.isDraggingAny && root.dragIndex === index

            // Normal Item Container
            Column {
                anchors.centerIn: parent
                spacing: 10
                opacity: delegateRoot.isThisHeld ? 0.0 : 1.0
                visible: opacity > 0.01
                Behavior on opacity { NumberAnimation { duration: 120 } }

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
                        source: model.icon
                        fillMode: Image.PreserveAspectFit
                        smooth: true
                        mipmap: true
                        sourceSize: Qt.size(256, 256)
                    }
                }

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: model.name
                    color: "#FFFFFF"
                    font.family: "Inter"
                    font.pixelSize: 15
                    font.weight: Font.Medium
                    horizontalAlignment: Text.AlignHCenter
                    opacity: appItemMouse.pressed ? 0.75 : 1.0
                    Behavior on opacity { NumberAnimation { duration: 120 } }
                }
            }

            MouseArea {
                id: appItemMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: root.isDraggingAny ? Qt.ClosedHandCursor : Qt.PointingHandCursor
                pressAndHoldInterval: 350

                onPressAndHold: {
                    root.isDraggingAny = true;
                    root.dragIndex = index;
                    root.dragAction = model.action;
                    dragGhost.ghostName = model.name;
                    dragGhost.ghostIcon = model.icon;

                    var p = delegateRoot.mapToItem(root, 0, 0);
                    dragGhost.x = p.x;
                    dragGhost.y = p.y;

                    if (typeof SystemBackend !== "undefined") {
                        SystemBackend.playTouchSound();
                    }
                }

                onPositionChanged: function(mouse) {
                    if (root.isDraggingAny && root.dragIndex === index) {
                        var globalPos = delegateRoot.mapToItem(root, mouse.x, mouse.y);
                        dragGhost.x = globalPos.x - dragGhost.width / 2;
                        dragGhost.y = globalPos.y - dragGhost.height / 2;

                        var gridPos = root.mapToItem(appsFlickable.contentItem, globalPos.x, globalPos.y);
                        var col = Math.floor(gridPos.x / appsFlickable.cellWidth);
                        var row = Math.floor(gridPos.y / appsFlickable.cellHeight);
                        if (col >= 0 && col < 4 && row >= 0) {
                            var targetIdx = row * 4 + col;
                            if (targetIdx >= 0 && targetIdx < appsModel.count && targetIdx !== root.dragIndex) {
                                appsModel.move(root.dragIndex, targetIdx, 1);
                                root.dragIndex = targetIdx;
                                if (typeof SystemBackend !== "undefined") {
                                    SystemBackend.playTouchSound();
                                }
                            }
                        }
                    }
                }

                onReleased: {
                    if (root.isDraggingAny) {
                        root.isDraggingAny = false;
                        root.dragIndex = -1;
                        root.dragAction = "";
                        root.saveAppOrder();
                        root.showToast("App layout saved");
                        if (typeof SystemBackend !== "undefined") {
                            SystemBackend.playTouchSound();
                        }
                    }
                }

                onCanceled: {
                    if (root.isDraggingAny) {
                        root.isDraggingAny = false;
                        root.dragIndex = -1;
                        root.dragAction = "";
                    }
                }

                onClicked: {
                    if (!root.isDraggingAny) {
                        if (typeof SystemBackend !== "undefined") {
                            SystemBackend.playTouchSound();
                        }
                        handleAppClick(model.name, model.action, model.icon);
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
