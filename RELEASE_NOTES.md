# Apex VISION IVI - Digital Cockpit v2.5.0 Release Notes

**Release**: `v2.5.0`  
**Target Architecture**: Modern Connected Automotive In-Vehicle Infotainment (HMI / Cockpit Head Unit)  
**Supported Platforms**: Linux (Ubuntu 22.04 / 24.04 LTS), macOS (Apple Silicon / Intel), Windows (MSVC 2022)  
**Framework**: Qt 6.5+ (C++20, Qt Quick / QML, QtWebEngine, QtQuick3D, QtMultimedia)  

---

## 🌟 Major Highlights & New Capabilities in v2.5.0

### 1. 🛰️ OrbitXM™ Satellite Radio Suite & 18-Channel Broadcast
- **18 Curated Digital Channels**: Complete channel portfolio spanning regional hits (**Bollywood Hits**, **Ishq & Melodies**, **Retro**, **90s Rewind**, **Punjabi Swag**, **South Wave**, **Desi Hip-Hop**, **Indie Spotlight**, **Bangla Modern**, **Acoustic Sessions**, **Bhakti & Dhyan**, **Classical Ragas**), live sports (**Cricket Live India**), 24x7 news (**Samachar 24x7**), and authentic in-game **Grand Theft Auto Radio Stations**.
- **High-Definition Station Art Carousel**: Dynamic 3-card rotating visual art carousel featuring vibrant album artwork with smooth swipe animations and automated ambient backdrop lighting.
- **Fluid Channel Grid & Preset Bar**: Normalized 150x62 station logo containers with pagination indicators, dynamic category filtering tabs, and persistent one-touch preset tuning across both cockpit views.

### 2. 🎮 Authentic Grand Theft Auto Radio Stations & Original In-Game Logos
- **Restored Authentic Internet Vectors**: Restored official, high-resolution logos for all GTA stations:
  - **Ch 25: GTA Flash FM** — Iconic 80s gradient script with palm tree emblem.
  - **Ch 26: GTA Los Santos Rock Radio** — Authentic red arched "LOS SANTOS" header with broadcast tower and stone-textured "ROCK RADIO" branding.
  - **Ch 34: GTA Non-Stop-Pop FM** — Authentic disco globe emblem and pop typography.
  - **Ch 36: GTA Radio Los Santos** — Authentic vinyl record emblem with yellow cursive script.

### 3. 🧹 Asset Footprint Cleanup & Performance Optimization
- **Purged Unwanted Duplicate Assets**: Eliminated over 25 MB of unreferenced raw screenshot copies (`image copy*.png`, unreferenced `image.png` files, obsolete SiriusXM SVG vectors) to streamline the repository and binary bundle.
- **Clean Owner's Manual Assets**: Renamed and compressed manual hotspot diagrams to `manual_interior_view.png` and `manual_exterior_view.png`.
- **Intelligent Image Compression**: Re-sampled news card images and vehicle UI assets to match target display pixel densities, saving over 120 MB of expanded C++ compiler memory.

### 4. 🛠️ CI/CD Build Reliability & GitHub Actions Compiler Fixes
- **Eliminated RCC Compiler Out-Of-Memory (OOM) Crashes**: Removed redundant bundling of heavy web assets into Qt's monolithic RCC byte-array, letting `DeployWebAssets` serve them directly from disk.
- **Bounded Concurrency on CI**: Configured `-j 2` compilation flags on Ubuntu and Windows CI runners to prevent memory exhaustion and compiler termination during parallel compilation.
- **Passing Workflows**: Validated successful multi-platform compilation across Linux (Ubuntu 22.04), macOS, and Windows runners.

### 5. 🏛️ Updated System Architecture & High-Resolution Diagram
- **Updated System Architecture Diagram**: Modern dark-mode high-resolution architecture diagram (`docs/architecture_diagram.png`) illustrating QML Presentation, Modern C++20 Core Controllers, and Hardware/Cloud Simulation layers.
- **Interactive Documentation**: Enhanced both Mermaid and PlantUML component specifications in `README.md` reflecting the OrbitXM satellite radio engine, Lincoln Zephyr 3D model, and Google Automotive HUD cluster.

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
