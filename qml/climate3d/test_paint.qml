/**
 * ==============================================================================
 * Project: Apex VISION IVI - Digital Cockpit & Infotainment System
 * File: test_paint.qml
 * Author / Developer: Sk Rehan Ahamed
 * License: MIT
 * ==============================================================================
 */


import QtQuick
import QtQuick3D
import QtQuick3D.Helpers
import "CarModel"

Item {
    width: 1000
    height: 700

    View3D {
        anchors.fill: parent
        environment: ExtendedSceneEnvironment {
            backgroundMode: SceneEnvironment.Transparent
            lightProbe: Texture {
                source: "assets/studio_lighting.ktx"
            }
            probeExposure: 0.75
            glowEnabled: true
        }

        PerspectiveCamera {
            position: Qt.vector3d(0, 0.65, 8.6)
            eulerRotation: Qt.vector3d(-9.0, 26.0, 0)
        }

        DirectionalLight {
            eulerRotation: Qt.vector3d(-90, 0, 0)
            brightness: 3.5
            color: "#FFFFFF"
        }
        DirectionalLight {
            eulerRotation: Qt.vector3d(-28, 38, 0)
            brightness: 3.8
            color: "#FFFFFF"
        }
        DirectionalLight {
            eulerRotation: Qt.vector3d(-15, 85, 0)
            brightness: 3.2
            color: "#F1F5F9"
        }
        DirectionalLight {
            eulerRotation: Qt.vector3d(-26, -140, 0)
            brightness: 2.8
            color: "#FFFFFF"
        }

        Scene {
            paintColor: "#070A10"
            metalness: 0.12
            roughness: 0.10
            clearcoat: 1.0
            roofVisible: true
            lightsOn: true
        }
    }
}
