
import QtQuick
import QtQuick3D
import QtQuick3D.Helpers
import "CarModel"

Item {
    id: root
    width: 1804
    height: 1128

    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            orientation: Gradient.Vertical
            GradientStop { position: 0.0; color: "#0E1626" }
            GradientStop { position: 0.45; color: "#080F1E" }
            GradientStop { position: 0.8; color: "#040814" }
            GradientStop { position: 1.0; color: "#020408" }
        }
    }

    View3D {
        id: v3d
        anchors.fill: parent
        environment: ExtendedSceneEnvironment {
            backgroundMode: SceneEnvironment.Transparent
            antialiasingMode: SceneEnvironment.MSAA
            antialiasingQuality: SceneEnvironment.High
            tonemapMode: SceneEnvironment.TonemapModeLinear
            glowEnabled: true
            glowStrength: 1.15
            glowIntensity: 0.85
            glowBloom: 0.32
        }

        PerspectiveCamera {
            id: cam
            position: Qt.vector3d(0.0, 1.22, 10.4)
            eulerRotation: Qt.vector3d(-6.5, 0.0, 0.0)
            clipNear: 0.1
            clipFar: 180.0
            fieldOfView: 25.0
        }

        DirectionalLight {
            eulerRotation: Qt.vector3d(-90, 0, 0)
            brightness: 4.2
            color: "#FFFFFF"
        }
        DirectionalLight {
            eulerRotation: Qt.vector3d(-35, 50, 0)
            brightness: 4.4
            color: "#FFFFFF"
        }
        DirectionalLight {
            eulerRotation: Qt.vector3d(-15, 75, 0)
            brightness: 3.8
            color: "#E2E8F0"
        }
        DirectionalLight {
            eulerRotation: Qt.vector3d(-30, -140, 0)
            brightness: 3.2
            color: "#FFFFFF"
        }

        Node {
            id: carRoot
            position: Qt.vector3d(1.35, 0.0, 0.0)
            eulerRotation: Qt.vector3d(0.0, 38.0, 0.0)

            Model {
                source: "#Rectangle"
                position: Qt.vector3d(0, 0.004, 0)
                eulerRotation: Qt.vector3d(-90, 0, 0)
                scale: Qt.vector3d(0.042, 0.078, 1.0)
                materials: [
                    PrincipledMaterial {
                        lighting: PrincipledMaterial.NoLighting
                        baseColor: "#000000"
                        opacity: 0.95
                        opacityMap: Texture { source: "images/Ground.png" }
                        opacityChannel: Material.A
                        alphaMode: PrincipledMaterial.Blend
                    }
                ]
            }

            Scene {
                id: carModel
                roofVisible: true
                paintColor: "#05070A"
                metalness: 0.94
                roughness: 0.14
                clearcoat: 1.0
                lightsOn: true
            }
        }
    }
}
