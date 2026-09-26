import QtQuick
import QtQuick.Controls
import ApexVision

Item {
    id: root
    objectName: "settingsPage"

    signal backRequested()

    // Default category matching user photo ("driver_assist" or "vehicle")
    property string activeCategory: "driver_assist"
    property string activeInfoText: ""

    // Driver assistance settings states (matching exact user photo)
    property string cruiseControlType: "adaptive" // "normal" | "adaptive"
    property bool laneCenteringEnabled: true
    property bool inLaneRepositioningEnabled: true

    // Vehicle settings states (matching image copy 7.png)
    property bool maxIdleEnabled: true
    property bool keyDetectionEnabled: true
    property bool rearOccupantEnabled: true
    property bool easyEntryEnabled: true

    // System settings states
    property bool autoUpdatesEnabled: true

    // =========================================================================
    // 0. BACKGROUND (Matches Default BG & Valet Screen)
    // =========================================================================
    Image {
        id: settingsBgImage
        anchors.fill: parent
        source: "qrc:/ApexVision/qml/assets/default_background.png"
        fillMode: Image.PreserveAspectCrop
        smooth: true
        z: 0
    }

    // Light scrim to preserve default background brightness
    Rectangle {
        anchors.fill: parent
        color: Qt.rgba(0, 0, 0, 0.15)
        z: 1
    }

    // Intercept clicks
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onClicked: root.activeInfoText = ""
    }

    // =========================================================================
    // 1. MAIN TWO-COLUMN WORKSPACE
    // Left side: Settings header + Categories menu
    // Right side: Active title with standard "←" back button + Divider + Items
    // =========================================================================
    Item {
        id: contentArea
        anchors.fill: parent
        anchors.leftMargin: 44
        anchors.rightMargin: 44
        anchors.topMargin: 24
        anchors.bottomMargin: 24
        z: 5

        // ---------------------------------------------------------------------
        // LEFT COLUMN: Header ("Settings") + Category Navigation Menu
        // ---------------------------------------------------------------------
        Item {
            id: leftColumn
            width: 320
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom

            // Top-Left Header: Circular Sliders Logo + "Settings"
            Row {
                id: leftHeaderRow
                anchors.left: parent.left
                anchors.top: parent.top
                height: 44
                spacing: 14

                // Bright blue circular logo with two slider bars (Automotive OEM settings icon)
                Image {
                    width: 38
                    height: 38
                    anchors.verticalCenter: parent.verticalCenter
                    source: "qrc:/ApexVision/qml/assets/icons/setting_sliders_logo.png"
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                    mipmap: true

                    // Interactive subtle scale on hover
                    scale: settingsIconMouse.containsMouse ? 1.06 : 1.0
                    Behavior on scale { NumberAnimation { duration: 120 } }

                    MouseArea {
                        id: settingsIconMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            root.activeCategory = "driver_assist";
                            root.activeInfoText = "";
                        }
                    }
                }

                // "Settings" Title (Bold, pure white, no pill wrapper)
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: "Settings"
                    font.family: "Inter"
                    font.pixelSize: 26
                    font.weight: Font.DemiBold
                    color: "#FFFFFF"
                }
            }

            // Categories Menu (Sound, BT, Assist, Vehicle, System, Profile)
            Column {
                id: leftMenuColumn
                anchors.top: leftHeaderRow.bottom
                anchors.topMargin: 20
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                spacing: 8

                Repeater {
                    model: [
                        { id: "sound", name: "Sound", icon: "qrc:/ApexVision/qml/assets/icons/setting_sound.png" },
                        { id: "bluetooth", name: "Bluetooth", icon: "qrc:/ApexVision/qml/assets/icons/setting_bluetooth.png" },
                        { id: "driver_assist", name: "Driver assistance", icon: "qrc:/ApexVision/qml/assets/icons/setting_driver_assistance.png" },
                        { id: "vehicle", name: "Vehicle", icon: "qrc:/ApexVision/qml/assets/icons/setting_vehicle_amber.png" },
                        { id: "system", name: "System", icon: "qrc:/ApexVision/qml/assets/icons/setting_system.png" },
                        { id: "profile", name: "Profile", icon: "qrc:/ApexVision/qml/assets/icons/setting_profile.png" }
                    ]

                    // Frosted glass rounded pill highlight around selected category (matching user photo)
                    Rectangle {
                        width: parent.width
                        height: 60
                        radius: 16
                        color: root.activeCategory === modelData.id ?
                               Qt.rgba(255, 255, 255, 0.14) :
                               (itemMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.06) : "transparent")
                        border.color: root.activeCategory === modelData.id ?
                                      Qt.rgba(255, 255, 255, 0.22) : "transparent"
                        border.width: 1
                        Behavior on color { ColorAnimation { duration: 120 } }

                        Row {
                            anchors.fill: parent
                            anchors.leftMargin: 14
                            anchors.rightMargin: 14
                            spacing: 18

                            // Category Icon (Yellow when selected, White when unselected)
                            Image {
                                anchors.verticalCenter: parent.verticalCenter
                                width: 32
                                height: 32
                                source: root.activeCategory === modelData.id ?
                                        ("qrc:/ApexVision/qml/assets/icons/setting_" + modelData.id + "_yellow.png") :
                                        ("qrc:/ApexVision/qml/assets/icons/setting_" + modelData.id + "_white.png")
                                fillMode: Image.PreserveAspectFit
                                smooth: true
                                mipmap: true
                            }

                            // Category Label
                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                text: modelData.name
                                font.family: "Inter"
                                font.pixelSize: 20
                                font.weight: root.activeCategory === modelData.id ? Font.DemiBold : Font.Normal
                                color: "#FFFFFF"
                            }
                        }

                        MouseArea {
                            id: itemMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                root.activeCategory = modelData.id;
                                root.activeInfoText = "";
                            }
                        }
                    }
                }
            }
        }

        // Vertical Divider Accent (Matching user photo)
        Rectangle {
            id: dividerLine
            anchors.left: leftColumn.right
            anchors.leftMargin: 24
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: 1
            color: Qt.rgba(255, 255, 255, 0.12)
        }

        // ---------------------------------------------------------------------
        // RIGHT COLUMN: Header (Standard "←" Back Button + Title) + Settings Items
        // ---------------------------------------------------------------------
        Item {
            id: rightColumn
            anchors.left: dividerLine.right
            anchors.leftMargin: 36
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom

            // Top-Right Header: Standard Back Button ("←") + Title ("Cruise Control")
            Item {
                id: rightHeaderRow
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                height: 44

                Row {
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 14

                    // Standard Back Button matching VehiclePage and other components
                    Item {
                        width: 36
                        height: 36
                        anchors.verticalCenter: parent.verticalCenter

                        Text {
                            anchors.centerIn: parent
                            text: "←"
                            font.pixelSize: 26
                            font.weight: Font.DemiBold
                            color: backMouseArea.pressed ? "#94A3B8" : (backMouseArea.containsMouse ? "#FFFFFF" : "#E2E8F0")
                        }

                        MouseArea {
                            id: backMouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                if (root.activeCategory !== "driver_assist") {
                                    root.activeCategory = "driver_assist";
                                } else {
                                    root.backRequested();
                                }
                            }
                        }
                    }

                    // Screen Title (e.g. "Cruise Control", "Vehicle", etc.)
                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: {
                            switch(root.activeCategory) {
                                case "driver_assist": return "Cruise Control";
                                case "vehicle": return "Vehicle";
                                case "sound": return "Sound";
                                case "bluetooth": return "Bluetooth";
                                case "system": return "System";
                                case "profile": return "Profile";
                                default: return "Cruise Control";
                            }
                        }
                        font.family: "Inter"
                        font.pixelSize: 26
                        font.weight: Font.DemiBold
                        color: "#FFFFFF"
                    }
                }

                // Horizontal separator line under header spanning across right content
                Rectangle {
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: 1
                    color: Qt.rgba(255, 255, 255, 0.12)
                }
            }

            // Right Items Container (below header)
            Item {
                id: rightContent
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: rightHeaderRow.bottom
                anchors.topMargin: 12
                anchors.bottom: parent.bottom

            // Info Explanation Banner (When ⓘ is clicked)
            Rectangle {
                id: infoBanner
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                height: root.activeInfoText !== "" ? 44 : 0
                visible: height > 0
                clip: true
                radius: 10
                color: Qt.rgba(30/255, 64/255, 175/255, 0.35)
                border.color: "#3B82F6"
                border.width: 1
                Behavior on height { NumberAnimation { duration: 200; easing.type: Easing.OutQuad } }

                Row {
                    anchors.fill: parent
                    anchors.leftMargin: 16
                    anchors.rightMargin: 16
                    spacing: 12

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: "ⓘ"
                        font.pixelSize: 18
                        color: "#60A5FA"
                    }

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: root.activeInfoText
                        font.family: "Inter"
                        font.pixelSize: 15
                        color: "#FFFFFF"
                    }
                }
            }

            // =================================================================
            // CATEGORY: DRIVER ASSISTANCE / CRUISE CONTROL (Matching New User Photo Exactly)
            // =================================================================
            Column {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: infoBanner.bottom
                anchors.topMargin: root.activeInfoText !== "" ? 12 : 0
                anchors.bottom: parent.bottom
                visible: root.activeCategory === "driver_assist"
                spacing: 0

                // 1. Normal Cruise Control (Radio Button - Unselected)
                SettingRowRadio {
                    title: "Normal Cruise Control"
                    selected: root.cruiseControlType === "normal"
                    infoText: "Maintains a constant set speed without automatic distance gap adjustment."
                    onSelectedRequested: root.cruiseControlType = "normal"
                    onInfoClicked: root.activeInfoText = infoText
                }

                // 2. Adaptive Cruise Control (Radio Button - Selected in Amber)
                SettingRowRadio {
                    title: "Adaptive Cruise Control"
                    selected: root.cruiseControlType === "adaptive"
                    infoText: "Maintains speed and adapts following distance based on the vehicle ahead."
                    onSelectedRequested: root.cruiseControlType = "adaptive"
                    onInfoClicked: root.activeInfoText = infoText
                }

                // 3. Lane Centering (Amber Switch + Subtitle "Hands-Free Available")
                SettingRowSwitch {
                    title: "Lane Centering"
                    subtitle: "Hands-Free Available"
                    checked: root.laneCenteringEnabled
                    infoText: "Provides continuous steering assistance to keep the vehicle centered within the lane."
                    onToggled: root.laneCenteringEnabled = !root.laneCenteringEnabled
                    onInfoClicked: root.activeInfoText = infoText
                }

                // 4. In-Lane Repositioning (Amber Switch)
                SettingRowSwitch {
                    title: "In-Lane Repositioning"
                    checked: root.inLaneRepositioningEnabled
                    infoText: "Subtly shifts the vehicle's lane position away from adjacent larger vehicles."
                    onToggled: root.inLaneRepositioningEnabled = !root.inLaneRepositioningEnabled
                    onInfoClicked: root.activeInfoText = infoText
                }
            }

            // =================================================================
            // CATEGORY: VEHICLE (Matching Previous User Photo image copy 7.png)
            // =================================================================
            Column {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: infoBanner.bottom
                anchors.topMargin: root.activeInfoText !== "" ? 12 : 0
                anchors.bottom: parent.bottom
                visible: root.activeCategory === "vehicle"
                spacing: 0

                // Item 1: 30min max idle (Switch + Info)
                SettingRowSwitch {
                    title: "30min max idle"
                    checked: root.maxIdleEnabled
                    infoText: "Engine automatically shuts down after 30 minutes of idling to conserve fuel."
                    onToggled: root.maxIdleEnabled = !root.maxIdleEnabled
                    onInfoClicked: root.activeInfoText = infoText
                }

                // Item 2: Rear occupant alert (Chevron + Info)
                SettingRowChevron {
                    title: "Rear occupant alert"
                    infoText: "Reminds you to check the rear seats before exiting the vehicle."
                    onClicked: root.activeInfoText = infoText
                    onInfoClicked: root.activeInfoText = infoText
                }

                // Item 3: Lighting (Chevron + Info)
                SettingRowChevron {
                    title: "Lighting"
                    infoText: "Configure welcome lighting, ambient cabin colors, and exterior headlight delay."
                    onClicked: root.activeInfoText = infoText
                    onInfoClicked: root.activeInfoText = infoText
                }

                // Item 4: Easy entry and exit (Chevron + Info)
                SettingRowChevron {
                    title: "Easy entry and exit"
                    infoText: "Automatically slides the driver seat back and tilts steering wheel for convenient entry."
                    onClicked: root.activeInfoText = infoText
                    onInfoClicked: root.activeInfoText = infoText
                }

                // Item 5: Key detection alert (Switch + Info)
                SettingRowSwitch {
                    title: "Key detection alert"
                    checked: root.keyDetectionEnabled
                    infoText: "Chimes if the smart key fob is removed from the vehicle while running."
                    onToggled: root.keyDetectionEnabled = !root.keyDetectionEnabled
                    onInfoClicked: root.activeInfoText = infoText
                }

                // Item 6: Alarm system (Chevron + Info)
                SettingRowChevron {
                    title: "Alarm system"
                    infoText: "Perimeter anti-theft sensors and interior motion intrusion monitoring."
                    onClicked: root.activeInfoText = infoText
                    onInfoClicked: root.activeInfoText = infoText
                }
            }

            // =================================================================
            // CATEGORY: SOUND
            // =================================================================
            Column {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                visible: root.activeCategory === "sound"
                spacing: 16

                SettingRowSlider {
                    title: "Treble"
                    value: 65
                }
                SettingRowSlider {
                    title: "Midrange"
                    value: 50
                }
                SettingRowSlider {
                    title: "Bass"
                    value: 75
                }
                SettingRowSwitch {
                    title: "Speed-compensated volume"
                    checked: true
                    infoText: "Adjusts audio volume automatically based on vehicle speed and road noise."
                    onInfoClicked: root.activeInfoText = infoText
                }
            }

            // =================================================================
            // CATEGORY: BLUETOOTH
            // =================================================================
            Column {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                visible: root.activeCategory === "bluetooth"
                spacing: 16

                SettingRowSwitch {
                    title: "Bluetooth Discovery"
                    checked: true
                    infoText: "Allows nearby smartphones to discover APEX VISION IVI."
                    onInfoClicked: root.activeInfoText = infoText
                }
                SettingRowChevron {
                    title: "Connected Devices (iPhone 15 Pro)"
                    infoText: "Manage paired Bluetooth audio and hands-free calling devices."
                    onInfoClicked: root.activeInfoText = infoText
                }
            }

            // =================================================================
            // CATEGORY: SYSTEM
            // =================================================================
            Column {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                visible: root.activeCategory === "system"
                spacing: 16

                SettingRowSlider {
                    title: "Display Brightness"
                    value: SystemBackend.brightness
                    onMovedVal: function(v) { SystemBackend.setBrightness(v) }
                }
                SettingRowSwitch {
                    title: "Automatic Software Updates"
                    checked: root.autoUpdatesEnabled
                    infoText: "Over-the-air firmware and digital cabin updates."
                    onToggled: root.autoUpdatesEnabled = !root.autoUpdatesEnabled
                    onInfoClicked: root.activeInfoText = infoText
                }
                SettingRowChevron {
                    title: "System Software Version: v1.0.0-PROD"
                    infoText: "APEX VISION IVI Automotive OS Build 2026."
                    onInfoClicked: root.activeInfoText = infoText
                }
            }

            // =================================================================
            // CATEGORY: PROFILE
            // =================================================================
            Column {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                visible: root.activeCategory === "profile"
                spacing: 0

                SettingRowChevron {
                    title: "Driver 1 (Active Profile)"
                    infoText: "Restores personalized seat positions, mirrors, climate and media presets."
                    onInfoClicked: root.activeInfoText = infoText
                }
                SettingRowChevron {
                    title: "Guest Profile"
                    infoText: "Temporary driving profile without modifying saved personal preferences."
                    onInfoClicked: root.activeInfoText = infoText
                }
            }
        }
    }
}

    // =========================================================================
    // REUSABLE ROW COMPONENTS (Radio, Switch, Chevron, Slider)
    // =========================================================================

    // Component 1: SettingRowRadio (Radio Button matching user reference photo)
    component SettingRowRadio: Item {
        id: radioRow
        property string title: ""
        property string subtitle: ""
        property bool selected: false
        property string infoText: ""
        signal selectedRequested()
        signal infoClicked()

        width: parent.width
        height: subtitle !== "" ? 72 : 62

        Column {
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            spacing: 4

            Text {
                text: radioRow.title
                font.family: "Inter"
                font.pixelSize: 20
                font.weight: Font.DemiBold
                color: "#FFFFFF"
            }

            Text {
                visible: radioRow.subtitle !== ""
                text: radioRow.subtitle
                font.family: "Inter"
                font.pixelSize: 14
                color: "#93C5FD"
            }
        }

        // Info (ⓘ) Icon Button
        Item {
            id: infoBtn
            width: 34
            height: 34
            anchors.right: parent.right
            anchors.rightMargin: 12
            anchors.verticalCenter: parent.verticalCenter

            Rectangle {
                anchors.fill: parent
                radius: 17
                color: infoMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.18) : "transparent"
                border.color: Qt.rgba(255, 255, 255, 0.50)
                border.width: 1.5

                Text {
                    anchors.centerIn: parent
                    text: "ⓘ"
                    font.family: "Inter"
                    font.pixelSize: 16
                    font.weight: Font.Bold
                    color: "#FFFFFF"
                }
            }

            MouseArea {
                id: infoMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: radioRow.infoClicked()
            }
        }

        // Radio Button (Amber when selected matching user photo)
        Item {
            anchors.right: infoBtn.left
            anchors.rightMargin: 28
            anchors.verticalCenter: parent.verticalCenter
            width: 28
            height: 28

            Rectangle {
                anchors.fill: parent
                radius: 14
                color: "transparent"
                border.color: radioRow.selected ? "#FB923C" : Qt.rgba(255, 255, 255, 0.50)
                border.width: 2.2
                Behavior on border.color { ColorAnimation { duration: 150 } }

                // Inner solid amber dot when selected
                Rectangle {
                    anchors.centerIn: parent
                    width: 14
                    height: 14
                    radius: 7
                    color: "#FB923C"
                    visible: radioRow.selected
                    opacity: radioRow.selected ? 1.0 : 0.0
                    scale: radioRow.selected ? 1.0 : 0.4
                    Behavior on scale { NumberAnimation { duration: 150; easing.type: Easing.OutBack } }
                    Behavior on opacity { NumberAnimation { duration: 150 } }
                }
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: radioRow.selectedRequested()
            }
        }

        MouseArea {
            anchors.fill: parent
            anchors.rightMargin: 80
            cursorShape: Qt.PointingHandCursor
            onClicked: radioRow.selectedRequested()
        }

        // Bottom hairline separator
        Rectangle {
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            height: 1
            color: Qt.rgba(255, 255, 255, 0.10)
        }
    }

    // Component 2: SettingRowSwitch (Amber Toggle Switch matching user photo)
    component SettingRowSwitch: Item {
        id: switchRow
        property string title: ""
        property string subtitle: ""
        property bool checked: false
        property string infoText: ""
        signal toggled()
        signal infoClicked()

        width: parent.width
        height: subtitle !== "" ? 72 : 62

        Column {
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            spacing: 4

            Text {
                text: switchRow.title
                font.family: "Inter"
                font.pixelSize: 20
                font.weight: Font.DemiBold
                color: "#FFFFFF"
            }

            Text {
                visible: switchRow.subtitle !== ""
                text: switchRow.subtitle
                font.family: "Inter"
                font.pixelSize: 14
                color: "#93C5FD"
            }
        }

        // Info (ⓘ) Icon Button
        Item {
            id: swInfoBtn
            width: 34
            height: 34
            anchors.right: parent.right
            anchors.rightMargin: 12
            anchors.verticalCenter: parent.verticalCenter

            Rectangle {
                anchors.fill: parent
                radius: 17
                color: swInfoMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.18) : "transparent"
                border.color: Qt.rgba(255, 255, 255, 0.50)
                border.width: 1.5

                Text {
                    anchors.centerIn: parent
                    text: "ⓘ"
                    font.family: "Inter"
                    font.pixelSize: 16
                    font.weight: Font.Bold
                    color: "#FFFFFF"
                }
            }

            MouseArea {
                id: swInfoMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: switchRow.infoClicked()
            }
        }

        // Toggle Switch (OEM Amber Track when active matching user photo)
        Rectangle {
            anchors.right: swInfoBtn.left
            anchors.rightMargin: 24
            anchors.verticalCenter: parent.verticalCenter
            width: 58
            height: 32
            radius: 16
            color: switchRow.checked ? "#FB923C" : Qt.rgba(255, 255, 255, 0.16)
            border.color: switchRow.checked ? "#F97316" : Qt.rgba(255, 255, 255, 0.30)
            border.width: 1
            Behavior on color { ColorAnimation { duration: 150 } }

            Rectangle {
                width: 26
                height: 26
                radius: 13
                color: "#FFFFFF"
                anchors.verticalCenter: parent.verticalCenter
                x: switchRow.checked ? parent.width - width - 3 : 3
                Behavior on x { NumberAnimation { duration: 180; easing.type: Easing.OutQuad } }
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: switchRow.toggled()
            }
        }

        // Bottom hairline separator
        Rectangle {
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            height: 1
            color: Qt.rgba(255, 255, 255, 0.10)
        }
    }

    // Component 3: SettingRowChevron
    component SettingRowChevron: Item {
        id: chevronRow
        property string title: ""
        property string subtitle: ""
        property string infoText: ""
        signal clicked()
        signal infoClicked()

        width: parent.width
        height: subtitle !== "" ? 72 : 62

        Column {
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            spacing: 4

            Text {
                text: chevronRow.title
                font.family: "Inter"
                font.pixelSize: 20
                font.weight: Font.DemiBold
                color: "#FFFFFF"
            }

            Text {
                visible: chevronRow.subtitle !== ""
                text: chevronRow.subtitle
                font.family: "Inter"
                font.pixelSize: 14
                color: "#93C5FD"
            }
        }

        // Info (ⓘ) Icon Button
        Item {
            id: chInfoBtn
            width: 34
            height: 34
            anchors.right: parent.right
            anchors.rightMargin: 12
            anchors.verticalCenter: parent.verticalCenter

            Rectangle {
                anchors.fill: parent
                radius: 17
                color: chInfoMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.18) : "transparent"
                border.color: Qt.rgba(255, 255, 255, 0.50)
                border.width: 1.5

                Text {
                    anchors.centerIn: parent
                    text: "ⓘ"
                    font.family: "Inter"
                    font.pixelSize: 16
                    font.weight: Font.Bold
                    color: "#FFFFFF"
                }
            }

            MouseArea {
                id: chInfoMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: chevronRow.infoClicked()
            }
        }

        // Chevron (>)
        Text {
            anchors.right: chInfoBtn.left
            anchors.rightMargin: 30
            anchors.verticalCenter: parent.verticalCenter
            text: "›"
            font.pixelSize: 28
            font.weight: Font.DemiBold
            color: "#CBD5E1"
        }

        MouseArea {
            anchors.fill: parent
            anchors.rightMargin: 80
            cursorShape: Qt.PointingHandCursor
            onClicked: chevronRow.clicked()
        }

        // Bottom hairline separator
        Rectangle {
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            height: 1
            color: Qt.rgba(255, 255, 255, 0.10)
        }
    }

    // Component 4: SettingRowSlider
    component SettingRowSlider: Item {
        id: sliderRow
        property string title: ""
        property real value: 50
        signal movedVal(real val)

        width: parent.width
        height: 62

        Row {
            anchors.fill: parent
            anchors.rightMargin: 20

            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: sliderRow.title
                font.family: "Inter"
                font.pixelSize: 20
                font.weight: Font.DemiBold
                color: "#FFFFFF"
                width: 220
            }

            Slider {
                anchors.verticalCenter: parent.verticalCenter
                width: 320
                from: 0
                to: 100
                value: sliderRow.value
                onMoved: sliderRow.movedVal(value)
            }
        }

        Rectangle {
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            height: 1
            color: Qt.rgba(255, 255, 255, 0.10)
        }
    }
}
