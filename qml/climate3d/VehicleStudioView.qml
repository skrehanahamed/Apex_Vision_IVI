/**
 * ==============================================================================
 * Project: Apex VISION IVI - Digital Cockpit & Infotainment System
 * File: VehicleStudioView.qml
 * Author / Developer: Sk Rehan Ahamed
 * License: MIT
 * ==============================================================================
 */

import QtQuick
import QtQuick3D
import QtQuick3D.Helpers
import "CarModel"

Item {
    id: root
    anchors.fill: parent
    implicitWidth: 1240
    implicitHeight: 1128

    // Pure Luxury Satin Pearl White Automotive Paint (Velvety smooth satin-metallic matching reference)
    property color paintColor: "#EDF2F7"
    property real metalness: 0.18
    property real roughness: 0.24
    property real clearcoat: 0.75
    property bool lightsOn: true

    // Ambient Lighting Mode & Controls
    property bool ambientMode: false
    property color ambientColor: "#A855F7"
    property real ambientBrightness: 0.85
    property bool ambientOn: true

    // Vehicle Status Mode & Controls (Tire Pressure & Oil Life)
    property bool statusMode: false
    property string statusTab: "tire" // "tire" | "oil"

    // Status Mode Locked Pose (Pitch -30° / Yaw 190° / Roll -4.5°, comfortably lowered car position and refined scale)
    property real statusTirePosX: 0.0
    property real statusTirePosY: 0.0
    property real statusTirePosZ: 0.8
    property real statusTirePitch: -30.0
    property real statusTireYaw: 188.0
    property real statusTireRoll: -4.5
    property real statusTireCamX: -1.95
    property real statusTireCamY: -0.30
    property real statusTireCamZ: 11.8
    property real statusTireCamPitch: 0.0
    property real statusTireFov: 28.5
    property real statusTireScale: 0.210

    onStatusTireCamXChanged: if (statusMode && statusTab === "tire") updateCameraPosition(false)
    onStatusTireCamYChanged: if (statusMode && statusTab === "tire") updateCameraPosition(false)
    onStatusTireCamZChanged: if (statusMode && statusTab === "tire") updateCameraPosition(false)
    onStatusOilCamXChanged: if (statusMode && statusTab === "oil") updateCameraPosition(false)
    onStatusOilCamYChanged: if (statusMode && statusTab === "oil") updateCameraPosition(false)
    onStatusOilCamZChanged: if (statusMode && statusTab === "oil") updateCameraPosition(false)

    property real statusOilPosX: 0.0
    property real statusOilPosY: 0.15
    property real statusOilPosZ: 2.55
    property real statusOilPitch: -78.0
    property real statusOilYaw: 180.0
    property real statusOilRoll: 0.0
    property real statusOilCamX: -1.70
    property real statusOilCamY: 0.0
    property real statusOilCamZ: 11.5
    property real statusOilCamPitch: 0.0
    property real statusOilFov: 28.0
    property real statusOilScale: 0.240






    // Expose 3D references and tire tracking functions
    readonly property alias carModelRef: carModel
    readonly property alias view3DRef: view3D

    function getTireScreenCoord(tireNode) {
        if (!tireNode || !view3D) return Qt.point(-1, -1);
        try {
            var b = tireNode.bounds;
            if (b && b.minimum && b.maximum) {
                var localCenter = Qt.vector3d(
                    (b.minimum.x + b.maximum.x) * 0.5,
                    (b.minimum.y + b.maximum.y) * 0.5,
                    (b.minimum.z + b.maximum.z) * 0.5
                );
                var scenePos = tireNode.mapPositionToScene(localCenter);
                return view3D.mapFrom3DScene(scenePos);
            }
        } catch (e) {}
        return Qt.point(-1, -1);
    }

    Vector3dAnimation {
        id: camStatusAnim
        target: mainCamera
        property: "position"
        duration: 680
        easing.type: Easing.InOutCubic
    }


    onStatusTabChanged: {
        if (statusMode) {
            updateCameraPosition(true);
        }
    }

    function updateCameraPosition(animate) {
        if (statusMode) {
            var isOil = (root.statusTab === "oil");
            var cx = isOil ? statusOilCamX : statusTireCamX;
            var cy = isOil ? statusOilCamY : statusTireCamY;
            var cz = isOil ? statusOilCamZ : statusTireCamZ;
            var targetPos = Qt.vector3d(cx, cy, cz);
            if (animate) {
                camStatusAnim.stop();
                camStatusAnim.to = targetPos;
                camStatusAnim.restart();
            } else {
                camStatusAnim.stop();
                mainCamera.position = targetPos;
            }
        }
    }

    function adjustStatusParam(param, delta) {
        var isOil = (root.statusTab === "oil");
        if (param === "posX") {
            if (isOil) statusOilPosX = Number((statusOilPosX + delta).toFixed(3));
            else statusTirePosX = Number((statusTirePosX + delta).toFixed(3));
        } else if (param === "posY") {
            if (isOil) statusOilPosY = Number((statusOilPosY + delta).toFixed(3));
            else statusTirePosY = Number((statusTirePosY + delta).toFixed(3));
        } else if (param === "posZ") {
            if (isOil) statusOilPosZ = Number((statusOilPosZ + delta).toFixed(3));
            else statusTirePosZ = Number((statusTirePosZ + delta).toFixed(3));
        } else if (param === "pitch") {
            if (isOil) statusOilPitch = Number((statusOilPitch + delta).toFixed(1));
            else statusTirePitch = Number((statusTirePitch + delta).toFixed(1));
        } else if (param === "yaw") {
            if (isOil) statusOilYaw = Number((((statusOilYaw + delta) % 360 + 360) % 360).toFixed(1));
            else statusTireYaw = Number((((statusTireYaw + delta) % 360 + 360) % 360).toFixed(1));
        } else if (param === "roll") {
            if (isOil) statusOilRoll = Number((statusOilRoll + delta).toFixed(1));
            else statusTireRoll = Number((statusTireRoll + delta).toFixed(1));
        } else if (param === "camX") {
            if (isOil) statusOilCamX = Number((statusOilCamX + delta).toFixed(3));
            else statusTireCamX = Number((statusTireCamX + delta).toFixed(3));
            updateCameraPosition(false);
        } else if (param === "camY") {
            if (isOil) statusOilCamY = Number((statusOilCamY + delta).toFixed(3));
            else statusTireCamY = Number((statusTireCamY + delta).toFixed(3));
            updateCameraPosition(false);
        } else if (param === "camZ") {
            if (isOil) statusOilCamZ = Number((statusOilCamZ + delta).toFixed(3));
            else statusTireCamZ = Number((statusTireCamZ + delta).toFixed(3));
            updateCameraPosition(false);
        } else if (param === "camPitch") {
            if (isOil) statusOilCamPitch = Number((statusOilCamPitch + delta).toFixed(1));
            else statusTireCamPitch = Number((statusTireCamPitch + delta).toFixed(1));
        } else if (param === "fov") {
            if (isOil) statusOilFov = Number(Math.max(10, Math.min(75, statusOilFov + delta)).toFixed(1));
            else statusTireFov = Number(Math.max(10, Math.min(75, statusTireFov + delta)).toFixed(1));
        } else if (param === "scale") {
            if (isOil) statusOilScale = Number(Math.max(0.10, Math.min(0.60, statusOilScale + delta)).toFixed(3));
            else statusTireScale = Number(Math.max(0.10, Math.min(0.60, statusTireScale + delta)).toFixed(3));
        }
    }

    function applyPreset(presetName) {
        var isOil = (root.statusTab === "oil");
        if (presetName === "topDown") {
            if (isOil) { statusOilPitch = -89.5; statusOilYaw = 180.0; statusOilRoll = 0.0; statusOilCamPitch = 0.0; }
            else { statusTirePitch = -89.5; statusTireYaw = 180.0; statusTireRoll = 0.0; statusTireCamPitch = 0.0; }
        } else if (presetName === "rearTop") {
            if (isOil) { statusOilPitch = -68.0; statusOilYaw = 180.0; statusOilRoll = 0.0; statusOilCamPitch = 0.0; }
            else { statusTirePitch = -68.0; statusTireYaw = 180.0; statusTireRoll = 0.0; statusTireCamPitch = 0.0; }
        } else if (presetName === "frontHood") {
            if (isOil) { statusOilPitch = -52.0; statusOilYaw = 180.0; statusOilRoll = 0.0; statusOilCamPitch = 0.0; }
            else { statusTirePitch = -52.0; statusTireYaw = 180.0; statusTireRoll = 0.0; statusTireCamPitch = 0.0; }
        } else if (presetName === "sideLeft") {
            if (isOil) { statusOilPitch = -6.0; statusOilYaw = 90.0; statusOilRoll = 0.0; statusOilCamPitch = 0.0; }
            else { statusTirePitch = -6.0; statusTireYaw = 90.0; statusTireRoll = 0.0; statusTireCamPitch = 0.0; }
        } else if (presetName === "sideRight") {
            if (isOil) { statusOilPitch = -6.0; statusOilYaw = 270.0; statusOilRoll = 0.0; statusOilCamPitch = 0.0; }
            else { statusTirePitch = -6.0; statusTireYaw = 270.0; statusTireRoll = 0.0; statusTireCamPitch = 0.0; }
        } else if (presetName === "isometric") {
            if (isOil) { statusOilPitch = -35.0; statusOilYaw = 145.0; statusOilRoll = 0.0; statusOilCamPitch = 0.0; }
            else { statusTirePitch = -35.0; statusTireYaw = 145.0; statusTireRoll = 0.0; statusTireCamPitch = 0.0; }
        } else if (presetName === "frontQuarter") {
            if (isOil) { statusOilPitch = -18.0; statusOilYaw = 215.0; statusOilRoll = 0.0; statusOilCamPitch = 0.0; }
            else { statusTirePitch = -18.0; statusTireYaw = 215.0; statusTireRoll = 0.0; statusTireCamPitch = 0.0; }
        } else if (presetName === "rearQuarter") {
            if (isOil) { statusOilPitch = -22.0; statusOilYaw = 135.0; statusOilRoll = 0.0; statusOilCamPitch = 0.0; }
            else { statusTirePitch = -22.0; statusTireYaw = 135.0; statusTireRoll = 0.0; statusTireCamPitch = 0.0; }
        } else if (presetName === "reset") {
            if (isOil) {
                statusOilPosX = 0.0; statusOilPosY = -0.35; statusOilPosZ = 1.20;
                statusOilPitch = -52.0; statusOilYaw = 180.0; statusOilRoll = 0.0;
                statusOilCamX = -1.95; statusOilCamY = 0.0; statusOilCamZ = 11.5;
                statusOilCamPitch = 0.0;
                statusOilFov = 28.0;
                statusOilScale = 0.24;
            } else {
                statusTirePosX = 0.0; statusTirePosY = 0.20; statusTirePosZ = -0.25;
                statusTirePitch = -68.0; statusTireYaw = 180.0; statusTireRoll = 0.0;
                statusTireCamX = -1.95; statusTireCamY = 0.0; statusTireCamZ = 11.5;
                statusTireCamPitch = 0.0;
                statusTireFov = 28.0;
                statusTireScale = 0.21;
            }
        }
        updateCameraPosition(true);
    }

    function printCurrentStatusPose() {
        var isOil = (root.statusTab === "oil");
        var tabName = isOil ? "OIL LIFE" : "TIRE PRESSURE";
        var px = isOil ? statusOilPosX : statusTirePosX;
        var py = isOil ? statusOilPosY : statusTirePosY;
        var pz = isOil ? statusOilPosZ : statusTirePosZ;
        var pitch = isOil ? statusOilPitch : statusTirePitch;
        var yaw = isOil ? statusOilYaw : statusTireYaw;
        var roll = isOil ? statusOilRoll : statusTireRoll;
        var cx = isOil ? statusOilCamX : statusTireCamX;
        var cy = isOil ? statusOilCamY : statusTireCamY;
        var cz = isOil ? statusOilCamZ : statusTireCamZ;
        var cp = isOil ? statusOilCamPitch : statusTireCamPitch;
        var fov = isOil ? statusOilFov : statusTireFov;
        var sc = isOil ? statusOilScale : statusTireScale;
        console.log("=====================================================================");
        console.log("[STATUS POSE CALIBRATION] " + tabName + ":");
        console.log("  cameraRig.position: Qt.vector3d(" + px + ", " + py + ", " + pz + ")");
        console.log("  cameraRig.eulerRotation: Qt.vector3d(" + pitch + ", " + yaw + ", " + roll + ")");
        console.log("  mainCamera.position: Qt.vector3d(" + cx + ", " + cy + ", " + cz + ")");
        console.log("  mainCamera.eulerRotation: Qt.vector3d(" + cp + ", 0.0, 0.0)");
        console.log("  mainCamera.fieldOfView: " + fov);
        console.log("  carModel.scale: Qt.vector3d(" + sc + ", " + sc + ", " + sc + ")");
        console.log("=====================================================================");
        return "Logged " + tabName + " (" + px + ", " + py + ", " + pz + ") CamZ: " + cz;
    }

    // Locked Hero Pose Target Values (Full-screen viewport with car positioned in right workspace)
    readonly property real heroYaw: 42.0
    readonly property real heroPitch: -4.5
    readonly property real heroCameraZ: 11.5
    readonly property real heroPosY: 0.56
    readonly property real heroCamOffsetX: -2.10
    readonly property real ambientCamOffsetX: -0.78
    readonly property real ambientCamOffsetY: -0.08

    // Single-Axis Rotation State (Only yaw rotates horizontally, pitch is strictly locked)
    property real currentYaw: heroYaw
    readonly property real currentPitch: heroPitch

    readonly property alias cameraZ: mainCamera.position.z

    // =========================================================================
    // Auto-Return to Nearest Initial Hero Pose after Inactivity
    // =========================================================================
    function getShortestAngleDiff(fromAngle, toAngle) {
        var diff = (toAngle - fromAngle) % 360;
        while (diff > 180) diff -= 360;
        while (diff < -180) diff += 360;
        return diff;
    }

    Timer {
        id: autoReturnTimer
        interval: 2500
        repeat: false
        onTriggered: {
            if (!rotateMouseArea.dragActive && !rotateMouseArea.inertiaActive && !root.ambientMode && !root.statusMode) {
                var diff = root.getShortestAngleDiff(root.currentYaw, root.heroYaw);
                resetYawAnim.from = root.currentYaw;
                resetYawAnim.to = root.currentYaw + diff;
                resetYawAnim.duration = Math.max(300, Math.min(650, Math.abs(diff) * 3.5));
                resetYawAnim.restart();
            }
        }
    }

    NumberAnimation {
        id: resetYawAnim
        target: root
        property: "currentYaw"
        easing.type: Easing.OutCubic
        onFinished: {
            root.currentYaw = root.heroYaw;
        }
    }

    // Delayed roof visibility so roof element removal is timed invisibly during camera flight
    property bool roofVisibleDelayed: true
    readonly property bool effectiveRoofVisible: root.roofVisibleDelayed

    Timer {
        id: hideRoofTimer
        interval: 240
        repeat: false
        onTriggered: {
            if (root.ambientMode) {
                root.roofVisibleDelayed = false;
            }
        }
    }

    property bool ambientFlightActive: false

    Timer {
        id: flightActiveTimer
        interval: 380
        repeat: false
        onTriggered: {
            root.ambientFlightActive = false;
        }
    }

    onAmbientModeChanged: {
        autoReturnTimer.stop();
        resetYawAnim.stop();
        rotateMouseArea.dragActive = false;
        rotateMouseArea.inertiaActive = false;
        rotateMouseArea.velocityX = 0.0;
        root.ambientFlightActive = true;
        flightActiveTimer.restart();

        if (ambientMode) {
            root.roofVisibleDelayed = true;
            hideRoofTimer.restart();
        } else {
            hideRoofTimer.stop();
            root.roofVisibleDelayed = true;
            root.currentYaw = root.heroYaw;
        }
    }

    onStatusModeChanged: {
        autoReturnTimer.stop();
        resetYawAnim.stop();
        rotateMouseArea.dragActive = false;
        rotateMouseArea.inertiaActive = false;
        rotateMouseArea.velocityX = 0.0;
        root.currentYaw = root.heroYaw;

        if (statusMode) {
            updateCameraPosition(true);
        } else if (!ambientMode) {
            camStatusAnim.stop();
            camStatusAnim.to = Qt.vector3d(root.heroCamOffsetX, 0.0, root.heroCameraZ);
            camStatusAnim.restart();
        }
    }

    // =========================================================================
    // 3D Viewport
    // =========================================================================
    View3D {
        id: view3D
        anchors.fill: parent
        camera: mainCamera

        environment: ExtendedSceneEnvironment {
            id: sceneEnv
            clearColor: "#00000000"
            backgroundMode: SceneEnvironment.Transparent
            antialiasingMode: SceneEnvironment.NoAA
            antialiasingQuality: SceneEnvironment.Medium
            tonemapMode: SceneEnvironment.TonemapModeLinear

            // Studio Light Probe for 360-degree environment reflections & ambient body illumination
            lightProbe: Texture {
                source: "assets/_Hall.ktx"
            }
            probeExposure: root.ambientMode ? 0.32 : 0.45
            Behavior on probeExposure { NumberAnimation { duration: 380; easing.type: Easing.OutCubic } }

            // Embedded Pi 5 GPU 60 FPS optimization: disable costly multi-pass full-screen bloom
            glowEnabled: false
        }

        // Camera Orbit Rig (Smooth flight between normal hero pose, ambient pose, and status poses)
        Node {
            id: cameraRig
            objectName: "cameraRig"
            position: root.ambientMode ?
                Qt.vector3d(0.0, 0.60, -0.35) :
                (root.statusMode ?
                    (root.statusTab === "oil" ?
                        Qt.vector3d(root.statusOilPosX, root.statusOilPosY, root.statusOilPosZ) :
                        Qt.vector3d(root.statusTirePosX, root.statusTirePosY, root.statusTirePosZ)) :
                    Qt.vector3d(0.0, root.heroPosY, 0.0))

            eulerRotation: root.ambientMode ?
                Qt.vector3d(-78.0, 180.0, 0.0) :
                (root.statusMode ?
                    (root.statusTab === "oil" ?
                        Qt.vector3d(root.statusOilPitch, root.statusOilYaw, root.statusOilRoll) :
                        Qt.vector3d(root.statusTirePitch, root.statusTireYaw, root.statusTireRoll)) :
                    Qt.vector3d(root.currentPitch, root.currentYaw, 0.0))

            Behavior on position {
                enabled: !statusTunerMouseArea.pressed
                Vector3dAnimation { duration: 380; easing.type: Easing.OutCubic }
            }
            Behavior on eulerRotation {
                enabled: !rotateMouseArea.dragActive && !rotateMouseArea.inertiaActive && !statusTunerMouseArea.pressed
                Vector3dAnimation { duration: 380; easing.type: Easing.OutCubic }
            }

            PerspectiveCamera {
                id: mainCamera
                position: root.ambientMode ?
                    Qt.vector3d(root.ambientCamOffsetX, root.ambientCamOffsetY, 4.7) :
                    Qt.vector3d(root.heroCamOffsetX, 0.0, root.heroCameraZ)

                Behavior on position {
                    Vector3dAnimation { duration: 380; easing.type: Easing.OutCubic }
                }

                eulerRotation: root.statusMode ?
                    (root.statusTab === "oil" ?
                        Qt.vector3d(root.statusOilCamPitch, 0.0, 0.0) :
                        Qt.vector3d(root.statusTireCamPitch, 0.0, 0.0)) :
                    Qt.vector3d(0.0, 0.0, 0.0)
                clipNear: 0.1
                clipFar: 180.0
                fieldOfView: root.ambientMode ? 28.0 : (root.statusMode ? (root.statusTab === "oil" ? root.statusOilFov : root.statusTireFov) : 27.0)

                Behavior on fieldOfView {
                    NumberAnimation { duration: 380; easing.type: Easing.OutCubic }
                }
                Behavior on eulerRotation {
                    Vector3dAnimation { duration: 380; easing.type: Easing.OutCubic }
                }
            }
        }

        // ---------------------------------------------------------------------
        // Studio Lighting Rig (Optimized 2-Light Setup for 60 FPS VideoCore VII GPU)
        // ---------------------------------------------------------------------
        // 1. Primary Key Light (Overhead & front fascia sculpting)
        DirectionalLight {
            id: primaryKeyLight
            eulerRotation: Qt.vector3d(-42, 35, 0)
            brightness: root.ambientMode ? 0.7 : 2.2
            color: "#FFFFFF"
            castsShadow: false
            Behavior on brightness { NumberAnimation { duration: 380; easing.type: Easing.OutCubic } }
        }

        // 2. Rim & Fill Light (Smooth continuous dimming to prevent shader re-compilation hitch)
        DirectionalLight {
            id: rimFillLight
            eulerRotation: Qt.vector3d(-28, -145, 0)
            brightness: root.ambientMode ? 0.25 : 1.6
            color: "#B4CEEE"
            castsShadow: false
            Behavior on brightness { NumberAnimation { duration: 380; easing.type: Easing.OutCubic } }
        }

        // ---------------------------------------------------------------------
        // 3D Car Model Node & Grand Studio Ground Shadow
        // ---------------------------------------------------------------------
        Node {
            id: carRoot
            position: Qt.vector3d(0.0, 0.0, 0.0)

            // Ground shadows (smooth opacity fade to prevent geometry drop)
            Node {
                id: groundShadowsContainer
                opacity: root.ambientMode ? 0.0 : 1.0
                scale: root.ambientMode ? Qt.vector3d(0.001, 0.001, 0.001) : Qt.vector3d(1.0, 1.0, 1.0)
                Behavior on opacity { NumberAnimation { duration: 380; easing.type: Easing.OutCubic } }

                // Consolidated 60 FPS Ground Contact Shadow Quad
                Model {
                    id: wideCastShadow
                    source: "#Rectangle"
                    position: Qt.vector3d(0.0, 0.001, 0.0)
                    eulerRotation: Qt.vector3d(-90, 0, 0)
                    scale: Qt.vector3d(0.036, 0.052, 1.0)
                    castsShadows: false
                    receivesShadows: false
                    materials: [
                        PrincipledMaterial {
                            lighting: PrincipledMaterial.NoLighting
                            baseColor: "#000000"
                            opacity: 0.82
                            opacityMap: Texture {
                                source: "images/CarGroundShadowBig.png"
                            }
                            opacityChannel: Material.A
                            alphaMode: PrincipledMaterial.Blend
                            cullMode: PrincipledMaterial.NoCulling
                        }
                    ]
                }
            }

        // Full Exterior Model
        Scene {
            id: carModel
            scale: root.statusMode ?
                (root.statusTab === "oil" ?
                    Qt.vector3d(root.statusOilScale, root.statusOilScale, root.statusOilScale) :
                    Qt.vector3d(root.statusTireScale, root.statusTireScale, root.statusTireScale)) :
                Qt.vector3d(0.205, 0.205, 0.205)
            paintColor: root.paintColor
            metalness: root.metalness
            roughness: root.roughness
            clearcoat: root.clearcoat
            lightsOn: root.lightsOn
            roofVisible: root.effectiveRoofVisible
            wheelsVisible: !root.ambientMode
            ambientColor: root.ambientColor
            ambientBrightness: root.ambientBrightness
            ambientOn: root.ambientOn

            Behavior on scale {
                Vector3dAnimation { duration: 680; easing.type: Easing.InOutCubic }
            }
        }

            // -----------------------------------------------------------------
            // Ambient Lighting Cabin Glow Rig (Consolidated 1-Light Setup for 60 FPS)
            // -----------------------------------------------------------------
            Node {
                id: ambientLightingRig
                visible: true

                property color activeColor: root.ambientColor
                property real lightFactor: (root.ambientMode && root.ambientOn) ? (root.ambientBrightness * 3.2) : 0.0

                Behavior on lightFactor { NumberAnimation { duration: 250 } }

                // High-efficiency unified central cabin point light
                PointLight {
                    id: cabinUnifiedAmbientLight
                    position: Qt.vector3d(0.0, 0.72, -0.05)
                    color: ambientLightingRig.activeColor
                    brightness: ambientLightingRig.lightFactor * 2.2
                    castsShadow: false
                }
            }

            // Headlights & Taillights Lighting Rig
            Node {
                id: headlightsRig
                visible: root.lightsOn && !root.ambientMode

                SpotLight {
                    id: leftHeadlightSpot
                    position: Qt.vector3d(-0.61, 0.70, 2.30)
                    eulerRotation: Qt.vector3d(15, 177, 0)
                    color: "#defaff"
                    brightness: 12.0
                    coneAngle: 55
                    innerConeAngle: 35
                    castsShadow: false
                }
                PointLight {
                    id: leftHeadlightGlow
                    position: Qt.vector3d(-0.61, 0.70, 2.30)
                    color: "#ffffff"
                    brightness: 3.5
                    castsShadow: false
                }

                SpotLight {
                    id: rightHeadlightSpot
                    position: Qt.vector3d(0.61, 0.70, 2.30)
                    eulerRotation: Qt.vector3d(15, 183, 0)
                    color: "#defaff"
                    brightness: 12.0
                    coneAngle: 55
                    innerConeAngle: 35
                    castsShadow: false
                }
                PointLight {
                    id: rightHeadlightGlow
                    position: Qt.vector3d(0.61, 0.70, 2.30)
                    color: "#ffffff"
                    brightness: 3.5
                    castsShadow: false
                }
            }
        }
    }

    // =========================================================================
    // Single-Axis Horizontal Turntable Orbit (Instant 1:1 Response & Smooth Inertia)
    // =========================================================================
    MouseArea {
        id: rotateMouseArea
        anchors.fill: parent
        enabled: !root.ambientMode && !root.statusMode
        acceptedButtons: Qt.LeftButton
        hoverEnabled: true
        cursorShape: pressed ? Qt.ClosedHandCursor : Qt.OpenHandCursor

        property real lastX: 0
        property real velocityX: 0.0
        property bool dragActive: false
        property bool inertiaActive: false

        onPressed: function(mouse) {
            autoReturnTimer.stop();
            resetYawAnim.stop();
            dragActive = true;
            inertiaActive = false;
            velocityX = 0.0;
            lastX = mouse.x;
        }

        onPositionChanged: function(mouse) {
            if (dragActive) {
                var dx = mouse.x - lastX;
                lastX = mouse.x;
                velocityX = dx * 0.40;
                var newYaw = root.currentYaw - dx * 0.40;
                while (newYaw > root.heroYaw + 180) newYaw -= 360;
                while (newYaw < root.heroYaw - 180) newYaw += 360;
                root.currentYaw = newYaw;
            }
        }

        onReleased: {
            dragActive = false;
            if (Math.abs(velocityX) > 0.25) {
                inertiaActive = true;
            } else {
                autoReturnTimer.restart();
            }
        }

        onCanceled: {
            dragActive = false;
            inertiaActive = false;
            autoReturnTimer.restart();
        }

        onDoubleClicked: {
            autoReturnTimer.stop();
            inertiaActive = false;
            var diff = root.getShortestAngleDiff(root.currentYaw, root.heroYaw);
            resetYawAnim.from = root.currentYaw;
            resetYawAnim.to = root.currentYaw + diff;
            resetYawAnim.duration = Math.max(300, Math.min(650, Math.abs(diff) * 3.5));
            resetYawAnim.restart();
        }
    }

    // =========================================================================
    // Vehicle Status Interactive 3D Pose Tuning MouseArea
    // Left-drag: Move Car (X/Y) | Right-drag / Shift+drag: Pitch & Yaw
    // Ctrl/Cmd-drag or Middle-drag: Pan Camera (CamX/CamY) | Alt-drag: Roll & CamPitch
    // Wheel: Zoom Camera Distance (CamZ)
    // =========================================================================
    MouseArea {
        id: statusTunerMouseArea
        anchors.fill: parent
        enabled: false
        visible: false
        acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
        hoverEnabled: true
        cursorShape: pressed ? Qt.ClosedHandCursor : Qt.OpenHandCursor

        property real lastX: 0
        property real lastY: 0

        onPressed: function(mouse) {
            lastX = mouse.x;
            lastY = mouse.y;
        }

        onPositionChanged: function(mouse) {
            if (pressed) {
                var dx = mouse.x - lastX;
                var dy = mouse.y - lastY;
                lastX = mouse.x;
                lastY = mouse.y;

                var isOil = (root.statusTab === "oil");

                if ((mouse.buttons & Qt.RightButton) || (mouse.modifiers & Qt.ShiftModifier)) {
                    // Right-click or Shift-drag: rotate pitch and yaw
                    if (isOil) {
                        root.statusOilPitch = Number(Math.max(-89.5, Math.min(25, root.statusOilPitch - dy * 0.25)).toFixed(1));
                        root.statusOilYaw = Number((((root.statusOilYaw + dx * 0.3) % 360 + 360) % 360).toFixed(1));
                    } else {
                        root.statusTirePitch = Number(Math.max(-89.5, Math.min(25, root.statusTirePitch - dy * 0.25)).toFixed(1));
                        root.statusTireYaw = Number((((root.statusTireYaw + dx * 0.3) % 360 + 360) % 360).toFixed(1));
                    }
                } else if ((mouse.buttons & Qt.MiddleButton) || (mouse.modifiers & Qt.ControlModifier) || (mouse.modifiers & Qt.MetaModifier)) {
                    // Middle-click or Ctrl/Cmd-drag: adjust Camera X & Y
                    if (isOil) {
                        root.statusOilCamX = Number((root.statusOilCamX + dx * 0.005).toFixed(3));
                        root.statusOilCamY = Number((root.statusOilCamY - dy * 0.005).toFixed(3));
                    } else {
                        root.statusTireCamX = Number((root.statusTireCamX + dx * 0.005).toFixed(3));
                        root.statusTireCamY = Number((root.statusTireCamY - dy * 0.005).toFixed(3));
                    }
                    root.updateCameraPosition(false);
                } else if (mouse.modifiers & Qt.AltModifier) {
                    // Alt-drag: roll and camera pitch
                    if (isOil) {
                        root.statusOilRoll = Number(Math.max(-45, Math.min(45, root.statusOilRoll + dx * 0.25)).toFixed(1));
                        root.statusOilCamPitch = Number(Math.max(-45, Math.min(45, root.statusOilCamPitch - dy * 0.25)).toFixed(1));
                    } else {
                        root.statusTireRoll = Number(Math.max(-45, Math.min(45, root.statusTireRoll + dx * 0.25)).toFixed(1));
                        root.statusTireCamPitch = Number(Math.max(-45, Math.min(45, root.statusTireCamPitch - dy * 0.25)).toFixed(1));
                    }
                } else {
                    // Left-click drag: pan Rig position X and Y
                    if (isOil) {
                        root.statusOilPosX = Number((root.statusOilPosX + dx * 0.005).toFixed(3));
                        root.statusOilPosY = Number((root.statusOilPosY - dy * 0.005).toFixed(3));
                    } else {
                        root.statusTirePosX = Number((root.statusTirePosX + dx * 0.005).toFixed(3));
                        root.statusTirePosY = Number((root.statusTirePosY - dy * 0.005).toFixed(3));
                    }
                }
            }
        }

        onReleased: function() {
            var isOil = (root.statusTab === "oil");
            console.log("\n================ [STATUS POSE TUNER] ================");
            if (isOil) {
                console.log("statusOilPitch: " + root.statusOilPitch);
                console.log("statusOilYaw: " + root.statusOilYaw);
                console.log("statusOilCamY: " + root.statusOilCamY);
                console.log("statusOilCamX: " + root.statusOilCamX);
                console.log("statusOilCamZ: " + root.statusOilCamZ);
            } else {
                console.log("statusTirePitch: " + root.statusTirePitch);
                console.log("statusTireYaw: " + root.statusTireYaw);
                console.log("statusTireCamY: " + root.statusTireCamY);
                console.log("statusTireCamX: " + root.statusTireCamX);
                console.log("statusTireCamZ: " + root.statusTireCamZ);
            }
            console.log("=====================================================\n");
        }

        onWheel: function(wheel) {
            var isOil = (root.statusTab === "oil");
            var delta = (wheel.angleDelta.y > 0) ? -0.2 : 0.2;
            if (isOil) {
                root.statusOilCamZ = Number((root.statusOilCamZ + delta).toFixed(3));
            } else {
                root.statusTireCamZ = Number((root.statusTireCamZ + delta).toFixed(3));
            }
            root.updateCameraPosition(false);
        }
    }

    FrameAnimation {
        id: inertiaAnimation
        running: rotateMouseArea.inertiaActive
        onTriggered: {
            rotateMouseArea.velocityX *= 0.93;
            var newYaw = root.currentYaw - rotateMouseArea.velocityX;
            while (newYaw > root.heroYaw + 180) newYaw -= 360;
            while (newYaw < root.heroYaw - 180) newYaw += 360;
            root.currentYaw = newYaw;
            if (Math.abs(rotateMouseArea.velocityX) < 0.04) {
                rotateMouseArea.inertiaActive = false;
                autoReturnTimer.restart();
            }
        }
    }
}
