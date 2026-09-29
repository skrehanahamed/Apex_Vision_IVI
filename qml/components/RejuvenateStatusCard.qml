import QtQuick
import QtQuick.Controls

Item {
    id: root

    property string iconType: "ambient" // "ambient", "climate", "sound", "seat", "massage"
    property string label: ""
    property string value: ""
    property color accentColor: "#24D9FF"

    height: 94
    implicitWidth: 140

    Rectangle {
        id: cardBg
        anchors.fill: parent
        radius: 14
        color: Qt.rgba(0.04, 0.09, 0.18, 0.60)
        border.color: Qt.rgba(0.18, 0.45, 0.85, 0.22)
        border.width: 1

        Column {
            anchors.fill: parent
            anchors.margins: 10
            spacing: 5

            // Icon item
            Item {
                width: 24
                height: 24
                anchors.horizontalCenter: parent.horizontalCenter

                Canvas {
                    id: iconCanvas
                    anchors.fill: parent
                    onPaint: {
                        var ctx = getContext("2d");
                        ctx.reset();
                        ctx.strokeStyle = root.accentColor;
                        ctx.fillStyle = root.accentColor;
                        ctx.lineWidth = 1.8;
                        ctx.lineCap = "round";
                        ctx.lineJoin = "round";

                        var w = width;
                        var h = height;

                        if (root.iconType === "ambient") {
                            // Sun / ambient light rays
                            ctx.beginPath();
                            ctx.arc(w/2, h/2, 4.5, 0, 2 * Math.PI);
                            ctx.stroke();

                            // 8 rays
                            var r1 = 7.5;
                            var r2 = 10.5;
                            for (var i = 0; i < 8; i++) {
                                var angle = (i * Math.PI) / 4;
                                ctx.beginPath();
                                ctx.moveTo(w/2 + Math.cos(angle)*r1, h/2 + Math.sin(angle)*r1);
                                ctx.lineTo(w/2 + Math.cos(angle)*r2, h/2 + Math.sin(angle)*r2);
                                ctx.stroke();
                            }
                        } else if (root.iconType === "climate") {
                            // Thermometer
                            ctx.beginPath();
                            ctx.arc(w/2, h - 7, 4, 0, 2 * Math.PI);
                            ctx.fill();
                            ctx.beginPath();
                            ctx.moveTo(w/2 - 2, h - 10);
                            ctx.lineTo(w/2 - 2, 5);
                            ctx.arc(w/2, 5, 2, Math.PI, 0);
                            ctx.lineTo(w/2 + 2, h - 10);
                            ctx.stroke();
                        } else if (root.iconType === "sound") {
                            // Musical eighth note
                            ctx.beginPath();
                            ctx.arc(w/2 - 3, h - 6, 3, 0, 2 * Math.PI);
                            ctx.fill();
                            ctx.beginPath();
                            ctx.moveTo(w/2, h - 6);
                            ctx.lineTo(w/2, 5);
                            ctx.lineTo(w/2 + 7, 8);
                            ctx.lineTo(w/2 + 7, 13);
                            ctx.lineTo(w/2, 10);
                            ctx.stroke();
                        } else if (root.iconType === "seat") {
                            // Reclining automotive seat outline
                            ctx.beginPath();
                            // Backrest
                            ctx.moveTo(w/2 - 5, 5);
                            ctx.lineTo(w/2 - 2, 14);
                            // Cushion
                            ctx.lineTo(w/2 + 7, 14);
                            ctx.stroke();
                            // Base
                            ctx.beginPath();
                            ctx.moveTo(w/2 - 3, 18);
                            ctx.lineTo(w/2 + 5, 18);
                            ctx.stroke();
                        } else if (root.iconType === "massage") {
                            // Wavy massage / heated pulse curves
                            for (var k = 0; k < 3; k++) {
                                var xOff = (w/2 - 6) + k * 6;
                                ctx.beginPath();
                                ctx.moveTo(xOff, 6);
                                ctx.bezierCurveTo(xOff + 3, 10, xOff - 3, 14, xOff + 1, 18);
                                ctx.stroke();
                            }
                        }
                    }
                }
            }

            // Category Label
            Text {
                text: root.label
                color: "#7E99BA"
                font.family: "Inter"
                font.pixelSize: 12
                font.weight: Font.Normal
                anchors.horizontalCenter: parent.horizontalCenter
                elide: Text.ElideRight
            }

            // Active Target Value
            Text {
                text: root.value
                color: root.accentColor
                font.family: "Inter"
                font.pixelSize: 14
                font.weight: Font.DemiBold
                anchors.horizontalCenter: parent.horizontalCenter
                elide: Text.ElideRight
            }
        }
    }
}
