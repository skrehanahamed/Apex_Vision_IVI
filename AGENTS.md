# APEX VISION IVI — Raspberry Pi 5 Workspace Guidelines & Operational Context

## 1. Project Purpose & Branch
- **Directory**: `/Users/reno/Projects/APEX_VISION_IVI_PI5`
- **Branch**: `pi5` (branched from clean stable macOS v2.6.0 with Rejuvenate fix `c6958b2`).
- **Goal**: Cross-compile, deploy, run, and resolve Raspberry Pi 5 specific issues (DRM/KMS, Wayland/Weston, HDMI audio, touch controls, Qt 3D / Quick3D, WebEngine) systematically starting from scratch.
- **Isolation Constraint**: DO NOT touch or alter `/Users/reno/Projects/APEX_VISION_IVI` (which is dedicated exclusively to macOS).

---

## 2. Raspberry Pi 5 Target System
- **IP Address**: `192.168.1.217`
- **SSH Alias**: `rpi5` (Configured in `~/.ssh/config` using `~/.ssh/id_ed25519`)
- **Direct SSH Command**: `ssh rpi5` or `ssh root@192.168.1.217`
- **Architecture**: `aarch64` (ARM Cortex-A76, Raspberry Pi 5 8GB)
- **OS**: Yocto Linux (Scarthgap 5.0, Kernel 6.6.63-v8-16k)
- **Qt Version on Pi**: Qt 6.7.3 (qtbase, qtdeclarative, qtmultimedia, qtquick3d, qt3d, qtwebengine)
- **Application Directory on Pi**: `/opt/apex_vision_ivi`

---

## 3. Docker Cross-Compilation Environment
The host Mac (Darwin arm64) cross-compiles using the Docker container and cached sysroot volume from the Yocto build:

- **Docker Image**: `rpi5-yocto-scarthgap-builder`
- **Yocto Scratch Directory**: `/Users/reno/.gemini/antigravity-ide/scratch/rpi5-yocto-qt-env`
- **Docker Persistent Volume**: `yocto-tmp` (holds target sysroot and native build tools)
- **Target Sysroot**: `/workspace/build/tmp/work/cortexa76-poky-linux/apex-ivi/1.0/recipe-sysroot`
- **Native Host Tools**: `/workspace/build/tmp/work/cortexa76-poky-linux/apex-ivi/1.0/recipe-sysroot-native`
- **CMake Toolchain File**: `/workspace/build/tmp/work/cortexa76-poky-linux/apex-ivi/1.0/toolchain.cmake`
- **Host Qt Path**: `/workspace/build/tmp/work/cortexa76-poky-linux/apex-ivi/1.0/recipe-sysroot-native/usr/`
- **QtQuick3D Native Tools**: `/workspace/build/tmp/sysroots-components/aarch64/qtquick3d-native/usr/lib/cmake/Qt6Quick3DTools`

---

## 4. Build & Deploy Commands

### A. Automated High-Speed Patch Deploy (Recommended - ~5s)
```bash
./patch-pi5.sh            # Binary + QML patch (~5.1 MB payload, ~5s total)
./patch-pi5.sh --qml      # Ultra-fast dynamic QML hot-patch (~290 KB payload, ~1s total)
```

### B. Full Sync Deploy (When adding new textures/video/web assets)
```bash
./deploy-pi5.sh           # Standard build & full sync
./deploy-pi5.sh --full    # Full sync including heavy video assets
```

### B. Manual Docker Cross-Compile Command
```bash
docker run --rm \
  -v /Users/reno/.gemini/antigravity-ide/scratch/rpi5-yocto-qt-env:/workspace \
  -v yocto-tmp:/workspace/build/tmp \
  -v /Users/reno/Projects/APEX_VISION_IVI_PI5:/workspace/APEX_VISION_IVI_PI5 \
  rpi5-yocto-scarthgap-builder \
  bash -c '
    set -euo pipefail
    export PATH="/workspace/build/tmp/sysroots-uninative/aarch64-linux/usr/bin:/workspace/build/tmp/work/cortexa76-poky-linux/apex-ivi/1.0/recipe-sysroot-native/usr/bin/python3-native:/workspace/build/tmp/work/cortexa76-poky-linux/apex-ivi/1.0/recipe-sysroot-native/usr/bin/perl-native:/workspace/sources/poky/scripts:/workspace/build/tmp/work/cortexa76-poky-linux/apex-ivi/1.0/recipe-sysroot-native/usr/bin/aarch64-poky-linux:/workspace/build/tmp/work/cortexa76-poky-linux/apex-ivi/1.0/recipe-sysroot/usr/bin/crossscripts:/workspace/build/tmp/work/cortexa76-poky-linux/apex-ivi/1.0/recipe-sysroot-native/usr/sbin:/workspace/build/tmp/work/cortexa76-poky-linux/apex-ivi/1.0/recipe-sysroot-native/usr/bin:/workspace/build/tmp/work/cortexa76-poky-linux/apex-ivi/1.0/recipe-sysroot-native/sbin:/workspace/build/tmp/work/cortexa76-poky-linux/apex-ivi/1.0/recipe-sysroot-native/bin:/workspace/sources/poky/bitbake/bin:/workspace/build/tmp/hosttools:$PATH"
    
    cd /workspace/APEX_VISION_IVI_PI5
    mkdir -p build-rpi5
    cd build-rpi5
    
    if [ ! -f "build.ninja" ]; then
      cmake -G Ninja \
        -DCMAKE_MAKE_PROGRAM=ninja \
        -DCMAKE_TOOLCHAIN_FILE=/workspace/build/tmp/work/cortexa76-poky-linux/apex-ivi/1.0/toolchain.cmake \
        -DQT_HOST_PATH=/workspace/build/tmp/work/cortexa76-poky-linux/apex-ivi/1.0/recipe-sysroot-native/usr/ \
        -DQt6Quick3DTools_DIR=/workspace/build/tmp/sysroots-components/aarch64/qtquick3d-native/usr/lib/cmake/Qt6Quick3DTools \
        -DCMAKE_BUILD_TYPE=Release \
        ..
    fi
    ninja -j 6
'
```

### C. Manual Transfer to Pi 5
```bash
tar -czf - -C build-rpi5 apex_vision_ivi assets.rcc assets qml web | ssh rpi5 "tar -xzf - -C /opt/apex_vision_ivi"
ssh rpi5 "chmod +x /opt/apex_vision_ivi/apex_vision_ivi"
```

### D. Launching / Debugging on Pi 5
```bash
# Check running service or kill prior instance
ssh rpi5 "systemctl stop apex-ivi 2>/dev/null; pkill -9 apex_vision_ivi 2>/dev/null || true"

# Launch in foreground with wayland or eglfs
ssh rpi5 "cd /opt/apex_vision_ivi && ./apex_vision_ivi -platform wayland"
# OR under eglfs (direct KMS/DRM):
ssh rpi5 "cd /opt/apex_vision_ivi && ./apex_vision_ivi -platform eglfs"
```

---

## 5. Reference Branch
The initial experimental Pi 5 modifications (touch scaling, navigation HUD, ALSA routing) are saved in the Git branch:
```bash
git log rpi5-deployment
```
Use this branch as reference when diagnosing and resolving specific issues.

---

## 6. Recent Accomplishments & Technical Milestones (Pi 5 Branch)

### A. Wi-Fi & Network Architecture
- **5 GHz & WPA3 / Regulatory Enforcement**:
  - Configured regulatory domain (`country=IN`) in `/etc/wpa_supplicant.conf` to unblock 5 GHz DFS / high frequency channels (36–165).
  - Validated WPA2-Personal, WPA3-Personal SAE, and 5 GHz 802.11ac connectivity on Pi 5 Cypress/Infineon Wi-Fi chipset.
- **Dual-Action Wi-Fi List UX**:
  - Tapping a saved network name or card connects immediately without unnecessary modal popups.
  - Tapping the dedicated trailing arrow button opens the full-screen `wifi_details` overlay with complete telemetry (SSID, BSSID, Security standard, Frequency band, Signal strength, IP, Gateway, DNS, Auto-reconnect toggle).
- **Background Auto-Scan & Cooldown Synchronization**:
  - Implemented 25s auto-scan timer in `SystemBackend.cpp` running silently without on-screen spinner interruptions.
  - Manual scan button resets cooldown and provides immediate visual feedback.

### B. 3D Graphics Engine & Real-Time Performance Optimizations (Raspberry Pi 5)
- **Consolidated 7-Mesh Architecture (`Scene.qml`)**:
  - Transformed monolithic 87-object model into clean, consolidated functional groups: `exterior_Body_mesh` (21 MB), `interior_Cabin_mesh` (3.5 MB), `roof_Assembly_mesh` (5.4 MB), and 4 separate wheel meshes.
- **Hardware Back-Face Culling (`cullMode: PrincipledMaterial.BackFaceCulling`)**:
  - Enabled hardware back-face culling across all 35 solid materials (outer panels, chassis, leather seats, trims, dashboard, steering wheel, wheels).
  - Cuts polygon rasterization and vertex shader load by ~40–50% on the Broadcom VideoCore VII GPU by instantly discarding reverse-facing interior triangles.
  - Retained `NoCulling` on transparent glass and decal blend overlays.
- **Wheel Mesh Off-Screen Frustum Culling**:
  - 4 wheel meshes translate off-screen `(0, -5000, 0)` in Ambient Lighting top-down cabin mode (`wheelsVisible: !root.ambientMode`), eliminating 4 complex model draw calls and tire texture lookups.
- **2D UI Layer Texture Caching**:
  - Added `layer.enabled: true` to `menuContainer` in `VehiclePage.qml`, caching the 6 vehicle cards into an off-screen GPU texture so that sliding and fading the menu no longer stalls CPU 2D rendering during 3D camera animations.
- **Dynamic Lighting & Reflection Optimization**:
  - Throttled multi-pass rim light and directional light during flight; smoothed `probeExposure` environment reflections.
  - Fixed camera gimbal lock (-78° top-down pitch) and tuned orbit flight path.

---

## 7. Current 3D Model Architecture & Optimization Roadmap
- **Current Mesh Breakdown**:
  - `exterior_Body_mesh.mesh` (21 MB) — 14 materials
  - `interior_Cabin_mesh.mesh` (3.5 MB) — 27 materials
  - `roof_Assembly_mesh.mesh` (5.4 MB) — 7 materials
  - 4 Wheel meshes (50 KB each) — 4 materials
  - **Total**: 52 material draw calls per frame.
- **Next Planned Optimizations**:
  - Consolidate `exterior_Body_mesh` and `interior_Cabin_mesh` into 1 unified chassis mesh (`car_body_cabin.mesh`).
  - Keep `roof_Assembly_mesh` separate to preserve the removable roof for Ambient Lighting cabin view.
  - Material consolidation/atlasing to reduce draw calls from 52 down to ~4–8.
  - Mesh decimation on exterior body (reducing 21 MB / ~300k triangles down to ~5–6 MB / ~60k triangles).

