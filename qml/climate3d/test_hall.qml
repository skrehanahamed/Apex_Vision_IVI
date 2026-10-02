/**
 * ==============================================================================
 * Project: Apex VISION IVI - Digital Cockpit & Infotainment System
 * File: test_hall.qml
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
                source: "assets/_Hall.ktx"
            }
            probeExposure: 1.15
            glowEnabled: true
        }

        Node {
            position: Qt.vector3d(0, 0.65, 0)
            eulerRotation: Qt.vector3d(-9.0, 26.0, 0)
            PerspectiveCamera {
                position: Qt.vector3d(0, 0, 8.6)
            }
        }

        DirectionalLight {
            eulerRotation: Qt.vector3d(-90, 0, 0)
            brightness: 3.5
            color: "#FFFFFF"
        }
        DirectionalLight {
            eulerRotation: Qt.vector3d(-42, 35, 0)
            brightness: 3.2
            color: "#FFFFFF"
        }
        DirectionalLight {
            eulerRotation: Qt.vector3d(-15, 85, 0)
            brightness: 3.0
            color: "#F1F5F9"
        }
        DirectionalLight {
            eulerRotation: Qt.vector3d(-35, -145, 0)
            brightness: 3.0
            color: "#FFFFFF"
        }

        Scene {
            scale: Qt.vector3d(0.25, 0.25, 0.25)
            paintColor: "#070A0F"
            metalness: 0.05
            roughness: 0.10
            clearcoat: 1.0
            roofVisible: true
            lightsOn: true
        }
    }
}
