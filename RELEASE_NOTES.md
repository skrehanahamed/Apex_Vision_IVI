# Apex VISION IVI - Digital Cockpit v2.3.0 Release Notes

**Release**: `v2.3.0`  
**Target Architecture**: Modern Connected Automotive In-Vehicle Infotainment (HMI / Cockpit Head Unit)  
**Supported Platforms**: Linux (Ubuntu 22.04 / 24.04 LTS), macOS (Apple Silicon / Intel), Windows (MSVC 2022)  
**Framework**: Qt 6.5+ (C++20, Qt Quick / QML, QtWebEngine, QtQuick3D, QtMultimedia)  

---

## 🌟 Major Highlights & New Capabilities

### 1. 🧘 APEX Rejuvenate™ Multi-Sensory Stationary Wellness Suite
- **Multi-Sensory Vehicle Actuator Synchronization (`RejuvenateController`)**: State machine orchestrating automated transitions across vehicle comfort subsystems when parked:
  - **Motorized Ergonomic Seating (`SeatBackend`)**: Automatic seat transition to **Relax Mode** (45° ergonomic recline) upon start, activating continuous pneumatic wave massage at Level 2, and automatic restoration to standard upright position upon completion.
  - **Micro-Climate Comfort (`ClimateBackend`)**: Automated thermal regulation to 22.0°C with gentle cabin airflow (`AUTO` mode, A/C engaged).
  - **Spatial Ambient Lighting (`AmbientLightBackend`)**: Synchronized theme-matching colors (e.g. Cyan Blue `#24D9FF` for Aurora, Deep Aqua for Ocean) with breathing brightness modulation.
- **Calm Audio/Visual Integration**: Integrated high-definition looping nature videos, soothing binaural audio streams, and synchronized timeline milestones (*Preparing*, *Active*, *Concluding*).
- **Automotive Safety Park Interlock**: Mandatory transmission Park (`P`) monitor. Shifting gears into Drive (`D`) or Reverse (`R`) immediately pauses the immersion, triggers an elevated safety modal, and safely halts motorized actuators.

### 2. 📖 Digital Owner's Manual & Visual Hotspot Navigation
- **3-Mode Tabbed Navigation**: Seamless switching between **Categories**, **Visual search**, and **Bookmarks** with sliding amber indicator underline.
- **2-Page Visual Search (Cockpit & Exterior SUV)**:
  - **Page 1 (Luxury Cockpit Interior)**: Interactive touch pins for Steering Controls, Digital Cockpit Cluster, 15.6" Infotainment Display, Center Console, Ambient Air Vents, and Seat Memory.
  - **Page 2 (Exterior SUV Perspective)**: Touch pins for Matrix LED Headlights, Front Radar & LiDAR sensors, Smart Keyless Mirrors, Power Charge Port, and Hands-Free Power Liftgate.
  - **Adaptive Hover Tooltips**: Responsive tooltips that automatically detect viewport boundaries to prevent edge clipping.
- **Fluid Horizontal Navigation Stack**:
  - Decoupled header layout with bidirectional horizontal slide animations for category breadcrumb titles (`0 → -60px` / `60px → 0`).
  - True off-screen content transitions (`100% viewport width → 0`) eliminating view overlap during drill-down into topics and articles.
- **Real-Time Touch Keyboard Search**: Live query filtering across all manual chapters and subtopics with built-in automotive on-screen touch keyboard.
- **Interactive Capsule Dragger**: Custom touch-target draggable capsule thumb synchronized bidirectionally with `Flickable.contentY`.

### 3. 🎬 Native YouTube Video Streaming Suite & Categorical Browser
- **`VideoBackend` Asynchronous Web Scraper**: High-performance C++20 network backend interacting directly with YouTube endpoints via `QNetworkAccessManager`, parsing and extracting video streams without third-party API keys or quota limits.
- **7 Automotive Category Tabs**: Seamless one-touch filtering across **All**, **Trending**, **Music**, **Gaming**, **Movies**, **Podcasts**, and **Live**.
- **Infinite Drag-Scroll Feed**: Dynamic scroll depth detection that pre-fetches and buffers subsequent video sets automatically for infinite browsing.
- **Instant Up Next Queue**: Tap-to-play recommendations queue using YouTube's iframe API (`loadVideoById`), switching videos seamlessly in-place.

### 4. 🗺️ Official OpenStreetMap 3D Cartography & Navigation
- **Zero Watermarks**: Running on official OSM tile infrastructure (`tile.openstreetmap.de` & `tile.openstreetmap.fr`).
- **3D Vector Extruded Buildings**: Hardware-accelerated WebGL 3D perspective with 56-degree forward-looking pitch, live GPS coordinate acquisition, and reverse geocoding via Nominatim.

### 5. 🎛️ Acoustic Soundstage, 3D Cabin Studio, and Valet Security
- **Acoustic Balance & Fade**: Draggable reticle with real-time radiating concentric sound wave ripples, 13-point tone controls, and wallpaper-dissolved cabin geometry.
- **Interactive 3D Multi-Contour Seats & Airflow**: Independent multi-intensity pneumatic massage, lumbar actuators, and PM2.5 air purification gauge with one-touch cabin air refresh.
- **Full-Screen PIN Valet Lock**: Automotive security overlay with masked PIN keypad and storage compartment lockout.

### 6. 🚀 Repository Hardening & Complete 17-Screenshot Showcase
- Pruned redundant/mock assets, optimized looping nature MP4 backdrops to fast-loading H.264 formats under 30MB.
- Updated system architecture, directory trees, and complete 17-screenshot subsystem gallery.

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
