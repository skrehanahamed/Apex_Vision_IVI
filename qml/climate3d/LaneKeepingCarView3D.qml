/**
 * ==============================================================================
 * Project: Apex VISION IVI - Digital Cockpit & Infotainment System
 * File: LaneKeepingCarView3D.qml
 * Author / Developer: Sk Rehan Ahamed
 * License: MIT
 * ==============================================================================
 */

import QtQuick
import QtQuick3D
import QtQuick3D.Helpers
import "CarModel"

Item {
    id: root
    property real wheelAngle: 0.0
    property real suspensionY: 0.0

    View3D {
        id: carView3D
        anchors.fill: parent
        environment: ExtendedSceneEnvironment {
            backgroundMode: SceneEnvironment.Transparent
            antialiasingMode: SceneEnvironment.NoAA
            antialiasingQuality: SceneEnvironment.Medium
            tonemapMode: SceneEnvironment.TonemapModeLinear

            lightProbe: Texture {
                source: "assets/_Hall.ktx"
            }
            probeExposure: 1.15

            glowEnabled: false
        }

        Node {
            position: Qt.vector3d(0.26, 0.44 + (root.suspensionY * 0.002), 0.0)
            eulerRotation: Qt.vector3d(-30.0, 155.0, 0.0)
            PerspectiveCamera {
                position: Qt.vector3d(0.0, 0.0, 10.0)
                clipNear: 0.1
                clipFar: 180.0
                fieldOfView: 26.0
            }
        }

        // 1. Overhead Softbox (illuminates roof, panoramic glass, and vehicle curves)
        DirectionalLight {
            eulerRotation: Qt.vector3d(-90, 0, 0)
            brightness: 3.2
            color: "#ffffff"
        }
        // 2. Front Upper Hood & Windshield Light
        DirectionalLight {
            eulerRotation: Qt.vector3d(-42, 35, 0)
            brightness: 3.0
            color: "#ffffff"
        }
        // 3. Rear Upper Light (creates specular reflection on rear lightbar & trunk)
        DirectionalLight {
            eulerRotation: Qt.vector3d(-35, -145, 0)
            brightness: 3.0
            color: "#ffffff"
        }
        // 4. Side Waistline & Wheels Light (illuminates left flank and wheels clearly)
        DirectionalLight {
            eulerRotation: Qt.vector3d(-18, -75, 0)
            brightness: 2.8
            color: "#ffffff"
        }

        Scene {
            id: car3DModel
            scale: Qt.vector3d(0.25, 0.25, 0.25)
            // Satin Pearl White Automotive Paint matching Vehicle Bar / Studio View exactly
            paintColor: "#EDF2F7"
            metalness: 0.18
            roughness: 0.24
            clearcoat: 0.75
            lightsOn: true
            roofVisible: true
            wheelAngle: root.wheelAngle
        }
    }
}
