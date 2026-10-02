/**
 * ==============================================================================
 * Project: Apex VISION IVI - Digital Cockpit & Infotainment System
 * File: VehiclePage.qml
 * Author / Developer: Sk Rehan Ahamed
 * License: MIT
 * ==============================================================================
 */

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import ApexVision

Item {
    id: root
    objectName: "vehiclePage"

    // =========================================================================
    // =========================================================================
    // Background: Shines through from Master default background in Main.qml
    // =========================================================================

    // =========================================================================
    property bool ambientLightingPageOpen: false
    property bool vehicleStatusPageOpen: false
    property string vehicleStatusTab: "tire" // "tire" | "oil"
    property bool seatsPageOpen: false
    property string seatsActiveTarget: "driver" // "driver" | "passenger"
    property string seatsSubMenu: "second_row" // "second_row" | "passenger" | "adjust_massage"
    property bool inSeatsStudio: false // false: Level 1 Cabin Overview, true: Level 2 Studio View
    property string seatStudioTab: "seat" // "seat" | "massage" (Default strictly to "seat")
    property bool valetModePageOpen: false
    property int valetStep: 1 // 1: Info Screen (matching reference image), 2: PIN Setup
    property string valetPin: "1234"
    property string enteredPin: ""
    property string tempPin: ""
    property bool pinConfirmStep: false
    property string valetErrorMessage: ""
    property bool isValetLocked: false

    property real rearLeftSlide: 0.0
    property real rearRightSlide: 0.0
    property real frontPassSlide: 0.0

    signal openSettingsRequested()

    function resetToInitialScreen() {
        ambientLightingPageOpen = false;
        vehicleStatusPageOpen = false;
        seatsPageOpen = false;
        inSeatsStudio = false;
        massageActive = false;
        seatsSubMenu = "second_row";
        valetModePageOpen = false;
        valetStep = 1;
        enteredPin = "";
        tempPin = "";
        pinConfirmStep = false;
        valetErrorMessage = "";
    }

    function handleKeypadInput(val) {
        valetErrorMessage = "";
        if (val === "clear") {
            enteredPin = "";
        } else if (val === "back") {
            if (enteredPin.length > 0) {
                enteredPin = enteredPin.substring(0, enteredPin.length - 1);
            }
        } else {
            if (enteredPin.length < 4) {
                enteredPin += val;
                if (enteredPin.length === 4) {
                    if (!pinConfirmStep) {
                        tempPin = enteredPin;
                        pinConfirmTimer.start();
                    } else {
                        if (enteredPin === tempPin) {
                            valetPin = enteredPin;
                            VehicleBackend.setValetMode(true);
                            isValetLocked = true;
                            valetModePageOpen = false;
                            valetStep = 1;
                            enteredPin = "";
                            tempPin = "";
                            pinConfirmStep = false;
                        } else {
                            valetErrorMessage = "PINs do not match. Please try again.";
                            pinMismatchTimer.start();
                        }
                    }
                }
            }
        }
    }

    Timer {
        id: pinConfirmTimer
        interval: 220
        repeat: false
        onTriggered: {
            root.enteredPin = "";
            root.pinConfirmStep = true;
        }
    }

    Timer {
        id: pinMismatchTimer
        interval: 700
        repeat: false
        onTriggered: {
            root.enteredPin = "";
            root.tempPin = "";
            root.pinConfirmStep = false;
        }
    }

    onSeatsPageOpenChanged: {
        if (seatsPageOpen) {
            if (!seatsSubMenu || seatsSubMenu === "") {
                seatsSubMenu = "second_row";
            }
        }
    }

    // Driver & Passenger Contour Levels (1 to 10):
    // 3 in Lumbar: "lumbar_upper" | "lumbar_mid" | "lumbar_lower"
    // 2 in Cushion: "cushion_left" | "cushion_right"
    property string seatActiveZone: "lumbar_mid"
    property int driverLumbarUpperVal: 5
    property int passengerLumbarUpperVal: 5
    property int driverLumbarMidVal: 5
    property int passengerLumbarMidVal: 5
    property int driverLumbarLowerVal: 5
    property int passengerLumbarLowerVal: 5
    property int driverCushionLeftVal: 5
    property int passengerCushionLeftVal: 5
    property int driverCushionRightVal: 5
    property int passengerCushionRightVal: 5

    function getCurrentZoneTitle() {
        switch (seatActiveZone) {
            case "lumbar_upper": return "Upper Lumbar";
            case "lumbar_mid": return "Mid Lumbar";
            case "lumbar_lower": return "Lower Lumbar";
            case "cushion_left": return "Left Cushion";
            case "cushion_right": return "Right Cushion";
            default: return "Seat Adjustment";
        }
    }

    // Helper getter for active zone value
    function getCurrentZoneVal() {
        var isDriver = (seatsActiveTarget === "driver");
        switch (seatActiveZone) {
            case "lumbar_upper": return isDriver ? driverLumbarUpperVal : passengerLumbarUpperVal;
            case "lumbar_mid": return isDriver ? driverLumbarMidVal : passengerLumbarMidVal;
            case "lumbar_lower": return isDriver ? driverLumbarLowerVal : passengerLumbarLowerVal;
            case "cushion_left": return isDriver ? driverCushionLeftVal : passengerCushionLeftVal;
            case "cushion_right": return isDriver ? driverCushionRightVal : passengerCushionRightVal;
            default: return isDriver ? driverLumbarMidVal : passengerLumbarMidVal;
        }
    }

    function adjustCurrentZoneVal(delta) {
        var isDriver = (seatsActiveTarget === "driver");
        switch (seatActiveZone) {
            case "lumbar_upper":
                if (isDriver) driverLumbarUpperVal = Math.max(1, Math.min(10, driverLumbarUpperVal + delta));
                else passengerLumbarUpperVal = Math.max(1, Math.min(10, passengerLumbarUpperVal + delta));
                break;
            case "lumbar_mid":
                if (isDriver) driverLumbarMidVal = Math.max(1, Math.min(10, driverLumbarMidVal + delta));
                else passengerLumbarMidVal = Math.max(1, Math.min(10, passengerLumbarMidVal + delta));
                break;
            case "lumbar_lower":
                if (isDriver) driverLumbarLowerVal = Math.max(1, Math.min(10, driverLumbarLowerVal + delta));
                else passengerLumbarLowerVal = Math.max(1, Math.min(10, passengerLumbarLowerVal + delta));
                break;
            case "cushion_left":
                if (isDriver) driverCushionLeftVal = Math.max(1, Math.min(10, driverCushionLeftVal + delta));
                else passengerCushionLeftVal = Math.max(1, Math.min(10, passengerCushionLeftVal + delta));
                break;
            case "cushion_right":
                if (isDriver) driverCushionRightVal = Math.max(1, Math.min(10, driverCushionRightVal + delta));
                else passengerCushionRightVal = Math.max(1, Math.min(10, passengerCushionRightVal + delta));
                break;
        }
    }

    // Multi-Contour Massage Settings
    property string massageProgram: "relax" // "circular" | "relax" | "recovery" | "rolling" | "pulse"
    property bool massageActive: false
    property int massageIntensity: 2 // 1, 2, 3


    readonly property var ambientColors: [
        { name: "Polar White", hex: "#DCE3EB" },
        { name: "Sky Blue", hex: "#70C5F5" },
        { name: "Apex Amber", hex: "#F5A623" },
        { name: "Emerald Green", hex: "#2ECC71" },
        { name: "Electric Cyan", hex: "#00D2FF" },
        { name: "Luxe Violet", hex: "#A855F7" },
        { name: "Coral Red", hex: "#E74C3C" }
    ]

    // =========================================================================
    // LEFT MENU / AMBIENT CONTROLS CONTAINER (Fixed 500px, identical to vehicle menu bounds)
    // =========================================================================
    Item {
        id: menuContainer
        anchors.left: parent.left
        anchors.leftMargin: 44
        anchors.top: parent.top
        anchors.topMargin: 36
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 36
        width: 500
        z: 10

        // Main Vehicle Overview 2x3 Grid (When Ambient Lighting screen is closed)
        Grid {
            id: menuGrid
            width: 500
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: -12
            columns: 2
            spacing: 16
            x: (root.ambientLightingPageOpen || root.vehicleStatusPageOpen || root.seatsPageOpen || root.valetModePageOpen) ? -36 : 0
            opacity: (!root.ambientLightingPageOpen && !root.vehicleStatusPageOpen && !root.seatsPageOpen && !root.valetModePageOpen) ? 1.0 : 0.0
            visible: opacity > 0.001
            enabled: !root.ambientLightingPageOpen && !root.vehicleStatusPageOpen && !root.seatsPageOpen && !root.valetModePageOpen
            Behavior on x { NumberAnimation { duration: 300; easing.type: Easing.OutCubic } }
            Behavior on opacity { NumberAnimation { duration: 300; easing.type: Easing.OutCubic } }

            // Card 1: Ambient Lighting (Navigation card to open ambient lighting screen)
            VehicleMenuCard {
                width: 242
                height: 124
                iconSource: "qrc:/ApexVision/qml/assets/icons/icon_ambient_lighting.png"
                titleText: "Ambient Lighting"
                isActive: false
                showActiveDot: false
                onCardClicked: {
                    root.ambientLightingPageOpen = true;
                }
            }

            // Card 2: Auto Hold (When active: yellow border and yellow dot)
            VehicleMenuCard {
                width: 242
                height: 124
                iconSource: VehicleBackend.autoHold ?
                    "qrc:/ApexVision/qml/assets/icons/icon_auto_hold_amber.png" :
                    "qrc:/ApexVision/qml/assets/icons/icon_auto_hold.png"
                titleText: "Auto Hold"
                isActive: VehicleBackend.autoHold
                showActiveDot: true
                activeDotColor: "#F59E0B"
                hasActiveBorder: true
                activeBorderColor: "#F59E0B"
                onCardClicked: VehicleBackend.toggleAutoHold()
            }

            // Card 3: Seats
            VehicleMenuCard {
                width: 242
                height: 124
                iconSource: "qrc:/ApexVision/qml/assets/icons/icon_seats.png"
                titleText: "Seats"
                isActive: false
                onCardClicked: {
                    root.seatsPageOpen = true;
                    root.inSeatsStudio = false;
                    root.seatsSubMenu = "second_row";
                    root.seatStudioTab = "seat";
                }
            }

            // Card 4: Valet mode
            VehicleMenuCard {
                width: 242
                height: 124
                iconSource: "qrc:/ApexVision/qml/assets/icons/icon_valet_mode.png"
                titleText: "Valet mode"
                isActive: VehicleBackend.valetMode
                showActiveDot: VehicleBackend.valetMode
                activeDotColor: "#F59E0B"
                onCardClicked: {
                    root.valetModePageOpen = true;
                    root.valetStep = 1;
                    root.enteredPin = "";
                    root.tempPin = "";
                    root.pinConfirmStep = false;
                    root.valetErrorMessage = "";
                }
            }

            // Card 5: Vehicle status
            VehicleMenuCard {
                width: 242
                height: 124
                iconSource: "qrc:/ApexVision/qml/assets/icons/icon_vehicle_status.png"
                titleText: "Vehicle status"
                isActive: false
                onCardClicked: {
                    root.vehicleStatusPageOpen = true;
                    root.vehicleStatusTab = "tire";
                }
            }

            // Card 6: Settings
            VehicleMenuCard {
                width: 242
                height: 124
                iconSource: "qrc:/ApexVision/qml/assets/icons/icon_vehicle_settings.png"
                titleText: "Settings"
                isActive: false
                onCardClicked: {
                    root.openSettingsRequested();
                }
            }
        }

        // Dedicated Ambient Lighting Panel (Takes exactly left bounds of the screen)
        Item {
            id: ambientControlsContainer
            width: parent.width
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            x: root.ambientLightingPageOpen ? 0 : 36
            opacity: root.ambientLightingPageOpen ? 1.0 : 0.0
            visible: opacity > 0.001
            enabled: root.ambientLightingPageOpen
            Behavior on x { NumberAnimation { duration: 300; easing.type: Easing.OutCubic } }
            Behavior on opacity { NumberAnimation { duration: 300; easing.type: Easing.OutCubic } }

            // Top Header: Back button + Title
            Row {
                id: ambientHeaderRow
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.topMargin: 8
                spacing: 16

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
                        onClicked: root.ambientLightingPageOpen = false
                    }
                }

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: "Ambient Lighting"
                    font.family: "Inter"
                    font.pixelSize: 24
                    font.weight: Font.DemiBold
                    color: "#FFFFFF"
                }
            }

            // Controls Body: 2-Column Palette + Small Straight Line + Vertical Brightness Slider
            Item {
                id: ambientContentArea
                anchors.left: parent.left
                anchors.leftMargin: 8
                anchors.right: parent.right
                anchors.top: ambientHeaderRow.bottom
                anchors.topMargin: 30
                anchors.bottom: parent.bottom

                // Color Palette Grid (2 Columns x 4 Rows - Original full proportions)
                Grid {
                    id: colorsGrid
                    columns: 2
                    spacing: 16
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter

                    Repeater {
                        model: root.ambientColors

                        delegate: Rectangle {
                            id: colorPill
                            width: 114
                            height: 60
                            radius: 14
                            color: modelData.hex

                            readonly property bool isSelected: VehicleBackend.ambientColor.toLowerCase() === modelData.hex.toLowerCase()

                            // Matching user's photo: Active pill has dark rounded border, others are borderless
                            border.color: isSelected ?
                                (VehicleBackend.ambientLighting ? "#0B1522" : Qt.rgba(11/255, 21/255, 34/255, 0.40)) :
                                "transparent"
                            border.width: isSelected ? 2.5 : 0
                            Behavior on border.color { ColorAnimation { duration: 150 } }

                            opacity: VehicleBackend.ambientLighting ?
                                1.0 :
                                (isSelected ? 0.75 : 0.40)
                            Behavior on opacity { NumberAnimation { duration: 180 } }

                            scale: pillMouse.pressed ? 0.94 : (pillMouse.containsMouse ? 1.03 : 1.0)
                            Behavior on scale { NumberAnimation { duration: 120 } }

                            // Power Logo shifts to whichever color circle/pill is pressed!
                            Item {
                                id: powerLogoItem
                                anchors.centerIn: parent
                                width: 26
                                height: 26
                                visible: isSelected

                                // Outer ring with gap at top
                                Rectangle {
                                    anchors.centerIn: parent
                                    width: 22
                                    height: 22
                                    radius: 11
                                    color: "transparent"
                                    border.color: (isSelected && VehicleBackend.ambientLighting) ?
                                        "#0B1522" :
                                        Qt.rgba(11/255, 21/255, 34/255, 0.45)
                                    border.width: 2.2

                                    // Notch cutout matching pill color
                                    Rectangle {
                                        anchors.top: parent.top
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        anchors.topMargin: -1
                                        width: 8
                                        height: 4
                                        color: colorPill.color
                                    }
                                }

                                // Center top vertical bar
                                Rectangle {
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    anchors.top: parent.top
                                    anchors.topMargin: 2
                                    width: 2.2
                                    height: 10
                                    radius: 1.1
                                    color: (isSelected && VehicleBackend.ambientLighting) ?
                                        "#0B1522" :
                                        Qt.rgba(11/255, 21/255, 34/255, 0.45)
                                }
                            }

                            MouseArea {
                                id: pillMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    if (isSelected) {
                                        // Pressing the active circle with the power logo toggles ambient light on/off
                                        VehicleBackend.toggleAmbientLighting();
                                    } else {
                                        // Pressing another circle shifts the logo here and activates this color
                                        VehicleBackend.setAmbientColor(modelData.hex);
                                        if (!VehicleBackend.ambientLighting) {
                                            VehicleBackend.setAmbientLighting(true);
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                // Small Straight Line (Sleek short vertical separator centered between colors and slider)
                Rectangle {
                    id: verticalSeparator
                    anchors.verticalCenter: parent.verticalCenter
                    x: colorsGrid.x + colorsGrid.width + 68
                    width: 1
                    height: 120
                    color: Qt.rgba(255, 255, 255, 0.10)
                }

                // Vertical Brightness Slider (Original full dragger size, positioned closer to 3D car model)
                Item {
                    id: sliderColumn
                    width: 48
                    height: 288
                    anchors.verticalCenter: parent.verticalCenter
                    x: verticalSeparator.x + 85

                    // Sun / Brightness Icon from SVG asset
                    Image {
                        id: sunIcon
                        anchors.top: parent.top
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 24
                        height: 24
                        source: "qrc:/ApexVision/qml/assets/icons/icon_brightness.svg"
                        sourceSize: Qt.size(24, 24)
                        fillMode: Image.PreserveAspectFit
                        opacity: VehicleBackend.ambientLighting ? 1.0 : 0.45
                    }

                    // Track Area
                    Item {
                        id: trackContainer
                        anchors.top: sunIcon.bottom
                        anchors.topMargin: 18
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 8
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 36

                        // Inactive / Base Track Groove
                        Rectangle {
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.top: parent.top
                            anchors.bottom: parent.bottom
                            width: 5
                            radius: 2.5
                            color: Qt.rgba(255, 255, 255, 0.14)
                        }

                        // Active Colored Fill (Always warm peach-coral gradient, regardless of selected ambient color!)
                        Rectangle {
                            id: activeTrackFill
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.bottom: parent.bottom
                            width: 5
                            height: parent.height * (VehicleBackend.ambientLighting ? VehicleBackend.ambientBrightness : 0.0)
                            radius: 2.5
                            gradient: Gradient {
                                GradientStop { position: 0.0; color: "#FFA77E" } // Warm peach at top
                                GradientStop { position: 1.0; color: "#FF5E36" } // Rich coral-orange at bottom
                            }
                            Behavior on height { NumberAnimation { duration: 60 } }
                        }

                        // 4 Subtle Tick Dots along the Track
                        Repeater {
                            model: 4
                            Rectangle {
                                anchors.horizontalCenter: parent.horizontalCenter
                                y: (trackContainer.height - 3) * ((index + 1) / 5.0)
                                width: 3
                                height: 3
                                radius: 1.5
                                color: "#161B26"
                                z: 2
                            }
                        }

                        // Circular Thumb Ring (Original size hollow ring with warm peach-coral border, same color for all colors!)
                        Rectangle {
                            id: thumbRing
                            anchors.horizontalCenter: parent.horizontalCenter
                            y: (trackContainer.height - height) * (1.0 - (VehicleBackend.ambientLighting ? VehicleBackend.ambientBrightness : 0.0))
                            width: 24
                            height: 24
                            radius: 12
                            color: "#080E18"
                            border.color: VehicleBackend.ambientLighting ? "#FFA77E" : Qt.rgba(255, 255, 255, 0.40)
                            border.width: 2.4
                            z: 3
                            Behavior on y {
                                enabled: !sliderMouseArea.pressed
                                NumberAnimation { duration: 60 }
                            }
                        }

                        MouseArea {
                            id: sliderMouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor

                            function applyVal(my) {
                                var clamped = Math.max(0, Math.min(trackContainer.height, my));
                                var val = 1.0 - (clamped / trackContainer.height);
                                VehicleBackend.setAmbientBrightness(val);
                                if (!VehicleBackend.ambientLighting && val > 0.02) {
                                    VehicleBackend.setAmbientLighting(true);
                                }
                            }

                            onPressed: function(mouse) {
                                applyVal(mouse.y);
                            }

                            onPositionChanged: function(mouse) {
                                if (pressed) {
                                    applyVal(mouse.y);
                                }
                            }
                        }
                    }
                }
            }
        }

        // Dedicated Vehicle Status Panel (Matching reference images)
        Item {
            id: vehicleStatusControlsContainer
            width: parent.width
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            x: root.vehicleStatusPageOpen ? 0 : 36
            opacity: root.vehicleStatusPageOpen ? 1.0 : 0.0
            visible: opacity > 0.001
            enabled: root.vehicleStatusPageOpen
            Behavior on x { NumberAnimation { duration: 300; easing.type: Easing.OutCubic } }
            Behavior on opacity { NumberAnimation { duration: 300; easing.type: Easing.OutCubic } }

            // Top Header: Back button + Title
            Row {
                id: statusHeaderRow
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.topMargin: 8
                spacing: 16

                Item {
                    width: 36
                    height: 36
                    anchors.verticalCenter: parent.verticalCenter

                    Text {
                        anchors.centerIn: parent
                        text: "←"
                        font.pixelSize: 26
                        font.weight: Font.DemiBold
                        color: statusBackMouseArea.pressed ? "#94A3B8" : (statusBackMouseArea.containsMouse ? "#FFFFFF" : "#E2E8F0")
                    }

                    MouseArea {
                        id: statusBackMouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.vehicleStatusPageOpen = false
                    }
                }

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: "Vehicle status"
                    font.family: "Inter"
                    font.pixelSize: 24
                    font.weight: Font.DemiBold
                    color: "#FFFFFF"
                }
            }

            // Left Navigation Cards Column (Tire pressure & Oil life) - Full 500px width aligned with ambient & overview menus
            Column {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: statusHeaderRow.bottom
                anchors.topMargin: 36
                spacing: 16
                width: parent.width

                // Tab 1: Tire pressure Card
                Rectangle {
                    width: parent.width
                    height: 104
                    radius: 18
                    clip: true

                    // Ultra-Light Frosted Glass Fill
                    gradient: Gradient {
                        GradientStop {
                            position: 0.0
                            color: tireMouseArea.pressed ?
                                Qt.rgba(215/255, 238/255, 255/255, 0.32) :
                                (tireMouseArea.containsMouse ? Qt.rgba(225/255, 242/255, 255/255, 0.24) :
                                (root.vehicleStatusTab === "tire" ? Qt.rgba(225/255, 242/255, 255/255, 0.22) : Qt.rgba(215/255, 238/255, 255/255, 0.16)))
                        }
                        GradientStop {
                            position: 1.0
                            color: tireMouseArea.pressed ?
                                Qt.rgba(195/255, 225/255, 255/255, 0.26) :
                                (tireMouseArea.containsMouse ? Qt.rgba(205/255, 232/255, 255/255, 0.18) :
                                (root.vehicleStatusTab === "tire" ? Qt.rgba(205/255, 232/255, 255/255, 0.16) : Qt.rgba(195/255, 225/255, 255/255, 0.10)))
                        }
                    }

                    // Border: active amber when selected, luminous light glass when unselected
                    border.color: (root.vehicleStatusTab === "tire") ?
                        "#F59E0B" :
                        (tireMouseArea.containsMouse ? Qt.rgba(255, 255, 255, 0.65) : Qt.rgba(225/255, 242/255, 255/255, 0.36))
                    border.width: (root.vehicleStatusTab === "tire") ? 2 : 1

                    Behavior on border.color { ColorAnimation { duration: 180 } }

                    scale: tireMouseArea.pressed ? 0.98 : (tireMouseArea.containsMouse ? 1.01 : 1.0)
                    Behavior on scale { NumberAnimation { duration: 150; easing.type: Easing.OutQuad } }

                    // Top Specular Glass Reflection
                    Rectangle {
                        anchors.top: parent.top
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.topMargin: 1
                        anchors.leftMargin: 20
                        anchors.rightMargin: 20
                        height: 1
                        color: (root.vehicleStatusTab === "tire") ?
                            Qt.rgba(245/255, 158/255, 11/255, 0.50) :
                            (tireMouseArea.containsMouse ? Qt.rgba(255, 255, 255, 0.60) : Qt.rgba(255, 255, 255, 0.35))
                        radius: 1
                    }

                    Row {
                        anchors.fill: parent
                        anchors.leftMargin: 24
                        anchors.rightMargin: 24
                        spacing: 20

                        // Glowing Tire Pressure Icon: Yellow glow when selected, Blue/cyan glow when unselected
                        Image {
                            anchors.verticalCenter: parent.verticalCenter
                            width: 38
                            height: 38
                            source: (root.vehicleStatusTab === "tire") ?
                                "qrc:/ApexVision/qml/assets/icons/icon_tire_pressure_amber.png" :
                                "qrc:/ApexVision/qml/assets/icons/icon_tire_pressure_blue.png"
                            sourceSize: Qt.size(76, 76)
                            fillMode: Image.PreserveAspectFit
                            smooth: true
                            mipmap: true
                        }

                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            text: "Tire pressure"
                            font.family: "Inter"
                            font.pixelSize: 22
                            font.weight: (root.vehicleStatusTab === "tire") ? Font.DemiBold : Font.Normal
                            color: "#FFFFFF"
                        }
                    }

                    MouseArea {
                        id: tireMouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.vehicleStatusTab = "tire"
                    }
                }

                // Tab 2: Oil life Card
                Rectangle {
                    width: parent.width
                    height: 104
                    radius: 18
                    clip: true

                    // Ultra-Light Frosted Glass Fill
                    gradient: Gradient {
                        GradientStop {
                            position: 0.0
                            color: oilMouseArea.pressed ?
                                Qt.rgba(215/255, 238/255, 255/255, 0.32) :
                                (oilMouseArea.containsMouse ? Qt.rgba(225/255, 242/255, 255/255, 0.24) :
                                (root.vehicleStatusTab === "oil" ? Qt.rgba(225/255, 242/255, 255/255, 0.22) : Qt.rgba(215/255, 238/255, 255/255, 0.16)))
                        }
                        GradientStop {
                            position: 1.0
                            color: oilMouseArea.pressed ?
                                Qt.rgba(195/255, 225/255, 255/255, 0.26) :
                                (oilMouseArea.containsMouse ? Qt.rgba(205/255, 232/255, 255/255, 0.18) :
                                (root.vehicleStatusTab === "oil" ? Qt.rgba(205/255, 232/255, 255/255, 0.16) : Qt.rgba(195/255, 225/255, 255/255, 0.10)))
                        }
                    }

                    // Border: active amber when selected, luminous light glass when unselected
                    border.color: (root.vehicleStatusTab === "oil") ?
                        "#F59E0B" :
                        (oilMouseArea.containsMouse ? Qt.rgba(255, 255, 255, 0.65) : Qt.rgba(225/255, 242/255, 255/255, 0.36))
                    border.width: (root.vehicleStatusTab === "oil") ? 2 : 1

                    Behavior on border.color { ColorAnimation { duration: 180 } }

                    scale: oilMouseArea.pressed ? 0.98 : (oilMouseArea.containsMouse ? 1.01 : 1.0)
                    Behavior on scale { NumberAnimation { duration: 150; easing.type: Easing.OutQuad } }

                    // Top Specular Glass Reflection
                    Rectangle {
                        anchors.top: parent.top
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.topMargin: 1
                        anchors.leftMargin: 20
                        anchors.rightMargin: 20
                        height: 1
                        color: (root.vehicleStatusTab === "oil") ?
                            Qt.rgba(245/255, 158/255, 11/255, 0.50) :
                            (oilMouseArea.containsMouse ? Qt.rgba(255, 255, 255, 0.60) : Qt.rgba(255, 255, 255, 0.35))
                        radius: 1
                    }

                    Row {
                        anchors.fill: parent
                        anchors.leftMargin: 24
                        anchors.rightMargin: 24
                        spacing: 20

                        // Glowing Oil Life Icon: Yellow glow when selected, Blue/cyan glow when unselected
                        Image {
                            anchors.verticalCenter: parent.verticalCenter
                            width: 38
                            height: 38
                            source: (root.vehicleStatusTab === "oil") ?
                                "qrc:/ApexVision/qml/assets/icons/icon_oil_life_amber.png" :
                                "qrc:/ApexVision/qml/assets/icons/icon_oil_life_blue.png"
                            sourceSize: Qt.size(76, 76)
                            fillMode: Image.PreserveAspectFit
                            smooth: true
                            mipmap: true
                        }

                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            text: "Oil life"
                            font.family: "Inter"
                            font.pixelSize: 22
                            font.weight: (root.vehicleStatusTab === "oil") ? Font.DemiBold : Font.Normal
                            color: "#FFFFFF"
                        }
                    }

                    MouseArea {
                        id: oilMouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.vehicleStatusTab = "oil"
                    }
                }
            }
        }
    }

    // =========================================================================
    // 3D Vehicle Studio (Right Half with Free 360 Orbit & Top-Down Cabin Mode)
    // =========================================================================
    Loader {
        id: studioLoader
        anchors.fill: parent
        clip: false
        z: 1
        visible: opacity > 0.001
        opacity: (root.seatsPageOpen || root.valetModePageOpen) ? 0.0 : 1.0
        Behavior on opacity { NumberAnimation { duration: 300; easing.type: Easing.OutCubic } }

        source: (typeof VehicleStudioViewUrl !== "undefined") ? VehicleStudioViewUrl : ""
        active: true

        onLoaded: {
            if (item) {
                item.anchors.fill = studioLoader;
                item.width = Qt.binding(() => studioLoader.width);
                item.height = Qt.binding(() => studioLoader.height);
                item.lightsOn = Qt.binding(() => VehicleBackend.headlights);
                item.ambientMode = Qt.binding(() => root.ambientLightingPageOpen);
                item.ambientColor = Qt.binding(() => VehicleBackend.ambientColor);
                item.ambientBrightness = Qt.binding(() => VehicleBackend.ambientBrightness);
                item.ambientOn = Qt.binding(() => VehicleBackend.ambientLighting);
                item.statusMode = Qt.binding(() => root.vehicleStatusPageOpen);
                item.statusTab = Qt.binding(() => root.vehicleStatusTab);
            }
        }
    }



    // 3D Model is locked in fixed hero pose per user request (no dragging or zoom controls)

    // =========================================================================
    // Floating Trunk Button (Bottom-Right under 3D car, matching reference)
    // =========================================================================
    Item {
        id: trunkButtonContainer
        anchors.right: parent.right
        anchors.rightMargin: 120
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 55
        width: 64
        height: 64
        z: 10
        visible: opacity > 0.01
        opacity: (root.ambientLightingPageOpen || root.vehicleStatusPageOpen || root.seatsPageOpen || root.valetModePageOpen) ? 0.0 : 1.0
        Behavior on opacity { NumberAnimation { duration: 250 } }

        Rectangle {
            id: trunkBtnBg
            anchors.fill: parent
            radius: 32
            clip: true

            gradient: Gradient {
                GradientStop {
                    position: 0.0
                    color: trunkMouseArea.pressed ?
                        Qt.rgba(215/255, 238/255, 255/255, 0.32) :
                        (trunkMouseArea.containsMouse ? Qt.rgba(225/255, 242/255, 255/255, 0.24) :
                        (VehicleBackend.trunkOpen ? Qt.rgba(225/255, 242/255, 255/255, 0.22) : Qt.rgba(215/255, 238/255, 255/255, 0.16)))
                }
                GradientStop {
                    position: 1.0
                    color: trunkMouseArea.pressed ?
                        Qt.rgba(195/255, 225/255, 255/255, 0.26) :
                        (trunkMouseArea.containsMouse ? Qt.rgba(205/255, 232/255, 255/255, 0.18) :
                        (VehicleBackend.trunkOpen ? Qt.rgba(205/255, 232/255, 255/255, 0.16) : Qt.rgba(195/255, 225/255, 255/255, 0.10)))
                }
            }

            border.color: VehicleBackend.trunkOpen ?
                "#00D2FF" :
                (trunkMouseArea.containsMouse ? Qt.rgba(255, 255, 255, 0.65) : Qt.rgba(225/255, 242/255, 255/255, 0.36))
            border.width: VehicleBackend.trunkOpen ? 2 : 1

            Behavior on border.color { ColorAnimation { duration: 180 } }

            scale: trunkMouseArea.pressed ? 0.94 : (trunkMouseArea.containsMouse ? 1.05 : 1.0)
            Behavior on scale { NumberAnimation { duration: 150; easing.type: Easing.OutQuad } }

            // Trunk Car Outline Icon (Pasted SUV model)
            Image {
                anchors.centerIn: parent
                width: 36
                height: 36
                source: "qrc:/ApexVision/qml/assets/icons/icon_trunk_suv.png"
                sourceSize: Qt.size(72, 72)
                fillMode: Image.PreserveAspectFit
                smooth: true
                mipmap: true
            }

            MouseArea {
                id: trunkMouseArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: VehicleBackend.toggleTrunk()
            }
        }
    }

    // =========================================================================
    // Vehicle Status 3D Readout Overlay (Tire Pressures & Oil Life)
    // Dynamic Entrance Animation: Smooth slide-in, fade, and rolling number counter
    // =========================================================================
    Item {
        id: vehicleStatusDisplayOverlay
        anchors.fill: parent
        z: 15
        visible: opacity > 0.001
        opacity: root.vehicleStatusPageOpen ? 1.0 : 0.0
        Behavior on opacity { NumberAnimation { duration: 300; easing.type: Easing.OutCubic } }
        enabled: root.vehicleStatusPageOpen

        // Entrance animation properties for Tire Pressure
        property real tireSlideOffset: 32.0   // starts offset, animates to 0
        property real tireReadoutOpacity: 0.0 // starts 0.0, animates to 1.0
        property real countFL: 1.0
        property real countFR: 1.0
        property real countRL: 1.0
        property real countRR: 1.0

        // Entrance animation properties for Oil Life
        property real oilSlideOffset: -24.0
        property real oilReadoutOpacity: 0.0
        property real countOil: 1.0

        NumberAnimation {
            id: tireSlideAnim
            target: vehicleStatusDisplayOverlay
            property: "tireSlideOffset"
            from: 32.0
            to: 0.0
            duration: 600
            easing.type: Easing.OutCubic
        }

        NumberAnimation {
            id: tireFadeAnim
            target: vehicleStatusDisplayOverlay
            property: "tireReadoutOpacity"
            from: 0.0
            to: 1.0
            duration: 500
            easing.type: Easing.OutCubic
        }

        NumberAnimation {
            id: tireAnimFL
            target: vehicleStatusDisplayOverlay
            property: "countFL"
            from: 1.0
            to: VehicleBackend.tirePressureFL
            duration: 750
            easing.type: Easing.OutCubic
        }

        NumberAnimation {
            id: tireAnimFR
            target: vehicleStatusDisplayOverlay
            property: "countFR"
            from: 1.0
            to: VehicleBackend.tirePressureFR
            duration: 750
            easing.type: Easing.OutCubic
        }

        NumberAnimation {
            id: tireAnimRL
            target: vehicleStatusDisplayOverlay
            property: "countRL"
            from: 1.0
            to: VehicleBackend.tirePressureRL
            duration: 820
            easing.type: Easing.OutCubic
        }

        NumberAnimation {
            id: tireAnimRR
            target: vehicleStatusDisplayOverlay
            property: "countRR"
            from: 1.0
            to: VehicleBackend.tirePressureRR
            duration: 820
            easing.type: Easing.OutCubic
        }

        NumberAnimation {
            id: oilSlideAnim
            target: vehicleStatusDisplayOverlay
            property: "oilSlideOffset"
            from: -24.0
            to: 0.0
            duration: 550
            easing.type: Easing.OutCubic
        }

        NumberAnimation {
            id: oilFadeAnim
            target: vehicleStatusDisplayOverlay
            property: "oilReadoutOpacity"
            from: 0.0
            to: 1.0
            duration: 450
            easing.type: Easing.OutCubic
        }

        NumberAnimation {
            id: oilCountAnim
            target: vehicleStatusDisplayOverlay
            property: "countOil"
            from: 1.0
            to: VehicleBackend.oilLife
            duration: 780
            easing.type: Easing.OutCubic
        }

        Timer {
            id: entranceDelayTimer
            interval: 420 // synchronized with the smooth 680ms 3D car flight
            repeat: false
            onTriggered: {
                if (root.vehicleStatusTab === "tire") {
                    tireSlideAnim.restart();
                    tireFadeAnim.restart();
                    tireAnimFL.restart();
                    tireAnimFR.restart();
                    tireAnimRL.restart();
                    tireAnimRR.restart();
                } else {
                    oilSlideAnim.restart();
                    oilFadeAnim.restart();
                    oilCountAnim.restart();
                }
            }
        }

        function triggerEntrance() {
            entranceDelayTimer.stop();
            tireSlideAnim.stop();
            tireFadeAnim.stop();
            tireAnimFL.stop();
            tireAnimFR.stop();
            tireAnimRL.stop();
            tireAnimRR.stop();
            oilSlideAnim.stop();
            oilFadeAnim.stop();
            oilCountAnim.stop();

            tireSlideOffset = 32.0;
            tireReadoutOpacity = 0.0;
            countFL = 1.0;
            countFR = 1.0;
            countRL = 1.0;
            countRR = 1.0;

            oilSlideOffset = -24.0;
            oilReadoutOpacity = 0.0;
            countOil = 1.0;

            if (root.vehicleStatusPageOpen) {
                entranceDelayTimer.restart();
            }
        }

        Connections {
            target: root
            function onVehicleStatusPageOpenChanged() {
                vehicleStatusDisplayOverlay.triggerEntrance();
            }
            function onVehicleStatusTabChanged() {
                vehicleStatusDisplayOverlay.triggerEntrance();
            }
        }

        Component.onCompleted: {
            if (root.vehicleStatusPageOpen) {
                vehicleStatusDisplayOverlay.triggerEntrance();
            }
        }

        // =====================================================================
        // OIL LIFE DISPLAY (100% Oil life remaining above front hood)
        // =====================================================================
        Column {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.horizontalCenterOffset: 240
            anchors.top: parent.top
            anchors.topMargin: 80 + vehicleStatusDisplayOverlay.oilSlideOffset
            spacing: 8
            visible: opacity > 0.001
            opacity: (root.vehicleStatusTab === "oil") ? vehicleStatusDisplayOverlay.oilReadoutOpacity : 0.0

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: Math.round(vehicleStatusDisplayOverlay.countOil) + "%"
                font.family: "Inter"
                font.pixelSize: 48
                font.weight: Font.Bold
                color: "#FFFFFF"
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Oil life remaining"
                font.family: "Inter"
                font.pixelSize: 16
                font.weight: Font.Medium
                color: "#CBD5E1"
            }
        }

        // =====================================================================
        // TIRE PRESSURE DISPLAY (4 Tire Readouts + Bottom Recommendation)
        // =====================================================================
        Item {
            id: tireDisplayItem
            anchors.fill: parent
            visible: opacity > 0.001
            opacity: (root.vehicleStatusTab === "tire") ? 1.0 : 0.0

            // =================================================================
            // 🎯 TIRE CALLOUT POSITION & OFFSET TUNING CONTROLS
            // Change these numbers directly to adjust position of numbers and lines!
            // =================================================================
            // 🎯 TIRE PRESSURE CONTROLS & X/Y AXIS SETTINGS
            // =================================================================
            // 🔘 OPTION TO REMOVE / HIDE THE WHOLE SET (4 Texts & Lines):
            // Set this to false to completely hide all 4 tire numbers and lines!
            property bool showTireNumbersAndLines: true

            // 🔘 OPTION TO REMOVE / HIDE THE BOTTOM SUMMARY TEXT:
            property bool showBottomSummary: true

            // 🎛️ MASTER GROUP SHIFT (Moves all 4 tires together):
            property real tireGroupX: 0        // Increase = shift entire set RIGHT, Decrease = shift LEFT
            property real tireGroupY: 0        // Increase = shift entire set DOWN, Decrease = shift UP

            // 📍 INDIVIDUAL X & Y AXIS CONTROLS FOR EACH TIRE:
            // --- FRONT LEFT (FL) "35 —" (Object_21) ---
            property real tireFL_X: 18         // X position: shifted further left away from 3D model
            property real tireFL_Y: -140       // Y position: moved down to align directly with front wheel

            // --- FRONT RIGHT (FR) "— 35" (Object_9) ---
            property real tireFR_X: 495        // X position: symmetrical spacing on right side
            property real tireFR_Y: -140       // Y position: moved down to align directly with front wheel

            // --- REAR LEFT (RL) "41 —" (Object_29) ---
            property real tireRL_X: -32        // X position: shifted further left away from rear panel
            property real tireRL_Y: 72         // Y position: aligned to rear axle

            // --- REAR RIGHT (RR) "— 41" (Object_10) ---
            property real tireRR_X: 520        // X position: symmetrical spacing on right side
            property real tireRR_Y: 72         // Y position: aligned to rear axle

            // 📏 LINE & TEXT STYLING:
            property real tireLineWidth: 46    // Length of the dash line
            property real tireLineHeight: 2.5  // Thickness of the dash line
            property real tireSpacing: 14      // Distance between number and line

            // 📝 BOTTOM SUMMARY POSITION ("psi", "Recommended cold pressure", "Front 33 Rear 40"):
            property real bottomSummaryX: 275  // Center horizontal position under car
            property real bottomSummaryY: 255  // Vertical position below rear diffuser

            // =================================================================
            // 4 TIRE NUMBERS AND LINES CONTAINER
            // (Controlled by showTireNumbersAndLines)
            // =================================================================
            Item {
                id: tireNumbersAndLinesContainer
                anchors.fill: parent
                visible: tireDisplayItem.showTireNumbersAndLines

                // -----------------------------------------------------------------
                // Front Left Tire: 35 — (Object_21 FL axle)
                // -----------------------------------------------------------------
                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.horizontalCenterOffset: tireDisplayItem.tireFL_X + tireDisplayItem.tireGroupX - vehicleStatusDisplayOverlay.tireSlideOffset
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.verticalCenterOffset: tireDisplayItem.tireFL_Y + tireDisplayItem.tireGroupY
                    spacing: tireDisplayItem.tireSpacing
                    opacity: vehicleStatusDisplayOverlay.tireReadoutOpacity

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: "" + Math.round(vehicleStatusDisplayOverlay.countFL)
                        font.family: "Inter"
                        font.pixelSize: 32
                        font.weight: Font.Bold
                        color: "#FFFFFF"
                    }

                    Rectangle {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.verticalCenterOffset: -2
                        width: tireDisplayItem.tireLineWidth
                        height: tireDisplayItem.tireLineHeight
                        radius: tireDisplayItem.tireLineHeight * 0.5
                        color: "#FFFFFF"
                    }
                }

                // -----------------------------------------------------------------
                // Front Right Tire: — 35 (Object_9 FR axle)
                // -----------------------------------------------------------------
                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.horizontalCenterOffset: tireDisplayItem.tireFR_X + tireDisplayItem.tireGroupX + vehicleStatusDisplayOverlay.tireSlideOffset
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.verticalCenterOffset: tireDisplayItem.tireFR_Y + tireDisplayItem.tireGroupY
                    spacing: tireDisplayItem.tireSpacing
                    opacity: vehicleStatusDisplayOverlay.tireReadoutOpacity

                    Rectangle {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.verticalCenterOffset: -2
                        width: tireDisplayItem.tireLineWidth
                        height: tireDisplayItem.tireLineHeight
                        radius: tireDisplayItem.tireLineHeight * 0.5
                        color: "#FFFFFF"
                    }

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: "" + Math.round(vehicleStatusDisplayOverlay.countFR)
                        font.family: "Inter"
                        font.pixelSize: 32
                        font.weight: Font.Bold
                        color: "#FFFFFF"
                    }
                }

                // -----------------------------------------------------------------
                // Rear Left Tire: 41 — (Object_29 RL axle)
                // -----------------------------------------------------------------
                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.horizontalCenterOffset: tireDisplayItem.tireRL_X + tireDisplayItem.tireGroupX - vehicleStatusDisplayOverlay.tireSlideOffset
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.verticalCenterOffset: tireDisplayItem.tireRL_Y + tireDisplayItem.tireGroupY
                    spacing: tireDisplayItem.tireSpacing
                    opacity: vehicleStatusDisplayOverlay.tireReadoutOpacity

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: "" + Math.round(vehicleStatusDisplayOverlay.countRL)
                        font.family: "Inter"
                        font.pixelSize: 32
                        font.weight: Font.Bold
                        color: "#FFFFFF"
                    }

                    Rectangle {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.verticalCenterOffset: -2
                        width: tireDisplayItem.tireLineWidth
                        height: tireDisplayItem.tireLineHeight
                        radius: tireDisplayItem.tireLineHeight * 0.5
                        color: "#FFFFFF"
                    }
                }

                // -----------------------------------------------------------------
                // Rear Right Tire: — 41 (Object_10 RR axle)
                // -----------------------------------------------------------------
                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.horizontalCenterOffset: tireDisplayItem.tireRR_X + tireDisplayItem.tireGroupX + vehicleStatusDisplayOverlay.tireSlideOffset
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.verticalCenterOffset: tireDisplayItem.tireRR_Y + tireDisplayItem.tireGroupY
                    spacing: tireDisplayItem.tireSpacing
                    opacity: vehicleStatusDisplayOverlay.tireReadoutOpacity

                    Rectangle {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.verticalCenterOffset: -2
                        width: tireDisplayItem.tireLineWidth
                        height: tireDisplayItem.tireLineHeight
                        radius: tireDisplayItem.tireLineHeight * 0.5
                        color: "#FFFFFF"
                    }

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: "" + Math.round(vehicleStatusDisplayOverlay.countRR)
                        font.family: "Inter"
                        font.pixelSize: 32
                        font.weight: Font.Bold
                        color: "#FFFFFF"
                    }
                }
            }

            // -----------------------------------------------------------------
            // Bottom Summary: psi / Recommended cold pressure / Front 33 Rear 40
            // -----------------------------------------------------------------
            Column {
                id: bottomSummaryColumn
                visible: tireDisplayItem.showBottomSummary
                width: 460
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.horizontalCenterOffset: tireDisplayItem.bottomSummaryX
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: tireDisplayItem.bottomSummaryY - (vehicleStatusDisplayOverlay.tireSlideOffset * 0.5)
                spacing: 6
                opacity: vehicleStatusDisplayOverlay.tireReadoutOpacity

                Text {
                    width: parent.width
                    horizontalAlignment: Text.AlignHCenter
                    text: "psi"
                    font.family: "Inter"
                    font.pixelSize: 22
                    font.weight: Font.Bold
                    color: "#FFFFFF"
                }

                Text {
                    width: parent.width
                    horizontalAlignment: Text.AlignHCenter
                    text: "Recommended cold pressure"
                    font.family: "Inter"
                    font.pixelSize: 18
                    font.weight: Font.DemiBold
                    color: "#FFFFFF"
                }

                Text {
                    width: parent.width
                    horizontalAlignment: Text.AlignHCenter
                    text: "Front " + VehicleBackend.recPressureFront + "   Rear " + VehicleBackend.recPressureRear
                    font.family: "Inter"
                    font.pixelSize: 22
                    font.weight: Font.Bold
                    color: "#FFA77E"
                }
            }
        }
    }

    // =========================================================================
    // Master Luxury Seat & Multi-Contour Massage System (Dual-Level Hub & Studio)
    // =========================================================================
    Item {
        id: seatsMasterOverlay
        anchors.fill: parent
        z: 15
        visible: opacity > 0.001
        opacity: root.seatsPageOpen ? 1.0 : 0.0
        enabled: root.seatsPageOpen
        Behavior on opacity { NumberAnimation { duration: 300; easing.type: Easing.OutCubic } }

        // =====================================================================
        // LEVEL 1: SEATS MASTER HUB (Screenshots 6 & 7)
        // =====================================================================
        Item {
            id: seatsLevel1Container
            anchors.fill: parent
            visible: opacity > 0.001
            opacity: !root.inSeatsStudio ? 1.0 : 0.0
            enabled: !root.inSeatsStudio
            Behavior on opacity {
                NumberAnimation { duration: 300; easing.type: Easing.OutCubic }
            }

            transform: Translate {
                x: !root.inSeatsStudio ? 0 : -36
                Behavior on x {
                    NumberAnimation { duration: 300; easing.type: Easing.OutCubic }
                }
            }

            // Top Navigation Header: Back Arrow + "Seats" Title
            Row {
                id: level1HeaderRow
                anchors.left: parent.left
                anchors.leftMargin: 44
                anchors.top: parent.top
                anchors.topMargin: 44
                spacing: 18

                Item {
                    width: 36
                    height: 36
                    anchors.verticalCenter: parent.verticalCenter

                    Text {
                        anchors.centerIn: parent
                        text: "←"
                        font.pixelSize: 26
                        font.weight: Font.DemiBold
                        color: level1BackMouseArea.pressed ? "#94A3B8" : (level1BackMouseArea.containsMouse ? "#FFFFFF" : "#E2E8F0")
                    }

                    MouseArea {
                        id: level1BackMouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.seatsPageOpen = false
                    }
                }

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: "Seats"
                    font.family: "Inter"
                    font.pixelSize: 24
                    font.weight: Font.DemiBold
                    color: "#FFFFFF"
                }
            }

            // Reusable Seat Adjustment Button matching User Reference Image
            component SeatCircleButton: Rectangle {
                id: cBtn
                property string direction: "up" // "up" or "down"
                property bool isCircle: true    // true = circle (top), false = rounded squircle (bottom)
                property int customSize: isCircle ? 50 : 46
                signal clicked()

                width: customSize
                height: customSize
                radius: isCircle ? (width / 2) : 14
                clip: true

                gradient: Gradient {
                    GradientStop {
                        position: 0.0
                        color: btnMouse.pressed ?
                            Qt.rgba(215/255, 238/255, 255/255, 0.34) :
                            (btnMouse.containsMouse ? Qt.rgba(225/255, 242/255, 255/255, 0.25) : Qt.rgba(215/255, 238/255, 255/255, 0.18))
                    }
                    GradientStop {
                        position: 1.0
                        color: btnMouse.pressed ?
                            Qt.rgba(195/255, 225/255, 255/255, 0.28) :
                            (btnMouse.containsMouse ? Qt.rgba(205/255, 232/255, 255/255, 0.19) : Qt.rgba(195/255, 225/255, 255/255, 0.12))
                    }
                }

                // Sleek glowing glass border
                border.color: btnMouse.containsMouse ?
                    Qt.rgba(255, 255, 255, 0.75) :
                    Qt.rgba(225/255, 242/255, 255/255, 0.38)
                border.width: btnMouse.containsMouse ? 1.8 : 1.2

                Behavior on border.color { ColorAnimation { duration: 150 } }

                scale: btnMouse.pressed ? 0.92 : (btnMouse.containsMouse ? 1.06 : 1.0)
                Behavior on scale { NumberAnimation { duration: 120; easing.type: Easing.OutQuad } }

                // Concentric inner glass ring for luxury depth
                Rectangle {
                    anchors.centerIn: parent
                    width: parent.width - 6
                    height: parent.height - 6
                    radius: cBtn.isCircle ? (width / 2) : 11
                    color: "transparent"
                    border.color: Qt.rgba(255, 255, 255, 0.16)
                    border.width: 1
                }

                // Precision Stroke Chevron matching user reference
                Image {
                    id: chevronImg
                    anchors.centerIn: parent
                    anchors.verticalCenterOffset: (cBtn.direction === "up") ? -1 : 1
                    width: 18
                    height: 8
                    source: (cBtn.direction === "up") ?
                        "qrc:/ApexVision/qml/assets/icons/chevron_up.svg" :
                        "qrc:/ApexVision/qml/assets/icons/chevron_down.svg"
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                    mipmap: true
                }

                MouseArea {
                    id: btnMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: cBtn.clicked()
                }
            }

            // Reusable Seat Menu Card matching Vehicle Status size & styling
            component SeatMenuCard: Rectangle {
                id: seatCard
                property string iconSource: ""
                property string iconSourceSelected: ""
                property string titleText: ""
                property bool isSelected: false
                signal clicked()

                width: parent ? parent.width : 500
                height: 104
                radius: 18
                clip: true

                // Ultra-Light Frosted Glass Fill
                gradient: Gradient {
                    GradientStop {
                        position: 0.0
                        color: cardMouse.pressed ?
                            Qt.rgba(215/255, 238/255, 255/255, 0.32) :
                            (cardMouse.containsMouse ? Qt.rgba(225/255, 242/255, 255/255, 0.24) :
                            (seatCard.isSelected ? Qt.rgba(225/255, 242/255, 255/255, 0.22) : Qt.rgba(215/255, 238/255, 255/255, 0.16)))
                    }
                    GradientStop {
                        position: 1.0
                        color: cardMouse.pressed ?
                            Qt.rgba(195/255, 225/255, 255/255, 0.26) :
                            (cardMouse.containsMouse ? Qt.rgba(205/255, 232/255, 255/255, 0.18) :
                            (seatCard.isSelected ? Qt.rgba(205/255, 232/255, 255/255, 0.16) : Qt.rgba(195/255, 225/255, 255/255, 0.10)))
                    }
                }

                // Border: active amber when selected, luminous light glass when unselected
                border.color: seatCard.isSelected ?
                    "#F59E0B" :
                    (cardMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.65) : Qt.rgba(225/255, 242/255, 255/255, 0.36))
                border.width: seatCard.isSelected ? 2 : 1

                Behavior on border.color { ColorAnimation { duration: 180 } }

                scale: cardMouse.pressed ? 0.98 : (cardMouse.containsMouse ? 1.01 : 1.0)
                Behavior on scale { NumberAnimation { duration: 150; easing.type: Easing.OutQuad } }

                // Top Specular Glass Reflection
                Rectangle {
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.topMargin: 1
                    anchors.leftMargin: 20
                    anchors.rightMargin: 20
                    height: 1
                    color: seatCard.isSelected ?
                        Qt.rgba(245/255, 158/255, 11/255, 0.50) :
                        (cardMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.60) : Qt.rgba(255, 255, 255, 0.35))
                    radius: 1
                }

                Row {
                    anchors.fill: parent
                    anchors.leftMargin: 24
                    anchors.rightMargin: 24
                    spacing: 20

                    // Glowing Seat Icon: Yellow glow when selected, Blue/cyan glow when unselected
                    Image {
                        id: menuIcon
                        anchors.verticalCenter: parent.verticalCenter
                        width: 38
                        height: 38
                        source: (seatCard.isSelected && seatCard.iconSourceSelected !== "") ?
                            seatCard.iconSourceSelected : seatCard.iconSource
                        sourceSize: Qt.size(76, 76)
                        fillMode: Image.PreserveAspectFit
                        smooth: true
                        mipmap: true
                    }

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: seatCard.titleText
                        font.family: "Inter"
                        font.pixelSize: 22
                        font.weight: seatCard.isSelected ? Font.DemiBold : Font.Normal
                        color: "#FFFFFF"
                        renderType: Text.NativeRendering
                    }
                }

                MouseArea {
                    id: cardMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: seatCard.clicked()
                }
            }

            // Left Menu: 3 Selection Cards (Full 500px width matching vehicle status)
            Column {
                id: level1MenuColumn
                anchors.left: parent.left
                anchors.leftMargin: 44
                anchors.top: level1HeaderRow.bottom
                anchors.topMargin: 36
                width: 500
                spacing: 16

                // 1. Move second row seats
                SeatMenuCard {
                    iconSource: "qrc:/ApexVision/qml/assets/icons/seat_menu_second_row_blue.png"
                    iconSourceSelected: "qrc:/ApexVision/qml/assets/icons/seat_menu_second_row_amber.png"
                    titleText: "Move second row seats"
                    isSelected: root.seatsSubMenu === "second_row"
                    onClicked: root.seatsSubMenu = "second_row"
                }

                // 2. Move front passenger seat
                SeatMenuCard {
                    iconSource: "qrc:/ApexVision/qml/assets/icons/seat_menu_passenger_blue.png"
                    iconSourceSelected: "qrc:/ApexVision/qml/assets/icons/seat_menu_passenger_amber.png"
                    titleText: "Move front passenger seat"
                    isSelected: root.seatsSubMenu === "passenger"
                    onClicked: root.seatsSubMenu = "passenger"
                }

                // 3. Adjust and massage
                SeatMenuCard {
                    iconSource: "qrc:/ApexVision/qml/assets/icons/seat_menu_adjust_massage_blue.png"
                    iconSourceSelected: "qrc:/ApexVision/qml/assets/icons/seat_menu_adjust_massage_amber.png"
                    titleText: "Adjust and massage"
                    isSelected: root.seatsSubMenu === "adjust_massage"
                    onClicked: {
                        root.seatsSubMenu = "adjust_massage";
                        root.inSeatsStudio = true;
                    }
                }
            }

            // Right Floating Adjustment Overlay for Cabin View
            Item {
                id: cabinOverlay
                anchors.left: level1MenuColumn.right
                anchors.leftMargin: 20
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom

                // Smooth fade and slide-in animation
                opacity: root.seatsPageOpen ? 1.0 : 0.0
                Behavior on opacity { NumberAnimation { duration: 420; easing.type: Easing.OutCubic } }

                transform: Translate {
                    x: root.seatsPageOpen ? 0 : 50
                    Behavior on x { NumberAnimation { duration: 450; easing.type: Easing.OutCubic } }
                }

                // -------------------------------------------------------------
                // Mode A: Move Second Row Seats View (Matching User Reference Image)
                // -------------------------------------------------------------
                // Mode A: Move Second Row Seats Controls (2 UP, 2 DOWN Arrows)
                // -------------------------------------------------------------
                // -------------------------------------------------------------
                // Mode A: Move Second Row Seats View (2D Image + Precision Arrow Controls)
                // -------------------------------------------------------------
                Item {
                    id: secondRowControls
                    anchors.fill: parent
                    visible: opacity > 0.001
                    opacity: (root.seatsSubMenu === "second_row" && !root.inSeatsStudio) ? 1.0 : 0.0
                    enabled: root.seatsSubMenu === "second_row" && !root.inSeatsStudio
                    z: 5

                    Behavior on opacity {
                        NumberAnimation { duration: 350; easing.type: Easing.OutCubic }
                    }

                    transform: Translate {
                        x: (root.seatsSubMenu === "second_row" && !root.inSeatsStudio) ? 0 : 40
                        Behavior on x {
                            NumberAnimation { duration: 380; easing.type: Easing.OutCubic }
                        }
                    }

                    // =========================================================================
                    // 🎯 2ND ROW SEAT IMAGE & ARROWS CONFIGURATION
                    // =========================================================================
                    // Dimensions of the 2D seats image (Enlarged to utilize available space, matching passenger view)
                    property real seatImageWidth: 780
                    property real seatImageHeight: 520

                    // Position of the seats image within cabinOverlay (Centered nicely)
                    property real seatImageX: Math.round((width - seatImageWidth) / 2)
                    property real seatImageY: Math.round((height - seatImageHeight) / 2 - 20)

                    // Horizontal (X) Centers mathematically locked to each seat's spine:
                    // In image copy 2.png (1536x1024), left seat center = 376.5, right seat center = 1154.0
                    property int leftSeatCenterX: Math.round(seatImageX + (376.5 / 1536.0) * seatImageWidth)
                    property int rightSeatCenterX: Math.round(seatImageX + (1154.0 / 1536.0) * seatImageWidth)

                    // Vertical (Y) Levels for arrows (perfectly spaced above headrest and below cushion):
                    // Headrest top in image = 86px -> frontArrowY (50px arrow, 16px gap)
                    // Cushion bottom in image = 936px -> backArrowY (46px arrow, 16px gap)
                    property int frontArrowY: Math.round(seatImageY + (86.0 / 1024.0) * seatImageHeight - 50 - 16)
                    property int backArrowY: Math.round(seatImageY + (936.0 / 1024.0) * seatImageHeight + 16)

                    // -------------------------------------------------------------
                    // 2D Luxury Seats Render Image
                    // -------------------------------------------------------------
                    Image {
                        id: secondRowSeatsImage
                        x: secondRowControls.seatImageX
                        y: secondRowControls.seatImageY
                        width: secondRowControls.seatImageWidth
                        height: secondRowControls.seatImageHeight
                        source: "qrc:/ApexVision/qml/assets/icons/seat_second_row_render.png"
                        fillMode: Image.PreserveAspectFit
                        smooth: true
                        mipmap: true
                        z: 1
                    }

                    // =========================================================================
                    // 📁 GROUP 1: LEFT SEAT ARROWS (Front & Back)
                    // =========================================================================
                    Item {
                        id: leftSeatArrowsGroup
                        x: secondRowControls.leftSeatCenterX - width / 2
                        y: 0
                        width: 80
                        height: parent.height
                        z: 2

                        // ⬆️ Front Arrow (UP - Circle in front of left seat)
                        SeatCircleButton {
                            id: btnLeftSeatFront
                            anchors.horizontalCenter: parent.horizontalCenter
                            y: secondRowControls.frontArrowY
                            direction: "up"
                            isCircle: true
                            onClicked: {}
                        }

                        // ⬇️ Back Arrow (DOWN - Squircle behind left seat)
                        SeatCircleButton {
                            id: btnLeftSeatBack
                            anchors.horizontalCenter: parent.horizontalCenter
                            y: secondRowControls.backArrowY
                            direction: "down"
                            isCircle: false
                            onClicked: {}
                        }
                    }

                    // =========================================================================
                    // 📁 GROUP 2: RIGHT SEAT ARROWS (Front & Back)
                    // =========================================================================
                    Item {
                        id: rightSeatArrowsGroup
                        x: secondRowControls.rightSeatCenterX - width / 2
                        y: 0
                        width: 80
                        height: parent.height
                        z: 2

                        // ⬆️ Front Arrow (UP - Circle in front of right seat)
                        SeatCircleButton {
                            id: btnRightSeatFront
                            anchors.horizontalCenter: parent.horizontalCenter
                            y: secondRowControls.frontArrowY
                            direction: "up"
                            isCircle: true
                            onClicked: {}
                        }

                        // ⬇️ Back Arrow (DOWN - Squircle behind right seat)
                        SeatCircleButton {
                            id: btnRightSeatBack
                            anchors.horizontalCenter: parent.horizontalCenter
                            y: secondRowControls.backArrowY
                            direction: "down"
                            isCircle: false
                            onClicked: {}
                        }
                    }
                }

                // -------------------------------------------------------------
                // Mode B: Move Front Passenger Seat View (Matching User Reference Image)
                // -------------------------------------------------------------
                Item {
                    id: passengerControls
                    anchors.fill: parent
                    visible: opacity > 0.001
                    opacity: (root.seatsSubMenu === "passenger" && !root.inSeatsStudio) ? 1.0 : 0.0
                    enabled: root.seatsSubMenu === "passenger" && !root.inSeatsStudio
                    z: 5

                    Behavior on opacity {
                        NumberAnimation { duration: 350; easing.type: Easing.OutCubic }
                    }

                    transform: Translate {
                        x: (root.seatsSubMenu === "passenger" && !root.inSeatsStudio) ? 0 : 40
                        Behavior on x {
                            NumberAnimation { duration: 380; easing.type: Easing.OutCubic }
                        }
                    }

                    // Dimensions and Position of the 2D passenger seat render (Enlarged to utilize available space)
                    property real seatImageWidth: 780
                    property real seatImageHeight: 520
                    property real seatImageX: Math.round((width - seatImageWidth) / 2)
                    property real seatImageY: Math.round((height - seatImageHeight) / 2 - 60)

                    // 2D Passenger Seat Render Image (image copy 4.png)
                    Image {
                        id: passengerSeatImage
                        x: passengerControls.seatImageX
                        y: passengerControls.seatImageY
                        width: passengerControls.seatImageWidth
                        height: passengerControls.seatImageHeight
                        source: "qrc:/ApexVision/qml/assets/icons/seat_passenger_render.png"
                        fillMode: Image.PreserveAspectFit
                        smooth: true
                        mipmap: true
                        z: 1
                    }

                    // Reusable Circular Action Button Component
                    component SeatActionButton: Rectangle {
                        id: actBtn
                        property string iconSource: ""
                        signal clicked()

                        width: 56
                        height: 56
                        radius: width / 2
                        clip: true

                        gradient: Gradient {
                            GradientStop {
                                position: 0.0
                                color: actMouse.pressed ?
                                    Qt.rgba(215/255, 238/255, 255/255, 0.34) :
                                    (actMouse.containsMouse ? Qt.rgba(225/255, 242/255, 255/255, 0.25) : Qt.rgba(215/255, 238/255, 255/255, 0.18))
                            }
                            GradientStop {
                                position: 1.0
                                color: actMouse.pressed ?
                                    Qt.rgba(195/255, 225/255, 255/255, 0.28) :
                                    (actMouse.containsMouse ? Qt.rgba(205/255, 232/255, 255/255, 0.19) : Qt.rgba(195/255, 225/255, 255/255, 0.12))
                            }
                        }

                        border.color: actMouse.containsMouse ?
                            Qt.rgba(255, 255, 255, 0.75) :
                            Qt.rgba(225/255, 242/255, 255/255, 0.38)
                        border.width: actMouse.containsMouse ? 1.8 : 1.2

                        Behavior on border.color { ColorAnimation { duration: 150 } }

                        scale: actMouse.pressed ? 0.92 : (actMouse.containsMouse ? 1.06 : 1.0)
                        Behavior on scale { NumberAnimation { duration: 120; easing.type: Easing.OutQuad } }

                        // Inner luxury glass rim
                        Rectangle {
                            anchors.centerIn: parent
                            width: parent.width - 6
                            height: parent.height - 6
                            radius: width / 2
                            color: "transparent"
                            border.color: Qt.rgba(255, 255, 255, 0.16)
                            border.width: 1
                        }

                        // Glowing Seat Action Icon (from image copy 5.png)
                        Image {
                            anchors.centerIn: parent
                            width: 34
                            height: 34
                            source: actBtn.iconSource
                            fillMode: Image.PreserveAspectFit
                            smooth: true
                            mipmap: true
                        }

                        MouseArea {
                            id: actMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: actBtn.clicked()
                        }
                    }

                    // Row of 4 Action Buttons (from image copy 5.png, under front passenger seat)
                    Row {
                        id: passengerButtonsRow
                        anchors.horizontalCenter: passengerSeatImage.horizontalCenter
                        y: passengerControls.seatImageY + passengerControls.seatImageHeight + 24
                        spacing: 18
                        z: 2

                        // 1. Recline Backrest Backward
                        SeatActionButton {
                            iconSource: "qrc:/ApexVision/qml/assets/icons/icon_passenger_recline_back.png"
                            onClicked: {}
                        }

                        // 2. Recline Backrest Forward
                        SeatActionButton {
                            iconSource: "qrc:/ApexVision/qml/assets/icons/icon_passenger_recline_fwd.png"
                            onClicked: {}
                        }

                        // 3. Lower Seat Cushion
                        SeatActionButton {
                            iconSource: "qrc:/ApexVision/qml/assets/icons/icon_passenger_cushion_down.png"
                            onClicked: {}
                        }

                        // 4. Raise Seat Cushion
                        SeatActionButton {
                            iconSource: "qrc:/ApexVision/qml/assets/icons/icon_passenger_cushion_up.png"
                            onClicked: {}
                        }
                    }
                }
            }
        }

        // =====================================================================
        // LEVEL 2: DEDICATED SEAT & MASSAGE STUDIO (Screenshots 1 – 5)
        // =====================================================================
        Item {
            id: seatsLevel2Container
            anchors.fill: parent
            visible: opacity > 0.001
            opacity: root.inSeatsStudio ? 1.0 : 0.0
            enabled: root.inSeatsStudio
            Behavior on opacity {
                NumberAnimation { duration: 300; easing.type: Easing.OutCubic }
            }

            transform: Translate {
                x: root.inSeatsStudio ? 0 : 36
                Behavior on x {
                    NumberAnimation { duration: 300; easing.type: Easing.OutCubic }
                }
            }

            // 3D Luxury Seat Studio Loader (Right-Half Interactive 360° Inspection)
            Loader {
                id: seatStudioLoader
                anchors.left: parent.horizontalCenter
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                clip: false
                z: 1
                active: root.seatsPageOpen && root.inSeatsStudio
                source: (typeof SeatStudioViewUrl !== "undefined") ? SeatStudioViewUrl : ""

                onLoaded: {
                    if (item) {
                        item.viewMode = "studio";
                        item.activeCabinTarget = Qt.binding(() => (root.seatsSubMenu === "second_row" ? "rear" : "front"));
                        item.activeSeat = Qt.binding(() => root.seatsActiveTarget);
                        item.selectedZone = Qt.binding(() => root.seatActiveZone);
                        item.lumbarUpperLevel = Qt.binding(() => (root.seatsActiveTarget === "driver" ? root.driverLumbarUpperVal / 10.0 : root.passengerLumbarUpperVal / 10.0));
                        item.lumbarMidLevel = Qt.binding(() => (root.seatsActiveTarget === "driver" ? root.driverLumbarMidVal / 10.0 : root.passengerLumbarMidVal / 10.0));
                        item.lumbarLowerLevel = Qt.binding(() => (root.seatsActiveTarget === "driver" ? root.driverLumbarLowerVal / 10.0 : root.passengerLumbarLowerVal / 10.0));
                        item.cushionLeftLevel = Qt.binding(() => (root.seatsActiveTarget === "driver" ? root.driverCushionLeftVal / 10.0 : root.passengerCushionLeftVal / 10.0));
                        item.cushionRightLevel = Qt.binding(() => (root.seatsActiveTarget === "driver" ? root.driverCushionRightVal / 10.0 : root.passengerCushionRightVal / 10.0));
                        item.seatStudioTab = Qt.binding(() => root.seatStudioTab);
                        item.massageActive = Qt.binding(() => (root.seatStudioTab === "massage" && root.massageActive));
                        item.massageIntensity = Qt.binding(() => root.massageIntensity);
                        item.massageProgram = Qt.binding(() => root.massageProgram);
                        item.rearLeftSlide = Qt.binding(() => root.rearLeftSlide);
                        item.rearRightSlide = Qt.binding(() => root.rearRightSlide);
                        item.frontPassSlide = Qt.binding(() => root.frontPassSlide);
                    }
                }

                Connections {
                    target: seatStudioLoader.item
                    ignoreUnknownSignals: true
                    function onZoneSelected(zone) {
                        root.seatActiveZone = zone;
                    }
                }
            }

            // Top Navigation: [✕ Close] + [Massage | Seat] Tabs + [Driver | Passenger] Selector
            Item {
                id: studioTopBar
                anchors.left: parent.left
                anchors.leftMargin: 44
                anchors.right: parent.right
                anchors.rightMargin: 120
                anchors.top: parent.top
                anchors.topMargin: 36
                height: 48
                z: 20

                // ✕ Close Button
                Item {
                    id: closeBtn
                    width: 36
                    height: 36
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter

                    Text {
                        anchors.centerIn: parent
                        text: "✕"
                        font.pixelSize: 22
                        font.weight: Font.DemiBold
                        color: closeMouseArea.pressed ? "#94A3B8" : (closeMouseArea.containsMouse ? "#FFFFFF" : "#E2E8F0")
                    }

                    MouseArea {
                        id: closeMouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            root.inSeatsStudio = false;
                            root.seatsPageOpen = false;
                        }
                    }
                }

                // Center-Left Segmented Tabs: "Massage" | "Seat"
                Row {
                    id: studioTabsRow
                    anchors.left: closeBtn.right
                    anchors.leftMargin: 36
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 32

                    // "Massage" Tab
                    Item {
                        width: massageText.implicitWidth + 8
                        height: 36

                        Text {
                            id: massageText
                            anchors.centerIn: parent
                            text: "Massage"
                            font.family: "Inter"
                            font.pixelSize: 21
                            font.weight: root.seatStudioTab === "massage" ? Font.Bold : Font.Normal
                            color: root.seatStudioTab === "massage" ? "#FFFFFF" : "#94A3B8"
                        }

                        Rectangle {
                            anchors.bottom: parent.bottom
                            anchors.horizontalCenter: parent.horizontalCenter
                            width: parent.width
                            height: 3
                            radius: 1.5
                            color: "#F59E0B" // yellow/amber underline matching selected seat options
                            visible: root.seatStudioTab === "massage"
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                root.seatStudioTab = "massage";
                                root.massageActive = true;
                                if (seatStudioLoader.item && typeof seatStudioLoader.item.playMassageRotation === "function") {
                                    seatStudioLoader.item.playMassageRotation();
                                }
                            }
                        }
                    }

                    // "Seat" Tab
                    Item {
                        width: seatText.implicitWidth + 8
                        height: 36

                        Text {
                            id: seatText
                            anchors.centerIn: parent
                            text: "Seat"
                            font.family: "Inter"
                            font.pixelSize: 21
                            font.weight: root.seatStudioTab === "seat" ? Font.Bold : Font.Normal
                            color: root.seatStudioTab === "seat" ? "#FFFFFF" : "#94A3B8"
                        }

                        Rectangle {
                            anchors.bottom: parent.bottom
                            anchors.horizontalCenter: parent.horizontalCenter
                            width: parent.width
                            height: 3
                            radius: 1.5
                            color: "#F59E0B" // yellow/amber underline matching selected seat options
                            visible: root.seatStudioTab === "seat"
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                if (root.massageActive || root.seatStudioTab === "massage") {
                                    root.massageActive = false;
                                }
                                root.seatStudioTab = "seat";
                            }
                        }
                    }
                }

                // Top Right: Driver / Passenger Target Selector Segmented Capsule
                Rectangle {
                    id: studioSeatSelector
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    height: 42
                    width: 216
                    radius: 21
                    color: Qt.rgba(14/255, 20/255, 34/255, 0.70)
                    border.color: Qt.rgba(255, 255, 255, 0.16)
                    border.width: 1

                    // Smooth Sliding Active Indicator Pill
                    Rectangle {
                        id: activeTabIndicator
                        x: root.seatsActiveTarget === "driver" ? 4 : 110
                        y: 4
                        width: 102
                        height: 34
                        radius: 17
                        color: Qt.rgba(245/255, 158/255, 11/255, 0.20)
                        border.color: "#F59E0B"
                        border.width: 1.5

                        Behavior on x {
                            NumberAnimation {
                                duration: 280
                                easing.type: Easing.OutCubic
                            }
                        }
                    }

                    Row {
                        anchors.fill: parent
                        anchors.margins: 4
                        spacing: 4

                        // Driver Tab Button
                        Item {
                            id: driverTabBtn
                            width: 102
                            height: 34

                            Text {
                                anchors.centerIn: parent
                                text: "Driver"
                                font.family: "Inter"
                                font.pixelSize: 14
                                font.weight: root.seatsActiveTarget === "driver" ? Font.DemiBold : Font.Normal
                                color: root.seatsActiveTarget === "driver" ? "#FFFFFF" : "#94A3B8"
                                Behavior on color { ColorAnimation { duration: 200 } }
                            }

                            MouseArea {
                                id: driverTabMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: root.seatsActiveTarget = "driver"
                            }
                        }

                        // Passenger Tab Button
                        Item {
                            id: passengerTabBtn
                            width: 102
                            height: 34

                            Text {
                                anchors.centerIn: parent
                                text: "Passenger"
                                font.family: "Inter"
                                font.pixelSize: 14
                                font.weight: root.seatsActiveTarget === "passenger" ? Font.DemiBold : Font.Normal
                                color: root.seatsActiveTarget === "passenger" ? "#FFFFFF" : "#94A3B8"
                                Behavior on color { ColorAnimation { duration: 200 } }
                            }

                            MouseArea {
                                id: passengerTabMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: root.seatsActiveTarget = "passenger"
                            }
                        }
                    }
                }
            }

            // =================================================================
            // STUDIO LEFT OPTIONS AREA (500px width matching Vehicle Status & Seats)
            // =================================================================
            Item {
                id: studioLeftOptionsArea
                anchors.left: parent.left
                anchors.leftMargin: 44
                width: 500
                anchors.top: studioTopBar.bottom
                anchors.bottom: parent.bottom
                anchors.topMargin: 20
                anchors.bottomMargin: 24
                z: 20

                // -------------------------------------------------------------
                // 1. "Seat" Mode: Clean frosted-glass dialer matching card colors
                // -------------------------------------------------------------
                Item {
                    id: seatControlsWrapper
                    anchors.fill: parent
                    visible: opacity > 0.001
                    opacity: root.seatStudioTab === "seat" ? 1.0 : 0.0
                    enabled: root.seatStudioTab === "seat"
                    Behavior on opacity {
                        NumberAnimation { duration: 300 }
                    }

                    Item {
                        id: seatDialContainer
                        anchors.centerIn: parent
                        width: 250
                        height: 250

                        // Outer Dial Disc - Styled with exact Card Colors (frosted glass)
                        Rectangle {
                            id: outerDialDisc
                            anchors.fill: parent
                            radius: width / 2
                            gradient: Gradient {
                                GradientStop { position: 0.0; color: Qt.rgba(225/255, 242/255, 255/255, 0.22) }
                                GradientStop { position: 1.0; color: Qt.rgba(135/255, 175/255, 220/255, 0.12) }
                            }
                            border.color: Qt.rgba(255, 255, 255, 0.28)
                            border.width: 1.5


                            // Top Chevron Button (Up)
                            Rectangle {
                                anchors.top: parent.top
                                anchors.topMargin: 12
                                anchors.horizontalCenter: parent.horizontalCenter
                                width: 58; height: 38
                                radius: 10
                                color: topBtnMouse.pressed ? Qt.rgba(255, 255, 255, 0.25) :
                                       (topBtnMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.15) : "transparent")
                                Behavior on color { ColorAnimation { duration: 150 } }

                                Text {
                                    anchors.centerIn: parent
                                    text: "▲"
                                    font.pixelSize: 16
                                    color: "#FFFFFF"
                                }

                                MouseArea {
                                    id: topBtnMouse
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: root.adjustCurrentZoneVal(+1)
                                }
                            }

                            // Bottom Chevron Button (Down)
                            Rectangle {
                                anchors.bottom: parent.bottom
                                anchors.bottomMargin: 12
                                anchors.horizontalCenter: parent.horizontalCenter
                                width: 58; height: 38
                                radius: 10
                                color: botBtnMouse.pressed ? Qt.rgba(255, 255, 255, 0.25) :
                                       (botBtnMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.15) : "transparent")
                                Behavior on color { ColorAnimation { duration: 150 } }

                                Text {
                                    anchors.centerIn: parent
                                    text: "▼"
                                    font.pixelSize: 16
                                    color: "#FFFFFF"
                                }

                                MouseArea {
                                    id: botBtnMouse
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: root.adjustCurrentZoneVal(-1)
                                }
                            }

                            // Left Button (Minus)
                            Rectangle {
                                anchors.left: parent.left
                                anchors.leftMargin: 12
                                anchors.verticalCenter: parent.verticalCenter
                                width: 44; height: 58
                                radius: 10
                                color: leftBtnMouse.pressed ? Qt.rgba(255, 255, 255, 0.25) :
                                       (leftBtnMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.15) : "transparent")
                                Behavior on color { ColorAnimation { duration: 150 } }

                                Image {
                                    anchors.centerIn: parent
                                    width: 26; height: 26
                                    source: "qrc:/ApexVision/qml/assets/icons/icon_seat_minus.svg"
                                    sourceSize: Qt.size(52, 52)
                                }

                                MouseArea {
                                    id: leftBtnMouse
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: root.adjustCurrentZoneVal(-1)
                                }
                            }

                            // Right Button (Plus)
                            Rectangle {
                                anchors.right: parent.right
                                anchors.rightMargin: 12
                                anchors.verticalCenter: parent.verticalCenter
                                width: 44; height: 58
                                radius: 10
                                color: rightBtnMouse.pressed ? Qt.rgba(255, 255, 255, 0.25) :
                                       (rightBtnMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.15) : "transparent")
                                Behavior on color { ColorAnimation { duration: 150 } }

                                Image {
                                    anchors.centerIn: parent
                                    width: 26; height: 26
                                    source: "qrc:/ApexVision/qml/assets/icons/icon_seat_plus.svg"
                                    sourceSize: Qt.size(52, 52)
                                }

                                MouseArea {
                                    id: rightBtnMouse
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: root.adjustCurrentZoneVal(+1)
                                }
                            }

                            // Center Value Readout Disc - Frosted Glass Card Tone
                            Rectangle {
                                anchors.centerIn: parent
                                width: 104
                                height: 104
                                radius: 52
                                gradient: Gradient {
                                    GradientStop { position: 0.0; color: Qt.rgba(215/255, 238/255, 255/255, 0.25) }
                                    GradientStop { position: 1.0; color: Qt.rgba(145/255, 185/255, 230/255, 0.14) }
                                }
                                border.color: Qt.rgba(255, 255, 255, 0.32)
                                border.width: 1.2

                                Column {
                                    anchors.centerIn: parent
                                    spacing: 1

                                    Text {
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        text: "" + root.getCurrentZoneVal()
                                        font.family: "Inter"
                                        font.pixelSize: 28
                                        font.weight: Font.Bold
                                        color: "#FFFFFF"
                                    }

                                    Text {
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        text: "/10"
                                        font.family: "Inter"
                                        font.pixelSize: 13
                                        font.weight: Font.Medium
                                        color: Qt.rgba(255, 255, 255, 0.70)
                                    }
                                }
                            }
                        }
                    }
                }

                // -------------------------------------------------------------
                // 2. "Massage" Mode: 5 High-Gloss Menu Cards matching Seats & Vehicle Status Menu
                // Height: 104px, Radius: 18, Frosted Glass with Specular Line
                // -------------------------------------------------------------
                Flickable {
                    id: massageFlickable
                    anchors.fill: parent
                    anchors.leftMargin: -12
                    anchors.rightMargin: -12
                    anchors.topMargin: -8
                    anchors.bottomMargin: -8
                    contentHeight: massageProgramsColumn.implicitHeight + 24
                    clip: true
                    boundsBehavior: Flickable.StopAtBounds
                    visible: opacity > 0.001
                    opacity: root.seatStudioTab === "massage" ? 1.0 : 0.0
                    enabled: root.seatStudioTab === "massage"
                    Behavior on opacity {
                        NumberAnimation { duration: 300 }
                    }

                    Column {
                        id: massageProgramsColumn
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.top
                        anchors.topMargin: 8
                        width: 500
                        spacing: 16

                        Repeater {
                            model: [
                                { id: "circular", title: "Circular" },
                                { id: "relax", title: "Relax" },
                                { id: "recovery", title: "Recovery" },
                                { id: "rolling", title: "Rolling" },
                                { id: "pulse", title: "Pulse" }
                            ]

                            delegate: Rectangle {
                                id: massageCard
                                readonly property bool isSelected: root.massageProgram === modelData.id
                                width: massageProgramsColumn.width
                                height: 104
                                radius: 18
                                z: massageCardMouse.containsMouse ? 2 : 1

                                // Ultra-Light Frosted Glass Fill matching Vehicle Status & Seat cards
                                gradient: Gradient {
                                    GradientStop {
                                        position: 0.0
                                        color: massageCardMouse.pressed ?
                                            Qt.rgba(215/255, 238/255, 255/255, 0.32) :
                                            (massageCardMouse.containsMouse ? Qt.rgba(225/255, 242/255, 255/255, 0.24) :
                                            (isSelected ? Qt.rgba(225/255, 242/255, 255/255, 0.22) : Qt.rgba(215/255, 238/255, 255/255, 0.16)))
                                    }
                                    GradientStop {
                                        position: 1.0
                                        color: massageCardMouse.pressed ?
                                            Qt.rgba(195/255, 225/255, 255/255, 0.26) :
                                            (massageCardMouse.containsMouse ? Qt.rgba(205/255, 232/255, 255/255, 0.18) :
                                            (isSelected ? Qt.rgba(205/255, 232/255, 255/255, 0.16) : Qt.rgba(195/255, 225/255, 255/255, 0.10)))
                                    }
                                }

                                // Border: active amber when selected, luminous light glass when unselected
                                border.color: isSelected ?
                                    "#F59E0B" :
                                    (massageCardMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.65) : Qt.rgba(225/255, 242/255, 255/255, 0.36))
                                border.width: isSelected ? 2 : 1
                                Behavior on border.color { ColorAnimation { duration: 180 } }

                                scale: massageCardMouse.pressed ? 0.98 : (massageCardMouse.containsMouse ? 1.01 : 1.0)
                                Behavior on scale { NumberAnimation { duration: 150; easing.type: Easing.OutQuad } }

                                // Top Specular Glass Reflection Line
                                Rectangle {
                                    anchors.top: parent.top
                                    anchors.left: parent.left
                                    anchors.right: parent.right
                                    anchors.topMargin: 1
                                    anchors.leftMargin: 20
                                    anchors.rightMargin: 20
                                    height: 1
                                    color: isSelected ?
                                        Qt.rgba(245/255, 158/255, 11/255, 0.50) :
                                        (massageCardMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.60) : Qt.rgba(255, 255, 255, 0.35))
                                    radius: 1
                                }

                                // Card Title on Left
                                Text {
                                    anchors.left: parent.left
                                    anchors.leftMargin: 24
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: modelData.title
                                    font.family: "Inter"
                                    font.pixelSize: 22
                                    font.weight: isSelected ? Font.DemiBold : Font.Normal
                                    color: "#FFFFFF"
                                }

                                // Extreme Right: 3 Intensity Dots and Power Icon
                                Row {
                                    anchors.right: parent.right
                                    anchors.rightMargin: 24
                                    anchors.verticalCenter: parent.verticalCenter
                                    spacing: 20
                                    visible: isSelected

                                    // 3 Intensity Indicator Dots
                                    Item {
                                        width: dotsRow.width
                                        height: 32
                                        anchors.verticalCenter: parent.verticalCenter

                                        Row {
                                            id: dotsRow
                                            anchors.centerIn: parent
                                            spacing: 9

                                            Repeater {
                                                model: 3
                                                Rectangle {
                                                    width: 10
                                                    height: 10
                                                    radius: 5
                                                    color: (index < root.massageIntensity && root.massageActive) ? "#F59E0B" : Qt.rgba(255, 255, 255, 0.35)
                                                }
                                            }
                                        }

                                        MouseArea {
                                            anchors.fill: parent
                                            anchors.margins: -10
                                            cursorShape: Qt.PointingHandCursor
                                            onClicked: {
                                                root.massageIntensity = (root.massageIntensity % 3) + 1;
                                            }
                                        }
                                    }

                                    // Power Icon ⏻
                                    Item {
                                        width: 32
                                        height: 32
                                        anchors.verticalCenter: parent.verticalCenter

                                        Image {
                                            anchors.centerIn: parent
                                            width: 24
                                            height: 24
                                            source: "qrc:/ApexVision/qml/assets/icons/icon_power.svg"
                                            sourceSize: Qt.size(48, 48)
                                            opacity: root.massageActive ? 1.0 : 0.45
                                        }

                                        MouseArea {
                                            anchors.fill: parent
                                            anchors.margins: -6
                                            cursorShape: Qt.PointingHandCursor
                                            onClicked: {
                                                if (root.massageActive) {
                                                    root.massageActive = false;
                                                } else {
                                                    root.massageActive = true;
                                                    if (seatStudioLoader.item && typeof seatStudioLoader.item.playMassageRotation === "function") {
                                                        seatStudioLoader.item.playMassageRotation();
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }

                                MouseArea {
                                    id: massageCardMouse
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                        var wasActive = root.massageActive;
                                        root.massageProgram = modelData.id;
                                        root.massageActive = true;
                                        if (!wasActive && seatStudioLoader.item && typeof seatStudioLoader.item.playMassageRotation === "function") {
                                            seatStudioLoader.item.playMassageRotation();
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    // =========================================================================
    // Master Full-Screen Valet Mode Experience (Warning & PIN Setup)
    // Takes the whole screen with luxury dark automotive backdrop matching reference photo
    // =========================================================================
    Item {
        id: valetModeOverlay
        anchors.fill: parent
        z: 25
        visible: opacity > 0.001
        opacity: root.valetModePageOpen ? 1.0 : 0.0
        enabled: root.valetModePageOpen
        Behavior on opacity { NumberAnimation { duration: 300; easing.type: Easing.OutCubic } }

        // Master Project Default Background (Matching IVI system wallpaper)
        Image {
            id: valetBgImage
            anchors.fill: parent
            source: "qrc:/ApexVision/qml/assets/default_background.png"
            fillMode: Image.PreserveAspectCrop
            smooth: true
            z: 0
        }

        // Very light scrim so default background colors stay bright and vibrant
        Rectangle {
            anchors.fill: parent
            color: Qt.rgba(0, 0, 0, 0.15)
            z: 1
        }

        // Intercept all clicks so underlying UI is not touchable
        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            preventStealing: true
        }

        // Top Navigation Header: Back Arrow, "Valet mode" Title
        Row {
            id: valetHeaderRow
            anchors.left: parent.left
            anchors.leftMargin: 44
            anchors.top: parent.top
            anchors.topMargin: 36
            spacing: 20
            z: 2

            // Back button
            Item {
                width: 36
                height: 36
                anchors.verticalCenter: parent.verticalCenter

                Text {
                    anchors.centerIn: parent
                    text: "←"
                    font.pixelSize: 26
                    font.weight: Font.DemiBold
                    color: valetBackMouse.pressed ? "#CBD5E1" : "#FFFFFF"
                }

                MouseArea {
                    id: valetBackMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        if (root.valetStep === 2) {
                            root.valetStep = 1;
                            root.enteredPin = "";
                            root.tempPin = "";
                            root.pinConfirmStep = false;
                            root.valetErrorMessage = "";
                        } else {
                            root.valetModePageOpen = false;
                        }
                    }
                }
            }

            // Title
            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: "Valet mode"
                font.family: "Inter"
                font.pixelSize: 24
                font.weight: Font.DemiBold
                color: "#FFFFFF"
            }
        }

        // Step 1: Warning & Information (Whole screen layout)
        Item {
            id: valetInfoStep
            anchors.fill: parent
            visible: root.valetStep === 1
            opacity: root.valetStep === 1 ? 1.0 : 0.0
            Behavior on opacity { NumberAnimation { duration: 250 } }

            Column {
                anchors.centerIn: parent
                anchors.verticalCenterOffset: -20
                width: 680
                spacing: 28

                // Center screen outline with lock icon (Matching user photo)
                Image {
                    source: "qrc:/ApexVision/qml/assets/icons/icon_valet_mode.png"
                    width: 72
                    height: 60
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                }

                // Two explanatory warning paragraphs
                Column {
                    width: parent.width
                    spacing: 16

                    Text {
                        width: parent.width
                        wrapMode: Text.WordWrap
                        text: "Valet mode lets you lock the center screen before you leave your vehicle. You can choose a different PIN each time you turn valet mode on."
                        font.family: "Inter"
                        font.pixelSize: 19
                        font.weight: Font.DemiBold
                        lineHeight: 1.45
                        color: "#FFFFFF"
                    }

                    Text {
                        width: parent.width
                        wrapMode: Text.WordWrap
                        text: "The same PIN must be entered to disable Valet Mode and unlock the system."
                        font.family: "Inter"
                        font.pixelSize: 19
                        font.weight: Font.DemiBold
                        lineHeight: 1.45
                        color: "#FFFFFF"
                    }
                }

                Item { width: 1; height: 8 }

                // Next Pill Button
                Rectangle {
                    id: nextBtn
                    width: 156
                    height: 50
                    radius: 25
                    color: nextMouse.pressed ? Qt.rgba(255, 255, 255, 0.35) :
                           (nextMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.25) : Qt.rgba(255, 255, 255, 0.16))
                    border.color: Qt.rgba(255, 255, 255, 0.60)
                    border.width: 1.5
                    Behavior on color { ColorAnimation { duration: 150 } }

                    Text {
                        anchors.centerIn: parent
                        text: "Next"
                        font.family: "Inter"
                        font.pixelSize: 18
                        font.weight: Font.Bold
                        color: "#FFFFFF"
                    }

                    MouseArea {
                        id: nextMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            root.valetStep = 2;
                            root.enteredPin = "";
                            root.tempPin = "";
                            root.pinConfirmStep = false;
                            root.valetErrorMessage = "";
                        }
                    }
                }
            }
        }

        // Step 2: Set PIN Screen (Keypad entry + confirmation, whole screen centered)
        Item {
            id: valetPinSetupStep
            anchors.fill: parent
            visible: root.valetStep === 2
            opacity: root.valetStep === 2 ? 1.0 : 0.0
            Behavior on opacity { NumberAnimation { duration: 250 } }

            Column {
                anchors.centerIn: parent
                anchors.verticalCenterOffset: -10
                spacing: 20
                width: 380

                // Prompt
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: root.pinConfirmStep ? "Re-enter PIN to confirm" : "Enter a 4-digit PIN"
                    font.family: "Inter"
                    font.pixelSize: 22
                    font.weight: Font.Bold
                    color: "#FFFFFF"
                }

                // Error text or subtext
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: root.valetErrorMessage !== "" ? root.valetErrorMessage : (root.pinConfirmStep ? "Confirm the 4-digit PIN for this session" : "Choose a 4-digit PIN to lock the screen")
                    font.family: "Inter"
                    font.pixelSize: 15
                    color: root.valetErrorMessage !== "" ? "#FF4D4D" : "#FFFFFF"
                    font.weight: Font.Medium
                }

                // 4 PIN Dots
                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 20

                    Repeater {
                        model: 4
                        Rectangle {
                            width: 22
                            height: 22
                            radius: 11
                            color: index < root.enteredPin.length ? "#F59E0B" : "transparent"
                            border.color: index < root.enteredPin.length ? "#F59E0B" : Qt.rgba(255, 255, 255, 0.35)
                            border.width: 2
                            Behavior on color { ColorAnimation { duration: 120 } }
                        }
                    }
                }

                Item { width: 1; height: 10 }

                // 3x4 Numeric Keypad
                Grid {
                    anchors.horizontalCenter: parent.horizontalCenter
                    columns: 3
                    spacing: 14

                    Repeater {
                        model: [
                            { label: "1", val: "1" },
                            { label: "2", val: "2" },
                            { label: "3", val: "3" },
                            { label: "4", val: "4" },
                            { label: "5", val: "5" },
                            { label: "6", val: "6" },
                            { label: "7", val: "7" },
                            { label: "8", val: "8" },
                            { label: "9", val: "9" },
                            { label: "Clear", val: "clear" },
                            { label: "0", val: "0" },
                            { label: "⌫", val: "back" }
                        ]

                        Rectangle {
                            width: 90
                            height: 56
                            radius: 16
                            color: keyMouse.pressed ? Qt.rgba(255, 255, 255, 0.22) :
                                   (keyMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.14) : Qt.rgba(255, 255, 255, 0.08))
                            border.color: Qt.rgba(255, 255, 255, 0.18)
                            border.width: 1
                            Behavior on color { ColorAnimation { duration: 120 } }

                            Text {
                                anchors.centerIn: parent
                                text: modelData.label
                                font.family: "Inter"
                                font.pixelSize: modelData.val === "clear" ? 14 : 20
                                font.weight: Font.DemiBold
                                color: "#FFFFFF"
                            }

                            MouseArea {
                                id: keyMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: root.handleKeypadInput(modelData.val)
                            }
                        }
                    }
                }
            }
        }
    }

    // =========================================================================
    // Reusable Vehicle Menu Card Component (Dark Translucent Slate)
    // =========================================================================
    component VehicleMenuCard: Rectangle {
        id: card

        property string iconSource: ""
        property string titleText: ""
        property bool isActive: false
        property bool showActiveDot: false
        property color activeDotColor: "#38BDF8"
        property bool hasActiveBorder: false
        property color activeBorderColor: "#F59E0B"
        signal cardClicked()

        radius: 18
        clip: true

        // Very Light Frosted Glass Fill
        gradient: Gradient {
            GradientStop {
                position: 0.0
                color: cardMouseArea.pressed ?
                    Qt.rgba(215/255, 238/255, 255/255, 0.32) :
                    (cardMouseArea.containsMouse ? Qt.rgba(225/255, 242/255, 255/255, 0.24) :
                    ((card.isActive && card.hasActiveBorder) ? Qt.rgba(225/255, 242/255, 255/255, 0.22) : Qt.rgba(215/255, 238/255, 255/255, 0.17)))
            }
            GradientStop {
                position: 1.0
                color: cardMouseArea.pressed ?
                    Qt.rgba(195/255, 225/255, 255/255, 0.26) :
                    (cardMouseArea.containsMouse ? Qt.rgba(205/255, 232/255, 255/255, 0.18) :
                    ((card.isActive && card.hasActiveBorder) ? Qt.rgba(205/255, 232/255, 255/255, 0.16) : Qt.rgba(195/255, 225/255, 255/255, 0.11)))
            }
        }

        // Luminous Light Glass Border, or active border highlight (e.g. yellow for Auto Hold when on)
        border.color: (card.isActive && card.hasActiveBorder) ?
            card.activeBorderColor :
            (cardMouseArea.containsMouse ? Qt.rgba(255, 255, 255, 0.65) : Qt.rgba(225/255, 242/255, 255/255, 0.36))
        border.width: (card.isActive && card.hasActiveBorder) ? 2 : 1

        Behavior on border.color { ColorAnimation { duration: 180 } }

        scale: cardMouseArea.pressed ? 0.98 : (cardMouseArea.containsMouse ? 1.015 : 1.0)
        Behavior on scale { NumberAnimation { duration: 150; easing.type: Easing.OutQuad } }

        // Top Specular Glass Reflection (High-gloss chamfer highlight)
        Rectangle {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.topMargin: 1
            anchors.leftMargin: 16
            anchors.rightMargin: 16
            height: 1
            color: (card.isActive && card.hasActiveBorder) ?
                Qt.rgba(245/255, 158/255, 11/255, 0.50) :
                (cardMouseArea.containsMouse ? Qt.rgba(255, 255, 255, 0.60) : Qt.rgba(255, 255, 255, 0.35))
            radius: 1
        }

        // Glowing Top-Left Active Indicator Dot (Matches Auto Hold dot in reference)
        Rectangle {
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.margins: 14
            width: 7
            height: 7
            radius: 3.5
            color: card.activeDotColor
            visible: card.isActive && card.showActiveDot
        }

        // Centered Content Column (Icon + Title)
        Column {
            anchors.centerIn: parent
            spacing: 10

            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                height: 38
                width: 48
                source: card.iconSource
                fillMode: Image.PreserveAspectFit
                smooth: true
                mipmap: true
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: card.titleText
                color: "#F2F5F7"
                font.family: "Inter"
                font.pixelSize: 16
                font.weight: Font.DemiBold
                renderType: Text.NativeRendering
            }
        }

        MouseArea {
            id: cardMouseArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: card.cardClicked()
        }
    }
}
