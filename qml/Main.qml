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
        anchors.fill: parent

        // Ambient Dark Focus Scrim (Darkens screen when popups are active to highlight focus controls)
        Rectangle {
            anchors.fill: parent
            z: 9
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
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: 72
            z: 10
        }

        // 2. LEFT GLOBAL NAVIGATION RAIL (Stops at climateBar.top)
        SideNavigation {
            id: sideNav
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: climateBar.top
            currentIndex: pageStack.currentIndex
            onPageSelected: function(idx) {
                pageStack.currentIndex = idx;
            }
        }

        // 3. MAIN WORKSPACE (Between Navigation Rail and Right Edge, above ClimateBar)
        Item {
            anchors.left: sideNav.right
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: climateBar.top

            // 3A. RIGHT STATUS BAR (Vertical: Notification, Tower, GPS)
            StatusBar {
                id: statusBar
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: 44
                z: 5
            }

            // 3B. CENTRAL CONTENT AREA (Stacked Pages)
            Item {
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: statusBar.left
                clip: true

                StackLayout {
                    id: pageStack
                    anchors.fill: parent
                    currentIndex: 0

                    // Page 0: Home (Navigation + Media)
                    HomePage {
                        id: homePage
                    }

                    // Page 1: Vehicle
                    VehiclePage {
                        id: vehiclePage
                    }

                    // Page 2: Apps
                    AppsPage {
                        id: appsPage
                    }

                    // Page 3: Phone
                    PhonePage {
                        id: phonePage
                    }

                    // Page 4: Settings
                    SettingsPage {
                        id: settingsPage
                    }
                }
            }
        }
    }
}
