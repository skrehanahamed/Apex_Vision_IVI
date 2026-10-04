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

    readonly property alias tireFL: wheel_FL
    readonly property alias tireFR: wheel_FR
    readonly property alias tireRL: wheel_RL
    readonly property alias tireRR: wheel_RR

    // Resources

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
    property url textureData168: "maps/textureData168.png"
    property url textureData163: "maps/textureData163.png"
    property url textureData9: "maps/textureData9.png"
    property url textureData158: "maps/textureData158.png"
    property url textureData11: "maps/textureData11.png"
    property url textureData152: "maps/textureData152.png"
    property url textureData148: "maps/textureData148.png"
    property url textureData14: "maps/textureData14.png"
    property url textureData145: "maps/textureData145.png"
    property url textureData143: "maps/textureData143.png"
    property url textureData17: "maps/textureData17.png"
    property url textureData140: "maps/textureData140.png"
    property url textureData138: "maps/textureData138.png"
    property url textureData135: "maps/textureData135.png"
    property url textureData21: "maps/textureData21.png"
    property url textureData133: "maps/textureData133.png"
    property url textureData130: "maps/textureData130.png"
    property url textureData24: "maps/textureData24.png"
    property url textureData128: "maps/textureData128.png"
    property url textureData26: "maps/textureData26.png"
    property url textureData125: "maps/textureData125.png"
    property url textureData123: "maps/textureData123.png"
    property url textureData120: "maps/textureData120.png"
    property url textureData118: "maps/textureData118.png"
    property url textureData115: "maps/textureData115.png"
    property url textureData113: "maps/textureData113.png"
    property url textureData110: "maps/textureData110.png"
    property url textureData107: "maps/textureData107.png"
    property url textureData104: "maps/textureData104.png"
    property url textureData36: "maps/textureData36.png"
    property url textureData100: "maps/textureData100.png"
    property url textureData38: "maps/textureData38.png"
    property url textureData97: "maps/textureData97.png"
    property url textureData95: "maps/textureData95.png"
    property url textureData91: "maps/textureData91.png"
    property url textureData89: "maps/textureData89.png"
    property url textureData173: "maps/textureData173.png"
    property url textureData86: "maps/textureData86.png"
    property url textureData47: "maps/textureData47.png"
    property url textureData83: "maps/textureData83.png"
    property url textureData49: "maps/textureData49.png"
    property url textureData81: "maps/textureData81.png"
    property url textureData78: "maps/textureData78.png"
    property url textureData52: "maps/textureData52.png"
    property url textureData75: "maps/textureData75.png"
    property url textureData54: "maps/textureData54.png"
    property url textureData73: "maps/textureData73.png"
    property url textureData70: "maps/textureData70.png"
    property url textureData57: "maps/textureData57.png"
    property url textureData68: "maps/textureData68.png"
    property url textureData59: "maps/textureData59.png"
    property url textureData65: "maps/textureData65.png"
    Texture {
        id: _52_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData173
    }
    Texture {
        id: _15_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData
    }
    Texture {
        id: _25_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData89
    }
    Texture {
        id: _16_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData65
    }
    Texture {
        id: _51_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData168
    }
    Texture {
        id: _0_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData9
    }
    Texture {
        id: _17_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData68
    }
    Texture {
        id: _14_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData59
    }
    Texture {
        id: _18_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData70
    }
    Texture {
        id: _13_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData57
    }
    Texture {
        id: _50_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData163
    }
    Texture {
        id: _19_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData73
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
        source: carModelRoot.textureData75
    }
    Texture {
        id: _12_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData54
    }
    Texture {
        id: _49_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData158
    }
    Texture {
        id: _21_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData78
    }
    Texture {
        id: _11_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData52
    }
    Texture {
        id: _48_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData152
    }
    Texture {
        id: _22_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData81
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
        source: carModelRoot.textureData83
    }
    Texture {
        id: _10_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData49
    }
    Texture {
        id: _47_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData148
    }
    Texture {
        id: _24_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData86
    }
    Texture {
        id: _9_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData47
    }
    Texture {
        id: _46_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData145
    }
    Texture {
        id: _3_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData17
    }
    Texture {
        id: _45_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData143
    }
    Texture {
        id: _26_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData91
    }
    Texture {
        id: _44_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData140
    }
    Texture {
        id: _43_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData138
    }
    Texture {
        id: _4_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData21
    }
    Texture {
        id: _27_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData95
    }
    Texture {
        id: _42_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData135
    }
    Texture {
        id: _28_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData97
    }
    Texture {
        id: _41_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData133
    }
    Texture {
        id: _5_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData24
    }
    Texture {
        id: _29_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData100
    }
    Texture {
        id: _8_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData38
    }
    Texture {
        id: _40_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData130
    }
    Texture {
        id: _6_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData26
    }
    Texture {
        id: _30_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData104
    }
    Texture {
        id: _7_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData36
    }
    Texture {
        id: _39_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData128
    }
    Texture {
        id: _31_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData107
    }
    Texture {
        id: _38_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData125
    }
    Texture {
        id: _37_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData123
    }
    Texture {
        id: _32_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData110
    }
    Texture {
        id: _36_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData120
    }
    Texture {
        id: _35_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData118
    }
    Texture {
        id: _33_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData113
    }
    Texture {
        id: _34_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: carModelRoot.textureData115
    }
    PrincipledMaterial {
        id: meshesuntitled5carbodyint151Mtl_material
        objectName: "Meshesuntitled5carbodyint151Mtl"
        baseColor: "#faffffff"
        baseColorMap: _35_texture
        metalness: 0.05000000074505806
        roughness: 1
        emissiveMap: _36_texture
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Blend
    }
        PrincipledMaterial {
        id: meshesuntitled1bodyfrontgrillepaint1Mtl_material
        objectName: "Meshesuntitled1bodyfrontgrillepaint1Mtl"
        baseColor: carModelRoot.paintColor
        metalness: carModelRoot.metalness
        roughness: carModelRoot.roughness
        clearcoatAmount: carModelRoot.clearcoat
        clearcoatRoughnessAmount: 0.06
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
            PrincipledMaterial {
        id: meshesuntitled2doorrfmirror1Mtl_material
        objectName: "Meshesuntitled2doorrfmirror1Mtl"
        baseColor: "#1A2026"
        metalness: 0.95
        roughness: 0.04
        clearcoatAmount: 1.0
        clearcoatRoughnessAmount: 0.02
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: meshesuntitled41Mtl_material
        objectName: "Meshesuntitled41Mtl"
        baseColor: "#ff080808"
        metalnessMap: _33_texture
        roughnessMap: _33_texture
        metalness: 0.05000000074505806
        roughness: 0.23323170840740204
        normalMap: _34_texture
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
        id: apex_Backing_Mtl_material
        objectName: "Apex_Backing_Mtl"
        baseColor: "#15181b"
        metalness: 0.9
        roughness: 0.1
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
        id: meshesuntitled5doorlbint401Mtl_material
        objectName: "Meshesuntitled5doorlbint401Mtl"
        baseColor: "#faffffff"
        baseColorMap: _37_texture
        metalness: 0.05000000074505806
        roughness: 1
        emissiveMap: _38_texture
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Blend
    }
    PrincipledMaterial {
        id: meshesuntitled3doorrbint381Mtl_material
        objectName: "Meshesuntitled3doorrbint381Mtl"
        baseColorMap: _32_texture
        metalness: 0.05000000074505806
        roughness: 1
        emissiveMap: _32_texture
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
        id: apex_Emblem_Mtl_material
        objectName: "Apex_Emblem_Mtl"
        baseColorMap: textures_apex_emblem_diffuse_png_texture
        metalness: 0.95
        roughness: 0.15
        emissiveMap: textures_apex_emblem_emissive_png_texture
        emissiveFactor: carModelRoot.lightsOn ? Qt.vector3d(2.5, 2.5, 2.5) : Qt.vector3d(0.8, 0.8, 0.8)
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Blend
    }
        PrincipledMaterial {
        id: meshesuntitled1bodyfrontgrillechorme0011Mtl_material
        objectName: "Meshesuntitled1bodyfrontgrillechorme0011Mtl"
        baseColor: "#E2E8F0"
        metalness: 0.92
        roughness: 0.06
        clearcoatAmount: 0.8
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: meshesuntitled5doorlfint401Mtl_material
        objectName: "Meshesuntitled5doorlfint401Mtl"
        baseColor: "#faffffff"
        baseColorMap: _39_texture
        metalness: 0.05000000074505806
        roughness: 1
        emissiveMap: _40_texture
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Blend
    }
    PrincipledMaterial {
        id: meshesuntitled3doorrbint371Mtl_material
        objectName: "Meshesuntitled3doorrbint371Mtl"
        baseColorMap: _31_texture
        metalness: 0.05000000074505806
        roughness: 1
        emissiveMap: _31_texture
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: meshesuntitled3doorlbint381Mtl_material
        objectName: "Meshesuntitled3doorlbint381Mtl"
        baseColorMap: _30_texture
        metalness: 0.05000000074505806
        roughness: 1
        emissiveMap: _30_texture
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
        id: meshesuntitled3doorlbint371Mtl_material
        objectName: "Meshesuntitled3doorlbint371Mtl"
        baseColorMap: _29_texture
        metalness: 0.05000000074505806
        roughness: 1
        emissiveMap: _29_texture
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: meshesuntitled5doorrbint401Mtl_material
        objectName: "Meshesuntitled5doorrbint401Mtl"
        baseColor: "#faffffff"
        baseColorMap: _41_texture
        metalness: 0.05000000074505806
        roughness: 1
        emissiveMap: _42_texture
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Blend
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
        id: meshesuntitled3carbodyint121Mtl_material
        objectName: "Meshesuntitled3carbodyint121Mtl"
        baseColor: "#ff080808"
        metalnessMap: _27_texture
        roughnessMap: _27_texture
        metalness: 0.05000000074505806
        roughness: 0.999910831451416
        normalMap: _28_texture
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: meshesuntitled5doorrfint401Mtl_material
        objectName: "Meshesuntitled5doorrfint401Mtl"
        baseColor: "#faffffff"
        baseColorMap: _43_texture
        metalness: 0.05000000074505806
        roughness: 1
        emissiveMap: _44_texture
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Blend
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
        id: meshesuntitled1trunkbodyplate1Mtl_material
        objectName: "Meshesuntitled1trunkbodyplate1Mtl"
        baseColorMap: Texture { generateMipmaps: true; mipFilter: Texture.Linear; source: "maps/textureData81.png" }
        metalness: 0.05
        roughness: 0.3125
        emissiveMap: Texture { generateMipmaps: true; mipFilter: Texture.Linear; source: "maps/textureData81.png" }
        emissiveFactor: carModelRoot.lightsOn ? Qt.vector3d(1, 1, 1) : Qt.vector3d(0, 0, 0)
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
        id: meshesuntitled71Mtl_material
        objectName: "Meshesuntitled71Mtl"
        baseColor: "#ff080808"
        metalnessMap: _45_texture
        roughnessMap: _45_texture
        metalness: 0.05000000074505806
        roughness: 0.2393292635679245
        normalMap: _46_texture
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: meshesuntitled3carbodyleather20021Mtl_material
        objectName: "Meshesuntitled3carbodyleather20021Mtl"
        baseColor: "#ff080808"
        metalnessMap: _9_texture
        roughnessMap: _9_texture
        metalness: 0.05000000074505806
        roughness: 0.33689025044441223
        normalMap: _10_texture
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: meshesuntitled2doorrfint421Mtl_material
        objectName: "Meshesuntitled2doorrfint421Mtl"
        baseColorMap: _25_texture
        metalness: 0.05000000074505806
        roughness: 1
        emissiveMap: _26_texture
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Blend
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
        id: meshesuntitled8doorlfint371Mtl_material
        objectName: "Meshesuntitled8doorlfint371Mtl"
        baseColorMap: _47_texture
        metalness: 0.05000000074505806
        roughness: 1
        emissiveMap: _47_texture
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: meshesuntitled2doorrfint381Mtl_material
        objectName: "Meshesuntitled2doorrfint381Mtl"
        baseColorMap: _24_texture
        metalness: 0.05000000074505806
        roughness: 1
        emissiveMap: _24_texture
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: meshesuntitled1bodyfrontgrilleint1Mtl_material
        objectName: "Meshesuntitled1bodyfrontgrilleint1Mtl"
        baseColorMap: _11_texture
        metalness: 0.05000000074505806
        roughness: 1
        emissiveMap: _12_texture
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
        id: meshesuntitledcarbodyleather51Mtl_material
        objectName: "Meshesuntitledcarbodyleather51Mtl"
        baseColor: "#ff080808"
        metalnessMap: _48_texture
        roughnessMap: _48_texture
        metalness: 0.05000000074505806
        roughness: 0.34908536076545715
        normalMap: _10_texture
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: meshesuntitled3carbodyint131Mtl_material
        objectName: "Meshesuntitled3carbodyint131Mtl"
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
        emissiveFactor: carModelRoot.lightsOn ? Qt.vector3d(1, 1, 1) : Qt.vector3d(0, 0, 0)
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
            PrincipledMaterial {
        id: meshesuntitled2wheelflowheeltire1Mtl_material
        objectName: "meshesuntitled2wheelflowheeltire1Mtl"
        baseColor: "#050505"
        baseColorMap: Texture { generateMipmaps: true; mipFilter: Texture.Linear; source: "maps/textureData91.png" }
        metalness: 0.05
        roughness: 0.90
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: meshesuntitled2doorlfint381Mtl_material
        objectName: "Meshesuntitled2doorlfint381Mtl"
        baseColorMap: _21_texture
        metalness: 0.05000000074505806
        roughness: 1
        emissiveMap: _21_texture
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: meshesuntitled1trunkbodyint1Mtl_material
        objectName: "Meshesuntitled1trunkbodyint1Mtl"
        baseColorMap: _13_texture
        metalness: 0.05000000074505806
        roughness: 1
        emissiveMap: _14_texture
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Blend
    }
        PrincipledMaterial {
        id: meshesuntitled1wheelfrowheeltire1Mtl_material
        objectName: "meshesuntitled1wheelfrowheeltire1Mtl"
        baseColor: "#050505"
        baseColorMap: Texture { generateMipmaps: true; mipFilter: Texture.Linear; source: "maps/textureData91.png" }
        metalness: 0.05
        roughness: 0.90
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: meshesuntitled2doorlfint421Mtl_material
        objectName: "Meshesuntitled2doorlfint421Mtl"
        baseColorMap: _19_texture
        metalness: 0.05000000074505806
        roughness: 1
        emissiveMap: _20_texture
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Blend
    }
    PrincipledMaterial {
        id: meshesuntitled2carbodyint471Mtl_material
        objectName: "Meshesuntitled2carbodyint471Mtl"
        baseColorMap: _17_texture
        metalness: 0.05000000074505806
        roughness: 1
        emissiveMap: _18_texture
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Blend
    }
        PrincipledMaterial {
        id: meshesuntitled3wheelblowheeltire1Mtl_material
        objectName: "meshesuntitled3wheelblowheeltire1Mtl"
        baseColor: "#050505"
        baseColorMap: Texture { generateMipmaps: true; mipFilter: Texture.Linear; source: "maps/textureData91.png" }
        metalness: 0.05
        roughness: 0.90
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: meshesuntitled2carbodyint171Mtl_material
        objectName: "Meshesuntitled2carbodyint171Mtl"
        baseColorMap: _15_texture
        metalness: 0.05000000074505806
        roughness: 1
        emissiveMap: _15_texture
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: meshesuntitled2carbodyint271Mtl_material
        objectName: "Meshesuntitled2carbodyint271Mtl"
        baseColorMap: _16_texture
        metalness: 0.05000000074505806
        emissiveMap: _16_texture
        emissiveFactor: carModelRoot.lightsOn ? Qt.vector3d(1, 1, 1) : Qt.vector3d(0, 0, 0)
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
        PrincipledMaterial {
        id: meshesuntitled1wheelbrowheeltire1Mtl_material
        objectName: "meshesuntitled1wheelbrowheeltire1Mtl"
        baseColor: "#050505"
        baseColorMap: Texture { generateMipmaps: true; mipFilter: Texture.Linear; source: "maps/textureData91.png" }
        metalness: 0.05
        roughness: 0.90
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

                Model {
                    id: apex_Emblem
                    objectName: "Apex_Emblem"
                    position: Qt.vector3d(-19.0592, -74.241, 0)
                    rotation: Qt.quaternion(0.707107, 0.707107, 0, 0)
                    scale: Qt.vector3d(1, 1, 1)
                    source: "meshes/apex_Emblem_mesh.mesh"
                    materials: [
                        apex_Emblem_Mtl_material
                    ]
                }
                Model {
                    id: apex_Emblem_Backing
                    objectName: "Apex_Emblem_Backing"
                    position: Qt.vector3d(-19.0592, -74.241, 0)
                    rotation: Qt.quaternion(0.707107, 0.707107, 0, 0)
                    scale: Qt.vector3d(1, 1, 1)
                    source: "meshes/apex_Emblem_Backing_mesh.mesh"
                    materials: [
                        apex_Backing_Mtl_material
                    ]
                }
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
                        meshesuntitled2carbodyfrostedplastic61Mtl_material,
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
                    id: exterior_Glass
                    objectName: "Exterior_Glass"
                    source: "meshes/exterior_Glass_mesh.mesh"
                    materials: [
                        meshesuntitled1bodyglassglass1Mtl_material,
                        meshesuntitled2bodyskyglassglassskylight1Mtl_material
                    ]
                }
                Model {
                    id: interior_Cabin
                    objectName: "Interior_Cabin"
                    source: "meshes/interior_Cabin_mesh.mesh"
                    materials: [
                        meshesuntitled3carbodyleather20021Mtl_material,
                        meshesuntitled1bodyfrontgrilleint1Mtl_material,
                        meshesuntitled1trunkbodyint1Mtl_material,
                        meshesuntitled2carbodyint171Mtl_material,
                        meshesuntitled2carbodyint271Mtl_material,
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
                        meshesuntitledcarbodyleather51Mtl_material
                    ]
                }
                Model {
                    id: wheel_FL
                    objectName: "Wheel_FL"
                    source: "meshes/object_19_mesh.mesh"
                    materials: [
                        meshesuntitled2wheelflowheeltire1Mtl_material
                    ]
                }
                Model {
                    id: wheel_FR
                    objectName: "Wheel_FR"
                    source: "meshes/object_7_mesh.mesh"
                    materials: [
                        meshesuntitled1wheelfrowheeltire1Mtl_material
                    ]
                }
                Model {
                    id: wheel_RL
                    objectName: "Wheel_RL"
                    source: "meshes/object_27_mesh.mesh"
                    materials: [
                        meshesuntitled3wheelblowheeltire1Mtl_material
                    ]
                }
                Model {
                    id: wheel_RR
                    objectName: "Wheel_RR"
                    source: "meshes/object_8_mesh.mesh"
                    materials: [
                        meshesuntitled1wheelbrowheeltire1Mtl_material
                    ]
                }
            }
        }
    }

    // Animations:
}
