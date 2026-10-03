# Apex VISION IVI - Digital Cockpit v2.6.0 Release Notes

**Release**: `v2.6.0`  
**Target Architecture**: Modern Connected Automotive In-Vehicle Infotainment (HMI / Cockpit Head Unit)  
**Supported Platforms**: Linux (Ubuntu 22.04 / 24.04 LTS, Yocto / Embedded Linux), macOS (Apple Silicon / Intel), Windows (MSVC 2022)  
**Framework**: Qt 6.5+ (C++20, Qt Quick / QML, QtWebEngine, QtQuick3D, QtMultimedia)  

---

## Major Highlights & New Capabilities in v2.6.0

### 1. Automotive OEM Welcome Screen & Specular Brand Evolution
- **Cinematic Startup Brand Ignition**: Multi-phase sequential reveal featuring laser line ignition, horizon sweep, SUV silhouette reveal, and final metallic emblem lock.
- **Brushed Titanium & Specular Chrome Shaders**: Handcrafted high-definition metallic textures for APEX and VISION emblems with dynamic real-time specular shine sweeps.
- **Synchronized Automotive Acoustic Chimes**: Integrated studio-grade startup chime (`welcome_startup.wav`) and crisp haptic UI sound feedback (`touch_click.wav`).
- **Strict Startup Audio Lockout**: Radio, streaming media, and system audio are safely locked out during the brand animation, automatically resuming once the digital cockpit transitions to the active driving state.

### 2. Automotive State Persistence Engine (`PersistenceManager`)
- **Power-Cycle State Retention**: Thread-safe JSON-backed persistence retaining driver profile customizations, media sources, volume levels, climate presets, and infotainment settings across vehicle ignition reboots.
- **Offline News Feed Caching**: Dynamically fetched automotive news articles are automatically cached to local storage, ensuring immediate visual presentation upon boot without waiting for network connectivity.

### 3. Infotainment & Cockpit Application Suite Expansion
- **Apple CarPlay & Android Auto Projection Gateway (`MobileDeviceConnectionPage.qml`)**: Modern automotive projection suite supporting wireless Apple CarPlay, Android Auto, and USB flash storage synchronization with live device status and signal telemetry.
- **In-Car Messages Center (`MessagesPage.qml`)**: Safe automotive messaging hub featuring driver-oriented message threads, text-to-speech read-aloud triggers, and quick replies.
- **Stationary In-Cabin Gaming Hub (`GamesPage.qml`)**: Dedicated entertainment portal offering retro-style vehicle gaming during charging and parked rest stops.
- **Multi-Driver Personalization Switcher (`ProfileSwitcherPage.qml`)**: Instant driver profile selection with personalized avatar icons, restoring seat posture, mirror tilt, and temperature preferences.

### 4. Midnight Cockpit Navigation HUD & WebEngine Night Mode
- **Midnight Vector Road Styling**: Dedicated automotive night stylesheet (`web/map.html`) with deep midnight contrast (`#090D16`), dark building geometry, and glowing cyan route vectors.
- **Automated Day/Night Synchronization**: Clock-synchronized ambient switching adapting between crisp daytime clarity and distraction-free night-driving HUD aesthetics.

### 5. Multi-Platform Build Verification & Architecture Cleanup
- **Prism-Clean CMake Configuration**: Project version upgraded to `2.6.0` with standard C++20 flags, complete `PersistenceManager` integration, and validated build passes on Linux, macOS, and Windows.
- **Asset Bundle Integrity**: All sound effects, metallic icons, and 3D assets registered cleanly within `assets.qrc`.

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
