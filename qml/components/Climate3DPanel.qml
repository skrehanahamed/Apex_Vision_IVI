import QtQuick
import ApexVision
import ".."

Item {
    id: root

    property bool isOpen: false
    property bool isRearView: false
    property bool airQualityMenuOpen: false

    onIsOpenChanged: {
        if (!isOpen && opacity <= 0.001) {
            airQualityMenuOpen = false;
        }
    }

    onOpacityChanged: {
        if (!isOpen && opacity <= 0.001 && airQualityMenuOpen) {
            airQualityMenuOpen = false;
        }
    }

    signal closeRequested()

    // Smooth pure fade in / fade out animation for the 3D cabin
    opacity: isOpen ? 1.0 : 0.0
    Behavior on opacity {
        NumberAnimation {
            duration: 350
            easing.type: Easing.InOutQuad
        }
    }

    // Remain visible during fade animation; disable input when closed
    visible: isOpen || opacity > 0.001
    enabled: isOpen

    // Solid dark automotive cockpit background (Clean, completely flat with no circle shapes)
    Rectangle {
        anchors.fill: parent
        color: "#040810"
        z: 0
    }

    // -------------------------------------------------------------------------
    // 3D Climate Cabin Content (Cabin 3D Loader, lateral vignettes, and OEM controls)
    // Completely hidden when airQualityMenuOpen is active so the 3D cabin never flashes
    // -------------------------------------------------------------------------
    Item {
        id: cabinContainer
        anchors.fill: parent
        visible: !root.airQualityMenuOpen
        opacity: (!root.airQualityMenuOpen && root.isOpen) ? 1.0 : 0.0

        Loader {
            id: cabinLoader
        anchors.fill: parent
        z: 1

        source: (typeof Climate3DViewUrl !== "undefined") ? Climate3DViewUrl : ""
        active: true

        onLoaded: {
            if (item) {
                item.isRearView = Qt.binding(() => root.isRearView);
                item.fanSpeed = Qt.binding(() => ClimateBackend.fanSpeed);
                item.temperature = Qt.binding(() => ClimateBackend.driverTemperature);
                item.acActive = Qt.binding(() => ClimateBackend.acEnabled);
                item.maxAcActive = Qt.binding(() => ClimateBackend.maxAcEnabled);
                item.maxDefrostActive = Qt.binding(() => ClimateBackend.maxDefrostEnabled);
                item.rearActive = Qt.binding(() => ClimateBackend.rearDefrost);
                item.faceVentsActive = Qt.binding(() => (ClimateBackend.airflowMode === 0 || ClimateBackend.airflowMode === 1));
                item.feetActive = Qt.binding(() => (ClimateBackend.airflowMode === 1 || ClimateBackend.airflowMode === 2 || ClimateBackend.airflowMode === 3));
                item.defrostActive = Qt.binding(() => (ClimateBackend.frontDefrost || ClimateBackend.maxDefrostEnabled));
                item.rearFanSpeed = Qt.binding(() => ClimateBackend.rearFanSpeed);
                item.rearPower = Qt.binding(() => ClimateBackend.rearPower);
                item.rearTemperature = Qt.binding(() => ClimateBackend.rearTemperature);
                item.rearAirflowMode = Qt.binding(() => ClimateBackend.rearAirflowMode);
                item.rearAutoMode = Qt.binding(() => ClimateBackend.rearAutoMode);
            }
        }
    }

    // -------------------------------------------------------------------------
    // Lateral Vignette Gradients (Soft sidewise fade of 3D model into cockpit)
    // -------------------------------------------------------------------------
    readonly property color bgBase: "#040810"

    // Left edge soft lateral fade into the sidebar
    Rectangle {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: 240
        z: 3
        enabled: false
        gradient: Gradient {
            orientation: Gradient.Horizontal
            GradientStop { position: 0.00; color: Qt.rgba(4/255, 8/255, 16/255, 1.0) }
            GradientStop { position: 0.30; color: Qt.rgba(4/255, 8/255, 16/255, 0.85) }
            GradientStop { position: 0.65; color: Qt.rgba(4/255, 8/255, 16/255, 0.40) }
            GradientStop { position: 1.00; color: Qt.rgba(4/255, 8/255, 16/255, 0.0) }
        }
    }

    // Right edge soft lateral fade
    Rectangle {
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: 240
        z: 3
        enabled: false
        gradient: Gradient {
            orientation: Gradient.Horizontal
            GradientStop { position: 0.00; color: Qt.rgba(4/255, 8/255, 16/255, 0.0) }
            GradientStop { position: 0.35; color: Qt.rgba(4/255, 8/255, 16/255, 0.40) }
            GradientStop { position: 0.70; color: Qt.rgba(4/255, 8/255, 16/255, 0.85) }
            GradientStop { position: 1.00; color: Qt.rgba(4/255, 8/255, 16/255, 1.0) }
        }
    }

    // Top edge soft fade under status bar
    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: 85
        z: 3
        enabled: false
        gradient: Gradient {
            orientation: Gradient.Vertical
            GradientStop { position: 0.0; color: Qt.rgba(4/255, 8/255, 16/255, 0.95) }
            GradientStop { position: 0.6; color: Qt.rgba(4/255, 8/255, 16/255, 0.40) }
            GradientStop { position: 1.0; color: Qt.rgba(4/255, 8/255, 16/255, 0.0) }
        }
    }

    // Bottom subtle soft fade into climate bar
    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: 45
        z: 3
        enabled: false
        gradient: Gradient {
            orientation: Gradient.Vertical
            GradientStop { position: 0.0; color: Qt.rgba(4/255, 8/255, 16/255, 0.0) }
            GradientStop { position: 1.0; color: Qt.rgba(4/255, 8/255, 16/255, 0.75) }
        }
    }

    // -------------------------------------------------------------------------
    // OEM Side Controls Overlay
    // Animates with a smooth fade and slide in from down to up
    // -------------------------------------------------------------------------
    Item {
        id: controlsOverlay
        anchors.fill: parent
        z: 10
        visible: (root.isOpen || root.opacity > 0.001)
        enabled: root.isOpen && !root.airQualityMenuOpen

        opacity: (root.isOpen && !root.airQualityMenuOpen) ? 1.0 : 0.0
        Behavior on opacity {
            NumberAnimation {
                duration: 280
                easing.type: Easing.InOutQuad
            }
        }

        transform: Translate {
            y: root.isOpen ? 0 : 28
            Behavior on y {
                NumberAnimation {
                    duration: 350
                    easing.type: Easing.OutCubic
                }
            }
        }



        // =====================================================================
        // Right Column: Air Recirculation, MAX A/C, Air Refresh (Front View Only)
        // =====================================================================
        Column {
            id: rightColumn
            anchors.right: parent.right
            anchors.rightMargin: 65
            anchors.top: parent.top
            anchors.topMargin: 125
            spacing: 34
            visible: opacity > 0.01
            opacity: !root.isRearView ? 1.0 : 0.0
            enabled: !root.isRearView

            Behavior on opacity {
                NumberAnimation { duration: 250; easing.type: Easing.InOutQuad }
            }

            // 1. Air Recirculation
            Item {
                width: 72
                height: 46
                anchors.horizontalCenter: parent.horizontalCenter

                Image {
                    anchors.centerIn: parent
                    source: "../assets/icons/icon_right_recirc.png"
                    width: 66
                    height: 38
                    fillMode: Image.PreserveAspectFit
                    opacity: ClimateBackend.recirculation ? 1.0 : 0.45
                    Behavior on opacity { NumberAnimation { duration: 150 } }
                }

                MouseArea {
                    id: recircMouse
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: ClimateBackend.toggleRecirculation()
                }
            }

            // 2. MAX A/C
            Item {
                width: 72
                height: 54
                anchors.horizontalCenter: parent.horizontalCenter

                Image {
                    anchors.centerIn: parent
                    source: "../assets/icons/icon_right_max_ac.png"
                    width: 62
                    height: 48
                    fillMode: Image.PreserveAspectFit
                    opacity: ClimateBackend.maxAcEnabled ? 1.0 : 0.45
                    Behavior on opacity { NumberAnimation { duration: 150 } }
                }

                MouseArea {
                    id: maxAcMouse
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: ClimateBackend.toggleMaxAC()
                }
            }

            // 3. Air Refresh (Air Quality System)
            Item {
                width: 82
                height: 52
                anchors.horizontalCenter: parent.horizontalCenter

                Row {
                    anchors.centerIn: parent
                    spacing: 6

                    Image {
                        source: "../assets/icons/icon_right_refresh.png"
                        width: 52
                        height: 38
                        fillMode: Image.PreserveAspectFit
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Text {
                        text: "›"
                        color: "#80C5FF"
                        font.pixelSize: 22
                        font.bold: true
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                MouseArea {
                    id: refreshMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        root.airQualityMenuOpen = true;
                    }
                }
            }
        }

        // =====================================================================
        // REAR CONTROLS GROUP (Dual Vertical Sliders & Cabin Floor Row Selector)
        // Only visible when in rear seat view (root.isRearView)
        // =====================================================================
        Item {
            id: rearControlsGroup
            anchors.fill: parent
            visible: opacity > 0.01
            opacity: root.isRearView ? 1.0 : 0.0
            enabled: root.isRearView

            Behavior on opacity {
                NumberAnimation { duration: 350; easing.type: Easing.InOutQuad }
            }

            // -----------------------------------------------------------------
            // Left Dual Vertical Sliders: Fan Speed + Temperature
            // -----------------------------------------------------------------
            Row {
                id: rearSlidersRow
                anchors.left: parent.left
                anchors.leftMargin: 46
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: -10
                spacing: 38

                // --- 1. Rear Fan Speed Slider Column ---
                Item {
                    id: fanSliderCol
                    width: 64
                    height: 380

                    // A. Header: Fan icon + speed number (or OFF)
                    Row {
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.top
                        spacing: 8
                        height: 36

                        Image {
                            anchors.verticalCenter: parent.verticalCenter
                            source: "qrc:/ApexVision/qml/assets/icons/icon_fan.png"
                            width: 26
                            height: 26
                            fillMode: Image.PreserveAspectFit
                            opacity: ClimateBackend.rearPower && ClimateBackend.rearFanSpeed > 0 ? 1.0 : 0.40
                        }

                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            text: (ClimateBackend.rearPower && ClimateBackend.rearFanSpeed > 0) ? ClimateBackend.rearFanSpeed.toString() : ""
                            color: "#FFFFFF"
                            font.family: "Inter"
                            font.pixelSize: 24
                            font.weight: Font.DemiBold
                        }
                    }

                    // B. Stepped Vertical Ladder Track (7 speed levels)
                    Item {
                        id: fanTrackItem
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.top
                        anchors.topMargin: 50
                        width: 44
                        height: 240

                        // Background ladder tick marks (7 steps)
                        Column {
                            anchors.centerIn: parent
                            spacing: 34

                            Repeater {
                                model: 7
                                Rectangle {
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    width: 26
                                    height: 2
                                    radius: 1
                                    color: Qt.rgba(255, 255, 255, 0.22)
                                }
                            }
                        }

                        // White Horizontal Pill Thumb indicator
                        Rectangle {
                            id: fanThumb
                            anchors.horizontalCenter: parent.horizontalCenter
                            width: 42
                            height: 6
                            radius: 3
                            color: "#FFFFFF"
                            visible: ClimateBackend.rearPower && ClimateBackend.rearFanSpeed > 0
                            y: {
                                const speed = Math.max(1, Math.min(7, ClimateBackend.rearFanSpeed));
                                return (parent.height - 12) - ((speed - 1) / 6.0) * (parent.height - 18);
                            }

                            Behavior on y {
                                NumberAnimation { duration: 160; easing.type: Easing.OutCubic }
                            }
                        }

                        // Interactive drag / click to set fan speed
                        MouseArea {
                            id: fanTrackMouse
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            preventStealing: true

                            function updateFanFromPos(mouseY) {
                                const clampedY = Math.max(0, Math.min(parent.height, mouseY));
                                const normalized = 1.0 - (clampedY / parent.height);
                                const speed = Math.max(1, Math.min(7, Math.round(1 + normalized * 6)));
                                ClimateBackend.setRearFanSpeed(speed);
                            }

                            onPressed: function(mouse) { updateFanFromPos(mouse.y); }
                            onPositionChanged: function(mouse) { if (pressed) updateFanFromPos(mouse.y); }
                        }
                    }

                    // C. Chevron Arrow Buttons underneath: [⌃ Up] and [⌄ Down]
                    Column {
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: fanTrackItem.bottom
                        anchors.topMargin: 14
                        spacing: 8

                        // Increase Fan Speed (⌃)
                        Item {
                            anchors.horizontalCenter: parent.horizontalCenter
                            width: 38
                            height: 28

                            Image {
                                anchors.centerIn: parent
                                source: "qrc:/ApexVision/qml/assets/icons/chevron_up.svg"
                                width: 20
                                height: 10
                                fillMode: Image.PreserveAspectFit
                                opacity: fanUpMouse.pressed ? 1.0 : (fanUpMouse.containsMouse ? 0.95 : 0.65)
                            }

                            MouseArea {
                                id: fanUpMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: ClimateBackend.increaseRearFanSpeed()
                            }

                            scale: fanUpMouse.pressed ? 0.88 : 1.0
                            Behavior on scale { NumberAnimation { duration: 100 } }
                        }

                        // Decrease Fan Speed (⌄)
                        Item {
                            anchors.horizontalCenter: parent.horizontalCenter
                            width: 38
                            height: 28

                            Image {
                                anchors.centerIn: parent
                                source: "qrc:/ApexVision/qml/assets/icons/chevron_down.svg"
                                width: 20
                                height: 10
                                fillMode: Image.PreserveAspectFit
                                opacity: fanDownMouse.pressed ? 1.0 : (fanDownMouse.containsMouse ? 0.95 : 0.65)
                            }

                            MouseArea {
                                id: fanDownMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: ClimateBackend.decreaseRearFanSpeed()
                            }

                            scale: fanDownMouse.pressed ? 0.88 : 1.0
                            Behavior on scale { NumberAnimation { duration: 100 } }
                        }
                    }
                }

                // --- 2. Rear Temperature Slider Column ---
                Item {
                    id: tempSliderCol
                    width: 78
                    height: 380

                    // A. Header: Temperature text ("22.0°" or "OFF") + red accent underline
                    Column {
                        id: tempHeader
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.top
                        spacing: 4
                        height: 36

                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: ClimateBackend.rearTemperatureDisplay
                            color: "#FFFFFF"
                            font.family: "Inter"
                            font.pixelSize: 24
                            font.weight: Font.DemiBold
                        }

                        // Signature red accent bar
                        Rectangle {
                            anchors.horizontalCenter: parent.horizontalCenter
                            width: 44
                            height: 2
                            radius: 1
                            color: "#FF4D4D"
                        }
                    }

                    // B. Vertical Ladder Track with fine ticks and blue accent bottom
                    Item {
                        id: tempTrackItem
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.top
                        anchors.topMargin: 50
                        width: 44
                        height: 240

                        // Fine horizontal tick marks running vertically
                        Column {
                            anchors.centerIn: parent
                            spacing: 6

                            Repeater {
                                model: 32
                                Rectangle {
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    width: (index % 4 === 0) ? 28 : 18
                                    height: 1.5
                                    radius: 0.75
                                    color: (index % 4 === 0) ? Qt.rgba(255, 255, 255, 0.28) : Qt.rgba(255, 255, 255, 0.14)
                                }
                            }
                        }

                        // Blue accent horizontal line at bottom
                        Rectangle {
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.bottom: parent.bottom
                            width: 44
                            height: 2
                            radius: 1
                            color: "#3BF0FF"
                        }

                        // White Horizontal Pill Thumb indicator
                        Rectangle {
                            id: tempThumb
                            anchors.horizontalCenter: parent.horizontalCenter
                            width: 42
                            height: 6
                            radius: 3
                            color: "#FFFFFF"
                            visible: ClimateBackend.rearPower
                            y: {
                                const t = Math.max(16.0, Math.min(28.0, ClimateBackend.rearTemperature));
                                return (parent.height - 10) - ((t - 16.0) / 12.0) * (parent.height - 14);
                            }

                            Behavior on y {
                                NumberAnimation { duration: 160; easing.type: Easing.OutCubic }
                            }
                        }

                        // Interactive drag / click to set temperature
                        MouseArea {
                            id: tempTrackMouse
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            preventStealing: true

                            function updateTempFromPos(mouseY) {
                                const clampedY = Math.max(0, Math.min(parent.height, mouseY));
                                const normalized = 1.0 - (clampedY / parent.height);
                                const rawTemp = 16.0 + normalized * 12.0;
                                const steppedTemp = Math.round(rawTemp * 2.0) / 2.0;
                                ClimateBackend.setRearTemperature(steppedTemp);
                            }

                            onPressed: function(mouse) { updateTempFromPos(mouse.y); }
                            onPositionChanged: function(mouse) { if (pressed) updateTempFromPos(mouse.y); }
                        }
                    }

                    // C. Chevron Arrow Buttons underneath: [⌃ Up] and [⌄ Down]
                    Column {
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: tempTrackItem.bottom
                        anchors.topMargin: 14
                        spacing: 8

                        // Increase Temperature (⌃)
                        Item {
                            anchors.horizontalCenter: parent.horizontalCenter
                            width: 38
                            height: 28

                            Image {
                                anchors.centerIn: parent
                                source: "qrc:/ApexVision/qml/assets/icons/chevron_up.svg"
                                width: 20
                                height: 10
                                fillMode: Image.PreserveAspectFit
                                opacity: tempUpMouse.pressed ? 1.0 : (tempUpMouse.containsMouse ? 0.95 : 0.65)
                            }

                            MouseArea {
                                id: tempUpMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: ClimateBackend.increaseRearTemperature()
                            }

                            scale: tempUpMouse.pressed ? 0.88 : 1.0
                            Behavior on scale { NumberAnimation { duration: 100 } }
                        }

                        // Decrease Temperature (⌄)
                        Item {
                            anchors.horizontalCenter: parent.horizontalCenter
                            width: 38
                            height: 28

                            Image {
                                anchors.centerIn: parent
                                source: "qrc:/ApexVision/qml/assets/icons/chevron_down.svg"
                                width: 20
                                height: 10
                                fillMode: Image.PreserveAspectFit
                                opacity: tempDownMouse.pressed ? 1.0 : (tempDownMouse.containsMouse ? 0.95 : 0.65)
                            }

                            MouseArea {
                                id: tempDownMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: ClimateBackend.decreaseRearTemperature()
                            }

                            scale: tempDownMouse.pressed ? 0.88 : 1.0
                            Behavior on scale { NumberAnimation { duration: 100 } }
                        }
                    }
                }
            }

        }

        // =====================================================================
        // Seat View Switcher (Borderless minimal automotive typography & arrows)
        // Lower: "Rear" + down arrow (to glide back into rear seat)
        // Up side: up arrow + "Front" (to glide forward into front cockpit)
        // =====================================================================

        // 1. Lower Button: "Rear" with down arrow underneath
        Item {
            id: lowerRearBtn
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 20
            width: 80
            height: 44
            visible: opacity > 0.01
            opacity: !root.isRearView ? 1.0 : 0.0
            enabled: !root.isRearView

            Behavior on opacity {
                NumberAnimation { duration: 400; easing.type: Easing.InOutQuad }
            }

            transform: Translate {
                y: !root.isRearView ? 0 : 12
                Behavior on y {
                    NumberAnimation { duration: 400; easing.type: Easing.OutCubic }
                }
            }

            Column {
                anchors.centerIn: parent
                spacing: 3

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Rear"
                    color: lowerRearMouse.pressed ? "#3BF0FF" : (lowerRearMouse.containsMouse ? "#FFFFFF" : Qt.rgba(255, 255, 255, 0.85))
                    font.family: "Inter"
                    font.pixelSize: 14
                    font.weight: Font.DemiBold
                    font.letterSpacing: 0.6
                }

                Image {
                    anchors.horizontalCenter: parent.horizontalCenter
                    source: "qrc:/ApexVision/qml/assets/icons/chevron_down.svg"
                    width: 16
                    height: 6
                    fillMode: Image.PreserveAspectFit
                    opacity: lowerRearMouse.pressed ? 1.0 : (lowerRearMouse.containsMouse ? 1.0 : 0.75)
                }
            }

            MouseArea {
                id: lowerRearMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: root.isRearView = true
            }

            scale: lowerRearMouse.pressed ? 0.92 : 1.0
            Behavior on scale { NumberAnimation { duration: 120 } }
        }

        // 2. Up Side Button: up arrow above "Front" text
        Item {
            id: upperFrontBtn
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 20
            width: 80
            height: 44
            visible: opacity > 0.01
            opacity: root.isRearView ? 1.0 : 0.0
            enabled: root.isRearView

            Behavior on opacity {
                NumberAnimation { duration: 400; easing.type: Easing.InOutQuad }
            }

            transform: Translate {
                y: root.isRearView ? 0 : -12
                Behavior on y {
                    NumberAnimation { duration: 400; easing.type: Easing.OutCubic }
                }
            }

            Column {
                anchors.centerIn: parent
                spacing: 3

                Image {
                    anchors.horizontalCenter: parent.horizontalCenter
                    source: "qrc:/ApexVision/qml/assets/icons/chevron_up.svg"
                    width: 16
                    height: 6
                    fillMode: Image.PreserveAspectFit
                    opacity: upperFrontMouse.pressed ? 1.0 : (upperFrontMouse.containsMouse ? 1.0 : 0.75)
                }

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Front"
                    color: upperFrontMouse.pressed ? "#3BF0FF" : (upperFrontMouse.containsMouse ? "#FFFFFF" : Qt.rgba(255, 255, 255, 0.85))
                    font.family: "Inter"
                    font.pixelSize: 14
                    font.weight: Font.DemiBold
                    font.letterSpacing: 0.6
                }
            }

            MouseArea {
                id: upperFrontMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: root.isRearView = false
            }

            scale: upperFrontMouse.pressed ? 0.92 : 1.0
            Behavior on scale { NumberAnimation { duration: 120 } }
        }
    }
    }

    // =========================================================================
    // AIR QUALITY & CABIN AIR REFRESH OVERLAY (Modal from "write under MAX A/C")
    // =========================================================================
    CabinAirRefreshOverlay {
        id: airQualityOverlay
        anchors.fill: parent
        z: 100
        visible: opacity > 0.001
        opacity: root.airQualityMenuOpen ? 1.0 : 0.0
        enabled: root.airQualityMenuOpen

        Behavior on opacity {
            NumberAnimation {
                duration: 280
                easing.type: Easing.OutCubic
            }
        }

        transform: Scale {
            origin.x: airQualityOverlay.width * 0.9
            origin.y: airQualityOverlay.height * 0.35
            xScale: root.airQualityMenuOpen ? 1.0 : 0.96
            yScale: root.airQualityMenuOpen ? 1.0 : 0.96
            Behavior on xScale { NumberAnimation { duration: 300; easing.type: Easing.OutCubic } }
            Behavior on yScale { NumberAnimation { duration: 300; easing.type: Easing.OutCubic } }
        }

        onCloseRequested: {
            root.closeRequested();
        }
    }
}
