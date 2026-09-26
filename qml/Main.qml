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

        // 1. BOTTOM CLIMATE CONTROL BAR (Permanent: Full-width, covers entire bottom with zero space)
        ClimateBar {
            id: climateBar
            objectName: "climateBar"
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: 72
            z: 40
        }

        // 2. LEFT GLOBAL NAVIGATION RAIL (Stops at climateBar.top)
        SideNavigation {
            id: sideNav
            objectName: "sideNav"
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: climateBar.top
            z: 30
            opacity: (climate3DPanel.airQualityMenuOpen && climate3DPanel.opacity > 0.001) ? 0.0 : 1.0
            enabled: (!climate3DPanel.airQualityMenuOpen || climate3DPanel.opacity <= 0.001) && !climateBar.climate3DOpen
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

                pageStack.currentIndex = idx;
            }
            onClimateCloseRequested: {
                climateBar.climate3DOpen = false;
                climate3DPanel.airQualityMenuOpen = false;
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
            z: 50
        }

        // 4. MAIN WORKSPACE (Between Navigation Rail and Right Status Bar, above ClimateBar)
        Item {
            id: workspaceItem
            anchors.left: sideNav.right
            anchors.right: statusBar.left
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

                // Page 0: Home (Navigation + Media)
                HomePage {
                    id: homePage
                    anchors.fill: parent
                    climateOpen: climateBar.climate3DOpen
                    visible: pageStack.currentIndex === 0
                    opacity: pageStack.currentIndex === 0 ? 1.0 : 0.0
                    enabled: pageStack.currentIndex === 0
                }

                // Page 1: Vehicle (3D Exterior Studio & Control Menu)
                VehiclePage {
                    id: vehiclePage
                    anchors.fill: parent
                    visible: pageStack.currentIndex === 1 || (pageStack.currentIndex === 4 && settingsPage.opacity < 0.99)
                    opacity: pageStack.currentIndex === 1 ? 1.0 : (pageStack.currentIndex === 4 ? 1.0 : 0.0)
                    enabled: pageStack.currentIndex === 1
                    onOpenSettingsRequested: {
                        pageStack.currentIndex = 4;
                    }
                }

                // Page 2: Apps
                AppsPage {
                    id: appsPage
                    anchors.fill: parent
                    visible: pageStack.currentIndex === 2
                    opacity: pageStack.currentIndex === 2 ? 1.0 : 0.0
                    enabled: pageStack.currentIndex === 2
                    onAppSelected: function(name) {
                        if (name === "Settings") {
                            pageStack.currentIndex = 4;
                        } else if (name === "Navigation" || name === "Media Player") {
                            pageStack.currentIndex = 0;
                        } else if (name === "Vehicle Status") {
                            pageStack.currentIndex = 1;
                            if (vehiclePage) {
                                vehiclePage.vehicleStatusPageOpen = true;
                            }
                        } else if (name === "Phone") {
                            pageStack.currentIndex = 3;
                        }
                    }
                }

                // Page 3: Phone
                PhonePage {
                    id: phonePage
                    anchors.fill: parent
                    visible: pageStack.currentIndex === 3
                    opacity: pageStack.currentIndex === 3 ? 1.0 : 0.0
                    enabled: pageStack.currentIndex === 3
                }

                // Page 4: Settings (Smooth fade transition on open & close)
                SettingsPage {
                    id: settingsPage
                    anchors.fill: parent
                    visible: opacity > 0.001
                    opacity: pageStack.currentIndex === 4 ? 1.0 : 0.0
                    enabled: pageStack.currentIndex === 4 && opacity > 0.90
                    Behavior on opacity {
                        NumberAnimation {
                            duration: 250
                            easing.type: Easing.InOutQuad
                        }
                    }
                    onBackRequested: {
                        pageStack.currentIndex = 1;
                    }
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
    }
}
