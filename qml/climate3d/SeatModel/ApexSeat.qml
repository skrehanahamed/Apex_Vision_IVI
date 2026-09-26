import QtQuick
import QtQuick3D

Node {
    id: node

    // Resources
    property url textureData: "maps/textureData.png"
    property url textureData8: "maps/textureData8.png"
    property url textureData13: "maps/textureData13.png"
    property url textureData15: "maps/textureData15.png"
    property url textureData20: "maps/textureData20.png"
    property url textureData22: "maps/textureData22.png"
    property url textureData27: "maps/textureData27.png"
    property url textureData29: "maps/textureData29.png"

    Texture {
        id: _0_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: node.textureData
    }
    Texture {
        id: _1_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: node.textureData8
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
        id: _4_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: node.textureData20
    }
    Texture {
        id: _5_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: node.textureData22
    }
    Texture {
        id: _6_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: node.textureData27
    }
    Texture {
        id: _7_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: node.textureData29
    }

    // High-Resolution Firefly 3D Bloom Texture for Real Volumetric Glow
    Texture {
        id: fireflyBloomTexture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: "maps/firefly_bloom.png"
    }

    // Configurable visual properties
    property bool isDimmed: false
    property color leatherColor: isDimmed ? "#0c0e14" : "#1b1f28"
    property real leatherRoughness: 0.35
    property real leatherMetalness: 0.08
    property color casingColor: isDimmed ? "#080a0e" : "#111419"

    // Object_30 Casing Material
    PrincipledMaterial {
        id: meshesuntitled41Mtl_material
        objectName: "Meshesuntitled41Mtl"
        baseColor: node.casingColor
        metalnessMap: _0_texture
        roughnessMap: _0_texture
        metalness: 0.05
        roughness: 0.40
        normalMap: _1_texture
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }

    // Object_36 Hardware & Rails Material
    PrincipledMaterial {
        id: meshesuntitled71Mtl_material
        objectName: "Meshesuntitled71Mtl"
        baseColor: "#181b22"
        metalnessMap: _2_texture
        roughnessMap: _2_texture
        metalness: 0.15
        roughness: 0.25
        normalMap: _3_texture
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }

    // Object_77 Frosted Plastic Controls & Sockets Material
    PrincipledMaterial {
        id: meshesuntitled2carbodyfrostedplastic50021Mtl_material
        objectName: "Meshesuntitled2carbodyfrostedplastic50021Mtl"
        baseColor: "#13171f"
        metalnessMap: _4_texture
        roughnessMap: _4_texture
        metalness: 0.05
        roughness: 0.35
        normalMap: _5_texture
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }

    // Object_85 Perforated Leather Cushions Material
    PrincipledMaterial {
        id: meshesuntitled3carbodyleather20021Mtl_material
        objectName: "Meshesuntitled3carbodyleather20021Mtl"
        baseColor: node.leatherColor
        metalnessMap: _6_texture
        roughnessMap: _6_texture
        metalness: node.leatherMetalness
        roughness: node.leatherRoughness
        normalMap: _7_texture
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }

    // Interactive Zone & Multi-Contour Seat Properties:
    // 3 in Lumbar (Backrest): "lumbar_upper" | "lumbar_mid" | "lumbar_lower"
    // 2 in Cushion (Seat base): "cushion_left" | "cushion_right"
    property string selectedZone: "lumbar_mid"
    property real lumbarUpperLevel: 0.5 // 0.1 to 1.0 (corresponds to 1/10 to 10/10)
    property real lumbarMidLevel: 0.5
    property real lumbarLowerLevel: 0.5
    property real cushionLeftLevel: 0.5
    property real cushionRightLevel: 0.5

    // Backward-compatible aliases
    property real upperLevel: lumbarUpperLevel
    property real lumbarLevel: lumbarMidLevel
    property real thighLevel: cushionLeftLevel
    property bool lumbarActive: selectedZone.indexOf("lumbar") !== -1
    property bool thighActive: selectedZone.indexOf("cushion") !== -1

    // Multi-Contour Massage Visualizer
    property bool massageActive: false
    property int massageIntensity: 1 // 1, 2, 3
    property string massageProgram: "relax"

    // Massage Pulsing & Motion Animation
    property real massagePulse: 0.0
    NumberAnimation on massagePulse {
        running: node.massageActive
        loops: Animation.Infinite
        from: 0.0; to: 1.0
        duration: {
            var base = (node.massageProgram === "pulse") ? 900 :
                       (node.massageProgram === "rolling") ? 1300 :
                       (node.massageProgram === "circular") ? 1500 : 1700;
            return base / (node.massageIntensity === 3 ? 1.4 : (node.massageIntensity === 2 ? 1.15 : 1.0));
        }
    }

    // Dynamic Massage Trajectory Calculations
    readonly property real cycleAngle: massagePulse * Math.PI * 2

    // -------------------------------------------------------------------------
    // Program Trajectory Logic for the 5 Massage Modes:
    // 1. circular: 1 dot rotates circular
    // 2. regular (relax): 1 dot goes zigzag
    // 3. recovery: 1 dot square style
    // 4. rolling: 2 dots go straight up and down
    // 5. pulse: 4 dots blink
    // -------------------------------------------------------------------------
    // 1. Circular: 1 dot rotating circular
    readonly property real circX: Math.cos(cycleAngle) * 0.12
    readonly property real circY: 1.58 + Math.sin(cycleAngle) * 0.16

    // 2. Regular (relax): 1 dot goes zigzag up and down
    readonly property real zigzagProgress: (massagePulse <= 0.5) ? (massagePulse * 2.0) : (2.0 - massagePulse * 2.0)
    readonly property real zigzagY: 1.36 + zigzagProgress * 0.52
    readonly property real zigzagX: Math.sin(massagePulse * Math.PI * 8.0) * 0.13

    // 3. Recovery: 1 dot in square style
    readonly property real sqMinX: -0.13
    readonly property real sqMaxX: 0.13
    readonly property real sqMinY: 1.40
    readonly property real sqMaxY: 1.78
    readonly property real squareX: {
        var p = massagePulse % 1.0;
        if (p < 0.25) return sqMinX + (sqMaxX - sqMinX) * (p / 0.25);
        else if (p < 0.50) return sqMaxX;
        else if (p < 0.75) return sqMaxX - (sqMaxX - sqMinX) * ((p - 0.50) / 0.25);
        else return sqMinX;
    }
    readonly property real squareY: {
        var p = massagePulse % 1.0;
        if (p < 0.25) return sqMinY;
        else if (p < 0.50) return sqMinY + (sqMaxY - sqMinY) * ((p - 0.25) / 0.25);
        else if (p < 0.75) return sqMaxY;
        else return sqMaxY - (sqMaxY - sqMinY) * ((p - 0.75) / 0.25);
    }

    // 4. Rolling: 2 dots go straight up and down
    readonly property real rollY: 1.36 + (Math.sin(cycleAngle) * 0.5 + 0.5) * 0.52

    // 5. Pulse: 4 dots blink
    readonly property real pulseBlink: Math.pow(Math.sin(massagePulse * Math.PI * 4.0) * 0.5 + 0.5, 2.5)
    readonly property real pulseScaleAnim: 0.00095 + pulseBlink * 0.00055

    // Resolved Node 1 Position (active in all programs)
    readonly property real dot1X: (massageProgram === "circular") ? circX :
                                  (massageProgram === "relax") ? zigzagX :
                                  (massageProgram === "recovery") ? squareX :
                                  (massageProgram === "rolling") ? -0.12 : -0.12
    readonly property real dot1Y: (massageProgram === "circular") ? circY :
                                  (massageProgram === "relax") ? zigzagY :
                                  (massageProgram === "recovery") ? squareY :
                                  (massageProgram === "rolling") ? rollY : 1.74
    readonly property real dot1Z: -0.64 - (dot1Y - 1.36) * 0.38 + 0.045

    // Resolved Node 2 Position (active in rolling & pulse)
    readonly property real dot2X: 0.12
    readonly property real dot2Y: (massageProgram === "rolling") ? rollY : 1.74
    readonly property real dot2Z: -0.64 - (dot2Y - 1.36) * 0.38 + 0.045

    // Resolved Node 3 Position (active in pulse, Lower Left)
    readonly property real dot3X: -0.12
    readonly property real dot3Y: 1.44
    readonly property real dot3Z: -0.64 - (dot3Y - 1.36) * 0.38 + 0.045

    // Resolved Node 4 Position (active in pulse, Lower Right)
    readonly property real dot4X: 0.12
    readonly property real dot4Y: 1.44
    readonly property real dot4Z: -0.64 - (dot4Y - 1.36) * 0.38 + 0.045

    // Firefly Bioluminescent Breathing Pulse
    readonly property real fireflyBreath: (massageProgram === "pulse") ?
        pulseBlink : Math.pow(Math.sin((massagePulse * 2.0) % 1.0 * Math.PI), 2.0)

    // Chronological Intro Sequences (Driven by SeatStudioView sequence: rotation -> blue color -> light glow)
    property real massageBlueIntro: node.massageActive ? 1.0 : 0.0
    property real massageFireflyIntro: node.massageActive ? 1.0 : 0.0

    // 1. Lumbar Support Restored Setting Glow Material (Seat Mode)
    PrincipledMaterial {
        id: lumbarGlowMaterial
        objectName: "LumbarGlowMaterial"
        lighting: PrincipledMaterial.NoLighting
        baseColor: "#00E5FF" // vivid electric cyan highlight
        emissiveFactor: Qt.vector3d(
            0.6 + node.lumbarMidLevel * 0.8,
            1.8 + node.lumbarMidLevel * 1.6,
            2.8 + node.lumbarMidLevel * 2.2
        )
        opacity: (!node.massageActive && (node.selectedZone === "lumbar_mid" || node.selectedZone === "lumbar_upper" || node.selectedZone === "lumbar_lower")) ? 0.94 : 0.0
        Behavior on opacity {
            NumberAnimation { duration: 380; easing.type: Easing.InOutQuad }
        }
        alphaMode: PrincipledMaterial.Blend
        cullMode: PrincipledMaterial.NoCulling
    }

    // 2. Object 36 Middle Backrest Contour Material
    // In Massage mode: expanded, rich electric cyan-blue lumbar luminescence with visible leather grain!
    // In Seat mode: lights up for active lumbar zone when selected.
    PrincipledMaterial {
        id: object36GlowMaterial
        objectName: "Object36GlowMaterial"
        baseColor: node.massageActive ? "#10325c" :
                   ((node.selectedZone === "lumbar_upper" || node.selectedZone === "lumbar_mid" || node.selectedZone === "lumbar_lower") && !node.isDimmed ? "#122035" : "#181b22")
        metalness: 0.12
        roughness: 0.35
        normalMap: _3_texture
        metalnessMap: _2_texture
        roughnessMap: _2_texture
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque

        emissiveFactor: {
            if (node.massageActive && node.massageBlueIntro > 0.001) {
                var wave = Math.sin(node.massagePulse * Math.PI * 2) * 0.5 + 0.5;
                var intensityMul = (1.1 + node.massageIntensity * 0.30) * node.massageBlueIntro;
                return Qt.vector3d(
                    0.020 * node.massageBlueIntro,
                    (0.160 + 0.080 * wave) * intensityMul,
                    (0.460 + 0.160 * wave) * intensityMul
                );
            } else if ((node.selectedZone === "lumbar_upper" || node.selectedZone === "lumbar_mid" || node.selectedZone === "lumbar_lower") && !node.isDimmed) {
                var lvl = (node.selectedZone === "lumbar_upper") ? node.lumbarUpperLevel :
                          (node.selectedZone === "lumbar_mid") ? node.lumbarMidLevel : node.lumbarLowerLevel;
                var lLevel = 0.3 + lvl * 0.6;
                return Qt.vector3d(0.002 * lLevel, 0.045 * lLevel, 0.120 * lLevel);
            } else {
                return Qt.vector3d(0.0, 0.0, 0.0);
            }
        }
    }

    // Cushion Glow Material for Bottom Cushion (active when cushion_left or cushion_right is selected in Seat mode)
    PrincipledMaterial {
        id: cushionGlowMaterial
        objectName: "CushionGlowMaterial"
        baseColor: "#14253e"
        metalnessMap: _2_texture
        roughnessMap: _2_texture
        metalness: 0.15
        roughness: 0.25
        normalMap: _3_texture
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
        emissiveFactor: {
            var cLvl = (node.selectedZone === "cushion_left") ? node.cushionLeftLevel : node.cushionRightLevel;
            var cLevel = 0.3 + cLvl * 0.6;
            return Qt.vector3d(0.002 * cLevel, 0.045 * cLevel, 0.120 * cLevel);
        }
    }

    // 3. Firefly Intense Bioluminescent Core (Glows like a real firefly)
    PrincipledMaterial {
        id: fireflyCoreMaterial
        objectName: "FireflyCoreMaterial"
        lighting: PrincipledMaterial.NoLighting
        baseColor: "#FFFFFF"
        emissiveFactor: Qt.vector3d(
            8.0 + fireflyBreath * 4.0,
            12.0 + fireflyBreath * 4.0,
            16.0 + fireflyBreath * 5.0
        )
        opacity: (node.massageActive && node.massageFireflyIntro > 0.001) ?
            (0.98 * node.massageFireflyIntro) : 0.0
        Behavior on opacity {
            NumberAnimation { duration: 250 }
        }
        alphaMode: PrincipledMaterial.Opaque
        cullMode: PrincipledMaterial.NoCulling
    }

    // 4. Real 3D Firefly Bloom Flare Material (Mapped from firefly_bloom.png)
    PrincipledMaterial {
        id: fireflyBloomMaterial
        objectName: "FireflyBloomMaterial"
        lighting: PrincipledMaterial.NoLighting
        baseColorMap: fireflyBloomTexture
        emissiveMap: fireflyBloomTexture
        emissiveFactor: Qt.vector3d(
            4.0 + fireflyBreath * 3.0,
            7.0 + fireflyBreath * 4.0,
            12.0 + fireflyBreath * 5.0
        )
        opacity: (node.massageActive && node.massageFireflyIntro > 0.001) ?
            ((0.92 + 0.08 * fireflyBreath) * node.massageFireflyIntro) : 0.0
        alphaMode: PrincipledMaterial.Blend
        cullMode: PrincipledMaterial.NoCulling
        depthDrawMode: PrincipledMaterial.NeverDepthDraw
    }

    // 5. Firefly Soft Radiant Luminous Halo Sphere
    PrincipledMaterial {
        id: fireflyHaloMaterial
        objectName: "FireflyHaloMaterial"
        lighting: PrincipledMaterial.NoLighting
        baseColor: "#00E5FF"
        emissiveFactor: Qt.vector3d(
            2.5 + fireflyBreath * 2.0,
            5.0 + fireflyBreath * 3.0,
            9.0 + fireflyBreath * 4.0
        )
        opacity: (node.massageActive && node.massageFireflyIntro > 0.001) ?
            ((0.60 + 0.35 * fireflyBreath) * node.massageFireflyIntro) : 0.0
        alphaMode: PrincipledMaterial.Blend
        cullMode: PrincipledMaterial.NoCulling
        depthDrawMode: PrincipledMaterial.NeverDepthDraw
    }

    // 6. Thigh / Cushion Extension Glow Material
    PrincipledMaterial {
        id: thighGlowMaterial
        objectName: "ThighGlowMaterial"
        lighting: PrincipledMaterial.NoLighting
        baseColor: "#00E5FF"
        emissiveFactor: Qt.vector3d(
            0.6 + node.cushionLeftLevel * 0.8,
            1.8 + node.cushionLeftLevel * 1.6,
            2.8 + node.cushionLeftLevel * 2.2
        )
        opacity: ((node.selectedZone === "cushion_left" || node.selectedZone === "cushion_right") && !node.massageActive) ? 0.94 : 0.0
        Behavior on opacity {
            NumberAnimation { duration: 350; easing.type: Easing.InOutQuad }
        }
        alphaMode: PrincipledMaterial.Blend
        cullMode: PrincipledMaterial.NoCulling
    }

    // Nodes:
    Node {
        id: root
        objectName: "ROOT"

        // Seat Frame / Casing
        Model {
            id: object_30_Seat
            objectName: "Object_30_Seat"
            source: "meshes/object_30_FrontDriverMesh_mesh.mesh"
            materials: [
                meshesuntitled41Mtl_material
            ]
        }

        // ---------------------------------------------------------------------
        // Object_36: Split into Bottom Cushion & Middle Backrest
        // Bottom Cushion: Clean dark leather, glows blue when Cushion zones selected
        // Middle Backrest: Rich glowing blue in Massage mode (expanded lumbar), or when Lumbar zones selected
        // ---------------------------------------------------------------------
        Model {
            id: object_36_Cushion
            objectName: "Object_36_Cushion"
            source: "meshes/object_36_CushionMesh_mesh.mesh"
            materials: [
                ((node.selectedZone === "cushion_left" || node.selectedZone === "cushion_right") && !node.massageActive && !node.isDimmed) ?
                    cushionGlowMaterial : meshesuntitled71Mtl_material
            ]
        }

        Model {
            id: object_36_Backrest
            objectName: "Object_36_Backrest"
            source: "meshes/object_36_BackrestMesh_mesh.mesh"
            materials: [
                (node.massageActive || ((node.selectedZone === "lumbar_upper" || node.selectedZone === "lumbar_mid" || node.selectedZone === "lumbar_lower") && !node.isDimmed)) ?
                    object36GlowMaterial : meshesuntitled71Mtl_material
            ]
        }

        // Frosted Plastic Side Controls & Base Trim
        Model {
            id: object_77_Seat
            objectName: "Object_77_Seat"
            source: "meshes/object_77_FrontDriverMesh_mesh.mesh"
            visible: true
            materials: [
                meshesuntitled2carbodyfrostedplastic50021Mtl_material
            ]
        }

        // Perforated Leather Cushions & Backrest
        Model {
            id: object_85_Seat
            objectName: "Object_85_Seat"
            source: "meshes/object_85_FrontDriverMesh_mesh.mesh"
            materials: [
                meshesuntitled3carbodyleather20021Mtl_material
            ]
        }

        // ---------------------------------------------------------------------
        // Dynamic Firefly Glowing Dots per Program with Real 3D Optical Bloom:
        // - circular: 1 dot rotating circular
        // - relax (regular): 1 dot zigzagging
        // - recovery: 1 dot in square style
        // - rolling: 2 dots going straight up and down
        // - pulse: 4 dots blinking
        // ---------------------------------------------------------------------

        // Dot 1 (Firefly 1 - Active in all programs)
        Model {
            id: fireflyCore1
            objectName: "FireflyCore1"
            source: "#Sphere"
            visible: !node.isDimmed && node.massageActive && (node.massageFireflyIntro > 0.001)
            position: Qt.vector3d(node.dot1X, node.dot1Y, node.dot1Z)
            scale: Qt.vector3d(
                (node.massageProgram === "pulse" ? node.pulseScaleAnim * 0.7 : 0.0009) * (0.85 + node.massageIntensity * 0.15),
                (node.massageProgram === "pulse" ? node.pulseScaleAnim * 0.7 : 0.0009) * (0.85 + node.massageIntensity * 0.15),
                0.0005
            )
            materials: [ fireflyCoreMaterial ]
        }

        Model {
            id: fireflyHalo1
            objectName: "FireflyHalo1"
            source: "#Sphere"
            visible: !node.isDimmed && node.massageActive && (node.massageFireflyIntro > 0.001)
            position: Qt.vector3d(node.dot1X, node.dot1Y, node.dot1Z)
            scale: Qt.vector3d(
                (node.massageProgram === "pulse" ? node.pulseScaleAnim * 1.3 : 0.0018) * (0.85 + node.massageIntensity * 0.15),
                (node.massageProgram === "pulse" ? node.pulseScaleAnim * 1.3 : 0.0018) * (0.85 + node.massageIntensity * 0.15),
                0.0008
            )
            materials: [ fireflyHaloMaterial ]
        }

        Model {
            id: fireflyBloom1
            objectName: "FireflyBloom1"
            source: "#Rectangle"
            visible: !node.isDimmed && node.massageActive && (node.massageFireflyIntro > 0.001)
            position: Qt.vector3d(node.dot1X, node.dot1Y, node.dot1Z + 0.010)
            eulerRotation: Qt.vector3d(-20, 0, 0)
            scale: Qt.vector3d(
                (node.massageProgram === "pulse" ? node.pulseScaleAnim * 1.5 : 0.0016) * (0.85 + node.massageIntensity * 0.15),
                (node.massageProgram === "pulse" ? node.pulseScaleAnim * 1.5 : 0.0016) * (0.85 + node.massageIntensity * 0.15),
                1.0
            )
            materials: [ fireflyBloomMaterial ]
        }

        PointLight {
            id: fireflyPointLight1
            visible: !node.isDimmed && node.massageActive && (node.massageFireflyIntro > 0.001)
            position: Qt.vector3d(node.dot1X, node.dot1Y, node.dot1Z + 0.025)
            color: "#38BDF8"
            brightness: (1.1 + 0.9 * node.fireflyBreath) * (0.7 + node.massageIntensity * 0.3) * node.massageFireflyIntro
            linearFade: 2.0
            quadraticFade: 3.5
            castsShadow: false
        }

        // Dot 2 (Firefly 2 - Active in rolling and pulse)
        Model {
            id: fireflyCore2
            objectName: "FireflyCore2"
            source: "#Sphere"
            visible: !node.isDimmed && node.massageActive && (node.massageProgram === "rolling" || node.massageProgram === "pulse") && (node.massageFireflyIntro > 0.001)
            position: Qt.vector3d(node.dot2X, node.dot2Y, node.dot2Z)
            scale: Qt.vector3d(
                (node.massageProgram === "pulse" ? node.pulseScaleAnim * 0.7 : 0.0009) * (0.85 + node.massageIntensity * 0.15),
                (node.massageProgram === "pulse" ? node.pulseScaleAnim * 0.7 : 0.0009) * (0.85 + node.massageIntensity * 0.15),
                0.0005
            )
            materials: [ fireflyCoreMaterial ]
        }

        Model {
            id: fireflyHalo2
            objectName: "FireflyHalo2"
            source: "#Sphere"
            visible: !node.isDimmed && node.massageActive && (node.massageProgram === "rolling" || node.massageProgram === "pulse") && (node.massageFireflyIntro > 0.001)
            position: Qt.vector3d(node.dot2X, node.dot2Y, node.dot2Z)
            scale: Qt.vector3d(
                (node.massageProgram === "pulse" ? node.pulseScaleAnim * 1.3 : 0.0018) * (0.85 + node.massageIntensity * 0.15),
                (node.massageProgram === "pulse" ? node.pulseScaleAnim * 1.3 : 0.0018) * (0.85 + node.massageIntensity * 0.15),
                0.0008
            )
            materials: [ fireflyHaloMaterial ]
        }

        Model {
            id: fireflyBloom2
            objectName: "FireflyBloom2"
            source: "#Rectangle"
            visible: !node.isDimmed && node.massageActive && (node.massageProgram === "rolling" || node.massageProgram === "pulse") && (node.massageFireflyIntro > 0.001)
            position: Qt.vector3d(node.dot2X, node.dot2Y, node.dot2Z + 0.010)
            eulerRotation: Qt.vector3d(-20, 0, 0)
            scale: Qt.vector3d(
                (node.massageProgram === "pulse" ? node.pulseScaleAnim * 1.5 : 0.0016) * (0.85 + node.massageIntensity * 0.15),
                (node.massageProgram === "pulse" ? node.pulseScaleAnim * 1.5 : 0.0016) * (0.85 + node.massageIntensity * 0.15),
                1.0
            )
            materials: [ fireflyBloomMaterial ]
        }

        PointLight {
            id: fireflyPointLight2
            visible: !node.isDimmed && node.massageActive && (node.massageProgram === "rolling" || node.massageProgram === "pulse") && (node.massageFireflyIntro > 0.001)
            position: Qt.vector3d(node.dot2X, node.dot2Y, node.dot2Z + 0.025)
            color: "#38BDF8"
            brightness: (1.1 + 0.9 * node.fireflyBreath) * (0.7 + node.massageIntensity * 0.3) * node.massageFireflyIntro
            linearFade: 2.0
            quadraticFade: 3.5
            castsShadow: false
        }

        // Dot 3 (Firefly 3 - Active in pulse, Lower Left)
        Model {
            id: fireflyCore3
            objectName: "FireflyCore3"
            source: "#Sphere"
            visible: !node.isDimmed && node.massageActive && (node.massageProgram === "pulse") && (node.massageFireflyIntro > 0.001)
            position: Qt.vector3d(node.dot3X, node.dot3Y, node.dot3Z)
            scale: Qt.vector3d(
                node.pulseScaleAnim * 0.7 * (0.85 + node.massageIntensity * 0.15),
                node.pulseScaleAnim * 0.7 * (0.85 + node.massageIntensity * 0.15),
                0.0005
            )
            materials: [ fireflyCoreMaterial ]
        }

        Model {
            id: fireflyHalo3
            objectName: "FireflyHalo3"
            source: "#Sphere"
            visible: !node.isDimmed && node.massageActive && (node.massageProgram === "pulse") && (node.massageFireflyIntro > 0.001)
            position: Qt.vector3d(node.dot3X, node.dot3Y, node.dot3Z)
            scale: Qt.vector3d(
                node.pulseScaleAnim * 1.3 * (0.85 + node.massageIntensity * 0.15),
                node.pulseScaleAnim * 1.3 * (0.85 + node.massageIntensity * 0.15),
                0.0008
            )
            materials: [ fireflyHaloMaterial ]
        }

        Model {
            id: fireflyBloom3
            objectName: "FireflyBloom3"
            source: "#Rectangle"
            visible: !node.isDimmed && node.massageActive && (node.massageProgram === "pulse") && (node.massageFireflyIntro > 0.001)
            position: Qt.vector3d(node.dot3X, node.dot3Y, node.dot3Z + 0.010)
            eulerRotation: Qt.vector3d(-20, 0, 0)
            scale: Qt.vector3d(
                node.pulseScaleAnim * 1.5 * (0.85 + node.massageIntensity * 0.15),
                node.pulseScaleAnim * 1.5 * (0.85 + node.massageIntensity * 0.15),
                1.0
            )
            materials: [ fireflyBloomMaterial ]
        }

        PointLight {
            id: fireflyPointLight3
            visible: !node.isDimmed && node.massageActive && (node.massageProgram === "pulse") && (node.massageFireflyIntro > 0.001)
            position: Qt.vector3d(node.dot3X, node.dot3Y, node.dot3Z + 0.025)
            color: "#38BDF8"
            brightness: (1.1 + 0.9 * node.fireflyBreath) * (0.7 + node.massageIntensity * 0.3) * node.massageFireflyIntro
            linearFade: 2.0
            quadraticFade: 3.5
            castsShadow: false
        }

        // Dot 4 (Firefly 4 - Active in pulse, Lower Right)
        Model {
            id: fireflyCore4
            objectName: "FireflyCore4"
            source: "#Sphere"
            visible: !node.isDimmed && node.massageActive && (node.massageProgram === "pulse") && (node.massageFireflyIntro > 0.001)
            position: Qt.vector3d(node.dot4X, node.dot4Y, node.dot4Z)
            scale: Qt.vector3d(
                node.pulseScaleAnim * 0.7 * (0.85 + node.massageIntensity * 0.15),
                node.pulseScaleAnim * 0.7 * (0.85 + node.massageIntensity * 0.15),
                0.0005
            )
            materials: [ fireflyCoreMaterial ]
        }

        Model {
            id: fireflyHalo4
            objectName: "FireflyHalo4"
            source: "#Sphere"
            visible: !node.isDimmed && node.massageActive && (node.massageProgram === "pulse") && (node.massageFireflyIntro > 0.001)
            position: Qt.vector3d(node.dot4X, node.dot4Y, node.dot4Z)
            scale: Qt.vector3d(
                node.pulseScaleAnim * 1.3 * (0.85 + node.massageIntensity * 0.15),
                node.pulseScaleAnim * 1.3 * (0.85 + node.massageIntensity * 0.15),
                0.0008
            )
            materials: [ fireflyHaloMaterial ]
        }

        Model {
            id: fireflyBloom4
            objectName: "FireflyBloom4"
            source: "#Rectangle"
            visible: !node.isDimmed && node.massageActive && (node.massageProgram === "pulse") && (node.massageFireflyIntro > 0.001)
            position: Qt.vector3d(node.dot4X, node.dot4Y, node.dot4Z + 0.010)
            eulerRotation: Qt.vector3d(-20, 0, 0)
            scale: Qt.vector3d(
                node.pulseScaleAnim * 1.5 * (0.85 + node.massageIntensity * 0.15),
                node.pulseScaleAnim * 1.5 * (0.85 + node.massageIntensity * 0.15),
                1.0
            )
            materials: [ fireflyBloomMaterial ]
        }

        PointLight {
            id: fireflyPointLight4
            visible: !node.isDimmed && node.massageActive && (node.massageProgram === "pulse") && (node.massageFireflyIntro > 0.001)
            position: Qt.vector3d(node.dot4X, node.dot4Y, node.dot4Z + 0.025)
            color: "#38BDF8"
            brightness: (1.1 + 0.9 * node.fireflyBreath) * (0.7 + node.massageIntensity * 0.3) * node.massageFireflyIntro
            linearFade: 2.0
            quadraticFade: 3.5
            castsShadow: false
        }

        // Front Seat Base / Thigh Extension Selected Glow Highlight
        Model {
            id: object_Thigh_Highlight
            objectName: "Object_Thigh_Highlight"
            source: "meshes/object_Thigh_HighlightMesh_mesh.mesh"
            visible: !node.isDimmed && ((node.selectedZone === "cushion_left" || node.selectedZone === "cushion_right") && !node.massageActive)
            materials: [
                thighGlowMaterial
            ]
        }

        // ---------------------------------------------------------------------
        // Area-Based Blue Illumination Lights (Only 1 active at a time in Seat Mode)
        // 3 Parts in Lumbar (Backrest spine)
        // 2 Parts in Cushion (Seat base left and right)
        // ---------------------------------------------------------------------
        // 1. Upper Lumbar Area Light
        PointLight {
            id: upperLumbarAreaLight
            visible: !node.isDimmed && !node.massageActive && node.selectedZone === "lumbar_upper"
            position: Qt.vector3d(0.0, 1.82, -0.92)
            color: "#38BDF8"
            brightness: 2.2 + node.lumbarUpperLevel * 1.8
            linearFade: 1.2
            quadraticFade: 2.0
            castsShadow: false
        }

        // 2. Mid Lumbar Area Light
        PointLight {
            id: midLumbarAreaLight
            visible: !node.isDimmed && !node.massageActive && node.selectedZone === "lumbar_mid"
            position: Qt.vector3d(0.0, 1.56, -0.78)
            color: "#38BDF8"
            brightness: 2.2 + node.lumbarMidLevel * 1.8
            linearFade: 1.2
            quadraticFade: 2.0
            castsShadow: false
        }

        // 3. Lower Lumbar Area Light
        PointLight {
            id: lowerLumbarAreaLight
            visible: !node.isDimmed && !node.massageActive && node.selectedZone === "lumbar_lower"
            position: Qt.vector3d(0.0, 1.24, -0.62)
            color: "#38BDF8"
            brightness: 2.2 + node.lumbarLowerLevel * 1.8
            linearFade: 1.2
            quadraticFade: 2.0
            castsShadow: false
        }

        // 4. Left Cushion Area Light (Bottom Seat Cushion Left)
        PointLight {
            id: leftCushionAreaLight
            visible: !node.isDimmed && !node.massageActive && node.selectedZone === "cushion_left"
            position: Qt.vector3d(-0.24, 0.88, 0.38)
            color: "#38BDF8"
            brightness: 2.2 + node.cushionLeftLevel * 1.8
            linearFade: 1.2
            quadraticFade: 2.0
            castsShadow: false
        }

        // 5. Right Cushion Area Light (Bottom Seat Cushion Right)
        PointLight {
            id: rightCushionAreaLight
            visible: !node.isDimmed && !node.massageActive && node.selectedZone === "cushion_right"
            position: Qt.vector3d(0.24, 0.88, 0.38)
            color: "#38BDF8"
            brightness: 2.2 + node.cushionRightLevel * 1.8
            linearFade: 1.2
            quadraticFade: 2.0
            castsShadow: false
        }

        // ---------------------------------------------------------------------
        // Massage Mode Expanded Lumbar Illumination Lights
        // Controlled, refined lighting tailored to the lumbar backrest with expanded lower lumbar coverage
        // ---------------------------------------------------------------------
        PointLight {
            id: massageUpperLight
            visible: !node.isDimmed && node.massageActive && (node.massageBlueIntro > 0.001)
            position: Qt.vector3d(0.0, 1.70, -0.70)
            color: "#38BDF8"
            brightness: 2.0 * node.massageBlueIntro * (0.85 + node.massageIntensity * 0.20)
            linearFade: 1.1
            quadraticFade: 1.8
            castsShadow: false
        }

        PointLight {
            id: massageMidLight
            visible: !node.isDimmed && node.massageActive && (node.massageBlueIntro > 0.001)
            position: Qt.vector3d(0.0, 1.48, -0.62)
            color: "#00E5FF"
            brightness: 2.2 * node.massageBlueIntro * (0.85 + node.massageIntensity * 0.20)
            linearFade: 1.0
            quadraticFade: 1.6
            castsShadow: false
        }

        PointLight {
            id: massageLowerLumbarLight
            visible: !node.isDimmed && node.massageActive && (node.massageBlueIntro > 0.001)
            position: Qt.vector3d(0.0, 1.22, -0.56)
            color: "#00E5FF"
            brightness: 2.8 * node.massageBlueIntro * (0.85 + node.massageIntensity * 0.20)
            linearFade: 0.9
            quadraticFade: 1.4
            castsShadow: false
        }
    }
}
