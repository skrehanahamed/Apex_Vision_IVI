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
FULL_SYNC=false

if [ "${1:-}" = "--full" ]; then
  FULL_SYNC=true
  echo ">> Full sync mode enabled (includes large static video assets)."
fi

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

echo ">> Packing payload and calculating exact byte size..."
DEPLOY_ARCHIVE="/tmp/apex_deploy_payload.tar.gz"
if [ "$FULL_SYNC" = true ]; then
  tar -czf "${DEPLOY_ARCHIVE}" \
      -C "${SCRIPT_DIR}/build-rpi5" apex_vision_ivi assets.rcc assets web \
      -C "${SCRIPT_DIR}" qml
else
  tar --exclude="CarModel_BACKUP" -czf "${DEPLOY_ARCHIVE}" \
      -C "${SCRIPT_DIR}/build-rpi5" apex_vision_ivi assets.rcc web \
      -C "${SCRIPT_DIR}" qml
fi

TOTAL_BYTES=$(stat -f%z "${DEPLOY_ARCHIVE}" 2>/dev/null || stat -c%s "${DEPLOY_ARCHIVE}")
echo ">> Exact payload size: $(python3 -c "print(f'${TOTAL_BYTES} bytes ({${TOTAL_BYTES}/(1024*1024):.2f} MB)')")"

echo "=================================================================="
echo " 📡 Activating On-Screen OTA Code Upload Display on ${PI_HOST}..."
echo "=================================================================="
ssh "${PI_HOST}" "
  systemctl stop apex-vision 2>/dev/null || true
  pkill -9 apex_vision_ivi 2>/dev/null || true
  pkill -9 -f 'qml' 2>/dev/null || true
  rm -f /tmp/apex_touch_click.wav 2>/dev/null || true
  nohup /usr/bin/show-upload-screen.sh > /dev/null 2>&1 &
"
sleep 0.8

echo ">> Streaming artifacts to ${PI_HOST} with live on-screen HUD..."
cat "${DEPLOY_ARCHIVE}" | \
  python3 "${SCRIPT_DIR}/scripts/pipe-progress.py" "${TOTAL_BYTES}" | \
  ssh "${PI_HOST}" "python3 /usr/bin/ota-receiver.py ${TOTAL_BYTES} ${PI_DEST} && chmod +x ${PI_DEST}/apex_vision_ivi"

rm -f "${DEPLOY_ARCHIVE}"

echo "=================================================================="
echo " 🚀 Update Completed! Transitioning to Apex Digital Cockpit..."
echo "=================================================================="
sleep 1.2
ssh "${PI_HOST}" "
  if [ -f /tmp/upload_screen.pid ]; then
    kill -9 \$(cat /tmp/upload_screen.pid) 2>/dev/null || true
    rm -f /tmp/upload_screen.pid
  fi
  pkill -9 -f 'qml' 2>/dev/null || true
  sleep 0.4
  systemctl start apex-vision
"

echo "=================================================================="
echo " ✅ Deployed and active on ${PI_HOST}"
echo "=================================================================="
