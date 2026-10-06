#!/usr/bin/env bash
# ==============================================================================
# APEX VISION IVI — High-Speed OTA Patch Deploy Script for Raspberry Pi 5
# Workspace: /Users/reno/Projects/APEX_VISION_IVI_PI5
#
# Usage:
#   ./patch-pi5.sh            -> Fast binary + QML patch (~4.9 MB payload, ~5-8 sec total)
#   ./patch-pi5.sh --qml      -> Ultra-fast QML hot-patch (~290 KB payload, ~1-2 sec total)
#   ./patch-pi5.sh --no-build -> Send current binary + QML without Docker rebuild
# ==============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOCKER_IMAGE="rpi5-yocto-scarthgap-builder"
PI_HOST="rpi5"
PI_DEST="/opt/apex_vision_ivi"
MODE="patch"

if [ "${1:-}" = "--qml" ]; then
  MODE="qml"
  echo ">> Mode: Ultra-Fast QML Hot-Patch (~290 KB payload)"
elif [ "${1:-}" = "--web" ]; then
  MODE="web"
  echo ">> Mode: Web Maps & 3D Model OTA Patch"
elif [ "${1:-}" = "--no-build" ]; then
  MODE="no-build"
  echo ">> Mode: Skip Docker build, send current binary and QML (~4.9 MB)"
else
  echo ">> Mode: Fast Binary & QML Patch (~4.9 MB payload, excludes 130MB static assets)"
fi

echo "=================================================================="
echo " ⚡ APEX VISION IVI — Fast Patch Deployer (${MODE})"
echo "=================================================================="

# 1. Compile binary if needed
if [ "$MODE" = "patch" ]; then
  echo ">> Compiling updated binary with Ninja in Docker..."
  docker run --rm \
    -v /Users/reno/.gemini/antigravity-ide/scratch/rpi5-yocto-qt-env:/workspace \
    -v yocto-tmp:/workspace/build/tmp \
    -v "${SCRIPT_DIR}:/workspace/APEX_VISION_IVI_PI5" \
    "${DOCKER_IMAGE}" \
    bash -c '
      set -euo pipefail
      export PATH="/workspace/build/tmp/sysroots-uninative/aarch64-linux/usr/bin:/workspace/build/tmp/work/cortexa76-poky-linux/apex-ivi/1.0/recipe-sysroot-native/usr/bin/python3-native:/workspace/build/tmp/work/cortexa76-poky-linux/apex-ivi/1.0/recipe-sysroot-native/usr/bin/perl-native:/workspace/sources/poky/scripts:/workspace/build/tmp/work/cortexa76-poky-linux/apex-ivi/1.0/recipe-sysroot-native/usr/bin/aarch64-poky-linux:/workspace/build/tmp/work/cortexa76-poky-linux/apex-ivi/1.0/recipe-sysroot/usr/bin/crossscripts:/workspace/build/tmp/work/cortexa76-poky-linux/apex-ivi/1.0/recipe-sysroot-native/usr/sbin:/workspace/build/tmp/work/cortexa76-poky-linux/apex-ivi/1.0/recipe-sysroot-native/usr/bin:/workspace/build/tmp/work/cortexa76-poky-linux/apex-ivi/1.0/recipe-sysroot-native/sbin:/workspace/build/tmp/work/cortexa76-poky-linux/apex-ivi/1.0/recipe-sysroot-native/bin:/workspace/sources/poky/bitbake/bin:/workspace/build/tmp/hosttools:$PATH"
      
      cd /workspace/APEX_VISION_IVI_PI5/build-rpi5
      ninja -j 6 apex_vision_ivi
  '
fi

# 2. Package ONLY the patch files into a lightweight archive
PATCH_ARCHIVE="/tmp/apex_patch_payload.tar.gz"
rm -f "${PATCH_ARCHIVE}"

EXCLUDE_ARGS=(
  --exclude="qml/climate3d/assets"
  --exclude="qml/climate3d/CarModel/meshes"
  --exclude="qml/climate3d/CarModel/maps"
  --exclude="qml/climate3d/CarModel_Consolidated/meshes"
  --exclude="qml/climate3d/CarModel_Consolidated/maps"
  --exclude="qml/climate3d/SeatModel"
  --exclude="qml/climate3d/images"
  --exclude="qml/assets/video"
  --exclude="qml/assets/sounds"
  --exclude="qml/assets/news_images"
  --exclude="qml/assets/radio_logos"
  --exclude="qml/assets/avatars"
  --exclude="CarModel_BACKUP"
  --exclude="CarModel_Pi_Backup"
  --exclude="*.mesh"
  --exclude="*.ktx"
  --exclude="*.png"
  --exclude="*.jpg"
  --exclude="*.wav"
  --exclude="*.mp3"
  --exclude="*.mp4"
)

if [ "$MODE" = "qml" ]; then
  echo ">> Packing QML patch (excluding static 3D textures/models)..."
  tar -czf "${PATCH_ARCHIVE}" \
      "${EXCLUDE_ARGS[@]}" \
      -C "${SCRIPT_DIR}" qml
elif [ "$MODE" = "web" ]; then
  echo ">> Packing Web & 3D Maps assets..."
  COPYFILE_DISABLE=1 tar --exclude="._*" -czf "${PATCH_ARCHIVE}" \
      -C "${SCRIPT_DIR}" web
else
  echo ">> Packing binary and QML patch..."
  tar -czf "${PATCH_ARCHIVE}" \
      "${EXCLUDE_ARGS[@]}" \
      -C "${SCRIPT_DIR}/build-rpi5" apex_vision_ivi assets.rcc \
      -C "${SCRIPT_DIR}" qml
fi

TOTAL_BYTES=$(stat -f%z "${PATCH_ARCHIVE}" 2>/dev/null || stat -c%s "${PATCH_ARCHIVE}")
echo ">> Exact patch size: $(python3 -c "print(f'${TOTAL_BYTES} bytes ({${TOTAL_BYTES}/(1024*1024):.2f} MB)')")"

# 3. Activate on-screen Cyberpunk OTA update HUD on the Pi 5
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

# 4. Stream patch to Pi 5 with real-time HUD progress
echo ">> Streaming patch to ${PI_HOST} with live on-screen HUD..."
cat "${PATCH_ARCHIVE}" | \
  python3 "${SCRIPT_DIR}/scripts/pipe-progress.py" "${TOTAL_BYTES}" | \
  ssh "${PI_HOST}" "python3 /usr/bin/ota-receiver.py ${TOTAL_BYTES} ${PI_DEST} && chmod +x ${PI_DEST}/apex_vision_ivi 2>/dev/null || true"

rm -f "${PATCH_ARCHIVE}"

# 5. Cleanly shut down OTA HUD and launch updated application
echo "=================================================================="
echo " 🚀 Patch Applied! Transitioning to Apex Digital Cockpit..."
echo "=================================================================="
sleep 1.0
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
echo " ✅ Fast Patch Deployed and Active on ${PI_HOST} in record time!"
echo "=================================================================="
