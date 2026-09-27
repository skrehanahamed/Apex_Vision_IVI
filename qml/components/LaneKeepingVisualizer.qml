import QtQuick
import QtQuick.Controls

Item {
    id: visualizer

    property string mode: "Alert" // "Alert", "Aid", "Alert + aid"
    property string intensity: "Normal" // "Low", "Normal", "High"
    property bool running: true

    // Continuous dynamic motion properties
    property real roadTime: 0.0          // continuous highway motion tracker
    property real wheelSpinAngle: 0.0    // continuous spinning wheel angle (degrees)
    property real suspensionY: 0.0       // micro chassis suspension heave (pixels)
    property real steeringAngle: 0.0     // steering wheel angle (degrees)
    property real hapticRipplePhase: 0.0 // continuous ripple wave phase (0.0 to 1.0)
    property real arrowNudgeAngle: 0.0   // small counter-steering torque arrow nudge angle (radians)
    property bool isIntervening: false   // whether lane departure intervention is active
    readonly property bool isAlertActive: visualizer.mode === "Alert" || (visualizer.mode === "Alert + aid" && visualizer.isIntervening)

    clip: true

    // =========================================================================
    // 60 FPS CONTINUOUS DYNAMIC MOTION ENGINE (High Speed & Ultra-Smooth)
    // =========================================================================
    FrameAnimation {
        running: visualizer.running && visualizer.visible
        onTriggered: {
            var dt = frameTime > 0.0 ? frameTime : 0.016;

            // 1. Continuous forward highway travel at high speed (time accumulator)
            visualizer.roadTime += dt;
            var t = visualizer.roadTime;

            // 2. High-speed continuous rotating wheels in 3D (synchronized to 13.5 m/s highway speed)
            // Circumference ~2.17m -> 13.5 / 2.17 * 360 deg/s ≈ 2240 deg/s
            visualizer.wheelSpinAngle = (visualizer.wheelSpinAngle - dt * 2240.0) % 360.0;

            // 3. Micro suspension road vibration & chassis heave (~14 Hz)
            visualizer.suspensionY = Math.sin(t * 14.0) * 0.6 + Math.cos(t * 7.5) * 0.3;

            // 4. Small counter-steering torque arrow nudge motion (does NOT go full circle)
            visualizer.arrowNudgeAngle = Math.sin(t * 3.2) * 0.14 * Math.PI;

            // 5. Continuous haptic ripple wave expansion (radiates smoothly outwards)
            visualizer.hapticRipplePhase = (t * 2.5) % 1.0;

            // 6. Lane Keeping Intervention Cycle (4.8 seconds loop)
            var cycle = (t / 4.8) % 1.0;
            var currentMode = visualizer.mode;
            var vibeAmp = visualizer.intensity === "High" ? 5.2 : (visualizer.intensity === "Low" ? 2.4 : 3.8);

            visualizer.isIntervening = (cycle >= 0.35 && cycle <= 0.85);

            if (currentMode === "Aid" || currentMode === "Alert + aid") {
                if (cycle >= 0.50 && cycle <= 0.85) {
                    var tAid = (cycle - 0.50) / 0.35;
                    visualizer.steeringAngle = Math.sin(tAid * Math.PI) * 18.0;
                } else {
                    visualizer.steeringAngle = Math.sin(t * 1.5) * 1.5;
                }
            } else {
                visualizer.steeringAngle = 0.0;
            }

            // Continuous haptic vibration in Alert mode:
            if (currentMode === "Alert" || (currentMode === "Alert + aid" && cycle >= 0.35 && cycle <= 0.65)) {
                var continuousVibe = Math.sin(t * 54.0) * (visualizer.isIntervening ? vibeAmp : (vibeAmp * 0.6));
                visualizer.steeringAngle += continuousVibe;
            }

            laneCanvas.requestPaint();
            badgeCanvas.requestPaint();
        }
    }

    // =========================================================================
    // 1. COCKPIT STUDIO ROAD BACKGROUND
    // =========================================================================
    Rectangle {
        anchors.fill: parent
        radius: 20
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#060B17" }
            GradientStop { position: 0.45; color: "#081020" }
            GradientStop { position: 1.0; color: "#03060C" }
        }
    }

    // =========================================================================
    // 2. ANIMATED PERSPECTIVE HIGHWAY LANES & REALISTIC LAND SCAN EFFECT
    // - Mathematically projected through vehicle camera (pitch -30°, yaw 155°)
    // - Right line skims the vehicle and touches the right rear tire contact patch
    // - Luminous "land scan" radar/lidar surface under the right rear wheel
    // - Ultra-smooth 60 FPS high-speed highway dash flow
    // - Left: Luminous Emerald Green (#00E676)
    // - Right: Lime-Yellow (#D2F827) transitioning to Vivid Neon Red (#FF1A35) on Alert
    // =========================================================================
    Canvas {
        id: laneCanvas
        anchors.fill: parent

        property color rightColor: visualizer.isAlertActive ? "#FF1E40" : "#00FF7F"
        Behavior on rightColor { ColorAnimation { duration: 240 } }

        property color rightGlow: visualizer.isAlertActive ? "rgba(255, 30, 60, 0.45)" : "rgba(0, 255, 127, 0.45)"
        Behavior on rightGlow { ColorAnimation { duration: 240 } }

        onPaint: {
            var ctx = getContext("2d");
            ctx.clearRect(0, 0, width, height);

            var w = width;
            var h = height;
            if (w <= 10 || h <= 10) return;

            // -----------------------------------------------------------------
            // EXACT CAMERA PROJECTION MATRIX (Matching LaneKeepingCarView3D.qml)
            // -----------------------------------------------------------------
            var pitch = -30.0 * Math.PI / 180.0;
            var yaw = 155.0 * Math.PI / 180.0;
            var cosP = Math.cos(pitch), sinP = Math.sin(pitch);
            var cosY = Math.cos(yaw),   sinY = Math.sin(yaw);

            var R00 = cosY,  R01 = sinY * sinP,  R02 = sinY * cosP;
            var R10 = 0.0,   R11 = cosP,         R12 = -sinP;
            var R20 = -sinY, R21 = cosY * sinP,  R22 = cosY * cosP;

            var camDist = 10.0;
            var camX = 0.26 + R02 * camDist;
            var camY = (0.44 + visualizer.suspensionY * 0.002) + R12 * camDist;
            var camZ = 0.00 + R22 * camDist;

            var fovY = 26.0 * Math.PI / 180.0;
            var fy = 1.0 / Math.tan(fovY * 0.5);
            var fx = fy / (w / h);

            function project(px, py, pz) {
                var dx = px - camX;
                var dy = py - camY;
                var dz = pz - camZ;
                var cx = R00 * dx + R10 * dy + R20 * dz;
                var cy = R01 * dx + R11 * dy + R21 * dz;
                var cz = R02 * dx + R12 * dy + R22 * dz;
                if (cz >= -0.1) return null;
                var invZ = -1.0 / cz;
                return {
                    x: (fx * cx * invZ + 1.0) * 0.5 * w,
                    y: (1.0 - fy * cy * invZ) * 0.5 * h,
                    scale: invZ * 10.0
                };
            }

            var t = visualizer.roadTime;
            var speed = 13.5;         // High speed highway cruising (13.5 m/s)
            var period = 4.8;         // Segment cycle length (m)
            var dashLen = 2.4;        // Clean realistic dash length (m)
            var halfW = 0.040;        // Half width of lane line (m)
            var isAlert = visualizer.isAlertActive;
            var xRight = -1.10;       // Right line position touching right rear wheel

            // =================================================================
            // HIGH-SPEED PERSPECTIVE LANE DASH & DYNAMIC SCAN GENERATOR
            // 100% mathematically continuous, non-overlapping, ultra-smooth flow
            // =================================================================
            var roadZ = t * speed;
            var kMin = Math.floor((-3.5 + roadZ) / period) - 1;
            var kMax = Math.ceil((6.5 + roadZ) / period) + 1;

            // -----------------------------------------------------------------
            // 1. LEFT TRACK: VIBRANT BRIGHT NEON GREEN (#00FF7F)
            // -----------------------------------------------------------------
            var xLeft = 1.80;
            for (var kl = kMin; kl <= kMax; kl++) {
                var zCenterL = kl * period - roadZ;
                var zStartL = zCenterL - dashLen * 0.5;
                var zEndL   = zCenterL + dashLen * 0.5;
                if (zEndL < -3.5 || zStartL > 6.5) continue;

                // Subtle distance fade near boundaries
                var alphaL = 1.0;
                if (zStartL > 4.5) alphaL = Math.max(0.0, Math.min(1.0, (6.5 - zStartL) / 2.0));
                if (zEndL < -2.0)   alphaL = Math.min(alphaL, Math.max(0.0, (zEndL - (-3.5)) / 1.5));

                var pL_TL = project(xLeft - halfW, 0.0, zEndL);
                var pL_TR = project(xLeft + halfW, 0.0, zEndL);
                var pL_BR = project(xLeft + halfW, 0.0, zStartL);
                var pL_BL = project(xLeft - halfW, 0.0, zStartL);

                if (pL_TL && pL_TR && pL_BR && pL_BL) {
                    ctx.save();

                    // Outer neon green glow
                    ctx.beginPath();
                    ctx.moveTo(pL_TL.x - 4, pL_TL.y);
                    ctx.lineTo(pL_TR.x + 4, pL_TR.y);
                    ctx.lineTo(pL_BR.x + 4, pL_BR.y);
                    ctx.lineTo(pL_BL.x - 4, pL_BL.y);
                    ctx.closePath();
                    ctx.fillStyle = "rgba(0, 255, 127, " + (0.45 * alphaL).toFixed(3) + ")";
                    ctx.fill();

                    // Main vibrant bright green body
                    ctx.beginPath();
                    ctx.moveTo(pL_TL.x, pL_TL.y);
                    ctx.lineTo(pL_TR.x, pL_TR.y);
                    ctx.lineTo(pL_BR.x, pL_BR.y);
                    ctx.lineTo(pL_BL.x, pL_BL.y);
                    ctx.closePath();
                    ctx.fillStyle = "rgba(0, 255, 127, " + (0.98 * alphaL).toFixed(3) + ")";
                    ctx.fill();

                    // Luminous white-green core highlight line
                    var pcL_end = project(xLeft, 0.0, zEndL);
                    var pcL_start = project(xLeft, 0.0, zStartL);
                    if (pcL_end && pcL_start) {
                        ctx.beginPath();
                        ctx.moveTo(pcL_end.x, pcL_end.y);
                        ctx.lineTo(pcL_start.x, pcL_start.y);
                        ctx.strokeStyle = "rgba(240, 255, 245, " + (0.95 * alphaL).toFixed(3) + ")";
                        ctx.lineWidth = Math.max(1.6, 2.6 * pcL_start.scale);
                        ctx.lineCap = "round";
                        ctx.stroke();
                    }

                    ctx.restore();
                }
            }

            // -----------------------------------------------------------------
            // 2. RIGHT TRACK & ATTACHED DYNAMIC LAND SCAN:
            // - In Alert: Bright Vivid Warning Red (#FF1E40) + Red Scan
            // - In Aid: Bright Vivid Neon Green (#00FF7F) + Green Scan
            // - Shows scan box ONLY when dash is present at rear wheel;
            //   when the black gap passes, scan becomes black!
            // -----------------------------------------------------------------
            for (var kr = kMin; kr <= kMax; kr++) {
                var zCenterR = kr * period - roadZ;
                var zStartR = zCenterR - dashLen * 0.5;
                var zEndR   = zCenterR + dashLen * 0.5;
                if (zEndR < -3.5 || zStartR > 6.5) continue;

                var alphaR = 1.0;
                if (zStartR > 4.5) alphaR = Math.max(0.0, Math.min(1.0, (6.5 - zStartR) / 2.0));
                if (zEndR < -2.0)   alphaR = Math.min(alphaR, Math.max(0.0, (zEndR - (-3.5)) / 1.5));

                // A. DYNAMIC LAND SCAN BOX (Attached to this dash!)
                // Only appears when this dash passes the right rear tyre zone [-0.40 .. -2.40].
                // When black gap is there, scan is black!
                var zScanTop = Math.min(-0.40, zEndR);
                var zScanBot = Math.max(-2.40, zStartR);

                if (zScanTop > zScanBot) {
                    var pScanTL = project(-0.70, 0.0, zScanTop);
                    var pScanTR = project(xRight, 0.0, zScanTop);
                    var pScanBR = project(xRight, 0.0, zScanBot);
                    var pScanBL = project(-0.62, 0.0, zScanBot);

                    if (pScanTL && pScanTR && pScanBR && pScanBL) {
                        ctx.save();

                        // 1. Soft glowing outer ambient aura
                        ctx.beginPath();
                        ctx.moveTo(pScanTL.x - 5, pScanTL.y);
                        ctx.lineTo(pScanTR.x + 4, pScanTR.y);
                        ctx.lineTo(pScanBR.x + 5, pScanBR.y);
                        ctx.lineTo(pScanBL.x - 5, pScanBL.y);
                        ctx.closePath();
                        ctx.fillStyle = isAlert
                            ? "rgba(255, 30, 60, " + (0.35 * alphaR).toFixed(3) + ")"
                            : "rgba(0, 255, 127, " + (0.30 * alphaR).toFixed(3) + ")";
                        ctx.fill();

                        // 2. Main luminous scan box fill surface (Bright Vibrant Color)
                        ctx.beginPath();
                        ctx.moveTo(pScanTL.x, pScanTL.y);
                        ctx.lineTo(pScanTR.x, pScanTR.y);
                        ctx.lineTo(pScanBR.x, pScanBR.y);
                        ctx.lineTo(pScanBL.x, pScanBL.y);
                        ctx.closePath();

                        var scanGrad = ctx.createLinearGradient(pScanTL.x, pScanTL.y, pScanBR.x, pScanBR.y);
                        if (isAlert) {
                            scanGrad.addColorStop(0.0, "rgba(255, 30, 60, " + (0.75 * alphaR).toFixed(3) + ")");
                            scanGrad.addColorStop(0.40, "rgba(255, 70, 95, " + (0.55 * alphaR).toFixed(3) + ")");
                            scanGrad.addColorStop(1.0, "rgba(255, 20, 50, " + (0.15 * alphaR).toFixed(3) + ")");
                        } else {
                            scanGrad.addColorStop(0.0, "rgba(0, 255, 127, " + (0.70 * alphaR).toFixed(3) + ")");
                            scanGrad.addColorStop(0.40, "rgba(50, 255, 160, " + (0.50 * alphaR).toFixed(3) + ")");
                            scanGrad.addColorStop(1.0, "rgba(0, 230, 110, " + (0.15 * alphaR).toFixed(3) + ")");
                        }
                        ctx.fillStyle = scanGrad;
                        ctx.fill();

                        ctx.restore();
                    }
                }

                // B. RIGHT DASH LINE SEGMENT
                var pR_TL = project(xRight - halfW, 0.0, zEndR);
                var pR_TR = project(xRight + halfW, 0.0, zEndR);
                var pR_BR = project(xRight + halfW, 0.0, zStartR);
                var pR_BL = project(xRight - halfW, 0.0, zStartR);

                if (pR_TL && pR_TR && pR_BR && pR_BL) {
                    ctx.save();

                    // Outer bright neon glow
                    ctx.beginPath();
                    ctx.moveTo(pR_TL.x - 4, pR_TL.y);
                    ctx.lineTo(pR_TR.x + 4, pR_TR.y);
                    ctx.lineTo(pR_BR.x + 4, pR_BR.y);
                    ctx.lineTo(pR_BL.x - 4, pR_BL.y);
                    ctx.closePath();
                    ctx.fillStyle = isAlert
                        ? "rgba(255, 30, 60, " + (0.45 * alphaR).toFixed(3) + ")"
                        : "rgba(0, 255, 127, " + (0.45 * alphaR).toFixed(3) + ")";
                    ctx.fill();

                    // Main vibrant bright body
                    ctx.beginPath();
                    ctx.moveTo(pR_TL.x, pR_TL.y);
                    ctx.lineTo(pR_TR.x, pR_TR.y);
                    ctx.lineTo(pR_BR.x, pR_BR.y);
                    ctx.lineTo(pR_BL.x, pR_BL.y);
                    ctx.closePath();
                    ctx.fillStyle = isAlert
                        ? "rgba(255, 30, 60, " + (0.98 * alphaR).toFixed(3) + ")"
                        : "rgba(0, 255, 127, " + (0.98 * alphaR).toFixed(3) + ")";
                    ctx.fill();

                    // Luminous core highlight line
                    var pcR_end = project(xRight, 0.0, zEndR);
                    var pcR_start = project(xRight, 0.0, zStartR);
                    if (pcR_end && pcR_start) {
                        ctx.beginPath();
                        ctx.moveTo(pcR_end.x, pcR_end.y);
                        ctx.lineTo(pcR_start.x, pcR_start.y);
                        ctx.strokeStyle = isAlert
                            ? "rgba(255, 245, 245, " + (0.95 * alphaR).toFixed(3) + ")"
                            : "rgba(240, 255, 245, " + (0.95 * alphaR).toFixed(3) + ")";
                        ctx.lineWidth = Math.max(1.6, 2.6 * pcR_start.scale);
                        ctx.lineCap = "round";
                        ctx.stroke();
                    }

                    ctx.restore();
                }
            }
        }
    }

    // =========================================================================
    // 4. REALISTIC 3D VEHICLE WITH DYNAMIC CONTINUOUS ROTATING WHEELS
    // - User-selected optimal elevated rear 3/4 perspective (p: -30°, y: 155°)
    // - True 3D spinning wheels (objects 9, 10, 21, 29) rotating continuously
    // - Rich studio lighting with amber flank rim highlight
    // =========================================================================
    Loader {
        id: car3DLoader
        anchors.fill: parent
        source: (typeof LaneKeeping3DCarUrl !== "undefined") ? LaneKeeping3DCarUrl : ""
    }

    Binding {
        target: car3DLoader.item
        property: "wheelAngle"
        value: visualizer.wheelSpinAngle
        when: car3DLoader.status === Loader.Ready
    }

    Binding {
        target: car3DLoader.item
        property: "suspensionY"
        value: visualizer.suspensionY
        when: car3DLoader.status === Loader.Ready
    }

    // =========================================================================
    // 6. TOP-RIGHT OEM STEERING WHEEL BADGE (White/Silver Monochrome)
    // - In Aid: Small curved torque arrows on TOP and BOTTOM that nudge subtly
    //           (Does NOT go full circle; leaves left & right free for haptics)
    // - In Alert: Lateral haptic vibration ripple arcs [ ((( ⎈ ))) ] on LEFT and RIGHT
    // - In Aid + Alert: Both display simultaneously without collision!
    // - Strictly white/silver monochrome (NO color changes)
    // =========================================================================
    Rectangle {
        id: steeringBadge
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: 18
        width: 88
        height: 88
        radius: 12
        color: Qt.rgba(8/255, 14/255, 24/255, 0.90)
        border.color: Qt.rgba(255, 255, 255, 0.38)
        border.width: 1.2

        // Dynamic Badge Canvas: Draws Torque Arrows (Aid) and/or Haptic Waves (Alert)
        Canvas {
            id: badgeCanvas
            anchors.fill: parent

            onPaint: {
                var ctx = getContext("2d");
                ctx.clearRect(0, 0, width, height);

                var cx = width / 2;
                var cy = height / 2;

                var isAidMode = visualizer.mode === "Aid" || visualizer.mode === "Alert + aid";
                var isAlertMode = visualizer.mode === "Alert" || visualizer.mode === "Alert + aid";

                // =============================================================
                // AID: SMALL CURVED TORQUE ARROWS (TOP & BOTTOM ONLY)
                // They do NOT go full circle. They stay on top and bottom,
                // nudging slightly counter-clockwise, leaving the sides free!
                // =============================================================
                if (isAidMode) {
                    var r = 36;
                    var arrowColor = "rgba(255, 255, 255, 0.92)";

                    ctx.strokeStyle = arrowColor;
                    ctx.fillStyle = arrowColor;
                    ctx.lineWidth = 2.4;
                    ctx.lineCap = "round";

                    // Small arc length: ~48 degrees (0.27 * PI)
                    var arcLen = Math.PI * 0.27;
                    var aLen = 7.2;
                    var aW = 3.8;

                    // --- 1. TOP ARROW (Strictly across the TOP rim, pointing down-left) ---
                    // Centered at North (1.50 * PI) + small nudge offset
                    var centerTop = Math.PI * 1.50 + visualizer.arrowNudgeAngle;
                    var aStartTop = centerTop + arcLen * 0.5;
                    var aEndTop = centerTop - arcLen * 0.5; // leading tip points left

                    ctx.beginPath();
                    ctx.arc(cx, cy, r, aStartTop, aEndTop, true); // counter-clockwise
                    ctx.stroke();

                    // Tangent aligned arrowhead at aEndTop
                    var hx1 = cx + r * Math.cos(aEndTop);
                    var hy1 = cy + r * Math.sin(aEndTop);
                    var tx1 = Math.sin(aEndTop);
                    var ty1 = -Math.cos(aEndTop);

                    ctx.beginPath();
                    ctx.moveTo(hx1, hy1);
                    ctx.lineTo(hx1 - tx1 * aLen + ty1 * aW, hy1 - ty1 * aLen - tx1 * aW);
                    ctx.lineTo(hx1 - tx1 * aLen - ty1 * aW, hy1 - ty1 * aLen + tx1 * aW);
                    ctx.closePath();
                    ctx.fill();

                    // --- 2. BOTTOM ARROW (Strictly across the BOTTOM rim, pointing up-right) ---
                    // Centered at South (0.50 * PI) + small nudge offset
                    var centerBot = Math.PI * 0.50 + visualizer.arrowNudgeAngle;
                    var aStartBot = centerBot + arcLen * 0.5;
                    var aEndBot = centerBot - arcLen * 0.5; // leading tip points right

                    ctx.beginPath();
                    ctx.arc(cx, cy, r, aStartBot, aEndBot, true); // counter-clockwise
                    ctx.stroke();

                    // Tangent aligned arrowhead at aEndBot
                    var hx2 = cx + r * Math.cos(aEndBot);
                    var hy2 = cy + r * Math.sin(aEndBot);
                    var tx2 = Math.sin(aEndBot);
                    var ty2 = -Math.cos(aEndBot);

                    ctx.beginPath();
                    ctx.moveTo(hx2, hy2);
                    ctx.lineTo(hx2 - tx2 * aLen + ty2 * aW, hy2 - ty2 * aLen - tx2 * aW);
                    ctx.lineTo(hx2 - tx2 * aLen - ty2 * aW, hy2 - ty2 * aLen + tx2 * aW);
                    ctx.closePath();
                    ctx.fill();
                }

                // =============================================================
                // ALERT: LATERAL HAPTIC VIBRATION WAVES [ ((( ⎈ ))) ]
                // Strictly on LEFT and RIGHT sides. Never collides with top/bottom arrows!
                // =============================================================
                if (isAlertMode) {
                    var waveProgress = visualizer.hapticRipplePhase;
                    ctx.lineWidth = 1.8;
                    ctx.lineCap = "round";

                    // 3 concentric vibration arcs on each side
                    var waveRadii = [31, 37, 43];

                    for (var wIdx = 0; wIdx < waveRadii.length; wIdx++) {
                        var baseR = waveRadii[wIdx];
                        // Outward radiating ripple pulsation
                        var waveR = baseR + waveProgress * 2.5;
                        var alpha = Math.max(0.15, 0.95 - (wIdx * 0.28) - (waveProgress * 0.25));

                        ctx.strokeStyle = "rgba(255, 255, 255, " + alpha.toFixed(2) + ")";

                        // Left Arcs ((( (Strictly West: 150 deg to 210 deg)
                        ctx.beginPath();
                        ctx.arc(cx, cy, waveR, Math.PI * 0.83, Math.PI * 1.17, false);
                        ctx.stroke();

                        // Right Arcs ))) (Strictly East: 330 deg to 30 deg)
                        ctx.beginPath();
                        ctx.arc(cx, cy, waveR, Math.PI * 1.83, Math.PI * 0.17, false);
                        ctx.stroke();
                    }
                }
            }
        }

        // Steering Wheel PNG Asset (User's 4K transparent asset)
        Image {
            id: steeringWheelImg
            anchors.centerIn: parent
            width: 52
            height: 52
            source: "qrc:/ApexVision/qml/assets/icons/lane_assist_steering.png"
            fillMode: Image.PreserveAspectFit
            smooth: true
            mipmap: true

            // Continuous dynamic rotation / haptic rumble oscillation
            rotation: visualizer.steeringAngle
        }
    }
}
