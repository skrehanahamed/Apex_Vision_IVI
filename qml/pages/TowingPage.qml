import QtQuick
import QtQuick.Controls

Item {
    id: root

    signal backRequested()
    signal openSettingsRequested()

    property int activeTab: 0 // 0: Trailers, 1: Aids

    // =========================================================================
    // DYNAMIC TRAILERS MODEL
    // =========================================================================
    ListModel {
        id: trailerModel
        ListElement {
            name: "Default"
            mileage: "0 mi"
            status: "---"
            trailerType: "Conventional"
            brakeGain: "6.5"
            hitchType: "Weight Carrying Ball"
            trailerLength: "20 ft"
            electricBrakes: true
            blisCovered: true
        }
    }

    // Master subtle dark background gradient
    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: Qt.rgba(7/255, 11/255, 20/255, 0.40) }
            GradientStop { position: 0.5; color: Qt.rgba(7/255, 11/255, 20/255, 0.55) }
            GradientStop { position: 1.0; color: Qt.rgba(7/255, 11/255, 20/255, 0.75) }
        }
    }

    // =========================================================================
    // 1. TOP HEADER BAR: Trailer Icon | Trailers & Aids Tabs | Right Settings
    // =========================================================================
    Item {
        id: headerBar
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 72
        z: 20

        Row {
            id: tabsRow
            anchors.left: parent.left
            anchors.leftMargin: 36
            anchors.verticalCenter: parent.verticalCenter
            spacing: 24

            // Small Blue Trailer Badge (Matching Screenshot 2)
            Rectangle {
                width: 42
                height: 42
                radius: 21
                color: "#1E88E5"
                anchors.verticalCenter: parent.verticalCenter

                Image {
                    anchors.centerIn: parent
                    width: 26
                    height: 26
                    source: "qrc:/ApexVision/qml/assets/icons/app_trailer.svg"
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                }
            }

            // Tab 1: Trailers
            Item {
                id: trailersTabItem
                width: trailersText.implicitWidth + 12
                height: 48
                anchors.verticalCenter: parent.verticalCenter

                Text {
                    id: trailersText
                    anchors.centerIn: parent
                    text: "Trailers"
                    color: root.activeTab === 0 ? "#FFFFFF" : Qt.rgba(255, 255, 255, 0.65)
                    font.family: "Inter"
                    font.pixelSize: 24
                    font.weight: root.activeTab === 0 ? Font.DemiBold : Font.Normal
                    Behavior on color { ColorAnimation { duration: 150 } }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.activeTab = 0
                }
            }

            // Tab 2: Aids
            Item {
                id: aidsTabItem
                width: aidsText.implicitWidth + 12
                height: 48
                anchors.verticalCenter: parent.verticalCenter

                Text {
                    id: aidsText
                    anchors.centerIn: parent
                    text: "Aids"
                    color: root.activeTab === 1 ? "#FFFFFF" : Qt.rgba(255, 255, 255, 0.65)
                    font.family: "Inter"
                    font.pixelSize: 24
                    font.weight: root.activeTab === 1 ? Font.DemiBold : Font.Normal
                    Behavior on color { ColorAnimation { duration: 150 } }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.activeTab = 1
                }
            }
        }

        // Signature Warm Gold / Cream Sliding Active Underline (Screenshot 2)
        Rectangle {
            id: tabUnderline
            anchors.bottom: headerBar.bottom
            anchors.bottomMargin: 8
            height: 3.5
            radius: 2
            color: "#F6D38B"
            x: root.activeTab === 0 ? (tabsRow.x + trailersTabItem.x) : (tabsRow.x + aidsTabItem.x)
            width: root.activeTab === 0 ? trailersTabItem.width : aidsTabItem.width
            Behavior on x { NumberAnimation { duration: 240; easing.type: Easing.OutCubic } }
            Behavior on width { NumberAnimation { duration: 240; easing.type: Easing.OutCubic } }
        }

        // Right Settings Button (Matching Screenshot 2)
        Item {
            id: settingsBtn
            anchors.right: parent.right
            anchors.rightMargin: 36
            anchors.verticalCenter: parent.verticalCenter
            width: 48
            height: 48

            Rectangle {
                anchors.fill: parent
                radius: 24
                color: settingsMouse.pressed ? Qt.rgba(255, 255, 255, 0.20) : (settingsMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.08) : "transparent")
                scale: settingsMouse.pressed ? 0.92 : 1.0
                Behavior on scale { NumberAnimation { duration: 120 } }
                Behavior on color { ColorAnimation { duration: 150 } }
            }

            Image {
                anchors.centerIn: parent
                width: 32
                height: 32
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
                    root.openSettingsRequested();
                }
            }
        }
    }

    // =========================================================================
    // 2. MAIN CONTENT AREA: TAB 0 (Trailers) | TAB 1 (Aids)
    // =========================================================================
    Item {
        id: contentContainer
        anchors.top: headerBar.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        clip: true

        // ---------------------------------------------------------------------
        // TAB 0: TRAILERS LIST & ADD TRAILER (Matching Screenshot 2 & vehiclebar)
        // ---------------------------------------------------------------------
        Flickable {
            id: trailersFlickable
            width: parent.width
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            contentWidth: trailersRow.width + 160
            contentHeight: height
            visible: opacity > 0.001
            opacity: root.activeTab === 0 ? 1.0 : 0.0
            x: root.activeTab === 0 ? 0 : -contentContainer.width
            enabled: root.activeTab === 0
            Behavior on x { NumberAnimation { duration: 320; easing.type: Easing.OutCubic } }
            Behavior on opacity { NumberAnimation { duration: 260; easing.type: Easing.InOutQuad } }
            clip: true
            boundsBehavior: Flickable.DragAndOvershootBounds

            Row {
                id: trailersRow
                anchors.left: parent.left
                anchors.leftMargin: 100
                anchors.top: parent.top
                anchors.topMargin: 36
                spacing: 52

                // Dynamic Trailer Cards (VehicleMenuCard Theme Colors & Dimensions)
                Repeater {
                    model: trailerModel

                    // Trailer Card
                    Rectangle {
                        id: trailerCard
                        width: 260
                        height: 280
                        radius: 18
                        clip: true

                        // VehicleMenuCard Frosted Glass Gradient
                        gradient: Gradient {
                            GradientStop {
                                position: 0.0
                                color: trailerCardMouse.pressed ?
                                    Qt.rgba(215/255, 238/255, 255/255, 0.28) :
                                    (trailerCardMouse.containsMouse ? Qt.rgba(225/255, 242/255, 255/255, 0.22) : Qt.rgba(215/255, 238/255, 255/255, 0.17))
                            }
                            GradientStop {
                                position: 1.0
                                color: trailerCardMouse.pressed ?
                                    Qt.rgba(195/255, 225/255, 255/255, 0.22) :
                                    (trailerCardMouse.containsMouse ? Qt.rgba(205/255, 232/255, 255/255, 0.16) : Qt.rgba(195/255, 225/255, 255/255, 0.11))
                            }
                        }

                        // Luminous Light Glass Border
                        border.color: trailerCardMouse.containsMouse ?
                            Qt.rgba(255, 255, 255, 0.65) :
                            Qt.rgba(225/255, 242/255, 255/255, 0.36)
                        border.width: 1

                        Behavior on border.color { ColorAnimation { duration: 180 } }

                        scale: trailerCardMouse.pressed ? 0.98 : (trailerCardMouse.containsMouse ? 1.02 : 1.0)
                        Behavior on scale { NumberAnimation { duration: 150; easing.type: Easing.OutQuad } }

                        // Top Specular Glass Reflection
                        Rectangle {
                            anchors.top: parent.top
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.topMargin: 1
                            anchors.leftMargin: 16
                            anchors.rightMargin: 16
                            height: 1
                            color: trailerCardMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.60) : Qt.rgba(255, 255, 255, 0.35)
                            radius: 1
                        }

                        // Card Content
                        Column {
                            anchors.top: parent.top
                            anchors.left: parent.left
                            anchors.margins: 24
                            spacing: 10

                            Text {
                                text: model.name
                                color: "#FFFFFF"
                                font.family: "Inter"
                                font.pixelSize: 26
                                font.weight: Font.Bold
                            }

                            Text {
                                text: model.mileage
                                color: Qt.rgba(255, 255, 255, 0.88)
                                font.family: "Inter"
                                font.pixelSize: 19
                                font.weight: Font.Normal
                            }

                            Text {
                                text: model.status
                                color: Qt.rgba(255, 255, 255, 0.55)
                                font.family: "Inter"
                                font.pixelSize: 19
                            }
                        }

                        // Bottom Details Button (Matching Screenshot 2)
                        Item {
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: 20
                            anchors.horizontalCenter: parent.horizontalCenter
                            width: detailsText.implicitWidth + 32
                            height: 38

                            Rectangle {
                                anchors.fill: parent
                                radius: 19
                                color: detailsMouse.pressed ? Qt.rgba(255, 255, 255, 0.18) : (detailsMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.08) : "transparent")
                            }

                            Text {
                                id: detailsText
                                anchors.centerIn: parent
                                text: "Details"
                                color: "#FFFFFF"
                                font.family: "Inter"
                                font.pixelSize: 18
                                font.weight: Font.Medium
                            }

                            MouseArea {
                                id: detailsMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    detailsModal.trailerName = model.name;
                                    detailsModal.trailerMileage = model.mileage;
                                    detailsModal.trailerType = model.trailerType || "Conventional";
                                    detailsModal.trailerGain = model.brakeGain || "6.5";
                                    detailsModal.hitchType = model.hitchType || "Weight Carrying Ball";
                                    detailsModal.trailerLength = model.trailerLength || "20 ft";
                                    detailsModal.open();
                                }
                            }
                        }

                        MouseArea {
                            id: trailerCardMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                detailsModal.trailerName = model.name;
                                detailsModal.trailerMileage = model.mileage;
                                detailsModal.trailerType = model.trailerType || "Conventional";
                                detailsModal.trailerGain = model.brakeGain || "6.5";
                                detailsModal.hitchType = model.hitchType || "Weight Carrying Ball";
                                detailsModal.trailerLength = model.trailerLength || "20 ft";
                                detailsModal.open();
                            }
                        }
                    }
                }

                // Add Trailer Item (+ Large Circle & Label matching Screenshot 2)
                Item {
                    width: 160
                    height: 280

                    Column {
                        anchors.centerIn: parent
                        spacing: 18

                        // Large Blue Circular Plus Button (Scaled up per user request)
                        Rectangle {
                            id: plusCircle
                            width: 80
                            height: 80
                            radius: 40
                            anchors.horizontalCenter: parent.horizontalCenter
                            color: plusMouse.pressed ? Qt.rgba(30/255, 136/255, 229/255, 0.80) : (plusMouse.containsMouse ? Qt.rgba(30/255, 136/255, 229/255, 0.65) : Qt.rgba(30/255, 136/255, 229/255, 0.50))
                            border.color: Qt.rgba(100/255, 181/255, 246/255, 0.70)
                            border.width: 1.5
                            scale: plusMouse.pressed ? 0.92 : (plusMouse.containsMouse ? 1.06 : 1.0)
                            Behavior on scale { NumberAnimation { duration: 160; easing.type: Easing.OutBack } }

                            Text {
                                anchors.centerIn: parent
                                text: "+"
                                color: "#FFFFFF"
                                font.family: "Inter"
                                font.pixelSize: 42
                                font.weight: Font.Light
                            }

                            MouseArea {
                                id: plusMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: addTrailerModal.open()
                            }
                        }

                        // "Add trailer" Text Label
                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "Add trailer"
                            color: "#FFFFFF"
                            font.family: "Inter"
                            font.pixelSize: 20
                            font.weight: Font.Medium
                        }
                    }
                }

            }
        }

        // ---------------------------------------------------------------------
        // TAB 1: AIDS (Matching vehiclebar VehicleMenuCard Theme, Icons & Toggles)
        // ---------------------------------------------------------------------
        Flickable {
            id: aidsFlickable
            width: parent.width
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            contentWidth: width
            contentHeight: aidsGrid.height + 60
            visible: opacity > 0.001
            opacity: root.activeTab === 1 ? 1.0 : 0.0
            x: root.activeTab === 1 ? 0 : contentContainer.width
            enabled: root.activeTab === 1
            Behavior on x { NumberAnimation { duration: 320; easing.type: Easing.OutCubic } }
            Behavior on opacity { NumberAnimation { duration: 260; easing.type: Easing.InOutQuad } }
            clip: true
            boundsBehavior: Flickable.DragAndOvershootBounds

            Grid {
                id: aidsGrid
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 28
                columns: 2
                spacing: 20

                // Aid 1: Trailer Blind Spot (BLIS)
                TowingAidCard {
                    iconSource: "qrc:/ApexVision/qml/assets/icons/setting_driver_assist_white.png"
                    titleText: "Trailer Blind Spot (BLIS)"
                    subtitleText: "Extends radar zone behind trailer up to 33 ft"
                    checked: true
                }

                // Aid 2: Pro Trailer Backup Assist & Hitch Guidance
                TowingAidCard {
                    iconSource: "qrc:/ApexVision/qml/assets/icons/setting_vehicle_white.png"
                    titleText: "Pro Trailer Backup Assist"
                    subtitleText: "Dynamic trailer steering lines & hitch angle tracking"
                    checked: true
                }

                // Aid 3: Automated Light Check Sequence
                TowingAidCard {
                    iconSource: "qrc:/ApexVision/qml/assets/icons/icon_auto_hold.png"
                    titleText: "Automated Light Check"
                    subtitleText: "Runs cycle of turn, brake, hazard & reverse lamps"
                    checked: false
                }

                // Aid 4: Integrated Trailer Brake Controller
                TowingAidCard {
                    id: brakeCard
                    iconSource: "qrc:/ApexVision/qml/assets/icons/icon_tire_pressure.png"
                    titleText: "Trailer Brake Gain"
                    property real gainVal: 6.5
                    subtitleText: "Electric brake gain: " + gainVal.toFixed(1) + " (Heavy Load)"
                    checked: true
                    isToggleable: false

                    // Custom minus / plus gain adjuster inside the card
                    Row {
                        anchors.right: parent.right
                        anchors.rightMargin: 18
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 8

                        Rectangle {
                            width: 38
                            height: 38
                            radius: 19
                            color: brakeMinusMouse.pressed ? Qt.rgba(255, 255, 255, 0.25) : (brakeMinusMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.16) : Qt.rgba(255, 255, 255, 0.10))
                            border.color: Qt.rgba(255, 255, 255, 0.25)
                            border.width: 1

                            Text {
                                anchors.centerIn: parent
                                text: "−"
                                color: "#FFFFFF"
                                font.family: "Inter"
                                font.pixelSize: 20
                                font.weight: Font.DemiBold
                            }

                            MouseArea {
                                id: brakeMinusMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    brakeCard.gainVal = Math.max(0.0, brakeCard.gainVal - 0.5);
                                }
                            }
                        }

                        Rectangle {
                            width: 38
                            height: 38
                            radius: 19
                            color: brakePlusMouse.pressed ? Qt.rgba(255, 255, 255, 0.25) : (brakePlusMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.16) : Qt.rgba(255, 255, 255, 0.10))
                            border.color: Qt.rgba(255, 255, 255, 0.25)
                            border.width: 1

                            Text {
                                anchors.centerIn: parent
                                text: "+"
                                color: "#FFFFFF"
                                font.family: "Inter"
                                font.pixelSize: 20
                                font.weight: Font.DemiBold
                            }

                            MouseArea {
                                id: brakePlusMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    brakeCard.gainVal = Math.min(10.0, brakeCard.gainVal + 0.5);
                                }
                            }
                        }
                    }
                }

                // Aid 5: Trailer Sway Control
                TowingAidCard {
                    iconSource: "qrc:/ApexVision/qml/assets/icons/setting_driver_assistance_white.png"
                    titleText: "Trailer Sway Control"
                    subtitleText: "Selective asymmetric wheel braking on sway detection"
                    checked: true
                }

                // Aid 6: Tow / Haul Powertrain Mode
                TowingAidCard {
                    iconSource: "qrc:/ApexVision/qml/assets/icons/icon_units_speedo.svg"
                    titleText: "Tow / Haul Mode"
                    subtitleText: "Enhanced engine braking & high-torque shift patterns"
                    checked: true
                }
            }
        }
    }

    // =========================================================================
    // Reusable Towing Aid Card Component (Matching VehicleMenuCard theme & toggles)
    // =========================================================================
    component TowingAidCard: Rectangle {
        id: aidCard

        property string iconSource: ""
        property string titleText: ""
        property string subtitleText: ""
        property bool checked: false
        property bool isToggleable: true
        signal cardToggled(bool isChecked)

        width: 470
        height: 118
        radius: 18
        clip: true

        // VehicleMenuCard Frosted Glass Gradient Fill
        gradient: Gradient {
            GradientStop {
                position: 0.0
                color: aidMouse.pressed ?
                    Qt.rgba(215/255, 238/255, 255/255, 0.30) :
                    (aidMouse.containsMouse ? Qt.rgba(225/255, 242/255, 255/255, 0.22) : Qt.rgba(215/255, 238/255, 255/255, 0.16))
            }
            GradientStop {
                position: 1.0
                color: aidMouse.pressed ?
                    Qt.rgba(195/255, 225/255, 255/255, 0.24) :
                    (aidMouse.containsMouse ? Qt.rgba(205/255, 232/255, 255/255, 0.16) : Qt.rgba(195/255, 225/255, 255/255, 0.10))
            }
        }

        // Luminous Frosted Glass Border (Clean, uniform, no yellow border)
        border.color: aidMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.65) : Qt.rgba(225/255, 242/255, 255/255, 0.36)
        border.width: 1
        Behavior on border.color { ColorAnimation { duration: 180 } }

        scale: aidMouse.pressed ? 0.98 : (aidMouse.containsMouse ? 1.015 : 1.0)
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
            color: aidMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.60) : Qt.rgba(255, 255, 255, 0.35)
            radius: 1
        }

        // Left Automotive Icon Container (Borderless, Clean)
        Item {
            id: iconBox
            anchors.left: parent.left
            anchors.leftMargin: 22
            anchors.verticalCenter: parent.verticalCenter
            width: 44
            height: 44

            Image {
                anchors.centerIn: parent
                width: 36
                height: 36
                source: aidCard.iconSource
                fillMode: Image.PreserveAspectFit
                smooth: true
                mipmap: true
            }
        }

        // Title and Subtitle Column
        Column {
            anchors.left: iconBox.right
            anchors.leftMargin: 16
            anchors.right: aidToggle.left
            anchors.rightMargin: 16
            anchors.verticalCenter: parent.verticalCenter
            spacing: 5

            Text {
                width: parent.width
                text: aidCard.titleText
                color: "#F2F5F7"
                font.family: "Inter"
                font.pixelSize: 16
                font.weight: Font.DemiBold
                elide: Text.ElideRight
            }

            Text {
                width: parent.width
                text: aidCard.subtitleText
                color: Qt.rgba(225/255, 242/255, 255/255, 0.70)
                font.family: "Inter"
                font.pixelSize: 13
                wrapMode: Text.WordWrap
            }
        }

        // OEM Vehiclebar-style Toggle Switch
        Rectangle {
            id: aidToggle
            anchors.right: parent.right
            anchors.rightMargin: 20
            anchors.verticalCenter: parent.verticalCenter
            width: 58
            height: 32
            radius: 16
            color: aidCard.checked ? "#F59E0B" : Qt.rgba(255, 255, 255, 0.16)
            border.color: aidCard.checked ? "#F59E0B" : Qt.rgba(255, 255, 255, 0.30)
            border.width: 1
            visible: aidCard.isToggleable

            Behavior on color { ColorAnimation { duration: 150 } }

            // Sliding thumb
            Rectangle {
                width: 26
                height: 26
                radius: 13
                color: "#FFFFFF"
                anchors.verticalCenter: parent.verticalCenter
                x: aidCard.checked ? parent.width - width - 3 : 3
                Behavior on x { NumberAnimation { duration: 180; easing.type: Easing.OutQuad } }
            }
        }

        MouseArea {
            id: aidMouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                if (aidCard.isToggleable) {
                    aidCard.checked = !aidCard.checked;
                    aidCard.cardToggled(aidCard.checked);
                }
            }
        }
    }



    // =========================================================================
    // MODAL: TRAILER DETAILS
    // =========================================================================
    Rectangle {
        id: detailsModal
        anchors.fill: parent
        color: Qt.rgba(0, 0, 0, 0.65)
        visible: opacity > 0.001
        opacity: 0.0
        z: 600

        property string trailerName: "Default"
        property string trailerMileage: "0 mi"
        property string trailerType: "Conventional"
        property string trailerGain: "6.5"
        property string hitchType: "Weight Carrying Ball"
        property string trailerLength: "20 ft"

        function open() { opacity = 1.0; }
        function close() { opacity = 0.0; }

        Behavior on opacity { NumberAnimation { duration: 200 } }

        MouseArea { anchors.fill: parent; onClicked: detailsModal.close() }

        Rectangle {
            anchors.centerIn: parent
            width: 440
            height: 380
            radius: 20
            color: "#0F172A"
            border.color: Qt.rgba(255, 255, 255, 0.25)
            border.width: 1

            MouseArea { anchors.fill: parent }

            Column {
                anchors.fill: parent
                anchors.margins: 28
                spacing: 16

                Text {
                    text: detailsModal.trailerName + " Trailer Profile"
                    color: "#FFFFFF"
                    font.family: "Inter"
                    font.pixelSize: 22
                    font.weight: Font.Bold
                }

                Rectangle { width: parent.width; height: 1; color: Qt.rgba(255, 255, 255, 0.12) }

                Column {
                    spacing: 12
                    width: parent.width

                    Row {
                        width: parent.width
                        Text { text: "Accumulated Distance:"; color: Qt.rgba(255, 255, 255, 0.65); font.pixelSize: 15; width: 200 }
                        Text { text: detailsModal.trailerMileage; color: "#FFFFFF"; font.pixelSize: 15; font.weight: Font.Medium }
                    }
                    Row {
                        width: parent.width
                        Text { text: "Hitch Connection:"; color: Qt.rgba(255, 255, 255, 0.65); font.pixelSize: 15; width: 200 }
                        Text { text: detailsModal.hitchType; color: "#FFFFFF"; font.pixelSize: 15; font.weight: Font.Medium }
                    }
                    Row {
                        width: parent.width
                        Text { text: "Brake Gain Preset:"; color: Qt.rgba(255, 255, 255, 0.65); font.pixelSize: 15; width: 200 }
                        Text { text: detailsModal.trailerGain + " (Electric)"; color: "#64B5F6"; font.pixelSize: 15; font.weight: Font.Medium }
                    }
                    Row {
                        width: parent.width
                        Text { text: "Calibrated Length:"; color: Qt.rgba(255, 255, 255, 0.65); font.pixelSize: 15; width: 200 }
                        Text { text: detailsModal.trailerLength; color: "#FFFFFF"; font.pixelSize: 15; font.weight: Font.Medium }
                    }
                    Row {
                        width: parent.width
                        Text { text: "7-Pin Harness Status:"; color: Qt.rgba(255, 255, 255, 0.65); font.pixelSize: 15; width: 200 }
                        Text { text: "Connected & Secure"; color: "#4CAF50"; font.pixelSize: 15; font.weight: Font.Medium }
                    }
                }

                Item { width: 1; height: 8 }

                Rectangle {
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: 140
                    height: 40
                    radius: 20
                    color: "#1E88E5"

                    Text {
                        anchors.centerIn: parent
                        text: "Done"
                        color: "#FFFFFF"
                        font.family: "Inter"
                        font.pixelSize: 16
                        font.weight: Font.DemiBold
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: detailsModal.close()
                    }
                }
            }
        }
    }

    // =========================================================================
    // MODAL: ADD TRAILER WIZARD
    // =========================================================================
    Rectangle {
        id: addTrailerModal
        anchors.fill: parent
        color: Qt.rgba(0, 0, 0, 0.65)
        visible: opacity > 0.001
        opacity: 0.0
        z: 600

        function open() {
            trailerInput.text = "Camper";
            opacity = 1.0;
        }
        function close() { opacity = 0.0; }

        Behavior on opacity { NumberAnimation { duration: 200 } }

        MouseArea { anchors.fill: parent; onClicked: addTrailerModal.close() }

        Rectangle {
            anchors.centerIn: parent
            width: 440
            height: 340
            radius: 20
            color: "#0F172A"
            border.color: Qt.rgba(255, 255, 255, 0.25)
            border.width: 1

            MouseArea { anchors.fill: parent }

            Column {
                anchors.fill: parent
                anchors.margins: 28
                spacing: 16

                Text {
                    text: "Create Trailer Profile"
                    color: "#FFFFFF"
                    font.family: "Inter"
                    font.pixelSize: 22
                    font.weight: Font.Bold
                }

                Text {
                    text: "Trailer Name:"
                    color: Qt.rgba(255, 255, 255, 0.70)
                    font.pixelSize: 15
                }

                Rectangle {
                    width: parent.width
                    height: 46
                    radius: 10
                    color: Qt.rgba(255, 255, 255, 0.08)
                    border.color: Qt.rgba(255, 255, 255, 0.25)
                    border.width: 1

                    TextInput {
                        id: trailerInput
                        anchors.fill: parent
                        anchors.leftMargin: 14
                        anchors.rightMargin: 14
                        verticalAlignment: TextInput.AlignVCenter
                        text: "Camper"
                        color: "#FFFFFF"
                        font.family: "Inter"
                        font.pixelSize: 16
                    }
                }

                Text {
                    text: "Hitch Type: Conventional Ball | Brake Type: Electric"
                    color: Qt.rgba(255, 255, 255, 0.6)
                    font.pixelSize: 13
                }

                Item { width: 1; height: 10 }

                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 20

                    Rectangle {
                        width: 130
                        height: 42
                        radius: 21
                        color: Qt.rgba(255, 255, 255, 0.12)
                        Text { anchors.centerIn: parent; text: "Cancel"; color: "#FFFFFF"; font.pixelSize: 15 }
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: addTrailerModal.close()
                        }
                    }

                    Rectangle {
                        width: 130
                        height: 42
                        radius: 21
                        color: "#1E88E5"
                        Text { anchors.centerIn: parent; text: "Save Profile"; color: "#FFFFFF"; font.pixelSize: 15; font.weight: Font.Bold }
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                var tName = trailerInput.text.trim();
                                if (tName === "") tName = "New Trailer";
                                trailerModel.append({
                                    name: tName,
                                    mileage: "0 mi",
                                    status: "---",
                                    trailerType: "Conventional",
                                    brakeGain: "6.0",
                                    hitchType: "Weight Carrying Ball",
                                    trailerLength: "22 ft",
                                    electricBrakes: true,
                                    blisCovered: true
                                });
                                addTrailerModal.close();
                            }
                        }
                    }
                }
            }
        }
    }
}
