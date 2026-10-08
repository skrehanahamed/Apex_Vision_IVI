/**
 * ==============================================================================
 * Project: Apex VISION IVI - Digital Cockpit & Infotainment System
 * File: Main.qml
 * Author / Developer: Sk Rehan Ahamed
 * License: MIT
 * ==============================================================================
 */

import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import "components"
import "pages"

Window {
    id: window
    width: 1920
    height: 1200
    visible: true
    title: "APEX VISION IVI"
    color: "#070A0F" // Automotive cockpit deep black

    // Master Layout Container
    Item {
        id: mainRoot
        anchors.fill: parent
        property bool climate3DOpen: climateBar.climate3DOpen
        property bool studioPrewarmed: false
        property bool backgroundPagesActive: false
        readonly property var settingsPage: (typeof settingsLoader !== "undefined" && settingsLoader && settingsLoader.item) ? settingsLoader.item : null
        readonly property var gamesPage: (typeof gamesLoader !== "undefined" && gamesLoader && gamesLoader.item) ? gamesLoader.item : null

        Timer {
            id: studioPrewarmTimer
            interval: 1000
            running: true
            repeat: false
            onTriggered: {
                mainRoot.studioPrewarmed = true;
            }
        }

        // Asynchronous background prewarm timer — fires during WelcomeScreen reveal so pages are 100% ready on unveil
        Timer {
            id: backgroundPrewarmTimer
            interval: 400
            running: true
            repeat: false
            onTriggered: {
                mainRoot.backgroundPagesActive = true;
            }
        }

        // Ambient Dark Focus Scrim (Darkens screen when popups are active to highlight focus controls)
        Rectangle {
            anchors.fill: parent
            z: 35
            color: "#000000"
            visible: opacity > 0.005
            opacity: (climateBar.driverSeatMenuOpen || climateBar.passengerSeatMenuOpen || climateBar.fanMenuOpen) ? 0.70 : 0.0

            Behavior on opacity {
                NumberAnimation { duration: 250; easing.type: Easing.OutCubic }
            }

            MouseArea {
                anchors.fill: parent
                enabled: parent.opacity > 0.05
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    climateBar.driverSeatMenuOpen = false;
                    climateBar.passengerSeatMenuOpen = false;
                    climateBar.fanMenuOpen = false;
                }
            }
        }

        // Rejuvenate sliding bars properties
        readonly property bool rejuvenateSessionActive: typeof RejuvenateController !== "undefined" && (RejuvenateController.active || RejuvenateController.paused)
        readonly property bool rejuvenateBarsVisible: !rejuvenateSessionActive || (typeof fullScreenRejuvenateSession !== "undefined" && fullScreenRejuvenateSession.hudVisible)


        // 1. BOTTOM CLIMATE CONTROL BAR (Permanent: Full-width, covers entire bottom with zero space)
        ClimateBar {
            id: climateBar
            objectName: "climateBar"
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: 72
            z: mainRoot.rejuvenateSessionActive ? 105 : 40

            transform: Translate {
                y: (mainRoot.rejuvenateSessionActive && !mainRoot.rejuvenateBarsVisible) ? 72 : 0
                Behavior on y {
                    NumberAnimation { duration: 380; easing.type: Easing.InOutQuad }
                }
            }
        }

        // 2. LEFT GLOBAL NAVIGATION RAIL (Stops at climateBar.top)
        SideNavigation {
            id: sideNav
            objectName: "sideNav"
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: climateBar.top
            z: mainRoot.rejuvenateSessionActive ? 105 : 30

            transform: Translate {
                x: (mainRoot.rejuvenateSessionActive && !mainRoot.rejuvenateBarsVisible) ? -80 : 0
                Behavior on x {
                    NumberAnimation { duration: 380; easing.type: Easing.InOutQuad }
                }
            }

            opacity: (climate3DPanel.airQualityMenuOpen && climate3DPanel.opacity > 0.001) ? 0.0 : 1.0
            enabled: (!climate3DPanel.airQualityMenuOpen || climate3DPanel.opacity <= 0.001)
            Behavior on opacity { NumberAnimation { duration: 350; easing.type: Easing.InOutQuad } }
            climateActive: climateBar.climate3DOpen
            isRearView: climate3DPanel.isRearView
            currentIndex: pageStack.currentIndex
            onPageSelected: function(idx) {
                // If in 3D climate or air quality, close back to normal IVI
                if (climateBar.climate3DOpen) {
                    climateBar.climate3DOpen = false;
                }
                climate3DPanel.airQualityMenuOpen = false;
                climateBar.fanMenuOpen = false;
                climateBar.driverSeatMenuOpen = false;
                climateBar.passengerSeatMenuOpen = false;

                // Reset Vehicle page overlays to initial screen
                if (vehiclePage && typeof vehiclePage.resetToInitialScreen === "function") {
                    vehiclePage.resetToInitialScreen();
                }

                if (appLoadingOverlay && appLoadingOverlay.opacity > 0.001) {
                    appLoadingOverlay.cancel();
                }

                if (idx === 0) {
                    if (pageStack.currentIndex === 0 && homePage && homePage.navExpanded) {
                        homePage.triggerNavToggle(false);
                        return;
                    } else if (pageStack.currentIndex !== 0 && homePage) {
                        homePage.collapseNav();
                    }
                } else {
                    if (homePage) {
                        homePage.collapseNav();
                    }
                }

                pageStack.currentIndex = idx;
            }
            onClimateCloseRequested: {
                climateBar.climate3DOpen = false;
                climate3DPanel.airQualityMenuOpen = false;
                if (homePage) {
                    homePage.collapseNav();
                }
                pageStack.currentIndex = 0;
            }
        }

        // 3. RIGHT STATUS BAR (Vertical: Notification, Tower, GPS - solid cockpit black)
        StatusBar {
            id: statusBar
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: climateBar.top
            width: 44
            visible: true
            clip: true
            z: mainRoot.rejuvenateSessionActive ? 105 : 50

            transform: Translate {
                x: (mainRoot.rejuvenateSessionActive && !mainRoot.rejuvenateBarsVisible) ? 44 : 0
                Behavior on x {
                    NumberAnimation { duration: 380; easing.type: Easing.InOutQuad }
                }
            }
        }

        // 4. MAIN WORKSPACE (Between Navigation Rail and Right Status Bar, above ClimateBar)
        Item {
            id: workspaceItem
            anchors.left: sideNav.right
            anchors.right: (statusBar.visible && statusBar.width > 0) ? statusBar.left : parent.right
            anchors.top: parent.top
            anchors.bottom: climateBar.top
            clip: true
            z: 5

            enabled: !climateBar.climate3DOpen
            visible: !climateBar.climate3DOpen || opacity > 0.001
            opacity: climateBar.climate3DOpen ? 0.0 : 1.0
            Behavior on opacity {
                NumberAnimation {
                    duration: 350
                    easing.type: Easing.InOutQuad
                }
            }

            // Master Project Default Background (Excluding sideNav, climateBar, and statusBar)
            Image {
                id: projectDefaultBackground
                anchors.fill: parent
                source: "qrc:/ApexVision/qml/assets/default_background.png"
                fillMode: Image.PreserveAspectCrop
                smooth: true
                z: 0
            }

            // Central Stacked Pages
            Item {
                id: pageStack
                objectName: "pageStack"
                anchors.fill: parent
                property int currentIndex: 0
                z: 1

                onCurrentIndexChanged: {
                    if (currentIndex !== 8) {
                        if (videoPage) {
                            videoPage.stopVideo();
                        }
                        VideoBackend.closePlayer();
                    }
                    if (currentIndex !== 9) {
                        if (typeof RejuvenateController !== "undefined" && (RejuvenateController.active || RejuvenateController.paused)) {
                            RejuvenateController.endSession(true);
                        }
                    }
                }

                // Page 0: Home (Navigation + Media)
                HomePage {
                    id: homePage
                    objectName: "homePage"
                    anchors.fill: parent
                    z: (pageStack.currentIndex === 0) ? 10 : 2
                    climateOpen: climateBar.climate3DOpen
                    visible: pageStack.currentIndex === 0 || opacity > 0.001
                    opacity: pageStack.currentIndex === 0 ? 1.0 : 0.0
                    enabled: pageStack.currentIndex === 0 && opacity > 0.8
                    transform: Translate {
                        x: pageStack.currentIndex === 7 ? -220 : 0
                        Behavior on x {
                            NumberAnimation {
                                duration: 340
                                easing.type: Easing.OutCubic
                            }
                        }
                    }
                    Behavior on opacity {
                        NumberAnimation {
                            duration: 320
                            easing.type: Easing.InOutCubic
                        }
                    }
                    onOpenPlayerRequested: {
                        radioPage.returnIndex = 0;
                        pageStack.currentIndex = 7;
                    }
                    onOpenProfileRequested: {
                        if (typeof profileSwitcherPage !== "undefined" && profileSwitcherPage) {
                            profileSwitcherPage.returnIndex = 0;
                        }
                        pageStack.currentIndex = 11;
                    }
                }

                // Page 1: Vehicle (3D Exterior Studio & Control Menu)
                VehiclePage {
                    id: vehiclePage
                    anchors.fill: parent
                    z: (pageStack.currentIndex === 1) ? 15 : 1
                    visible: pageStack.currentIndex === 1 || !mainRoot.studioPrewarmed || opacity > 0.01
                    opacity: (pageStack.currentIndex === 1) ? 1.0 : (mainRoot.studioPrewarmed ? 0.0 : 0.001)
                    enabled: pageStack.currentIndex === 1 && opacity > 0.8
                    Behavior on opacity {
                        NumberAnimation {
                            duration: 320
                            easing.type: Easing.InOutCubic
                        }
                    }
                    onOpenSettingsRequested: {
                        pageStack.currentIndex = 4;
                    }
                }

                // Page 2: Apps
                AppsPage {
                    id: appsPage
                    objectName: "appsPage"
                    anchors.fill: parent
                    visible: opacity > 0.001
                    opacity: pageStack.currentIndex === 2 ? 1.0 : 0.0
                    enabled: pageStack.currentIndex === 2 && opacity > 0.8
                    Behavior on opacity {
                        NumberAnimation {
                            duration: 320
                            easing.type: Easing.InOutCubic
                        }
                    }
                    onAppSelected: function(name, icon) {
                        var targetIdx = -1;
                        if (name === "ProfileSwitcher") {
                            targetIdx = 11;
                            if (typeof profileSwitcherPage !== "undefined" && profileSwitcherPage) {
                                profileSwitcherPage.returnIndex = 2;
                            }
                        } else if (name === "Settings" || name === "Bluetooth" || name === "Bluetooth Audio") {
                            targetIdx = 4;
                            if (typeof settingsPage !== "undefined" && settingsPage) {
                                settingsPage.returnIndex = 2;
                                if (icon && icon.indexOf("profile") !== -1) {
                                    settingsPage.returnIndex = 11;
                                    settingsPage.activeCategory = "profile";
                                } else if (name === "Bluetooth" || name === "Bluetooth Audio") {
                                    settingsPage.activeCategory = "bluetooth";
                                }
                            }
                        } else if (name === "AM" || name === "RadioAM") {
                            MediaBackend.setSource("AM");
                            targetIdx = 7;
                        } else if (name === "FM" || name === "RadioFM") {
                            MediaBackend.setSource("FM");
                            targetIdx = 7;
                        } else if (name === "SatelliteRadio" || name === "OrbitXM" || name === "SiriusXM") {
                            MediaBackend.setSource("OrbitXM");
                            targetIdx = 7;
                        } else if (name === "Navigation") {
                            targetIdx = 0;
                            if (homePage) {
                                homePage.openFullNavigation(false);
                            }
                        } else if (name === "Media Player" || name === "Media" || name === "Assistant") {
                            targetIdx = 0;
                        } else if (name === "CarPlay" || name === "Apple CarPlay" || name === "AppleCarPlay") {
                            mobileDeviceConnectionPage.projectionType = "carplay";
                            targetIdx = 12;
                        } else if (name === "AndroidAuto" || name === "Android Auto") {
                            mobileDeviceConnectionPage.projectionType = "android_auto";
                            targetIdx = 12;
                        } else if (name === "Vehicle Status") {
                            targetIdx = 1;
                            if (vehiclePage) {
                                vehiclePage.vehicleStatusPageOpen = true;
                            }
                        } else if (name === "Towing" || name === "Trailer") {
                            targetIdx = 5;
                        } else if (name === "News") {
                            targetIdx = 6;
                        } else if (name === "Video" || name === "YouTube") {
                            targetIdx = 8;
                        } else if (name === "Phone") {
                            targetIdx = 3;
                        } else if (name === "Messages") {
                            targetIdx = 13;
                        } else if (name === "Manual") {
                            targetIdx = 10;
                        } else if (name === "Updates" || name === "Software Updates") {
                            targetIdx = 4;
                            if (typeof settingsPage !== "undefined" && settingsPage) {
                                settingsPage.returnIndex = 2;
                                settingsPage.activeCategory = "system";
                                settingsPage.sysSlideDir = 1;
                                settingsPage.sysCurrentScreen = "system_update";
                            }
                        } else if (name === "Rejuvenate") {
                            targetIdx = 9;
                        } else if (name === "Games") {
                            targetIdx = 14;
                        }

                        var iconPath = (icon && icon !== "") ? icon : "qrc:/ApexVision/qml/assets/icons/app_trailer.svg";
                        appLoadingOverlay.launch(iconPath, targetIdx, name);
                    }
                }

                // Page 3: Phone
                PhonePage {
                    id: phonePage
                    anchors.fill: parent
                    visible: opacity > 0.001
                    opacity: pageStack.currentIndex === 3 ? 1.0 : 0.0
                    enabled: pageStack.currentIndex === 3 && opacity > 0.8
                    Behavior on opacity {
                        NumberAnimation {
                            duration: 320
                            easing.type: Easing.InOutCubic
                        }
                    }
                    onBackRequested: {
                        pageStack.currentIndex = 2; // Return to Apps page
                    }
                    onOpenBluetoothRequested: {
                        pageStack.currentIndex = 4; // Settings Page
                        if (typeof settingsPage !== "undefined" && settingsPage) {
                            settingsPage.returnIndex = 3;
                            settingsPage.activeCategory = "bluetooth";
                        }
                    }
                }

                // Page 4: Settings (Asynchronous background pre-warming via dynamic source)
                Loader {
                    id: settingsLoader
                    anchors.fill: parent
                    z: (pageStack.currentIndex === 4) ? 25 : 1
                    visible: opacity > 0.001
                    opacity: pageStack.currentIndex === 4 ? 1.0 : 0.0
                    enabled: pageStack.currentIndex === 4 && opacity > 0.90
                    asynchronous: true
                    active: mainRoot.backgroundPagesActive || pageStack.currentIndex === 4
                    source: (mainRoot.backgroundPagesActive || pageStack.currentIndex === 4) ? "pages/SettingsPage.qml" : ""
                    onLoaded: {
                        if (item) {
                            item.returnIndex = 1;
                            item.backRequested.connect(function() {
                                if (item.activeCategory === "profile" && item.returnIndex === 1) {
                                    item.returnIndex = 11;
                                }
                                pageStack.currentIndex = item.returnIndex;
                                item.returnIndex = 1;
                            });
                        }
                    }
                    Behavior on opacity {
                        NumberAnimation {
                            duration: 320
                            easing.type: Easing.InOutCubic
                        }
                    }
                }

                // Page 5: Towing & Trailers (Matching Screenshot 2)
                TowingPage {
                    id: towingPage
                    anchors.fill: parent
                    visible: pageStack.currentIndex === 5 || opacity > 0.001
                    opacity: pageStack.currentIndex === 5 ? 1.0 : 0.0
                    enabled: pageStack.currentIndex === 5 && opacity > 0.8
                    Behavior on opacity {
                        NumberAnimation {
                            duration: 320
                            easing.type: Easing.InOutCubic
                        }
                    }
                    onOpenSettingsRequested: {
                        pageStack.currentIndex = 4;
                    }
                    onBackRequested: {
                        pageStack.currentIndex = 2;
                    }
                }

                // Page 6: Live News Feed (Free News API)
                NewsPage {
                    id: newsPage
                    objectName: "newsPage"
                    anchors.fill: parent
                    visible: pageStack.currentIndex === 6 || opacity > 0.001
                    opacity: pageStack.currentIndex === 6 ? 1.0 : 0.0
                    enabled: pageStack.currentIndex === 6 && opacity > 0.8
                    Behavior on opacity {
                        NumberAnimation {
                            duration: 320
                            easing.type: Easing.InOutCubic
                        }
                    }
                    onBackRequested: {
                        pageStack.currentIndex = 2; // Return to Apps page
                    }
                }

                // Page 7: AM/FM Radio (Matching Reference Screenshot 1)
                RadioPage {
                    id: radioPage
                    objectName: "radioPage"
                    anchors.fill: parent
                    visible: pageStack.currentIndex === 7 || opacity > 0.001
                    opacity: pageStack.currentIndex === 7 ? 1.0 : 0.0
                    enabled: pageStack.currentIndex === 7 && opacity > 0.8
                    transform: Translate {
                        x: pageStack.currentIndex === 7 ? 0 : (pageStack.currentIndex < 7 ? 220 : -220)
                        Behavior on x {
                            NumberAnimation {
                                duration: 340
                                easing.type: Easing.OutCubic
                            }
                        }
                    }
                    Behavior on opacity {
                        NumberAnimation {
                            duration: 320
                            easing.type: Easing.InOutCubic
                        }
                    }
                    property int returnIndex: 2
                    onBackRequested: {
                        pageStack.currentIndex = returnIndex;
                        returnIndex = 2; // Return to Apps page default
                    }
                    onOpenSettingsRequested: {
                        pageStack.currentIndex = 4;
                    }
                    onOpenBluetoothRequested: {
                        pageStack.currentIndex = 4;
                        if (typeof settingsPage !== "undefined" && settingsPage) {
                            settingsPage.returnIndex = 7;
                            settingsPage.activeCategory = "bluetooth";
                        }
                    }
                    onOpenAppsRequested: {
                        pageStack.currentIndex = 2;
                    }
                }

                // Page 8: YouTube Video (Native Tabbed Interface)
                VideoPage {
                    id: videoPage
                    objectName: "videoPage"
                    anchors.fill: parent
                    visible: pageStack.currentIndex === 8 || opacity > 0.001
                    opacity: pageStack.currentIndex === 8 ? 1.0 : 0.0
                    enabled: pageStack.currentIndex === 8 && opacity > 0.8
                    Behavior on opacity {
                        NumberAnimation {
                            duration: 320
                            easing.type: Easing.InOutCubic
                        }
                    }
                    onBackRequested: {
                        if (videoPage) {
                            videoPage.stopVideo();
                        }
                        VideoBackend.closePlayer();
                        pageStack.currentIndex = 2; // Return to Apps page
                    }
                }

                // Page 9: APEX VISION Rejuvenate (Stationary Wellness Experience)
                RejuvenatePage {
                    id: rejuvenatePage
                    objectName: "rejuvenatePage"
                    anchors.fill: parent
                    visible: pageStack.currentIndex === 9 || opacity > 0.001
                    opacity: pageStack.currentIndex === 9 ? 1.0 : 0.0
                    enabled: pageStack.currentIndex === 9 && opacity > 0.8
                    Behavior on opacity {
                        NumberAnimation {
                            duration: 320
                            easing.type: Easing.InOutCubic
                        }
                    }
                    onBackRequested: {
                        if (typeof RejuvenateController !== "undefined" && (RejuvenateController.active || RejuvenateController.paused)) {
                            RejuvenateController.endSession(true);
                        }
                        pageStack.currentIndex = 2; // Return to Apps page
                    }
                }

                // Page 10: Digital Owner's Manual
                ManualPage {
                    id: manualPage
                    objectName: "manualPage"
                    anchors.fill: parent
                    visible: pageStack.currentIndex === 10 || opacity > 0.001
                    opacity: pageStack.currentIndex === 10 ? 1.0 : 0.0
                    enabled: pageStack.currentIndex === 10 && opacity > 0.8
                    Behavior on opacity {
                        NumberAnimation {
                            duration: 320
                            easing.type: Easing.InOutCubic
                        }
                    }
                    onBackRequested: {
                        pageStack.currentIndex = 2; // Return to Apps page
                    }
                }

                // Page 11: Personal Profiles Switcher & Creation (Separate Modular QML file)
                ProfileSwitcherPage {
                    id: profileSwitcherPage
                    objectName: "profileSwitcherPage"
                    anchors.fill: parent
                    visible: pageStack.currentIndex === 11 || opacity > 0.001
                    opacity: pageStack.currentIndex === 11 ? 1.0 : 0.0
                    enabled: pageStack.currentIndex === 11 && opacity > 0.8
                    Behavior on opacity {
                        NumberAnimation {
                            duration: 320
                            easing.type: Easing.InOutCubic
                        }
                    }
                    property int returnIndex: 0
                    onBackRequested: {
                        pageStack.currentIndex = returnIndex;
                        returnIndex = 0;
                    }
                    onOpenProfileSettingsRequested: {
                        if (typeof settingsPage !== "undefined" && settingsPage) {
                            settingsPage.returnIndex = 11;
                            settingsPage.activeCategory = "profile";
                            settingsPage.profCurrentScreen = "main";
                        }
                        pageStack.currentIndex = 4;
                    }
                }

                // Page 12: Mobile Device Connection (Apple CarPlay & Android Auto)
                MobileDeviceConnectionPage {
                    id: mobileDeviceConnectionPage
                    objectName: "mobileDeviceConnectionPage"
                    anchors.fill: parent
                    visible: pageStack.currentIndex === 12 || opacity > 0.001
                    opacity: pageStack.currentIndex === 12 ? 1.0 : 0.0
                    enabled: pageStack.currentIndex === 12 && opacity > 0.8
                    Behavior on opacity {
                        NumberAnimation {
                            duration: 320
                            easing.type: Easing.InOutCubic
                        }
                    }
                    onBackRequested: {
                        pageStack.currentIndex = 2; // Return to Apps page
                    }
                    onOpenBluetoothRequested: {
                        pageStack.currentIndex = 4; // Settings Page
                        if (typeof settingsPage !== "undefined" && settingsPage) {
                            settingsPage.returnIndex = 12;
                            settingsPage.activeCategory = "bluetooth";
                        }
                    }
                }

                // Page 13: Messages (Smartphone Text Messaging)
                MessagesPage {
                    id: messagesPage
                    objectName: "messagesPage"
                    anchors.fill: parent
                    visible: pageStack.currentIndex === 13 || opacity > 0.001
                    opacity: pageStack.currentIndex === 13 ? 1.0 : 0.0
                    enabled: pageStack.currentIndex === 13 && opacity > 0.8
                    Behavior on opacity {
                        NumberAnimation {
                            duration: 320
                            easing.type: Easing.InOutCubic
                        }
                    }
                    onBackRequested: {
                        pageStack.currentIndex = 2; // Return to Apps page
                    }
                    onOpenBluetoothRequested: {
                        pageStack.currentIndex = 4; // Settings Page
                        if (typeof settingsPage !== "undefined" && settingsPage) {
                            settingsPage.returnIndex = 13;
                            settingsPage.activeCategory = "bluetooth";
                        }
                    }
                }

                // Page 14: Games (Asynchronous background pre-warming)
                Loader {
                    id: gamesLoader
                    objectName: "gamesLoader"
                    anchors.fill: parent
                    visible: pageStack.currentIndex === 14 || opacity > 0.001
                    opacity: pageStack.currentIndex === 14 ? 1.0 : 0.0
                    enabled: pageStack.currentIndex === 14 && opacity > 0.8
                    asynchronous: true
                    active: mainRoot.backgroundPagesActive || pageStack.currentIndex === 14
                    source: (mainRoot.backgroundPagesActive || pageStack.currentIndex === 14) ? "pages/GamesPage.qml" : ""
                    onLoaded: {
                        if (item) {
                            item.backRequested.connect(function() {
                                pageStack.currentIndex = 2; // Return to Apps page
                            });
                        }
                    }
                    Behavior on opacity {
                        NumberAnimation {
                            duration: 320
                            easing.type: Easing.InOutCubic
                        }
                    }
                }
            }

            // 6. APP LAUNCH SPLASH / LOADING SCREEN (Solid Black 1s Screen with Centered Icon)
            Rectangle {
                id: appLoadingOverlay
                anchors.fill: parent
                color: "#000000" // Pure solid cockpit black
                z: 100
                visible: opacity > 0.001
                opacity: 0.0

                property string iconSource: "qrc:/ApexVision/qml/assets/icons/app_trailer.svg"
                property int targetIndex: 5
                property string appName: ""

                Behavior on opacity {
                    id: overlayFadeBehavior
                    NumberAnimation {
                        duration: 360
                        easing.type: Easing.InOutCubic
                    }
                }

                // Centered frosted ice-blue card with app icon (or clean borderless official logo for YouTube)
                Rectangle {
                    id: splashCard
                    anchors.centerIn: parent
                    readonly property bool isYouTube: appLoadingOverlay.appName === "YouTube" || appLoadingOverlay.targetIndex === 8
                    width: isYouTube ? 140 : 108
                    height: isYouTube ? 98 : 108
                    radius: isYouTube ? 0 : 22
                    color: isYouTube ? "transparent" : "#DDEAF8"
                    border.color: isYouTube ? "transparent" : Qt.rgba(255, 255, 255, 0.45)
                    border.width: isYouTube ? 0 : 1
                    scale: 1.0

                    Behavior on scale {
                        id: cardScaleBehavior
                        NumberAnimation {
                            duration: 320
                            easing.type: Easing.OutBack
                            easing.overshoot: 1.15
                        }
                    }

                    Image {
                        id: splashIcon
                        anchors.centerIn: parent
                        width: splashCard.isYouTube ? 130 : 74
                        height: splashCard.isYouTube ? 91 : 74
                        source: appLoadingOverlay.iconSource
                        fillMode: Image.PreserveAspectFit
                        smooth: true
                        mipmap: true
                        sourceSize: Qt.size(512, 512)
                    }
                }

                // 1-second hold timer then smooth dissolve to reveal Towing page
                Timer {
                    id: splashTimer
                    interval: 1000 // Exactly 1 second
                    repeat: false
                    onTriggered: {
                        appLoadingOverlay.opacity = 0.0;
                        if (appLoadingOverlay.appName === "Navigation" && homePage) {
                            homePage.openFullNavigation(false);
                        }
                    }
                }

                function launch(icon, targetIdx, name) {
                    appName = (name !== undefined) ? name : "";
                    iconSource = icon;
                    targetIndex = (targetIdx !== undefined) ? targetIdx : -1;

                    // Immediately pop solid black without delay to eliminate any 1-frame flicker
                    overlayFadeBehavior.enabled = false;
                    appLoadingOverlay.opacity = 1.0;
                    overlayFadeBehavior.enabled = true;

                    // Spring card animation
                    cardScaleBehavior.enabled = false;
                    splashCard.scale = 0.82;
                    cardScaleBehavior.enabled = true;
                    splashCard.scale = 1.0;

                    // Switch pageStack underneath the solid black overlay (if valid target)
                    if (targetIndex >= 0) {
                        if (pageStack.currentIndex === 8 && targetIndex !== 8) {
                            if (videoPage) {
                                videoPage.stopVideo();
                            }
                            VideoBackend.closePlayer();
                        }
                        pageStack.currentIndex = targetIndex;
                        if (targetIndex === 0 && appName === "Navigation" && homePage) {
                            homePage.openFullNavigation(false);
                        }
                    }

                    // Run the 1-second splash timer
                    splashTimer.restart();
                }

                function cancel() {
                    splashTimer.stop();
                    overlayFadeBehavior.enabled = false;
                    appLoadingOverlay.opacity = 0.0;
                    overlayFadeBehavior.enabled = true;
                }
            }
        }

        // 5. 3D CLIMATE OVERLAY (Fades in cabin, controls slide in)
        Climate3DPanel {
            id: climate3DPanel
            objectName: "climate3DPanel"
            anchors.left: (climate3DPanel.airQualityMenuOpen && climate3DPanel.opacity > 0.001) ? parent.left : sideNav.right
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: climateBar.top
            z: (climate3DPanel.airQualityMenuOpen && climate3DPanel.opacity > 0.001) ? 50 : 20
            isOpen: climateBar.climate3DOpen
            onCloseRequested: {
                climateBar.climate3DOpen = false;
                pageStack.currentIndex = 0;
            }
        }

        // 6. VALET MODE FULL CENTER SCREEN LOCK OVERLAY
        ValetLockOverlay {
            id: valetLockOverlay
            objectName: "valetLockOverlay"
            anchors.fill: parent
            z: 100
            targetPin: (vehiclePage && vehiclePage.valetPin !== "") ? vehiclePage.valetPin : "1234"
            isLocked: vehiclePage ? vehiclePage.isValetLocked : false
            onUnlocked: {
                if (vehiclePage) {
                    vehiclePage.isValetLocked = false;
                }
            }
        }

        // 7. FULL-SCREEN REJUVENATE IMMERSION SESSION (True Edge-to-Edge 1920x1200 Display)
        RejuvenateSession {
            id: fullScreenRejuvenateSession
            anchors.fill: parent
            z: 95
            visible: typeof RejuvenateController !== "undefined" && (RejuvenateController.active || RejuvenateController.paused || RejuvenateController.isCompleted)
            onExitSessionRequested: {
                if (typeof RejuvenateController !== "undefined") {
                    RejuvenateController.endSession(true);
                }
            }
        }

        // Stop background sound/music/video when Rejuvenate experience is running
        Connections {
            target: typeof RejuvenateController !== "undefined" ? RejuvenateController : null
            function onActiveChanged() {
                if (RejuvenateController.active || RejuvenateController.isPreparing) {
                    if (typeof MediaBackend !== "undefined") {
                        MediaBackend.setIsPlaying(false);
                        MediaBackend.pausePlayback();
                    }
                    if (typeof VideoBackend !== "undefined" && VideoBackend.playerVisible) {
                        VideoBackend.closePlayer();
                    }
                }
            }
            function onIsPreparingChanged() {
                if (RejuvenateController.isPreparing) {
                    if (typeof MediaBackend !== "undefined") {
                        MediaBackend.setIsPlaying(false);
                        MediaBackend.pausePlayback();
                    }
                    if (typeof VideoBackend !== "undefined" && VideoBackend.playerVisible) {
                        VideoBackend.closePlayer();
                    }
                }
            }
        }

        // Auto-fallback from disconnected media sources (Bluetooth, CarPlay, USB) to OrbitXM
        Connections {
            target: typeof PhoneBackend !== "undefined" ? PhoneBackend : null
            function onIsConnectedChanged() {
                if (PhoneBackend && !PhoneBackend.isConnected) {
                    if (typeof MediaBackend !== "undefined" && (MediaBackend.source === "Bluetooth" || MediaBackend.source === "CarPlay" || MediaBackend.source === "USB")) {
                        MediaBackend.setSource("OrbitXM");
                    }
                }
            }
        }

        // =====================================================================
        // MASTER HARDWARE / SOFTWARE SCREEN BRIGHTNESS DIMMER
        // Dims display dynamically based on SystemBackend.brightness.
        // Calibrated with a safe floor so the display NEVER becomes dark or invisible.
        // =====================================================================
        Rectangle {
            id: displayBrightnessDimmer
            anchors.fill: parent
            z: 9999
            color: "#000000"
            // At 100% brightness: opacity is 0.0 (full brightness)
            // At 10% brightness: opacity is 0.65 (retains 35% luminance, clear and readable)
            // Floor ensures screen is ALWAYS visible and never pitch black
            opacity: {
                var b = typeof SystemBackend !== "undefined" ? SystemBackend.brightness : 85;
                var clampedB = Math.max(10, Math.min(100, b));
                return (1.0 - (clampedB - 10) / 90.0) * 0.65;
            }
            visible: opacity > 0.005
            enabled: false // Transparent to all mouse and touch events

            Behavior on opacity {
                NumberAnimation { duration: 160; easing.type: Easing.OutQuad }
            }
        }

        // 8. AUTOMOTIVE OEM WELCOME SCREEN & STARTUP ANIMATION (APEX VISION Brand Evolution)
        WelcomeScreen {
            id: welcomeScreen
            anchors.fill: parent
            z: 10000
            onFinished: {
                if (typeof MediaBackend !== "undefined") {
                    MediaBackend.startPlaybackAfterBoot();
                }
            }
        }

        Component.onCompleted: {
            if (typeof PhoneBackend !== "undefined" && !PhoneBackend.isConnected) {
                if (typeof MediaBackend !== "undefined" && (MediaBackend.source === "Bluetooth" || MediaBackend.source === "CarPlay" || MediaBackend.source === "USB")) {
                    MediaBackend.setSource("OrbitXM");
                }
            }
        }
    }
}
