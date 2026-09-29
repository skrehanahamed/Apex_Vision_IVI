import QtQuick

Item {
    id: root

    property double progress: 0.0 // 0.0 to 1.0
    property string timeText: "10:00"
    property string phaseText: "Immersion"
    property color ringColor: "#24D9FF"

    implicitWidth: 160
    implicitHeight: 160

    Canvas {
        id: canvas
        anchors.fill: parent
        antialiasing: true

        onPaint: {
            var ctx = getContext("2d");
            ctx.reset();

            var centerX = width / 2;
            var centerY = height / 2;
            var radius = Math.min(centerX, centerY) - 8;

            // Background track
            ctx.beginPath();
            ctx.arc(centerX, centerY, radius, 0, 2 * Math.PI);
            ctx.strokeStyle = Qt.rgba(0.2, 0.4, 0.7, 0.25);
            ctx.lineWidth = 5.0;
            ctx.stroke();

            // Progress track
            var startAngle = -0.5 * Math.PI;
            var endAngle = startAngle + (2 * Math.PI * root.progress);

            ctx.beginPath();
            ctx.arc(centerX, centerY, radius, startAngle, endAngle, false);
            ctx.strokeStyle = root.ringColor;
            ctx.lineWidth = 5.5;
            ctx.lineCap = "round";
            ctx.stroke();
        }
    }

    onProgressChanged: canvas.requestPaint()
    onRingColorChanged: canvas.requestPaint()

    Column {
        anchors.centerIn: parent
        spacing: 2

        Text {
            text: root.timeText
            color: "#FFFFFF"
            font.family: "Inter"
            font.pixelSize: 28
            font.weight: Font.DemiBold
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Text {
            text: root.phaseText
            color: "#8AB6E8"
            font.family: "Inter"
            font.pixelSize: 12
            font.weight: Font.Medium
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
}
