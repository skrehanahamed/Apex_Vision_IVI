/**
 * ==============================================================================
 * Project: Apex VISION IVI - Digital Cockpit & Infotainment System
 * File: Scene.qml
 * Author / Developer: Sk Rehan Ahamed
 * License: MIT
 * ==============================================================================
 */

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
    readonly property alias tireFL: car_Body_Cabin
    readonly property alias tireFR: car_Body_Cabin
    readonly property alias tireRL: car_Body_Cabin
    readonly property alias tireRR: car_Body_Cabin


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
        cullMode: PrincipledMaterial.BackFaceCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: meshesuntitled2doorrfint381Mtl_material
        objectName: "Meshesuntitled2doorrfint381Mtl"
        baseColorMap: textures_Meshesuntitled2doorrfint381Mtl_baseColor_png_texture
        metalness: 0.05000000074505806
        roughness: 1
        emissiveMap: textures_Meshesuntitled2doorrfint381Mtl_baseColor_png_texture
        cullMode: PrincipledMaterial.BackFaceCulling
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
        cullMode: PrincipledMaterial.BackFaceCulling
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
        cullMode: PrincipledMaterial.BackFaceCulling
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
        cullMode: PrincipledMaterial.BackFaceCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: meshesuntitled2carbodyint271Mtl_material
        objectName: "Meshesuntitled2carbodyint271Mtl"
        baseColor: "#050608"
        roughness: 0.08
        metalness: 0.12
        specularAmount: 0.98
        cullMode: PrincipledMaterial.BackFaceCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: meshesuntitled3doorlbint371Mtl_material
        objectName: "Meshesuntitled3doorlbint371Mtl"
        baseColorMap: textures_Meshesuntitled3doorlbint371Mtl_baseColor_png_texture
        metalness: 0.05000000074505806
        roughness: 1
        emissiveMap: textures_Meshesuntitled3doorlbint371Mtl_baseColor_png_texture
        cullMode: PrincipledMaterial.BackFaceCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: meshesuntitled2carbodyint171Mtl_material
        objectName: "Meshesuntitled2carbodyint171Mtl"
        baseColorMap: textures_Meshesuntitled2carbodyint171Mtl_baseColor_png_texture
        metalness: 0.05000000074505806
        roughness: 1
        emissiveMap: textures_Meshesuntitled2carbodyint171Mtl_baseColor_png_texture
        cullMode: PrincipledMaterial.BackFaceCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: meshesuntitled3carbodyint181Mtl_material
        objectName: "Meshesuntitled3carbodyint181Mtl"
        baseColor: "#ff1b53ba"
        metalness: 0.05000000074505806
        roughness: 1
        cullMode: PrincipledMaterial.BackFaceCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: meshesuntitled3doorlbint381Mtl_material
        objectName: "Meshesuntitled3doorlbint381Mtl"
        baseColorMap: textures_Meshesuntitled3doorlbint381Mtl_baseColor_png_texture
        metalness: 0.05000000074505806
        roughness: 1
        emissiveMap: textures_Meshesuntitled3doorlbint381Mtl_baseColor_png_texture
        cullMode: PrincipledMaterial.BackFaceCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: meshesuntitled3doorrbint371Mtl_material
        objectName: "Meshesuntitled3doorrbint371Mtl"
        baseColorMap: textures_Meshesuntitled3doorrbint371Mtl_baseColor_png_texture
        metalness: 0.05000000074505806
        roughness: 1
        emissiveMap: textures_Meshesuntitled3doorrbint371Mtl_baseColor_png_texture
        cullMode: PrincipledMaterial.BackFaceCulling
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
        cullMode: PrincipledMaterial.BackFaceCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: meshesuntitled3doorrbint381Mtl_material
        objectName: "Meshesuntitled3doorrbint381Mtl"
        baseColorMap: textures_Meshesuntitled3doorrbint381Mtl_baseColor_png_texture
        metalness: 0.05000000074505806
        roughness: 1
        emissiveMap: textures_Meshesuntitled3doorrbint381Mtl_baseColor_png_texture
        cullMode: PrincipledMaterial.BackFaceCulling
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
        cullMode: PrincipledMaterial.BackFaceCulling
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
        id: meshesuntitled41Mtl_material
        objectName: "Meshesuntitled41Mtl"
        baseColor: "#ff080808"
        metalnessMap: textures_Meshesuntitled41Mtl_metallicRoughness_png_texture
        roughnessMap: textures_Meshesuntitled41Mtl_metallicRoughness_png_texture
        metalness: 0.05000000074505806
        roughness: 0.23323170840740204
        normalMap: textures_Meshesuntitled41Mtl_normal_png_texture
        cullMode: PrincipledMaterial.BackFaceCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: meshesuntitled1wheelbrowheeltire1Mtl_material
        objectName: "Meshesuntitled1wheelbrowheeltire1Mtl"
        baseColorMap: textures_Meshesuntitled1wheelbrowheeltire1Mtl_baseColor_png_texture
        metalness: 0.28
        roughness: 0.35
        cullMode: PrincipledMaterial.BackFaceCulling
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
        cullMode: PrincipledMaterial.BackFaceCulling
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
        cullMode: PrincipledMaterial.BackFaceCulling
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
        cullMode: PrincipledMaterial.BackFaceCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: meshesuntitled131Mtl_material
        objectName: "Meshesuntitled131Mtl"
        baseColorMap: textures_Meshesuntitled131Mtl_baseColor_png_texture
        metalness: 0.05000000074505806
        roughness: 1
        emissiveMap: textures_Meshesuntitled131Mtl_baseColor_png_texture
        cullMode: PrincipledMaterial.BackFaceCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: meshesuntitled8doorlfint371Mtl_material
        objectName: "Meshesuntitled8doorlfint371Mtl"
        baseColorMap: textures_Meshesuntitled8doorlfint371Mtl_baseColor_png_texture
        metalness: 0.05000000074505806
        roughness: 1
        emissiveMap: textures_Meshesuntitled8doorlfint371Mtl_baseColor_png_texture
        cullMode: PrincipledMaterial.BackFaceCulling
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
        cullMode: PrincipledMaterial.BackFaceCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: headlightActive_material
        objectName: "HeadlightActiveMaterial"
        baseColor: root.lightsOn ? "#ffffff" : "#d0d4d8"
        metalness: root.lightsOn ? 0.0 : 0.95
        roughness: root.lightsOn ? 0.05 : 0.08
        emissiveFactor: root.lightsOn ? Qt.vector3d(6.0, 6.0, 6.5) : Qt.vector3d(0, 0, 0)
        cullMode: PrincipledMaterial.BackFaceCulling
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
        cullMode: PrincipledMaterial.BackFaceCulling
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
        cullMode: PrincipledMaterial.BackFaceCulling
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
        cullMode: PrincipledMaterial.BackFaceCulling
        opacity: 0.25
        alphaMode: PrincipledMaterial.Blend
        depthDrawMode: PrincipledMaterial.OpaqueOnlyDepthDraw
    }
    PrincipledMaterial {
        id: whiteRim_material
        objectName: "WhiteRimMaterial"
        baseColor: "#F2F5F8"
        metalness: 0.60
        roughness: 0.20
        clearcoatAmount: 0.90
        clearcoatRoughnessAmount: 0.06
        cullMode: PrincipledMaterial.BackFaceCulling
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
        cullMode: PrincipledMaterial.BackFaceCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: meshesuntitled1bodyheadlampplastic1Mtl_material
        objectName: "Meshesuntitled1bodyheadlampplastic1Mtl"
        baseColor: "#ff080808"
        metalness: 0.05000000074505806
        roughness: 0.3246951103210449
        cullMode: PrincipledMaterial.BackFaceCulling
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
        cullMode: PrincipledMaterial.BackFaceCulling
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
        cullMode: PrincipledMaterial.BackFaceCulling
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
        cullMode: PrincipledMaterial.BackFaceCulling
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
        cullMode: PrincipledMaterial.BackFaceCulling
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
        cullMode: PrincipledMaterial.BackFaceCulling
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
        cullMode: PrincipledMaterial.BackFaceCulling
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
        cullMode: PrincipledMaterial.BackFaceCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: meshesuntitled101Mtl_material
        objectName: "Meshesuntitled101Mtl"
        baseColor: "#1e2024"
        metalness: 0.05
        roughness: 0.85
        cullMode: PrincipledMaterial.BackFaceCulling
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
        cullMode: PrincipledMaterial.BackFaceCulling
        alphaMode: PrincipledMaterial.Opaque
    }

    // Nodes: (True 2-Mesh Architecture: Full Car Body & Cabin + Removable Roof)
    Node {
        id: rootNode
        objectName: "ROOT"

        Node {
            id: node2023_Lincoln_Zephyr_obj_cleaner_materialmerger_gles
            objectName: "2023 Lincoln Zephyr.obj.cleaner.materialmerger.gles"

            // 1. Full Vehicle Assembly (Chassis, Cabin Interior, Dashboard, Seats, Wheels, Controls)
            Model {
                id: car_Body_Cabin
                objectName: "car_Body_Cabin"
                source: "meshes/car_Body_Cabin_mesh.mesh"
                materials: [
                    meshesuntitled101Mtl_material,
                    meshesuntitled111Mtl_material,
                    meshesuntitled131Mtl_material,
                    meshesuntitled1bodyfrontgrilleint1Mtl_material,
                    meshesuntitled1trunkbodyint1Mtl_material,
                    meshesuntitled1bodyheadlampglass1Mtl_material,
                    meshesuntitled1trunkbodyplate1Mtl_material,
                    meshesuntitled1wheelfrowheeltire1Mtl_material,
                    meshesuntitled1wheelbrowheeltire1Mtl_material,
                    meshesuntitled2carbodyint171Mtl_material,
                    meshesuntitled2carbodyint271Mtl_material,
                    meshesuntitled2carbodyint471Mtl_material,
                    meshesuntitled2doorlfint421Mtl_material,
                    meshesuntitled2doorlfint381Mtl_material,
                    meshesuntitled3carbodyint131Mtl_material,
                    meshesuntitled2doorrfint381Mtl_material,
                    meshesuntitled2doorrfint421Mtl_material,
                    meshesuntitled2wheelflowheeltire1Mtl_material,
                    meshesuntitled3carbodyfrostedplastic21Mtl_material,
                    meshesuntitled3carbodyint121Mtl_material,
                    meshesuntitled3doorlbint371Mtl_material,
                    meshesuntitled3carbodyint181Mtl_material,
                    meshesuntitled3doorlbint381Mtl_material,
                    meshesuntitled3doorrbint371Mtl_material,
                    meshesuntitled3doorrbint381Mtl_material,
                    meshesuntitled3wheelblowheeltire1Mtl_material,
                    meshesuntitled41Mtl_material,
                    meshesuntitled5carbodyint151Mtl_material,
                    meshesuntitled5doorlbint401Mtl_material,
                    meshesuntitled5doorlfint401Mtl_material,
                    meshesuntitled5doorrbint401Mtl_material,
                    meshesuntitled5doorrfint401Mtl_material,
                    meshesuntitled71Mtl_material,
                    meshesuntitled8doorlfint371Mtl_material,
                    meshesuntitled1bodyfrontgrillechorme0011Mtl_material,
                    meshesuntitled1bodylightglass1Mtl_material,
                    meshesuntitled1trunkbodyplastic51Mtl_material,
                    meshesuntitled1bodyfrontgrillepaint1Mtl_material,
                    meshesuntitled1bodyheadlampplastic1Mtl_material,
                    meshesuntitled2carbodyfrostedplastic50021Mtl_material,
                    meshesuntitled2doorrfmirror1Mtl_material,
                    meshesuntitled3carbodyint191Mtl_material,
                    meshesuntitled3carbodyleather20021Mtl_material,
                    meshesuntitledcarbodyleather51Mtl_material,
                    apex_Backing_Mtl_material,
                    apex_Emblem_Mtl_material
                ]
            }

            // 2. Independent Removable Roof Assembly (Vanishes in Rear View for Unobstructed Cabin Sightlines)
            Model {
                id: roof_Assembly
                objectName: "roof_Assembly"
                visible: root.roofVisible
                source: "meshes/roof_Assembly_mesh.mesh"
                materials: [
                    meshesuntitled2bodyskyglassglassskylight1Mtl_material,
                    meshesuntitled2carbodyfrostedplastic61Mtl_material,
                    meshesuntitled1bodyfrontgrillechorme0011Mtl_material,
                    meshesuntitled1bodyglassglass1Mtl_material,
                    meshesuntitled1bodyheadlampplastic1Mtl_material
                ]
            }
        }
    }
}
