
import QtQuick
import QtQuick3D
import QtQuick3D.Helpers
import "CarModel"

Item {
    width: 800
    height: 600

    View3D {
        anchors.fill: parent
        environment: ExtendedSceneEnvironment {
            backgroundMode: SceneEnvironment.Transparent
            lightProbe: Texture {
                source: "assets/studio_lighting.ktx"
            }
            probeExposure: 1.5
            glowEnabled: true
        }

        PerspectiveCamera {
            position: Qt.vector3d(0, 0.7, 7.5)
            eulerRotation: Qt.vector3d(-8, 30, 0)
        }

        DirectionalLight {
            eulerRotation: Qt.vector3d(-35, 50, 0)
            brightness: 2.5
            color: "#FFFFFF"
        }

        Scene {
            paintColor: "#0e1420"
            roofVisible: true
            lightsOn: true
        }
    }
}
