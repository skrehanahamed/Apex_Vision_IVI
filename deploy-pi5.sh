#!/usr/bin/env bash
# ==============================================================================
# APEX VISION IVI — Raspberry Pi 5 Cross-Compile & Deploy Script
# Workspace: /Users/reno/Projects/APEX_VISION_IVI_PI5
# ==============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOCKER_IMAGE="rpi5-yocto-scarthgap-builder"
PI_HOST="rpi5"
PI_DEST="/opt/apex_vision_ivi"

echo "=================================================================="
echo " 🚀 APEX VISION IVI — Building for Raspberry Pi 5"
echo "=================================================================="

docker run --rm \
  -v /Users/reno/.gemini/antigravity-ide/scratch/rpi5-yocto-qt-env:/workspace \
  -v yocto-tmp:/workspace/build/tmp \
  -v "${SCRIPT_DIR}:/workspace/APEX_VISION_IVI_PI5" \
  "${DOCKER_IMAGE}" \
  bash -c '
    set -euo pipefail
    export PATH="/workspace/build/tmp/sysroots-uninative/aarch64-linux/usr/bin:/workspace/build/tmp/work/cortexa76-poky-linux/apex-ivi/1.0/recipe-sysroot-native/usr/bin/python3-native:/workspace/build/tmp/work/cortexa76-poky-linux/apex-ivi/1.0/recipe-sysroot-native/usr/bin/perl-native:/workspace/sources/poky/scripts:/workspace/build/tmp/work/cortexa76-poky-linux/apex-ivi/1.0/recipe-sysroot-native/usr/bin/aarch64-poky-linux:/workspace/build/tmp/work/cortexa76-poky-linux/apex-ivi/1.0/recipe-sysroot/usr/bin/crossscripts:/workspace/build/tmp/work/cortexa76-poky-linux/apex-ivi/1.0/recipe-sysroot-native/usr/sbin:/workspace/build/tmp/work/cortexa76-poky-linux/apex-ivi/1.0/recipe-sysroot-native/usr/bin:/workspace/build/tmp/work/cortexa76-poky-linux/apex-ivi/1.0/recipe-sysroot-native/sbin:/workspace/build/tmp/work/cortexa76-poky-linux/apex-ivi/1.0/recipe-sysroot-native/bin:/workspace/sources/poky/bitbake/bin:/workspace/build/tmp/hosttools:$PATH"
    
    SYSROOT="/workspace/build/tmp/work/cortexa76-poky-linux/apex-ivi/1.0/recipe-sysroot"
    for comp in qtwebengine qtwebchannel qtpositioning nss nspr libopus libevent tiff snappy lcms libxcomposite libxcursor libxi libxrandr libxtst libxscrnsaver libxshmfence minizip pciutils flac libxkbfile ne10; do
      if [ -d "/workspace/build/tmp/sysroots-components/cortexa76/$comp" ]; then
        cp -rn "/workspace/build/tmp/sysroots-components/cortexa76/$comp/"* "${SYSROOT}/" 2>/dev/null || true
      fi
    done

    cd /workspace/APEX_VISION_IVI_PI5
    mkdir -p build-rpi5
    cd build-rpi5
    
    if [ ! -f "build.ninja" ] || ! grep -q "HAVE_WEBENGINE" CMakeCache.txt 2>/dev/null; then
      echo ">> Configuring CMake with Raspberry Pi 5 Yocto Toolchain (including QtWebEngine)..."
      rm -f CMakeCache.txt
      cmake -G Ninja \
        -DCMAKE_MAKE_PROGRAM=ninja \
        -DCMAKE_TOOLCHAIN_FILE=/workspace/build/tmp/work/cortexa76-poky-linux/apex-ivi/1.0/toolchain.cmake \
        -DQT_HOST_PATH=/workspace/build/tmp/work/cortexa76-poky-linux/apex-ivi/1.0/recipe-sysroot-native/usr/ \
        -DQt6Quick3DTools_DIR=/workspace/build/tmp/sysroots-components/aarch64/qtquick3d-native/usr/lib/cmake/Qt6Quick3DTools \
        -DCMAKE_BUILD_TYPE=Release \
        ..
    fi
    
    echo ">> Compiling binary with Ninja..."
    ninja -j 6
'

echo "=================================================================="
echo " 📡 Syncing build artifacts to Raspberry Pi 5 (${PI_HOST}:${PI_DEST})..."
echo "=================================================================="

tar -czf - -C "${SCRIPT_DIR}/build-rpi5" apex_vision_ivi assets.rcc assets web \
          -C "${SCRIPT_DIR}" qml config.json | \
  ssh "${PI_HOST}" "mkdir -p ${PI_DEST} && tar -xzf - -C ${PI_DEST} && chmod +x ${PI_DEST}/apex_vision_ivi && systemctl restart apex-vision"

echo "=================================================================="
echo " ✅ Deployed and restarted apex-vision on ${PI_HOST}"
echo "=================================================================="
