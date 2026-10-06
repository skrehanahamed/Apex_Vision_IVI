/**
 * ==============================================================================
 * Project: Apex VISION IVI - Digital Cockpit & Infotainment System
 * File: AirflowRear.qml
 * Author / Developer: Sk Rehan Ahamed
 * License: MIT
 * ==============================================================================
 */

import QtQuick
import QtQuick3D

Node {
    id: root

    property color airColor: "#bceeff"
    property int fanSpeed: 4
    property bool active: true
    property real baseOpacity: 0.90
    property real flowSpeedFactor: 1.0

    // Fan speed condition: active between 1 and 7
    readonly property bool fanActive: root.fanSpeed >= 1 && root.fanSpeed <= 7
    readonly property real speedMultiplier: root.fanActive ? (0.65 + (root.fanSpeed / 7.0) * 0.85) * root.flowSpeedFactor : 0.0

    readonly property real streamOpacity: (root.active && root.fanActive) ?
        (0.82 + (root.fanSpeed / 7.0) * 0.18) * root.baseOpacity : 0.0

    // Primary continuous flow animation
    property real flowPos: 0.0
    NumberAnimation {
        target: root
        property: "flowPos"
        from: 0.0
        to: -1.0
        duration: Math.max(800, Math.round(1800 / Math.max(0.2, root.speedMultiplier)))
        running: root.active && root.fanActive
        loops: Animation.Infinite
        easing.type: Easing.Linear
    }

    // Secondary desynchronized flow layer for volumetric depth
    property real flowPos2: 0.0
    NumberAnimation {
        target: root
        property: "flowPos2"
        from: 0.0
        to: -1.0
        duration: Math.max(1000, Math.round(2300 / Math.max(0.2, root.speedMultiplier)))
        running: root.active && root.fanActive
        loops: Animation.Infinite
        easing.type: Easing.Linear
    }

    // Layer 1: Primary Stream
    Model {
        id: rearModel1
        source: "CarModel_Climate/meshes/airflow_rear_console.mesh"
        castsShadows: false
        receivesShadows: false

        materials: [
            PrincipledMaterial {
                lighting: PrincipledMaterial.NoLighting
                baseColor: Qt.lighter(root.airColor, 1.30)
                cullMode: PrincipledMaterial.NoCulling
                alphaMode: PrincipledMaterial.Blend

                opacity: root.streamOpacity * 0.98
                Behavior on opacity {
                    NumberAnimation { duration: 300; easing.type: Easing.InOutQuad }
                }

                emissiveFactor: Qt.vector3d(2.2, 2.2, 2.2)
                emissiveMap: Texture {
                    source: "images/airflow_laminar_stream.png"
                    positionV: root.flowPos
                    scaleV: 1.0
                    scaleU: 1.4
                    tilingModeVertical: Texture.Repeat
                    tilingModeHorizontal: Texture.ClampToEdge
                }

                baseColorMap: Texture {
                    source: "images/airflow_laminar_stream.png"
                    positionV: root.flowPos
                    scaleV: 1.0
                    scaleU: 1.4
                    tilingModeVertical: Texture.Repeat
                    tilingModeHorizontal: Texture.ClampToEdge
                }

                opacityMap: Texture {
                    source: "images/airflow_envelope_mask.png"
                    scaleV: 1.0
                    scaleU: 1.0
                    tilingModeVertical: Texture.ClampToEdge
                    tilingModeHorizontal: Texture.ClampToEdge
                }
                opacityChannel: Material.A
            }
        ]
    }

    // Layer 2: Secondary overlapping stream for soft volumetric glow
    Model {
        id: rearModel2
        source: "CarModel_Climate/meshes/airflow_rear_console.mesh"
        scale: Qt.vector3d(1.025, 1.025, 1.0)
        castsShadows: false
        receivesShadows: false

        materials: [
            PrincipledMaterial {
                lighting: PrincipledMaterial.NoLighting
                baseColor: "#ffffff"
                cullMode: PrincipledMaterial.NoCulling
                alphaMode: PrincipledMaterial.Blend

                opacity: root.streamOpacity * 0.78
                Behavior on opacity {
                    NumberAnimation { duration: 300; easing.type: Easing.InOutQuad }
                }

                emissiveFactor: Qt.vector3d(2.6, 2.6, 2.6)
                emissiveMap: Texture {
                    source: "images/airflow_laminar_stream.png"
                    positionV: root.flowPos2
                    scaleV: 1.0
                    scaleU: 1.8
                    tilingModeVertical: Texture.Repeat
                    tilingModeHorizontal: Texture.ClampToEdge
                }

                baseColorMap: Texture {
                    source: "images/airflow_laminar_stream.png"
                    positionV: root.flowPos2
                    scaleV: 1.0
                    scaleU: 1.8
                    tilingModeVertical: Texture.Repeat
                    tilingModeHorizontal: Texture.ClampToEdge
                }

                opacityMap: Texture {
                    source: "images/airflow_envelope_mask.png"
                    scaleV: 1.0
                    scaleU: 1.0
                    tilingModeVertical: Texture.ClampToEdge
                    tilingModeHorizontal: Texture.ClampToEdge
                }
                opacityChannel: Material.A
            }
        ]
    }
}
