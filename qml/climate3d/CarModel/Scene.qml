import QtQuick
import QtQuick3D

Node {
    id: root

    property color paintColor: "#F5F7FA"
    property real metalness: 0.08
    property real roughness: 0.16
    property real clearcoat: 0.95
    property bool lightsOn: true
    property real wheelAngle: 0.0
    property bool roofVisible: true

    // Four Tire Objects (object 21: FL, object 9: FR, object 29: RL, object 10: RR)
    readonly property alias tireFL: object_21
    readonly property alias tireFR: object_9
    readonly property alias tireRL: object_29
    readonly property alias tireRR: object_10


    // Resources
    Texture {
        id: textures_apex_emblem_diffuse_png_texture
        objectName: "textures/apex_emblem_diffuse.png"
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: "maps/apex_emblem_diffuse.png"
    }
    Texture {
        id: textures_apex_emblem_emissive_png_texture
        objectName: "textures/apex_emblem_emissive.png"
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: "maps/apex_emblem_emissive.png"
    }
    Texture {
        id: textures_Meshesuntitled2doorlfint381Mtl_baseColor_png_texture
        objectName: "textures/Meshesuntitled2doorlfint381Mtl_baseColor.png"
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: "maps/Meshesuntitled2doorlfint381Mtl_baseColor.png"
    }
    Texture {
        id: textures_Meshesuntitled41Mtl_normal_png_texture
        objectName: "textures/Meshesuntitled41Mtl_normal.png"
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: "maps/Meshesuntitled41Mtl_normal.png"
    }
    Texture {
        id: textures_Meshesuntitled101Mtl_metallicRoughness_png_texture
        objectName: "textures/Meshesuntitled101Mtl_metallicRoughness.png"
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: "maps/Meshesuntitled101Mtl_metallicRoughness.png"
    }
    Texture {
        id: textures_Meshesuntitled101Mtl_normal_png_texture
        objectName: "textures/Meshesuntitled101Mtl_normal.png"
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: "maps/Meshesuntitled101Mtl_normal.png"
    }
    Texture {
        id: textures_Meshesuntitled3carbodyleather20021Mtl_normal_png_texture
        objectName: "textures/Meshesuntitled3carbodyleather20021Mtl_normal.png"
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: "maps/Meshesuntitled3carbodyleather20021Mtl_normal.png"
    }
    Texture {
        id: textures_Meshesuntitled3carbodyleather20021Mtl_metallicRoughness_png_texture
        objectName: "textures/Meshesuntitled3carbodyleather20021Mtl_metallicRoughness.png"
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: "maps/Meshesuntitled3carbodyleather20021Mtl_metallicRoughness.png"
    }
    Texture {
        id: textures_Meshesuntitled111Mtl_emissive_png_texture
        objectName: "textures/Meshesuntitled111Mtl_emissive.png"
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: "maps/Meshesuntitled111Mtl_emissive.png"
    }
    Texture {
        id: textures_Meshesuntitled8doorlfint371Mtl_baseColor_png_texture
        objectName: "textures/Meshesuntitled8doorlfint371Mtl_baseColor.png"
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: "maps/Meshesuntitled8doorlfint371Mtl_baseColor.png"
    }
    Texture {
        id: textures_Meshesuntitled71Mtl_normal_png_texture
        objectName: "textures/Meshesuntitled71Mtl_normal.png"
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: "maps/Meshesuntitled71Mtl_normal.png"
    }
    Texture {
        id: textures_Meshesuntitled131Mtl_baseColor_png_texture
        objectName: "textures/Meshesuntitled131Mtl_baseColor.png"
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: "maps/Meshesuntitled131Mtl_baseColor.png"
    }
    Texture {
        id: textures_Meshesuntitled71Mtl_metallicRoughness_png_texture
        objectName: "textures/Meshesuntitled71Mtl_metallicRoughness.png"
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: "maps/Meshesuntitled71Mtl_metallicRoughness.png"
    }
    Texture {
        id: textures_Meshesuntitled5doorrfint401Mtl_emissive_png_texture
        objectName: "textures/Meshesuntitled5doorrfint401Mtl_emissive.png"
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: "maps/Meshesuntitled5doorrfint401Mtl_emissive.png"
    }
    Texture {
        id: textures_Meshesuntitled1bodyfrontgrilleint1Mtl_baseColor_png_texture
        objectName: "textures/Meshesuntitled1bodyfrontgrilleint1Mtl_baseColor.png"
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: "maps/Meshesuntitled1bodyfrontgrilleint1Mtl_baseColor.png"
    }
    Texture {
        id: textures_Meshesuntitled1bodyfrontgrilleint1Mtl_emissive_png_texture
        objectName: "textures/Meshesuntitled1bodyfrontgrilleint1Mtl_emissive.png"
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: "maps/Meshesuntitled1bodyfrontgrilleint1Mtl_emissive.png"
    }
    Texture {
        id: textures_Meshesuntitled5doorrfint401Mtl_baseColor_png_texture
        objectName: "textures/Meshesuntitled5doorrfint401Mtl_baseColor.png"
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: "maps/Meshesuntitled5doorrfint401Mtl_baseColor.png"
    }
    Texture {
        id: textures_Meshesuntitled5doorrbint401Mtl_emissive_png_texture
        objectName: "textures/Meshesuntitled5doorrbint401Mtl_emissive.png"
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: "maps/Meshesuntitled5doorrbint401Mtl_emissive.png"
    }
    Texture {
        id: textures_Meshesuntitled1trunkbodyint1Mtl_baseColor_png_texture
        objectName: "textures/Meshesuntitled1trunkbodyint1Mtl_baseColor.png"
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: "maps/Meshesuntitled1trunkbodyint1Mtl_baseColor.png"
    }
    Texture {
        id: textures_Meshesuntitled1trunkbodyint1Mtl_emissive_png_texture
        objectName: "textures/Meshesuntitled1trunkbodyint1Mtl_emissive.png"
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: "maps/Meshesuntitled1trunkbodyint1Mtl_emissive.png"
    }
    Texture {
        id: textures_Meshesuntitled5doorrbint401Mtl_baseColor_png_texture
        objectName: "textures/Meshesuntitled5doorrbint401Mtl_baseColor.png"
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: "maps/Meshesuntitled5doorrbint401Mtl_baseColor.png"
    }
    Texture {
        id: textures_Meshesuntitled5doorlfint401Mtl_emissive_png_texture
        objectName: "textures/Meshesuntitled5doorlfint401Mtl_emissive.png"
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: "maps/Meshesuntitled5doorlfint401Mtl_emissive.png"
    }
    Texture {
        id: textures_Meshesuntitled5doorlfint401Mtl_baseColor_png_texture
        objectName: "textures/Meshesuntitled5doorlfint401Mtl_baseColor.png"
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: "maps/Meshesuntitled5doorlfint401Mtl_baseColor.png"
    }
    Texture {
        id: textures_Meshesuntitled5doorlbint401Mtl_emissive_png_texture
        objectName: "textures/Meshesuntitled5doorlbint401Mtl_emissive.png"
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: "maps/Meshesuntitled5doorlbint401Mtl_emissive.png"
    }
    Texture {
        id: textures_Meshesuntitled1trunkbodyplate1Mtl_emissive_png_texture
        objectName: "textures/Meshesuntitled1trunkbodyplate1Mtl_emissive.png"
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: "maps/Meshesuntitled1trunkbodyplate1Mtl_emissive.png"
    }
    Texture {
        id: textures_Meshesuntitled5doorlbint401Mtl_baseColor_png_texture
        objectName: "textures/Meshesuntitled5doorlbint401Mtl_baseColor.png"
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: "maps/Meshesuntitled5doorlbint401Mtl_baseColor.png"
    }
    Texture {
        id: textures_Meshesuntitled5carbodyint151Mtl_emissive_png_texture
        objectName: "textures/Meshesuntitled5carbodyint151Mtl_emissive.png"
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: "maps/Meshesuntitled5carbodyint151Mtl_emissive.png"
    }
    Texture {
        id: textures_Meshesuntitled1wheelfrowheeltire1Mtl_baseColor_png_texture
        objectName: "textures/Meshesuntitled1wheelfrowheeltire1Mtl_baseColor.png"
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: "maps/Meshesuntitled1wheelfrowheeltire1Mtl_baseColor.png"
    }
    Texture {
        id: textures_Meshesuntitled5carbodyint151Mtl_baseColor_png_texture
        objectName: "textures/Meshesuntitled5carbodyint151Mtl_baseColor.png"
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: "maps/Meshesuntitled5carbodyint151Mtl_baseColor.png"
    }
    Texture {
        id: textures_Meshesuntitledcarbodyleather51Mtl_metallicRoughness_png_texture
        objectName: "textures/Meshesuntitledcarbodyleather51Mtl_metallicRoughness.png"
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: "maps/Meshesuntitledcarbodyleather51Mtl_metallicRoughness.png"
    }
    Texture {
        id: textures_Meshesuntitled1wheelbrowheeltire1Mtl_baseColor_png_texture
        objectName: "textures/Meshesuntitled1wheelbrowheeltire1Mtl_baseColor.png"
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: "maps/Meshesuntitled1wheelbrowheeltire1Mtl_baseColor.png"
    }
    Texture {
        id: textures_Meshesuntitled41Mtl_metallicRoughness_png_texture
        objectName: "textures/Meshesuntitled41Mtl_metallicRoughness.png"
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: "maps/Meshesuntitled41Mtl_metallicRoughness.png"
    }
    Texture {
        id: textures_Meshesuntitled3wheelblowheeltire1Mtl_baseColor_png_texture
        objectName: "textures/Meshesuntitled3wheelblowheeltire1Mtl_baseColor.png"
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: "maps/Meshesuntitled3wheelblowheeltire1Mtl_baseColor.png"
    }
    Texture {
        id: textures_Meshesuntitled3doorrbint381Mtl_baseColor_png_texture
        objectName: "textures/Meshesuntitled3doorrbint381Mtl_baseColor.png"
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: "maps/Meshesuntitled3doorrbint381Mtl_baseColor.png"
    }
    Texture {
        id: textures_Meshesuntitled3doorrbint371Mtl_baseColor_png_texture
        objectName: "textures/Meshesuntitled3doorrbint371Mtl_baseColor.png"
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: "maps/Meshesuntitled3doorrbint371Mtl_baseColor.png"
    }
    Texture {
        id: textures_Meshesuntitled2carbodyfrostedplastic50021Mtl_metallicRoughness_png_texture
        objectName: "textures/Meshesuntitled2carbodyfrostedplastic50021Mtl_metallicRoughness.png"
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: "maps/Meshesuntitled2carbodyfrostedplastic50021Mtl_metallicRoughness.png"
    }
    Texture {
        id: textures_Meshesuntitled2carbodyfrostedplastic50021Mtl_normal_png_texture
        objectName: "textures/Meshesuntitled2carbodyfrostedplastic50021Mtl_normal.png"
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: "maps/Meshesuntitled2carbodyfrostedplastic50021Mtl_normal.png"
    }
    Texture {
        id: textures_Meshesuntitled3doorlbint381Mtl_baseColor_png_texture
        objectName: "textures/Meshesuntitled3doorlbint381Mtl_baseColor.png"
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: "maps/Meshesuntitled3doorlbint381Mtl_baseColor.png"
    }
    Texture {
        id: textures_Meshesuntitled3doorlbint371Mtl_baseColor_png_texture
        objectName: "textures/Meshesuntitled3doorlbint371Mtl_baseColor.png"
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: "maps/Meshesuntitled3doorlbint371Mtl_baseColor.png"
    }
    Texture {
        id: textures_Meshesuntitled2carbodyint171Mtl_baseColor_png_texture
        objectName: "textures/Meshesuntitled2carbodyint171Mtl_baseColor.png"
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: "maps/Meshesuntitled2carbodyint171Mtl_baseColor.png"
    }
    Texture {
        id: textures_Meshesuntitled3carbodyint121Mtl_normal_png_texture
        objectName: "textures/Meshesuntitled3carbodyint121Mtl_normal.png"
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: "maps/Meshesuntitled3carbodyint121Mtl_normal.png"
    }
    Texture {
        id: textures_Meshesuntitled3carbodyint121Mtl_metallicRoughness_png_texture
        objectName: "textures/Meshesuntitled3carbodyint121Mtl_metallicRoughness.png"
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: "maps/Meshesuntitled3carbodyint121Mtl_metallicRoughness.png"
    }
    Texture {
        id: textures_Meshesuntitled2carbodyint271Mtl_baseColor_png_texture
        objectName: "textures/Meshesuntitled2carbodyint271Mtl_baseColor.png"
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: "maps/Meshesuntitled2carbodyint271Mtl_baseColor.png"
    }
    Texture {
        id: textures_Meshesuntitled2wheelflowheeltire1Mtl_baseColor_png_texture
        objectName: "textures/Meshesuntitled2wheelflowheeltire1Mtl_baseColor.png"
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: "maps/Meshesuntitled2wheelflowheeltire1Mtl_baseColor.png"
    }
    Texture {
        id: textures_Meshesuntitled2doorrfint421Mtl_emissive_png_texture
        objectName: "textures/Meshesuntitled2doorrfint421Mtl_emissive.png"
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: "maps/Meshesuntitled2doorrfint421Mtl_emissive.png"
    }
    Texture {
        id: textures_Meshesuntitled2carbodyint471Mtl_baseColor_png_texture
        objectName: "textures/Meshesuntitled2carbodyint471Mtl_baseColor.png"
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: "maps/Meshesuntitled2carbodyint471Mtl_baseColor.png"
    }
    Texture {
        id: textures_Meshesuntitled2carbodyint471Mtl_emissive_png_texture
        objectName: "textures/Meshesuntitled2carbodyint471Mtl_emissive.png"
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: "maps/Meshesuntitled2carbodyint471Mtl_emissive.png"
    }
    Texture {
        id: textures_Meshesuntitled2doorrfint421Mtl_baseColor_png_texture
        objectName: "textures/Meshesuntitled2doorrfint421Mtl_baseColor.png"
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: "maps/Meshesuntitled2doorrfint421Mtl_baseColor.png"
    }
    Texture {
        id: textures_Meshesuntitled2doorrfint381Mtl_baseColor_png_texture
        objectName: "textures/Meshesuntitled2doorrfint381Mtl_baseColor.png"
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: "maps/Meshesuntitled2doorrfint381Mtl_baseColor.png"
    }
    Texture {
        id: textures_Meshesuntitled2doorlfint421Mtl_baseColor_png_texture
        objectName: "textures/Meshesuntitled2doorlfint421Mtl_baseColor.png"
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: "maps/Meshesuntitled2doorlfint421Mtl_baseColor.png"
    }
    Texture {
        id: textures_Meshesuntitled2doorlfint421Mtl_emissive_png_texture
        objectName: "textures/Meshesuntitled2doorlfint421Mtl_emissive.png"
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: "maps/Meshesuntitled2doorlfint421Mtl_emissive.png"
    }
    Texture {
        id: textures_Meshesuntitled3carbodyint131Mtl_emissive_png_texture
        objectName: "textures/Meshesuntitled3carbodyint131Mtl_emissive.png"
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: "maps/Meshesuntitled3carbodyint131Mtl_emissive.png"
    }
    Texture {
        id: textures_Meshesuntitled3carbodyint131Mtl_baseColor_png_texture
        objectName: "textures/Meshesuntitled3carbodyint131Mtl_baseColor.png"
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: "maps/Meshesuntitled3carbodyint131Mtl_baseColor.png"
    }
    PrincipledMaterial {
        id: meshesuntitled3carbodyint131Mtl_material
        objectName: "Meshesuntitled3carbodyint131Mtl"
        baseColorMap: textures_Meshesuntitled3carbodyint131Mtl_baseColor_png_texture
        metalness: 0.05000000074505806
        roughness: 1
        emissiveMap: textures_Meshesuntitled3carbodyint131Mtl_emissive_png_texture
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Blend
    }
    PrincipledMaterial {
        id: meshesuntitled2doorlfint381Mtl_material
        objectName: "Meshesuntitled2doorlfint381Mtl"
        baseColorMap: textures_Meshesuntitled2doorlfint381Mtl_baseColor_png_texture
        metalness: 0.05000000074505806
        roughness: 1
        emissiveMap: textures_Meshesuntitled2doorlfint381Mtl_baseColor_png_texture
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: meshesuntitled2doorrfint381Mtl_material
        objectName: "Meshesuntitled2doorrfint381Mtl"
        baseColorMap: textures_Meshesuntitled2doorrfint381Mtl_baseColor_png_texture
        metalness: 0.05000000074505806
        roughness: 1
        emissiveMap: textures_Meshesuntitled2doorrfint381Mtl_baseColor_png_texture
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: meshesuntitled2doorlfint421Mtl_material
        objectName: "Meshesuntitled2doorlfint421Mtl"
        baseColorMap: textures_Meshesuntitled2doorlfint421Mtl_baseColor_png_texture
        metalness: 0.05000000074505806
        roughness: 1
        emissiveMap: textures_Meshesuntitled2doorlfint421Mtl_emissive_png_texture
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Blend
    }
    PrincipledMaterial {
        id: meshesuntitled2doorrfint421Mtl_material
        objectName: "Meshesuntitled2doorrfint421Mtl"
        baseColorMap: textures_Meshesuntitled2doorrfint421Mtl_baseColor_png_texture
        metalness: 0.05000000074505806
        roughness: 1
        emissiveMap: textures_Meshesuntitled2doorrfint421Mtl_emissive_png_texture
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Blend
    }
    PrincipledMaterial {
        id: meshesuntitled2carbodyint471Mtl_material
        objectName: "Meshesuntitled2carbodyint471Mtl"
        baseColorMap: textures_Meshesuntitled2carbodyint471Mtl_baseColor_png_texture
        metalness: 0.05000000074505806
        roughness: 1
        emissiveMap: textures_Meshesuntitled2carbodyint471Mtl_emissive_png_texture
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Blend
    }
    PrincipledMaterial {
        id: meshesuntitled2wheelflowheeltire1Mtl_material
        objectName: "Meshesuntitled2wheelflowheeltire1Mtl"
        baseColorMap: textures_Meshesuntitled2wheelflowheeltire1Mtl_baseColor_png_texture
        metalness: 0.04
        roughness: 0.65
        clearcoatAmount: 0.06
        clearcoatRoughnessAmount: 0.40
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: meshesuntitled3carbodyfrostedplastic21Mtl_material
        objectName: "Meshesuntitled3carbodyfrostedplastic21Mtl"
        baseColor: "#ffcecece"
        metalnessMap: textures_Meshesuntitled2carbodyfrostedplastic50021Mtl_metallicRoughness_png_texture
        roughnessMap: textures_Meshesuntitled2carbodyfrostedplastic50021Mtl_metallicRoughness_png_texture
        metalness: 0.05000000074505806
        roughness: 0.9986796379089355
        normalMap: textures_Meshesuntitled2carbodyfrostedplastic50021Mtl_normal_png_texture
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: meshesuntitled3carbodyint121Mtl_material
        objectName: "Meshesuntitled3carbodyint121Mtl"
        baseColor: "#ff080808"
        metalnessMap: textures_Meshesuntitled3carbodyint121Mtl_metallicRoughness_png_texture
        roughnessMap: textures_Meshesuntitled3carbodyint121Mtl_metallicRoughness_png_texture
        metalness: 0.05000000074505806
        roughness: 0.999910831451416
        normalMap: textures_Meshesuntitled3carbodyint121Mtl_normal_png_texture
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: meshesuntitled2carbodyint271Mtl_material
        objectName: "Meshesuntitled2carbodyint271Mtl"
        baseColor: "#050608"
        roughness: 0.08
        metalness: 0.12
        specularAmount: 0.98
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: meshesuntitled3doorlbint371Mtl_material
        objectName: "Meshesuntitled3doorlbint371Mtl"
        baseColorMap: textures_Meshesuntitled3doorlbint371Mtl_baseColor_png_texture
        metalness: 0.05000000074505806
        roughness: 1
        emissiveMap: textures_Meshesuntitled3doorlbint371Mtl_baseColor_png_texture
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: meshesuntitled2carbodyint171Mtl_material
        objectName: "Meshesuntitled2carbodyint171Mtl"
        baseColorMap: textures_Meshesuntitled2carbodyint171Mtl_baseColor_png_texture
        metalness: 0.05000000074505806
        roughness: 1
        emissiveMap: textures_Meshesuntitled2carbodyint171Mtl_baseColor_png_texture
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
        id: meshesuntitled3doorlbint381Mtl_material
        objectName: "Meshesuntitled3doorlbint381Mtl"
        baseColorMap: textures_Meshesuntitled3doorlbint381Mtl_baseColor_png_texture
        metalness: 0.05000000074505806
        roughness: 1
        emissiveMap: textures_Meshesuntitled3doorlbint381Mtl_baseColor_png_texture
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: meshesuntitled3doorrbint371Mtl_material
        objectName: "Meshesuntitled3doorrbint371Mtl"
        baseColorMap: textures_Meshesuntitled3doorrbint371Mtl_baseColor_png_texture
        metalness: 0.05000000074505806
        roughness: 1
        emissiveMap: textures_Meshesuntitled3doorrbint371Mtl_baseColor_png_texture
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: meshesuntitled2carbodyfrostedplastic61Mtl_material
        objectName: "Meshesuntitled2carbodyfrostedplastic61Mtl"
        baseColor: "#ffcecece"
        metalnessMap: textures_Meshesuntitled2carbodyfrostedplastic50021Mtl_metallicRoughness_png_texture
        roughnessMap: textures_Meshesuntitled2carbodyfrostedplastic50021Mtl_metallicRoughness_png_texture
        metalness: 0.05000000074505806
        roughness: 0.9786701798439026
        normalMap: textures_Meshesuntitled2carbodyfrostedplastic50021Mtl_normal_png_texture
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: meshesuntitled3doorrbint381Mtl_material
        objectName: "Meshesuntitled3doorrbint381Mtl"
        baseColorMap: textures_Meshesuntitled3doorrbint381Mtl_baseColor_png_texture
        metalness: 0.05000000074505806
        roughness: 1
        emissiveMap: textures_Meshesuntitled3doorrbint381Mtl_baseColor_png_texture
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: meshesuntitled3wheelblowheeltire1Mtl_material
        objectName: "Meshesuntitled3wheelblowheeltire1Mtl"
        baseColorMap: textures_Meshesuntitled3wheelblowheeltire1Mtl_baseColor_png_texture
        metalness: 0.28
        roughness: 0.35
        clearcoatAmount: 0.45
        clearcoatRoughnessAmount: 0.12
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
        id: meshesuntitled41Mtl_material
        objectName: "Meshesuntitled41Mtl"
        baseColor: "#ff080808"
        metalnessMap: textures_Meshesuntitled41Mtl_metallicRoughness_png_texture
        roughnessMap: textures_Meshesuntitled41Mtl_metallicRoughness_png_texture
        metalness: 0.05000000074505806
        roughness: 0.23323170840740204
        normalMap: textures_Meshesuntitled41Mtl_normal_png_texture
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: meshesuntitled1wheelbrowheeltire1Mtl_material
        objectName: "Meshesuntitled1wheelbrowheeltire1Mtl"
        baseColorMap: textures_Meshesuntitled1wheelbrowheeltire1Mtl_baseColor_png_texture
        metalness: 0.28
        roughness: 0.35
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: meshesuntitled5carbodyint151Mtl_material
        objectName: "Meshesuntitled5carbodyint151Mtl"
        baseColor: "#faffffff"
        baseColorMap: textures_Meshesuntitled5carbodyint151Mtl_baseColor_png_texture
        metalness: 0.05000000074505806
        roughness: 1
        emissiveMap: textures_Meshesuntitled5carbodyint151Mtl_emissive_png_texture
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Blend
    }
    PrincipledMaterial {
        id: meshesuntitled1wheelfrowheeltire1Mtl_material
        objectName: "Meshesuntitled1wheelfrowheeltire1Mtl"
        baseColorMap: textures_Meshesuntitled1wheelfrowheeltire1Mtl_baseColor_png_texture
        metalness: 0.28
        roughness: 0.35
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: meshesuntitled5doorlbint401Mtl_material
        objectName: "Meshesuntitled5doorlbint401Mtl"
        baseColor: "#faffffff"
        baseColorMap: textures_Meshesuntitled5doorlbint401Mtl_baseColor_png_texture
        metalness: 0.05000000074505806
        roughness: 1
        emissiveMap: textures_Meshesuntitled5doorlbint401Mtl_emissive_png_texture
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Blend
    }
    PrincipledMaterial {
        id: meshesuntitled1trunkbodyplate1Mtl_material
        objectName: "Meshesuntitled1trunkbodyplate1Mtl"
        baseColor: "#ff180000"
        metalness: 0.1
        roughness: 0.25
        emissiveMap: textures_Meshesuntitled1trunkbodyplate1Mtl_emissive_png_texture
        emissiveFactor: root.lightsOn ? Qt.vector3d(3.5, 3.5, 3.5) : Qt.vector3d(0, 0, 0)
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: meshesuntitled5doorlfint401Mtl_material
        objectName: "Meshesuntitled5doorlfint401Mtl"
        baseColor: "#faffffff"
        baseColorMap: textures_Meshesuntitled5doorlfint401Mtl_baseColor_png_texture
        metalness: 0.05000000074505806
        roughness: 1
        emissiveMap: textures_Meshesuntitled5doorlfint401Mtl_emissive_png_texture
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Blend
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
        id: meshesuntitled5doorrbint401Mtl_material
        objectName: "Meshesuntitled5doorrbint401Mtl"
        baseColor: "#faffffff"
        baseColorMap: textures_Meshesuntitled5doorrbint401Mtl_baseColor_png_texture
        metalness: 0.05000000074505806
        roughness: 1
        emissiveMap: textures_Meshesuntitled5doorrbint401Mtl_emissive_png_texture
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Blend
    }
    PrincipledMaterial {
        id: meshesuntitled1trunkbodyint1Mtl_material
        objectName: "Meshesuntitled1trunkbodyint1Mtl"
        baseColorMap: textures_Meshesuntitled1trunkbodyint1Mtl_baseColor_png_texture
        metalness: 0.05000000074505806
        roughness: 1
        emissiveMap: textures_Meshesuntitled1trunkbodyint1Mtl_emissive_png_texture
        emissiveFactor: root.lightsOn ? Qt.vector3d(3.5, 3.5, 3.5) : Qt.vector3d(0, 0, 0)
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Blend
    }
    PrincipledMaterial {
        id: meshesuntitled5doorrfint401Mtl_material
        objectName: "Meshesuntitled5doorrfint401Mtl"
        baseColor: "#faffffff"
        baseColorMap: textures_Meshesuntitled5doorrfint401Mtl_baseColor_png_texture
        metalness: 0.05000000074505806
        roughness: 1
        emissiveMap: textures_Meshesuntitled5doorrfint401Mtl_emissive_png_texture
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Blend
    }
    PrincipledMaterial {
        id: meshesuntitled1bodyfrontgrilleint1Mtl_material
        objectName: "Meshesuntitled1bodyfrontgrilleint1Mtl"
        baseColorMap: textures_Meshesuntitled1bodyfrontgrilleint1Mtl_baseColor_png_texture
        metalness: 0.05
        roughness: 0.3
        emissiveMap: textures_Meshesuntitled1bodyfrontgrilleint1Mtl_emissive_png_texture
        emissiveFactor: root.lightsOn ? Qt.vector3d(3.5, 3.5, 3.5) : Qt.vector3d(0, 0, 0)
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Blend
    }
    PrincipledMaterial {
        id: meshesuntitled71Mtl_material
        objectName: "Meshesuntitled71Mtl"
        baseColor: "#ff080808"
        metalnessMap: textures_Meshesuntitled71Mtl_metallicRoughness_png_texture
        roughnessMap: textures_Meshesuntitled71Mtl_metallicRoughness_png_texture
        metalness: 0.05000000074505806
        roughness: 0.2393292635679245
        normalMap: textures_Meshesuntitled71Mtl_normal_png_texture
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: meshesuntitled131Mtl_material
        objectName: "Meshesuntitled131Mtl"
        baseColorMap: textures_Meshesuntitled131Mtl_baseColor_png_texture
        metalness: 0.05000000074505806
        roughness: 1
        emissiveMap: textures_Meshesuntitled131Mtl_baseColor_png_texture
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: meshesuntitled8doorlfint371Mtl_material
        objectName: "Meshesuntitled8doorlfint371Mtl"
        baseColorMap: textures_Meshesuntitled8doorlfint371Mtl_baseColor_png_texture
        metalness: 0.05000000074505806
        roughness: 1
        emissiveMap: textures_Meshesuntitled8doorlfint371Mtl_baseColor_png_texture
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: meshesuntitled1bodyfrontgrillechorme0011Mtl_material
        objectName: "Meshesuntitled1bodyfrontgrillechorme0011Mtl"
        baseColor: "#EBF1F8"
        metalness: 0.98
        roughness: 0.05
        clearcoatAmount: 1.0
        clearcoatRoughnessAmount: 0.02
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: headlightActive_material
        objectName: "HeadlightActiveMaterial"
        baseColor: root.lightsOn ? "#ffffff" : "#d0d4d8"
        metalness: root.lightsOn ? 0.0 : 0.95
        roughness: root.lightsOn ? 0.05 : 0.08
        emissiveFactor: root.lightsOn ? Qt.vector3d(6.0, 6.0, 6.5) : Qt.vector3d(0, 0, 0)
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
        id: meshesuntitled1trunkbodyplastic51Mtl_material
        objectName: "Meshesuntitled1trunkbodyplastic51Mtl"
        baseColor: root.lightsOn ? "#ff0a0a" : "#800505"
        metalness: 0.05
        roughness: 0.12
        clearcoatAmount: 0.9
        clearcoatRoughnessAmount: 0.08
        emissiveFactor: root.lightsOn ? Qt.vector3d(6.0, 0.2, 0.2) : Qt.vector3d(0, 0, 0)
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: meshesuntitled1bodyfrontgrillepaint1Mtl_material
        objectName: "Meshesuntitled1bodyfrontgrillepaint1Mtl"
        baseColor: root.paintColor
        metalness: root.metalness
        roughness: root.roughness
        clearcoatAmount: root.clearcoat
        clearcoatRoughnessAmount: 0.06
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
        id: whiteRim_material
        objectName: "WhiteRimMaterial"
        baseColor: "#F2F5F8"
        metalness: 0.60
        roughness: 0.20
        clearcoatAmount: 0.90
        clearcoatRoughnessAmount: 0.06
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: darkRimPocket_material
        objectName: "DarkRimPocketMaterial"
        baseColor: "#141A22"
        metalness: 0.85
        roughness: 0.32
        clearcoatAmount: 0.60
        clearcoatRoughnessAmount: 0.10
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
        id: meshesuntitled2carbodyfrostedplastic50021Mtl_material
        objectName: "Meshesuntitled2carbodyfrostedplastic50021Mtl"
        baseColor: root.paintColor
        metalness: root.metalness
        roughness: root.roughness
        clearcoatAmount: root.clearcoat
        clearcoatRoughnessAmount: 0.04
        normalMap: textures_Meshesuntitled2carbodyfrostedplastic50021Mtl_normal_png_texture
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
        id: meshesuntitled3carbodyint191Mtl_material
        objectName: "Meshesuntitled3carbodyint191Mtl"
        baseColor: root.lightsOn ? "#ff0a0a" : "#800505"
        metalness: 0.05
        roughness: 0.12
        clearcoatAmount: 0.9
        clearcoatRoughnessAmount: 0.08
        emissiveFactor: root.lightsOn ? Qt.vector3d(6.0, 0.2, 0.2) : Qt.vector3d(0, 0, 0)
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: meshesuntitled3carbodyleather20021Mtl_material
        objectName: "Meshesuntitled3carbodyleather20021Mtl"
        baseColor: "#171a21"
        metalnessMap: textures_Meshesuntitled3carbodyleather20021Mtl_metallicRoughness_png_texture
        roughnessMap: textures_Meshesuntitled3carbodyleather20021Mtl_metallicRoughness_png_texture
        metalness: 0.05
        roughness: 0.40
        normalMap: textures_Meshesuntitled3carbodyleather20021Mtl_normal_png_texture
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: meshesuntitled111Mtl_material
        objectName: "Meshesuntitled111Mtl"
        baseColor: "#ff000000"
        metalness: 0.05000000074505806
        roughness: 0.30640244483947754
        emissiveMap: textures_Meshesuntitled111Mtl_emissive_png_texture
        emissiveFactor: root.lightsOn ? Qt.vector3d(5.0, 5.0, 5.0) : Qt.vector3d(0, 0, 0)
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    Texture {
        id: apex_steering_texture
        source: "maps/apex_steering_wheel.png"
        generateMipmaps: true
        mipFilter: Texture.Linear
    }
    Texture {
        id: apex_steering_emissive_texture
        source: "maps/apex_steering_wheel_emissive.png"
        generateMipmaps: true
        mipFilter: Texture.Linear
    }
    PrincipledMaterial {
        id: meshesuntitledcarbodyleather51Mtl_material
        objectName: "Meshesuntitledcarbodyleather51Mtl"
        baseColor: "#15181e"
        metalness: 0.05
        roughness: 0.48
        normalMap: textures_Meshesuntitled3carbodyleather20021Mtl_normal_png_texture
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: steeringWheel_material
        objectName: "SteeringWheelMaterial"
        baseColor: "#ffffff"
        baseColorMap: apex_steering_texture
        emissiveMap: apex_steering_emissive_texture
        emissiveFactor: Qt.vector3d(5.5, 5.5, 6.0)
        metalness: 0.10
        roughness: 0.40
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: meshesuntitled101Mtl_material
        objectName: "Meshesuntitled101Mtl"
        baseColor: "#1e2024"
        metalness: 0.05
        roughness: 0.85
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
        emissiveFactor: root.lightsOn ? Qt.vector3d(2.5, 2.5, 2.5) : Qt.vector3d(0.8, 0.8, 0.8)
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Blend
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

    // Nodes:
    Node {
        id: sketchfab_model
        objectName: "Sketchfab_model"
        eulerRotation: Qt.vector3d(-90, 0, 0)
        Node {
            id: node2023_Apex_obj_cleaner_materialmerger_gles
            objectName: "2023 Apex Vehicle.obj.cleaner.materialmerger.gles"
            position: Qt.vector3d(19.0592, 74.2330, 0)


            Model {
                id: apex_Emblem_Backing
                objectName: "Apex_Emblem_Backing"
                source: "meshes/apex_Emblem_Backing_mesh.mesh"
                materials: [
                    apex_Backing_Mtl_material
                ]
            }
            Model {
                id: apex_Emblem
                objectName: "Apex_Emblem"
                source: "meshes/apex_Emblem_mesh.mesh"
                materials: [
                    apex_Emblem_Mtl_material
                ]
            }
            Model {
                id: object_2
                objectName: "Object_2"
                source: "meshes/object_0_mesh.mesh"
                materials: [
                    meshesuntitled101Mtl_material
                ]
            }
            Model {
                id: object_3
                objectName: "Object_3"
                source: "meshes/object_1_mesh.mesh"
                materials: [
                    meshesuntitled111Mtl_material
                ]
            }
            Model {
                id: object_4
                objectName: "Object_4"
                source: "meshes/object_2_mesh.mesh"
                materials: [
                    meshesuntitled131Mtl_material
                ]
            }
            Model {
                id: object_5
                objectName: "Object_5"
                source: "meshes/object_3_mesh.mesh"
                materials: [
                    meshesuntitled1bodyfrontgrilleint1Mtl_material
                ]
            }
            Model {
                id: object_6
                objectName: "Object_6"
                source: "meshes/object_4_mesh.mesh"
                materials: [
                    meshesuntitled1trunkbodyint1Mtl_material
                ]
            }
            Model {
                id: object_7
                objectName: "Object_7"
                source: "meshes/object_5_mesh.mesh"
                materials: [
                    meshesuntitled1bodyheadlampglass1Mtl_material
                ]
            }
            Model {
                id: object_8
                objectName: "Object_8"
                source: "meshes/object_6_mesh.mesh"
                materials: [
                    meshesuntitled1trunkbodyplate1Mtl_material
                ]
            }
            Model {
                id: object_9
                objectName: "Object_9"
                source: "meshes/object_7_mesh.mesh"
                materials: [
                    meshesuntitled1wheelfrowheeltire1Mtl_material
                ]
            }
            Model {
                id: object_10
                objectName: "Object_10"
                source: "meshes/object_8_mesh.mesh"
                materials: [
                    meshesuntitled1wheelbrowheeltire1Mtl_material
                ]
            }
            Model {
                id: object_11
                objectName: "Object_11"
                visible: root.roofVisible
                source: "meshes/object_9_mesh.mesh"
                materials: [
                    meshesuntitled2bodyskyglassglassskylight1Mtl_material
                ]
            }
            Model {
                id: object_12
                objectName: "Object_12"
                visible: root.roofVisible
                source: "meshes/object_10_mesh.mesh"
                materials: [
                    meshesuntitled2carbodyfrostedplastic61Mtl_material
                ]
            }
            Model {
                id: object_13
                objectName: "Object_13"
                source: "meshes/object_11_mesh.mesh"
                materials: [
                    meshesuntitled2carbodyint171Mtl_material
                ]
            }
            Model {
                id: object_14
                objectName: "Object_14"
                source: "meshes/object_12_mesh.mesh"
                materials: [
                    meshesuntitled2carbodyint271Mtl_material
                ]
            }
            Model {
                id: object_15
                objectName: "Object_15"
                source: "meshes/object_13_mesh.mesh"
                materials: [
                    meshesuntitled2carbodyint471Mtl_material
                ]
            }
            Model {
                id: object_16
                objectName: "Object_16"
                source: "meshes/object_14_mesh.mesh"
                materials: [
                    meshesuntitled2doorlfint421Mtl_material
                ]
            }
            Model {
                id: object_17
                objectName: "Object_17"
                source: "meshes/object_15_mesh.mesh"
                materials: [
                    meshesuntitled2doorlfint381Mtl_material
                ]
            }
            Model {
                id: object_18
                objectName: "Object_18"
                source: "meshes/object_16_mesh.mesh"
                materials: [
                    meshesuntitled3carbodyint131Mtl_material
                ]
            }
            Model {
                id: object_19
                objectName: "Object_19"
                source: "meshes/object_17_mesh.mesh"
                materials: [
                    meshesuntitled2doorrfint381Mtl_material
                ]
            }
            Model {
                id: object_20
                objectName: "Object_20"
                source: "meshes/object_18_mesh.mesh"
                materials: [
                    meshesuntitled2doorrfint421Mtl_material
                ]
            }
            Model {
                id: object_21
                objectName: "Object_21"
                source: "meshes/object_19_mesh.mesh"
                materials: [
                    meshesuntitled2wheelflowheeltire1Mtl_material
                ]
            }
            Model {
                id: object_22
                objectName: "Object_22"
                source: "meshes/object_20_mesh.mesh"
                materials: [
                    meshesuntitled3carbodyfrostedplastic21Mtl_material
                ]
            }
            Model {
                id: object_23
                objectName: "Object_23"
                source: "meshes/object_21_mesh.mesh"
                materials: [
                    meshesuntitled3carbodyint121Mtl_material
                ]
            }
            Model {
                id: object_24
                objectName: "Object_24"
                source: "meshes/object_22_mesh.mesh"
                materials: [
                    meshesuntitled3doorlbint371Mtl_material
                ]
            }
            Model {
                id: object_25
                objectName: "Object_25"
                source: "meshes/object_23_mesh.mesh"
                materials: [
                    meshesuntitled3carbodyint181Mtl_material
                ]
            }
            Model {
                id: object_26
                objectName: "Object_26"
                source: "meshes/object_24_mesh.mesh"
                materials: [
                    meshesuntitled3doorlbint381Mtl_material
                ]
            }
            Model {
                id: object_27
                objectName: "Object_27"
                source: "meshes/object_25_mesh.mesh"
                materials: [
                    meshesuntitled3doorrbint371Mtl_material
                ]
            }
            Model {
                id: object_28
                objectName: "Object_28"
                source: "meshes/object_26_mesh.mesh"
                materials: [
                    meshesuntitled3doorrbint381Mtl_material
                ]
            }
            Model {
                id: object_29
                objectName: "Object_29"
                source: "meshes/object_27_mesh.mesh"
                materials: [
                    meshesuntitled3wheelblowheeltire1Mtl_material
                ]
            }
            Model {
                id: object_30
                objectName: "Object_30"
                source: "meshes/object_28_mesh.mesh"
                materials: [
                    meshesuntitled41Mtl_material
                ]
            }
            Model {
                id: object_31
                objectName: "Object_31"
                source: "meshes/object_29_mesh.mesh"
                materials: [
                    meshesuntitled5carbodyint151Mtl_material
                ]
            }
            Model {
                id: object_32
                objectName: "Object_32"
                source: "meshes/object_30_mesh.mesh"
                materials: [
                    meshesuntitled5doorlbint401Mtl_material
                ]
            }
            Model {
                id: object_33
                objectName: "Object_33"
                source: "meshes/object_31_mesh.mesh"
                materials: [
                    meshesuntitled5doorlfint401Mtl_material
                ]
            }
            Model {
                id: object_34
                objectName: "Object_34"
                source: "meshes/object_32_mesh.mesh"
                materials: [
                    meshesuntitled5doorrbint401Mtl_material
                ]
            }
            Model {
                id: object_35
                objectName: "Object_35"
                source: "meshes/object_33_mesh.mesh"
                materials: [
                    meshesuntitled5doorrfint401Mtl_material
                ]
            }
            Model {
                id: object_36
                objectName: "Object_36"
                source: "meshes/object_34_mesh.mesh"
                materials: [
                    meshesuntitled71Mtl_material
                ]
            }
            Model {
                id: object_37
                objectName: "Object_37"
                source: "meshes/object_35_mesh.mesh"
                materials: [
                    meshesuntitled8doorlfint371Mtl_material
                ]
            }
            Model {
                id: object_38
                objectName: "Object_38"
                source: "meshes/object_36_mesh.mesh"
                materials: [
                    whiteRim_material
                ]
            }
            Model {
                id: object_39
                objectName: "Object_39"
                source: "meshes/object_37_mesh.mesh"
                materials: [
                    whiteRim_material
                ]
            }
            Model {
                id: object_40
                objectName: "Object_40"
                source: "meshes/object_38_mesh.mesh"
                materials: [
                    meshesuntitled1bodyfrontgrillechorme0011Mtl_material
                ]
            }
            Model {
                id: object_41
                objectName: "Object_41"
                source: "meshes/object_39_mesh.mesh"
                materials: [
                    meshesuntitled1bodyfrontgrillechorme0011Mtl_material
                ]
            }
            Model {
                id: object_42
                objectName: "Object_42"
                source: "meshes/object_40_mesh.mesh"
                materials: [
                    headlightActive_material
                ]
            }
            Model {
                id: object_43
                objectName: "Object_43"
                source: "meshes/object_41_mesh.mesh"
                materials: [
                    meshesuntitled1bodyfrontgrillechorme0011Mtl_material
                ]
            }
            Model {
                id: object_44
                objectName: "Object_44"
                source: "meshes/object_42_mesh.mesh"
                materials: [
                    meshesuntitled1bodyfrontgrillechorme0011Mtl_material
                ]
            }
            Model {
                id: object_45
                objectName: "Object_45"
                source: "meshes/object_43_mesh.mesh"
                materials: [
                    meshesuntitled1bodyfrontgrillechorme0011Mtl_material
                ]
            }
            Model {
                id: object_46
                objectName: "Object_46"
                visible: root.roofVisible
                source: "meshes/object_44_mesh.mesh"
                materials: [
                    meshesuntitled1bodyfrontgrillechorme0011Mtl_material
                ]
            }
            Model {
                id: object_47
                objectName: "Object_47"
                source: "meshes/object_45_mesh.mesh"
                materials: [
                    whiteRim_material
                ]
            }
            Model {
                id: object_48
                objectName: "Object_48"
                source: "meshes/object_46_mesh.mesh"
                materials: [
                    meshesuntitled1bodylightglass1Mtl_material
                ]
            }
            Model {
                id: object_49
                objectName: "Object_49"
                source: "meshes/object_47_mesh.mesh"
                materials: [
                    meshesuntitled1trunkbodyplastic51Mtl_material
                ]
            }
            Model {
                id: object_50
                 
                objectName: "Object_50"
                source: "meshes/object_48_mesh.mesh"
                materials: [
                    meshesuntitled1bodyfrontgrillepaint1Mtl_material
                ]
            }
            Model {
                id: object_51
                 
                objectName: "Object_51"
                source: "meshes/object_49_mesh.mesh"
                materials: [
                    meshesuntitled1bodyfrontgrillepaint1Mtl_material
                ]
            }
            Model {
                id: object_52
                 
                objectName: "Object_52"
                source: "meshes/object_50_mesh.mesh"
                materials: [
                    meshesuntitled1bodyfrontgrillepaint1Mtl_material
                ]
            }
            Model {
                id: object_53
                 
                objectName: "Object_53"
                source: "meshes/object_51_mesh.mesh"
                materials: [
                    meshesuntitled1bodyfrontgrillepaint1Mtl_material
                ]
            }
            Model {
                id: object_54
                 
                objectName: "Object_54"
                source: "meshes/object_52_mesh.mesh"
                materials: [
                    meshesuntitled1bodyfrontgrillepaint1Mtl_material
                ]
            }
            Model {
                id: object_55
                objectName: "Object_55"
                visible: root.roofVisible
                source: "meshes/object_53_mesh.mesh"
                materials: [
                    meshesuntitled1bodyglassglass1Mtl_material
                ]
            }
            Model {
                id: object_56
                objectName: "Object_56"
                visible: root.roofVisible
                source: "meshes/object_54_mesh.mesh"
                materials: [
                    meshesuntitled1bodyheadlampplastic1Mtl_material
                ]
            }
            Model {
                id: object_57
                objectName: "Object_57"
                visible: root.roofVisible
                source: "meshes/object_55_mesh.mesh"
                materials: [
                    meshesuntitled1bodyheadlampplastic1Mtl_material
                ]
            }
            Model {
                id: object_58
                objectName: "Object_58"
                source: "meshes/object_56_mesh.mesh"
                materials: [
                    meshesuntitled1bodyheadlampplastic1Mtl_material
                ]
            }
            Model {
                id: object_59
                objectName: "Object_59"
                source: "meshes/object_57_mesh.mesh"
                materials: [
                    meshesuntitled1bodyheadlampplastic1Mtl_material
                ]
            }
            Model {
                id: object_60
                objectName: "Object_60"
                source: "meshes/object_58_mesh.mesh"
                materials: [
                    darkRimPocket_material
                ]
            }
            Model {
                id: object_61
                objectName: "Object_61"
                source: "meshes/object_59_mesh.mesh"
                materials: [
                    darkRimPocket_material
                ]
            }
            Model {
                id: object_62
                objectName: "Object_62"
                source: "meshes/object_60_mesh.mesh"
                materials: [
                    darkRimPocket_material
                ]
            }
            Model {
                id: object_63
                objectName: "Object_63"
                visible: root.roofVisible
                source: "meshes/object_61_mesh.mesh"
                materials: [
                    meshesuntitled1bodyheadlampplastic1Mtl_material
                ]
            }
            Model {
                id: object_64
                objectName: "Object_64"
                source: "meshes/object_62_mesh.mesh"
                materials: [
                    meshesuntitled1bodyheadlampplastic1Mtl_material
                ]
            }
            Model {
                id: object_65
                objectName: "Object_65"
                source: "meshes/object_63_mesh.mesh"
                materials: [
                    meshesuntitled1bodyheadlampplastic1Mtl_material
                ]
            }
            Model {
                id: object_66_67_merged
                objectName: "Object_66_67_Merged"
                source: "meshes/object_66_67_merged_mesh.mesh"
                materials: [
                    meshesuntitled1bodyheadlampplastic1Mtl_material
                ]
            }
            Model {
                id: object_68
                objectName: "Object_68"
                source: "meshes/object_66_mesh.mesh"
                materials: [
                    darkRimPocket_material
                ]
            }
            Model {
                id: object_69
                objectName: "Object_69"
                source: "meshes/object_67_mesh.mesh"
                materials: [
                    darkRimPocket_material
                ]
            }
            Model {
                id: object_70
                objectName: "Object_70"
                source: "meshes/object_68_mesh.mesh"
                materials: [
                    darkRimPocket_material
                ]
            }
            Model {
                id: object_71
                objectName: "Object_71"
                source: "meshes/object_69_mesh.mesh"
                materials: [
                    meshesuntitled1bodyheadlampplastic1Mtl_material
                ]
            }
            Model {
                id: object_72
                objectName: "Object_72"
                source: "meshes/object_70_mesh.mesh"
                materials: [
                    meshesuntitled1bodyheadlampplastic1Mtl_material
                ]
            }
            Model {
                id: object_73
                objectName: "Object_73"
                visible: root.roofVisible
                source: "meshes/object_71_mesh.mesh"
                materials: [
                    meshesuntitled1bodyheadlampplastic1Mtl_material
                ]
            }
            Model {
                id: object_74
                objectName: "Object_74"
                source: "meshes/object_72_mesh.mesh"
                materials: [
                    meshesuntitled2carbodyfrostedplastic50021Mtl_material
                ]
            }
            Model {
                id: object_75
                objectName: "Object_75"
                source: "meshes/object_73_mesh.mesh"
                materials: [
                    meshesuntitled2carbodyfrostedplastic50021Mtl_material
                ]
            }
            Model {
                id: object_76
                objectName: "Object_76"
                source: "meshes/object_74_mesh.mesh"
                materials: [
                    meshesuntitled2carbodyfrostedplastic50021Mtl_material
                ]
            }
            Model {
                id: object_77
                objectName: "Object_77"
                source: "meshes/object_75_mesh.mesh"
                materials: [
                    meshesuntitled2carbodyfrostedplastic50021Mtl_material
                ]
            }
            Model {
                id: object_78
                objectName: "Object_78"
                source: "meshes/object_76_mesh.mesh"
                materials: [
                    meshesuntitled2carbodyfrostedplastic50021Mtl_material
                ]
            }
            Model {
                id: object_79
                objectName: "Object_79"
                visible: root.roofVisible
                source: "meshes/object_77_mesh.mesh"
                materials: [
                    meshesuntitled2carbodyfrostedplastic50021Mtl_material
                ]
            }
            Model {
                id: object_80
                objectName: "Object_80"
                source: "meshes/object_78_mesh.mesh"
                materials: [
                    meshesuntitled2carbodyfrostedplastic50021Mtl_material
                ]
            }
            Model {
                id: object_81
                objectName: "Object_81"
                source: "meshes/object_79_mesh.mesh"
                materials: [
                    meshesuntitled2carbodyfrostedplastic50021Mtl_material
                ]
            }
            Model {
                id: object_82
                objectName: "Object_82"
                source: "meshes/object_80_mesh.mesh"
                materials: [
                    meshesuntitled2carbodyfrostedplastic50021Mtl_material
                ]
            }
            Model {
                id: object_83
                objectName: "Object_83"
                source: "meshes/object_81_mesh.mesh"
                materials: [
                    meshesuntitled2doorrfmirror1Mtl_material
                ]
            }
            Model {
                id: object_84
                objectName: "Object_84"
                source: "meshes/object_82_mesh.mesh"
                materials: [
                    meshesuntitled3carbodyint191Mtl_material
                ]
            }
            Model {
                id: object_85
                objectName: "Object_85"
                source: "meshes/object_83_mesh.mesh"
                materials: [
                    meshesuntitled3carbodyleather20021Mtl_material
                ]
            }
            Model {
                id: object_86
                objectName: "Object_86"
                source: "meshes/object_84_mesh.mesh"
                materials: [
                    meshesuntitled3carbodyleather20021Mtl_material
                ]
            }
            Model {
                id: object_87
                objectName: "Object_87"
                source: "meshes/object_85_mesh.mesh"
                materials: [
                    meshesuntitled3carbodyleather20021Mtl_material
                ]
            }
            Model {
                id: object_88
                objectName: "Object_88"
                source: "meshes/object_86_mesh.mesh"
                materials: [
                    meshesuntitledcarbodyleather51Mtl_material
                ]
            }
            Model {
                id: object_89
                objectName: "Object_89"
                source: "meshes/object_87_mesh.mesh"
                materials: [
                    steeringWheel_material
                ]
            }
        }
    }

    // Animations:
}