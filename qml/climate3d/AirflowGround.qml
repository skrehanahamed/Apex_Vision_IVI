import QtQuick
import QtQuick3D

Node {
    id: root

    property string meshSource: ""
    property color airColor: "#38b6ff"
    property int fanSpeed: 4
    property bool active: true
    property real baseOpacity: 0.95

    property string streamTexture: "images/airflow_laminar_stream.png"
    property string maskTexture: "images/airflow_envelope_mask.png"

    readonly property real speedMultiplier: root.fanSpeed > 0 ? (0.65 + (root.fanSpeed / 7.0) * 0.85) : 0.0
    readonly property real streamOpacity: root.active && root.fanSpeed > 0 ?
        (0.85 + (root.fanSpeed / 7.0) * 0.15) * root.baseOpacity : 0.0

    // Continuous forward flow animation under front seat into footwell
    property real flowPos1: 0.0
    NumberAnimation {
        target: root
        property: "flowPos1"
        from: 0.0
        to: -1.0
        duration: Math.max(800, Math.round(2000 / Math.max(0.2, root.speedMultiplier)))
        running: root.active && root.fanSpeed > 0
        loops: Animation.Infinite
        easing.type: Easing.Linear
    }

    // Secondary desynchronized phase
    property real flowPos2: 0.0
    NumberAnimation {
        target: root
        property: "flowPos2"
        from: 0.0
        to: -1.0
        duration: Math.max(900, Math.round(2350 / Math.max(0.2, root.speedMultiplier)))
        running: root.active && root.fanSpeed > 0
        loops: Animation.Infinite
        easing.type: Easing.Linear
    }

    // Tertiary core velocity streak
    property real flowPos3: 0.0
    NumberAnimation {
        target: root
        property: "flowPos3"
        from: 0.0
        to: -1.0
        duration: Math.max(600, Math.round(1500 / Math.max(0.2, root.speedMultiplier)))
        running: root.active && root.fanSpeed > 0
        loops: Animation.Infinite
        easing.type: Easing.Linear
    }

    // Layer 1: Main under-seat ground flow ribbon streaming forward into footwell
    Model {
        id: groundSheetModel
        source: root.meshSource
        castsShadows: false
        receivesShadows: false

        materials: [
            PrincipledMaterial {
                lighting: PrincipledMaterial.NoLighting
                baseColor: Qt.lighter(root.airColor, 1.25)
                cullMode: PrincipledMaterial.NoCulling
                alphaMode: PrincipledMaterial.Blend

                opacity: root.streamOpacity * 0.98
                Behavior on opacity {
                    NumberAnimation { duration: 260; easing.type: Easing.InOutQuad }
                }

                emissiveFactor: Qt.vector3d(2.6, 2.6, 2.6)
                emissiveMap: Texture {
                    source: root.streamTexture
                    positionV: root.flowPos1 * 0.90
                    scaleV: 1.5
                    scaleU: 1.0
                    tilingModeVertical: Texture.Repeat
                    tilingModeHorizontal: Texture.ClampToEdge
                }

                baseColorMap: Texture {
                    source: root.streamTexture
                    positionV: root.flowPos1 * 0.90
                    scaleV: 1.5
                    scaleU: 1.0
                    tilingModeVertical: Texture.Repeat
                    tilingModeHorizontal: Texture.ClampToEdge
                }

                opacityMap: Texture {
                    source: root.maskTexture
                    scaleV: 1.0
                    scaleU: 1.0
                    tilingModeVertical: Texture.ClampToEdge
                    tilingModeHorizontal: Texture.ClampToEdge
                }
                opacityChannel: Material.A
            }
        ]
    }

    // Layer 2: Secondary wispy streamlines
    Model {
        id: groundSecondaryModel
        source: root.meshSource
        scale: Qt.vector3d(1.01, 1.02, 1.0)
        castsShadows: false
        receivesShadows: false

        materials: [
            PrincipledMaterial {
                lighting: PrincipledMaterial.NoLighting
                baseColor: Qt.lighter(root.airColor, 1.45)
                cullMode: PrincipledMaterial.NoCulling
                alphaMode: PrincipledMaterial.Blend

                opacity: root.streamOpacity * 0.88
                Behavior on opacity {
                    NumberAnimation { duration: 260; easing.type: Easing.InOutQuad }
                }

                emissiveFactor: Qt.vector3d(2.8, 2.8, 2.8)
                emissiveMap: Texture {
                    source: "images/airflow_ribbon_layer2.png"
                    positionV: root.flowPos2 * 0.90
                    scaleV: 1.5
                    scaleU: 1.0
                    tilingModeVertical: Texture.Repeat
                    tilingModeHorizontal: Texture.ClampToEdge
                }

                baseColorMap: Texture {
                    source: "images/airflow_ribbon_layer2.png"
                    positionV: root.flowPos2 * 0.90
                    scaleV: 1.5
                    scaleU: 1.0
                    tilingModeVertical: Texture.Repeat
                    tilingModeHorizontal: Texture.ClampToEdge
                }

                opacityMap: Texture {
                    source: root.maskTexture
                    scaleV: 1.0
                    scaleU: 1.0
                    tilingModeVertical: Texture.ClampToEdge
                    tilingModeHorizontal: Texture.ClampToEdge
                }
                opacityChannel: Material.A
            }
        ]
    }

    // Layer 3: Radiant white core velocity streak
    Model {
        id: groundHighlightModel
        source: root.meshSource
        scale: Qt.vector3d(0.97, 1.04, 1.0)
        castsShadows: false
        receivesShadows: false

        materials: [
            PrincipledMaterial {
                lighting: PrincipledMaterial.NoLighting
                baseColor: "#ffffff"
                cullMode: PrincipledMaterial.NoCulling
                alphaMode: PrincipledMaterial.Blend

                opacity: root.streamOpacity * 0.85
                Behavior on opacity {
                    NumberAnimation { duration: 260; easing.type: Easing.InOutQuad }
                }

                emissiveFactor: Qt.vector3d(3.5, 3.5, 3.5)
                emissiveMap: Texture {
                    source: "images/airflow_ribbon_core.png"
                    positionV: root.flowPos3 * 0.90
                    scaleV: 1.5
                    scaleU: 1.0
                    tilingModeVertical: Texture.Repeat
                    tilingModeHorizontal: Texture.ClampToEdge
                }

                baseColorMap: Texture {
                    source: "images/airflow_ribbon_core.png"
                    positionV: root.flowPos3 * 0.90
                    scaleV: 1.5
                    scaleU: 1.0
                    tilingModeVertical: Texture.Repeat
                    tilingModeHorizontal: Texture.ClampToEdge
                }

                opacityMap: Texture {
                    source: root.maskTexture
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
