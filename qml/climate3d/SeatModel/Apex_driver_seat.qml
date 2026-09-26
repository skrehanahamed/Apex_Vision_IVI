import QtQuick
import QtQuick3D

Node {
    id: node

    // Resources
    property url textureData: "maps/textureData.png"
    property url textureData6: "maps/textureData6.png"
    property url textureData8: "maps/textureData8.png"
    property url textureData27: "maps/textureData27.png"
    property url textureData13: "maps/textureData13.png"
    property url textureData15: "maps/textureData15.png"
    property url textureData22: "maps/textureData22.png"
    property url textureData20: "maps/textureData20.png"
    Texture {
        id: _5_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: node.textureData22
    }
    Texture {
        id: _0_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: node.textureData6
    }
    Texture {
        id: _1_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: node.textureData8
    }
    Texture {
        id: _7_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: node.textureData
    }
    Texture {
        id: _2_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: node.textureData13
    }
    Texture {
        id: _3_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: node.textureData15
    }
    Texture {
        id: _6_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: node.textureData27
    }
    Texture {
        id: _4_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: node.textureData20
    }
    PrincipledMaterial {
        id: meshesuntitled2carbodyfrostedplastic50021Mtl_material
        objectName: "Meshesuntitled2carbodyfrostedplastic50021Mtl"
        baseColor: "#ff080808"
        metalnessMap: _4_texture
        roughnessMap: _4_texture
        metalness: 0.05000000074505806
        roughness: 0.28810974955558777
        normalMap: _5_texture
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: meshesuntitled3carbodyleather20021Mtl_material
        objectName: "Meshesuntitled3carbodyleather20021Mtl"
        baseColor: "#ff080808"
        metalnessMap: _6_texture
        roughnessMap: _6_texture
        metalness: 0.05000000074505806
        roughness: 0.33689025044441223
        normalMap: _7_texture
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: meshesuntitled71Mtl_material
        objectName: "Meshesuntitled71Mtl"
        baseColor: "#ff080808"
        metalnessMap: _2_texture
        roughnessMap: _2_texture
        metalness: 0.05000000074505806
        roughness: 0.2393292635679245
        normalMap: _3_texture
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: meshesuntitled41Mtl_material
        objectName: "Meshesuntitled41Mtl"
        baseColor: "#ff080808"
        metalnessMap: _0_texture
        roughnessMap: _0_texture
        metalness: 0.05000000074505806
        roughness: 0.23323170840740204
        normalMap: _1_texture
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: lumbarGlowMaterial_material
        objectName: "LumbarGlowMaterial"
        baseColor: "#ffe7e7e7"
        roughness: 0.5
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: thighGlowMaterial_material
        objectName: "ThighGlowMaterial"
        baseColor: "#ffe7e7e7"
        roughness: 0.5
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }

    // Nodes:
    Node {
        id: root
        objectName: "ROOT"
        Model {
            id: object_30_FrontDriver
            objectName: "Object_30_FrontDriver"
            source: "meshes/object_30_FrontDriverMesh_mesh.mesh"
            materials: [
                meshesuntitled41Mtl_material
            ]
        }
        Model {
            id: object_36_FrontDriver
            objectName: "Object_36_FrontDriver"
            source: "meshes/object_36_FrontDriverMesh_mesh.mesh"
            materials: [
                meshesuntitled71Mtl_material
            ]
        }
        Model {
            id: object_77_FrontDriver
            objectName: "Object_77_FrontDriver"
            source: "meshes/object_77_FrontDriverMesh_mesh.mesh"
            materials: [
                meshesuntitled2carbodyfrostedplastic50021Mtl_material
            ]
        }
        Model {
            id: object_85_FrontDriver
            objectName: "Object_85_FrontDriver"
            source: "meshes/object_85_FrontDriverMesh_mesh.mesh"
            materials: [
                meshesuntitled3carbodyleather20021Mtl_material
            ]
        }
        Model {
            id: object_Lumbar_Highlight
            objectName: "Object_Lumbar_Highlight"
            source: "meshes/object_Lumbar_HighlightMesh_mesh.mesh"
            materials: [
                lumbarGlowMaterial_material
            ]
        }
        Model {
            id: object_Thigh_Highlight
            objectName: "Object_Thigh_Highlight"
            source: "meshes/object_Thigh_HighlightMesh_mesh.mesh"
            materials: [
                thighGlowMaterial_material
            ]
        }
    }

    // Animations:
}
