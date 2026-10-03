/**
 * ==============================================================================
 * Project: Apex VISION IVI - Digital Cockpit & Infotainment System
 * File: WelcomeScreen.qml
 * Description: Premium Automotive OEM Startup Animation for APEX VISION
 * Brand Evolution: APEX (Hero Brand) -> HORIZON -> SUV -> VISION (Final Lock & Shine)
 * Features:
 *   - Synchronized Studio-Grade Automotive Welcome Sound Chime (welcome_startup.wav)
 *   - Authentic Brushed Titanium & Specular Chrome Metallic Textures for APEX & VISION
 *   - Synchronized Dynamic Specular Horizon Sweep Across Both Brand Emblems
 *   - Strict Audio Playback Lockout during Startup Reveal
 * Author / Developer: Sk Rehan Ahamed
 * License: MIT
 * ==============================================================================
 */

import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import QtMultimedia
import ApexVision

Item {
    id: root

    anchors.fill: parent
    z: 10000

    visible: opacity > 0.001
    enabled: opacity > 0.001

    // Emitted when startup sequence completes and cockpit is fully revealed
    signal finished()

    // Studio-grade OEM welcome audio chime
    SoundEffect {
        id: startupChime
        source: "qrc:/ApexVision/qml/assets/sounds/welcome_startup.wav"
        volume: 0.92
    }

    // Interactive interceptor with instant-skip capability
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        preventStealing: true
        onClicked: {
            if (startupSequence.running) {
                startupSequence.stop();
                if (startupChime.playing) {
                    startupChime.stop();
                }
                fadeToCockpit.start();
            }
        }
    }

    // Dynamic animatable properties
    property real apexLogoOpacity: 0.0
    property real signatureShineX: -220
    property real signatureShineOpacity: 0.0
    property real apexGlowOpacity: 0.0

    property real horizonOpacity: 0.0
    property real horizonX: 0
    property real horizonY: 12

    property real suvOpacity: 0.0
    property real suvX: -25

    property real visionOpacity: 0.0
    property real visionX: 0
    property real visionY: 8
    property real visionScale: 0.95

    // -------------------------------------------------------------------------
    // 1. BACKGROUND: Deep automotive cockpit graphite & subtle studio vignette
    // -------------------------------------------------------------------------
    Rectangle {
        id: bgDark
        anchors.fill: parent
        color: "#05070A" // Deep cockpit graphite
    }

    // Soft ambient studio vignette behind the hero emblem (OEM showroom lighting)
    Rectangle {
        id: studioLighting
        anchors.centerIn: parent
        anchors.verticalCenterOffset: -42
        width: 900
        height: 380
        radius: 190
        color: "#111824"
        opacity: 0.35
        layer.enabled: true
        layer.effect: MultiEffect {
            blurEnabled: true
            blur: 1.0
            blurMax: 96
        }
    }

    // -------------------------------------------------------------------------
    // 2. HERO APEX LOGO: Stationary brand hero with machined brushed metallic texture
    // -------------------------------------------------------------------------
    Item {
        id: logoContainer
        width: 600
        height: 120 // 5:1 ratio matching the 1024x204 metallic emblem
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: -42

        // A. Restrained cool-white ambient glow radiating from the brushed emblem
        Image {
            id: imgGlow
            anchors.fill: parent
            source: "qrc:/ApexVision/qml/assets/icons/apex_logo_metallic.png"
            fillMode: Image.PreserveAspectFit
            smooth: true
            mipmap: true
            opacity: root.apexGlowOpacity
            layer.enabled: true
            layer.effect: MultiEffect {
                blurEnabled: true
                blur: 0.60
                blurMax: 32
                brightness: 0.50
                colorization: 1.0
                colorizationColor: "#D6E8FC" // Restrained cool-white glow
            }
        }

        // B. Base Metallic Brushed APEX Logo (Permanent Hero Identity)
        Image {
            id: baseLogo
            anchors.fill: parent
            source: "qrc:/ApexVision/qml/assets/icons/apex_logo_metallic.png"
            fillMode: Image.PreserveAspectFit
            smooth: true
            mipmap: true
            opacity: root.apexLogoOpacity
        }

        // C. Mask Source (Must have layer.enabled: true for MultiEffect)
        Image {
            id: imgMask
            anchors.fill: parent
            source: "qrc:/ApexVision/qml/assets/icons/apex_logo_metallic.png"
            fillMode: Image.PreserveAspectFit
            visible: false
            layer.enabled: true
        }

        // D. Traveling Metallic Shine Beam (Angled light sweep strictly inside emblem)
        Item {
            id: shineCanvas
            anchors.fill: parent
            visible: false
            layer.enabled: true

            Rectangle {
                id: shineBeam
                width: 110
                height: parent.height * 2.8
                anchors.verticalCenter: parent.verticalCenter
                x: root.signatureShineX
                rotation: 18
                gradient: Gradient {
                    orientation: Gradient.Horizontal
                    GradientStop { position: 0.0; color: "transparent" }
                    GradientStop { position: 0.30; color: Qt.rgba(1.0, 1.0, 1.0, 0.20) }
                    GradientStop { position: 0.48; color: Qt.rgba(1.0, 1.0, 1.0, 0.85) }
                    GradientStop { position: 0.50; color: Qt.rgba(1.0, 1.0, 1.0, 1.0) }
                    GradientStop { position: 0.52; color: Qt.rgba(1.0, 1.0, 1.0, 0.85) }
                    GradientStop { position: 0.70; color: Qt.rgba(1.0, 1.0, 1.0, 0.20) }
                    GradientStop { position: 1.0; color: "transparent" }
                }
            }
        }

        // E. Masked Specular Light Sweep Layer
        MultiEffect {
            anchors.fill: parent
            source: shineCanvas
            maskEnabled: true
            maskSource: imgMask
            opacity: root.signatureShineOpacity
        }
    }

    // -------------------------------------------------------------------------
    // 3. VEHICLE GENERATION STAGE (Underneath APEX Logo, Zero Artifacts/Lines)
    // -------------------------------------------------------------------------
    Item {
        id: subTextStage
        anchors.top: logoContainer.bottom
        anchors.topMargin: 28
        anchors.horizontalCenter: parent.horizontalCenter
        width: 600
        height: 60

        // 1. HORIZON (First Model Identity)
        Text {
            id: textHorizon
            anchors.centerIn: parent
            text: "HORIZON"
            font.family: "Inter"
            font.pixelSize: 22
            font.weight: Font.DemiBold
            font.letterSpacing: 16
            color: "#A2B2C6" // Refined brushed titanium slate
            opacity: root.horizonOpacity
            visible: opacity > 0.001
            transform: Translate { x: root.horizonX; y: root.horizonY }
        }

        // 2. SUV (Second Generation)
        Text {
            id: textSuv
            anchors.centerIn: parent
            text: "SUV"
            font.family: "Inter"
            font.pixelSize: 23
            font.weight: Font.DemiBold
            font.letterSpacing: 18
            color: "#BDCEE0" // Clean automotive silver
            opacity: root.suvOpacity
            visible: opacity > 0.001
            transform: Translate { x: root.suvX; y: 0 }
        }

        // 3. VISION (Current Model & Final Brand Identity with Machined Metallic Texture)
        Item {
            id: visionContainer
            anchors.centerIn: parent
            width: 600
            height: 60
            opacity: root.visionOpacity
            visible: opacity > 0.001
            transform: [
                Translate { x: root.visionX; y: root.visionY },
                Scale { xScale: root.visionScale; yScale: root.visionScale; origin.x: visionContainer.width / 2; origin.y: visionContainer.height / 2 }
            ]

            // Metallic Brushed VISION Emblem
            Image {
                id: imgVisionMetallic
                anchors.centerIn: parent
                width: 600
                height: 60
                source: "qrc:/ApexVision/qml/assets/icons/apex_vision_metallic.png"
                fillMode: Image.PreserveAspectFit
                smooth: true
                mipmap: true
            }

            // Mask Source for Specular Glint on VISION
            Image {
                id: imgVisionMask
                anchors.fill: imgVisionMetallic
                source: "qrc:/ApexVision/qml/assets/icons/apex_vision_metallic.png"
                fillMode: Image.PreserveAspectFit
                visible: false
                layer.enabled: true
            }

            // Masked Specular Light Sweep Layer on VISION (synchronized with APEX shine)
            MultiEffect {
                anchors.fill: imgVisionMetallic
                source: shineCanvas
                maskEnabled: true
                maskSource: imgVisionMask
                opacity: root.signatureShineOpacity * 0.90
            }
        }
    }

    // -------------------------------------------------------------------------
    // 4. MASTER OEM STARTUP ANIMATION TIMELINE (Exact 5.0s Total Runtime)
    // -------------------------------------------------------------------------
    SequentialAnimation {
        id: startupSequence
        running: false

        // Phase 1: 0.0s – 0.5s: APEX Brand Established (500 ms) & Startup Chime
        ParallelAnimation {
            ScriptAction {
                script: {
                    try {
                        startupChime.play();
                    } catch (e) {
                        console.warn("[WelcomeScreen] SoundEffect error:", e);
                    }
                }
            }
            NumberAnimation { target: root; property: "apexLogoOpacity"; from: 0.0; to: 1.0; duration: 250; easing.type: Easing.OutQuad }
            PauseAnimation { duration: 500 }
        }

        // Phase 2: 0.5s – 1.1s: HORIZON Generation (600 ms total)
        ParallelAnimation {
            NumberAnimation { target: root; property: "horizonOpacity"; from: 0.0; to: 1.0; duration: 180; easing.type: Easing.OutCubic }
            NumberAnimation { target: root; property: "horizonY"; from: 8; to: 0; duration: 180; easing.type: Easing.OutCubic }
        }
        PauseAnimation { duration: 420 }

        // Phase 3: 1.1s – 1.7s: HORIZON → SUV (600 ms total)
        ParallelAnimation {
            NumberAnimation { target: root; property: "horizonOpacity"; from: 1.0; to: 0.0; duration: 110; easing.type: Easing.InQuad }
            NumberAnimation { target: root; property: "horizonX"; from: 0; to: 20; duration: 120; easing.type: Easing.InQuad }

            SequentialAnimation {
                PauseAnimation { duration: 50 }
                ParallelAnimation {
                    NumberAnimation { target: root; property: "suvOpacity"; from: 0.0; to: 1.0; duration: 160; easing.type: Easing.OutCubic }
                    NumberAnimation { target: root; property: "suvX"; from: -16; to: 0; duration: 160; easing.type: Easing.OutCubic }
                }
            }
        }
        PauseAnimation { duration: 380 }

        // Phase 4: 1.7s – 2.5s: SUV → VISION (800 ms total)
        ParallelAnimation {
            NumberAnimation { target: root; property: "suvOpacity"; from: 1.0; to: 0.0; duration: 120; easing.type: Easing.InQuad }
            NumberAnimation { target: root; property: "suvX"; from: 0; to: 20; duration: 130; easing.type: Easing.InQuad }

            SequentialAnimation {
                PauseAnimation { duration: 60 }
                ParallelAnimation {
                    NumberAnimation { target: root; property: "visionOpacity"; from: 0.0; to: 1.0; duration: 200; easing.type: Easing.OutCubic }
                    NumberAnimation { target: root; property: "visionY"; from: 6; to: 0; duration: 200; easing.type: Easing.OutCubic }
                    NumberAnimation { target: root; property: "visionScale"; from: 0.94; to: 1.0; duration: 200; easing.type: Easing.OutCubic }
                }
            }
        }
        PauseAnimation { duration: 520 }

        // Phase 5: 2.5s – 2.9s: FINAL METALLIC LOCK (400 ms)
        PauseAnimation { duration: 400 }

        // Phase 6: 2.9s – 4.1s: SIGNATURE METALLIC SPECULAR SHINE SWEEP (1200 ms)
        ParallelAnimation {
            NumberAnimation { target: root; property: "signatureShineOpacity"; from: 0.0; to: 1.0; duration: 120 }

            // Clean metallic light sweep travels across both APEX logo and VISION
            NumberAnimation {
                target: root
                property: "signatureShineX"
                from: -180
                to: 680
                duration: 1050
                easing.type: Easing.InOutSine
            }

            // Restrained cool-white ambient glow swells and settles
            SequentialAnimation {
                NumberAnimation {
                    target: root
                    property: "apexGlowOpacity"
                    from: 0.0
                    to: 0.45
                    duration: 525
                    easing.type: Easing.OutQuad
                }
                NumberAnimation {
                    target: root
                    property: "apexGlowOpacity"
                    from: 0.45
                    to: 0.10
                    duration: 525
                    easing.type: Easing.InQuad
                }
            }

            SequentialAnimation {
                PauseAnimation { duration: 950 }
                NumberAnimation { target: root; property: "signatureShineOpacity"; from: 1.0; to: 0.0; duration: 120 }
            }
        }

        // Phase 7: 4.1s – 4.6s: PROUD BRAND HOLD (500 ms)
        PauseAnimation { duration: 500 }

        // Phase 8: 4.6s – 5.0s: DISSOLVE TO LIVE COCKPIT (400 ms)
        ParallelAnimation {
            NumberAnimation { target: root; property: "opacity"; from: 1.0; to: 0.0; duration: 400; easing.type: Easing.InOutQuad }
        }

        ScriptAction {
            script: {
                root.visible = false;
                root.enabled = false;
                root.finished();
            }
        }
    }

    // Smooth manual fade-out if user taps the screen to skip
    ParallelAnimation {
        id: fadeToCockpit
        NumberAnimation {
            target: root
            property: "opacity"
            to: 0.0
            duration: 350
            easing.type: Easing.InOutQuad
        }
        onFinished: {
            if (startupChime.playing) {
                startupChime.stop();
            }
            root.visible = false;
            root.enabled = false;
            root.finished();
        }
    }

    // Auto-start on application launch
    Component.onCompleted: {
        startupSequence.start();
    }
}
