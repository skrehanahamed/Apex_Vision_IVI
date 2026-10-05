/**
 * ==============================================================================
 * Project: Apex VISION IVI - Digital Cockpit & Infotainment System
 * File: Scene.qml (Consolidated 7-Mesh Architecture)
 * Author / Developer: Sk Rehan Ahamed
 * License: MIT
 * ==============================================================================
 */

import QtQuick
import QtQuick3D

Node {
    id: carModelRoot

    readonly property var root: carModelRoot
    property color paintColor: "#F5F7FA"
    property real metalness: 0.08
    property real roughness: 0.16
    property real clearcoat: 0.95
    property bool lightsOn: true
    property real wheelAngle: 0.0
    property bool roofVisible: true
    property color ambientColor: "#FF3B30"
    property real ambientBrightness: 1.0
    property bool ambientOn: false

    readonly property alias tireFL: wheel_FL
    readonly property alias tireFR: wheel_FR
    readonly property alias tireRL: wheel_RL
    readonly property alias tireRR: wheel_RR

    Texture {
        id: textures_apex_emblem_diffuse_png_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: "maps/apex_emblem_diffuse.png"
    }
    Texture {
        id: textures_apex_emblem_emissive_png_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: "maps/apex_emblem_emissive.png"
    }

    property url textureData: "maps/textureData.png"
    property url textureData87: "maps/textureData87.png"
    property url textureData60: "maps/textureData60.png"
    property url textureData11: "maps/textureData11.png"
    property url textureData168: "maps/textureData168.png"
    property url textureData14: "maps/textureData14.png"
    property url textureData17: "maps/textureData17.png"
    property url textureData163: "maps/textureData163.png"
    property url textureData21: "maps/textureData21.png"
    property url textureData158: "maps/textureData158.png"
    property url textureData151: "maps/textureData151.png"
    property url textureData144: "maps/textureData144.png"
    property url textureData28: "maps/textureData28.png"
    property url textureData30: "maps/textureData30.png"
    property url textureData141: "maps/textureData141.png"
    property url textureData35: "maps/textureData35.png"
    property url textureData37: "maps/textureData37.png"
    property url textureData139: "maps/textureData139.png"
    property url textureData42: "maps/textureData42.png"
    property url textureData110: "maps/textureData110.png"
    property url textureData115: "maps/textureData115.png"
    property url textureData107: "maps/textureData107.png"
    property url textureData105: "maps/textureData105.png"
    property url textureData102: "maps/textureData102.png"
    property url textureData100: "maps/textureData100.png"
    property url textureData117: "maps/textureData117.png"
    property url textureData97: "maps/textureData97.png"
    property url textureData94: "maps/textureData94.png"
    property url textureData120: "maps/textureData120.png"
    property url textureData91: "maps/textureData91.png"
    property url textureData173: "maps/textureData173.png"
    property url textureData122: "maps/textureData122.png"
    property url textureData84: "maps/textureData84.png"
    property url textureData82: "maps/textureData82.png"
    property url textureData125: "maps/textureData125.png"
    property url textureData78: "maps/textureData78.png"
    property url textureData135: "maps/textureData135.png"
    property url textureData76: "maps/textureData76.png"
    property url textureData45: "maps/textureData45.png"
    property url textureData73: "maps/textureData73.png"
    property url textureData47: "maps/textureData47.png"
    property url textureData127: "maps/textureData127.png"
    property url textureData70: "maps/textureData70.png"
    property url textureData50: "maps/textureData50.png"
    property url textureData68: "maps/textureData68.png"
    property url textureData52: "maps/textureData52.png"
    property url textureData132: "maps/textureData132.png"
    property url textureData65: "maps/textureData65.png"
    property url textureData55: "maps/textureData55.png"
    property url textureData130: "maps/textureData130.png"
    property url textureData57: "maps/textureData57.png"
    property url textureData62: "maps/textureData62.png"
    property url textureData9: "maps/textureData9.png"
    Texture {
        id: _17_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData62
    }
    Texture {
        id: _36_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData115
    }
    Texture {
        id: _43_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData132
    }
    Texture {
        id: _15_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData57
    }
    Texture {
        id: _18_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData65
    }
    Texture {
        id: _14_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData55
    }
    Texture {
        id: _42_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData130
    }
    Texture {
        id: _19_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData68
    }
    Texture {
        id: _13_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData52
    }
    Texture {
        id: _20_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData70
    }
    Texture {
        id: _12_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData50
    }
    Texture {
        id: _44_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData135
    }
    Texture {
        id: _21_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData73
    }
    Texture {
        id: _11_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData47
    }
    Texture {
        id: _41_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData127
    }
    Texture {
        id: _22_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData76
    }
    Texture {
        id: _10_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData45
    }
    Texture {
        id: _23_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData78
    }
    Texture {
        id: _9_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData42
    }
    Texture {
        id: _45_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData139
    }
    Texture {
        id: _40_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData125
    }
    Texture {
        id: _24_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData82
    }
    Texture {
        id: _8_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData37
    }
    Texture {
        id: _25_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData84
    }
    Texture {
        id: _7_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData35
    }
    Texture {
        id: _46_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData141
    }
    Texture {
        id: _26_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData87
    }
    Texture {
        id: _52_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData173
    }
    Texture {
        id: _47_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData144
    }
    Texture {
        id: _39_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData122
    }
    Texture {
        id: _27_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData91
    }
    Texture {
        id: _6_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData30
    }
    Texture {
        id: _5_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData28
    }
    Texture {
        id: _28_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData94
    }
    Texture {
        id: _48_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData151
    }
    Texture {
        id: _38_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData120
    }
    Texture {
        id: _29_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData97
    }
    Texture {
        id: _49_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData158
    }
    Texture {
        id: _4_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData21
    }
    Texture {
        id: _30_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData100
    }
    Texture {
        id: _50_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData163
    }
    Texture {
        id: _31_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData102
    }
    Texture {
        id: _3_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData17
    }
    Texture {
        id: _37_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData117
    }
    Texture {
        id: _32_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData105
    }
    Texture {
        id: _51_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData168
    }
    Texture {
        id: _33_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData107
    }
    Texture {
        id: _2_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData14
    }
    Texture {
        id: _1_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData11
    }
    Texture {
        id: _34_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData110
    }
    Texture {
        id: _0_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData9
    }
    Texture {
        id: _35_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData
    }
    Texture {
        id: _16_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData60
    }
    PrincipledMaterial {
        id: meshesuntitled1bodyfrontgrillepaint1Mtl_material
        objectName: "Meshesuntitled1bodyfrontgrillepaint1Mtl"
        baseColor: carModelRoot.paintColor
        metalness: carModelRoot.metalness
        roughness: carModelRoot.roughness
        clearcoatAmount: carModelRoot.clearcoat
        clearcoatRoughnessAmount: 0.04
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: meshesuntitled3carbodyint181Mtl_material
        objectName: "Meshesuntitled3carbodyint181Mtl"
        baseColor: carModelRoot.ambientOn ? carModelRoot.ambientColor : "#ff1b53ba"
        emissiveFactor: carModelRoot.ambientOn ?
            Qt.vector3d(carModelRoot.ambientColor.r * carModelRoot.ambientBrightness,
                        carModelRoot.ambientColor.g * carModelRoot.ambientBrightness,
                        carModelRoot.ambientColor.b * carModelRoot.ambientBrightness) :
            Qt.vector3d(0, 0, 0)
        metalness: 0.05
        roughness: 0.2
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: meshesuntitled5doorlbint401Mtl_material
        objectName: "Meshesuntitled5doorlbint401Mtl"
        baseColor: "#faffffff"
        baseColorMap: _34_texture
        metalness: 0.05000000074505806
        roughness: 1
        emissiveMap: _35_texture
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Blend
    }
    PrincipledMaterial {
        id: meshesuntitled5carbodyint151Mtl_material
        objectName: "Meshesuntitled5carbodyint151Mtl"
        baseColor: "#faffffff"
        baseColorMap: _32_texture
        metalness: 0.05000000074505806
        roughness: 1
        emissiveMap: _33_texture
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Blend
    }
    PrincipledMaterial {
        id: meshesuntitled41Mtl_material
        objectName: "Meshesuntitled41Mtl"
        baseColor: "#ff080808"
        metalnessMap: _30_texture
        roughnessMap: _30_texture
        metalness: 0.05000000074505806
        roughness: 0.23323170840740204
        normalMap: _31_texture
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: meshesuntitled5doorrbint401Mtl_material
        objectName: "Meshesuntitled5doorrbint401Mtl"
        baseColor: "#faffffff"
        baseColorMap: _38_texture
        metalness: 0.05000000074505806
        roughness: 1
        emissiveMap: _39_texture
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Blend
    }
    PrincipledMaterial {
        id: meshesuntitled3doorrbint381Mtl_material
        objectName: "Meshesuntitled3doorrbint381Mtl"
        baseColorMap: _29_texture
        metalness: 0.05000000074505806
        roughness: 1
        emissiveMap: _29_texture
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: meshesuntitled3doorrbint371Mtl_material
        objectName: "Meshesuntitled3doorrbint371Mtl"
        baseColorMap: _28_texture
        metalness: 0.05000000074505806
        roughness: 1
        emissiveMap: _28_texture
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: meshesuntitled3doorlbint381Mtl_material
        objectName: "Meshesuntitled3doorlbint381Mtl"
        baseColorMap: _27_texture
        metalness: 0.05000000074505806
        roughness: 1
        emissiveMap: _27_texture
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: meshesuntitled3doorlbint371Mtl_material
        objectName: "Meshesuntitled3doorlbint371Mtl"
        baseColorMap: _26_texture
        metalness: 0.05000000074505806
        roughness: 1
        emissiveMap: _26_texture
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: meshesuntitled5doorrfint401Mtl_material
        objectName: "Meshesuntitled5doorrfint401Mtl"
        baseColor: "#faffffff"
        baseColorMap: _40_texture
        metalness: 0.05000000074505806
        roughness: 1
        emissiveMap: _41_texture
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Blend
    }
    PrincipledMaterial {
        id: meshesuntitled3carbodyint121Mtl_material
        objectName: "Meshesuntitled3carbodyint121Mtl"
        baseColor: "#ff080808"
        metalnessMap: _24_texture
        roughnessMap: _24_texture
        metalness: 0.05000000074505806
        roughness: 0.999910831451416
        normalMap: _25_texture
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: meshesuntitled3carbodyfrostedplastic21Mtl_material
        objectName: "Meshesuntitled3carbodyfrostedplastic21Mtl"
        baseColor: "#ff760000"
        metalnessMap: _5_texture
        roughnessMap: _5_texture
        metalness: 0.05000000074505806
        roughness: 0.9986796379089355
        normalMap: _6_texture
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: meshesuntitled2doorrfint421Mtl_material
        objectName: "Meshesuntitled2doorrfint421Mtl"
        baseColorMap: _22_texture
        metalness: 0.05000000074505806
        roughness: 1
        emissiveMap: _23_texture
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Blend
    }
    PrincipledMaterial {
        id: meshesuntitled2doorrfint381Mtl_material
        objectName: "Meshesuntitled2doorrfint381Mtl"
        baseColorMap: _21_texture
        metalness: 0.05000000074505806
        roughness: 1
        emissiveMap: _21_texture
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: meshesuntitled71Mtl_material
        objectName: "Meshesuntitled71Mtl"
        baseColor: "#ff080808"
        metalnessMap: _42_texture
        roughnessMap: _42_texture
        metalness: 0.05000000074505806
        roughness: 0.2393292635679245
        normalMap: _43_texture
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: meshesuntitled3carbodyint131Mtl_material
        objectName: "Meshesuntitled3carbodyint131Mtl"
        baseColorMap: _19_texture
        metalness: 0.05000000074505806
        roughness: 1
        emissiveMap: _20_texture
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Blend
    }
    PrincipledMaterial {
        id: meshesuntitled2doorlfint381Mtl_material
        objectName: "Meshesuntitled2doorlfint381Mtl"
        baseColorMap: _18_texture
        metalness: 0.05000000074505806
        roughness: 1
        emissiveMap: _18_texture
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: meshesuntitled2doorlfint421Mtl_material
        objectName: "Meshesuntitled2doorlfint421Mtl"
        baseColorMap: _16_texture
        metalness: 0.05000000074505806
        roughness: 1
        emissiveMap: _17_texture
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Blend
    }
    PrincipledMaterial {
        id: meshesuntitled2carbodyint471Mtl_material
        objectName: "Meshesuntitled2carbodyint471Mtl"
        baseColorMap: _14_texture
        metalness: 0.05000000074505806
        roughness: 1
        emissiveMap: _15_texture
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Blend
    }
    PrincipledMaterial {
        id: meshesuntitled8doorlfint371Mtl_material
        objectName: "Meshesuntitled8doorlfint371Mtl"
        baseColorMap: _44_texture
        metalness: 0.05000000074505806
        roughness: 1
        emissiveMap: _44_texture
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: meshesuntitled1trunkbodyint1Mtl_material
        objectName: "Meshesuntitled1trunkbodyint1Mtl"
        baseColorMap: _12_texture
        metalness: 0.05000000074505806
        roughness: 1
        emissiveMap: _13_texture
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Blend
    }
    PrincipledMaterial {
        id: meshesuntitled1bodyfrontgrilleint1Mtl_material
        objectName: "Meshesuntitled1bodyfrontgrilleint1Mtl"
        baseColorMap: _10_texture
        metalness: 0.05000000074505806
        roughness: 1
        emissiveMap: _11_texture
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Blend
    }
    PrincipledMaterial {
        id: meshesuntitled3carbodyint191Mtl_material
        objectName: "Meshesuntitled3carbodyint191Mtl"
        baseColor: "#ff760000"
        metalness: 0.05000000074505806
        roughness: 1
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: meshesuntitled3carbodyleather20021Mtl_material
        objectName: "Meshesuntitled3carbodyleather20021Mtl"
        baseColor: "#ff080808"
        metalnessMap: _45_texture
        roughnessMap: _45_texture
        metalness: 0.05000000074505806
        roughness: 0.33689025044441223
        normalMap: _46_texture
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: meshesuntitled2carbodyint271Mtl_material
        objectName: "Meshesuntitled2carbodyint271Mtl"
        baseColorMap: _9_texture
        metalness: 0.05000000074505806
        emissiveMap: _9_texture
        emissiveFactor: Qt.vector3d(1, 1, 1)
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: apex_Emblem_Mtl_material
        objectName: "Apex_Emblem_Mtl"
        baseColorMap: textures_apex_emblem_diffuse_png_texture
        metalness: 0.95
        roughness: 0.15
        emissiveMap: textures_apex_emblem_emissive_png_texture
        emissiveFactor: carModelRoot.lightsOn ? Qt.vector3d(1, 1, 1) : Qt.vector3d(0, 0, 0)
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Blend
    }
    PrincipledMaterial {
        id: apex_Backing_Mtl_material
        objectName: "Apex_Backing_Mtl"
        baseColor: "#ff212121"
        metalness: 0.8999999761581421
        roughness: 0.10000000149011612
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: meshesuntitledcarbodyleather51Mtl_material
        objectName: "Meshesuntitledcarbodyleather51Mtl"
        baseColor: "#ff080808"
        metalnessMap: _47_texture
        roughnessMap: _47_texture
        metalness: 0.05000000074505806
        roughness: 0.34908536076545715
        normalMap: _46_texture
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: meshesuntitled2doorrfmirror1Mtl_material
        objectName: "Meshesuntitled2doorrfmirror1Mtl"
        metalness: 1
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: meshesuntitled2carbodyfrostedplastic50021Mtl_material
        objectName: "Meshesuntitled2carbodyfrostedplastic50021Mtl"
        baseColor: carModelRoot.paintColor
        metalness: carModelRoot.metalness
        roughness: carModelRoot.roughness
        clearcoatAmount: carModelRoot.clearcoat
        clearcoatRoughnessAmount: 0.04
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: meshesuntitled2bodyskyglassglassskylight1Mtl_material
        objectName: "Meshesuntitled2bodyskyglassglassskylight1Mtl"
        baseColor: "#05070A"
        metalness: 0.15
        roughness: 0.03
        clearcoatAmount: 1.0
        clearcoatRoughnessAmount: 0.01
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: meshesuntitled2carbodyfrostedplastic61Mtl_material
        objectName: "Meshesuntitled2carbodyfrostedplastic61Mtl"
        baseColor: "#ffcecece"
        metalnessMap: _5_texture
        roughnessMap: _5_texture
        metalness: 0.05000000074505806
        roughness: 0.9786701798439026
        normalMap: _6_texture
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: meshesuntitled2carbodyint171Mtl_material
        objectName: "Meshesuntitled2carbodyint171Mtl"
        baseColorMap: _48_texture
        metalness: 0.05000000074505806
        roughness: 1
        emissiveMap: _48_texture
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: meshesuntitled1bodyheadlampplastic1Mtl_material
        objectName: "Meshesuntitled1bodyheadlampplastic1Mtl"
        baseColor: "#ff080808"
        metalness: 0.05000000074505806
        roughness: 0.3246951103210449
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: meshesuntitled1trunkbodyplastic51Mtl_material
        objectName: "Meshesuntitled1trunkbodyplastic51Mtl"
        baseColor: "#ffa4a3a6"
        metalness: 0.05000000074505806
        roughness: 1
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: meshesuntitled1bodyglassglass1Mtl_material
        objectName: "Meshesuntitled1bodyglassglass1Mtl"
        baseColor: "#05070A"
        metalness: 0.15
        roughness: 0.03
        clearcoatAmount: 1.0
        clearcoatRoughnessAmount: 0.01
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: meshesuntitled2wheelflowheeltire1Mtl_material
        objectName: "Meshesuntitled2wheelflowheeltire1Mtl"
        baseColorMap: _49_texture
        metalness: 0.05000000074505806
        roughness: 1
        emissiveMap: _49_texture
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: meshesuntitled1bodylightglass1Mtl_material
        objectName: "Meshesuntitled1bodylightglass1Mtl"
        baseColor: "#66080808"
        metalness: 0.05000000074505806
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Blend
    }
    PrincipledMaterial {
        id: meshesuntitled1bodyfrontgrillechorme0011Mtl_material
        objectName: "Meshesuntitled1bodyfrontgrillechorme0011Mtl"
        baseColor: "#fffafbfc"
        metalness: 0.9800000190734863
        roughness: 0.07999999821186066
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: meshesuntitled1wheelfrowheeltire1Mtl_material
        objectName: "Meshesuntitled1wheelfrowheeltire1Mtl"
        baseColorMap: _50_texture
        metalness: 0.05000000074505806
        roughness: 1
        emissiveMap: _50_texture
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: meshesuntitled1trunkbodyplate1Mtl_material
        objectName: "Meshesuntitled1trunkbodyplate1Mtl"
        baseColorMap: _4_texture
        metalness: 0.05000000074505806
        roughness: 0.3125
        emissiveMap: _4_texture
        emissiveFactor: Qt.vector3d(1, 1, 1)
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: meshesuntitled1bodyheadlampglass1Mtl_material
        objectName: "Meshesuntitled1bodyheadlampglass1Mtl"
        baseColor: "#8d080808"
        metalness: 0.05000000074505806
        roughness: 1
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Blend
    }
    PrincipledMaterial {
        id: meshesuntitled3wheelblowheeltire1Mtl_material
        objectName: "Meshesuntitled3wheelblowheeltire1Mtl"
        baseColorMap: _51_texture
        metalness: 0.05000000074505806
        roughness: 1
        emissiveMap: _51_texture
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: meshesuntitled131Mtl_material
        objectName: "Meshesuntitled131Mtl"
        baseColorMap: _3_texture
        metalness: 0.05000000074505806
        roughness: 1
        emissiveMap: _3_texture
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: meshesuntitled111Mtl_material
        objectName: "Meshesuntitled111Mtl"
        baseColorMap: _2_texture
        metalness: 0.05000000074505806
        roughness: 0.30640244483947754
        emissiveMap: _2_texture
        emissiveFactor: Qt.vector3d(1, 1, 1)
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: meshesuntitled1wheelbrowheeltire1Mtl_material
        objectName: "Meshesuntitled1wheelbrowheeltire1Mtl"
        baseColorMap: _52_texture
        metalness: 0.05000000074505806
        roughness: 1
        emissiveMap: _52_texture
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: meshesuntitled101Mtl_material
        objectName: "Meshesuntitled101Mtl"
        baseColor: "#ffd4d3d6"
        metalnessMap: _0_texture
        roughnessMap: _0_texture
        metalness: 0.05000000074505806
        roughness: 0.9774071574211121
        normalMap: _1_texture
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: meshesuntitled5doorlfint401Mtl_material
        objectName: "Meshesuntitled5doorlfint401Mtl"
        baseColor: "#faffffff"
        baseColorMap: _36_texture
        metalness: 0.05000000074505806
        roughness: 1
        emissiveMap: _37_texture
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Blend
    }

    // Nodes:
    Node {
        id: root
        objectName: "ROOT"
        Node {
            id: rearTarget
            objectName: "RearTarget"
            position: Qt.vector3d(-1.5, 2.725, -9.645)
        }
        Node {
            id: sketchfab_model
            objectName: "Sketchfab_model"
            position: Qt.vector3d(19.0592, -1.06017e-05, -74.233)
            rotation: Qt.quaternion(0.707107, -0.707107, 0, 0)
            scale: Qt.vector3d(1, 1, 1)
            Node {
                id: node2023_Lincoln_Zephyr_obj_cleaner_materialmerger_gles
                objectName: "2023 Lincoln Zephyr.obj.cleaner.materialmerger.gles"
                Model {
                    id: exterior_Body
                    objectName: "Exterior_Body"
                    source: "meshes/exterior_Body_mesh.mesh"
                    materials: [
                        meshesuntitled1bodyfrontgrillepaint1Mtl_material,
                        meshesuntitled101Mtl_material,
                        meshesuntitled111Mtl_material,
                        meshesuntitled131Mtl_material,
                        meshesuntitled1bodyheadlampglass1Mtl_material,
                        meshesuntitled1trunkbodyplate1Mtl_material,
                        meshesuntitled1bodyfrontgrillechorme0011Mtl_material,
                        meshesuntitled1bodylightglass1Mtl_material,
                        meshesuntitled1trunkbodyplastic51Mtl_material,
                        meshesuntitled1bodyheadlampplastic1Mtl_material,
                        meshesuntitled2carbodyfrostedplastic50021Mtl_material,
                        meshesuntitled2doorrfmirror1Mtl_material,
                        apex_Backing_Mtl_material,
                        apex_Emblem_Mtl_material
                    ]
                }
                Model {
                    id: interior_Cabin
                    objectName: "Interior_Cabin"
                    source: "meshes/interior_Cabin_mesh.mesh"
                    materials: [
                        meshesuntitled2carbodyint271Mtl_material,
                        meshesuntitled1bodyfrontgrilleint1Mtl_material,
                        meshesuntitled1trunkbodyint1Mtl_material,
                        meshesuntitled2carbodyint471Mtl_material,
                        meshesuntitled2doorlfint421Mtl_material,
                        meshesuntitled2doorlfint381Mtl_material,
                        meshesuntitled3carbodyint131Mtl_material,
                        meshesuntitled2doorrfint381Mtl_material,
                        meshesuntitled2doorrfint421Mtl_material,
                        meshesuntitled3carbodyfrostedplastic21Mtl_material,
                        meshesuntitled3carbodyint121Mtl_material,
                        meshesuntitled3doorlbint371Mtl_material,
                        meshesuntitled3carbodyint181Mtl_material,
                        meshesuntitled3doorlbint381Mtl_material,
                        meshesuntitled3doorrbint371Mtl_material,
                        meshesuntitled3doorrbint381Mtl_material,
                        meshesuntitled41Mtl_material,
                        meshesuntitled5carbodyint151Mtl_material,
                        meshesuntitled5doorlbint401Mtl_material,
                        meshesuntitled5doorlfint401Mtl_material,
                        meshesuntitled5doorrbint401Mtl_material,
                        meshesuntitled5doorrfint401Mtl_material,
                        meshesuntitled71Mtl_material,
                        meshesuntitled8doorlfint371Mtl_material,
                        meshesuntitled3carbodyint191Mtl_material,
                        meshesuntitled3carbodyleather20021Mtl_material,
                        meshesuntitledcarbodyleather51Mtl_material
                    ]
                }
                Model {
                    id: roof_Assembly
                    visible: carModelRoot.roofVisible
                    objectName: "Roof_Assembly"
                    source: "meshes/roof_Assembly_mesh.mesh"
                    materials: [
                        meshesuntitled2bodyskyglassglassskylight1Mtl_material,
                        meshesuntitled2carbodyfrostedplastic61Mtl_material,
                        meshesuntitled2carbodyint171Mtl_material,
                        meshesuntitled1bodyfrontgrillechorme0011Mtl_material,
                        meshesuntitled1bodyglassglass1Mtl_material,
                        meshesuntitled1bodyheadlampplastic1Mtl_material,
                        meshesuntitled2carbodyfrostedplastic50021Mtl_material
                    ]
                }
                Model {
                    id: wheel_FL
                    objectName: "Wheel_FL"
                    source: "meshes/wheel_FL_mesh.mesh"
                    position: Qt.vector3d(-15.998, -80.290, 1.384)
                    pivot: Qt.vector3d(-15.998, -80.290, 1.384)
                    eulerRotation: Qt.vector3d(carModelRoot.wheelAngle, 0, 0)
                    materials: [
                        meshesuntitled2wheelflowheeltire1Mtl_material
                    ]
                }
                Model {
                    id: wheel_FR
                    objectName: "Wheel_FR"
                    source: "meshes/wheel_FR_mesh.mesh"
                    position: Qt.vector3d(-22.119, -80.290, 1.384)
                    pivot: Qt.vector3d(-22.119, -80.290, 1.384)
                    eulerRotation: Qt.vector3d(carModelRoot.wheelAngle, 0, 0)
                    materials: [
                        meshesuntitled1wheelfrowheeltire1Mtl_material
                    ]
                }
                Model {
                    id: wheel_RL
                    objectName: "Wheel_RL"
                    source: "meshes/wheel_RL_mesh.mesh"
                    position: Qt.vector3d(-15.998, -68.515, 1.385)
                    pivot: Qt.vector3d(-15.998, -68.515, 1.385)
                    eulerRotation: Qt.vector3d(carModelRoot.wheelAngle, 0, 0)
                    materials: [
                        meshesuntitled3wheelblowheeltire1Mtl_material
                    ]
                }
                Model {
                    id: wheel_RR
                    objectName: "Wheel_RR"
                    source: "meshes/wheel_RR_mesh.mesh"
                    position: Qt.vector3d(-22.119, -68.514, 1.384)
                    pivot: Qt.vector3d(-22.119, -68.514, 1.384)
                    eulerRotation: Qt.vector3d(carModelRoot.wheelAngle, 0, 0)
                    materials: [
                        meshesuntitled1wheelbrowheeltire1Mtl_material
                    ]
                }
            }
        }
    }

    // Animations:
}
