# Apex VISION IVI - Digital Cockpit v2.2.0 Release Notes

**Release**: `v2.2.0`  
**Target Architecture**: Modern Automotive In-Vehicle Infotainment (HMI / Cockpit Head Unit)  
**Supported Platforms**: Linux (Ubuntu 22.04 / 24.04 LTS), macOS (Apple Silicon / Intel), Windows (MSVC 2022)  
**Framework**: Qt 6.5+ (C++20, Qt Quick / QML, QtWebEngine, QtQuick3D, QtMultimedia)  

---

## 🌟 Major Highlights & New Capabilities

### 1. 🎬 Native YouTube Video Streaming Suite & Categorical Browser
- **`VideoBackend` Asynchronous Web Scraper**: High-performance C++20 network backend interacting directly with YouTube endpoints via `QNetworkAccessManager`, parsing and extracting video streams, channel logos, subscriber counts, view metrics, and duration badges without third-party API keys or quota limits.
- **7 Automotive Category Tabs**: Seamless one-touch filtering across **All**, **Trending**, **Music**, **Gaming**, **Movies**, **Podcasts**, and **Live**.
- **Infinite Drag-Scroll Feed**: Dynamic scroll depth detection that pre-fetches and buffers subsequent video sets automatically for infinite, lag-free browsing.
- **On-Screen Touch Keyboard**: Automotive-sized touch keyboard with full alphabet, numbers, space, backspace, and shift toggles for instant in-cabin searches.
- **Modern Borderless Card Layout**: Clean frosted glass aesthetics with crisp typography, channel identity avatars, view counts, and time duration badges.

### 2. 📺 Cinematic Embedded Player & Instant Up Next Recommendations
- **Hardware-Accelerated Embedded Sandbox**: 16:9 embedded player powered by `QtWebEngineQuick` with `--autoplay-policy=no-user-gesture-required` and auto-hiding controls.
- **Instant Up Next Queue**: Tap-to-play recommendations queue using YouTube's iframe API (`loadVideoById`), switching videos seamlessly in-place without reload flicker or latency.
- **Cockpit-Preserving Fullscreen**: Full-bleed workspace expansion that keeps the left navigation rail, right status/slider bar, and bottom climate control dock visible and interactive at all times.

### 3. 🗺️ Official OpenStreetMap Navigation (Zero Watermarks)
- **Official OpenStreetMap Tile Infrastructure**: Migrated raster tile services to official OSM endpoints (`tile.openstreetmap.de` & `tile.openstreetmap.fr`), completely resolving "API Key Required" and "Restricted" watermarks.
- **3D Vector Extruded Buildings**: Hardware-accelerated WebGL 3D perspective with 56-degree forward-looking pitch, live GPS coordinate acquisition, reverse geocoding via Nominatim, and dynamic street name badges.

### 4. 📻 Digital Radio Tuner & Media Center
- **Multi-Band Tuner**: Integrated AM, FM, and SiriusXM tuner interface with direct numeric keypad, bookmarkable presets, and animated audio waveforms.
- **Dual-Card Home Interface**: Split-view dashboard pairing the 3D navigation card with the media player.

### 5. 🛠️ CI/CD & Build Pipeline Updates
- Added `qtmultimedia` across all GitHub Actions build workflows (`build.yml`, `build-macos.yml`, `build-windows.yml`, `release.yml`).
- Bumped project version to `v2.2.0` in `CMakeLists.txt` and `README.md`.
- Added high-resolution screenshots in `docs/screenshots/` showcasing the new YouTube hub, player, OSM navigation, and radio media center.

---

## 📦 Distribution Packages

| Package | Platform | Architecture | Binary / Format |
|---|---|---|---|
| `ApexVisionIVI-Ubuntu-x86_64.zip` | Linux (Ubuntu 22.04+) | x86_64 | Native ELF + Assets + `run.sh` |
| `ApexVisionIVI-macOS.zip` | macOS (Sonoma / Ventura / Sequoia) | Universal / Apple Silicon | Native Mach-O + Assets + `run.sh` |

---

## 🚀 Quick Launch

### Linux
```bash
unzip ApexVisionIVI-Ubuntu-x86_64.zip
cd ApexVisionIVI-Ubuntu-x86_64
./run.sh
```

### macOS
```bash
unzip ApexVisionIVI-macOS.zip
cd ApexVisionIVI-macOS
./run.sh
```
