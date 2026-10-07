/**
 * ==============================================================================
 * Project: Apex VISION IVI - Digital Cockpit & Infotainment System
 * File: ClimateCabinView.qml
 * Author / Developer: Sk Rehan Ahamed
 * License: MIT
 * ==============================================================================
 */

import QtQuick
import QtQuick3D
import QtQuick3D.Helpers
import "CarModel_Climate"

Item {
    id: cabinView

    // -------------------------------------------------------------------------
    // Public Climate Control API (for parent / IVI host integration)
    // -------------------------------------------------------------------------
    property int fanSpeed: 4               // 0 (Off) to 7 (Max)
    property real temperature: 20.5        // Celsius: 16.0 to 28.0
    property bool acActive: true           // AC toggle
    property bool maxAcActive: false       // MAX A/C preset
    property bool maxDefrostActive: false  // MAX DEFROST preset

    // Airflow Mode: "AUTO", "FACE", "FACE_FEET", "FEET", "DEFROST", "DEFROST_FEET"
    property string airflowMode: "FACE"

    // Independent Vent Group Visibility (can be independently enabled/disabled)
    property bool leftAirflowVisible: true
    property bool centerLeftAirflowVisible: true
    property bool centerRightAirflowVisible: true
    property bool rightAirflowVisible: true
    property bool footwellAirflowVisible: true
    property bool windshieldDefrostVisible: true
    property bool rearActive: true
    property bool isRearView: false
    property int rearFanSpeed: 2
    property bool rearPower: true
    property real rearTemperature: 22.0
    property int rearAirflowMode: 0
    property bool rearAutoMode: true

    // Mode properties and compatibility bindings
    property bool faceVentsActive: true
    property bool defrostActive: false
    property bool feetActive: false

    // Computed Mode States
    readonly property bool isFaceActive: faceVentsActive && (airflowMode === "FACE" || airflowMode === "FACE_FEET" || airflowMode === "AUTO")
    readonly property bool isFeetActive: feetActive || (airflowMode === "FEET" || airflowMode === "FACE_FEET" || airflowMode === "DEFROST_FEET")
    readonly property bool isDefrostActive: defrostActive || (airflowMode === "DEFROST" || airflowMode === "DEFROST_FEET" || maxDefrostActive)

    // Dynamic airflow temperature color:
    // Normal cooling: translucent cool white → cyan/blue (#c2eeff)
    // Heating: slightly warmer white / very subtle warm tint (#fff4ea), NOT bright orange/red
    readonly property color coolColor: "#42b8ff"
    readonly property color warmColor: "#fff4ea"
    readonly property color starryNightBlue: "#0b1c38"

    readonly property color airColor: {
        if (!acActive || temperature >= 23.5) return warmColor;
        return coolColor;
    }

    // Parallax interactive camera offsets
    property real camParallaxX: 0.0
    property real camParallaxY: 0.0
    property real camYawParallax: 0.0
    property real camPitchParallax: 0.0

    // -------------------------------------------------------------------------
    // 3D Viewport
    // -------------------------------------------------------------------------
    View3D {
        id: view3D
        anchors.fill: parent
        renderMode: View3D.Offscreen

        environment: SceneEnvironment {
            id: sceneEnv
            clearColor: "#040810"
            backgroundMode: SceneEnvironment.Color
            antialiasingMode: SceneEnvironment.MSAA
            antialiasingQuality: SceneEnvironment.High
            tonemapMode: SceneEnvironment.TonemapModeLinear
        }

        // Animated Camera Rig: Glides between Front Cockpit and Rear Passenger Seat view
        Node {
            id: cameraRig

            readonly property vector3d frontPos: Qt.vector3d(cabinView.camParallaxX, 1.100 + cabinView.camParallaxY, -0.400)
            readonly property vector3d frontRot: Qt.vector3d(-16.0 + cabinView.camPitchParallax, 180.0 + cabinView.camYawParallax, 0.0)

            readonly property vector3d rearPos: Qt.vector3d(cabinView.camParallaxX * 0.5, 1.720 + cabinView.camParallaxY * 0.5, -1.550)
            readonly property vector3d rearRot: Qt.vector3d(-42.0 + cabinView.camPitchParallax * 0.5, 180.0 + cabinView.camYawParallax * 0.5, 0.0)

            position: cabinView.isRearView ? rearPos : frontPos
            eulerRotation: cabinView.isRearView ? rearRot : frontRot

            Behavior on position {
                Vector3dAnimation { duration: 800; easing.type: Easing.InOutCubic }
            }
            Behavior on eulerRotation {
                Vector3dAnimation { duration: 800; easing.type: Easing.InOutCubic }
            }

            PerspectiveCamera {
                id: cockpitCamera
                clipNear: 0.04
                clipFar: 60.0
                fieldOfView: 62.0
            }
        }

        // ---------------------------------------------------------------------
        // Comprehensive Luxury Cockpit Lighting (Even Interior Illumination)
        // ---------------------------------------------------------------------
        // 1. Cabin Key Overhead Light: Illuminates dashboard, steering wheel & seats
        DirectionalLight {
            id: cabinKeyLight
            eulerRotation: Qt.vector3d(-55, 15, 0)
            color: "#f8fbff"
            brightness: 2.2
            castsShadow: false
        }

        // 2. Dome Diffuse Light: Illuminates center console, seats & carpet
        // Dedicated Front Seats & Leather Illumination Light
        PointLight {
            id: frontSeatsLight
            position: Qt.vector3d(0.0, 1.20, -0.15)
            color: "#eef5ff"
            brightness: cabinView.isRearView ? 0.20 : 2.2
            castsShadow: false
            Behavior on brightness { NumberAnimation { duration: 400 } }
        }

        DirectionalLight {
            id: overheadSoftLight
            eulerRotation: Qt.vector3d(-85, -15, 0)
            color: "#e2ecfa"
            brightness: 1.8
            castsShadow: false
        }

        // 3. Lower Dashboard & Center Vent Light: Makes vents, louvers & controls clearly visible
        PointLight {
            id: dashFillLight
            position: Qt.vector3d(0.0, 0.72, 0.48)
            color: "#ffffff"
            brightness: 3.2
            castsShadow: false
        }

        // 4. Driver Cockpit & Steering Column Light: Illuminates driver dash, pedals & door
        PointLight {
            id: driverDashLight
            position: Qt.vector3d(0.38, 0.75, 0.35)
            color: "#f0f5ff"
            brightness: 2.4
            castsShadow: false
        }

        // 5. Passenger Dash & Glovebox Light: Illuminates passenger dash, glovebox & door
        PointLight {
            id: passengerDashLight
            position: Qt.vector3d(-0.38, 0.75, 0.35)
            color: "#f0f5ff"
            brightness: 2.4
            castsShadow: false
        }

        // 6. Driver Cockpit & Steering Wheel Spot: Highlights wheel grip, stitches & emblem
        SpotLight {
            id: steeringSpotLight
            position: Qt.vector3d(0.38, 1.25, 0.12)
            eulerRotation: Qt.vector3d(52, 180, 0)
            coneAngle: 70
            innerConeAngle: 40
            color: "#ffffff"
            brightness: 2.5
            castsShadow: false
        }

        // 7. Center Armrest & Console Light: Highlights center armrest leather & stitching
        PointLight {
            id: centerCabinFill
            position: Qt.vector3d(0.0, 0.82, 0.08)
            color: "#edf4ff"
            brightness: 2.2
            castsShadow: false
        }

        // 8. Starry Night Blue Dashboard Ambient Accent Glow
        PointLight {
            id: starryNightGlow
            position: Qt.vector3d(0.0, 0.88, 0.65)
            color: "#1858a8"
            brightness: 2.2
            castsShadow: false
        }

        // 9. Vent Cavity Inner Illumination (makes smoke glow right inside the vents)
        PointLight {
            id: driverVentLight
            position: Qt.vector3d(0.60, 0.90, 0.68)
            color: cabinView.airColor
            brightness: cabinView.faceVentsActive && cabinView.fanSpeed > 0 ? 2.2 : 0.0
            castsShadow: false
        }
        PointLight {
            id: centerLeftVentLight
            position: Qt.vector3d(0.20, 0.815, 0.68)
            color: cabinView.airColor
            brightness: cabinView.faceVentsActive && cabinView.fanSpeed > 0 ? 2.6 : 0.0
            castsShadow: false
        }
        PointLight {
            id: centerRightVentLight
            position: Qt.vector3d(-0.20, 0.815, 0.68)
            color: cabinView.airColor
            brightness: cabinView.faceVentsActive && cabinView.fanSpeed > 0 ? 2.6 : 0.0
            castsShadow: false
        }
        PointLight {
            id: passengerVentLight
            position: Qt.vector3d(-0.61, 0.90, 0.68)
            color: cabinView.airColor
            brightness: cabinView.faceVentsActive && cabinView.fanSpeed > 0 ? 2.2 : 0.0
            castsShadow: false
        }
        PointLight {
            id: rearConsoleGlow
            position: Qt.vector3d(0.0, 0.56, -0.06)
            color: cabinView.airColor
            brightness: cabinView.rearActive && cabinView.fanSpeed > 0 ? 2.4 : 0.0
            castsShadow: false
        }

        // 10. Rear Passenger Cabin Illumination (Overhead & Ambient Luxury Blue)
        PointLight {
            id: rearSeatsOverheadLight
            position: Qt.vector3d(0.0, 1.65, -0.90)
            color: "#f0f5ff"
            brightness: cabinView.isRearView ? 3.0 : 0.8
            castsShadow: false
            Behavior on brightness { NumberAnimation { duration: 600 } }
        }
        PointLight {
            id: rearAmbientAccentLight
            position: Qt.vector3d(0.0, 0.70, -1.00)
            color: "#1858a8"
            brightness: cabinView.isRearView ? 2.4 : 0.6
            castsShadow: false
            Behavior on brightness { NumberAnimation { duration: 600 } }
        }

        // 11. Rear Footwell Airflow Ground Glow (Dual Driver & Passenger Underseat illumination)
        PointLight {
            id: rearFootwellDriverLight
            position: Qt.vector3d(0.36, 0.52, -0.40)
            color: (cabinView.rearTemperature >= 23.5) ? cabinView.warmColor : cabinView.coolColor
            brightness: (cabinView.isRearView && cabinView.rearPower && (cabinView.rearAirflowMode === 1 || cabinView.rearAutoMode)) ? 3.6 : 0.0
            castsShadow: false
            Behavior on brightness { NumberAnimation { duration: 400 } }
            Behavior on color { ColorAnimation { duration: 400 } }
        }

        PointLight {
            id: rearFootwellPassLight
            position: Qt.vector3d(-0.36, 0.52, -0.40)
            color: (cabinView.rearTemperature >= 23.5) ? cabinView.warmColor : cabinView.coolColor
            brightness: (cabinView.isRearView && cabinView.rearPower && (cabinView.rearAirflowMode === 1 || cabinView.rearAutoMode)) ? 3.6 : 0.0
            castsShadow: false
            Behavior on brightness { NumberAnimation { duration: 400 } }
            Behavior on color { ColorAnimation { duration: 400 } }
        }

        // 10. Dynamic Climate Temperature Glow
        PointLight {
            id: dashClimateGlow
            position: Qt.vector3d(0.0, 0.78, 0.52)
            color: cabinView.airColor
            brightness: cabinView.fanSpeed > 0 ? 1.6 : 0.4
            castsShadow: false
            Behavior on brightness { NumberAnimation { duration: 400 } }
            Behavior on color { ColorAnimation { duration: 400 } }
        }

        // 11. Under-seat & Footwell Dynamic Climate Illumination
        PointLight {
            id: driverFootwellGlow
            position: Qt.vector3d(0.36, 0.50, 0.60)
            color: cabinView.airColor
            brightness: !cabinView.isRearView && (cabinView.feetActive || cabinView.faceVentsActive) && cabinView.fanSpeed > 0 ? 3.2 : 0.0
            castsShadow: false
            Behavior on brightness { NumberAnimation { duration: 300 } }
            Behavior on color { ColorAnimation { duration: 400 } }
        }
        PointLight {
            id: passengerFootwellGlow
            position: Qt.vector3d(-0.36, 0.50, 0.60)
            color: cabinView.airColor
            brightness: !cabinView.isRearView && (cabinView.feetActive || cabinView.faceVentsActive) && cabinView.fanSpeed > 0 ? 3.2 : 0.0
            castsShadow: false
            Behavior on brightness { NumberAnimation { duration: 300 } }
            Behavior on color { ColorAnimation { duration: 400 } }
        }

        // ---------------------------------------------------------------------
        // Cabin 3D Model
        // ---------------------------------------------------------------------
        Node {
            id: carRoot

            Scene {
                id: carModel
                scale: Qt.vector3d(0.25, 0.25, 0.25)
                paintColor: cabinView.starryNightBlue
                metalness: 0.92
                roughness: 0.14
                clearcoat: 1.0
                lightsOn: true
                roofVisible: !cabinView.isRearView
            }

            // Illuminated APEX Logo on Steering Wheel Hub (Pure APEX, Ultra-visible in darkness)
            Model {
                id: apexSteeringBadge
                source: "#Rectangle"
                position: Qt.vector3d(0.371, 0.902, 0.445)
                eulerRotation: Qt.vector3d(-24.0, 180.0, 0.0)
                scale: Qt.vector3d(0.00115, 0.00058, 1.0)
                castsShadows: false
                receivesShadows: false

                materials: [
                    PrincipledMaterial {
                        lighting: PrincipledMaterial.NoLighting
                        baseColor: "#ffffff"
                        baseColorMap: Texture {
                            source: "images/apex_steering_badge_ultra.png"
                        }
                        emissiveMap: Texture {
                            source: "images/apex_steering_badge_ultra.png"
                        }
                        emissiveFactor: Qt.vector3d(6.5, 6.5, 7.0)
                        opacity: 1.0
                        opacityMap: Texture {
                            source: "images/apex_steering_badge_ultra.png"
                        }
                        opacityChannel: Material.A
                        alphaMode: PrincipledMaterial.Blend
                        cullMode: PrincipledMaterial.NoCulling
                    }
                ]
            }

            // -----------------------------------------------------------------
            // 3D Animated Airflow Streams Matching User HVAC Reference
            // -----------------------------------------------------------------

            // 1. Windshield Defroster Aurora: Rises upward behind infotainment and steering wheel
            AirflowDefrost {
                id: windshieldDefrostFlow
                airColor: cabinView.airColor
                fanSpeed: cabinView.fanSpeed
                active: (cabinView.isDefrostActive || cabinView.faceVentsActive || cabinView.defrostActive) && cabinView.windshieldDefrostVisible
            }

            // 2. Driver Left AC Vent: Emanates from vent mouth left of steering wheel
            AirflowStream {
                id: driverLeftFlow
                meshSource: "CarModel_Climate/meshes/airflow_driver_left.mesh"
                airColor: cabinView.airColor
                fanSpeed: cabinView.fanSpeed
                active: cabinView.faceVentsActive && cabinView.leftAirflowVisible
                flowSpeedFactor: 1.0
            }

            // 3. Middle AC Vent 1 (Center-Left): Cascades down into center console
            AirflowStream {
                id: centerLeftFlow
                meshSource: "CarModel_Climate/meshes/airflow_center_left.mesh"
                airColor: cabinView.airColor
                fanSpeed: cabinView.fanSpeed
                active: cabinView.faceVentsActive && cabinView.centerLeftAirflowVisible
                flowSpeedFactor: 0.98
                streamTexture: "images/airflow_center_laminar_oem.png"
                maskTexture: "images/airflow_center_mask_oem.png"
            }

            // 4. Middle AC Vent 2 (Center-Right): Cascades down toward passenger side
            AirflowStream {
                id: centerRightFlow
                meshSource: "CarModel_Climate/meshes/airflow_center_right.mesh"
                airColor: cabinView.airColor
                fanSpeed: cabinView.fanSpeed
                active: cabinView.faceVentsActive && cabinView.centerRightAirflowVisible
                flowSpeedFactor: 0.98
                streamTexture: "images/airflow_center_laminar_oem.png"
                maskTexture: "images/airflow_center_mask_oem.png"
            }

            // 5. Passenger Right AC Vent: Emanates from passenger outer AC vent
            AirflowStream {
                id: passengerRightFlow
                meshSource: "CarModel_Climate/meshes/airflow_passenger_right.mesh"
                airColor: cabinView.airColor
                fanSpeed: cabinView.fanSpeed
                active: cabinView.faceVentsActive && cabinView.rightAirflowVisible
                flowSpeedFactor: 1.0
            }

            // 6. Rear Console Emitter: Radiates back from center console armrest
            AirflowRear {
                id: rearConsoleFlow
                airColor: (cabinView.rearTemperature >= 23.5) ? cabinView.warmColor : cabinView.coolColor
                fanSpeed: cabinView.rearFanSpeed
                active: cabinView.rearPower && ((cabinView.isRearView && (cabinView.rearAirflowMode === 0 || cabinView.rearAutoMode)) || (!cabinView.isRearView && cabinView.rearActive))
            }

            // 7. Driver Under-Seat Ground Flow Stream (Front Footwell / Driver Pedals)
            AirflowGround {
                id: driverGroundFlow
                meshSource: "CarModel_Climate/meshes/airflow_ground_driver.mesh"
                airColor: cabinView.airColor
                fanSpeed: cabinView.fanSpeed
                active: !cabinView.isRearView && (cabinView.feetActive || cabinView.faceVentsActive) && cabinView.footwellAirflowVisible
            }

            // 8. Passenger Under-Seat Ground Flow Stream (Front Footwell / Passenger Floor)
            AirflowGround {
                id: passengerGroundFlow
                meshSource: "CarModel_Climate/meshes/airflow_ground_passenger.mesh"
                airColor: cabinView.airColor
                fanSpeed: cabinView.fanSpeed
                active: !cabinView.isRearView && (cabinView.feetActive || cabinView.faceVentsActive) && cabinView.footwellAirflowVisible
            }

            // 9. Rear Cabin Driver Under-Seat Ground Flow (Flows under Front Seat into Rear Footwell)
            AirflowRearGround {
                id: rearDriverGroundFlow
                meshSource: "CarModel_Climate/meshes/airflow_rear_underseat_driver.mesh"
                airColor: (cabinView.rearTemperature >= 23.5) ? cabinView.warmColor : cabinView.coolColor
                fanSpeed: cabinView.rearFanSpeed
                active: cabinView.isRearView && cabinView.rearPower && (cabinView.rearAirflowMode === 1 || cabinView.rearAutoMode) && cabinView.footwellAirflowVisible
            }

            // 10. Rear Cabin Passenger Under-Seat Ground Flow (Flows under Front Seat into Rear Footwell)
            AirflowRearGround {
                id: rearPassengerGroundFlow
                meshSource: "CarModel_Climate/meshes/airflow_rear_underseat_passenger.mesh"
                airColor: (cabinView.rearTemperature >= 23.5) ? cabinView.warmColor : cabinView.coolColor
                fanSpeed: cabinView.rearFanSpeed
                active: cabinView.isRearView && cabinView.rearPower && (cabinView.rearAirflowMode === 1 || cabinView.rearAutoMode) && cabinView.footwellAirflowVisible
            }
        }
    }

    // -------------------------------------------------------------------------
    // Interactive Cockpit Micro-Parallax Drag & Spring Back
    // -------------------------------------------------------------------------
    MouseArea {
        id: parallaxMouseArea
        anchors.fill: parent
        hoverEnabled: true

        property real lastX: 0
        property real lastY: 0
        property bool isDragging: false

        onPressed: function(mouse) {
            lastX = mouse.x;
            lastY = mouse.y;
            isDragging = true;
            if (springBackAnim.running) springBackAnim.stop();
        }

        onPositionChanged: function(mouse) {
            if (isDragging) {
                var dx = (mouse.x - lastX) / cabinView.width;
                var dy = (mouse.y - lastY) / cabinView.height;
                cabinView.camParallaxX = Math.max(-0.045, Math.min(0.045, cabinView.camParallaxX - dx * 0.10));
                cabinView.camYawParallax = Math.max(-3.5, Math.min(3.5, cabinView.camYawParallax - dx * 6.0));
                cabinView.camPitchParallax = Math.max(-2.5, Math.min(2.5, cabinView.camPitchParallax + dy * 5.0));
                lastX = mouse.x;
                lastY = mouse.y;
            }
        }

        onReleased: {
            isDragging = false;
            springBackAnim.restart();
        }
    }

    ParallelAnimation {
        id: springBackAnim
        NumberAnimation { target: cabinView; property: "camParallaxX"; to: 0.0; duration: 500; easing.type: Easing.OutBack }
        NumberAnimation { target: cabinView; property: "camYawParallax"; to: 0.0; duration: 500; easing.type: Easing.OutBack }
        NumberAnimation { target: cabinView; property: "camPitchParallax"; to: 0.0; duration: 500; easing.type: Easing.OutBack }
    }
}
