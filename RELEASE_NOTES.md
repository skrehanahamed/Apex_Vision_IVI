# Apex VISION IVI - Digital Cockpit v2.4.0 Release Notes

**Release**: `v2.4.0`  
**Target Architecture**: Modern Connected Automotive In-Vehicle Infotainment (HMI / Cockpit Head Unit)  
**Supported Platforms**: Linux (Ubuntu 22.04 / 24.04 LTS), macOS (Apple Silicon / Intel), Windows (MSVC 2022)  
**Framework**: Qt 6.5+ (C++20, Qt Quick / QML, QtWebEngine, QtQuick3D, QtMultimedia)  

---

## 🌟 Major Highlights & New Capabilities in v2.4.0

### 1. 🏎️ Authentic Lincoln Zephyr 3D Model with Pearl White Automotive Finish
- **Three.js WebGL CustomLayer Integration**: Direct integration into MapLibre GL 3D perspective pipeline, rendering the high-fidelity **Lincoln Zephyr luxury sedan** (`lincoln_zephyr.glb`) at runtime.
- **Custom Automotive Paint Shader**: Multi-layer pearl white metallic finish with specular gloss clearcoat, tinted panoramic black glass roof, and chrome trim accents.
- **True Road Elevation & Dynamic Scaling**: Accurately centered bounding chassis sitting flush with the road surface at `Y = 0` with dynamic Mercator elevation and heading synchronization.

### 2. 🎯 Dynamic 3D Screen Bounding Projection for Street Labels
- **8-Corner 3D Bounding Box Projection**: Real-time projection of all 8 vertices of the Lincoln Zephyr 3D model into 2D screen coordinates on every frame.
- **Collision-Free Positioning**: Automatically computes `maxY + 18px` so the current street pill label remains positioned cleanly beneath the vehicle, eliminating any visual overlap or clipping under any camera pitch, zoom level, heading angle, or display aspect ratio.

### 3. ⏱️ Google Automotive Circular HUD Speedometer & Physics
- **Integrated Speedometer Cluster**: Dual-ring circular HUD cluster with live digital vehicle speed readout (`km/h`), speed limit warning sign, and animated dial accent.
- **Realistic Telemetry Physics**: Synchronized with vehicle acceleration and braking physics from the backend simulator.
- **Optimized UI Clearance**: Re-positioned 32px above the Google badge to maintain balanced cockpit ergonomics.

### 4. 🧭 3-in-1 Cockpit View Mode Switcher
- **Perspective 3D Mode**: 58° forward-looking driving angle locked to the vehicle's heading with extruded 3D vector buildings.
- **North-Up 2D Mode**: 0° top-down flat cartography aligned to true geographic North with animated compass needle orientation.
- **Route Overview Mode**: High-altitude macroscopic camera framing the active turn-by-turn route geometry.

### 5. 🏁 Spacious Trip Arrival & Route Summary Card
- **Automotive Arrival View**: Re-engineered arrival card with generous spatial layout, destination waypoint metadata, trip duration, total distance, and calculated average driving speed.
- **One-Touch Trip Dismissal**: Primary end-route action button seamlessly resetting route state and returning to free-drive navigation.

### 6. 🔍 Google Automotive Search Pill, POI Discovery & Clean Telemetry
- **Refactored Search Card**: Modern floating search pill with Google Automotive branding, voice search shortcut, and horizontal category POI carousel (Gas Stations, Restaurants, Groceries, Coffee).
- **CORS Resolution**: Migrated from blocked third-party reverse geocoding endpoints to reliable OpenStreetMap Nominatim with explicit JSON accept headers.
- **Streamlined Telemetry & Console Silence**: Filtered informational web messages in QML terminal, purged obsolete mock assets, and bundled all local MapLibre and Three.js runtime assets.

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
