/**
 * ==============================================================================
 * Project: Apex VISION IVI - Digital Cockpit & Infotainment System
 * File: SeatStudioView.qml
 * Author / Developer: Sk Rehan Ahamed
 * License: MIT
 * ==============================================================================
 */

import QtQuick
import QtQuick3D
import QtQuick3D.Helpers
import "./SeatModel"
import "./CarModel"

Item {
    id: root
    anchors.fill: parent

    // View Mode: "cabin" (Level 1: 4-Seat Overview) or "studio" (Level 2: 1-Seat Adjust & Massage)
    property string viewMode: "cabin"
    property string activeCabinTarget: "front" // "front" | "rear"

    // Selection: "driver" or "passenger"
    property string activeSeat: "driver"
    property string selectedZone: "lumbar_mid" // "lumbar_upper" | "lumbar_mid" | "lumbar_lower" | "cushion_left" | "cushion_right"
    property real lumbarUpperLevel: 0.5 // 0.1 to 1.0 (corresponds to 1/10 to 10/10)
    property real lumbarMidLevel: 0.5
    property real lumbarLowerLevel: 0.5
    property real cushionLeftLevel: 0.5
    property real cushionRightLevel: 0.5

    // Backward-compatible aliases
    property real upperLevel: lumbarUpperLevel
    property real lumbarLevel: lumbarMidLevel
    property real thighLevel: cushionLeftLevel
    property real bolsterLeftLevel: cushionLeftLevel
    property real bolsterRightLevel: cushionRightLevel
    property string seatStudioTab: "seat"
    property bool lumbarActive: selectedZone.indexOf("lumbar") !== -1

    // Massage Visualizer Properties
    property bool massageActive: false
    property int massageIntensity: 1 // 1, 2, 3
    property string massageProgram: "relax"

    // Signal when a seat is clicked in cabin mode or zone in studio mode
    signal seatSelected(string seatName)
    signal zoneSelected(string zone)

    // Camera & Pose calibration values
    readonly property real defaultPitch: 20.0
    readonly property real defaultYaw: (activeSeat === "passenger") ? 26.0 : -26.0
    readonly property real defaultPosX: (activeSeat === "passenger") ? 0.16 : -0.16
    readonly property real targetYaw: (activeSeat === "passenger") ? 26.0 : -26.0
    readonly property real targetPosX: (activeSeat === "passenger") ? 0.16 : -0.16
    property real seatPitch: 20.0
    property real seatYaw: -26.0
    property real seatRoll: 0.0
    property real seatScale: 0.47
    property real seatPosX: -0.16
    property real seatPosY: -0.76
    property real seatPosZ: 0.0

    Component.onCompleted: {
        seatPosX = targetPosX;
        seatYaw = targetYaw;
    }

    // Studio Camera Rig
    readonly property real studioCamX: 0.0
    readonly property real studioCamY: 0.0
    readonly property real studioCamZ: 6.5
    readonly property real studioCamPitch: 0.0
    readonly property real studioCamYaw: 0.0
    readonly property real studioCamFov: 27.0

    // Interactive Seat Slide Values
    property real rearLeftSlide: 0.0
    property real rearRightSlide: 0.0
    property real frontPassSlide: 0.0

    // Cabin Camera Poses (Top View of 2nd Row Seats matching User Reference Image)
    property real rearCamX: -0.70
    property real rearCamY: 3.20
    property real rearCamZ: 0.0
    property real rearCamPitch: -89.0
    property real rearCamYaw: 0.0

    property real frontCamX: -0.52
    property real frontCamY: 3.20
    property real frontCamZ: 0.0
    property real frontCamPitch: -89.0
    property real frontCamYaw: 0.0

    property real cabinCamFov: 28.0

    // Chronological Sequence State:
    // Step 1: Chair rotates from back to initial position
    // Step 2: Then blue colour will come (massageBlueIntro: 0.0 -> 1.0)
    // Step 3: And then the light glow will come (massageFireflyIntro: 0.0 -> 1.0)
    property real massageBlueIntro: 0.0
    property real massageFireflyIntro: 0.0

    ParallelAnimation {
        id: switchSeatAnim
        NumberAnimation { target: root; property: "seatPosX"; to: root.targetPosX; duration: 600; easing.type: Easing.OutCubic }
        NumberAnimation { target: root; property: "seatYaw"; to: root.targetYaw; duration: 600; easing.type: Easing.OutCubic }
        NumberAnimation { target: root; property: "seatPitch"; to: root.defaultPitch; duration: 600; easing.type: Easing.OutCubic }
    }

    onActiveSeatChanged: {
        inertiaTimer.stop();
        orbitMouseArea.dragActive = false;
        orbitMouseArea.inertiaActive = false;
        orbitMouseArea.velocityX = 0.0;
        orbitMouseArea.velocityY = 0.0;
        switchSeatAnim.restart();
    }

    onMassageActiveChanged: {
        if (massageActive && viewMode === "studio") {
            playMassageRotation();
        } else if (!massageActive) {
            massageIntroSequence.stop();
            massageBlueIntro = 0.0;
            massageFireflyIntro = 0.0;
        }
    }

    ParallelAnimation {
        id: resetPoseAnim
        NumberAnimation { target: root; property: "seatPosX"; to: root.targetPosX; duration: 420; easing.type: Easing.OutCubic }
        NumberAnimation { target: root; property: "seatYaw"; to: root.targetYaw; duration: 420; easing.type: Easing.OutCubic }
        NumberAnimation { target: root; property: "seatPitch"; to: root.defaultPitch; duration: 420; easing.type: Easing.OutCubic }
    }

    function resetToDefaultPose() {
        inertiaTimer.stop();
        massageIntroSequence.stop();
        massageBlueIntro = 0.0;
        massageFireflyIntro = 0.0;
        orbitMouseArea.dragActive = false;
        orbitMouseArea.inertiaActive = false;
        orbitMouseArea.velocityX = 0.0;
        orbitMouseArea.velocityY = 0.0;
        resetPoseAnim.restart();
    }

    // Sequence trigger: chair rotates from back, then blue color comes, then light glow comes
    function playMassageRotation() {
        inertiaTimer.stop();
        orbitMouseArea.dragActive = false;
        orbitMouseArea.inertiaActive = false;
        orbitMouseArea.velocityX = 0.0;
        orbitMouseArea.velocityY = 0.0;

        massageBlueIntro = 0.0;
        massageFireflyIntro = 0.0;
        seatYaw = (root.activeSeat === "passenger") ? -155.0 : 155.0;
        seatPitch = 14.0;
        seatPosX = root.targetPosX;

        massageIntroSequence.stop();
        massageIntroSequence.restart();
    }

    SequentialAnimation {
        id: massageIntroSequence

        // Phase 0: Reset glow factors to 0 during rotation and ensure back angle
        PropertyAction { target: root; property: "massageBlueIntro"; value: 0.0 }
        PropertyAction { target: root; property: "massageFireflyIntro"; value: 0.0 }
        PropertyAction { target: root; property: "seatYaw"; value: (root.activeSeat === "passenger") ? -155.0 : 155.0 }
        PropertyAction { target: root; property: "seatPitch"; value: 14.0 }
        PropertyAction { target: root; property: "seatPosX"; value: root.targetPosX }

        // STEP 1: Chair rotates from back to its initial position on opposite side
        ParallelAnimation {
            NumberAnimation {
                target: root
                property: "seatYaw"
                from: (root.activeSeat === "passenger") ? -155.0 : 155.0
                to: root.targetYaw
                duration: 1150
                easing.type: Easing.OutCubic
            }
            NumberAnimation {
                target: root
                property: "seatPitch"
                from: 14.0
                to: root.defaultPitch
                duration: 1150
                easing.type: Easing.OutCubic
            }
            NumberAnimation {
                target: root
                property: "seatPosX"
                to: root.targetPosX
                duration: 1150
                easing.type: Easing.OutCubic
            }
        }

        // Brief natural pause as the chair settles
        PauseAnimation { duration: 120 }

        // STEP 2: "then blue colour will come" (subtle middle backrest luminescence)
        NumberAnimation {
            target: root
            property: "massageBlueIntro"
            from: 0.0
            to: 1.0
            duration: 480
            easing.type: Easing.OutQuad
        }

        // STEP 3: "and then the light glow will come" (firefly glowing circle blooms)
        NumberAnimation {
            target: root
            property: "massageFireflyIntro"
            from: 0.0
            to: 1.0
            duration: 420
            easing.type: Easing.OutQuad
        }
    }

    // Master Project Default Background (Transparent in Studio so 3D seat smoothly fades/slides over page)
    Image {
        id: defaultBg
        anchors.fill: parent
        source: "qrc:/ApexVision/qml/assets/default_background.png"
        fillMode: Image.PreserveAspectCrop
        smooth: true
        visible: false
        z: 0
    }

    View3D {
        id: seatView3D
        anchors.fill: parent
        camera: mainCamera
        renderMode: View3D.Offscreen
        z: 1

        environment: SceneEnvironment {
            id: sceneEnv
            clearColor: "#00000000"
            backgroundMode: SceneEnvironment.Transparent
            antialiasingMode: SceneEnvironment.MSAA
            antialiasingQuality: SceneEnvironment.High
            tonemapMode: SceneEnvironment.TonemapModeLinear

            lightProbe: Texture {
                source: "assets/_Hall.ktx"
            }
            probeExposure: 0.55
        }

        // Fixed Studio Camera Rig (No random position/rotation camera animation)
        Node {
            id: cameraRig
            position: Qt.vector3d(root.studioCamX, root.studioCamY, root.studioCamZ)
            eulerRotation: Qt.vector3d(root.studioCamPitch, root.studioCamYaw, 0.0)

            PerspectiveCamera {
                id: mainCamera
                clipNear: 0.1
                clipFar: 100.0
                fieldOfView: root.studioCamFov
            }
        }

        // ---------------------------------------------------------------------
        // Studio & Cabin Lighting Rig
        // ---------------------------------------------------------------------
        DirectionalLight {
            id: keyLight
            eulerRotation: Qt.vector3d(-45, 25, 0)
            brightness: 1.8
            color: "#FFFFFF"
            castsShadow: false
        }

        DirectionalLight {
            id: fillLight
            eulerRotation: Qt.vector3d(-30, -55, 0)
            brightness: 1.2
            color: "#C5D8F8"
            castsShadow: false
        }

        DirectionalLight {
            id: rimLight
            eulerRotation: Qt.vector3d(20, -150, 0)
            brightness: 1.6
            color: "#93C5FD"
            castsShadow: false
        }

        DirectionalLight {
            id: overheadLight
            eulerRotation: Qt.vector3d(-85, 0, 0)
            brightness: 1.4
            color: "#F4F6FA"
            castsShadow: false
        }

        // ---------------------------------------------------------------------
        // LEVEL 1: ISOLATED 4-SEAT CABIN RIG (Top-Down View matching User Reference)
        // ---------------------------------------------------------------------
        Node {
            id: cabinRig
            visible: false

            // Front Row Seats (Vanished for clean second row focus)
            Node {
                id: cabinDriverNode
                visible: false
            }

            Node {
                id: cabinPassNode
                visible: false
            }

            // Rear Left Seat (2nd Row Left - Rotated to opposite direction per user request)
            Node {
                id: cabinRearLeftNode
                position: Qt.vector3d(-0.21, 0.0, 0.0)
                scale: Qt.vector3d(0.18, 0.18, 0.18)
                eulerRotation: Qt.vector3d(0, 180, 0)

                ApexSeat {
                    id: cabinRearLeftSeat
                    selectedZone: ""
                    isDimmed: false
                    leatherRoughness: 0.35
                    leatherMetalness: 0.08
                }
            }

            // Rear Right Seat (2nd Row Right - Rotated to opposite direction per user request)
            Node {
                id: cabinRearRightNode
                position: Qt.vector3d(0.21, 0.0, 0.0)
                scale: Qt.vector3d(0.18, 0.18, 0.18)
                eulerRotation: Qt.vector3d(0, 180, 0)

                ApexSeat {
                    id: cabinRearRightSeat
                    selectedZone: ""
                    isDimmed: false
                    leatherRoughness: 0.35
                    leatherMetalness: 0.08
                }
            }
        }

        // ---------------------------------------------------------------------
        // LEVEL 2: SINGLE SEAT STUDIO RIG (Adjust & Massage Mode)
        // ---------------------------------------------------------------------
        Node {
            id: seatRig
            visible: root.viewMode === "studio"
            position: Qt.vector3d(root.seatPosX, root.seatPosY, root.seatPosZ)
            eulerRotation: Qt.vector3d(root.seatPitch, root.seatYaw, root.seatRoll)
            scale: Qt.vector3d(root.seatScale, root.seatScale, root.seatScale)

            // Apex Luxury Seat
            ApexSeat {
                id: apexSeat
                leatherColor: "#1a1e26"
                leatherRoughness: 0.35
                leatherMetalness: 0.08
                casingColor: "#111419"
                selectedZone: root.selectedZone
                lumbarUpperLevel: root.lumbarUpperLevel
                lumbarMidLevel: root.lumbarMidLevel
                lumbarLowerLevel: root.lumbarLowerLevel
                cushionLeftLevel: root.cushionLeftLevel
                cushionRightLevel: root.cushionRightLevel
                massageActive: root.massageActive
                massageIntensity: root.massageIntensity
                massageProgram: root.massageProgram
                massageBlueIntro: root.massageBlueIntro
                massageFireflyIntro: root.massageFireflyIntro
            }

            // -----------------------------------------------------------------
            // 5 Interactive Hotspot Markers on the Seat (Normal Seat Mode)
            // 3 Points in Lumbar Backrest, 2 Points in Seat Cushion (Left & Right)
            // Smaller & sleeker scale; only 1 point pressed at a time -> area glows blue!
            // -----------------------------------------------------------------
            PrincipledMaterial {
                id: hotspotActiveMat
                lighting: PrincipledMaterial.NoLighting
                baseColor: "#00E5FF"
                emissiveFactor: Qt.vector3d(3.0, 5.0, 7.0)
                cullMode: PrincipledMaterial.NoCulling
            }

            PrincipledMaterial {
                id: hotspotInactiveMat
                lighting: PrincipledMaterial.NoLighting
                baseColor: "#E2E8F0"
                emissiveFactor: Qt.vector3d(0.8, 1.2, 1.6)
                opacity: 0.75
                alphaMode: PrincipledMaterial.Blend
                cullMode: PrincipledMaterial.NoCulling
            }

            // 1. Lumbar Spine - Upper Lumbar Point
            Node {
                id: hotspotUpperLumbarNode
                position: Qt.vector3d(0.0, 1.82, -0.98)
                visible: root.viewMode === "studio" && !root.massageActive

                Model {
                    source: "#Sphere"
                    scale: (root.selectedZone === "lumbar_upper") ? Qt.vector3d(0.00030, 0.00030, 0.00020) : Qt.vector3d(0.00020, 0.00020, 0.00014)
                    materials: [ (root.selectedZone === "lumbar_upper") ? hotspotActiveMat : hotspotInactiveMat ]
                }
            }

            // 2. Lumbar Spine - Mid Lumbar Point
            Node {
                id: hotspotMidLumbarNode
                position: Qt.vector3d(0.0, 1.56, -0.82)
                visible: root.viewMode === "studio" && !root.massageActive

                Model {
                    source: "#Sphere"
                    scale: (root.selectedZone === "lumbar_mid") ? Qt.vector3d(0.00030, 0.00030, 0.00020) : Qt.vector3d(0.00020, 0.00020, 0.00014)
                    materials: [ (root.selectedZone === "lumbar_mid") ? hotspotActiveMat : hotspotInactiveMat ]
                }
            }

            // 3. Lumbar Spine - Lower Lumbar Point
            Node {
                id: hotspotLowerLumbarNode
                position: Qt.vector3d(0.0, 1.30, -0.68)
                visible: root.viewMode === "studio" && !root.massageActive

                Model {
                    source: "#Sphere"
                    scale: (root.selectedZone === "lumbar_lower") ? Qt.vector3d(0.00030, 0.00030, 0.00020) : Qt.vector3d(0.00020, 0.00020, 0.00014)
                    materials: [ (root.selectedZone === "lumbar_lower") ? hotspotActiveMat : hotspotInactiveMat ]
                }
            }

            // 4. Cushion Base - Left Cushion Point
            Node {
                id: hotspotCushionLeftNode
                position: Qt.vector3d(-0.24, 0.88, 0.38)
                visible: root.viewMode === "studio" && !root.massageActive

                Model {
                    source: "#Sphere"
                    scale: (root.selectedZone === "cushion_left") ? Qt.vector3d(0.00030, 0.00030, 0.00020) : Qt.vector3d(0.00020, 0.00020, 0.00014)
                    materials: [ (root.selectedZone === "cushion_left") ? hotspotActiveMat : hotspotInactiveMat ]
                }
            }

            // 5. Cushion Base - Right Cushion Point
            Node {
                id: hotspotCushionRightNode
                position: Qt.vector3d(0.24, 0.88, 0.38)
                visible: root.viewMode === "studio" && !root.massageActive

                Model {
                    source: "#Sphere"
                    scale: (root.selectedZone === "cushion_right") ? Qt.vector3d(0.00030, 0.00030, 0.00020) : Qt.vector3d(0.00020, 0.00020, 0.00014)
                    materials: [ (root.selectedZone === "cushion_right") ? hotspotActiveMat : hotspotInactiveMat ]
                }
            }
        }
    }

    // -------------------------------------------------------------------------
    // Interactive 360° Drag & Inspection MouseArea with Inertia (Studio mode only)
    // -------------------------------------------------------------------------
    MouseArea {
        id: orbitMouseArea
        anchors.fill: parent
        z: 10
        enabled: root.viewMode === "studio"
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton
        cursorShape: pressed ? Qt.ClosedHandCursor : Qt.OpenHandCursor
        preventStealing: true

        property real lastX: 0
        property real lastY: 0
        property real velocityX: 0.0
        property real velocityY: 0.0
        property bool dragActive: false
        property bool inertiaActive: false

        onPressed: function(mouse) {
            resetPoseAnim.stop();
            inertiaTimer.stop();
            dragActive = true;
            inertiaActive = false;
            velocityX = 0.0;
            velocityY = 0.0;
            lastX = mouse.x;
            lastY = mouse.y;
        }

        onPositionChanged: function(mouse) {
            if (dragActive) {
                var dx = mouse.x - lastX;
                var dy = mouse.y - lastY;
                lastX = mouse.x;
                lastY = mouse.y;

                velocityX = dx * 0.45;
                velocityY = dy * 0.25;

                root.seatYaw += dx * 0.45;
                root.seatPitch = Math.max(-20.0, Math.min(35.0, root.seatPitch - dy * 0.25));
            }
        }

        onReleased: {
            dragActive = false;
            if (Math.abs(velocityX) > 0.3 || Math.abs(velocityY) > 0.3) {
                inertiaActive = true;
                inertiaTimer.restart();
            }
        }

        onCanceled: {
            dragActive = false;
            inertiaActive = false;
        }

        onDoubleClicked: {
            root.resetToDefaultPose();
        }
    }

    // -------------------------------------------------------------------------
    // 2D Interactive Target Pins Overlay (Tracking 3D Scene Hotspots)
    // 3 Points in Lumbar Backrest, 2 Points in Cushion Base (Left & Right)
    // Only 1 Point pressed at a time -> that portion glows blue!
    // -------------------------------------------------------------------------
    Item {
        id: hotspotsOverlay2D
        anchors.fill: parent
        z: 25
        visible: root.viewMode === "studio" && !root.massageActive && (root.seatStudioTab === "seat")
        opacity: (Math.cos(root.seatYaw * Math.PI / 180.0) > 0.0) ? 1.0 : 0.0
        Behavior on opacity { NumberAnimation { duration: 250 } }

        function updatePins() {
            if (!seatView3D) return;
            try {
                var p1 = seatView3D.mapFrom3DScene(hotspotUpperLumbarNode.scenePosition);
                pinUpperLumbar.x = p1.x - pinUpperLumbar.width / 2;
                pinUpperLumbar.y = p1.y - pinUpperLumbar.height / 2;

                var p2 = seatView3D.mapFrom3DScene(hotspotMidLumbarNode.scenePosition);
                pinMidLumbar.x = p2.x - pinMidLumbar.width / 2;
                pinMidLumbar.y = p2.y - pinMidLumbar.height / 2;

                var p3 = seatView3D.mapFrom3DScene(hotspotLowerLumbarNode.scenePosition);
                pinLowerLumbar.x = p3.x - pinLowerLumbar.width / 2;
                pinLowerLumbar.y = p3.y - pinLowerLumbar.height / 2;

                var p4 = seatView3D.mapFrom3DScene(hotspotCushionLeftNode.scenePosition);
                pinCushionLeft.x = p4.x - pinCushionLeft.width / 2;
                pinCushionLeft.y = p4.y - pinCushionLeft.height / 2;

                var p5 = seatView3D.mapFrom3DScene(hotspotCushionRightNode.scenePosition);
                pinCushionRight.x = p5.x - pinCushionRight.width / 2;
                pinCushionRight.y = p5.y - pinCushionRight.height / 2;
            } catch(e) {}
        }

        Timer {
            interval: 16
            running: hotspotsOverlay2D.visible
            repeat: true
            onTriggered: hotspotsOverlay2D.updatePins()
        }

        Component.onCompleted: updatePins()

        // 1. Upper Lumbar Pin (Backrest Center Top)
        Rectangle {
            id: pinUpperLumbar
            width: 34; height: 34
            color: "transparent"

            Rectangle {
                anchors.centerIn: parent
                width: (root.selectedZone === "lumbar_upper") ? 20 : 13
                height: width
                radius: width / 2
                color: (root.selectedZone === "lumbar_upper") ? Qt.rgba(0/255, 229/255, 255/255, 0.25) : Qt.rgba(255, 255, 255, 0.08)
                border.color: (root.selectedZone === "lumbar_upper") ? "#00E5FF" : Qt.rgba(255, 255, 255, 0.35)
                border.width: (root.selectedZone === "lumbar_upper") ? 1.5 : 1.0
            }
            Rectangle {
                anchors.centerIn: parent
                width: (root.selectedZone === "lumbar_upper") ? 7 : 4.5
                height: width
                radius: width / 2
                color: (root.selectedZone === "lumbar_upper") ? "#00E5FF" : "#FFFFFF"
            }
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    root.selectedZone = "lumbar_upper";
                    root.zoneSelected("lumbar_upper");
                }
            }
        }

        // 2. Mid Lumbar Pin (Backrest Center Middle)
        Rectangle {
            id: pinMidLumbar
            width: 34; height: 34
            color: "transparent"

            Rectangle {
                anchors.centerIn: parent
                width: (root.selectedZone === "lumbar_mid") ? 20 : 13
                height: width
                radius: width / 2
                color: (root.selectedZone === "lumbar_mid") ? Qt.rgba(0/255, 229/255, 255/255, 0.25) : Qt.rgba(255, 255, 255, 0.08)
                border.color: (root.selectedZone === "lumbar_mid") ? "#00E5FF" : Qt.rgba(255, 255, 255, 0.35)
                border.width: (root.selectedZone === "lumbar_mid") ? 1.5 : 1.0
            }
            Rectangle {
                anchors.centerIn: parent
                width: (root.selectedZone === "lumbar_mid") ? 7 : 4.5
                height: width
                radius: width / 2
                color: (root.selectedZone === "lumbar_mid") ? "#00E5FF" : "#FFFFFF"
            }
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    root.selectedZone = "lumbar_mid";
                    root.zoneSelected("lumbar_mid");
                }
            }
        }

        // 3. Lower Lumbar Pin (Backrest Center Lower)
        Rectangle {
            id: pinLowerLumbar
            width: 34; height: 34
            color: "transparent"

            Rectangle {
                anchors.centerIn: parent
                width: (root.selectedZone === "lumbar_lower") ? 20 : 13
                height: width
                radius: width / 2
                color: (root.selectedZone === "lumbar_lower") ? Qt.rgba(0/255, 229/255, 255/255, 0.25) : Qt.rgba(255, 255, 255, 0.08)
                border.color: (root.selectedZone === "lumbar_lower") ? "#00E5FF" : Qt.rgba(255, 255, 255, 0.35)
                border.width: (root.selectedZone === "lumbar_lower") ? 1.5 : 1.0
            }
            Rectangle {
                anchors.centerIn: parent
                width: (root.selectedZone === "lumbar_lower") ? 7 : 4.5
                height: width
                radius: width / 2
                color: (root.selectedZone === "lumbar_lower") ? "#00E5FF" : "#FFFFFF"
            }
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    root.selectedZone = "lumbar_lower";
                    root.zoneSelected("lumbar_lower");
                }
            }
        }

        // 4. Left Cushion Pin (Seat Base Left)
        Rectangle {
            id: pinCushionLeft
            width: 34; height: 34
            color: "transparent"

            Rectangle {
                anchors.centerIn: parent
                width: (root.selectedZone === "cushion_left") ? 20 : 13
                height: width
                radius: width / 2
                color: (root.selectedZone === "cushion_left") ? Qt.rgba(0/255, 229/255, 255/255, 0.25) : Qt.rgba(255, 255, 255, 0.08)
                border.color: (root.selectedZone === "cushion_left") ? "#00E5FF" : Qt.rgba(255, 255, 255, 0.35)
                border.width: (root.selectedZone === "cushion_left") ? 1.5 : 1.0
            }
            Rectangle {
                anchors.centerIn: parent
                width: (root.selectedZone === "cushion_left") ? 7 : 4.5
                height: width
                radius: width / 2
                color: (root.selectedZone === "cushion_left") ? "#00E5FF" : "#FFFFFF"
            }
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    root.selectedZone = "cushion_left";
                    root.zoneSelected("cushion_left");
                }
            }
        }

        // 5. Right Cushion Pin (Seat Base Right)
        Rectangle {
            id: pinCushionRight
            width: 34; height: 34
            color: "transparent"

            Rectangle {
                anchors.centerIn: parent
                width: (root.selectedZone === "cushion_right") ? 20 : 13
                height: width
                radius: width / 2
                color: (root.selectedZone === "cushion_right") ? Qt.rgba(0/255, 229/255, 255/255, 0.25) : Qt.rgba(255, 255, 255, 0.08)
                border.color: (root.selectedZone === "cushion_right") ? "#00E5FF" : Qt.rgba(255, 255, 255, 0.35)
                border.width: (root.selectedZone === "cushion_right") ? 1.5 : 1.0
            }
            Rectangle {
                anchors.centerIn: parent
                width: (root.selectedZone === "cushion_right") ? 7 : 4.5
                height: width
                radius: width / 2
                color: (root.selectedZone === "cushion_right") ? "#00E5FF" : "#FFFFFF"
            }
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    root.selectedZone = "cushion_right";
                    root.zoneSelected("cushion_right");
                }
            }
        }
    }

    Timer {
        id: inertiaTimer
        interval: 16
        repeat: true
        running: false
        onTriggered: {
            orbitMouseArea.velocityX *= 0.92;
            orbitMouseArea.velocityY *= 0.92;

            root.seatYaw += orbitMouseArea.velocityX;
            root.seatPitch = Math.max(-20.0, Math.min(35.0, root.seatPitch - orbitMouseArea.velocityY));

            if (Math.abs(orbitMouseArea.velocityX) < 0.03 && Math.abs(orbitMouseArea.velocityY) < 0.03) {
                orbitMouseArea.inertiaActive = false;
                inertiaTimer.stop();
            }
        }
    }
}
