/**
 * ==============================================================================
 * Project: Apex VISION IVI - Digital Cockpit & Infotainment System
 * File: ProfileSwitcherPage.qml
 * Author / Developer: Sk Rehan Ahamed
 * License: MIT
 * ==============================================================================
 */

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import ApexVision

Item {
    id: profileSwitcherRoot
    objectName: "profileSwitcherPage"

    // Safe alias so all existing root references resolve to the page root
    readonly property var root: profileSwitcherRoot

    signal backRequested()
    signal openProfileSettingsRequested()

    function openProfileSettings() {
        console.log("[APEX IVI] Navigating directly to Settings -> Profile category");
        profileSwitcherRoot.openProfileSettingsRequested();
        if (typeof pageStack !== "undefined" && pageStack) {
            pageStack.currentIndex = 4;
        }
        if (typeof settingsPage !== "undefined" && settingsPage) {
            settingsPage.returnIndex = 11;
            settingsPage.activeCategory = "profile";
            settingsPage.profCurrentScreen = "main";
        }
    }

    function openLanguageSettings() {
        console.log("[APEX IVI] Navigating directly to Settings -> System -> Languages & input");
        if (typeof pageStack !== "undefined" && pageStack) {
            pageStack.currentIndex = 4;
        }
        if (typeof settingsPage !== "undefined" && settingsPage) {
            settingsPage.returnIndex = 11;
            settingsPage.activeCategory = "system";
            settingsPage.sysSlideDir = 1;
            settingsPage.sysCurrentScreen = "languages_select";
        }
    }

    function returnToHome() {
        console.log("[APEX IVI] Returning to main menu (Homescreen)");
        profileSwitcherRoot.backRequested();
        if (typeof pageStack !== "undefined" && pageStack) {
            pageStack.currentIndex = 0;
        }
    }

    // Screen modes: "setup_intro" (matches user's photo) | "overview" (profile cards) | "create_wizard"
    property string currentMode: "setup_intro"
    property int slideDir: 1 // 1: forward, -1: back
    property string selectedLanguage: "English (United States)"
    property int wizardStep: 1 // 1: Name & Keyboard, 2: Adjustments, 3: Link Key Fob, 4: Done

    // Wizard Temp State
    property bool isSavingProfile: false
    property string newProfileName: (VehicleBackend.profileCount === 1 && VehicleBackend.driverProfileName === "Profile 1") ? "Profile 1" : ("Profile " + (VehicleBackend.profileCount + 1))
    property string newProfileAvatar: "monogram"
    property string newProfileAvatarPath: ""
    property string newProfileKeyLink: "Key Fob linked, Phone As A Key"
    property int wizardSeatRecline: 5
    property int wizardSeatSlide: 5
    property int wizardMirrorTilt: 0

    // Virtual Keyboard & Adjustment states
    property bool isCapsLock: false
    property bool isSymbols: false
    property int activeAdjustmentIndex: 0 // 0: Steering wheel, 1: Left mirror, 2: Right mirror, 3: Pedals
    property bool isKeyFobLinked: false

    function resetWizard() {
        newProfileName = "Profile " + (VehicleBackend.profileCount + 1);
        newProfileAvatar = "monogram";
        newProfileAvatarPath = "";
        newProfileKeyLink = "Key Fob linked, Phone As A Key";
        isKeyFobLinked = false;
        wizardStep = 1;
        currentMode = "overview";
    }

    property var avatarList: [
        { id: "monogram", name: "Monogram Initial", type: "monogram", path: "" },
        { id: "bird", name: "Soaring Bird", type: "image", path: "qrc:/ApexVision/qml/assets/avatars/avatar_bird.jpg" },
        { id: "chevron", name: "Gold Chevron", type: "image", path: "qrc:/ApexVision/qml/assets/avatars/avatar_chevron.jpg" },
        { id: "geometric", name: "Art Deco Diamonds", type: "image", path: "qrc:/ApexVision/qml/assets/avatars/avatar_geometric.jpg" },
        { id: "waves", name: "Golden Waves", type: "image", path: "qrc:/ApexVision/qml/assets/avatars/avatar_waves.jpg" },
        { id: "marble", name: "Blue Swirl Marble", type: "image", path: "qrc:/ApexVision/qml/assets/avatars/avatar_marble.jpg" },
        { id: "climber", name: "Mountain Climber", type: "image", path: "qrc:/ApexVision/qml/assets/avatars/avatar_climber.jpg" },
        { id: "desert", name: "Desert Canyon Sunset", type: "image", path: "qrc:/ApexVision/qml/assets/avatars/avatar_desert.jpg" },
        { id: "phoenix", name: "Fire Phoenix", type: "image", path: "qrc:/ApexVision/qml/assets/avatars/avatar_phoenix.jpg" },
        { id: "architecture", name: "Skyscraper Architecture", type: "image", path: "qrc:/ApexVision/qml/assets/avatars/avatar_architecture.jpg" },
        { id: "fish", name: "River Trout", type: "image", path: "qrc:/ApexVision/qml/assets/avatars/avatar_fish.jpg" },
        { id: "cabin", name: "Alpine Cabin & Lake", type: "image", path: "qrc:/ApexVision/qml/assets/avatars/avatar_cabin.jpg" },
        { id: "aurora", name: "Northern Lights Aurora", type: "image", path: "qrc:/ApexVision/qml/assets/avatars/avatar_aurora.jpg" },
        { id: "twilight", name: "Twilight Hills", type: "image", path: "qrc:/ApexVision/qml/assets/avatars/avatar_twilight.jpg" },
        { id: "sunset", name: "Golden Sunset", type: "image", path: "qrc:/ApexVision/qml/assets/avatars/avatar_sunset.jpg" },
        { id: "forest", name: "Pine Forest", type: "image", path: "qrc:/ApexVision/qml/assets/avatars/avatar_forest.jpg" },
        { id: "mountain", name: "Snow Peaks", type: "image", path: "qrc:/ApexVision/qml/assets/avatars/avatar_mountain.jpg" }
    ]

    function finishSetup() {
        if (root.isSavingProfile) return;
        root.isSavingProfile = true;

        var defaultName = (VehicleBackend.profileCount === 1 && VehicleBackend.driverProfileName === "Profile 1") ? "Profile 1" : ("Profile " + (VehicleBackend.profileCount + 1));
        var finalName = root.newProfileName.trim() === "" ? defaultName : root.newProfileName.trim();
        var finalAvatar = root.newProfileAvatar;
        var finalPath = root.newProfileAvatarPath;
        if (finalAvatar !== "monogram" && finalPath === "") {
            for (var i = 0; i < root.avatarList.length; i++) {
                if (root.avatarList[i].id === finalAvatar) {
                    finalPath = root.avatarList[i].path;
                    break;
                }
            }
        }
        VehicleBackend.addProfile(finalName, finalAvatar, finalPath, "Key Fob linked, Phone As A Key");
        VehicleBackend.showToast("Profile " + finalName + " Saved");
        root.resetWizard();
        root.slideDir = -1;
        root.currentMode = "overview";

        // Return to Main Menu (Homescreen)
        profileSwitcherRoot.returnToHome();
        if (typeof pageStack !== "undefined" && pageStack) {
            pageStack.currentIndex = 0;
        }

        root.isSavingProfile = false;
    }

    // Transparent cockpit scrim allowing Master default_background.png to shine through
    Rectangle {
        anchors.fill: parent
        color: Qt.rgba(7/255, 10/255, 18/255, 0.25)
    }

    // =========================================================================
    // 1. TOP BAR: Back Arrow, APEX Branding, "Switch profile", "Start" / "Drive as guest"
    // =========================================================================
    Item {
        id: topBar
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 76
        z: 20

        // Back Arrow & Title
        Row {
            anchors.left: parent.left
            anchors.leftMargin: 36
            anchors.verticalCenter: parent.verticalCenter
            spacing: 16

            Rectangle {
                width: 44
                height: 44
                radius: 22
                color: backMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.15) : Qt.rgba(255, 255, 255, 0.08)
                border.color: Qt.rgba(255, 255, 255, 0.20)
                border.width: 1

                Image {
                    anchors.centerIn: parent
                    source: "qrc:/ApexVision/qml/assets/icons/nav_back_arrow.svg"
                    width: 22
                    height: 22
                    sourceSize: Qt.size(44, 44)
                    fillMode: Image.PreserveAspectFit
                }

                MouseArea {
                    id: backMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        if (root.currentMode === "create_wizard") {
                            if (root.wizardStep > 1) {
                                root.slideDir = -1;
                                root.wizardStep--;
                            } else {
                                root.slideDir = -1;
                                root.currentMode = "setup_intro";
                            }
                        } else if (root.currentMode === "setup_intro") {
                            root.slideDir = -1;
                            root.currentMode = "overview";
                        } else {
                            profileSwitcherRoot.returnToHome();
                            if (typeof pageStack !== "undefined" && pageStack) {
                                pageStack.currentIndex = 0;
                            }
                        }
                    }
                }
            }

            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: {
                    if (root.currentMode === "create_wizard") {
                        if (root.wizardStep === 2) return "Adjustments";
                        if (root.wizardStep === 3) return "Link profile";
                        if (root.wizardStep === 4) return "Display image";
                        if (root.wizardStep === 5) return "Setup complete";
                        return "Profile Setup";
                    }
                    if (root.currentMode === "setup_intro") return "Profile Setup";
                    return "Personal Profiles";
                }
                color: "#FFFFFF"
                font.family: "Inter"
                font.pixelSize: 22
                font.weight: Font.DemiBold
            }

            // Profile Count (clean, borderless, no dot, exact writing requested)
            Text {
                id: profileCountText
                anchors.verticalCenter: parent.verticalCenter
                text: VehicleBackend.profileCount + " of 3 Profiles"
                color: "#38BDF8"
                font.family: "Inter"
                font.pixelSize: 13
                font.weight: Font.Medium
                visible: profileSwitcherRoot.currentMode === "overview"
            }
        }

        // Center APEX Brand Header: Prominent Big APEX Logo
        Item {
            anchors.centerIn: parent
            width: 180
            height: 48
            visible: root.currentMode === "overview"

            Image {
                anchors.centerIn: parent
                source: "qrc:/ApexVision/qml/assets/icons/apex_logo.png"
                width: 168
                height: 38
                fillMode: Image.PreserveAspectFit
            }
        }

        // Right Actions in Create Wizard Mode
        Row {
            anchors.right: parent.right
            anchors.rightMargin: 36
            anchors.verticalCenter: parent.verticalCenter
            spacing: 14
            visible: root.currentMode === "create_wizard"

            // Step 2 (Seat Adjustments) Next Button
            Rectangle {
                height: 42
                width: 100
                radius: 21
                visible: root.wizardStep === 2
                color: nextMouse2.pressed ? Qt.rgba(224/255, 169/255, 109/255, 0.22) :
                       (nextMouse2.containsMouse ? Qt.rgba(224/255, 169/255, 109/255, 0.12) : Qt.rgba(255, 255, 255, 0.04))
                border.color: "#E0A96D"
                border.width: 2

                Text {
                    anchors.centerIn: parent
                    text: "Next"
                    color: "#FFFFFF"
                    font.family: "Inter"
                    font.pixelSize: 15
                    font.weight: Font.DemiBold
                }

                MouseArea {
                    id: nextMouse2
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        root.slideDir = 1;
                        root.wizardStep = 3;
                    }
                }
            }

            // Step 3 (Link Key Fob) Skip & Next Buttons
            Row {
                spacing: 12
                visible: root.wizardStep === 3

                Rectangle {
                    height: 42
                    width: 86
                    radius: 21
                    color: skipMouse3.pressed ? Qt.rgba(255, 255, 255, 0.16) :
                           (skipMouse3.containsMouse ? Qt.rgba(255, 255, 255, 0.12) : Qt.rgba(255, 255, 255, 0.08))
                    border.color: Qt.rgba(255, 255, 255, 0.25)
                    border.width: 1

                    Text {
                        anchors.centerIn: parent
                        text: "Skip"
                        color: "#FFFFFF"
                        font.family: "Inter"
                        font.pixelSize: 15
                    }

                    MouseArea {
                        id: skipMouse3
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            root.slideDir = 1;
                            root.wizardStep = 4;
                        }
                    }
                }

                Rectangle {
                    height: 42
                    width: 96
                    radius: 21
                    color: nextMouse3.pressed ? Qt.rgba(224/255, 169/255, 109/255, 0.22) :
                           (nextMouse3.containsMouse ? Qt.rgba(224/255, 169/255, 109/255, 0.12) : Qt.rgba(255, 255, 255, 0.04))
                    border.color: "#E0A96D"
                    border.width: 2

                    Text {
                        anchors.centerIn: parent
                        text: "Next"
                        color: "#FFFFFF"
                        font.family: "Inter"
                        font.pixelSize: 15
                        font.weight: Font.DemiBold
                    }

                    MouseArea {
                        id: nextMouse3
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            root.slideDir = 1;
                            root.wizardStep = 4;
                        }
                    }
                }
            }

            // Step 4 (Display Image) Next Button
            Rectangle {
                height: 42
                width: 100
                radius: 21
                visible: root.wizardStep === 4
                color: nextMouse4.pressed ? Qt.rgba(224/255, 169/255, 109/255, 0.22) :
                       (nextMouse4.containsMouse ? Qt.rgba(224/255, 169/255, 109/255, 0.12) : Qt.rgba(255, 255, 255, 0.04))
                border.color: "#E0A96D"
                border.width: 2

                Text {
                    anchors.centerIn: parent
                    text: "Next"
                    color: "#FFFFFF"
                    font.family: "Inter"
                    font.pixelSize: 15
                    font.weight: Font.DemiBold
                }

                MouseArea {
                    id: nextMouse4
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        root.slideDir = 1;
                        root.wizardStep = 5;
                    }
                }
            }

            // Step 5 (Setup Complete) Done Button
            Rectangle {
                height: 42
                width: 110
                radius: 21
                visible: root.wizardStep === 5
                color: doneMouse5.pressed ? Qt.rgba(224/255, 169/255, 109/255, 0.25) :
                       (doneMouse5.containsMouse ? Qt.rgba(224/255, 169/255, 109/255, 0.15) : Qt.rgba(255, 255, 255, 0.05))
                border.color: "#E0A96D"
                border.width: 2

                Text {
                    anchors.centerIn: parent
                    text: "Done"
                    color: "#FFFFFF"
                    font.family: "Inter"
                    font.pixelSize: 15
                    font.weight: Font.DemiBold
                }

                MouseArea {
                    id: doneMouse5
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.finishSetup()
                }
            }
        }

        // Right Action in Setup Intro Mode: "Switch profile" and "Start" buttons
        Row {
            anchors.right: parent.right
            anchors.rightMargin: 36
            anchors.verticalCenter: parent.verticalCenter
            spacing: 14
            visible: root.currentMode === "setup_intro"

            // "Switch profile" Pill Button
            Rectangle {
                height: 42
                width: switchBtnText.implicitWidth + 36
                radius: 21
                color: switchMouse.pressed ? Qt.rgba(255, 255, 255, 0.18) :
                       (switchMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.12) : Qt.rgba(255, 255, 255, 0.08))
                border.color: switchMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.35) : Qt.rgba(255, 255, 255, 0.18)
                border.width: 1

                Text {
                    id: switchBtnText
                    anchors.centerIn: parent
                    text: "Switch profile"
                    color: "#FFFFFF"
                    font.family: "Inter"
                    font.pixelSize: 15
                    font.weight: Font.Medium
                }

                MouseArea {
                    id: switchMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        root.slideDir = -1;
                        root.currentMode = "overview";
                    }
                }
            }

            // "Start" Pill Button with warm amber border matching photo
            Rectangle {
                height: 42
                width: startBtnText.implicitWidth + 40
                radius: 21
                color: startMouse.pressed ? Qt.rgba(224/255, 169/255, 109/255, 0.22) :
                       (startMouse.containsMouse ? Qt.rgba(224/255, 169/255, 109/255, 0.12) : Qt.rgba(255, 255, 255, 0.04))
                border.color: "#E0A96D"
                border.width: 2

                Text {
                    id: startBtnText
                    anchors.centerIn: parent
                    text: "Start"
                    color: "#FFFFFF"
                    font.family: "Inter"
                    font.pixelSize: 15
                    font.weight: Font.DemiBold
                }

                MouseArea {
                    id: startMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        root.slideDir = 1;
                        root.wizardStep = 1;
                        root.currentMode = "create_wizard";
                    }
                }
            }
        }

        // Right Action in Overview Mode: "Drive as guest" Pill Button
        Rectangle {
            id: guestBtn
            anchors.right: parent.right
            anchors.rightMargin: 36
            anchors.verticalCenter: parent.verticalCenter
            height: 42
            width: guestBtnRow.implicitWidth + 28
            radius: 21
            visible: root.currentMode === "overview"
            color: guestMouse.pressed ? Qt.rgba(255, 255, 255, 0.18) :
                   (guestMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.12) :
                   (VehicleBackend.isGuestSession ? Qt.rgba(56/255, 189/255, 248/255, 0.25) : Qt.rgba(255, 255, 255, 0.07)))
            border.color: VehicleBackend.isGuestSession ? "#38BDF8" :
                          (guestMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.40) : Qt.rgba(255, 255, 255, 0.18))
            border.width: VehicleBackend.isGuestSession ? 1.5 : 1

            Row {
                id: guestBtnRow
                anchors.centerIn: parent
                spacing: 8

                Rectangle {
                    width: 8
                    height: 8
                    radius: 4
                    color: VehicleBackend.isGuestSession ? "#38BDF8" : Qt.rgba(255, 255, 255, 0.40)
                    anchors.verticalCenter: parent.verticalCenter
                }

                Text {
                    text: VehicleBackend.isGuestSession ? "Driving as Guest" : "Drive as guest"
                    color: VehicleBackend.isGuestSession ? "#38BDF8" : "#FFFFFF"
                    font.family: "Inter"
                    font.pixelSize: 14
                    font.weight: Font.Medium
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            MouseArea {
                id: guestMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    VehicleBackend.driveAsGuest();
                    profileSwitcherRoot.returnToHome();
                    if (typeof pageStack !== "undefined" && pageStack) {
                        pageStack.currentIndex = 0;
                    }
                }
            }
        }

        // Horizontal divider line in upper side below the next part
        Rectangle {
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            height: 1
            color: Qt.rgba(255, 255, 255, 0.15)
        }
    }

    // =========================================================================
    // 2. SETUP INTRO VIEW (Exact 1:1 Match to Reference Screenshot)
    // =========================================================================
    Item {
        id: setupIntroView
        anchors.top: topBar.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        visible: opacity > 0.001
        opacity: root.currentMode === "setup_intro" ? 1.0 : 0.0
        enabled: root.currentMode === "setup_intro" && opacity > 0.8
        transform: Translate {
            x: profileSwitcherRoot.currentMode === "setup_intro" ? 0 : (profileSwitcherRoot.slideDir > 0 ? -160 : 160)
            Behavior on x {
                NumberAnimation {
                    duration: 340
                    easing.type: Easing.OutCubic
                }
            }
        }
        Behavior on opacity { NumberAnimation { duration: 280; easing.type: Easing.InOutQuad } }

        Item {
            anchors.centerIn: parent
            width: Math.min(parent.width - 80, 1140)
            height: Math.min(parent.height - 40, 520)

            // -----------------------------------------------------------------
            // Left Side: Description Text & Language Selection
            // -----------------------------------------------------------------
            Column {
                id: introLeftCol
                anchors.left: parent.left
                anchors.leftMargin: 20
                anchors.verticalCenter: parent.verticalCenter
                width: 480
                spacing: 40

                Text {
                    text: "Personalize your experience by connecting your vehicle settings, Google account and apps to your profile."
                    color: "#FFFFFF"
                    font.family: "Inter"
                    font.pixelSize: 24
                    font.weight: Font.DemiBold
                    wrapMode: Text.WordWrap
                    width: parent.width
                    lineHeight: 1.35
                }

                Column {
                    width: parent.width
                    spacing: 12

                    Text {
                        text: "Select your language"
                        color: "#94A3B8"
                        font.family: "Inter"
                        font.pixelSize: 15
                        font.weight: Font.Medium
                    }

                    Rectangle {
                        id: langDropdownPill
                        width: 360
                        height: 52
                        radius: 14
                        color: langMouse.pressed ? Qt.rgba(255, 255, 255, 0.12) :
                               (langMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.08) : Qt.rgba(255, 255, 255, 0.05))
                        border.color: langMouse.containsMouse ? Qt.rgba(56/255, 189/255, 248/255, 0.70) : Qt.rgba(255, 255, 255, 0.16)
                        border.width: 1
                        Behavior on border.color { ColorAnimation { duration: 150 } }

                        Text {
                            anchors.left: parent.left
                            anchors.leftMargin: 20
                            anchors.right: langChevron.left
                            anchors.rightMargin: 12
                            anchors.verticalCenter: parent.verticalCenter
                            text: (typeof SystemBackend !== "undefined" && SystemBackend.selectedLanguage) ? SystemBackend.selectedLanguage : root.selectedLanguage
                            color: "#FFFFFF"
                            font.family: "Inter"
                            font.pixelSize: 15
                            font.weight: Font.Medium
                            elide: Text.ElideRight
                        }

                        Image {
                            id: langChevron
                            anchors.right: parent.right
                            anchors.rightMargin: 20
                            anchors.verticalCenter: parent.verticalCenter
                            source: "qrc:/ApexVision/qml/assets/icons/chevron_right_white.svg"
                            width: 14
                            height: 14
                            fillMode: Image.PreserveAspectFit
                            opacity: langMouse.containsMouse ? 1.0 : 0.65
                            Behavior on opacity { NumberAnimation { duration: 150 } }
                        }

                        MouseArea {
                            id: langMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                profileSwitcherRoot.openLanguageSettings();
                            }
                        }
                    }
                }
            }

            // -----------------------------------------------------------------
            // Right Side: Stepper 1 - 2 - 3 - 4 with Connected Vertical Line
            // -----------------------------------------------------------------
            Column {
                id: introRightCol
                anchors.left: introLeftCol.right
                anchors.leftMargin: 80
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                spacing: 0

                // Step 1: Profile name (Highlighted in Amber Outline)
                Item {
                    width: parent.width
                    height: 64

                    Row {
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 20

                        Rectangle {
                            width: 44
                            height: 44
                            radius: 22
                            color: "transparent"
                            border.color: "#E0A96D"
                            border.width: 2.2
                            anchors.verticalCenter: parent.verticalCenter

                            Text {
                                anchors.centerIn: parent
                                text: "1"
                                color: "#FFFFFF"
                                font.family: "Inter"
                                font.pixelSize: 18
                                font.weight: Font.DemiBold
                            }
                        }

                        Column {
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: 4

                            Text {
                                text: "Profile name"
                                color: "#FFFFFF"
                                font.family: "Inter"
                                font.pixelSize: 20
                                font.weight: Font.DemiBold
                            }

                            Text {
                                text: "Personalize your profile"
                                color: "#94A3B8"
                                font.family: "Inter"
                                font.pixelSize: 14
                            }
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            root.slideDir = 1;
                            root.wizardStep = 1;
                            root.currentMode = "create_wizard";
                        }
                    }
                }

                // Vertical Connector Line (Step 1 to 2)
                Item {
                    width: 44
                    height: 36

                    Rectangle {
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        width: 2
                        color: Qt.rgba(255, 255, 255, 0.22)
                    }
                }

                // Step 2: Adjustments
                Item {
                    width: parent.width
                    height: 64

                    Row {
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 20

                        Rectangle {
                            width: 44
                            height: 44
                            radius: 22
                            color: "transparent"
                            border.color: Qt.rgba(255, 255, 255, 0.28)
                            border.width: 1.8
                            anchors.verticalCenter: parent.verticalCenter

                            Text {
                                anchors.centerIn: parent
                                text: "2"
                                color: Qt.rgba(255, 255, 255, 0.55)
                                font.family: "Inter"
                                font.pixelSize: 18
                                font.weight: Font.Medium
                            }
                        }

                        Column {
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: 4

                            Text {
                                text: "Adjustments"
                                color: Qt.rgba(255, 255, 255, 0.70)
                                font.family: "Inter"
                                font.pixelSize: 20
                                font.weight: Font.Medium
                            }

                            Text {
                                text: "Seat, mirror, and steering wheel"
                                color: Qt.rgba(255, 255, 255, 0.40)
                                font.family: "Inter"
                                font.pixelSize: 14
                            }
                        }
                    }
                }

                // Vertical Connector Line (Step 2 to 3)
                Item {
                    width: 44
                    height: 36

                    Rectangle {
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        width: 2
                        color: Qt.rgba(255, 255, 255, 0.22)
                    }
                }

                // Step 3: Link profile
                Item {
                    width: parent.width
                    height: 64

                    Row {
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 20

                        Rectangle {
                            width: 44
                            height: 44
                            radius: 22
                            color: "transparent"
                            border.color: Qt.rgba(255, 255, 255, 0.28)
                            border.width: 1.8
                            anchors.verticalCenter: parent.verticalCenter

                            Text {
                                anchors.centerIn: parent
                                text: "3"
                                color: Qt.rgba(255, 255, 255, 0.55)
                                font.family: "Inter"
                                font.pixelSize: 18
                                font.weight: Font.Medium
                            }
                        }

                        Column {
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: 4

                            Text {
                                text: "Link profile"
                                color: Qt.rgba(255, 255, 255, 0.70)
                                font.family: "Inter"
                                font.pixelSize: 20
                                font.weight: Font.Medium
                            }

                            Text {
                                text: "Key fob"
                                color: Qt.rgba(255, 255, 255, 0.40)
                                font.family: "Inter"
                                font.pixelSize: 14
                            }
                        }
                    }
                }

                // Vertical Connector Line (Step 3 to 4)
                Item {
                    width: 44
                    height: 36

                    Rectangle {
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        width: 2
                        color: Qt.rgba(255, 255, 255, 0.22)
                    }
                }

                // Step 4: Display image (Profile avatar)
                Item {
                    width: parent.width
                    height: 64

                    Row {
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 20

                        Rectangle {
                            width: 44
                            height: 44
                            radius: 22
                            color: "transparent"
                            border.color: Qt.rgba(255, 255, 255, 0.28)
                            border.width: 1.8
                            anchors.verticalCenter: parent.verticalCenter

                            Text {
                                anchors.centerIn: parent
                                text: "4"
                                color: Qt.rgba(255, 255, 255, 0.55)
                                font.family: "Inter"
                                font.pixelSize: 18
                                font.weight: Font.Medium
                            }
                        }

                        Column {
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: 4

                            Text {
                                text: "Display image"
                                color: Qt.rgba(255, 255, 255, 0.70)
                                font.family: "Inter"
                                font.pixelSize: 20
                                font.weight: Font.Medium
                            }

                            Text {
                                text: "Profile avatar"
                                color: Qt.rgba(255, 255, 255, 0.40)
                                font.family: "Inter"
                                font.pixelSize: 14
                            }
                        }
                    }
                }
            }
        }
    }

    // =========================================================================
    // 3. OVERVIEW SCREEN: Profile Cards (up to 3) + "Add profile" Button
    // =========================================================================
    Item {
        id: overviewView
        anchors.top: topBar.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        visible: opacity > 0.001
        opacity: root.currentMode === "overview" ? 1.0 : 0.0
        enabled: root.currentMode === "overview" && opacity > 0.8
        transform: Translate {
            x: profileSwitcherRoot.currentMode === "overview" ? 0 : (profileSwitcherRoot.slideDir > 0 ? -160 : 160)
            Behavior on x {
                NumberAnimation {
                    duration: 340
                    easing.type: Easing.OutCubic
                }
            }
        }
        Behavior on opacity { NumberAnimation { duration: 280; easing.type: Easing.InOutQuad } }

        Column {
            anchors.centerIn: parent
            spacing: 32
            width: Math.min(parent.width - 80, 1100)

            // Header prompt
            Column {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 6

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Select Active Driver Profile"
                    color: "#FFFFFF"
                    font.family: "Inter"
                    font.pixelSize: 26
                    font.weight: Font.DemiBold
                }

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Seating, mirrors, ambient lighting, and media settings adapt automatically"
                    color: Qt.rgba(255, 255, 255, 0.55)
                    font.family: "Inter"
                    font.pixelSize: 14
                }
            }

            // Cards Row: Existing Profiles + Add Profile
            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 24

                // Profiles Repeater (Up to 3 profiles)
                Repeater {
                    model: VehicleBackend.profilesList

                    Rectangle {
                        id: profileCard
                        width: 260
                        height: 280
                        radius: 20
                        clip: true

                        // Light frosted glass background matching VehicleMenuCard
                        gradient: Gradient {
                            GradientStop {
                                position: 0.0
                                color: cardMouse.pressed ? Qt.rgba(215/255, 238/255, 255/255, 0.36) :
                                       (cardMouse.containsMouse ? Qt.rgba(225/255, 242/255, 255/255, 0.28) :
                                       (modelData.isCurrent ? Qt.rgba(225/255, 242/255, 255/255, 0.22) : Qt.rgba(215/255, 238/255, 255/255, 0.16)))
                            }
                            GradientStop {
                                position: 1.0
                                color: cardMouse.pressed ? Qt.rgba(195/255, 225/255, 255/255, 0.30) :
                                       (cardMouse.containsMouse ? Qt.rgba(205/255, 232/255, 255/255, 0.22) :
                                       (modelData.isCurrent ? Qt.rgba(205/255, 232/255, 255/255, 0.16) : Qt.rgba(195/255, 225/255, 255/255, 0.10)))
                            }
                        }

                        // Luminous border (Cyan active highlight)
                        border.color: modelData.isCurrent ? "#00D2FF" :
                                      (cardMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.65) : Qt.rgba(225/255, 242/255, 255/255, 0.36))
                        border.width: modelData.isCurrent ? 2 : 1

                        // Top specular chamfer
                        Rectangle {
                            anchors.top: parent.top
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.topMargin: 1
                            anchors.leftMargin: 20
                            anchors.rightMargin: 20
                            height: 1
                            color: modelData.isCurrent ? Qt.rgba(0, 210/255, 255/255, 0.50) : Qt.rgba(255, 255, 255, 0.35)
                            radius: 1
                        }

                        // Active Indicator Pill (Top Right)
                        Rectangle {
                            anchors.top: parent.top
                            anchors.topMargin: 14
                            anchors.right: parent.right
                            anchors.rightMargin: 14
                            height: 22
                            width: activeLabel.implicitWidth + 16
                            radius: 11
                            color: Qt.rgba(56/255, 189/255, 248/255, 0.25)
                            border.color: "#38BDF8"
                            border.width: 1
                            visible: modelData.isCurrent

                            Text {
                                id: activeLabel
                                anchors.centerIn: parent
                                text: "ACTIVE"
                                color: "#38BDF8"
                                font.family: "Inter"
                                font.pixelSize: 10
                                font.weight: Font.Bold
                                font.letterSpacing: 1.0
                            }
                        }

                        // Settings/Edit Button (Top Left) with High Z-Index
                        Rectangle {
                            id: editBtn
                            z: 20
                            anchors.top: parent.top
                            anchors.topMargin: 12
                            anchors.left: parent.left
                            anchors.leftMargin: 12
                            width: 36
                            height: 36
                            radius: 18
                            color: editMouse.pressed ? Qt.rgba(56/255, 189/255, 248/255, 0.35) :
                                   (editMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.22) : Qt.rgba(255, 255, 255, 0.10))
                            border.color: editMouse.containsMouse ? "#38BDF8" : Qt.rgba(255, 255, 255, 0.25)
                            border.width: 1.5

                            Text {
                                anchors.centerIn: parent
                                text: "✎"
                                color: "#FFFFFF"
                                font.pixelSize: 16
                            }

                            MouseArea {
                                id: editMouse
                                z: 20
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    console.log("[APEX IVI] Edit Profile clicked for: " + modelData.id);
                                    VehicleBackend.switchProfile(modelData.id);
                                    root.openProfileSettingsRequested();
                                    if (typeof pageStack !== "undefined" && pageStack) {
                                        pageStack.currentIndex = 4;
                                    }
                                    if (typeof settingsPage !== "undefined" && settingsPage) {
                                        settingsPage.returnIndex = 11;
                                        settingsPage.activeCategory = "profile";
                                        settingsPage.profCurrentScreen = "main";
                                    }
                                }
                            }
                        }

                        // Profile Content Column
                        Column {
                            anchors.centerIn: parent
                            spacing: 12
                            width: parent.width - 32

                            // Avatar Circle (72x72)
                            Item {
                                width: 72
                                height: 72
                                anchors.horizontalCenter: parent.horizontalCenter

                                // Image Avatar
                                Item {
                                    anchors.fill: parent
                                    visible: modelData.avatarPath !== ""

                                    Image {
                                        id: cardAvatarImg
                                        anchors.fill: parent
                                        source: modelData.avatarPath
                                        fillMode: Image.PreserveAspectCrop
                                        visible: false
                                    }
                                    Rectangle {
                                        id: cardAvatarMask
                                        anchors.fill: parent
                                        radius: 36
                                        visible: false
                                        layer.enabled: true
                                    }
                                    MultiEffect {
                                        anchors.fill: parent
                                        source: cardAvatarImg
                                        maskEnabled: true
                                        maskSource: cardAvatarMask
                                    }
                                    Rectangle {
                                        anchors.fill: parent
                                        radius: 36
                                        color: "transparent"
                                        border.color: modelData.isCurrent ? "#38BDF8" : Qt.rgba(255, 255, 255, 0.40)
                                        border.width: 2
                                    }
                                }

                                // Monogram Badge
                                Rectangle {
                                    anchors.fill: parent
                                    radius: 36
                                    visible: modelData.avatarPath === ""
                                    gradient: Gradient {
                                        GradientStop { position: 0.0; color: "#2563EB" }
                                        GradientStop { position: 1.0; color: "#1D4ED8" }
                                    }
                                    border.color: modelData.isCurrent ? "#38BDF8" : Qt.rgba(255, 255, 255, 0.35)
                                    border.width: 2

                                    Text {
                                        anchors.centerIn: parent
                                        text: modelData.initials
                                        color: "#FFFFFF"
                                        font.family: "Inter"
                                        font.pixelSize: 24
                                        font.weight: Font.Bold
                                    }
                                }
                            }

                            // Profile Name
                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: modelData.name
                                color: "#FFFFFF"
                                font.family: "Inter"
                                font.pixelSize: 18
                                font.weight: Font.DemiBold
                                elide: Text.ElideRight
                                width: parent.width
                                horizontalAlignment: Text.AlignHCenter
                            }

                            // Linked Device Subtext
                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: modelData.linkedKey
                                color: Qt.rgba(255, 255, 255, 0.50)
                                font.family: "Inter"
                                font.pixelSize: 11
                                elide: Text.ElideRight
                                width: parent.width
                                horizontalAlignment: Text.AlignHCenter
                            }

                            // Switch / Select Button
                            Rectangle {
                                anchors.horizontalCenter: parent.horizontalCenter
                                width: 140
                                height: 34
                                radius: 17
                                color: modelData.isCurrent ? Qt.rgba(56/255, 189/255, 248/255, 0.20) : Qt.rgba(255, 255, 255, 0.12)
                                border.color: modelData.isCurrent ? "#38BDF8" : Qt.rgba(255, 255, 255, 0.25)
                                border.width: 1

                                Text {
                                    anchors.centerIn: parent
                                    text: modelData.isCurrent ? "Active Profile" : "Switch Profile"
                                    color: modelData.isCurrent ? "#38BDF8" : "#FFFFFF"
                                    font.family: "Inter"
                                    font.pixelSize: 12
                                    font.weight: Font.Medium
                                }
                            }
                        }

                        MouseArea {
                            id: cardMouse
                            z: 1
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: (mouse) => {
                                // If click was inside the edit button zone (top-left 52x52), let edit handle it
                                if (mouse.x <= 54 && mouse.y <= 54) {
                                    return;
                                }
                                VehicleBackend.switchProfile(modelData.id);
                                profileSwitcherRoot.returnToHome();
                                if (typeof pageStack !== "undefined" && pageStack) {
                                    pageStack.currentIndex = 0;
                                }
                            }
                        }
                    }
                }

                // "Add profile" Tile (Available if fewer than 3 profiles exist)
                Rectangle {
                    id: addProfileTile
                    width: 260
                    height: 280
                    radius: 20
                    visible: VehicleBackend.canAddProfile
                    clip: true

                    // Light frosted glass background matching VehicleMenuCard
                    gradient: Gradient {
                        GradientStop {
                            position: 0.0
                            color: addMouse.pressed ? Qt.rgba(215/255, 238/255, 255/255, 0.32) :
                                   (addMouse.containsMouse ? Qt.rgba(225/255, 242/255, 255/255, 0.24) : Qt.rgba(215/255, 238/255, 255/255, 0.16))
                        }
                        GradientStop {
                            position: 1.0
                            color: addMouse.pressed ? Qt.rgba(195/255, 225/255, 255/255, 0.26) :
                                   (addMouse.containsMouse ? Qt.rgba(205/255, 232/255, 255/255, 0.18) : Qt.rgba(195/255, 225/255, 255/255, 0.10))
                        }
                    }
                    border.color: addMouse.containsMouse ? "#00D2FF" : Qt.rgba(225/255, 242/255, 255/255, 0.36)
                    border.width: addMouse.containsMouse ? 2 : 1

                    // Top specular highlight
                    Rectangle {
                        anchors.top: parent.top
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.topMargin: 1
                        anchors.leftMargin: 20
                        anchors.rightMargin: 20
                        height: 1
                        color: addMouse.containsMouse ? Qt.rgba(0, 210/255, 255/255, 0.50) : Qt.rgba(255, 255, 255, 0.35)
                        radius: 1
                    }

                    Column {
                        anchors.centerIn: parent
                        spacing: 16

                        // Plus Circle Icon
                        Rectangle {
                            width: 64
                            height: 64
                            radius: 32
                            anchors.horizontalCenter: parent.horizontalCenter
                            color: addMouse.containsMouse ? Qt.rgba(56/255, 189/255, 248/255, 0.25) : Qt.rgba(255, 255, 255, 0.08)
                            border.color: addMouse.containsMouse ? "#38BDF8" : Qt.rgba(255, 255, 255, 0.30)
                            border.width: 1.5

                            Text {
                                anchors.centerIn: parent
                                text: "+"
                                color: addMouse.containsMouse ? "#38BDF8" : "#FFFFFF"
                                font.family: "Inter"
                                font.pixelSize: 32
                                font.weight: Font.Light
                            }
                        }

                        Column {
                            anchors.horizontalCenter: parent.horizontalCenter
                            spacing: 4

                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: "Add Profile"
                                color: "#FFFFFF"
                                font.family: "Inter"
                                font.pixelSize: 18
                                font.weight: Font.DemiBold
                            }

                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: "Up to 3 driver profiles"
                                color: Qt.rgba(255, 255, 255, 0.50)
                                font.family: "Inter"
                                font.pixelSize: 12
                            }
                        }
                    }

                    MouseArea {
                        id: addMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            root.resetWizard();
                            root.slideDir = 1;
                            root.currentMode = "setup_intro";
                        }
                    }
                }
            }
        }
    }

    // =========================================================================
    // 4. PROFILE CREATION WIZARD (NO GOOGLE STEP!)
    // =========================================================================
    Item {
        id: wizardView
        anchors.top: topBar.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        clip: true
        visible: opacity > 0.001
        opacity: root.currentMode === "create_wizard" ? 1.0 : 0.0
        enabled: root.currentMode === "create_wizard" && opacity > 0.8
        transform: Translate {
            x: profileSwitcherRoot.currentMode === "create_wizard" ? 0 : 160
            Behavior on x {
                NumberAnimation {
                    duration: 340
                    easing.type: Easing.OutCubic
                }
            }
        }
        Behavior on opacity { NumberAnimation { duration: 280; easing.type: Easing.InOutQuad } }

        // Helper inline keyboard key component
        component KeyButton: Rectangle {
            id: kBtn
            property string label: ""
            property real btnWidth: 68
            property real btnHeight: 52
            signal clicked()

            width: btnWidth
            height: btnHeight
            radius: 12
            color: kMouse.pressed ? Qt.rgba(255, 255, 255, 0.22) :
                   (kMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.14) : Qt.rgba(255, 255, 255, 0.08))
            border.color: Qt.rgba(255, 255, 255, 0.20)
            border.width: 1

            Text {
                anchors.centerIn: parent
                text: kBtn.label
                color: "#FFFFFF"
                font.family: "Inter"
                font.pixelSize: 20
                font.weight: Font.Medium
            }

            MouseArea {
                id: kMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: kBtn.clicked()
            }
        }

        // =====================================================================
        // STEP 1: Profile Name with Onboard Virtual Keyboard (Matching Image 4)
        // =====================================================================
        Item {
            id: wizardStep1
            anchors.fill: parent
            visible: opacity > 0.001
            opacity: profileSwitcherRoot.wizardStep === 1 ? 1.0 : 0.0
            enabled: profileSwitcherRoot.wizardStep === 1 && opacity > 0.8
            transform: Translate {
                x: profileSwitcherRoot.wizardStep === 1 ? 0 : (profileSwitcherRoot.wizardStep > 1 ? -160 : 160)
                Behavior on x {
                    NumberAnimation {
                        duration: 340
                        easing.type: Easing.OutCubic
                    }
                }
            }
            Behavior on opacity { NumberAnimation { duration: 280; easing.type: Easing.InOutQuad } }

            // Top Header: Profile Title with Underline and Clear (x)
            Column {
                anchors.top: parent.top
                anchors.topMargin: 24
                anchors.horizontalCenter: parent.horizontalCenter
                width: Math.min(parent.width - 120, 1020)
                spacing: 12

                Item {
                    width: parent.width
                    height: 52

                    Row {
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 2

                        Text {
                            text: root.newProfileName
                            color: "#FFFFFF"
                            font.family: "Inter"
                            font.pixelSize: 28
                            font.weight: Font.DemiBold
                            visible: root.newProfileName.length > 0
                        }

                        Text {
                            text: "Enter profile name"
                            color: Qt.rgba(255, 255, 255, 0.35)
                            font.family: "Inter"
                            font.pixelSize: 28
                            font.weight: Font.Normal
                            visible: root.newProfileName.length === 0
                        }

                        // Blinking automotive cursor
                        Rectangle {
                            width: 2
                            height: 30
                            color: "#E0A96D"
                            anchors.verticalCenter: parent.verticalCenter
                            SequentialAnimation on opacity {
                                loops: Animation.Infinite
                                NumberAnimation { from: 1; to: 0; duration: 530 }
                                NumberAnimation { from: 0; to: 1; duration: 530 }
                            }
                        }
                    }

                    // Clear button (x) - only visible when there is text to clear
                    Rectangle {
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        width: 32
                        height: 32
                        radius: 16
                        visible: root.newProfileName.length > 0
                        color: clearNameMouse.pressed ? Qt.rgba(255, 255, 255, 0.25) :
                               (clearNameMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.15) : Qt.rgba(255, 255, 255, 0.08))
                        border.color: Qt.rgba(255, 255, 255, 0.30)
                        border.width: 1

                        Text {
                            anchors.centerIn: parent
                            text: "✕"
                            color: "#FFFFFF"
                            font.family: "Inter"
                            font.pixelSize: 13
                            font.weight: Font.Bold
                        }

                        MouseArea {
                            id: clearNameMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: root.newProfileName = ""
                        }
                    }

                    // Underline
                    Rectangle {
                        anchors.bottom: parent.bottom
                        anchors.left: parent.left
                        anchors.right: parent.right
                        height: 1.5
                        color: Qt.rgba(224/255, 169/255, 109/255, 0.85)
                    }
                }

                Text {
                    text: "Name your profile"
                    color: "#FFFFFF"
                    font.family: "Inter"
                    font.pixelSize: 20
                    font.weight: Font.Medium
                }
            }

            // Onboard Virtual QWERTY Keyboard
            Column {
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 26
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 10
                width: Math.min(parent.width - 80, 1040)

                // Row 1
                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 8
                    Repeater {
                        model: root.isSymbols ? ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"] :
                                                ["q", "w", "e", "r", "t", "y", "u", "i", "o", "p"]
                        KeyButton {
                            label: root.isCapsLock ? modelData.toUpperCase() : modelData
                            btnWidth: (parent.parent.width - (9 * 8)) / 10
                            onClicked: root.newProfileName += label
                        }
                    }
                }

                // Row 2
                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 8
                    Repeater {
                        model: root.isSymbols ? ["-", "/", ":", ";", "(", ")", "$", "&", "@"] :
                                                ["a", "s", "d", "f", "g", "h", "j", "k", "l"]
                        KeyButton {
                            label: root.isCapsLock ? modelData.toUpperCase() : modelData
                            btnWidth: (parent.parent.width - (8 * 8) - 40) / 9
                            onClicked: root.newProfileName += label
                        }
                    }
                }

                // Row 3 (Shift, letters, Backspace)
                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 8

                    // Shift Key
                    Rectangle {
                        width: 88
                        height: 52
                        radius: 12
                        color: root.isCapsLock ? Qt.rgba(224/255, 169/255, 109/255, 0.35) : Qt.rgba(255, 255, 255, 0.08)
                        border.color: root.isCapsLock ? "#E0A96D" : Qt.rgba(255, 255, 255, 0.20)
                        border.width: 1
                        Text {
                            anchors.centerIn: parent
                            text: "⇧"
                            color: "#FFFFFF"
                            font.pixelSize: 22
                        }
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: root.isCapsLock = !root.isCapsLock
                        }
                    }

                    Repeater {
                        model: root.isSymbols ? ["_", "\"", "!", "?", "%", "+", "="] :
                                                ["z", "x", "c", "v", "b", "n", "m"]
                        KeyButton {
                            label: root.isCapsLock ? modelData.toUpperCase() : modelData
                            btnWidth: (parent.parent.width - 200 - (6 * 8)) / 7
                            onClicked: root.newProfileName += label
                        }
                    }

                    // Backspace Key
                    Rectangle {
                        width: 88
                        height: 52
                        radius: 12
                        color: bsMouse.pressed ? Qt.rgba(255, 255, 255, 0.18) : Qt.rgba(255, 255, 255, 0.08)
                        border.color: Qt.rgba(255, 255, 255, 0.20)
                        border.width: 1
                        Text {
                            anchors.centerIn: parent
                            text: "⌫"
                            color: "#FFFFFF"
                            font.pixelSize: 20
                        }
                        MouseArea {
                            id: bsMouse
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                if (root.newProfileName.length > 0) {
                                    root.newProfileName = root.newProfileName.substring(0, root.newProfileName.length - 1);
                                }
                            }
                        }
                    }
                }

                // Row 4 (?123, Emoji, Globe, Space, ., Enter)
                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 8

                    // ?123 symbol switch
                    Rectangle {
                        width: 90
                        height: 52
                        radius: 12
                        color: root.isSymbols ? Qt.rgba(224/255, 169/255, 109/255, 0.35) : Qt.rgba(255, 255, 255, 0.08)
                        border.color: root.isSymbols ? "#E0A96D" : Qt.rgba(255, 255, 255, 0.20)
                        border.width: 1
                        Text {
                            anchors.centerIn: parent
                            text: root.isSymbols ? "ABC" : "?123"
                            color: "#FFFFFF"
                            font.family: "Inter"
                            font.pixelSize: 15
                            font.weight: Font.DemiBold
                        }
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: root.isSymbols = !root.isSymbols
                        }
                    }

                    // Emoji key
                    Rectangle {
                        width: 60
                        height: 52
                        radius: 12
                        color: Qt.rgba(255, 255, 255, 0.08)
                        border.color: Qt.rgba(255, 255, 255, 0.20)
                        border.width: 1
                        Text { anchors.centerIn: parent; text: "☺"; color: "#FFFFFF"; font.pixelSize: 20 }
                    }

                    // Globe key
                    Rectangle {
                        width: 60
                        height: 52
                        radius: 12
                        color: Qt.rgba(255, 255, 255, 0.08)
                        border.color: Qt.rgba(255, 255, 255, 0.20)
                        border.width: 1
                        Text { anchors.centerIn: parent; text: "🌐"; color: "#FFFFFF"; font.pixelSize: 18 }
                    }

                    // Space bar
                    Rectangle {
                        width: parent.parent.width - 440
                        height: 52
                        radius: 12
                        color: spaceMouse.pressed ? Qt.rgba(255, 255, 255, 0.18) : Qt.rgba(255, 255, 255, 0.08)
                        border.color: Qt.rgba(255, 255, 255, 0.20)
                        border.width: 1
                        Text {
                            anchors.centerIn: parent
                            text: "Space"
                            color: "#FFFFFF"
                            font.family: "Inter"
                            font.pixelSize: 15
                        }
                        MouseArea {
                            id: spaceMouse
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: root.newProfileName += " "
                        }
                    }

                    // Dot key
                    Rectangle {
                        width: 60
                        height: 52
                        radius: 12
                        color: dotMouse.pressed ? Qt.rgba(255, 255, 255, 0.18) : Qt.rgba(255, 255, 255, 0.08)
                        border.color: Qt.rgba(255, 255, 255, 0.20)
                        border.width: 1
                        Text { anchors.centerIn: parent; text: "."; color: "#FFFFFF"; font.pixelSize: 22 }
                        MouseArea {
                            id: dotMouse
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: root.newProfileName += "."
                        }
                    }

                    // Enter Key with Amber Outline
                    Rectangle {
                        width: 110
                        height: 52
                        radius: 12
                        color: enterMouse.pressed ? Qt.rgba(224/255, 169/255, 109/255, 0.35) :
                               (enterMouse.containsMouse ? Qt.rgba(224/255, 169/255, 109/255, 0.18) : Qt.rgba(255, 255, 255, 0.08))
                        border.color: "#E0A96D"
                        border.width: 2
                        Text {
                            anchors.centerIn: parent
                            text: "⏎"
                            color: "#FFFFFF"
                            font.pixelSize: 24
                            font.weight: Font.DemiBold
                        }
                        MouseArea {
                            id: enterMouse
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                if (root.newProfileName.trim() === "") {
                                    root.newProfileName = "Profile " + (VehicleBackend.profileCount + 1);
                                }
                                root.slideDir = 1;
                                root.wizardStep = 2;
                            }
                        }
                    }
                }
            }
        }

        // =====================================================================
        // STEP 2: Seat Adjustments with REAL 3D Seat Model (Matching Reference)
        // =====================================================================
        Item {
            id: wizardStep2
            anchors.fill: parent
            visible: opacity > 0.001
            opacity: profileSwitcherRoot.wizardStep === 2 ? 1.0 : 0.0
            enabled: profileSwitcherRoot.wizardStep === 2 && opacity > 0.8
            transform: Translate {
                x: profileSwitcherRoot.wizardStep === 2 ? 0 : (profileSwitcherRoot.wizardStep > 2 ? -160 : 160)
                Behavior on x {
                    NumberAnimation {
                        duration: 340
                        easing.type: Easing.OutCubic
                    }
                }
            }
            Behavior on opacity { NumberAnimation { duration: 280; easing.type: Easing.InOutQuad } }

            Item {
                anchors.centerIn: parent
                width: Math.min(parent.width - 80, 1140)
                height: Math.min(parent.height - 40, 520)

                // Left Side Text (Matching User's Reference Screenshot Exactly)
                Column {
                    id: seatLeftCol
                    anchors.left: parent.left
                    anchors.leftMargin: 20
                    anchors.verticalCenter: parent.verticalCenter
                    width: 480
                    spacing: 24

                    Text {
                        text: (root.newProfileName.length > 0 ? root.newProfileName : ("Profile " + (VehicleBackend.profileCount + 1))) + " , your seat adjustments are always saved to your profile when changes are made."
                        color: "#FFFFFF"
                        font.family: "Inter"
                        font.pixelSize: 26
                        font.weight: Font.DemiBold
                        wrapMode: Text.WordWrap
                        width: parent.width
                        lineHeight: 1.35
                    }

                    Text {
                        text: "Adjust your seat position, recline angle, lumbar support, and cushion bolsters using the power controls on the side of your seat."
                        color: "#94A3B8"
                        font.family: "Inter"
                        font.pixelSize: 15
                        wrapMode: Text.WordWrap
                        width: parent.width
                        lineHeight: 1.45
                    }
                }

                // Right Side: Purple P1 Badge + 3D Seat Model View
                Item {
                    anchors.left: seatLeftCol.right
                    anchors.leftMargin: 20
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom

                    // Purple Badge "P1" / "P2"
                    Rectangle {
                        anchors.left: parent.left
                        anchors.leftMargin: 20
                        anchors.verticalCenter: parent.verticalCenter
                        width: 96
                        height: 96
                        radius: 48
                        z: 10
                        color: Qt.rgba(59/255, 31/255, 94/255, 0.65)
                        border.color: Qt.rgba(139/255, 92/255, 246/255, 0.50)
                        border.width: 2

                        Text {
                            anchors.centerIn: parent
                            text: {
                                var trimmed = root.newProfileName.trim();
                                if (trimmed.length > 0) {
                                    if (trimmed.toLowerCase().startsWith("profile ") && trimmed.length > 8) {
                                        return "P" + trimmed.substring(8).trim();
                                    }
                                    return trimmed.charAt(0).toUpperCase();
                                }
                                return (VehicleBackend.profileCount === 1 && VehicleBackend.driverProfileName === "Profile 1") ? "P1" : ("P" + (VehicleBackend.profileCount + 1));
                            }
                            color: "#FFFFFF"
                            font.family: "Inter"
                            font.pixelSize: 34
                            font.weight: Font.Bold
                        }
                    }

                    // 3D Luxury Seat Model Loader (Interactive 360° Studio View)
                    Loader {
                        id: wizardSeat3dLoader
                        anchors.fill: parent
                        clip: false
                        z: 2
                        active: root.wizardStep === 2 && root.currentMode === "create_wizard"
                        source: (typeof SeatStudioViewUrl !== "undefined") ? SeatStudioViewUrl : ""

                        onLoaded: {
                            if (item) {
                                item.viewMode = "studio";
                                item.activeSeat = "driver";
                                item.activeCabinTarget = "front";
                                item.seatScale = 0.44;
                                item.seatPitch = 16.0;
                                item.seatYaw = -24.0;
                                item.seatPosX = 0.20;
                                item.seatPosY = -0.72;
                            }
                        }
                    }

                    // High-res Seat Render (clean backdrop / fallback for instant crisp rendering)
                    Image {
                        anchors.centerIn: parent
                        anchors.horizontalCenterOffset: 60
                        source: "qrc:/ApexVision/qml/assets/icons/seat_passenger_render.png"
                        width: 380
                        height: 380
                        fillMode: Image.PreserveAspectFit
                        visible: wizardSeat3dLoader.status !== Loader.Ready
                        z: 1
                    }
                }
            }
        }

        // =====================================================================
        // STEP 3: Link Profile (Key Fob) (Matching Image 3)
        // =====================================================================
        Item {
            id: wizardStep3
            anchors.fill: parent
            visible: opacity > 0.001
            opacity: profileSwitcherRoot.wizardStep === 3 ? 1.0 : 0.0
            enabled: profileSwitcherRoot.wizardStep === 3 && opacity > 0.8
            transform: Translate {
                x: profileSwitcherRoot.wizardStep === 3 ? 0 : (profileSwitcherRoot.wizardStep > 3 ? -160 : 160)
                Behavior on x {
                    NumberAnimation {
                        duration: 340
                        easing.type: Easing.OutCubic
                    }
                }
            }
            Behavior on opacity { NumberAnimation { duration: 280; easing.type: Easing.InOutQuad } }

            Item {
                anchors.centerIn: parent
                width: Math.min(parent.width - 80, 1140)
                height: Math.min(parent.height - 40, 520)

                // Left Side Text
                Column {
                    id: linkLeftCol
                    anchors.left: parent.left
                    anchors.leftMargin: 20
                    anchors.verticalCenter: parent.verticalCenter
                    width: 500
                    spacing: 24

                    Text {
                        text: "To link your key fob to your profile, press the lock button"
                        color: "#FFFFFF"
                        font.family: "Inter"
                        font.pixelSize: 26
                        font.weight: Font.DemiBold
                        wrapMode: Text.WordWrap
                        width: parent.width
                        lineHeight: 1.35
                    }

                    Text {
                        text: "When you unlock and start your vehicle using this key fob, your profile will be loaded."
                        color: "#94A3B8"
                        font.family: "Inter"
                        font.pixelSize: 16
                        wrapMode: Text.WordWrap
                        width: parent.width
                        lineHeight: 1.45
                    }
                }

                // Right Side: Transparent APEX Key Fob
                Item {
                    anchors.left: linkLeftCol.right
                    anchors.leftMargin: 60
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    height: 480

                    Image {
                        id: fobImg
                        anchors.centerIn: parent
                        source: "qrc:/ApexVision/qml/assets/icons/image.png"
                        height: 430
                        fillMode: Image.PreserveAspectFit
                    }

                    // Interactive Lock Button Area Overlay
                    Rectangle {
                        anchors.horizontalCenter: fobImg.horizontalCenter
                        anchors.verticalCenter: fobImg.verticalCenter
                        anchors.verticalCenterOffset: -45
                        width: 86
                        height: 86
                        radius: 43
                        color: root.isKeyFobLinked ? Qt.rgba(56/255, 189/255, 248/255, 0.40) :
                               (fobMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.20) : "transparent")
                        border.color: root.isKeyFobLinked ? "#38BDF8" : (fobMouse.containsMouse ? "#FFFFFF" : "transparent")
                        border.width: 2

                        // Connected badge
                        Rectangle {
                            anchors.centerIn: parent
                            width: 32
                            height: 32
                            radius: 16
                            color: "#10B981"
                            visible: root.isKeyFobLinked

                            Text {
                                anchors.centerIn: parent
                                text: "✓"
                                color: "#FFFFFF"
                                font.pixelSize: 18
                                font.weight: Font.Bold
                            }
                        }

                        MouseArea {
                            id: fobMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                root.isKeyFobLinked = true;
                                VehicleBackend.showToast("Key Fob Linked to " + (root.newProfileName.length > 0 ? root.newProfileName : "Profile") + " ✓");
                            }
                        }
                    }
                }
            }
        }

        // =====================================================================
        // STEP 4: Display Image (Profile Avatar Gallery from Settings)
        // =====================================================================
        Item {
            id: wizardStep4
            anchors.fill: parent
            visible: opacity > 0.001
            opacity: profileSwitcherRoot.wizardStep === 4 ? 1.0 : 0.0
            enabled: profileSwitcherRoot.wizardStep === 4 && opacity > 0.8
            transform: Translate {
                x: profileSwitcherRoot.wizardStep === 4 ? 0 : (profileSwitcherRoot.wizardStep > 4 ? -160 : 160)
                Behavior on x {
                    NumberAnimation {
                        duration: 340
                        easing.type: Easing.OutCubic
                    }
                }
            }
            Behavior on opacity { NumberAnimation { duration: 280; easing.type: Easing.InOutQuad } }

            Item {
                anchors.centerIn: parent
                width: Math.min(parent.width - 60, 1220)
                height: Math.min(parent.height - 40, 530)

                // Left Column: Live Large Circular Preview of Selected Display Image
                Column {
                    id: avatarPreviewCol
                    anchors.left: parent.left
                    anchors.leftMargin: 24
                    anchors.verticalCenter: parent.verticalCenter
                    width: 300
                    spacing: 18

                    // Large Circular Avatar (140x140)
                    Item {
                        width: 140
                        height: 140
                        anchors.horizontalCenter: parent.horizontalCenter

                        // Monogram Fallback
                        Rectangle {
                            anchors.fill: parent
                            radius: 70
                            visible: root.newProfileAvatar === "monogram"
                            gradient: Gradient {
                                GradientStop { position: 0.0; color: "#2563EB" }
                                GradientStop { position: 1.0; color: "#1D4ED8" }
                            }
                            border.color: Qt.rgba(255, 255, 255, 0.40)
                            border.width: 2.5

                            Text {
                                anchors.centerIn: parent
                                text: {
                                    var trimmed = root.newProfileName.trim();
                                    return trimmed.length > 0 ? trimmed.charAt(0).toUpperCase() : "P";
                                }
                                color: "#FFFFFF"
                                font.family: "Inter"
                                font.pixelSize: 56
                                font.weight: Font.DemiBold
                            }
                        }

                        // Image Avatar with Circular Masking
                        Item {
                            anchors.fill: parent
                            visible: root.newProfileAvatar !== "monogram" && root.newProfileAvatarPath !== ""

                            Image {
                                id: previewImg
                                anchors.fill: parent
                                source: root.newProfileAvatarPath
                                fillMode: Image.PreserveAspectCrop
                                visible: false
                                smooth: true
                                mipmap: true
                            }

                            Rectangle {
                                id: previewMask
                                anchors.fill: parent
                                radius: 70
                                visible: false
                                layer.enabled: true
                            }

                            MultiEffect {
                                anchors.fill: parent
                                source: previewImg
                                maskEnabled: true
                                maskSource: previewMask
                            }

                            Rectangle {
                                anchors.fill: parent
                                radius: 70
                                color: "transparent"
                                border.color: "#38BDF8"
                                border.width: 3
                            }
                        }
                    }

                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: root.newProfileName.length > 0 ? root.newProfileName : ("Profile " + (VehicleBackend.profileCount + 1))
                        color: "#FFFFFF"
                        font.family: "Inter"
                        font.pixelSize: 22
                        font.weight: Font.DemiBold
                    }

                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "Choose a display image for your personal profile avatar"
                        color: "#94A3B8"
                        font.family: "Inter"
                        font.pixelSize: 14
                        horizontalAlignment: Text.AlignHCenter
                        width: parent.width - 20
                        wrapMode: Text.WordWrap
                    }
                }

                // Right Column: Grid of All 16 Luxury Artwork Images + Monogram from Settings
                Item {
                    anchors.left: avatarPreviewCol.right
                    anchors.leftMargin: 24
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                    anchors.verticalCenter: parent.verticalCenter
                    height: 440

                    Flickable {
                        anchors.fill: parent
                        contentWidth: avatarGrid.width
                        contentHeight: avatarGrid.implicitHeight + 20
                        clip: false
                        boundsBehavior: Flickable.StopAtBounds

                        Grid {
                            id: avatarGrid
                            anchors.horizontalCenter: parent.horizontalCenter
                            columns: 6
                            spacing: 14
                            topPadding: 10
                            bottomPadding: 10

                            Repeater {
                                model: root.avatarList

                                Rectangle {
                                    width: 78
                                    height: 78
                                    radius: 39
                                    color: isSelected ? Qt.rgba(56/255, 189/255, 248/255, 0.20) : Qt.rgba(255, 255, 255, 0.06)
                                    border.color: isSelected ? "#38BDF8" : Qt.rgba(255, 255, 255, 0.20)
                                    border.width: isSelected ? 2.5 : 1
                                    scale: avatarMouse.containsMouse ? 1.04 : 1.0
                                    Behavior on scale { NumberAnimation { duration: 160 } }

                                    readonly property bool isSelected: root.newProfileAvatar === modelData.id

                                    // Monogram Tile
                                    Item {
                                        anchors.fill: parent
                                        visible: modelData.type === "monogram"

                                        Text {
                                            anchors.centerIn: parent
                                            text: {
                                                var trimmed = root.newProfileName.trim();
                                                return trimmed.length > 0 ? trimmed.charAt(0).toUpperCase() : "P";
                                            }
                                            color: "#FFFFFF"
                                            font.family: "Inter"
                                            font.pixelSize: 28
                                            font.weight: Font.DemiBold
                                        }
                                    }

                                    // Image Tile with Circular Masking
                                    Item {
                                        anchors.fill: parent
                                        anchors.margins: isSelected ? 2.5 : 0
                                        visible: modelData.type === "image"

                                        Image {
                                            id: tileImg
                                            anchors.fill: parent
                                            source: modelData.path
                                            fillMode: Image.PreserveAspectCrop
                                            visible: false
                                            asynchronous: true
                                            smooth: true
                                            mipmap: true
                                        }

                                        Rectangle {
                                            id: tileMask
                                            anchors.fill: parent
                                            radius: 39
                                            visible: false
                                            layer.enabled: true
                                        }

                                        MultiEffect {
                                            anchors.fill: parent
                                            source: tileImg
                                            maskEnabled: true
                                            maskSource: tileMask
                                        }
                                    }

                                    MouseArea {
                                        id: avatarMouse
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: {
                                            root.newProfileAvatar = modelData.id;
                                            root.newProfileAvatarPath = modelData.path;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        // =====================================================================
        // STEP 5: Setup Complete (Matching Image 4)
        // =====================================================================
        Item {
            id: wizardStep5
            anchors.fill: parent
            visible: opacity > 0.001
            opacity: profileSwitcherRoot.wizardStep === 5 ? 1.0 : 0.0
            enabled: profileSwitcherRoot.wizardStep === 5 && opacity > 0.8
            transform: Translate {
                x: profileSwitcherRoot.wizardStep === 5 ? 0 : (profileSwitcherRoot.wizardStep > 5 ? -160 : 160)
                Behavior on x {
                    NumberAnimation {
                        duration: 340
                        easing.type: Easing.OutCubic
                    }
                }
            }
            Behavior on opacity { NumberAnimation { duration: 280; easing.type: Easing.InOutQuad } }

            Item {
                anchors.centerIn: parent
                width: Math.min(parent.width - 80, 1140)
                height: Math.min(parent.height - 40, 520)

                // Left Side: Selected Display Image Avatar with Green Checkmark
                Column {
                    id: completeAvatarCol
                    anchors.left: parent.left
                    anchors.leftMargin: 80
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 20

                    Item {
                        width: 150
                        height: 150
                        anchors.horizontalCenter: parent.horizontalCenter

                        // Monogram Avatar
                        Rectangle {
                            anchors.fill: parent
                            radius: 75
                            visible: root.newProfileAvatar === "monogram" || root.newProfileAvatarPath === ""
                            gradient: Gradient {
                                GradientStop { position: 0.0; color: "#1E293B" }
                                GradientStop { position: 1.0; color: "#0F172A" }
                            }
                            border.color: Qt.rgba(255, 255, 255, 0.20)
                            border.width: 1.5

                            Text {
                                anchors.centerIn: parent
                                text: {
                                    var trimmed = root.newProfileName.trim();
                                    if (trimmed.length > 0) return trimmed.charAt(0).toUpperCase();
                                    return "P";
                                }
                                color: "#FFFFFF"
                                font.family: "Inter"
                                font.pixelSize: 58
                                font.weight: Font.DemiBold
                            }
                        }

                        // Selected Image Avatar with Circular Masking
                        Item {
                            anchors.fill: parent
                            visible: root.newProfileAvatar !== "monogram" && root.newProfileAvatarPath !== ""

                            Image {
                                id: compAvatarImg
                                anchors.fill: parent
                                source: root.newProfileAvatarPath
                                fillMode: Image.PreserveAspectCrop
                                visible: false
                            }

                            Rectangle {
                                id: compAvatarMask
                                anchors.fill: parent
                                radius: 75
                                visible: false
                                layer.enabled: true
                            }

                            MultiEffect {
                                anchors.fill: parent
                                source: compAvatarImg
                                maskEnabled: true
                                maskSource: compAvatarMask
                            }

                            Rectangle {
                                anchors.fill: parent
                                radius: 75
                                color: "transparent"
                                border.color: "#38BDF8"
                                border.width: 2.5
                            }
                        }

                        // Green Checkmark Badge
                        Rectangle {
                            anchors.bottom: parent.bottom
                            anchors.right: parent.right
                            width: 44
                            height: 44
                            radius: 22
                            color: "#10B981"
                            border.color: "#0F172A"
                            border.width: 3

                            Text {
                                anchors.centerIn: parent
                                text: "✓"
                                color: "#FFFFFF"
                                font.pixelSize: 24
                                font.weight: Font.Bold
                            }
                        }
                    }

                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: root.newProfileName.length > 0 ? root.newProfileName : ("Profile " + (VehicleBackend.profileCount + 1))
                        color: "#FFFFFF"
                        font.family: "Inter"
                        font.pixelSize: 24
                        font.weight: Font.DemiBold
                    }
                }

                // Right Side: APEX Connect Phone As A Key Info
                Column {
                    anchors.left: completeAvatarCol.right
                    anchors.leftMargin: 100
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 20

                    Text {
                        text: "The APEX Connect app turns your phone into a key"
                        color: "#FFFFFF"
                        font.family: "Inter"
                        font.pixelSize: 26
                        font.weight: Font.DemiBold
                        wrapMode: Text.WordWrap
                        width: parent.width
                        lineHeight: 1.35
                    }

                    Text {
                        text: "Open the APEX Connect app and follow the instructions to set up Phone As A Key."
                        color: "#94A3B8"
                        font.family: "Inter"
                        font.pixelSize: 16
                        wrapMode: Text.WordWrap
                        width: parent.width
                        lineHeight: 1.45
                    }
                }
            }
        }
    }
}
