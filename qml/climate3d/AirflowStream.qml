import QtQuick
import QtQuick3D

Node {
    id: root

    property string meshSource: ""
    property color airColor: "#42b8ff"
    property int fanSpeed: 4
    property bool active: true
    property real baseOpacity: 1.0
    property real flowSpeedFactor: 1.0
    property string streamTexture: "images/airflow_laminar_stream.png"
    property string maskTexture: "images/airflow_envelope_mask.png"

    // Speed multiplier based on fan speed (1 = slow/subtle ~0.7x, 4 = moderate ~1.0x, 7 = fast ~1.5x)
    readonly property real speedMultiplier: root.fanSpeed > 0 ? (0.65 + (root.fanSpeed / 7.0) * 0.85) * root.flowSpeedFactor : 0.0

    // Opacity range matching specification: 0.30 to 0.70 for bold radiant OEM streams
    readonly property real streamOpacity: root.active && root.fanSpeed > 0 ?
        (0.34 + (root.fanSpeed / 7.0) * 0.40) * root.baseOpacity : 0.0

    // Subtle 3D organic stream undulating/meandering
    property real undulateX: 1.0
    property real undulateY: 1.0

    SequentialAnimation {
        running: root.active && root.fanSpeed > 0
        loops: Animation.Infinite
        ParallelAnimation {
            NumberAnimation { target: root; property: "undulateX"; to: 1.025; duration: 2400; easing.type: Easing.InOutSine }
            NumberAnimation { target: root; property: "undulateY"; to: 0.985; duration: 2400; easing.type: Easing.InOutSine }
        }
        ParallelAnimation {
            NumberAnimation { target: root; property: "undulateX"; to: 0.980; duration: 2400; easing.type: Easing.InOutSine }
            NumberAnimation { target: root; property: "undulateY"; to: 1.020; duration: 2400; easing.type: Easing.InOutSine }
        }
    }

    // -------------------------------------------------------------------------
    // STREAM LAYER 1: Continuous Laminar Ribbon Streamlines (Primary Flow)
    // -------------------------------------------------------------------------
    property real flowPos1: 0.0
    NumberAnimation {
        target: root
        property: "flowPos1"
        from: 0.0
        to: -1.0
        duration: Math.max(900, Math.round(2100 / Math.max(0.2, root.speedMultiplier)))
        running: root.active && root.fanSpeed > 0
        loops: Animation.Infinite
        easing.type: Easing.Linear
    }

    Model {
        id: layer1Model
        source: root.meshSource
        scale: Qt.vector3d(root.undulateX, 1.0, root.undulateY)
        castsShadows: false
        receivesShadows: false

        materials: [
            PrincipledMaterial {
                id: matLayer1
                lighting: PrincipledMaterial.NoLighting
                baseColor: root.airColor
                cullMode: PrincipledMaterial.NoCulling
                alphaMode: PrincipledMaterial.Blend

                opacity: root.streamOpacity * 0.92
                Behavior on opacity {
                    NumberAnimation { duration: 260; easing.type: Easing.InOutQuad }
                }

                baseColorMap: Texture {
                    source: root.streamTexture
                    positionV: root.flowPos1
                    scaleV: 1.0
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

    // -------------------------------------------------------------------------
    // STREAM LAYER 2: Whispy Overlapping Secondary Streamlines (Desynchronized)
    // -------------------------------------------------------------------------
    property real flowPos2: 0.0
    NumberAnimation {
        target: root
        property: "flowPos2"
        from: 0.0
        to: -1.0
        duration: Math.max(750, Math.round(1680 / Math.max(0.2, root.speedMultiplier)))
        running: root.active && root.fanSpeed > 0
        loops: Animation.Infinite
        easing.type: Easing.Linear
    }

    Model {
        id: layer2Model
        source: root.meshSource
        scale: Qt.vector3d(root.undulateX * 0.98, 1.0, root.undulateY * 0.98)
        castsShadows: false
        receivesShadows: false

        materials: [
            PrincipledMaterial {
                id: matLayer2
                lighting: PrincipledMaterial.NoLighting
                baseColor: root.airColor
                cullMode: PrincipledMaterial.NoCulling
                alphaMode: PrincipledMaterial.Blend

                opacity: root.streamOpacity * 0.60
                Behavior on opacity {
                    NumberAnimation { duration: 260; easing.type: Easing.InOutQuad }
                }

                baseColorMap: Texture {
                    source: "images/airflow_ribbon_layer2.png"
                    positionV: root.flowPos2
                    scaleV: 1.0
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

    // -------------------------------------------------------------------------
    // STREAM LAYER 3: Luminous White Core Velocity Streak (Fastest)
    // -------------------------------------------------------------------------
    property real flowPos3: 0.0
    NumberAnimation {
        target: root
        property: "flowPos3"
        from: 0.0
        to: -1.0
        duration: Math.max(500, Math.round(1250 / Math.max(0.2, root.speedMultiplier)))
        running: root.active && root.fanSpeed > 0
        loops: Animation.Infinite
        easing.type: Easing.Linear
    }

    Model {
        id: layer3Model
        source: root.meshSource
        scale: Qt.vector3d(root.undulateX * 0.95, 1.0, root.undulateY * 0.95)
        castsShadows: false
        receivesShadows: false

        materials: [
            PrincipledMaterial {
                id: matLayer3
                lighting: PrincipledMaterial.NoLighting
                baseColor: "#ffffff"
                cullMode: PrincipledMaterial.NoCulling
                alphaMode: PrincipledMaterial.Blend

                opacity: root.fanSpeed >= 2 ? (root.streamOpacity * (0.35 + (root.fanSpeed / 7.0) * 0.35)) : 0.0
                Behavior on opacity {
                    NumberAnimation { duration: 260; easing.type: Easing.InOutQuad }
                }

                baseColorMap: Texture {
                    source: "images/airflow_ribbon_core.png"
                    positionV: root.flowPos3
                    scaleV: 1.0
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
