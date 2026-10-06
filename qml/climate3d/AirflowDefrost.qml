/**
 * ==============================================================================
 * Project: Apex VISION IVI - Digital Cockpit & Infotainment System
 * File: AirflowDefrost.qml
 * Author / Developer: Sk Rehan Ahamed
 * License: MIT
 * ==============================================================================
 */

import QtQuick
import QtQuick3D

Node {
    id: root

    property color airColor: "#42b8ff"
    property int fanSpeed: 4
    property bool active: true
    property real baseOpacity: 0.95

    readonly property real speedMultiplier: root.fanSpeed > 0 ? (0.65 + (root.fanSpeed / 7.0) * 0.85) : 0.0
    readonly property real streamOpacity: root.active && root.fanSpeed > 0 ?
        (0.48 + (root.fanSpeed / 7.0) * 0.44) * root.baseOpacity : 0.0

    // Upward flowing cold smoke streaks animation on top of the image
    // Note: The PNG position and scale remain completely static (NO up-and-down movement)
    property real smokeFlow1: 0.0
    NumberAnimation {
        target: root
        property: "smokeFlow1"
        from: 0.0
        to: -1.0
        duration: Math.max(800, Math.round(2100 / Math.max(0.2, root.speedMultiplier)))
        running: root.active && root.fanSpeed > 0
        loops: Animation.Infinite
        easing.type: Easing.Linear
    }

    property real smokeFlow2: 0.0
    NumberAnimation {
        target: root
        property: "smokeFlow2"
        from: 0.0
        to: -1.0
        duration: Math.max(650, Math.round(1550 / Math.max(0.2, root.speedMultiplier)))
        running: root.active && root.fanSpeed > 0
        loops: Animation.Infinite
        easing.type: Easing.Linear
    }

    // -------------------------------------------------------------------------
    // Layer 1: Core Ice Ray Plume (Rock-Solid Fixed Position, No Up-and-Down)
    // -------------------------------------------------------------------------
    Model {
        id: defrostIcePlume
        source: "CarModel_Climate/meshes/airflow_defrost.mesh"
        scale: Qt.vector3d(1.0, 1.0, 1.0)
        castsShadows: false
        receivesShadows: false

        materials: [
            PrincipledMaterial {
                id: matIcePlume
                lighting: PrincipledMaterial.NoLighting
                baseColor: "#ffffff"
                cullMode: PrincipledMaterial.NoCulling
                alphaMode: PrincipledMaterial.Blend

                opacity: root.streamOpacity * 0.95
                Behavior on opacity {
                    NumberAnimation { duration: 280; easing.type: Easing.InOutQuad }
                }

                // Reference ice ray image shaped into an oval arch spanning steering side to passenger side
                baseColorMap: Texture {
                    source: "images/airflow_defrost_oval_ice.png"
                    scaleV: 1.0
                    scaleU: 1.0
                    tilingModeVertical: Texture.ClampToEdge
                    tilingModeHorizontal: Texture.ClampToEdge
                }
            }
        ]
    }

    // -------------------------------------------------------------------------
    // Layer 2: Animated Upward-Streaming Ice Smoke (Terminates along smooth oval arch)
    // -------------------------------------------------------------------------
    Model {
        id: defrostIceFlow1
        source: "CarModel_Climate/meshes/airflow_defrost.mesh"
        scale: Qt.vector3d(1.002, 1.002, 1.002)
        castsShadows: false
        receivesShadows: false

        materials: [
            PrincipledMaterial {
                id: matIceFlow1
                lighting: PrincipledMaterial.NoLighting
                baseColor: root.airColor
                cullMode: PrincipledMaterial.NoCulling
                alphaMode: PrincipledMaterial.Blend

                opacity: root.streamOpacity * 0.70
                Behavior on opacity {
                    NumberAnimation { duration: 280; easing.type: Easing.InOutQuad }
                }

                // Animated upward flowing smoke tendrils aligned with the oval rays
                baseColorMap: Texture {
                    source: "images/airflow_defrost_oval_flow.png"
                    scaleV: 1.0
                    scaleU: 1.0
                    positionV: root.smokeFlow1
                    positionU: 0.0
                    tilingModeVertical: Texture.Repeat
                    tilingModeHorizontal: Texture.ClampToEdge
                }

                // Master oval mask ensures proper curved dissolution at the top (NO square cut)
                opacityMap: Texture {
                    source: "images/airflow_defrost_oval_mask.png"
                    scaleV: 1.0
                    scaleU: 1.0
                    positionV: 0.0
                    positionU: 0.0
                    tilingModeVertical: Texture.ClampToEdge
                    tilingModeHorizontal: Texture.ClampToEdge
                }
                opacityChannel: Material.A
            }
        ]
    }

    // -------------------------------------------------------------------------
    // Layer 3: Secondary Desynchronized Rolling Mist Wisps (Terminates along oval arch)
    // -------------------------------------------------------------------------
    Model {
        id: defrostIceFlow2
        source: "CarModel_Climate/meshes/airflow_defrost.mesh"
        scale: Qt.vector3d(1.004, 1.004, 1.004)
        castsShadows: false
        receivesShadows: false

        materials: [
            PrincipledMaterial {
                id: matIceFlow2
                lighting: PrincipledMaterial.NoLighting
                baseColor: "#edf8ff"
                cullMode: PrincipledMaterial.NoCulling
                alphaMode: PrincipledMaterial.Blend

                opacity: root.fanSpeed >= 2 ? (root.streamOpacity * 0.45) : 0.0
                Behavior on opacity {
                    NumberAnimation { duration: 280; easing.type: Easing.InOutQuad }
                }

                baseColorMap: Texture {
                    source: "images/airflow_defrost_oval_flow2.png"
                    scaleV: 1.2
                    scaleU: 1.0
                    positionV: root.smokeFlow2
                    positionU: 0.0
                    tilingModeVertical: Texture.Repeat
                    tilingModeHorizontal: Texture.ClampToEdge
                }

                opacityMap: Texture {
                    source: "images/airflow_defrost_oval_mask.png"
                    scaleV: 1.0
                    scaleU: 1.0
                    positionV: 0.0
                    positionU: 0.0
                    tilingModeVertical: Texture.ClampToEdge
                    tilingModeHorizontal: Texture.ClampToEdge
                }
                opacityChannel: Material.A
            }
        ]
    }
}
