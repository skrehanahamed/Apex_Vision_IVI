/**
 * ==============================================================================
 * Project: Apex VISION IVI
 * File: Scene.qml (True 3-Mesh Consolidated Architecture)
 * Model Nodes: Car_Body_Cabin (25MB), Roof_Assembly (5.4MB), Wheels_Assembly (201KB)
 * ==============================================================================
 */

import QtQuick
import QtQuick3D

Node {
    id: carModelRoot

    property color paintColor: "#EDF2F7"
    property real metalness: 0.18
    property real roughness: 0.24
    property real clearcoat: 0.75
    property bool lightsOn: true
    property real wheelAngle: 0.0
    property bool roofVisible: true
    property bool wheelsVisible: true
    property color ambientColor: "#FF3B30"
    property real ambientBrightness: 1.0
    property bool ambientOn: false


    // Resources
    property url textureData: "maps/textureData.png"
    property url textureData164: "maps/textureData164.png"
    property url textureData161: "maps/textureData161.png"
    property url textureData9: "maps/textureData9.png"
    property url textureData158: "maps/textureData158.png"
    property url textureData11: "maps/textureData11.png"
    property url textureData155: "maps/textureData155.png"
    property url textureData149: "maps/textureData149.png"
    property url textureData14: "maps/textureData14.png"
    property url textureData142: "maps/textureData142.png"
    property url textureData139: "maps/textureData139.png"
    property url textureData17: "maps/textureData17.png"
    property url textureData137: "maps/textureData137.png"
    property url textureData133: "maps/textureData133.png"
    property url textureData130: "maps/textureData130.png"
    property url textureData21: "maps/textureData21.png"
    property url textureData128: "maps/textureData128.png"
    property url textureData125: "maps/textureData125.png"
    property url textureData123: "maps/textureData123.png"
    property url textureData120: "maps/textureData120.png"
    property url textureData118: "maps/textureData118.png"
    property url textureData115: "maps/textureData115.png"
    property url textureData28: "maps/textureData28.png"
    property url textureData113: "maps/textureData113.png"
    property url textureData30: "maps/textureData30.png"
    property url textureData110: "maps/textureData110.png"
    property url textureData108: "maps/textureData108.png"
    property url textureData105: "maps/textureData105.png"
    property url textureData103: "maps/textureData103.png"
    property url textureData35: "maps/textureData35.png"
    property url textureData100: "maps/textureData100.png"
    property url textureData37: "maps/textureData37.png"
    property url textureData98: "maps/textureData98.png"
    property url textureData95: "maps/textureData95.png"
    property url textureData40: "maps/textureData40.png"
    property url textureData92: "maps/textureData92.png"
    property url textureData89: "maps/textureData89.png"
    property url textureData43: "maps/textureData43.png"
    property url textureData85: "maps/textureData85.png"
    property url textureData45: "maps/textureData45.png"
    property url textureData82: "maps/textureData82.png"
    property url textureData80: "maps/textureData80.png"
    property url textureData48: "maps/textureData48.png"
    property url textureData76: "maps/textureData76.png"
    property url textureData50: "maps/textureData50.png"
    property url textureData74: "maps/textureData74.png"
    property url textureData71: "maps/textureData71.png"
    property url textureData53: "maps/textureData53.png"
    property url textureData68: "maps/textureData68.png"
    property url textureData55: "maps/textureData55.png"
    property url textureData66: "maps/textureData66.png"
    property url textureData63: "maps/textureData63.png"
    property url textureData58: "maps/textureData58.png"
    Texture {
        id: _52_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData164
    }
    Texture {
        id: _36_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData113
    }
    Texture {
        id: _0_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData9
    }
    Texture {
        id: _18_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData63
    }
    Texture {
        id: _16_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData58
    }
    Texture {
        id: _51_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData161
    }
    Texture {
        id: _19_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData66
    }
    Texture {
        id: _1_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData11
    }
    Texture {
        id: _20_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData68
    }
    Texture {
        id: _15_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData55
    }
    Texture {
        id: _50_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData158
    }
    Texture {
        id: _21_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData71
    }
    Texture {
        id: _14_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData53
    }
    Texture {
        id: _49_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData155
    }
    Texture {
        id: _22_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData74
    }
    Texture {
        id: _2_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData14
    }
    Texture {
        id: _23_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData76
    }
    Texture {
        id: _13_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData50
    }
    Texture {
        id: _48_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData149
    }
    Texture {
        id: _47_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData142
    }
    Texture {
        id: _24_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData80
    }
    Texture {
        id: _12_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData48
    }
    Texture {
        id: _25_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData82
    }
    Texture {
        id: _3_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData17
    }
    Texture {
        id: _46_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData139
    }
    Texture {
        id: _26_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData85
    }
    Texture {
        id: _11_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData45
    }
    Texture {
        id: _45_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData137
    }
    Texture {
        id: _44_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData133
    }
    Texture {
        id: _27_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData89
    }
    Texture {
        id: _10_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData43
    }
    Texture {
        id: _4_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData21
    }
    Texture {
        id: _28_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData92
    }
    Texture {
        id: _43_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData130
    }
    Texture {
        id: _42_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData128
    }
    Texture {
        id: _29_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData95
    }
    Texture {
        id: _9_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData40
    }
    Texture {
        id: _41_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData125
    }
    Texture {
        id: _30_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData98
    }
    Texture {
        id: _40_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData123
    }
    Texture {
        id: _31_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData100
    }
    Texture {
        id: _8_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData37
    }
    Texture {
        id: _39_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData120
    }
    Texture {
        id: _32_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData103
    }
    Texture {
        id: _7_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData35
    }
    Texture {
        id: _33_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData105
    }
    Texture {
        id: _38_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData118
    }
    Texture {
        id: _5_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData28
    }
    Texture {
        id: _34_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData108
    }
    Texture {
        id: _37_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData115
    }
    Texture {
        id: _35_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData110
    }
    Texture {
        id: _6_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData30
    }
    Texture {
        id: _17_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData
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
    PrincipledMaterial {
        id: meshesuntitled2doorrfmirror1Mtl_material
        objectName: "Meshesuntitled2doorrfmirror1Mtl"
        metalness: 1
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
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
        id: apex_Emblem_Mtl_material
        objectName: "Apex_Emblem_Mtl"
        baseColorMap: _7_texture
        metalness: 0.949999988079071
        roughness: 0.15000000596046448
        emissiveMap: _8_texture
        emissiveFactor: Qt.vector3d(1, 1, 1)
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Blend
    }
    PrincipledMaterial {
        id: meshesuntitled2carbodyfrostedplastic50021Mtl_material
        objectName: "Meshesuntitled2carbodyfrostedplastic50021Mtl"
        baseColor: "#ff080808"
        metalnessMap: _5_texture
        roughnessMap: _5_texture
        metalness: 0.05000000074505806
        roughness: 0.28810974955558777
        normalMap: _6_texture
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
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
        id: meshesuntitled1bodyheadlampplastic1Mtl_material
        objectName: "Meshesuntitled1bodyheadlampplastic1Mtl"
        baseColor: "#ff080808"
        metalness: 0.05000000074505806
        roughness: 0.3246951103210449
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
        id: meshesuntitled1trunkbodyplastic51Mtl_material
        objectName: "Meshesuntitled1trunkbodyplastic51Mtl"
        baseColor: "#ffa4a3a6"
        metalness: 0.05000000074505806
        roughness: 1
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
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
        id: meshesuntitled1bodylightglass1Mtl_material
        objectName: "Meshesuntitled1bodylightglass1Mtl"
        baseColor: "#66080808"
        metalness: 0.05000000074505806
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Blend
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
        id: meshesuntitled1bodyfrontgrillechorme0011Mtl_material
        objectName: "Meshesuntitled1bodyfrontgrillechorme0011Mtl"
        baseColor: "#fffafbfc"
        metalness: 0.9800000190734863
        roughness: 0.07999999821186066
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
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
        id: meshesuntitled1bodyfrontgrillepaint1Mtl_material
        objectName: "Meshesuntitled1bodyfrontgrillepaint1Mtl"
        baseColor: carModelRoot.paintColor
        metalness: carModelRoot.metalness
        roughness: carModelRoot.roughness
        clearcoatAmount: carModelRoot.clearcoat
        clearcoatRoughnessAmount: 0.04
        cullMode: PrincipledMaterial.BackFaceCulling
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
        id: meshesuntitled2bodyskyglassglassskylight1Mtl_material
        objectName: "Meshesuntitled2bodyskyglassglassskylight1Mtl"
        baseColor: "#05070A"
        metalness: 0.15
        roughness: 0.03
        clearcoatAmount: 1.0
        clearcoatRoughnessAmount: 0.01
        cullMode: PrincipledMaterial.BackFaceCulling
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
        id: meshesuntitled1bodyglassglass1Mtl_material
        objectName: "Meshesuntitled1bodyglassglass1Mtl"
        baseColor: "#05070A"
        metalness: 0.15
        roughness: 0.03
        clearcoatAmount: 1.0
        clearcoatRoughnessAmount: 0.01
        cullMode: PrincipledMaterial.BackFaceCulling
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
        id: meshesuntitled1wheelbrowheeltire1Mtl_material
        objectName: "Meshesuntitled1wheelbrowheeltire1Mtl"
        baseColorMap: _51_texture
        metalness: 0.05000000074505806
        roughness: 1
        emissiveMap: _51_texture
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
        id: meshesuntitled3wheelblowheeltire1Mtl_material
        objectName: "Meshesuntitled3wheelblowheeltire1Mtl"
        baseColorMap: _52_texture
        metalness: 0.05000000074505806
        roughness: 1
        emissiveMap: _52_texture
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: meshesuntitled3carbodyint181Mtl_material
        objectName: "Meshesuntitled3carbodyint181Mtl"
        baseColor: "#ff1b53ba"
        metalness: 0.05000000074505806
        roughness: 1
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
                    id: car_Body_Cabin
                    objectName: "Car_Body_Cabin"
                    source: "meshes/car_Body_Cabin_mesh.mesh"
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
                        apex_Emblem_Mtl_material,
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
                    visible: true
                    position: carModelRoot.roofVisible ? Qt.vector3d(0, 0, 0) : Qt.vector3d(0, -5000, 0)
                    castsShadows: carModelRoot.roofVisible
                    receivesShadows: carModelRoot.roofVisible
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
                    id: wheels_Assembly
                    visible: true
                    position: carModelRoot.wheelsVisible ? Qt.vector3d(0, 0, 0) : Qt.vector3d(0, -5000, 0)
                    castsShadows: carModelRoot.wheelsVisible
                    receivesShadows: carModelRoot.wheelsVisible
                    objectName: "Wheels_Assembly"
                    source: "meshes/wheels_Assembly_mesh.mesh"
                    materials: [
                        meshesuntitled2wheelflowheeltire1Mtl_material,
                        meshesuntitled1wheelfrowheeltire1Mtl_material,
                        meshesuntitled1wheelbrowheeltire1Mtl_material,
                        meshesuntitled3wheelblowheeltire1Mtl_material
                    ]
                }
            }
        }
    }

    // Animations:
}
