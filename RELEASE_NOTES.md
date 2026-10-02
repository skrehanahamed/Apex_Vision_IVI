# Apex VISION IVI - Digital Cockpit v2.5.0 Release Notes

**Release**: `v2.5.0`  
**Target Architecture**: Modern Connected Automotive In-Vehicle Infotainment (HMI / Cockpit Head Unit)  
**Supported Platforms**: Linux (Ubuntu 22.04 / 24.04 LTS), macOS (Apple Silicon / Intel), Windows (MSVC 2022)  
**Framework**: Qt 6.5+ (C++20, Qt Quick / QML, QtWebEngine, QtQuick3D, QtMultimedia)  

---

## Major Highlights & New Capabilities in v2.5.0

### 1. Direct Full-Screen Navigation Launch
- **One-Touch Full-Screen Navigation**: Tapping Navigation in the Applications drawer immediately opens the full-screen 3D Google Vector / WebGL perspective navigation view, bypassing compact split layouts.
- **Dynamic Viewport Synchronization**: Responsive Google 3D vector map canvas resizing across all display aspect ratios with automatic heading and camera pitch lock.

### 2. OrbitXM Satellite Radio Suite & 18-Channel Broadcast
- **18 Curated Digital Channels**: Complete channel portfolio spanning regional hits (Bollywood Hits, Ishq & Melodies, Retro, 90s Rewind, Punjabi Swag, South Wave, Desi Hip-Hop, Indie Spotlight, Bangla Modern, Acoustic Sessions, Bhakti & Dhyan, Classical Ragas), live sports (Cricket Live India), 24x7 news (Samachar 24x7), and authentic in-game Grand Theft Auto Radio Stations.
- **High-Definition Station Art Carousel**: Dynamic 3-card rotating visual art carousel featuring album artwork with smooth swipe animations and automated ambient backdrop lighting.
- **Fluid Channel Grid & Preset Bar**: Normalized 150x62 station logo containers with pagination indicators, dynamic category filtering tabs, and persistent one-touch preset tuning across both cockpit views.

### 3. Authentic Grand Theft Auto Radio Stations & Original In-Game Logos
- **Restored Authentic High-Resolution Vectors**: Official high-resolution logos for all GTA stations:
  - **Ch 25: GTA Flash FM** - Iconic 80s gradient script with palm tree emblem.
  - **Ch 26: GTA Los Santos Rock Radio** - Red arched "LOS SANTOS" header with broadcast tower and stone-textured "ROCK RADIO" branding.
  - **Ch 34: GTA Non-Stop-Pop FM** - Authentic disco globe emblem and pop typography.
  - **Ch 36: GTA Radio Los Santos** - Authentic vinyl record emblem with yellow cursive script.

### 4. Security Hardening & Secret Scanning Protection
- **Dynamic API Key Loading**: Completely eliminated hardcoded API keys from tracked source files. API credentials load dynamically at runtime from `config.json` or `.env` files.
- **Developer Configuration Templates**: Added `config.example.json` and `.env.example` templates to streamline setup for developers while ensuring local secrets remain git-ignored.
- **Runtime WebEngine Key Injection**: Secure programmatic injection into WebEngine via `window.setGoogleApiKey(...)` for dynamic Places and Routes resolution.

### 5. Multi-Platform CI/CD Optimization & Compiler Stability
- **`NO_CACHEGEN` Optimization**: Added `NO_CACHEGEN` to `qt_add_qml_module` in CMake, bypassing the Qt 6.5 `qmlcachegen` recursive AST compiler crash (Access Violation `0xC0000005` on Windows and OOM exit code `143` on Ubuntu).
- **Binary RCC Asset Bundling**: Converted asset compilation from monolithic C++ arrays to binary `qt_add_binary_resources(assets.rcc)` with runtime registration, cutting build times from minutes to seconds.
- **Validated Cross-Platform CI**: Automated GitHub Actions pipelines passing cleanly across Ubuntu 22.04, Windows 2022 (MSVC), and macOS.

### 6. Updated System Architecture & Developer Attribution
- **Updated System Architecture Diagram**: Modern dark-mode high-resolution architecture diagram (`docs/architecture_diagram.png`) illustrating QML Presentation, Modern C++20 Core Controllers, and Hardware/Cloud Simulation layers.
- **Developer Authorship Headers**: Added standard developer headers across source files and integrated developer attribution in the Settings > System > About UI.

---

## Distribution Packages

| Package | Platform | Architecture | Binary / Format |
|---|---|---|---|
| `ApexVisionIVI-Ubuntu-x86_64.zip` | Linux (Ubuntu 22.04+) | x86_64 | Native ELF + Assets + `run.sh` |
| `ApexVisionIVI-macOS.zip` | macOS (Sonoma / Ventura / Sequoia) | Universal / Apple Silicon | Native Mach-O + Assets + `run.sh` |

---

## Quick Launch

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
