import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import ApexVision
import ".."

Item {
    id: root

    signal openSettingsRequested()
    signal openAppsRequested()
    signal backRequested()

    Component.onCompleted: {
        if (MediaBackend.source === "AM" && !MediaBackend.isAmAudioPlaying) {
            MediaBackend.startAmPlayback();
        }
    }

    // -------------------------------------------------------------------------
    // BACKGROUND GRADIENT (Matches OEM Cockpit Atmosphere)
    // -------------------------------------------------------------------------
    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: Qt.rgba(7/255, 14/255, 30/255, 0.40) }
            GradientStop { position: 0.5; color: Qt.rgba(9/255, 20/255, 42/255, 0.50) }
            GradientStop { position: 1.0; color: Qt.rgba(5/255, 12/255, 26/255, 0.70) }
        }
    }

    // -------------------------------------------------------------------------
    // FULL SCREEN BLURRED / DIMMED BACKDROP FOR SOURCE MODAL (Matches user requirement)
    // -------------------------------------------------------------------------
    Rectangle {
        id: sourceModalBackdrop
        anchors.fill: parent
        color: Qt.rgba(3/255, 7/255, 18/255, 0.74)
        visible: sourceDropdownMenu.visible
        z: 90

        MouseArea {
            anchors.fill: parent
            onClicked: {
                sourceDropdownMenu.visible = false;
            }
        }
    }

    // -------------------------------------------------------------------------
    // TOP BAR: Source Selector Pill (Left) | Settings Sliders Button (Right)
    // -------------------------------------------------------------------------
    Item {
        id: topBar
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 72
        z: 30

        // Source Dropdown Pill (Matches Screenshot 1 "(•) AM ▼")
        Rectangle {
            id: sourcePill
            anchors.left: parent.left
            anchors.leftMargin: 40
            anchors.verticalCenter: parent.verticalCenter
            width: sourceRow.width + 34
            height: 48
            radius: 24
            color: sourceMouse.pressed ? Qt.rgba(215/255, 238/255, 255/255, 0.28) :
                   (sourceMouse.containsMouse ? Qt.rgba(225/255, 242/255, 255/255, 0.22) : Qt.rgba(20/255, 40/255, 80/255, 0.65))
            border.color: Qt.rgba(255, 255, 255, 0.35)
            border.width: 1

            scale: sourceMouse.pressed ? 0.95 : 1.0
            Behavior on scale { NumberAnimation { duration: 100 } }

            Row {
                id: sourceRow
                anchors.centerIn: parent
                spacing: 10

                // Circular Blue Badge with Antenna Icon
                Rectangle {
                    width: 28
                    height: 28
                    radius: 14
                    color: "#1E88E5"
                    anchors.verticalCenter: parent.verticalCenter

                    Image {
                        anchors.centerIn: parent
                        width: 16
                        height: 16
                        source: "qrc:/ApexVision/qml/assets/icons/radio_source.svg"
                        fillMode: Image.PreserveAspectFit
                        smooth: true
                    }
                }

                Text {
                    text: MediaBackend.source
                    color: "#FFFFFF"
                    font.family: "Inter"
                    font.pixelSize: 19
                    font.weight: Font.DemiBold
                    anchors.verticalCenter: parent.verticalCenter
                }

                Text {
                    text: "▼"
                    color: "#93C5FD"
                    font.family: "Inter"
                    font.pixelSize: 11
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            MouseArea {
                id: sourceMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    sourceDropdownMenu.visible = !sourceDropdownMenu.visible;
                }
            }
        }

        // Settings Sliders Button (Right Edge)
        Item {
            anchors.right: parent.right
            anchors.rightMargin: 40
            anchors.verticalCenter: parent.verticalCenter
            width: 48
            height: 48

            Rectangle {
                anchors.fill: parent
                radius: 24
                color: settingsMouse.pressed ? Qt.rgba(255, 255, 255, 0.16) :
                       (settingsMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.08) : "transparent")
                scale: settingsMouse.pressed ? 0.92 : 1.0
                Behavior on scale { NumberAnimation { duration: 100 } }
            }

            Image {
                anchors.centerIn: parent
                width: 24
                height: 24
                source: "qrc:/ApexVision/qml/assets/icons/setting_sliders_white.svg"
                fillMode: Image.PreserveAspectFit
                smooth: true
            }

            MouseArea {
                id: settingsMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: root.openSettingsRequested()
            }
        }
    }

    // =========================================================================
    // SOURCE MODAL POPUP (Centered in the MIDDLE with screen blur/dim as requested)
    // Options: Apple CarPlay, FM, AM, USB DISK, Bluetooth Audio (No SiriusXM)
    // =========================================================================
    Rectangle {
        id: sourceDropdownMenu
        objectName: "sourceDropdownMenu"
        anchors.centerIn: parent
        width: 360
        height: sourceListCol.implicitHeight + 24
        radius: 20
        color: Qt.rgba(11/255, 18/255, 34/255, 0.98)
        border.color: Qt.rgba(255, 255, 255, 0.20)
        border.width: 1.5
        visible: false
        z: 95

        Column {
            id: sourceListCol
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 12
            spacing: 2

            Repeater {
                model: [
                    { name: "Apple CarPlay", sourceKey: "CarPlay", icon: "qrc:/ApexVision/qml/assets/icons/app_carplay.svg" },
                    { name: "FM", sourceKey: "FM", icon: "qrc:/ApexVision/qml/assets/icons/radio_source.svg" },
                    { name: "AM", sourceKey: "AM", icon: "qrc:/ApexVision/qml/assets/icons/radio_source.svg" },
                    { name: "USB DISK", sourceKey: "USB", icon: "qrc:/ApexVision/qml/assets/icons/usb_source.svg" },
                    { name: "Bluetooth Audio", sourceKey: "Bluetooth", icon: "qrc:/ApexVision/qml/assets/icons/bluetooth.svg" }
                ]

                Item {
                    width: sourceListCol.width
                    height: 60

                    // Row background hover/active
                    Rectangle {
                        anchors.fill: parent
                        radius: 12
                        color: itemMouse.pressed ? Qt.rgba(255, 255, 255, 0.16) :
                               (itemMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.08) :
                               (MediaBackend.source === modelData.sourceKey ? Qt.rgba(30/255, 136/255, 229/255, 0.25) : "transparent"))
                        Behavior on color { ColorAnimation { duration: 120 } }
                    }

                    // Content row: circular blue badge + title
                    Row {
                        anchors.left: parent.left
                        anchors.leftMargin: 16
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 18

                        // Bigger Circular Blue Badge with Icon
                        Rectangle {
                            width: 40
                            height: 40
                            radius: 20
                            color: "#1976D2"
                            anchors.verticalCenter: parent.verticalCenter

                            Image {
                                anchors.centerIn: parent
                                width: 22
                                height: 22
                                source: modelData.icon
                                fillMode: Image.PreserveAspectFit
                                smooth: true
                            }
                        }

                        // Bigger Text Label
                        Text {
                            text: modelData.name
                            color: "#FFFFFF"
                            font.family: "Inter"
                            font.pixelSize: 18
                            font.weight: MediaBackend.source === modelData.sourceKey ? Font.Bold : Font.Medium
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    // Subtle Divider Line (except last item)
                    Rectangle {
                        anchors.bottom: parent.bottom
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.leftMargin: 16
                        anchors.rightMargin: 16
                        height: 1
                        color: Qt.rgba(255, 255, 255, 0.08)
                        visible: index < 4
                    }

                    MouseArea {
                        id: itemMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            MediaBackend.setSource(modelData.sourceKey);
                            sourceDropdownMenu.visible = false;
                        }
                    }
                }
            }
        }
    }

    // -------------------------------------------------------------------------
    // MAIN CONTENT AREA: Radio Controls (Left) | Coral Music Note Visual (Right)
    // Text and icons enlarged to fill the cockpit space beautifully
    // -------------------------------------------------------------------------
    Item {
        id: mainContent
        anchors.top: topBar.bottom
        anchors.bottom: presetBar.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: 40
        anchors.rightMargin: 40
        anchors.topMargin: 10
        anchors.bottomMargin: 10

        // LEFT COLUMN: Station Frequency, Info, and Controls
        Item {
            id: leftCol
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: parent.width * 0.58

            Column {
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                spacing: 20

                // Big Frequency Number & Unit (e.g. 530 kHz or 87.9 MHz)
                Row {
                    spacing: 12
                    Text {
                        id: bigFreqText
                        text: MediaBackend.source === "AM" ? MediaBackend.amFrequency : MediaBackend.frequency
                        color: "#FFFFFF"
                        font.family: "Inter"
                        font.pixelSize: 96
                        font.weight: Font.DemiBold
                        renderType: Text.NativeRendering
                    }

                    Text {
                        text: MediaBackend.source === "AM" ? "kHz" : "MHz"
                        color: "#94A3B8"
                        font.family: "Inter"
                        font.pixelSize: 26
                        font.weight: Font.Medium
                        anchors.baseline: bigFreqText.baseline
                    }
                }

                // Station Name & City (NO mention of "Live Broadcast" as requested)
                Column {
                    spacing: 6
                    Text {
                        text: MediaBackend.source === "AM" ? MediaBackend.amStationName : MediaBackend.station
                        color: "#E2E8F0"
                        font.family: "Inter"
                        font.pixelSize: 32
                        font.weight: Font.DemiBold
                    }

                    Text {
                        text: MediaBackend.source === "AM" ? MediaBackend.amStationCity : MediaBackend.trackTitle
                        color: "#94A3B8"
                        font.family: "Inter"
                        font.pixelSize: 18
                        font.weight: Font.Medium
                    }
                }

                Item { width: 1; height: 10 }

                // Transport Controls: |<<   :::   >>|   ☆+ Save as preset
                Row {
                    spacing: 34
                    anchors.left: parent.left

                    // Previous Station Button |<<
                    Item {
                        width: 56
                        height: 56
                        anchors.verticalCenter: parent.verticalCenter

                        Rectangle {
                            anchors.fill: parent
                            radius: 28
                            color: prevMouse.pressed ? Qt.rgba(255, 255, 255, 0.16) :
                                   (prevMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.08) : "transparent")
                            scale: prevMouse.pressed ? 0.9 : 1.0
                            Behavior on scale { NumberAnimation { duration: 80 } }
                        }

                        Image {
                            anchors.centerIn: parent
                            width: 30
                            height: 30
                            source: "qrc:/ApexVision/qml/assets/icons/skip_prev.svg"
                            fillMode: Image.PreserveAspectFit
                            smooth: true
                        }

                        MouseArea {
                            id: prevMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: MediaBackend.prevRadioStation()
                        }
                    }

                    // Direct Frequency Keypad Button :::
                    Item {
                        width: 56
                        height: 56
                        anchors.verticalCenter: parent.verticalCenter

                        Rectangle {
                            anchors.fill: parent
                            radius: 28
                            color: keypadMouse.pressed ? Qt.rgba(255, 255, 255, 0.16) :
                                   (keypadMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.08) : "transparent")
                            scale: keypadMouse.pressed ? 0.9 : 1.0
                            Behavior on scale { NumberAnimation { duration: 80 } }
                        }

                        Image {
                            anchors.centerIn: parent
                            width: 28
                            height: 28
                            source: "qrc:/ApexVision/qml/assets/icons/radio_keypad.svg"
                            fillMode: Image.PreserveAspectFit
                            smooth: true
                        }

                        MouseArea {
                            id: keypadMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: keypadModal.openKeypad()
                        }
                    }

                    // Next Station Button >>|
                    Item {
                        width: 56
                        height: 56
                        anchors.verticalCenter: parent.verticalCenter

                        Rectangle {
                            anchors.fill: parent
                            radius: 28
                            color: nextMouse.pressed ? Qt.rgba(255, 255, 255, 0.16) :
                                   (nextMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.08) : "transparent")
                            scale: nextMouse.pressed ? 0.9 : 1.0
                            Behavior on scale { NumberAnimation { duration: 80 } }
                        }

                        Image {
                            anchors.centerIn: parent
                            width: 30
                            height: 30
                            source: "qrc:/ApexVision/qml/assets/icons/skip_next.svg"
                            fillMode: Image.PreserveAspectFit
                            smooth: true
                        }

                        MouseArea {
                            id: nextMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: MediaBackend.nextRadioStation()
                        }
                    }

                    // "Save as preset" Button:
                    // If saved/pressed: ONLY pure white glowing star icon (no text)
                    // If not saved: Star with + icon + "Save as preset" text
                    Item {
                        height: 56
                        width: MediaBackend.isCurrentRadioPreset ? 56 : (savePresetRow.width + 24)
                        anchors.verticalCenter: parent.verticalCenter

                        Rectangle {
                            anchors.fill: parent
                            radius: 28
                            color: savePresetMouse.pressed ? Qt.rgba(255, 255, 255, 0.16) :
                                   (savePresetMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.08) : "transparent")
                            scale: savePresetMouse.pressed ? 0.95 : 1.0
                            Behavior on scale { NumberAnimation { duration: 80 } }
                        }

                        Row {
                            id: savePresetRow
                            anchors.centerIn: parent
                            spacing: 10

                            Image {
                                width: MediaBackend.isCurrentRadioPreset ? 34 : 28
                                height: MediaBackend.isCurrentRadioPreset ? 34 : 28
                                source: MediaBackend.isCurrentRadioPreset ?
                                        "qrc:/ApexVision/qml/assets/icons/star_glow_filled.svg" :
                                        "qrc:/ApexVision/qml/assets/icons/preset_star_add.svg"
                                fillMode: Image.PreserveAspectFit
                                smooth: true
                                anchors.verticalCenter: parent.verticalCenter
                            }

                            Text {
                                text: "Save as preset"
                                color: "#E2E8F0"
                                font.family: "Inter"
                                font.pixelSize: 18
                                font.weight: Font.Medium
                                anchors.verticalCenter: parent.verticalCenter
                                visible: !MediaBackend.isCurrentRadioPreset
                            }
                        }

                        MouseArea {
                            id: savePresetMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                MediaBackend.saveCurrentAsPreset();
                                if (MediaBackend.isCurrentRadioPreset) {
                                    var currFreqStr = MediaBackend.source === "AM" ? (MediaBackend.amFrequency + " kHz") : (MediaBackend.frequency + " MHz");
                                    saveNotification.showToast("Preset saved: " + currFreqStr);
                                } else {
                                    saveNotification.showToast("Preset removed");
                                }
                            }
                        }
                    }
                }
            }
        }

        // RIGHT COLUMN: Music Note Visual Card (Enlarged, only coral note icon, no circle border, no play/pause)
        Item {
            id: rightCol
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: parent.width * 0.42

            Rectangle {
                id: musicCard
                anchors.centerIn: parent
                width: 270
                height: 270
                radius: 32
                gradient: Gradient {
                    GradientStop { position: 0.0; color: Qt.rgba(20/255, 45/255, 95/255, 0.55) }
                    GradientStop { position: 1.0; color: Qt.rgba(10/255, 25/255, 60/255, 0.75) }
                }
                border.color: Qt.rgba(255, 255, 255, 0.20)
                border.width: 1.5

                // Coral Double Note Vector Icon (ONLY icon, no circle border, no play/pause)
                Image {
                    id: coralNoteIcon
                    anchors.centerIn: parent
                    width: 135
                    height: 135
                    source: "qrc:/ApexVision/qml/assets/icons/music_note_coral.svg"
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                    mipmap: true
                }
            }
        }
    }

    // -------------------------------------------------------------------------
    // BOTTOM PRESET BAR: (Unified AM & FM stored together - cross-band direct switching)
    // -------------------------------------------------------------------------
    Item {
        id: presetBar
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: 40
        anchors.rightMargin: 40
        anchors.bottomMargin: 14
        height: 72
        visible: MediaBackend.radioPresets.length > 0

        Row {
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            spacing: 16

            Repeater {
                model: MediaBackend.radioPresets

                Item {
                    width: 136
                    height: 56
                    anchors.verticalCenter: parent.verticalCenter

                    readonly property bool isActivePreset: (MediaBackend.activeRadioPresetIndex === index) ||
                        (MediaBackend.source === modelData.band && (MediaBackend.source === "AM" ? MediaBackend.amFrequency : MediaBackend.frequency) === modelData.frequency)

                    // Highlight Pill around active preset
                    Rectangle {
                        anchors.fill: parent
                        radius: 14
                        color: parent.isActivePreset ?
                               Qt.rgba(215/255, 238/255, 255/255, 0.24) :
                               (presetItemMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.10) : Qt.rgba(255, 255, 255, 0.05))
                        border.color: parent.isActivePreset ?
                                      Qt.rgba(255, 255, 255, 0.55) : Qt.rgba(255, 255, 255, 0.15)
                        border.width: parent.isActivePreset ? 1.5 : 1

                        scale: presetItemMouse.pressed ? 0.94 : 1.0
                        Behavior on scale { NumberAnimation { duration: 100 } }
                        Behavior on color { ColorAnimation { duration: 150 } }
                    }

                    Row {
                        anchors.centerIn: parent
                        spacing: 8

                        // Band Tag (AM / FM)
                        Rectangle {
                            width: 32
                            height: 22
                            radius: 6
                            color: modelData.band === "FM" ? "#2563EB" : "#D97706"
                            anchors.verticalCenter: parent.verticalCenter

                            Text {
                                anchors.centerIn: parent
                                text: modelData.band
                                color: "#FFFFFF"
                                font.family: "Inter"
                                font.pixelSize: 11
                                font.weight: Font.Bold
                            }
                        }

                        // Frequency
                        Text {
                            text: modelData.frequency
                            color: parent.parent.isActivePreset ? "#FFFFFF" : "#CBD5E1"
                            font.family: "Inter"
                            font.pixelSize: 20
                            font.weight: parent.parent.isActivePreset ? Font.Bold : Font.DemiBold
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    MouseArea {
                        id: presetItemMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            MediaBackend.selectRadioPreset(index);
                        }
                    }
                }
            }
        }
    }

    // -------------------------------------------------------------------------
    // DIRECT TUNE FULL VIEW (Matches Screenshot 1 & 2 exactly with centered Enter button)
    // -------------------------------------------------------------------------
    Item {
        id: keypadModal
        objectName: "keypadModal"
        anchors.fill: parent
        visible: opacity > 0.001
        opacity: 0.0
        z: 200

        property string enteredFreq: ""

        Behavior on opacity { NumberAnimation { duration: 220 } }

        function openKeypad() {
            enteredFreq = "";
            opacity = 1.0;
        }

        function closeKeypad() {
            opacity = 0.0;
        }

        // Master Default Background (Matches OEM Default Background)
        Image {
            anchors.fill: parent
            source: "qrc:/ApexVision/qml/assets/default_background.png"
            fillMode: Image.PreserveAspectCrop
            smooth: true
            z: 0
        }

        // Dark Cockpit Tint
        Rectangle {
            anchors.fill: parent
            color: Qt.rgba(5/255, 11/255, 22/255, 0.48)
            z: 1
        }

        // Mouse blocker: prevents clicks from leaking to AM screen below
        MouseArea {
            anchors.fill: parent
            z: 2
            onClicked: {}
        }

        // Header: Back Arrow, Blue Antenna Badge, "Direct Tune"
        Item {
            id: directTuneHeader
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: 72
            z: 10

            Row {
                anchors.left: parent.left
                anchors.leftMargin: 36
                anchors.verticalCenter: parent.verticalCenter
                spacing: 18

                // Back Arrow Button
                Item {
                    width: 44
                    height: 44
                    anchors.verticalCenter: parent.verticalCenter

                    Rectangle {
                        anchors.fill: parent
                        radius: 22
                        color: backMouse.pressed ? Qt.rgba(255, 255, 255, 0.16) :
                               (backMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.08) : "transparent")
                    }

                    Text {
                        anchors.centerIn: parent
                        text: "←"
                        color: "#FFFFFF"
                        font.family: "Inter"
                        font.pixelSize: 28
                        font.weight: Font.DemiBold
                    }

                    MouseArea {
                        id: backMouse
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: keypadModal.closeKeypad()
                    }
                }

                // Circular Blue Badge with Antenna Icon
                Rectangle {
                    width: 32
                    height: 32
                    radius: 16
                    color: "#1E88E5"
                    anchors.verticalCenter: parent.verticalCenter

                    Image {
                        anchors.centerIn: parent
                        width: 18
                        height: 18
                        source: "qrc:/ApexVision/qml/assets/icons/radio_source.svg"
                        fillMode: Image.PreserveAspectFit
                        smooth: true
                    }
                }

                // "Direct Tune" Title
                Text {
                    text: "Direct Tune"
                    color: "#FFFFFF"
                    font.family: "Inter"
                    font.pixelSize: 22
                    font.weight: Font.DemiBold
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }

        // MAIN BODY: Keypad + Centered Enter Button (Left) | Frequency Display with Underline & (X) (Right)
        Item {
            anchors.top: directTuneHeader.bottom
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.topMargin: 10
            z: 10

            // LEFT SIDE: Keypad + Enter Pill Button
            Item {
                id: keypadSection
                anchors.left: parent.left
                anchors.leftMargin: 100
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: 10
                width: 340
                height: 430

                // 3-column Numeric Keypad
                Grid {
                    id: keypadGrid
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    columns: 3
                    rowSpacing: 14
                    columnSpacing: 14

                    Repeater {
                        model: [
                            "1", "2", "3",
                            "4", "5", "6",
                            "7", "8", "9",
                            ".", "0", "⌫"
                        ]

                        Item {
                            width: (keypadGrid.width - 28) / 3
                            height: 68

                            visible: modelData !== ""

                            Rectangle {
                                anchors.centerIn: parent
                                width: 68
                                height: 68
                                radius: 34
                                color: keyPressMouse.pressed ? Qt.rgba(255, 255, 255, 0.22) :
                                       (keyPressMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.08) : "transparent")
                                Behavior on color { ColorAnimation { duration: 100 } }
                            }

                            Text {
                                anchors.centerIn: parent
                                text: modelData === "⌫" ? "⌫" : modelData
                                color: "#FFFFFF"
                                font.family: "Inter"
                                font.pixelSize: 32
                                font.weight: Font.DemiBold
                            }

                            MouseArea {
                                id: keyPressMouse
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    if (modelData === "⌫") {
                                        if (keypadModal.enteredFreq.length > 0) {
                                            keypadModal.enteredFreq = keypadModal.enteredFreq.slice(0, -1);
                                        }
                                    } else if (modelData === ".") {
                                        if (keypadModal.enteredFreq.indexOf(".") === -1 && keypadModal.enteredFreq.length > 0 && keypadModal.enteredFreq.length < 6) {
                                            keypadModal.enteredFreq += ".";
                                        }
                                    } else {
                                        if (keypadModal.enteredFreq.length < 6) {
                                            keypadModal.enteredFreq += modelData;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                // Centered "Enter" Button (Matches Screenshot 1 & 2: pill button right below keypad)
                Rectangle {
                    id: enterButton
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 8
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: 250
                    height: 52
                    radius: 14
                    color: keypadModal.enteredFreq.length > 0 ?
                           (enterMouse.pressed ? Qt.rgba(226/255, 169/255, 107/255, 0.25) : Qt.rgba(226/255, 169/255, 107/255, 0.12)) :
                           Qt.rgba(255, 255, 255, 0.05)
                    border.color: keypadModal.enteredFreq.length > 0 ? "#E2A96B" : Qt.rgba(255, 255, 255, 0.18)
                    border.width: keypadModal.enteredFreq.length > 0 ? 1.5 : 1

                    scale: enterMouse.pressed ? 0.95 : 1.0
                    Behavior on scale { NumberAnimation { duration: 80 } }
                    Behavior on border.color { ColorAnimation { duration: 150 } }

                    Text {
                        anchors.centerIn: parent
                        text: "Enter"
                        color: keypadModal.enteredFreq.length > 0 ? "#FFFFFF" : "#64748B"
                        font.family: "Inter"
                        font.pixelSize: 21
                        font.weight: Font.DemiBold
                    }

                    MouseArea {
                        id: enterMouse
                        anchors.fill: parent
                        enabled: keypadModal.enteredFreq.length > 0
                        cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
                        onClicked: {
                            MediaBackend.tuneRadioFrequency(keypadModal.enteredFreq);
                            keypadModal.closeKeypad();
                        }
                    }
                }
            }

            // RIGHT SIDE: Frequency Display Line & Clear (X) Button (Matching Screenshot 1 & 2)
            Item {
                id: displayContainer
                anchors.left: keypadSection.right
                anchors.leftMargin: 120
                anchors.right: parent.right
                anchors.rightMargin: 80
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: -40
                height: 100

                Column {
                    anchors.fill: parent
                    spacing: 10

                    // Input Text and Clear Button Row
                    Item {
                        width: parent.width
                        height: 54

                        // Display text (Placeholder "Frequency" or Typed number with cursor)
                        Row {
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: 4

                            Text {
                                text: keypadModal.enteredFreq.length > 0 ? keypadModal.enteredFreq : "Frequency"
                                color: keypadModal.enteredFreq.length > 0 ? "#FFFFFF" : "#94A3B8"
                                font.family: "Inter"
                                font.pixelSize: keypadModal.enteredFreq.length > 0 ? 40 : 32
                                font.weight: keypadModal.enteredFreq.length > 0 ? Font.Bold : Font.Normal
                                anchors.verticalCenter: parent.verticalCenter
                            }

                            // Blinking cursor | when typing
                            Rectangle {
                                width: 2
                                height: 36
                                color: "#E2A96B"
                                visible: keypadModal.enteredFreq.length > 0
                                anchors.verticalCenter: parent.verticalCenter

                                SequentialAnimation on opacity {
                                    loops: Animation.Infinite
                                    running: keypadModal.enteredFreq.length > 0
                                    NumberAnimation { to: 1.0; duration: 500 }
                                    NumberAnimation { to: 0.0; duration: 500 }
                                }
                            }
                        }

                        // Circular (X) Clear Button (Always visible on right side of underline)
                        Item {
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            width: 36
                            height: 36

                            Rectangle {
                                anchors.fill: parent
                                radius: 18
                                color: clearMouse.pressed ? Qt.rgba(255, 255, 255, 0.20) : "transparent"
                                border.color: Qt.rgba(255, 255, 255, 0.50)
                                border.width: 1.5
                            }

                            Text {
                                anchors.centerIn: parent
                                text: "✕"
                                color: "#FFFFFF"
                                font.family: "Inter"
                                font.pixelSize: 14
                                font.weight: Font.Bold
                            }

                            MouseArea {
                                id: clearMouse
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    keypadModal.enteredFreq = "";
                                }
                            }
                        }
                    }

                    // Clean Underline Line across the right display
                    Rectangle {
                        width: parent.width
                        height: 1.5
                        color: "#CBD5E1"
                    }
                }
            }
        }
    }

    // -------------------------------------------------------------------------
    // PRESET TOAST NOTIFICATION
    // -------------------------------------------------------------------------
    Rectangle {
        id: saveNotification
        anchors.bottom: presetBar.top
        anchors.bottomMargin: 16
        anchors.horizontalCenter: parent.horizontalCenter
        width: notifText.implicitWidth + 36
        height: 38
        radius: 19
        color: Qt.rgba(15/255, 23/255, 42/255, 0.95)
        border.color: Qt.rgba(255, 255, 255, 0.25)
        border.width: 1
        opacity: 0.0
        z: 999

        Behavior on opacity { NumberAnimation { duration: 180 } }

        Text {
            id: notifText
            anchors.centerIn: parent
            text: ""
            color: "#FFFFFF"
            font.family: "Inter"
            font.pixelSize: 14
            font.weight: Font.Medium
        }

        Timer {
            id: notifTimer
            interval: 1800
            onTriggered: saveNotification.opacity = 0.0
        }

        function showToast(msg) {
            notifText.text = msg;
            saveNotification.opacity = 1.0;
            notifTimer.restart();
        }
    }
}
