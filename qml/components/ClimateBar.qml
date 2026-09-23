import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import ApexVision
import ".."

Rectangle {
    id: root

    height: 72
    color: "#070A0F" // Deep automotive cockpit black, completely borderless and flush with bottom

    property bool driverSeatMenuOpen: false
    property bool passengerSeatMenuOpen: false
    property bool fanMenuOpen: false
    readonly property bool anyPopupOpen: driverSeatMenuOpen || passengerSeatMenuOpen || fanMenuOpen
    readonly property bool anySeatMenuOpen: driverSeatMenuOpen || passengerSeatMenuOpen

    // Background dismiss for popups when clicking empty areas of the climate bar
    MouseArea {
        anchors.fill: parent
        enabled: root.anyPopupOpen
        onClicked: {
            root.driverSeatMenuOpen = false;
            root.passengerSeatMenuOpen = false;
            root.fanMenuOpen = false;
        }
    }

    // Full-width horizontal strip matching user reference photo exactly
    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 20
        anchors.rightMargin: 20
        spacing: 0

        // =====================================================================
        // 1. DRIVER TEMPERATURE (< OFF > / < 21.5° >)
        // =====================================================================
        Item {
            Layout.preferredWidth: 120
            Layout.fillHeight: true
            opacity: root.anyPopupOpen ? 0.35 : 1.0
            Behavior on opacity { NumberAnimation { duration: 200 } }

            Row {
                anchors.centerIn: parent
                spacing: 10

                // Blue Left Chevron <
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: "‹"
                    color: "#38BDF8"
                    font.family: "Inter"
                    font.pixelSize: 24
                    font.bold: true
                    opacity: (!ClimateBackend.driverPower) ? 0.3 : (dDecMouse.pressed ? 0.5 : 1.0)
                    scale: dDecMouse.pressed ? 0.9 : 1.0

                    MouseArea {
                        id: dDecMouse
                        anchors.fill: parent
                        anchors.margins: -10
                        cursorShape: Qt.PointingHandCursor
                        onClicked: ClimateBackend.decreaseDriverTemperature()
                    }
                }

                // Temp / OFF text
                Text {
                    id: dTempText
                    anchors.verticalCenter: parent.verticalCenter
                    text: ClimateBackend.driverTemperatureDisplay
                    color: ClimateBackend.driverPower ? "#F8FAFC" : "#64748B"
                    font.family: "Inter"
                    font.pixelSize: 24
                    font.weight: Font.DemiBold
                    renderType: Text.NativeRendering

                    MouseArea {
                        anchors.fill: parent
                        anchors.margins: -8
                        cursorShape: Qt.PointingHandCursor
                        onClicked: ClimateBackend.toggleDriverPower()
                    }
                }

                // Red Right Chevron >
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: "›"
                    color: "#F87171"
                    font.family: "Inter"
                    font.pixelSize: 24
                    font.bold: true
                    opacity: dIncMouse.pressed ? 0.5 : 1.0
                    scale: dIncMouse.pressed ? 0.9 : 1.0

                    MouseArea {
                        id: dIncMouse
                        anchors.fill: parent
                        anchors.margins: -10
                        cursorShape: Qt.PointingHandCursor
                        onClicked: ClimateBackend.increaseDriverTemperature()
                    }
                }
            }
        }

        // =====================================================================
        // 2. DRIVER SEAT COMFORT & POPUP MENU (Lincoln Style)
        // =====================================================================
        Item {
            id: driverSeatContainer
            Layout.preferredWidth: 86
            Layout.fillHeight: true
            opacity: (root.passengerSeatMenuOpen || root.fanMenuOpen) ? 0.35 : 1.0
            Behavior on opacity { NumberAnimation { duration: 200 } }

            // Vertical 4-item popup dock menu (Comes OVER the icon, completely hiding it)
            Rectangle {
                id: driverSeatPopup
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 4
                anchors.horizontalCenter: parent.horizontalCenter
                width: 86
                height: 254
                radius: 18
                color: "#0C121E"
                border.color: Qt.rgba(255, 255, 255, 0.08)
                border.width: 1
                z: 100

                visible: opacity > 0
                opacity: root.driverSeatMenuOpen ? 1.0 : 0.0
                scale: root.driverSeatMenuOpen ? 1.0 : 0.92
                transformOrigin: Item.Bottom

                Behavior on opacity { NumberAnimation { duration: 180; easing.type: Easing.OutCubic } }
                Behavior on scale { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }

                Column {
                    anchors.fill: parent
                    anchors.margins: 4
                    spacing: 2

                    // 1. Steering Wheel Heating (At the TOP matching reference photo)
                    Item {
                        width: parent.width
                        height: 56

                        Rectangle {
                            anchors.fill: parent
                            radius: 12
                            color: steerMouse.pressed ? Qt.rgba(255, 255, 255, 0.08) : "transparent"
                        }

                        Row {
                            anchors.centerIn: parent
                            spacing: 8

                            Image {
                                width: 26
                                height: 26
                                fillMode: Image.PreserveAspectFit
                                source: "qrc:/ApexVision/qml/assets/icons/icon_steering_heat.png"
                                opacity: ClimateBackend.steeringHeat ? 1.0 : 0.45
                                anchors.verticalCenter: parent.verticalCenter
                            }

                            Rectangle {
                                width: 12
                                height: 2.5
                                radius: 1.25
                                anchors.verticalCenter: parent.verticalCenter
                                color: ClimateBackend.steeringHeat ? "#FFA500" : Qt.rgba(255, 255, 255, 0.25)
                            }
                        }

                        MouseArea {
                            id: steerMouse
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: ClimateBackend.toggleSteeringHeat()
                        }
                    }

                    // Separator line below steering wheel (does not touch border)
                    Item {
                        width: parent.width
                        height: 9

                        Rectangle {
                            anchors.centerIn: parent
                            width: parent.width - 24
                            height: 1
                            color: Qt.rgba(255, 255, 255, 0.15)
                        }
                    }

                    // 2. Auto Seat Comfort
                    Item {
                        width: parent.width
                        height: 56

                        Rectangle {
                            anchors.fill: parent
                            radius: 12
                            color: autoSeatMouse.pressed ? Qt.rgba(255, 255, 255, 0.08) : "transparent"
                        }

                        Row {
                            anchors.centerIn: parent
                            spacing: 8

                            Image {
                                width: 25
                                height: 25
                                fillMode: Image.PreserveAspectFit
                                source: "qrc:/ApexVision/qml/assets/icons/icon_seat_auto.png"
                                opacity: ClimateBackend.driverSeatAuto ? 1.0 : 0.45
                                anchors.verticalCenter: parent.verticalCenter
                            }

                            Rectangle {
                                width: 12
                                height: 2.5
                                radius: 1.25
                                anchors.verticalCenter: parent.verticalCenter
                                color: ClimateBackend.driverSeatAuto ? "#00D2FF" : Qt.rgba(255, 255, 255, 0.25)
                            }
                        }

                        MouseArea {
                            id: autoSeatMouse
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: ClimateBackend.toggleDriverSeatAuto()
                        }
                    }

                    // 3. Seat Ventilation (Blue Fan Seat facing left, 3 dashes on right)
                    Item {
                        width: parent.width
                        height: 56

                        Rectangle {
                            anchors.fill: parent
                            radius: 12
                            color: ventMouse.pressed ? Qt.rgba(255, 255, 255, 0.08) : "transparent"
                        }

                        Row {
                            anchors.centerIn: parent
                            spacing: 8

                            Image {
                                width: 26
                                height: 26
                                fillMode: Image.PreserveAspectFit
                                source: "qrc:/ApexVision/qml/assets/icons/icon_seat_vent.png"
                                opacity: ClimateBackend.driverSeatVentilation > 0 ? 1.0 : 0.45
                                anchors.verticalCenter: parent.verticalCenter
                            }

                            Column {
                                anchors.verticalCenter: parent.verticalCenter
                                spacing: 2
                                Repeater {
                                    model: 3
                                    Rectangle {
                                        width: 10
                                        height: 2.5
                                        radius: 1.25
                                        color: (ClimateBackend.driverSeatVentilation > (2 - index)) ?
                                               "#00D2FF" : Qt.rgba(255, 255, 255, 0.25)
                                    }
                                }
                            }
                        }

                        MouseArea {
                            id: ventMouse
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: ClimateBackend.cycleDriverSeatVent()
                        }
                    }

                    // 4. Seat Heating (Red Wavy Lines Seat facing left, 3 dashes on right)
                    Item {
                        width: parent.width
                        height: 56

                        Rectangle {
                            anchors.fill: parent
                            radius: 12
                            color: heatMouse.pressed ? Qt.rgba(255, 255, 255, 0.08) : "transparent"
                        }

                        Row {
                            anchors.centerIn: parent
                            spacing: 8

                            Image {
                                width: 26
                                height: 26
                                fillMode: Image.PreserveAspectFit
                                source: "qrc:/ApexVision/qml/assets/icons/icon_seat_heat.png"
                                opacity: ClimateBackend.driverSeatLevel > 0 ? 1.0 : 0.45
                                anchors.verticalCenter: parent.verticalCenter
                            }

                            Column {
                                anchors.verticalCenter: parent.verticalCenter
                                spacing: 2
                                Repeater {
                                    model: 3
                                    Rectangle {
                                        width: 10
                                        height: 2.5
                                        radius: 1.25
                                        color: (ClimateBackend.driverSeatLevel > (2 - index)) ?
                                               "#FF4444" : Qt.rgba(255, 255, 255, 0.25)
                                    }
                                }
                            }
                        }

                        MouseArea {
                            id: heatMouse
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: ClimateBackend.cycleDriverSeatLevel()
                        }
                    }
                }
            }

            // Bottom bar driver seat comfort button
            Item {
                id: driverSeatBtn
                anchors.centerIn: parent
                width: 60
                height: 44
                visible: !root.driverSeatMenuOpen

                Rectangle {
                    anchors.fill: parent
                    radius: 12
                    color: dSeatMouse.pressed ? Qt.rgba(255, 255, 255, 0.08) : "transparent"
                    Behavior on color { ColorAnimation { duration: 150 } }
                }

                Image {
                    anchors.centerIn: parent
                    width: 38
                    height: 24
                    fillMode: Image.PreserveAspectFit
                    source: "qrc:/ApexVision/qml/assets/icons/seat_comfort_icon.png"
                    opacity: 0.95
                }

                MouseArea {
                    id: dSeatMouse
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        root.passengerSeatMenuOpen = false;
                        root.fanMenuOpen = false;
                        root.driverSeatMenuOpen = true;
                    }
                }
            }
        }

        // Flexible proportional spacer
        Item { Layout.fillWidth: true; Layout.fillHeight: true }

        // =====================================================================
        // 3. FAN CONTROL (< 🪭 3 >) + POPUP SLIDER DOCK (Lincoln Style)
        // =====================================================================
        Item {
            id: fanControlItem
            Layout.preferredWidth: 136
            Layout.fillHeight: true
            opacity: (!ClimateBackend.driverPower) ? 0.35 : ((root.driverSeatMenuOpen || root.passengerSeatMenuOpen) ? 0.35 : 1.0)
            Behavior on opacity { NumberAnimation { duration: 200 } }

            // Vertical Fan Slider Popup Dock (Comes OVER the down fan logo, completely hiding it)
            Rectangle {
                id: fanPopup
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 4
                anchors.horizontalCenter: parent.horizontalCenter
                width: 96
                height: 350
                radius: 18
                color: "#0C121E"
                border.color: Qt.rgba(255, 255, 255, 0.08)
                border.width: 1
                z: 100

                visible: opacity > 0
                opacity: root.fanMenuOpen ? 1.0 : 0.0
                scale: root.fanMenuOpen ? 1.0 : 0.92
                transformOrigin: Item.Bottom

                Behavior on opacity { NumberAnimation { duration: 180; easing.type: Easing.OutCubic } }
                Behavior on scale { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }

                Column {
                    anchors.fill: parent
                    anchors.topMargin: 16
                    anchors.bottomMargin: 16
                    spacing: 0

                    // 1. Top Header: [fan icon]  [number]
                    Item {
                        width: parent.width
                        height: 38

                        Row {
                            anchors.centerIn: parent
                            spacing: ClimateBackend.fanSpeed > 0 ? 8 : 0

                            Image {
                                width: 26
                                height: 26
                                fillMode: Image.PreserveAspectFit
                                source: "qrc:/ApexVision/qml/assets/icons/icon_fan.png"
                                anchors.verticalCenter: parent.verticalCenter
                            }

                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                visible: ClimateBackend.fanSpeed > 0
                                text: ClimateBackend.fanSpeed > 0 ? ClimateBackend.fanSpeed.toString() : ""
                                color: "#FFFFFF"
                                font.family: "Inter"
                                font.pixelSize: 24
                                font.weight: Font.Bold
                                renderType: Text.NativeRendering
                            }
                        }
                    }

                    // Subtle separator line below header
                    Rectangle {
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: parent.width - 24
                        height: 1
                        color: Qt.rgba(255, 255, 255, 0.12)
                    }

                    // Spacer
                    Item { width: 1; height: 10 }

                    // 2. 7 Horizontal Level Bars (Level 7 at top to Level 1 at bottom)
                    Item {
                        id: fanSliderArea
                        width: parent.width
                        height: 252

                        Column {
                            anchors.fill: parent

                            Repeater {
                                model: 7 // index 0 (lvl 7) to 6 (lvl 1)
                                Item {
                                    id: levelItem
                                    property int lvl: 7 - index
                                    property bool isActive: ClimateBackend.fanSpeed === lvl
                                    width: fanSliderArea.width
                                    height: fanSliderArea.height / 7

                                    Rectangle {
                                        anchors.centerIn: parent
                                        width: levelItem.isActive ? 58 : 44
                                        height: levelItem.isActive ? 4 : 2
                                        radius: levelItem.isActive ? 2 : 1
                                        color: levelItem.isActive ? "#FFFFFF" : Qt.rgba(255, 255, 255, 0.28)

                                        Behavior on width { NumberAnimation { duration: 120 } }
                                        Behavior on height { NumberAnimation { duration: 120 } }
                                        Behavior on color { ColorAnimation { duration: 120 } }
                                    }
                                }
                            }
                        }

                        // Touch and Slide interactive MouseArea
                        MouseArea {
                            id: fanSliderMouse
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            preventStealing: true

                            function applySpeed(mouseY) {
                                var stepH = height / 7.0;
                                var idx = Math.floor(mouseY / stepH);
                                idx = Math.max(0, Math.min(6, idx));
                                var selectedLevel = 7 - idx;
                                ClimateBackend.setFanSpeed(selectedLevel);
                            }

                            onClicked: (mouse) => applySpeed(mouse.y)
                            onPositionChanged: (mouse) => {
                                if (pressed) {
                                    applySpeed(mouse.y);
                                }
                            }
                        }
                    }
                }
            }

            // Bottom bar fan control row: < [fan icon  number] >
            Row {
                anchors.centerIn: parent
                spacing: 8

                // Left Chevron < (Decreases fan speed 0-7)
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: "‹"
                    color: "#94A3B8"
                    font.family: "Inter"
                    font.pixelSize: 24
                    font.bold: true
                    opacity: fanDecM.pressed ? 0.5 : 1.0
                    scale: fanDecM.pressed ? 0.9 : 1.0

                    MouseArea {
                        id: fanDecM
                        anchors.fill: parent
                        anchors.margins: -10
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            if (ClimateBackend.fanSpeed > 0) {
                                ClimateBackend.decreaseFanSpeed();
                            }
                        }
                    }
                }

                // Middle interactive fan button: [fan icon]  [number on right]
                Item {
                    id: fanMidBtn
                    width: 68
                    height: 48
                    anchors.verticalCenter: parent.verticalCenter
                    visible: !root.fanMenuOpen

                    Rectangle {
                        anchors.fill: parent
                        radius: 12
                        color: fanMidMouse.pressed ? Qt.rgba(255, 255, 255, 0.08) : "transparent"
                        Behavior on color { ColorAnimation { duration: 150 } }
                    }

                    Row {
                        anchors.centerIn: parent
                        spacing: ClimateBackend.fanSpeed > 0 ? 6 : 0

                        Image {
                            width: 25
                            height: 25
                            fillMode: Image.PreserveAspectFit
                            source: "qrc:/ApexVision/qml/assets/icons/icon_fan.png"
                            opacity: ClimateBackend.fanSpeed > 0 ? 1.0 : 0.45
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            visible: ClimateBackend.fanSpeed > 0
                            text: ClimateBackend.fanSpeed > 0 ? ClimateBackend.fanSpeed.toString() : ""
                            color: "#F8FAFC"
                            font.family: "Inter"
                            font.pixelSize: 20
                            font.weight: Font.DemiBold
                            renderType: Text.NativeRendering
                        }
                    }

                    MouseArea {
                        id: fanMidMouse
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            root.driverSeatMenuOpen = false;
                            root.passengerSeatMenuOpen = false;
                            root.fanMenuOpen = true;
                        }
                    }
                }

                // Right Chevron > (Increases fan speed 1-7)
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: "›"
                    color: "#94A3B8"
                    font.family: "Inter"
                    font.pixelSize: 24
                    font.bold: true
                    opacity: fanIncM.pressed ? 0.5 : 1.0
                    scale: fanIncM.pressed ? 0.9 : 1.0

                    MouseArea {
                        id: fanIncM
                        anchors.fill: parent
                        anchors.margins: -10
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            if (ClimateBackend.fanSpeed < 7) {
                                ClimateBackend.increaseFanSpeed();
                            }
                        }
                    }
                }
            }
        }

        // =====================================================================
        // 4. AUTO BUTTON (AUTO with 3 yellow indicator dashes below)
        // =====================================================================
        Item {
            Layout.preferredWidth: 68
            Layout.fillHeight: true
            opacity: (!ClimateBackend.driverPower) ? 0.35 : (root.anyPopupOpen ? 0.35 : 1.0)
            Behavior on opacity { NumberAnimation { duration: 200 } }

            Item {
                anchors.centerIn: parent
                width: 58
                height: 50

                Column {
                    anchors.centerIn: parent
                    spacing: 4

                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "AUTO"
                        color: ClimateBackend.autoMode ? "#FFFFFF" : "#94A3B8"
                        font.family: "Inter"
                        font.pixelSize: 17
                        font.weight: Font.DemiBold
                        font.letterSpacing: 0.8
                    }

                    // 3 indicator dashes below AUTO - yellow light matching user reference
                    Row {
                        anchors.horizontalCenter: parent.horizontalCenter
                        spacing: 3.5

                        Repeater {
                            model: 3
                            Rectangle {
                                width: 8
                                height: 3
                                radius: 1.5
                                color: ClimateBackend.autoMode ? "#FFA044" : Qt.rgba(255, 255, 255, 0.2)
                            }
                        }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: ClimateBackend.toggleAuto()
                }
            }
        }

        // =====================================================================
        // 5. AIRFLOW MODE (Figure from image copy 3.png + custom up/down chevrons)
        // =====================================================================
        Item {
            id: airflowItem
            Layout.preferredWidth: 68
            Layout.fillHeight: true
            opacity: (!ClimateBackend.driverPower) ? 0.35 : (root.anyPopupOpen ? 0.35 : 1.0)
            Behavior on opacity { NumberAnimation { duration: 200 } }

            property bool active: false

            Item {
                anchors.centerIn: parent
                width: 58
                height: 50

                Column {
                    anchors.centerIn: parent
                    spacing: 2.5

                    // UP arrow when OFF (inactive)
                    Image {
                        visible: !airflowItem.active
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 26
                        height: 8
                        fillMode: Image.PreserveAspectFit
                        source: "qrc:/ApexVision/qml/assets/icons/chevron_up.svg"
                        opacity: 0.65
                    }

                    // Main Airflow seat figure from image copy 3.png
                    Image {
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 32
                        height: 28
                        fillMode: Image.PreserveAspectFit
                        source: "qrc:/ApexVision/qml/assets/icons/icon_airflow_seat.png"
                        opacity: airflowItem.active ? 1.0 : 0.75
                        Behavior on opacity { NumberAnimation { duration: 150 } }
                    }

                    // DOWN arrow when ON (activated)
                    Image {
                        visible: airflowItem.active
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 26
                        height: 8
                        fillMode: Image.PreserveAspectFit
                        source: "qrc:/ApexVision/qml/assets/icons/chevron_down.svg"
                        opacity: 1.0
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        airflowItem.active = !airflowItem.active;
                        ClimateBackend.cycleAirflowMode();
                    }
                }
            }
        }

        // =====================================================================
        // 6. MAX DEFROST (MAX on top of windshield icon + small yellow indicator line)
        // =====================================================================
        Item {
            Layout.preferredWidth: 68
            Layout.fillHeight: true
            opacity: (!ClimateBackend.driverPower) ? 0.35 : (root.anyPopupOpen ? 0.35 : 1.0)
            Behavior on opacity { NumberAnimation { duration: 200 } }

            Item {
                anchors.centerIn: parent
                width: 58
                height: 50

                Column {
                    anchors.centerIn: parent
                    spacing: 2

                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "MAX"
                        color: ClimateBackend.maxDefrostEnabled ? "#FFFFFF" : "#94A3B8"
                        font.family: "Inter"
                        font.pixelSize: 14
                        font.weight: Font.DemiBold
                        font.letterSpacing: 0.8
                    }

                    Image {
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 32
                        height: 24
                        fillMode: Image.PreserveAspectFit
                        source: "qrc:/ApexVision/qml/assets/icons/defrost_front.svg"
                        opacity: ClimateBackend.maxDefrostEnabled ? 1.0 : 0.55
                    }

                    // Smaller yellow indicator line when ON
                    Rectangle {
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 18
                        height: 3
                        radius: 1.5
                        color: "#FFA044"
                        opacity: ClimateBackend.maxDefrostEnabled ? 1.0 : 0.0
                        Behavior on opacity { NumberAnimation { duration: 150 } }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: ClimateBackend.toggleMaxDefrost()
                }
            }
        }

        // =====================================================================
        // 7. REAR DEFROST (Rear window rectangle + small yellow indicator line)
        // =====================================================================
        Item {
            Layout.preferredWidth: 68
            Layout.fillHeight: true
            opacity: (!ClimateBackend.driverPower) ? 0.35 : (root.anyPopupOpen ? 0.35 : 1.0)
            Behavior on opacity { NumberAnimation { duration: 200 } }

            Item {
                anchors.centerIn: parent
                width: 58
                height: 50

                Column {
                    anchors.centerIn: parent
                    spacing: 4

                    Image {
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 32
                        height: 25
                        fillMode: Image.PreserveAspectFit
                        source: "qrc:/ApexVision/qml/assets/icons/defrost_rear.svg"
                        opacity: ClimateBackend.rearDefrost ? 1.0 : 0.55
                    }

                    // Smaller yellow indicator line when ON
                    Rectangle {
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 18
                        height: 3
                        radius: 1.5
                        color: "#FFA044"
                        opacity: ClimateBackend.rearDefrost ? 1.0 : 0.0
                        Behavior on opacity { NumberAnimation { duration: 150 } }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: ClimateBackend.toggleRearDefrost()
                }
            }
        }

        // =====================================================================
        // 8. A/C BUTTON (A/C text + small yellow indicator line)
        // =====================================================================
        Item {
            Layout.preferredWidth: 68
            Layout.fillHeight: true
            opacity: (!ClimateBackend.driverPower) ? 0.35 : (root.anyPopupOpen ? 0.35 : 1.0)
            Behavior on opacity { NumberAnimation { duration: 200 } }

            Item {
                anchors.centerIn: parent
                width: 58
                height: 50

                Column {
                    anchors.centerIn: parent
                    spacing: 5

                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "A/C"
                        color: ClimateBackend.acEnabled ? "#FFFFFF" : "#94A3B8"
                        font.family: "Inter"
                        font.pixelSize: 17
                        font.weight: Font.DemiBold
                        font.letterSpacing: 0.8
                    }

                    // Smaller yellow indicator line when ON
                    Rectangle {
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 18
                        height: 3
                        radius: 1.5
                        color: "#FFA044"
                        opacity: ClimateBackend.acEnabled ? 1.0 : 0.0
                        Behavior on opacity { NumberAnimation { duration: 150 } }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: ClimateBackend.toggleAC()
                }
            }
        }

        // Flexible proportional spacer
        Item { Layout.fillWidth: true; Layout.fillHeight: true }

        // =====================================================================
        // 9. PASSENGER SEAT COMFORT & POPUP MENU
        // =====================================================================
        Item {
            id: passengerSeatContainer
            Layout.preferredWidth: 86
            Layout.fillHeight: true
            opacity: (root.driverSeatMenuOpen || root.fanMenuOpen) ? 0.35 : 1.0
            Behavior on opacity { NumberAnimation { duration: 200 } }

            // Vertical 3-item popup dock menu (Auto, Vent, Heat - comes OVER the icon)
            Rectangle {
                id: passengerSeatPopup
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 4
                anchors.horizontalCenter: parent.horizontalCenter
                width: 86
                height: 188
                radius: 18
                color: "#0C121E"
                border.color: Qt.rgba(255, 255, 255, 0.08)
                border.width: 1
                z: 100

                visible: opacity > 0
                opacity: root.passengerSeatMenuOpen ? 1.0 : 0.0
                scale: root.passengerSeatMenuOpen ? 1.0 : 0.92
                transformOrigin: Item.Bottom

                Behavior on opacity { NumberAnimation { duration: 180; easing.type: Easing.OutCubic } }
                Behavior on scale { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }

                Column {
                    anchors.fill: parent
                    anchors.margins: 4
                    spacing: 2

                    // 1. Auto Seat Comfort (Dash on LEFT, Seat on RIGHT facing right)
                    Item {
                        width: parent.width
                        height: 56

                        Rectangle {
                            anchors.fill: parent
                            radius: 12
                            color: pAutoMouse.pressed ? Qt.rgba(255, 255, 255, 0.08) : "transparent"
                        }

                        Row {
                            anchors.centerIn: parent
                            spacing: 8

                            Rectangle {
                                width: 12
                                height: 2.5
                                radius: 1.25
                                anchors.verticalCenter: parent.verticalCenter
                                color: ClimateBackend.passengerSeatAuto ? "#00D2FF" : Qt.rgba(255, 255, 255, 0.25)
                            }

                            Image {
                                width: 25
                                height: 25
                                fillMode: Image.PreserveAspectFit
                                source: "qrc:/ApexVision/qml/assets/icons/icon_seat_auto_passenger.png"
                                opacity: ClimateBackend.passengerSeatAuto ? 1.0 : 0.45
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }

                        MouseArea {
                            id: pAutoMouse
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: ClimateBackend.togglePassengerSeatAuto()
                        }
                    }

                    // 2. Seat Ventilation (3 dashes on LEFT, Blue Fan Seat on RIGHT facing right)
                    Item {
                        width: parent.width
                        height: 56

                        Rectangle {
                            anchors.fill: parent
                            radius: 12
                            color: pVentMouse.pressed ? Qt.rgba(255, 255, 255, 0.08) : "transparent"
                        }

                        Row {
                            anchors.centerIn: parent
                            spacing: 8

                            Column {
                                anchors.verticalCenter: parent.verticalCenter
                                spacing: 2
                                Repeater {
                                    model: 3
                                    Rectangle {
                                        width: 10
                                        height: 2.5
                                        radius: 1.25
                                        color: (ClimateBackend.passengerSeatVentilation > (2 - index)) ?
                                               "#00D2FF" : Qt.rgba(255, 255, 255, 0.25)
                                    }
                                }
                            }

                            Image {
                                width: 26
                                height: 26
                                fillMode: Image.PreserveAspectFit
                                source: "qrc:/ApexVision/qml/assets/icons/icon_seat_vent_blue_passenger.png"
                                opacity: ClimateBackend.passengerSeatVentilation > 0 ? 1.0 : 0.45
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }

                        MouseArea {
                            id: pVentMouse
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: ClimateBackend.cyclePassengerSeatVent()
                        }
                    }

                    // 3. Seat Heating (3 dashes on LEFT, Red Wavy Lines Seat on RIGHT facing right)
                    Item {
                        width: parent.width
                        height: 56

                        Rectangle {
                            anchors.fill: parent
                            radius: 12
                            color: pHeatMouse.pressed ? Qt.rgba(255, 255, 255, 0.08) : "transparent"
                        }

                        Row {
                            anchors.centerIn: parent
                            spacing: 8

                            Column {
                                anchors.verticalCenter: parent.verticalCenter
                                spacing: 2
                                Repeater {
                                    model: 3
                                    Rectangle {
                                        width: 10
                                        height: 2.5
                                        radius: 1.25
                                        color: (ClimateBackend.passengerSeatLevel > (2 - index)) ?
                                               "#FF4444" : Qt.rgba(255, 255, 255, 0.25)
                                    }
                                }
                            }

                            Image {
                                width: 26
                                height: 26
                                fillMode: Image.PreserveAspectFit
                                source: "qrc:/ApexVision/qml/assets/icons/icon_seat_heat_passenger.png"
                                opacity: ClimateBackend.passengerSeatLevel > 0 ? 1.0 : 0.45
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }

                        MouseArea {
                            id: pHeatMouse
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: ClimateBackend.cyclePassengerSeatLevel()
                        }
                    }
                }
            }

            // Bottom bar passenger seat comfort button
            Item {
                id: passengerSeatBtn
                anchors.centerIn: parent
                width: 60
                height: 44
                visible: !root.passengerSeatMenuOpen

                Rectangle {
                    anchors.fill: parent
                    radius: 12
                    color: pSeatMouse.pressed ? Qt.rgba(255, 255, 255, 0.08) : "transparent"
                    Behavior on color { ColorAnimation { duration: 150 } }
                }

                Image {
                    anchors.centerIn: parent
                    width: 36
                    height: 24
                    fillMode: Image.PreserveAspectFit
                    source: "qrc:/ApexVision/qml/assets/icons/icon_seat_vent_passenger.png"
                    opacity: 0.95
                }

                MouseArea {
                    id: pSeatMouse
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        root.driverSeatMenuOpen = false;
                        root.fanMenuOpen = false;
                        root.passengerSeatMenuOpen = true;
                    }
                }
            }
        }

        // =====================================================================
        // 10. PASSENGER TEMPERATURE (< OFF > / < 22.0° >)
        // =====================================================================
        Item {
            Layout.preferredWidth: 120
            Layout.fillHeight: true
            opacity: root.anyPopupOpen ? 0.35 : 1.0
            Behavior on opacity { NumberAnimation { duration: 200 } }

            Row {
                anchors.centerIn: parent
                spacing: 10

                // Blue Left Chevron <
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: "‹"
                    color: "#38BDF8"
                    font.family: "Inter"
                    font.pixelSize: 24
                    font.bold: true
                    opacity: (!ClimateBackend.passengerPower) ? 0.3 : (pDecMouse.pressed ? 0.5 : 1.0)
                    scale: pDecMouse.pressed ? 0.9 : 1.0

                    MouseArea {
                        id: pDecMouse
                        anchors.fill: parent
                        anchors.margins: -10
                        cursorShape: Qt.PointingHandCursor
                        onClicked: ClimateBackend.decreasePassengerTemperature()
                    }
                }

                // Temp / OFF text
                Text {
                    id: pTempText
                    anchors.verticalCenter: parent.verticalCenter
                    text: ClimateBackend.passengerTemperatureDisplay
                    color: ClimateBackend.passengerPower ? "#F8FAFC" : "#64748B"
                    font.family: "Inter"
                    font.pixelSize: 24
                    font.weight: Font.DemiBold
                    renderType: Text.NativeRendering

                    MouseArea {
                        anchors.fill: parent
                        anchors.margins: -8
                        cursorShape: Qt.PointingHandCursor
                        onClicked: ClimateBackend.togglePassengerPower()
                    }
                }

                // Red Right Chevron >
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: "›"
                    color: "#F87171"
                    font.family: "Inter"
                    font.pixelSize: 24
                    font.bold: true
                    opacity: pIncMouse.pressed ? 0.5 : 1.0
                    scale: pIncMouse.pressed ? 0.9 : 1.0

                    MouseArea {
                        id: pIncMouse
                        anchors.fill: parent
                        anchors.margins: -10
                        cursorShape: Qt.PointingHandCursor
                        onClicked: ClimateBackend.increasePassengerTemperature()
                    }
                }
            }
        }
    }
}
