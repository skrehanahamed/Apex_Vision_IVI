/**
 * ==============================================================================
 * Project: Apex VISION IVI
 * File: test_interactive_car.qml
 * Description: Interactive 360° 3D Vehicle Inspector (Drag to Orbit, Scroll to Zoom)
 * ==============================================================================
 */

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick3D
import "file:///Users/reno/.gemini/antigravity-ide/brain/1f1bc63d-6ca6-4fc9-aff4-9b67e3c490ac/scratch/balsam_3mesh_perfect"

Window {
    id: appWindow
    width: 1440
    height: 900
    visible: true
    title: "APEX VISION IVI — Interactive 3D Vehicle Inspector"
    color: "#080B10"

    // Model State Properties
    property color selectedPaint: "#EDF2F7"
    property real selectedMetalness: 0.18
    property real selectedRoughness: 0.24
    property real selectedClearcoat: 0.75
    property bool roofOn: true
    property bool wheelsOn: true
    property bool ambientMode: false
    property color ambientGlowColor: "#A855F7"

    Item {
        anchors.fill: parent

        // ---------------------------------------------------------------------
        // 3D Viewport
        // ---------------------------------------------------------------------
        View3D {
            id: view3D
            anchors.fill: parent

            environment: SceneEnvironment {
                backgroundMode: SceneEnvironment.Color
                clearColor: appWindow.ambientMode ? "#040508" : "#080B10"
                antialiasingMode: SceneEnvironment.MSAA
                antialiasingQuality: SceneEnvironment.High
                tonemapMode: SceneEnvironment.TonemapModeLinear
                lightProbe: Texture {
                    source: "assets/_Hall.ktx"
                }
                probeExposure: appWindow.ambientMode ? 0.35 : 0.65
            }

            // Camera Rig for 360° Orbiting
            Node {
                id: cameraOrigin
                position: Qt.vector3d(0, 0.45, 0)
                eulerRotation: Qt.vector3d(-10, 35, 0)

                PerspectiveCamera {
                    id: mainCamera
                    position: Qt.vector3d(0, 0, 7.5)
                    clipNear: 0.1
                    clipFar: 200.0
                    fieldOfView: 28.0
                }
            }

            // Lighting Setup
            DirectionalLight {
                eulerRotation: Qt.vector3d(-42, 35, 0)
                brightness: appWindow.ambientMode ? 0.6 : 2.2
                color: "#FFFFFF"
            }
            DirectionalLight {
                eulerRotation: Qt.vector3d(-20, -140, 0)
                brightness: appWindow.ambientMode ? 0.4 : 1.8
                color: "#FFFFFF"
            }

            // The Vehicle Model
            Scene {
                id: carModel
                scale: Qt.vector3d(0.205, 0.205, 0.205)
                paintColor: appWindow.selectedPaint
                metalness: appWindow.selectedMetalness
                roughness: appWindow.selectedRoughness
                clearcoat: appWindow.selectedClearcoat
                roofVisible: appWindow.roofOn
                wheelsVisible: appWindow.wheelsOn
                ambientColor: appWindow.ambientGlowColor
                ambientBrightness: 1.0
                ambientOn: appWindow.ambientMode
            }
        }

        // ---------------------------------------------------------------------
        // Mouse Orbit & Zoom Controller
        // ---------------------------------------------------------------------
        MouseArea {
            id: orbitMouseArea
            anchors.fill: view3D
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

                    // Horizontal Orbit (Yaw)
                    cameraOrigin.eulerRotation.y = (cameraOrigin.eulerRotation.y + dx * 0.40) % 360;

                    // Vertical Orbit (Pitch)
                    var newPitch = cameraOrigin.eulerRotation.x - dy * 0.35;
                    cameraOrigin.eulerRotation.x = Math.max(-89.5, Math.min(89.5, newPitch));
                }
            }

            onWheel: function(wheel) {
                var delta = (wheel.angleDelta.y > 0) ? -0.40 : 0.40;
                mainCamera.position.z = Math.max(2.5, Math.min(18.0, mainCamera.position.z + delta));
            }
        }

        // ---------------------------------------------------------------------
        // Left Floating Control Panel (Glassmorphism HUD)
        // ---------------------------------------------------------------------
        Rectangle {
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.margins: 20
            width: 320
            radius: 16
            color: "#D80F172A"
            border.color: "#33475569"
            border.width: 1.5

            // Prevent orbit mouse drag when clicking inside the panel
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                preventStealing: true
            }

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 18
                spacing: 12

                Text {
                    text: "APEX VEHICLE INSPECTOR"
                    color: "#FFFFFF"
                    font.bold: true
                    font.pixelSize: 15
                    font.letterSpacing: 1.0
                }

                Text {
                    text: "Drag left-click to orbit 360° | Scroll to zoom"
                    color: "#94A3B8"
                    font.pixelSize: 11
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: 1
                    color: "#33475569"
                }

                // Camera Presets
                Text {
                    text: "CAMERA PRESETS"
                    color: "#E2E8F0"
                    font.pixelSize: 11
                    font.bold: true
                    font.letterSpacing: 0.8
                }

                RowLayout {
                    spacing: 6
                    Button {
                        text: "Hero"
                        onClicked: {
                            appWindow.ambientMode = false;
                            appWindow.roofOn = true;
                            appWindow.wheelsOn = true;
                            cameraOrigin.eulerRotation = Qt.vector3d(-10, 35, 0);
                            mainCamera.position.z = 7.5;
                        }
                    }
                    Button {
                        text: "Front"
                        onClicked: {
                            appWindow.ambientMode = false;
                            cameraOrigin.eulerRotation = Qt.vector3d(-4, 0, 0);
                            mainCamera.position.z = 5.2;
                        }
                    }
                    Button {
                        text: "Side"
                        onClicked: {
                            appWindow.ambientMode = false;
                            cameraOrigin.eulerRotation = Qt.vector3d(0, 90, 0);
                            mainCamera.position.z = 7.5;
                        }
                    }
                    Button {
                        text: "Rear"
                        onClicked: {
                            appWindow.ambientMode = false;
                            cameraOrigin.eulerRotation = Qt.vector3d(-8, 180, 0);
                            mainCamera.position.z = 6.8;
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: 1
                    color: "#33475569"
                }

                // Exterior Paint Selection
                Text {
                    text: "EXTERIOR PAINT"
                    color: "#E2E8F0"
                    font.pixelSize: 11
                    font.bold: true
                    font.letterSpacing: 0.8
                }

                Row {
                    spacing: 8
                    Repeater {
                        model: [
                            { name: "Satin Pearl", color: "#EDF2F7", metal: 0.18, rough: 0.24 },
                            { name: "Apex Red", color: "#BD242C", metal: 0.25, rough: 0.22 },
                            { name: "Obsidian", color: "#18181B", metal: 0.40, rough: 0.18 },
                            { name: "Glacier Blue", color: "#1E3A8A", metal: 0.35, rough: 0.20 },
                            { name: "Nardo Grey", color: "#64748B", metal: 0.15, rough: 0.28 },
                            { name: "Emerald", color: "#064E3B", metal: 0.30, rough: 0.22 }
                        ]
                        Rectangle {
                            width: 34; height: 34; radius: 17
                            color: modelData.color
                            border.color: appWindow.selectedPaint === modelData.color ? "#38BDF8" : "#475569"
                            border.width: appWindow.selectedPaint === modelData.color ? 2.5 : 1
                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    appWindow.selectedPaint = modelData.color;
                                    appWindow.selectedMetalness = modelData.metal;
                                    appWindow.selectedRoughness = modelData.rough;
                                }
                            }
                        }
                    }
                }

                // Material Sliders
                Text {
                    text: "Roughness: " + appWindow.selectedRoughness.toFixed(2)
                    color: "#CBD5E1"
                    font.pixelSize: 11
                }
                Slider {
                    Layout.fillWidth: true
                    from: 0.05; to: 0.85
                    value: appWindow.selectedRoughness
                    onMoved: appWindow.selectedRoughness = value
                }

                Text {
                    text: "Metallic: " + appWindow.selectedMetalness.toFixed(2)
                    color: "#CBD5E1"
                    font.pixelSize: 11
                }
                Slider {
                    Layout.fillWidth: true
                    from: 0.0; to: 1.0
                    value: appWindow.selectedMetalness
                    onMoved: appWindow.selectedMetalness = value
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: 1
                    color: "#33475569"
                }

                // Assembly Toggles
                Text {
                    text: "COMPONENTS & MODES"
                    color: "#E2E8F0"
                    font.pixelSize: 11
                    font.bold: true
                    font.letterSpacing: 0.8
                }

                Switch {
                    text: "Panoramic Roof"
                    checked: appWindow.roofOn
                    onToggled: appWindow.roofOn = checked
                }

                Switch {
                    text: "Alloy Wheels"
                    checked: appWindow.wheelsOn
                    onToggled: appWindow.wheelsOn = checked
                }

                Switch {
                    text: "Ambient Cabin View"
                    checked: appWindow.ambientMode
                    onToggled: {
                        appWindow.ambientMode = checked;
                        if (checked) {
                            appWindow.roofOn = false;
                            appWindow.wheelsOn = false;
                            cameraOrigin.eulerRotation = Qt.vector3d(-78, 90, 0);
                            mainCamera.position.z = 4.8;
                        } else {
                            appWindow.roofOn = true;
                            appWindow.wheelsOn = true;
                            cameraOrigin.eulerRotation = Qt.vector3d(-10, 35, 0);
                            mainCamera.position.z = 7.5;
                        }
                    }
                }

                Item { Layout.fillHeight: true }
            }
        }
    }
}
