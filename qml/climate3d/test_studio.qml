/**
 * ==============================================================================
 * Project: Apex VISION IVI - Digital Cockpit & Infotainment System
 * File: test_studio.qml
 * Description: Interactive 3D Model Studio with Individual Mesh On/Off Toggles
 * ==============================================================================
 */

import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick3D
import QtQuick3D.Helpers
import "CarModel"
import "CarModel_Consolidated"
import "MeshCatalog.js" as Catalog

Window {
    id: root
    width: 1560
    height: 960
    visible: true
    title: "Lincoln Zephyr 3D Model Studio - Interactive Mesh Inspector"

    property bool useConsolidated: false
    property bool roofOn: false
    property bool lightsOn: true
    property real carScale: 0.25
    property color paintColor: "#bd242c"

    // Mesh Visibility State
    property var hiddenMeshList: ["Object_11", "Object_12", "Object_13", "Object_46", "Object_55", "Object_56", "Object_57", "Object_63", "Object_73", "Object_79"]
    property string soloedMesh: ""
    property string activeCategory: "candidates" // "candidates", "arch", "user10", "frosted", "glass", "interior", "all"
    property string searchFilter: ""
    property int filterRevision: 0

    // Computed effective hidden list passed directly to Scene.qml
    readonly property var effectiveHiddenList: {
        var dummy = filterRevision;
        if (soloedMesh !== "") {
            var list = [];
            for (var i = 0; i < Catalog.allMeshes.length; i++) {
                if (Catalog.allMeshes[i].name !== soloedMesh) {
                    list.push(Catalog.allMeshes[i].name);
                }
            }
            return list;
        }
        return hiddenMeshList;
    }

    function isObjectHidden(name) {
        if (soloedMesh !== "") {
            return soloedMesh !== name;
        }
        return hiddenMeshList.indexOf(name) !== -1;
    }

    function toggleObject(name) {
        soloedMesh = "";
        var arr = hiddenMeshList.slice(0);
        var idx = arr.indexOf(name);
        if (idx !== -1) {
            arr.splice(idx, 1);
        } else {
            arr.push(name);
        }
        hiddenMeshList = arr;
        filterRevision++;
    }

    function toggleSolo(name) {
        if (soloedMesh === name) {
            soloedMesh = "";
        } else {
            soloedMesh = name;
        }
        filterRevision++;
    }

    function showAll() {
        soloedMesh = "";
        hiddenMeshList = [];
        filterRevision++;
    }

    function hideArchCandidates() {
        soloedMesh = "";
        var candidates = ["Object_38", "Object_39", "Object_47", "Object_74", "Object_75", "Object_76", "Object_77", "Object_78", "Object_79", "Object_80", "Object_81", "Object_82"];
        var arr = hiddenMeshList.slice(0);
        for (var i = 0; i < candidates.length; i++) {
            if (arr.indexOf(candidates[i]) === -1) {
                arr.push(candidates[i]);
            }
        }
        hiddenMeshList = arr;
        filterRevision++;
    }

    function hideUser10() {
        soloedMesh = "";
        var u10 = ["Object_11", "Object_12", "Object_13", "Object_46", "Object_55", "Object_56", "Object_57", "Object_63", "Object_73", "Object_79"];
        var arr = hiddenMeshList.slice(0);
        for (var i = 0; i < u10.length; i++) {
            if (arr.indexOf(u10[i]) === -1) {
                arr.push(u10[i]);
            }
        }
        hiddenMeshList = arr;
        filterRevision++;
    }

    function getFilteredMeshes() {
        var res = [];
        var q = searchFilter.trim().toLowerCase();
        for (var i = 0; i < Catalog.allMeshes.length; i++) {
            var item = Catalog.allMeshes[i];
            if (activeCategory === "candidates") {
                if (item.tag !== "roof_target" && item.tag !== "arch_candidate") continue;
            } else if (activeCategory === "arch") {
                if (item.tag !== "arch_candidate") continue;
            } else if (activeCategory === "user10") {
                if (item.tag !== "roof_target") continue;
            } else if (activeCategory === "frosted") {
                if (!item.short_mat.toLowerCase().includes("frosted")) continue;
            } else if (activeCategory === "glass") {
                if (item.tag !== "glass" && !item.short_mat.toLowerCase().includes("glass")) continue;
            } else if (activeCategory === "interior") {
                if (item.tag !== "interior" && !item.short_mat.toLowerCase().includes("int") && !item.short_mat.toLowerCase().includes("leather")) continue;
            }

            if (q !== "") {
                var matchName = item.name.toLowerCase().includes(q);
                var matchSrc = item.source.toLowerCase().includes(q);
                var matchMat = item.short_mat.toLowerCase().includes(q);
                if (!matchName && !matchSrc && !matchMat) continue;
            }
            res.push(item);
        }
        return res;
    }

    readonly property var filteredMeshes: {
        var dummy = filterRevision;
        var dummyCat = activeCategory;
        var dummySearch = searchFilter;
        return getFilteredMeshes();
    }

    // Background Gradient
    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            orientation: Gradient.Vertical
            GradientStop { position: 0.0; color: "#0E1626" }
            GradientStop { position: 0.45; color: "#080F1E" }
            GradientStop { position: 0.8; color: "#040814" }
            GradientStop { position: 1.0; color: "#020408" }
        }
    }

    // 3D Viewport
    View3D {
        id: view3D
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: inspectorPanel.left
        anchors.rightMargin: 10

        environment: ExtendedSceneEnvironment {
            backgroundMode: SceneEnvironment.Transparent
            antialiasingMode: SceneEnvironment.MSAA
            antialiasingQuality: SceneEnvironment.High
            tonemapMode: SceneEnvironment.TonemapModeLinear
            lightProbe: Texture {
                source: "assets/_Hall.ktx"
            }
            probeExposure: 1.15
            glowEnabled: true
            glowStrength: 1.10
            glowIntensity: 0.90
            glowBloom: 0.35
        }

        Node {
            id: cameraOrigin
            position: Qt.vector3d(0, 0.70, 0)
            eulerRotation: Qt.vector3d(-15.0, 150.0, 0)

            Behavior on eulerRotation {
                enabled: !orbitMouseArea.pressed
                Vector3dAnimation { duration: 450; easing.type: Easing.OutCubic }
            }

            PerspectiveCamera {
                id: mainCamera
                position: Qt.vector3d(0, 0.0, 5.2)
                fieldOfView: 28.0
                clipNear: 0.1
                clipFar: 200.0

                Behavior on position {
                    enabled: !orbitMouseArea.pressed
                    Vector3dAnimation { duration: 450; easing.type: Easing.OutCubic }
                }
            }
        }

        DirectionalLight { eulerRotation: Qt.vector3d(-90, 0, 0); brightness: 3.8; color: "#FFFFFF" }
        DirectionalLight { eulerRotation: Qt.vector3d(-42, 35, 0); brightness: 3.6; color: "#FFFFFF" }
        DirectionalLight { eulerRotation: Qt.vector3d(-35, -145, 0); brightness: 3.2; color: "#FFFFFF" }
        DirectionalLight { eulerRotation: Qt.vector3d(-20, 85, 0); brightness: 2.5; color: "#E2E8F0" }

        Node {
            id: carRoot
            position: Qt.vector3d(0, 0, 0)

            Model {
                id: contactShadow
                source: "#Rectangle"
                position: Qt.vector3d(0, 0.002, 0)
                eulerRotation: Qt.vector3d(-90, 0, 0)
                scale: Qt.vector3d(0.038, 0.062, 1.0)
                visible: root.roofOn
                materials: [
                    PrincipledMaterial {
                        lighting: PrincipledMaterial.NoLighting
                        baseColor: "#000000"
                        opacity: 0.90
                        opacityMap: Texture { source: "images/Ground.png" }
                        opacityChannel: Material.A
                        alphaMode: PrincipledMaterial.Blend
                    }
                ]
            }

            Lincoln_Zephyr_Apex_Vision_Consolidated {
                id: carModelConsolidated
                visible: root.useConsolidated
                scale: Qt.vector3d(root.carScale, root.carScale, root.carScale)
                roofVisible: root.roofOn
                paintColor: root.paintColor
                metalness: 0.90
                roughness: 0.12
                clearcoat: 1.0
                lightsOn: root.lightsOn
            }

            Scene {
                id: carModel
                visible: !root.useConsolidated
                scale: Qt.vector3d(root.carScale, root.carScale, root.carScale)
                roofVisible: root.roofOn
                paintColor: root.paintColor
                metalness: 0.90
                roughness: 0.12
                clearcoat: 1.0
                lightsOn: root.lightsOn
                hiddenList: root.effectiveHiddenList
            }

            Node {
                id: carLightsRig
                visible: root.lightsOn

                SpotLight {
                    id: leftHeadlightSpot
                    position: Qt.vector3d(-0.61 * (root.carScale / 0.205), 0.70 * (root.carScale / 0.205), 2.30 * (root.carScale / 0.205))
                    eulerRotation: Qt.vector3d(15, 177, 0)
                    color: "#defaff"
                    brightness: 12.0
                    coneAngle: 55
                    innerConeAngle: 35
                    castsShadow: false
                }
                SpotLight {
                    id: rightHeadlightSpot
                    position: Qt.vector3d(0.61 * (root.carScale / 0.205), 0.70 * (root.carScale / 0.205), 2.30 * (root.carScale / 0.205))
                    eulerRotation: Qt.vector3d(15, 183, 0)
                    color: "#defaff"
                    brightness: 12.0
                    coneAngle: 55
                    innerConeAngle: 35
                    castsShadow: false
                }
            }
        }
    }

    // 360 Mouse Orbit
    MouseArea {
        id: orbitMouseArea
        anchors.fill: view3D
        hoverEnabled: true
        cursorShape: pressed ? Qt.ClosedHandCursor : Qt.OpenHandCursor

        property real lastX: 0
        property real lastY: 0

        onPressed: function(mouse) { lastX = mouse.x; lastY = mouse.y; }

        onPositionChanged: function(mouse) {
            if (pressed) {
                var dx = mouse.x - lastX;
                var dy = mouse.y - lastY;
                lastX = mouse.x; lastY = mouse.y;
                cameraOrigin.eulerRotation.y = (cameraOrigin.eulerRotation.y + dx * 0.40) % 360;
                var newPitch = cameraOrigin.eulerRotation.x - dy * 0.35;
                cameraOrigin.eulerRotation.x = Math.max(-89.5, Math.min(89.5, newPitch));
            }
        }

        onWheel: function(wheel) {
            var delta = (wheel.angleDelta.y > 0) ? -0.35 : 0.35;
            mainCamera.position.z = Math.max(2.0, Math.min(14.0, mainCamera.position.z + delta));
        }
    }

    // Top Controls Bar (Camera Presets & View Controls)
    Rectangle {
        anchors.top: parent.top
        anchors.topMargin: 16
        anchors.left: parent.left
        anchors.leftMargin: 20
        height: 48
        width: controlsRow.width + 24
        radius: 24
        color: "#E00F172A"
        border.color: "#33FFFFFF"
        border.width: 1.5

        Row {
            id: controlsRow
            anchors.centerIn: parent
            spacing: 10

            // Base 9 Parts Roof Toggle
            Rectangle {
                width: 140
                height: 34
                radius: 17
                color: root.roofOn ? "#E0334155" : "#2563EB"
                border.color: root.roofOn ? "#55FFFFFF" : "#93C5FD"
                border.width: 1.5

                Row {
                    anchors.centerIn: parent
                    spacing: 6
                    Text { text: root.roofOn ? "🚗" : "✨"; font.pixelSize: 13 }
                    Text {
                        text: root.roofOn ? "Base Roof: ON" : "Base Roof: OFF"
                        font.family: "Inter"
                        font.pixelSize: 12
                        font.weight: Font.Bold
                        color: "#FFFFFF"
                    }
                }
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.roofOn = !root.roofOn
                }
            }

            // Top-Down Preset
            Rectangle {
                width: 110
                height: 34
                radius: 17
                color: "#D01E293B"
                border.color: "#40FFFFFF"
                border.width: 1
                Row {
                    anchors.centerIn: parent
                    spacing: 6
                    Text { text: "⬇️"; font.pixelSize: 11 }
                    Text { text: "Top Cabin"; font.family: "Inter"; font.pixelSize: 12; font.weight: Font.DemiBold; color: "#E2E8F0" }
                }
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        cameraOrigin.eulerRotation = Qt.vector3d(-89.0, 180.0, 0.0);
                        mainCamera.position.z = 4.2;
                    }
                }
            }

            // 3D Hero Preset
            Rectangle {
                width: 100
                height: 34
                radius: 17
                color: "#D01E293B"
                border.color: "#40FFFFFF"
                border.width: 1
                Row {
                    anchors.centerIn: parent
                    spacing: 6
                    Text { text: "🏎"; font.pixelSize: 11 }
                    Text { text: "Hero 3D"; font.family: "Inter"; font.pixelSize: 12; font.weight: Font.DemiBold; color: "#E2E8F0" }
                }
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        cameraOrigin.eulerRotation = Qt.vector3d(-12.0, 145.0, 0.0);
                        mainCamera.position.z = 4.8;
                    }
                }
            }

            // Lights Toggle
            Rectangle {
                width: 90
                height: 34
                radius: 17
                color: root.lightsOn ? "#D97706" : "#334155"
                border.color: root.lightsOn ? "#FDE68A" : "#40FFFFFF"
                border.width: 1
                Row {
                    anchors.centerIn: parent
                    spacing: 6
                    Text { text: "💡"; font.pixelSize: 11 }
                    Text { text: root.lightsOn ? "Lights" : "Off"; font.family: "Inter"; font.pixelSize: 12; font.weight: Font.DemiBold; color: "#FFFFFF" }
                }
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.lightsOn = !root.lightsOn
                }
            }
        }
    }

    // Solo Active Banner (Floating)
    Rectangle {
        visible: root.soloedMesh !== ""
        anchors.top: parent.top
        anchors.topMargin: 74
        anchors.left: parent.left
        anchors.leftMargin: 20
        height: 38
        width: soloRow.width + 24
        radius: 19
        color: "#D97706"
        border.color: "#FDE68A"
        border.width: 1.5

        Row {
            id: soloRow
            anchors.centerIn: parent
            spacing: 8
            Text { text: "🔍"; font.pixelSize: 13 }
            Text {
                text: "SOLO ACTIVE: Only " + root.soloedMesh + " is Visible! (Click to Exit Solo)"
                font.family: "Inter"
                font.pixelSize: 12
                font.weight: Font.Bold
                color: "#FFFFFF"
            }
        }
        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: root.soloedMesh = ""
        }
    }

    // =========================================================================
    // RIGHT PANEL: INTERACTIVE MESH INSPECTOR WITH ON/OFF FOR EVERY MESH
    // =========================================================================
    Rectangle {
        id: inspectorPanel
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.margins: 14
        width: 420
        radius: 18
        color: "#F0080E1A"
        border.color: "#1E293B"
        border.width: 1.5

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 14
            spacing: 10

            // Header Section
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 3

                RowLayout {
                    Layout.fillWidth: true
                    Text {
                        text: "3D MESH INSPECTOR"
                        font.family: "Inter"
                        font.pixelSize: 15
                        font.weight: Font.Bold
                        color: "#FFFFFF"
                    }
                    Item { Layout.fillWidth: true }
                    Rectangle {
                        height: 24
                        width: badgeTxt.width + 16
                        radius: 12
                        color: root.hiddenMeshList.length > 0 ? "#DC2626" : "#059669"
                        Text {
                            id: badgeTxt
                            anchors.centerIn: parent
                            text: root.hiddenMeshList.length + " Hidden / " + (89 - root.hiddenMeshList.length) + " On"
                            font.family: "Inter"
                            font.pixelSize: 11
                            font.weight: Font.Bold
                            color: "#FFFFFF"
                        }
                    }
                }

                Text {
                    text: "Every 3D mesh has its own button. Click to toggle or solo!"
                    font.family: "Inter"
                    font.pixelSize: 11
                    color: "#94A3B8"
                }
            }

            // Quick Batch Action Buttons
            RowLayout {
                Layout.fillWidth: true
                spacing: 6

                Rectangle {
                    Layout.fillWidth: true
                    height: 32
                    radius: 8
                    color: "#1E293B"
                    border.color: "#475569"
                    border.width: 1
                    Text {
                        anchors.centerIn: parent
                        text: "👁️ Show All"
                        font.family: "Inter"
                        font.pixelSize: 11
                        font.weight: Font.SemiBold
                        color: "#E2E8F0"
                    }
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.showAll()
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: 32
                    radius: 8
                    color: "#B91C1C"
                    border.color: "#F87171"
                    border.width: 1
                    Text {
                        anchors.centerIn: parent
                        text: "✂️ Hide Arch (74-82)"
                        font.family: "Inter"
                        font.pixelSize: 11
                        font.weight: Font.Bold
                        color: "#FFFFFF"
                    }
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.hideArchCandidates()
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: 32
                    radius: 8
                    color: "#4338CA"
                    border.color: "#818CF8"
                    border.width: 1
                    Text {
                        anchors.centerIn: parent
                        text: "⭐ Hide User 10"
                        font.family: "Inter"
                        font.pixelSize: 11
                        font.weight: Font.Bold
                        color: "#FFFFFF"
                    }
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.hideUser10()
                    }
                }
            }

            // Category Filter Chips
            Flow {
                Layout.fillWidth: true
                spacing: 6

                Repeater {
                    model: [
                        { id: "candidates", name: "🎯 Arch Candidates (18)" },
                        { id: "arch", name: "⚪ Frosted Arch (9)" },
                        { id: "user10", name: "⭐ User 10" },
                        { id: "frosted", name: "❄️ Frosted" },
                        { id: "glass", name: "🪟 Glass" },
                        { id: "interior", name: "🛋️ Interior" },
                        { id: "all", name: "🚗 All Meshes (89)" }
                    ]

                    delegate: Rectangle {
                        required property var modelData
                        height: 26
                        width: chipTxt.width + 16
                        radius: 13
                        color: root.activeCategory === modelData.id ? "#3B82F6" : "#1E293B"
                        border.color: root.activeCategory === modelData.id ? "#93C5FD" : "#334155"
                        border.width: 1

                        Text {
                            id: chipTxt
                            anchors.centerIn: parent
                            text: modelData.name
                            font.family: "Inter"
                            font.pixelSize: 11
                            font.weight: root.activeCategory === modelData.id ? Font.Bold : Font.Normal
                            color: root.activeCategory === modelData.id ? "#FFFFFF" : "#94A3B8"
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                root.activeCategory = modelData.id;
                                root.filterRevision++;
                            }
                        }
                    }
                }
            }

            // Search Box
            Rectangle {
                Layout.fillWidth: true
                height: 34
                radius: 8
                color: "#0F172A"
                border.color: searchInput.activeFocus ? "#3B82F6" : "#334155"
                border.width: 1

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 10
                    anchors.rightMargin: 10
                    spacing: 6

                    Text { text: "🔍"; font.pixelSize: 12 }
                    TextInput {
                        id: searchInput
                        Layout.fillWidth: true
                        font.family: "Inter"
                        font.pixelSize: 12
                        color: "#FFFFFF"
                        clip: true
                        selectByMouse: true
                        onTextChanged: {
                            root.searchFilter = text;
                            root.filterRevision++;
                        }

                        Text {
                            anchors.fill: parent
                            text: "Filter by mesh name or material (e.g. 75, glass)..."
                            font.family: "Inter"
                            font.pixelSize: 12
                            color: "#475569"
                            visible: !searchInput.text && !searchInput.activeFocus
                        }
                    }

                    Text {
                        visible: searchInput.text.length > 0
                        text: "✕"
                        font.pixelSize: 11
                        color: "#94A3B8"
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                searchInput.text = "";
                                root.searchFilter = "";
                            }
                        }
                    }
                }
            }

            // Meshes Count Indicator
            Text {
                text: "Showing " + root.filteredMeshes.length + " meshes:"
                font.family: "Inter"
                font.pixelSize: 11
                font.weight: Font.SemiBold
                color: "#64748B"
            }

            // Scrollable List of Mesh Cards
            ListView {
                id: meshListView
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                spacing: 6
                model: root.filteredMeshes

                ScrollBar.vertical: ScrollBar {
                    active: true
                    policy: ScrollBar.AsNeeded
                }

                delegate: Rectangle {
                    required property var modelData
                    required property int index
                    width: meshListView.width - 8
                    height: 58
                    radius: 10

                    readonly property bool isHidden: root.isObjectHidden(modelData.name)
                    readonly property bool isSoloed: root.soloedMesh === modelData.name

                    color: isSoloed ? "#451A03" : (isHidden ? "#2D0F14" : "#131E30")
                    border.color: isSoloed ? "#F59E0B" : (isHidden ? "#7F1D1D" : "#1E293B")
                    border.width: isSoloed ? 1.5 : 1

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 8
                        spacing: 8

                        // Object Info
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 2

                            RowLayout {
                                spacing: 6
                                Text {
                                    text: modelData.name
                                    font.family: "Inter"
                                    font.pixelSize: 13
                                    font.weight: Font.Bold
                                    color: isHidden ? "#FCA5A5" : "#FFFFFF"
                                }
                                Rectangle {
                                    height: 16
                                    width: tagTxt.width + 10
                                    radius: 8
                                    color: modelData.tag === "roof_target" ? "#4338CA" : (modelData.tag === "arch_candidate" ? "#B91C1C" : "#1E293B")
                                    Text {
                                        id: tagTxt
                                        anchors.centerIn: parent
                                        text: modelData.tag === "roof_target" ? "User 10" : (modelData.tag === "arch_candidate" ? "Arch Cand" : modelData.tag)
                                        font.family: "Inter"
                                        font.pixelSize: 9
                                        font.weight: Font.Bold
                                        color: "#FFFFFF"
                                    }
                                }
                            }

                            Text {
                                text: modelData.source + " • " + modelData.short_mat
                                font.family: "Inter"
                                font.pixelSize: 10
                                color: "#94A3B8"
                                elide: Text.ElideRight
                                Layout.fillWidth: true
                            }
                        }

                        // SOLO Button
                        Rectangle {
                            width: 60
                            height: 32
                            radius: 6
                            color: isSoloed ? "#D97706" : "#1E293B"
                            border.color: isSoloed ? "#FDE68A" : "#334155"
                            border.width: 1

                            Text {
                                anchors.centerIn: parent
                                text: isSoloed ? "⭐ SOLO" : "🔍 SOLO"
                                font.family: "Inter"
                                font.pixelSize: 10
                                font.weight: Font.Bold
                                color: isSoloed ? "#FFFFFF" : "#CBD5E1"
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: root.toggleSolo(modelData.name)
                            }
                        }

                        // ON / OFF Toggle Button
                        Rectangle {
                            width: 82
                            height: 32
                            radius: 6
                            color: isHidden ? "#DC2626" : "#059669"
                            border.color: isHidden ? "#FCA5A5" : "#6EE7B7"
                            border.width: 1

                            Row {
                                anchors.centerIn: parent
                                spacing: 4
                                Text {
                                    text: isHidden ? "❌" : "👁"
                                    font.pixelSize: 10
                                }
                                Text {
                                    text: isHidden ? "OFF" : "ON"
                                    font.family: "Inter"
                                    font.pixelSize: 11
                                    font.weight: Font.Bold
                                    color: "#FFFFFF"
                                }
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: root.toggleObject(modelData.name)
                            }
                        }
                    }
                }
            }
        }
    }
}
