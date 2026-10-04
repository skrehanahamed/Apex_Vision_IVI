import QtQuick
import QtQuick.Shapes

Rectangle {
    id: root
    width: 1920
    height: 1200
    color: "#040711"

    // Real-time reactive state properties
    property real progressPercent: 0
    property string transferSpeed: "Connecting..."
    property string receivedBytes: "0.0 MB"
    property string totalBytes: "Calculating..."
    property string etaStr: "--"
    property string activeComponent: "Connecting Uplink..."
    property bool isCompleted: false

    // Cyber aesthetics & color tokens matching reference image
    readonly property color colCyan: "#00d2ff"
    readonly property color colBlue: "#0088ff"
    readonly property color colGreen: "#00ff9d"
    readonly property color colCardBg: "#0a1324"
    readonly property color colBorder: "#1c2b44"
    readonly property color colTrack: "#121d31"
    readonly property color colTextMuted: "#8e9bb0"

    // 1. High-Res Background Graphic (Car, neon floor, particle waves)
    Image {
        id: bgImage
        anchors.fill: parent
        source: "file:///opt/apex_vision_ivi/qml/assets/images/ota_background.png"
        fillMode: Image.PreserveAspectCrop
        smooth: true
        mipmap: true
    }

    // 2. Top Header Identity Section (Official APEX Logo + Title + Subtitle)
    Column {
        id: headerCol
        anchors.top: parent.top
        anchors.topMargin: 46
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 8
        z: 10

        // Official APEX Logo Emblem
        Image {
            id: apexLogo
            anchors.horizontalCenter: parent.horizontalCenter
            source: "file:///opt/apex_vision_ivi/qml/assets/icons/apex_logo_metallic.png"
            width: 220
            height: 44
            fillMode: Image.PreserveAspectFit
            smooth: true
            mipmap: true
        }

        // Glowing Horizon Curve
        Item {
            anchors.horizontalCenter: parent.horizontalCenter
            width: 280
            height: 8

            Rectangle {
                anchors.centerIn: parent
                width: parent.width
                height: 2
                radius: 1
                gradient: Gradient {
                    orientation: Gradient.Horizontal
                    GradientStop { position: 0.0; color: "transparent" }
                    GradientStop { position: 0.5; color: root.isCompleted ? colGreen : colCyan }
                    GradientStop { position: 1.0; color: "transparent" }
                }
            }
        }

        // Title: SYSTEM SOFTWARE UPDATE / OTA
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: 4
            text: "SYSTEM SOFTWARE UPDATE / OTA"
            color: "#ffffff"
            font.pixelSize: 22
            font.bold: true
            font.letterSpacing: 2
        }

        // Subtitle: Updating your vehicle with the latest features...
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Updating your vehicle with the latest features and improvements."
            color: colTextMuted
            font.pixelSize: 14
        }
    }

    // 3. Lower Section: Premium Glassmorphism Data Transmission Panel (No circular gauge, uncluttered cockpit)
    Rectangle {
        id: transferCard
        anchors.bottom: warningBox.top
        anchors.bottomMargin: 28
        anchors.horizontalCenter: parent.horizontalCenter
        width: root.width * 0.86
        height: 126
        radius: 20
        color: Qt.rgba(10/255, 19/255, 36/255, 0.70)
        border.color: Qt.rgba(1, 1, 1, 0.18)
        border.width: 1.5
        z: 10

        // Specular Glass Top Highlight
        Rectangle {
            anchors.top: parent.top
            anchors.topMargin: 1
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width - 32
            height: 1
            gradient: Gradient {
                orientation: Gradient.Horizontal
                GradientStop { position: 0.0; color: "transparent" }
                GradientStop { position: 0.5; color: Qt.rgba(1, 1, 1, 0.35) }
                GradientStop { position: 1.0; color: "transparent" }
            }
        }

        Column {
            anchors.fill: parent
            anchors.margins: 18
            spacing: 12

            // Top Row: Transmission Component (Left) | Glowing Percentage Pill & Transferred MB (Right)
            Item {
                width: parent.width
                height: 36

                Row {
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 12

                    Image {
                        source: "file:///opt/apex_vision_ivi/qml/assets/icons/ota_cloud_highres.png"
                        width: 30
                        height: 22
                        fillMode: Image.PreserveAspectFit
                        smooth: true
                        mipmap: true
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Text {
                        text: "Transmitting:  " + root.activeComponent
                        color: "#ffffff"
                        font.pixelSize: 16
                        font.bold: true
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                Row {
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 16

                    // Glass Transferred Data MB Badge
                    Rectangle {
                        height: 32
                        width: bytesRow.width + 24
                        radius: 16
                        color: Qt.rgba(1, 1, 1, 0.06)
                        border.color: Qt.rgba(1, 1, 1, 0.12)
                        border.width: 1
                        anchors.verticalCenter: parent.verticalCenter

                        Row {
                            id: bytesRow
                            anchors.centerIn: parent
                            spacing: 6

                            Text {
                                text: "DATA:"
                                color: root.colTextMuted
                                font.pixelSize: 11
                                font.bold: true
                                font.letterSpacing: 1
                                anchors.verticalCenter: parent.verticalCenter
                            }

                            Text {
                                text: root.receivedBytes + " / " + root.totalBytes
                                color: "#f8fafc"
                                font.pixelSize: 14
                                font.bold: true
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }
                    }

                    // Futuristic Glowing Percentage Pill
                    Rectangle {
                        height: 32
                        width: percentTxt.width + 28
                        radius: 16
                        color: root.isCompleted ? Qt.rgba(0, 1, 157/255, 0.16) : Qt.rgba(0, 210/255, 1, 0.16)
                        border.color: root.isCompleted ? root.colGreen : root.colCyan
                        border.width: 1.5
                        anchors.verticalCenter: parent.verticalCenter

                        Text {
                            id: percentTxt
                            anchors.centerIn: parent
                            text: Math.round(root.progressPercent) + "%"
                            color: root.isCompleted ? root.colGreen : root.colCyan
                            font.pixelSize: 16
                            font.bold: true
                            font.letterSpacing: 0.5
                        }
                    }
                }
            }

            // Middle: High-End Glass Neon Horizontal Progress Bar
            Rectangle {
                id: progressTrack
                width: parent.width
                height: 12
                radius: 6
                color: Qt.rgba(18/255, 29/255, 49/255, 0.85)
                border.color: Qt.rgba(1, 1, 1, 0.12)
                border.width: 1
                clip: true

                // Glowing Neon Progress Bar Fill
                Rectangle {
                    id: progressFill
                    width: Math.max(12, parent.width * Math.min(1.0, Math.max(0.0, root.progressPercent / 100.0)))
                    height: parent.height
                    radius: 6
                    gradient: Gradient {
                        orientation: Gradient.Horizontal
                        GradientStop { position: 0.0; color: root.isCompleted ? "#00c853" : "#0052d4" }
                        GradientStop { position: 0.5; color: root.isCompleted ? root.colGreen : root.colBlue }
                        GradientStop { position: 1.0; color: root.isCompleted ? "#a7f3d0" : root.colCyan }
                    }

                    // Cyber glass specular shine sweep animation
                    Rectangle {
                        width: 90
                        height: parent.height
                        gradient: Gradient {
                            orientation: Gradient.Horizontal
                            GradientStop { position: 0.0; color: "transparent" }
                            GradientStop { position: 0.5; color: Qt.rgba(1, 1, 1, 0.55) }
                            GradientStop { position: 1.0; color: "transparent" }
                        }
                        NumberAnimation on x {
                            loops: Animation.Infinite
                            from: -90
                            to: transferCard.width
                            duration: 1700
                            running: !root.isCompleted
                        }
                    }
                }
            }

            // Bottom Sub-Row: Speed + ETA Info
            Item {
                width: parent.width
                height: 18

                Row {
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 8

                    Text {
                        text: "⚡ Speed: " + root.transferSpeed
                        color: root.colTextMuted
                        font.pixelSize: 13
                        font.bold: true
                    }
                }

                Row {
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 8

                    Text {
                        text: root.isCompleted ? "Status: Transfer Verified" : "⏱️ Estimated: " + root.etaStr
                        color: root.isCompleted ? root.colGreen : root.colTextMuted
                        font.pixelSize: 13
                        font.bold: true
                    }
                }
            }
        }
    }

    // 4. Bottom Status / Safeguard Glass Badge
    Rectangle {
        id: warningBox
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 32
        anchors.horizontalCenter: parent.horizontalCenter
        width: 440
        height: 54
        radius: 16
        color: root.isCompleted ? Qt.rgba(6/255, 35/255, 22/255, 0.72) : Qt.rgba(9/255, 18/255, 34/255, 0.70)
        border.color: root.isCompleted ? Qt.rgba(0, 1, 157/255, 0.35) : Qt.rgba(1, 1, 1, 0.14)
        border.width: 1.2
        z: 10

        Row {
            anchors.centerIn: parent
            spacing: 16

            Image {
                source: root.isCompleted
                        ? "file:///opt/apex_vision_ivi/qml/assets/icons/ota_cloud_highres.png"
                        : "file:///opt/apex_vision_ivi/qml/assets/icons/ota_warning_highres.png"
                width: 24
                height: 22
                fillMode: Image.PreserveAspectFit
                smooth: true
                mipmap: true
                anchors.verticalCenter: parent.verticalCenter
            }

            Rectangle {
                width: 1
                height: 24
                color: colBorder
                anchors.verticalCenter: parent.verticalCenter
            }

            Column {
                anchors.verticalCenter: parent.verticalCenter
                spacing: 2

                Text {
                    text: root.isCompleted
                          ? "SYSTEM UPDATE COMPLETE"
                          : "SYSTEM UPDATE IN PROGRESS"
                    color: root.isCompleted ? colGreen : "#e2e8f0"
                    font.pixelSize: 13
                    font.bold: true
                    font.letterSpacing: 1.5
                }

                Text {
                    text: root.isCompleted
                          ? "TRANSITIONING TO APEX IVI..."
                          : "KEEP VEHICLE POWER ON"
                    color: colTextMuted
                    font.pixelSize: 11
                    font.letterSpacing: 1
                }
            }
        }
    }

    // 6. Real-Time State Synchronizer from /tmp/ota_progress.json
    Timer {
        id: progressPoller
        interval: 80
        repeat: true
        running: true
        onTriggered: {
            var xhr = new XMLHttpRequest();
            xhr.open("GET", "file:///tmp/ota_progress.json?nocache=" + Date.now());
            xhr.onreadystatechange = function() {
                if (xhr.readyState === XMLHttpRequest.DONE) {
                    if (xhr.status === 200 || xhr.status === 0) {
                        try {
                            var data = JSON.parse(xhr.responseText);
                            if (data.percent !== undefined) root.progressPercent = data.percent;
                            if (data.speed !== undefined) root.transferSpeed = data.speed;
                            if (data.received !== undefined) root.receivedBytes = data.received;
                            if (data.total !== undefined) root.totalBytes = data.total;
                            if (data.eta !== undefined) root.etaStr = data.eta;
                            if (data.component !== undefined) root.activeComponent = data.component;
                            if (data.status === "completed") {
                                root.isCompleted = true;
                                root.progressPercent = 100;
                            } else {
                                root.isCompleted = false;
                            }
                        } catch (e) {}
                    }
                }
            };
            xhr.send();
        }
    }
}
