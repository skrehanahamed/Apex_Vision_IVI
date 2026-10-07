/**
 * ==============================================================================
 * Project: Apex VISION IVI - Digital Cockpit & Infotainment System
 * File: ApexCyberRacer.qml
 * Description: Retro Pixel Arcade Highway Runner for In-Cabin Cockpit Gaming
 * Author / Developer: Sk Rehan Ahamed
 * License: MIT
 * ==============================================================================
 */

import QtQuick
import QtQuick.Controls

Item {
    id: root
    anchors.fill: parent

    signal exitRequested()

    // Persistent High Score
    property int highScore: 0
    property int score: 0
    property int distanceKm: 0
    property int speedKmh: 140
    property int maxSpeedKmh: 280
    property int shields: 1
    property bool isShieldActive: false
    property int nitroDuration: 0 // frames remaining

    // Game States: "ready", "playing", "paused", "gameover"
    property string gameState: "ready"

    // 3 Lanes (0 = Left, 1 = Center, 2 = Right)
    property int currentLane: 1
    property real playerX: 0
    property real targetPlayerX: 0

    // Touch swipe gesture tracking
    property real touchStartX: 0
    property real touchStartY: 0

    // Component Lifecycle: Load high score
    Component.onCompleted: {
        var saved = 0;
        try {
            if (typeof PersistenceManager !== "undefined") {
                saved = PersistenceManager.getSetting("sys_cyber_racer_high_score", 0);
            }
        } catch (e) {}
        root.highScore = saved > 0 ? saved : 1850;
        root.resetGame();
    }

    function saveHighScore() {
        if (root.score > root.highScore) {
            root.highScore = root.score;
            try {
                if (typeof PersistenceManager !== "undefined") {
                    PersistenceManager.setSetting("sys_cyber_racer_high_score", root.highScore);
                }
            } catch (e) {}
        }
    }

    function resetGame() {
        root.score = 0;
        root.distanceKm = 0;
        root.speedKmh = 140;
        root.shields = 1;
        root.isShieldActive = false;
        root.nitroDuration = 0;
        root.currentLane = 1;
        gameCanvas.resetEntities();
    }

    function startGame() {
        root.resetGame();
        root.gameState = "playing";
        gameLoop.start();
    }

    function steerLeft() {
        if (root.gameState !== "playing") return;
        if (root.currentLane > 0) {
            root.currentLane--;
        }
    }

    function steerRight() {
        if (root.gameState !== "playing") return;
        if (root.currentLane < 2) {
            root.currentLane++;
        }
    }

    function activateNitro() {
        if (root.gameState !== "playing") return;
        if (root.shields > 0 && root.nitroDuration <= 0) {
            root.nitroDuration = 180; // ~3 seconds at 60 FPS
            root.isShieldActive = true;
            root.shields--;
        }
    }

    // Keyboard Controller
    focus: true
    Keys.onLeftPressed: steerLeft()
    Keys.onRightPressed: steerRight()
    Keys.onPressed: function(event) {
        if (event.key === Qt.Key_A) steerLeft();
        else if (event.key === Qt.Key_D) steerRight();
        else if (event.key === Qt.Key_Space) {
            if (root.gameState === "ready" || root.gameState === "gameover") {
                startGame();
            } else if (root.gameState === "playing") {
                activateNitro();
            }
        } else if (event.key === Qt.Key_Escape) {
            root.exitRequested();
        }
    }

    // 60 FPS High-Speed Game Timer Loop
    Timer {
        id: gameLoop
        interval: 16 // 60 FPS target
        repeat: true
        running: root.gameState === "playing"
        onTriggered: {
            gameCanvas.updatePhysics();
            gameCanvas.requestPaint();
        }
    }

    // =========================================================================
    // 1. MASTER GAME CANVAS (Pixel-Art Engine & CRT Retro Scanlines)
    // =========================================================================
    Canvas {
        id: gameCanvas
        anchors.fill: parent

        // Internal Game Physics State
        property var obstacles: []
        property var powerups: []
        property var particles: []
        property var stars: []
        property real roadOffset: 0
        property real frameCount: 0

        // Lane Centers calculation
        function getLaneX(laneIndex, roadW, roadL) {
            var laneWidth = roadW / 3;
            return roadL + laneWidth * laneIndex + laneWidth / 2;
        }

        function resetEntities() {
            obstacles = [];
            powerups = [];
            particles = [];
            stars = [];
            frameCount = 0;
            roadOffset = 0;

            // Generate initial background starfield
            for (var i = 0; i < 45; i++) {
                stars.push({
                    x: Math.random() * gameCanvas.width,
                    y: Math.random() * (gameCanvas.height * 0.45),
                    size: Math.random() > 0.7 ? 3 : 2,
                    speed: 0.3 + Math.random() * 0.5,
                    color: Math.random() > 0.5 ? "#00F0FF" : "#FF007F"
                });
            }
        }

        function triggerExplosion(x, y, color) {
            for (var i = 0; i < 24; i++) {
                var angle = Math.random() * Math.PI * 2;
                var spd = 2 + Math.random() * 6;
                particles.push({
                    x: x,
                    y: y,
                    vx: Math.cos(angle) * spd,
                    vy: Math.sin(angle) * spd,
                    life: 25 + Math.random() * 15,
                    maxLife: 40,
                    size: 3 + Math.random() * 4,
                    color: color
                });
            }
        }

        function updatePhysics() {
            frameCount++;

            // Dynamic Road Speed calculation
            var currentSpeedFactor = (root.speedKmh / 140.0);
            if (root.nitroDuration > 0) {
                root.nitroDuration--;
                currentSpeedFactor *= 1.8;
                if (root.nitroDuration === 0) {
                    root.isShieldActive = false;
                }
            }

            roadOffset = (roadOffset + 8 * currentSpeedFactor) % 40;

            // Gradually accelerate player speed over time
            if (frameCount % 60 === 0 && root.speedKmh < root.maxSpeedKmh) {
                root.speedKmh += 2;
            }

            // Odometer & Distance
            if (frameCount % 45 === 0) {
                root.score += Math.round(10 * currentSpeedFactor);
                root.distanceKm = Math.floor(root.score / 50);
            }

            // Road Bounds
            var roadWidth = Math.min(gameCanvas.width * 0.46, 420);
            var roadLeft = (gameCanvas.width - roadWidth) / 2;

            // Smooth Player Lane Movement
            targetPlayerX = getLaneX(root.currentLane, roadWidth, roadLeft);
            if (playerX === 0) playerX = targetPlayerX;
            playerX += (targetPlayerX - playerX) * 0.22;

            // Move Starfield
            for (var s = 0; s < stars.length; s++) {
                stars[s].y += stars[s].speed * currentSpeedFactor * 0.3;
                if (stars[s].y > gameCanvas.height * 0.45) {
                    stars[s].y = 0;
                    stars[s].x = Math.random() * gameCanvas.width;
                }
            }

            // Spawn Obstacles (Traffic)
            var spawnInterval = Math.max(35, Math.floor(80 - (root.speedKmh - 140) * 0.25));
            if (frameCount % spawnInterval === 0) {
                var randomLane = Math.floor(Math.random() * 3);
                var types = ["coupe", "truck", "drone"];
                var chosenType = types[Math.floor(Math.random() * types.length)];
                var obsWidth = (chosenType === "truck") ? 54 : 44;
                var obsHeight = (chosenType === "truck") ? 82 : 64;
                var obsSpeed = (chosenType === "truck") ? 3.5 : (chosenType === "drone" ? 6.5 : 4.8);

                obstacles.push({
                    lane: randomLane,
                    x: getLaneX(randomLane, roadWidth, roadLeft),
                    y: -100,
                    width: obsWidth,
                    height: obsHeight,
                    type: chosenType,
                    speed: obsSpeed
                });
            }

            // Spawn Collectibles (Energy Cells & Nitro Shields)
            if (frameCount % 130 === 0) {
                var pLane = Math.floor(Math.random() * 3);
                var isShield = (Math.random() > 0.75);
                powerups.push({
                    lane: pLane,
                    x: getLaneX(pLane, roadWidth, roadLeft),
                    y: -60,
                    type: isShield ? "shield" : "battery",
                    size: 26,
                    speed: 4.0
                });
            }

            // Player Bounding Box
            var playerY = gameCanvas.height - 150;
            var playerW = 46;
            var playerH = 72;

            // Update & Check Obstacles Collision
            for (var o = obstacles.length - 1; o >= 0; o--) {
                var obs = obstacles[o];
                obs.y += (obs.speed + (currentSpeedFactor * 3.5));

                // Bounding Box Collision
                var collideX = Math.abs(playerX - obs.x) < ((playerW + obs.width) * 0.42);
                var collideY = Math.abs((playerY + playerH / 2) - (obs.y + obs.height / 2)) < ((playerH + obs.height) * 0.42);

                if (collideX && collideY) {
                    if (root.isShieldActive) {
                        // Destroy traffic obstacle!
                        triggerExplosion(obs.x, obs.y + obs.height / 2, "#00F0FF");
                        root.score += 250;
                        obstacles.splice(o, 1);
                        continue;
                    } else {
                        // Crash! Game Over
                        triggerExplosion(playerX, playerY + playerH / 2, "#FF007F");
                        root.saveHighScore();
                        root.gameState = "gameover";
                        gameLoop.stop();
                        return;
                    }
                }

                // Remove off-screen
                if (obs.y > gameCanvas.height + 120) {
                    obstacles.splice(o, 1);
                }
            }

            // Update & Check Powerups
            for (var p = powerups.length - 1; p >= 0; p--) {
                var pow = powerups[p];
                pow.y += (pow.speed + (currentSpeedFactor * 3.5));

                var powHitX = Math.abs(playerX - pow.x) < ((playerW + pow.size) * 0.48);
                var powHitY = Math.abs((playerY + playerH / 2) - pow.y) < ((playerH + pow.size) * 0.48);

                if (powHitX && powHitY) {
                    if (pow.type === "shield") {
                        root.shields = Math.min(3, root.shields + 1);
                        root.score += 200;
                        triggerExplosion(pow.x, pow.y, "#F59E0B");
                    } else {
                        root.score += 100;
                        triggerExplosion(pow.x, pow.y, "#00F0FF");
                    }
                    powerups.splice(p, 1);
                    continue;
                }

                if (pow.y > gameCanvas.height + 60) {
                    powerups.splice(p, 1);
                }
            }

            // Update Explosion Particles
            for (var pt = particles.length - 1; pt >= 0; pt--) {
                var part = particles[pt];
                part.x += part.vx;
                part.y += part.vy;
                part.life--;
                if (part.life <= 0) {
                    particles.splice(pt, 1);
                }
            }
        }

        // =====================================================================
        // CANVAS 2D PIXEL RENDERING ENGINE
        // =====================================================================
        onPaint: {
            var ctx = getContext("2d");
            var W = width;
            var H = height;

            ctx.save();
            ctx.clearRect(0, 0, W, H);

            // 1. Dark Synthwave Sky Gradient
            var skyGrad = ctx.createLinearGradient(0, 0, 0, H * 0.5);
            skyGrad.addColorStop(0.0, "#080512");
            skyGrad.addColorStop(0.6, "#1A0933");
            skyGrad.addColorStop(1.0, "#360C4E");
            ctx.fillStyle = skyGrad;
            ctx.fillRect(0, 0, W, H * 0.5);

            // 2. Stars
            for (var s = 0; s < stars.length; s++) {
                ctx.fillStyle = stars[s].color;
                ctx.fillRect(stars[s].x, stars[s].y, stars[s].size, stars[s].size);
            }

            // 3. Glowing Synthwave Sun on the Horizon
            var sunY = H * 0.36;
            var sunR = 64;
            var sunGrad = ctx.createLinearGradient(0, sunY - sunR, 0, sunY + sunR);
            sunGrad.addColorStop(0.0, "#FF007F");
            sunGrad.addColorStop(0.5, "#FF5500");
            sunGrad.addColorStop(1.0, "#FFD700");
            ctx.fillStyle = sunGrad;
            ctx.beginPath();
            ctx.arc(W / 2, sunY, sunR, 0, Math.PI * 2);
            ctx.fill();

            // Sun horizontal pixel cuts
            ctx.fillStyle = "#1A0933";
            for (var sl = 0; sl < 6; sl++) {
                var cutY = sunY - 4 + sl * 11;
                var cutH = 2.5 + sl * 0.8;
                ctx.fillRect(W / 2 - sunR - 10, cutY, (sunR + 10) * 2, cutH);
            }

            // 4. Perspective Highway Road
            var roadWidth = Math.min(W * 0.46, 420);
            var roadLeft = (W - roadWidth) / 2;
            var roadRight = roadLeft + roadWidth;
            var horizonY = H * 0.42;

            // Road Base Fill
            ctx.fillStyle = "#0B0B14";
            ctx.fillRect(roadLeft, horizonY, roadWidth, H - horizonY);

            // Road Glowing Borders
            ctx.strokeStyle = (root.nitroDuration > 0) ? "#FF007F" : "#00F0FF";
            ctx.lineWidth = 4;
            ctx.beginPath();
            ctx.moveTo(roadLeft, horizonY);
            ctx.lineTo(roadLeft, H);
            ctx.moveTo(roadRight, horizonY);
            ctx.lineTo(roadRight, H);
            ctx.stroke();

            // Lane Divider Dashes
            ctx.strokeStyle = "#FDE047";
            ctx.lineWidth = 2.5;
            var laneWidth = roadWidth / 3;

            for (var l = 1; l <= 2; l++) {
                var lx = roadLeft + laneWidth * l;
                ctx.beginPath();
                for (var dy = horizonY - 40 + roadOffset; dy < H; dy += 40) {
                    if (dy >= horizonY) {
                        ctx.moveTo(lx, dy);
                        ctx.lineTo(lx, dy + 22);
                    }
                }
                ctx.stroke();
            }

            // 5. Draw Powerups
            for (var p = 0; p < powerups.length; p++) {
                var pow = powerups[p];
                ctx.save();
                ctx.translate(pow.x, pow.y);

                if (pow.type === "shield") {
                    // Golden Shield Orb
                    ctx.fillStyle = "#F59E0B";
                    ctx.beginPath();
                    ctx.arc(0, 0, 14, 0, Math.PI * 2);
                    ctx.fill();
                    ctx.strokeStyle = "#FDE68A";
                    ctx.lineWidth = 2.5;
                    ctx.stroke();

                    // Star icon inside
                    ctx.fillStyle = "#FFFFFF";
                    ctx.fillRect(-3, -3, 6, 6);
                } else {
                    // Cyan Energy Battery Cell
                    ctx.fillStyle = "#00F0FF";
                    ctx.fillRect(-10, -14, 20, 28);
                    ctx.fillStyle = "#FFFFFF";
                    ctx.fillRect(-5, -17, 10, 4); // Battery tip
                    // Lightning bolt
                    ctx.fillStyle = "#08101E";
                    ctx.beginPath();
                    ctx.moveTo(0, -8);
                    ctx.lineTo(-4, 0);
                    ctx.lineTo(2, 0);
                    ctx.lineTo(-1, 8);
                    ctx.lineTo(4, -1);
                    ctx.lineTo(-1, -1);
                    ctx.fill();
                }
                ctx.restore();
            }

            // 6. Draw Traffic Obstacles
            for (var o = 0; o < obstacles.length; o++) {
                var obs = obstacles[o];
                ctx.save();
                ctx.translate(obs.x, obs.y);

                if (obs.type === "truck") {
                    // Cyber Truck / Heavy Semi (Purple & Cyan)
                    ctx.fillStyle = "#3B0764";
                    ctx.fillRect(-obs.width / 2, -obs.height / 2, obs.width, obs.height);
                    ctx.fillStyle = "#7E22CE";
                    ctx.fillRect(-obs.width / 2 + 4, -obs.height / 2 + 6, obs.width - 8, obs.height - 24);
                    // Tail lights
                    ctx.fillStyle = "#EF4444";
                    ctx.fillRect(-obs.width / 2 + 4, obs.height / 2 - 6, 10, 5);
                    ctx.fillRect(obs.width / 2 - 14, obs.height / 2 - 6, 10, 5);
                } else if (obs.type === "drone") {
                    // Cyber Drone / Yellow Taxi
                    ctx.fillStyle = "#D97706";
                    ctx.fillRect(-obs.width / 2, -obs.height / 2, obs.width, obs.height);
                    ctx.fillStyle = "#FBBF24";
                    ctx.fillRect(-obs.width / 2 + 3, -obs.height / 2 + 10, obs.width - 6, obs.height - 24);
                    ctx.fillStyle = "#000000";
                    ctx.fillRect(-obs.width / 2 + 6, -obs.height / 2 + 18, obs.width - 12, 12);
                    // Red tail lights
                    ctx.fillStyle = "#EF4444";
                    ctx.fillRect(-obs.width / 2 + 3, obs.height / 2 - 5, 8, 4);
                    ctx.fillRect(obs.width / 2 - 11, obs.height / 2 - 5, 8, 4);
                } else {
                    // Red Sports Coupe
                    ctx.fillStyle = "#991B1B";
                    ctx.fillRect(-obs.width / 2, -obs.height / 2, obs.width, obs.height);
                    ctx.fillStyle = "#EF4444";
                    ctx.fillRect(-obs.width / 2 + 4, -obs.height / 2 + 12, obs.width - 8, obs.height - 26);
                    ctx.fillStyle = "#0F172A";
                    ctx.fillRect(-obs.width / 2 + 6, -obs.height / 2 + 20, obs.width - 12, 10);
                    // Tail lights
                    ctx.fillStyle = "#FF0000";
                    ctx.fillRect(-obs.width / 2 + 3, obs.height / 2 - 6, 8, 4);
                    ctx.fillRect(obs.width / 2 - 11, obs.height / 2 - 6, 8, 4);
                }
                ctx.restore();
            }

            // 7. Draw Player's Apex Cyber Coupe
            var playerY = H - 150;
            var playerW = 46;
            var playerH = 72;

            ctx.save();
            ctx.translate(playerX, playerY + playerH / 2);

            // Exhaust Flames (Pulsing Animation)
            var flameLen = (root.nitroDuration > 0) ? 28 : (12 + (frameCount % 4) * 2);
            ctx.fillStyle = (root.nitroDuration > 0) ? "#FF007F" : "#FF5500";
            ctx.fillRect(-14, playerH / 2, 7, flameLen);
            ctx.fillRect(7, playerH / 2, 7, flameLen);
            ctx.fillStyle = "#FFD700";
            ctx.fillRect(-12, playerH / 2, 3, flameLen * 0.65);
            ctx.fillRect(9, playerH / 2, 3, flameLen * 0.65);

            // Car Body (Sleek Cyan / Titanium)
            ctx.fillStyle = (root.isShieldActive) ? "#00F0FF" : "#0284C7";
            ctx.fillRect(-playerW / 2, -playerH / 2, playerW, playerH);

            // Inner Roof & Windshield
            ctx.fillStyle = "#0F172A";
            ctx.fillRect(-playerW / 2 + 6, -playerH / 2 + 18, playerW - 12, 28);
            ctx.fillStyle = "#00F0FF";
            ctx.fillRect(-playerW / 2 + 8, -playerH / 2 + 20, playerW - 16, 6);

            // Front Hood Apex Emblem
            ctx.fillStyle = "#38BDF8";
            ctx.fillRect(-4, -playerH / 2 + 4, 8, 6);

            // Rear Neon LED Tail Strip
            ctx.fillStyle = "#FF0055";
            ctx.fillRect(-playerW / 2 + 3, playerH / 2 - 6, playerW - 6, 4);
            ctx.fillStyle = "#FFAACC";
            ctx.fillRect(-playerW / 2 + 8, playerH / 2 - 5, playerW - 16, 2);

            // Wheels
            ctx.fillStyle = "#050508";
            ctx.fillRect(-playerW / 2 - 3, -playerH / 2 + 8, 3, 14);
            ctx.fillRect(playerW / 2, -playerH / 2 + 8, 3, 14);
            ctx.fillRect(-playerW / 2 - 3, playerH / 2 - 22, 3, 14);
            ctx.fillRect(playerW / 2, playerH / 2 - 22, 3, 14);

            // Invincibility Shield Bubble
            if (root.isShieldActive) {
                ctx.strokeStyle = "#00F0FF";
                ctx.lineWidth = 3;
                ctx.beginPath();
                ctx.arc(0, 0, playerH * 0.68, 0, Math.PI * 2);
                ctx.stroke();
            }

            ctx.restore();

            // 8. Explosion Particles
            for (var pt = 0; pt < particles.length; pt++) {
                var p = particles[pt];
                ctx.fillStyle = p.color;
                ctx.globalAlpha = p.life / p.maxLife;
                ctx.fillRect(p.x, p.y, p.size, p.size);
            }
            ctx.globalAlpha = 1.0;

            // 9. Retro CRT Scanline Overlay
            ctx.fillStyle = "rgba(0, 0, 0, 0.15)";
            for (var sc = 0; sc < H; sc += 4) {
                ctx.fillRect(0, sc, W, 1.5);
            }

            ctx.restore();
        }
    }

    // =========================================================================
    // 2. TOUCH GESTURE & DUAL-ZONE STEERING CONTROLS
    // =========================================================================
    MouseArea {
        id: screenTouchArea
        anchors.fill: parent
        hoverEnabled: false

        onPressed: function(mouse) {
            root.touchStartX = mouse.x;
            root.touchStartY = mouse.y;

            if (root.gameState === "ready" || root.gameState === "gameover") {
                root.startGame();
                return;
            }

            // Dual-Zone Steering: Left Half = Steer Left, Right Half = Steer Right
            if (mouse.x < width / 2) {
                root.steerLeft();
            } else {
                root.steerRight();
            }
        }

        onReleased: function(mouse) {
            var diffX = mouse.x - root.touchStartX;
            if (Math.abs(diffX) > 40) {
                if (diffX > 0) root.steerRight();
                else root.steerLeft();
            }
        }
    }

    // =========================================================================
    // 3. RETRO HEADS-UP DISPLAY (HUD)
    // =========================================================================
    Item {
        id: hudOverlay
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 80
        z: 20

        Row {
            anchors.left: parent.left
            anchors.leftMargin: 28
            anchors.verticalCenter: parent.verticalCenter
            spacing: 20

            // Exit Button
            Rectangle {
                width: 40
                height: 40
                radius: 20
                color: Qt.rgba(255, 255, 255, 0.12)
                border.color: Qt.rgba(255, 255, 255, 0.30)
                border.width: 1

                Text {
                    anchors.centerIn: parent
                    text: "←"
                    font.family: "Inter"
                    font.pixelSize: 22
                    color: "#FFFFFF"
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        gameLoop.stop();
                        root.exitRequested();
                    }
                }
            }

            // Score Badge
            Column {
                anchors.verticalCenter: parent.verticalCenter
                spacing: 2
                Text {
                    text: "SCORE"
                    font.family: "monospace"
                    font.pixelSize: 11
                    font.weight: Font.Bold
                    color: "#00F0FF"
                }
                Text {
                    text: String(root.score).padStart(6, '0')
                    font.family: "monospace"
                    font.pixelSize: 22
                    font.weight: Font.Bold
                    color: "#FFFFFF"
                }
            }

            // Best Score Badge
            Column {
                anchors.verticalCenter: parent.verticalCenter
                spacing: 2
                Text {
                    text: "BEST"
                    font.family: "monospace"
                    font.pixelSize: 11
                    font.weight: Font.Bold
                    color: "#FDE047"
                }
                Text {
                    text: String(Math.max(root.score, root.highScore)).padStart(6, '0')
                    font.family: "monospace"
                    font.pixelSize: 22
                    font.weight: Font.Bold
                    color: "#FDE047"
                }
            }
        }

        // Center Speedometer
        Rectangle {
            anchors.centerIn: parent
            width: 140
            height: 42
            radius: 21
            color: Qt.rgba(11, 19, 43, 0.75)
            border.color: (root.nitroDuration > 0) ? "#FF007F" : "#00F0FF"
            border.width: 1.5

            Row {
                anchors.centerIn: parent
                spacing: 6
                Text {
                    text: String(root.speedKmh)
                    font.family: "monospace"
                    font.pixelSize: 20
                    font.weight: Font.Bold
                    color: (root.nitroDuration > 0) ? "#FF007F" : "#00F0FF"
                    anchors.verticalCenter: parent.verticalCenter
                }
                Text {
                    text: "KM/H"
                    font.family: "monospace"
                    font.pixelSize: 11
                    font.weight: Font.DemiBold
                    color: Qt.rgba(255, 255, 255, 0.70)
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }

        // Right Shields & Nitro Status
        Row {
            anchors.right: parent.right
            anchors.rightMargin: 28
            anchors.verticalCenter: parent.verticalCenter
            spacing: 12

            Text {
                text: "SHIELD"
                font.family: "monospace"
                font.pixelSize: 12
                font.weight: Font.Bold
                color: "#F59E0B"
                anchors.verticalCenter: parent.verticalCenter
            }

            Row {
                spacing: 4
                anchors.verticalCenter: parent.verticalCenter
                Repeater {
                    model: 3
                    Rectangle {
                        width: 14
                        height: 18
                        radius: 3
                        color: (index < root.shields) ? "#F59E0B" : Qt.rgba(255, 255, 255, 0.15)
                        border.color: (index < root.shields) ? "#FDE68A" : Qt.rgba(255, 255, 255, 0.25)
                        border.width: 1
                    }
                }
            }
        }
    }

    // =========================================================================
    // 4. BOTTOM TOUCH CONTROLS (Arcade Buttons & Nitro Boost)
    // =========================================================================
    Item {
        id: bottomControls
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: 100
        z: 20

        // Left Steer Touch Pill
        Rectangle {
            anchors.left: parent.left
            anchors.leftMargin: 36
            anchors.verticalCenter: parent.verticalCenter
            width: 88
            height: 64
            radius: 20
            color: leftBtnMouse.pressed ? Qt.rgba(0, 240, 255, 0.40) : Qt.rgba(0, 240, 255, 0.18)
            border.color: "#00F0FF"
            border.width: 2

            Text {
                anchors.centerIn: parent
                text: "◄"
                font.family: "Inter"
                font.pixelSize: 28
                color: "#FFFFFF"
            }

            MouseArea {
                id: leftBtnMouse
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: root.steerLeft()
            }
        }

        // Center Nitro Boost Pill
        Rectangle {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            width: 170
            height: 54
            radius: 27
            color: (root.shields > 0) ?
                   (nitroMouse.pressed ? Qt.rgba(255, 0, 127, 0.60) : Qt.rgba(255, 0, 127, 0.30)) :
                   Qt.rgba(255, 255, 255, 0.08)
            border.color: (root.shields > 0) ? "#FF007F" : Qt.rgba(255, 255, 255, 0.20)
            border.width: 2

            Row {
                anchors.centerIn: parent
                spacing: 8
                Text {
                    text: "⚡"
                    font.pixelSize: 18
                }
                Text {
                    text: "NITRO BOOST"
                    font.family: "monospace"
                    font.pixelSize: 13
                    font.weight: Font.Bold
                    color: (root.shields > 0) ? "#FFFFFF" : Qt.rgba(255, 255, 255, 0.40)
                }
            }

            MouseArea {
                id: nitroMouse
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                enabled: root.shields > 0
                onClicked: root.activateNitro()
            }
        }

        // Right Steer Touch Pill
        Rectangle {
            anchors.right: parent.right
            anchors.rightMargin: 36
            anchors.verticalCenter: parent.verticalCenter
            width: 88
            height: 64
            radius: 20
            color: rightBtnMouse.pressed ? Qt.rgba(0, 240, 255, 0.40) : Qt.rgba(0, 240, 255, 0.18)
            border.color: "#00F0FF"
            border.width: 2

            Text {
                anchors.centerIn: parent
                text: "►"
                font.family: "Inter"
                font.pixelSize: 28
                color: "#FFFFFF"
            }

            MouseArea {
                id: rightBtnMouse
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: root.steerRight()
            }
        }
    }

    // =========================================================================
    // 5. READY / TITLE SCREEN OVERLAY
    // =========================================================================
    Rectangle {
        id: readyOverlay
        anchors.fill: parent
        color: Qt.rgba(6, 4, 15, 0.75)
        visible: root.gameState === "ready"
        z: 30

        Column {
            anchors.centerIn: parent
            spacing: 18

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "APEX CYBER RACER"
                font.family: "monospace"
                font.pixelSize: 38
                font.weight: Font.Bold
                color: "#00F0FF"
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "★ RETRO PIXEL ARCADE HIGHWAY ★"
                font.family: "monospace"
                font.pixelSize: 14
                font.weight: Font.Bold
                color: "#FF007F"
            }

            Rectangle {
                anchors.horizontalCenter: parent.horizontalCenter
                width: 220
                height: 52
                radius: 26
                color: "#00F0FF"

                Text {
                    anchors.centerIn: parent
                    text: "TAP TO PLAY"
                    font.family: "monospace"
                    font.pixelSize: 16
                    font.weight: Font.Bold
                    color: "#05070A"
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.startGame()
                }
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Tap Left / Right to Steer • Dodge Traffic • Collect Cells"
                font.family: "Inter"
                font.pixelSize: 13
                color: Qt.rgba(255, 255, 255, 0.70)
            }
        }
    }

    // =========================================================================
    // 6. GAME OVER SCREEN OVERLAY
    // =========================================================================
    Rectangle {
        id: gameOverOverlay
        anchors.fill: parent
        color: Qt.rgba(8, 2, 12, 0.88)
        visible: root.gameState === "gameover"
        z: 30

        Column {
            anchors.centerIn: parent
            spacing: 16

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "GAME OVER"
                font.family: "monospace"
                font.pixelSize: 42
                font.weight: Font.Bold
                color: "#FF0055"
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                visible: root.score >= root.highScore && root.score > 0
                text: "★ NEW HIGH SCORE! ★"
                font.family: "monospace"
                font.pixelSize: 16
                font.weight: Font.Bold
                color: "#FDE047"
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "FINAL SCORE: " + root.score
                font.family: "monospace"
                font.pixelSize: 24
                font.weight: Font.Bold
                color: "#FFFFFF"
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "DISTANCE: " + root.distanceKm + " KM  •  BEST: " + root.highScore
                font.family: "monospace"
                font.pixelSize: 14
                color: Qt.rgba(255, 255, 255, 0.70)
            }

            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 16

                Rectangle {
                    width: 170
                    height: 48
                    radius: 24
                    color: "#00F0FF"

                    Text {
                        anchors.centerIn: parent
                        text: "PLAY AGAIN"
                        font.family: "monospace"
                        font.pixelSize: 15
                        font.weight: Font.Bold
                        color: "#05070A"
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.startGame()
                    }
                }

                Rectangle {
                    width: 150
                    height: 48
                    radius: 24
                    color: Qt.rgba(255, 255, 255, 0.12)
                    border.color: Qt.rgba(255, 255, 255, 0.30)
                    border.width: 1

                    Text {
                        anchors.centerIn: parent
                        text: "EXIT"
                        font.family: "monospace"
                        font.pixelSize: 15
                        font.weight: Font.Bold
                        color: "#FFFFFF"
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.exitRequested()
                    }
                }
            }
        }
    }
}
