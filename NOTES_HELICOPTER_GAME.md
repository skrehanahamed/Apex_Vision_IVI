# Endless Helicopter Reborn — IVI Porting & Integration Notes

**Date & Time**: October 8, 2026  
**Status**: In Progress — Paused for review tomorrow  
**Reference Project**: [jessejamesblack/endless-helicopter-reborn](https://github.com/jessejamesblack/endless-helicopter-reborn)  

---

## 1. Executive Summary & Objective
Recreate the authentic Godot endless runner game **"Endless Helicopter Reborn"** by Jesse James Black as an embedded Cockpit Entertainment game in **APEX VISION IVI**.
- **Phase 1**: Run, test, and verify every piece of code on **macOS** first.
- **Phase 2**: Polish the game icon in `GamesPage.qml` (add rounded squircle border, neon glow, and center alignment).
- **Phase 3**: Cross-compile and deploy to **Raspberry Pi 5** (`/opt/apex_vision_ivi`).

---

## 2. Work Completed So Far

### A. Authentic Assets Downloaded & Organized
- **Directory**: `web/helicopter/`
  - **Images (`web/helicopter/images/`)**:
    - `BadGames.png` & `EndlessHelicopter.png` (authentic title logos)
    - `alien_cavern/`: `sky.png`, `far.png`, `mid.png`, `near.png` (authentic 4-layer parallax background extracted from Godot gameplay)
    - `canyon_run/`: Alternate desert biome parallax layers
    - `blackhawk_shadow.svg`, `bubble_chopper.svg`, `helicopter.svg`
    - `obstacle.svg`, `missile.svg`, `missile_pickup.svg`
    - `fire_button.svg` (authentic hexagonal fire button from mobile build)
  - **Audio (`web/helicopter/audio/`)**:
    - `helicopter.mp3` (continuous rotor audio loop)
    - `canyon_run.wav` (authentic in-game canyon music)
    - `player_missile_fire.wav` (missile launch SFX)
    - `death.wav` (crash / explosion SFX)
    - `missile_reload_retro.wav` (missile pickup chime)

### B. Game Engine Recreated (`web/helicopter/index.html`)
- **Title Screen**: Faithful recreation of the author's title screen with both `BadGames` and `EndlessHelicopter` badges, pulsing "Tap, click, or press Space to continue" pill.
- **Gameplay**:
  - 4-layer parallax scrolling background (`alien_cavern`).
  - Procedural cavern terrain (organic ceiling and floor stalactites/stalagmites).
  - Authentic helicopter physics: smooth lift acceleration on hold, natural gravity glide on release, dynamic pitch tilting, and rotor blur.
  - Floating rocky obstacles and missile crates (`+3 Missiles`).
  - Missile launching with smoke trails, particle blast rings, and collision explosion effects.
  - Godot-accurate HUD: Top score pill with gold numbers, cyan missile counter, pause button, and bottom-right hexagonal fire button.
  - Dual control scheme: Mouse/touch hold anywhere or `Space` for lift; tap `FIRE` or press `X` for missiles.

### C. Mac Browser Validation
- Tested via `http://localhost:8089/` in Safari on macOS:
  - Title screen, audio triggers, and responsive full-screen canvas verified working.

---

## 3. Findings & Tomorrow's Checklist

### 1. In-App WebEngine Canvas Blank Fix
- **Issue**: When opening the game inside the IVI app on macOS, the top bar (`← EXIT`) shows, but the WebEngine center canvas was blank.
- **Root Cause & Solution**:
  - Canvas size initialization in `index.html` relies on `window.innerWidth` / `innerHeight`, which may evaluate to `0` or minimal dimensions before the QML layout finishes. Add default fallbacks (`1920x1080`) and trigger resize handlers on load.
  - In `qml/pages/HelicopterGameView.qml`:
    - Ensure `settings.localContentCanAccessFileUrls: true` and `settings.allowFileAccessFromFileUrls: true` are enabled.
    - Check file URL format: use `Qt.resolvedUrl("../../web/helicopter/index.html")` or `QUrl::fromLocalFile` for universal macOS & Pi 5 path resolution.

### 2. Game Icon & Border in `GamesPage.qml`
- **Request**: "fix the icon also add a border to it make it look good"
- **Tasks**:
  - Match the style of `Racer` (`game_retro_racer.svg`) and `2048` (`game_retro_2048.svg`):
    - 128x128 SVG with `rx="28"` background shield.
    - Curated gradient background (e.g. deep cyber-navy/teal `#08101E` to `#0A2238`).
    - Crisp neon accent border (`stroke="#00D2FF" stroke-width="2.5"`).
    - Authentic Blackhawk / Bubble chopper silhouette with rotor blur and glowing horizon canyon.
  - Update `qml/assets/icons/game_helicopter.svg` and `game_helicopter.png`.
  - Verify centering and scaling inside `GamesPage.qml`.

### 3. Deploy & Verify on Raspberry Pi 5
- Sync updated `web/helicopter/` directory to Pi 5 (`/opt/apex_vision_ivi/web/helicopter/`).
- Compile binary and updated `assets.rcc` via `./patch-pi5.sh`.
- Run on Pi 5 (`./apex_vision_ivi -platform wayland`) and confirm 60 FPS performance and touch controls.

---

## 4. Key Files
- `web/helicopter/index.html` — Canvas game engine
- `web/helicopter/images/` — Author's game textures & sprites
- `web/helicopter/audio/` — Sound effects & music
- `qml/pages/HelicopterGameView.qml` — IVI WebEngine container
- `qml/pages/GamesPage.qml` — Games menu & icon card
- `qml/assets/icons/game_helicopter.svg` / `.png` — Game icon
