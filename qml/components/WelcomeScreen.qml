/**
 * ==============================================================================
 * Project: Apex VISION IVI - Digital Cockpit & Infotainment System
 * File: WelcomeScreen.qml
 * Description: Executive Automotive OEM Startup Animation for APEX VISION
 * Brand Identity: APEX VISION (Smooth Letter Fade Cascade & Unified Specular Shine)
 * Features:
 *   - Synchronized Welcome Chime (welcome_startup.wav)
 *   - APEX Hero Logo Reveal
 *   - V - I - S - I - O - N Letters Fade In One by One with Smooth Elegant Dissolve
 *   - Unified Full Specular Shine Sweep across both APEX & VISION
 *   - Fast, Punchy ~3.2s Total Duration
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

    // V - I - S - I - O - N Smooth Fade Opacity Properties
    property real letter0Opacity: 0.0
    property real letter1Opacity: 0.0
    property real letter2Opacity: 0.0
    property real letter3Opacity: 0.0
    property real letter4Opacity: 0.0
    property real letter5Opacity: 0.0

    // -------------------------------------------------------------------------
    // 1. BACKGROUND: Deep automotive cockpit obsidian & showroom vignette
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

        // A. Restrained platinum-silver ambient glow radiating from the brushed emblem
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
                colorizationColor: "#E2E8F0" // Platinum silver glow
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

        // D. Traveling Metallic Shine Beam (Liquid Silver / Chrome reflection)
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
                    GradientStop { position: 0.30; color: Qt.rgba(0.90, 0.94, 0.98, 0.20) }
                    GradientStop { position: 0.48; color: Qt.rgba(0.95, 0.98, 1.0, 0.85) }
                    GradientStop { position: 0.50; color: "#FFFFFF" }
                    GradientStop { position: 0.52; color: Qt.rgba(0.95, 0.98, 1.0, 0.85) }
                    GradientStop { position: 0.70; color: Qt.rgba(0.90, 0.94, 0.98, 0.20) }
                    GradientStop { position: 1.0; color: "transparent" }
                }
            }
        }

        // E. Masked Specular Light Sweep Layer on APEX
        MultiEffect {
            anchors.fill: parent
            source: shineCanvas
            maskEnabled: true
            maskSource: imgMask
            opacity: root.signatureShineOpacity
        }
    }

    // -------------------------------------------------------------------------
    // 3. V - I - S - I - O - N STAGE (Letter-by-Letter Fade Beneath APEX Logo)
    // -------------------------------------------------------------------------
    Item {
        id: subTextStage
        anchors.top: logoContainer.bottom
        anchors.topMargin: 24
        anchors.horizontalCenter: parent.horizontalCenter
        width: 600
        height: 60

        // Base Visible Letters Row
        Row {
            id: visionLetterRow
            anchors.centerIn: parent
            spacing: 26

            // Letter 0: V
            Text {
                text: "V"
                font.family: "Inter"
                font.pixelSize: 28
                font.weight: Font.Bold
                color: "#E2E8F0"
                opacity: root.letter0Opacity
            }

            // Letter 1: I
            Text {
                text: "I"
                font.family: "Inter"
                font.pixelSize: 28
                font.weight: Font.Bold
                color: "#E2E8F0"
                opacity: root.letter1Opacity
            }

            // Letter 2: S
            Text {
                text: "S"
                font.family: "Inter"
                font.pixelSize: 28
                font.weight: Font.Bold
                color: "#E2E8F0"
                opacity: root.letter2Opacity
            }

            // Letter 3: I
            Text {
                text: "I"
                font.family: "Inter"
                font.pixelSize: 28
                font.weight: Font.Bold
                color: "#E2E8F0"
                opacity: root.letter3Opacity
            }

            // Letter 4: O
            Text {
                text: "O"
                font.family: "Inter"
                font.pixelSize: 28
                font.weight: Font.Bold
                color: "#E2E8F0"
                opacity: root.letter4Opacity
            }

            // Letter 5: N
            Text {
                text: "N"
                font.family: "Inter"
                font.pixelSize: 28
                font.weight: Font.Bold
                color: "#E2E8F0"
                opacity: root.letter5Opacity
            }
        }

        // Mask Source for Specular Glint on VISION Letters
        Item {
            id: visionLetterMaskContainer
            anchors.fill: parent
            visible: false
            layer.enabled: true

            Row {
                anchors.centerIn: parent
                spacing: 26

                Text { text: "V"; font.family: "Inter"; font.pixelSize: 28; font.weight: Font.Bold; color: "#FFFFFF"; opacity: root.letter0Opacity }
                Text { text: "I"; font.family: "Inter"; font.pixelSize: 28; font.weight: Font.Bold; color: "#FFFFFF"; opacity: root.letter1Opacity }
                Text { text: "S"; font.family: "Inter"; font.pixelSize: 28; font.weight: Font.Bold; color: "#FFFFFF"; opacity: root.letter2Opacity }
                Text { text: "I"; font.family: "Inter"; font.pixelSize: 28; font.weight: Font.Bold; color: "#FFFFFF"; opacity: root.letter3Opacity }
                Text { text: "O"; font.family: "Inter"; font.pixelSize: 28; font.weight: Font.Bold; color: "#FFFFFF"; opacity: root.letter4Opacity }
                Text { text: "N"; font.family: "Inter"; font.pixelSize: 28; font.weight: Font.Bold; color: "#FFFFFF"; opacity: root.letter5Opacity }
            }
        }

        // Masked Specular Light Sweep Layer on VISION (Synchronized with APEX shine)
        MultiEffect {
            anchors.fill: parent
            source: shineCanvas
            maskEnabled: true
            maskSource: visionLetterMaskContainer
            opacity: root.signatureShineOpacity * 0.95
        }
    }

    // -------------------------------------------------------------------------
    // 4. MASTER OEM STARTUP ANIMATION TIMELINE (~3.2s Total Execution Time)
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
            NumberAnimation { target: root; property: "apexLogoOpacity"; from: 0.0; to: 1.0; duration: 320; easing.type: Easing.OutCubic }
            PauseAnimation { duration: 480 }
        }

        // Phase 2: 0.5s – 1.35s: V - I - S - I - O - N Letters Fade In One by One
        // Letter 0: 'V'
        NumberAnimation { target: root; property: "letter0Opacity"; from: 0.0; to: 1.0; duration: 180; easing.type: Easing.OutCubic }
        PauseAnimation { duration: 40 }

        // Letter 1: 'I'
        NumberAnimation { target: root; property: "letter1Opacity"; from: 0.0; to: 1.0; duration: 180; easing.type: Easing.OutCubic }
        PauseAnimation { duration: 40 }

        // Letter 2: 'S'
        NumberAnimation { target: root; property: "letter2Opacity"; from: 0.0; to: 1.0; duration: 180; easing.type: Easing.OutCubic }
        PauseAnimation { duration: 40 }

        // Letter 3: 'I'
        NumberAnimation { target: root; property: "letter3Opacity"; from: 0.0; to: 1.0; duration: 180; easing.type: Easing.OutCubic }
        PauseAnimation { duration: 40 }

        // Letter 4: 'O'
        NumberAnimation { target: root; property: "letter4Opacity"; from: 0.0; to: 1.0; duration: 180; easing.type: Easing.OutCubic }
        PauseAnimation { duration: 40 }

        // Letter 5: 'N'
        NumberAnimation { target: root; property: "letter5Opacity"; from: 0.0; to: 1.0; duration: 180; easing.type: Easing.OutCubic }

        // Settling lock pause
        PauseAnimation { duration: 200 }

        // Phase 3: 1.4s – 2.4s: FULL SIGNATURE SPECULAR SHINE SWEEP ACROSS BOTH (1000 ms)
        ParallelAnimation {
            NumberAnimation { target: root; property: "signatureShineOpacity"; from: 0.0; to: 1.0; duration: 120 }

            // Liquid silver specular sweep cuts through APEX and V I S I O N
            NumberAnimation {
                target: root
                property: "signatureShineX"
                from: -180
                to: 680
                duration: 950
                easing.type: Easing.InOutSine
            }

            // Refined platinum-silver glow pulse
            SequentialAnimation {
                NumberAnimation {
                    target: root
                    property: "apexGlowOpacity"
                    from: 0.0
                    to: 0.45
                    duration: 475
                    easing.type: Easing.OutQuad
                }
                NumberAnimation {
                    target: root
                    property: "apexGlowOpacity"
                    from: 0.45
                    to: 0.10
                    duration: 475
                    easing.type: Easing.InQuad
                }
            }

            SequentialAnimation {
                PauseAnimation { duration: 830 }
                NumberAnimation { target: root; property: "signatureShineOpacity"; from: 1.0; to: 0.0; duration: 120 }
            }
        }

        // Phase 4: 2.4s – 2.8s: Brand Hold (400 ms)
        PauseAnimation { duration: 400 }

        // Phase 5: 2.8s – 3.2s: Dissolve to Live Cockpit (400 ms)
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
