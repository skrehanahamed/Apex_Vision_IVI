# Apex VISION IVI - Automotive In-Vehicle Infotainment System

<div align="center">

![APEX Logo](qml/assets/icons/apex_logo.png)

### Production-Grade Automotive Human-Machine Interface (HMI) and Digital Cockpit Head Unit

[![Platform](https://img.shields.io/badge/Platform-Qt%206%20%7C%20C%2B%2B20-41CD52.svg?style=for-the-badge&logo=qt&logoColor=white)](https://www.qt.io/)
[![Standard](https://img.shields.io/badge/Standard-ISO%2026262%20%7C%20MISRA%20C%2B%2B-00599C.svg?style=for-the-badge&logo=c%2B%2B&logoColor=white)](https://isocpp.org/)
[![Version](https://img.shields.io/badge/Version-v2.1.0-007ACC.svg?style=for-the-badge&logo=semver)](CMakeLists.txt)
[![macOS CI](https://img.shields.io/badge/macOS%20CI-Passing-brightgreen.svg?style=for-the-badge&logo=apple)](.github/workflows/build-macos.yml)
[![Ubuntu CI](https://img.shields.io/badge/Ubuntu%20CI-Passing-brightgreen.svg?style=for-the-badge&logo=ubuntu)](.github/workflows/build.yml)
[![Windows CI](https://img.shields.io/badge/Windows%20CI-Passing-brightgreen.svg?style=for-the-badge&logo=windows)](.github/workflows/build-windows.yml)
[![Releases](https://img.shields.io/badge/Release-v2.1.0-blueviolet.svg?style=for-the-badge&logo=github)](https://github.com/skrehanahamed/Apex_Vision_IVI/releases)
[![Developer](https://img.shields.io/badge/Developer-Sk%20Rehan%20Ahamed-FF6D00.svg?style=for-the-badge&logo=github)](https://github.com/skrehanahamed)
[![License](https://img.shields.io/badge/License-MIT-blue.svg?style=for-the-badge)](LICENSE)

<br/>

<sub>Made by <b>Sk Rehan Ahamed</b> with the help of <b>Antigravity</b></sub>

</div>

---

## Executive Overview

Apex VISION IVI is a production-grade automotive In-Vehicle Infotainment (IVI) system and digital cockpit head unit engineered with Qt 6 (QML / Qt Quick), WebEngine WebGL 3D acceleration, and modern C++20. Modeled on modern connected electric vehicle (EV) widescreen cockpit architectures, the system features a hardware-accelerated dual-viewport dashboard, live 3D perspective cockpit navigation with vector 3D buildings and real-time reverse geocoding, full HVAC and seat comfort management, 3D interactive vehicle and cabin studios, multi-contour massage seat control, full-screen valet security locking, and a modern OEM cockpit settings suite.

The architecture strictly decouples the QML presentation layer from deterministic C++ backend controllers, establishing an automotive-compliant state machine that manages live telemetry, reverse geocode lookups, thermal comfort states, valet access arbitration, and vehicle telemetry.

---

## Visual Showcase and Subsystem Tour

<div align="center">

### 1. Dual-Card Cockpit Home and Status Chrome
![Apex VISION Cockpit Dashboard](docs/screenshots/01_cockpit_dashboard.png)
*Widescreen digital cockpit head unit featuring live 3D perspective navigation card, media player with waveform visualizer, persistent top status bar, and automotive dock controls.*

<br/>

### 2. Multi-Zone Climate and Seat Thermal Comfort
![Climate and Seat Comfort](docs/screenshots/02_climate_seat_comfort.png)
*Interactive thermal comfort control featuring independent dual-zone temperature regulation, 3-level seat ventilation and heating flyouts, steering wheel heating, and multi-zone airflow distribution.*

<br/>

### 3. Interactive 3D Multi-Contour Massage Seats
![Multi-Contour Massage Seats](docs/screenshots/03_seat_comfort_massage.png)
*Full-featured 3D seat studio allowing passenger and 2nd row seat adjustment, pneumatic lumbar support, cushion extension, and 3-zone multi-intensity massage cycles.*

<br/>

### 4. Cabin Air Refresh and PM2.5 Air Quality Suite
![Cabin Air Refresh](docs/screenshots/04_cabin_air_refresh.png)
*Live cabin air purification monitor featuring real-time PM2.5 air quality gauge, multi-stage filtration indicators, and one-touch high-velocity cabin air refresh.*

<br/>

### 5. Full-Screen Valet Mode Security Lockout
![Valet Mode Security Lockout](docs/screenshots/05_valet_security_lock.png)
*Automotive security overlay with 4-digit PIN authentication, interactive masked keypad, trunk/glove box lockout, and tamper-resistant unlock flows.*

<br/>

### 6. Acoustic Soundstage with Radiating Wave Ripples & Cabin Dissolve
![Acoustic Soundstage Balance and Fade](docs/screenshots/06_acoustic_soundstage_balance_fade.png)
*Acoustic balance and fader soundstage featuring zoomed-in cabin geometry seamlessly faded into ambient wallpaper gradients, real-time radiating sound wave ripples from the draggable reticle, and one-touch center reset.*

<br/>

### 7. Automotive Connectivity and Network Management
![Automotive Connectivity and Network Settings](docs/screenshots/07_connectivity_network_settings.png)
*Comprehensive connectivity control center managing Wi-Fi network scanning and associations, personal mobile hotspot sharing, cellular 5G data telemetry, and roaming toggles.*

<br/>

### 8. Voice Assistant and Speech Feedback Settings
![Voice Assistant and Speech Feedback](docs/screenshots/08_voice_assistant_settings.png)
*Integrated voice and assistant controls offering Google Assistant wake phrase detection ("Hey Google"), screen context analysis, offline speech processing, and language selection.*

</div>

---

## Subsystem Specifications

### 1. 3D Cockpit Navigation and Geospatial Engine
- **Rendering Pipeline**: Hardware-accelerated WebGL 3D engine powered by MapLibre GL and QtWebEngineQuick.
- **3D Perspective**: 56-degree forward-looking driving pitch with vector extruded 3D buildings (OpenFreeMap planet vector tiles).
- **Base Cartography**: High-resolution OpenStreetMap raster tiles capped at zoom level 18.0 to prevent void zoom states.
- **Live GPS Coordinate Acquisition**: Asynchronous startup resolution via network IP geolocation (`https://ipwho.is/` with fallback to `https://ipapi.co/json/`) for immediate, card-free global location positioning.
- **Reverse Geocoding**: Automated OpenStreetMap Nominatim query engine resolving live coordinates to street-level metadata (e.g., road, pedestrian way, suburb).
- **Rate-Limited Geocoding Cache**: Distance-delta thresholding preventing redundant Nominatim network calls during cruising.
- **Navigation Reference Marker**: 3D elliptical ground disc with directional blue chevron rotating 0 to 360 degrees and dynamic street name badge.

### 2. HVAC, Climate, and Cabin Air Purification
- **Dual-Zone Temperature Control**: Independent driver and passenger thermal regulation ranging from 16.0°C to 28.0°C with fine-grained 0.5°C stepping.
- **3D Interactive Cabin Studio**: Real-time 3D rendered cabin view with interactive directional airflow vents.
- **Cabin Air Refresh Overlay**: Real-time cabin air purification loop with animated air particle streams and live PM2.5 index gauges.
- **3-Level Seat Ventilation & Heating**: Independent seat cooling and PTC heating control with 3-stage visual state feedback.
- **Defrost Modes**: Dedicated MAX Front Windshield Defrost and Rear Heated Glass controls.

### 3. Multi-Contour Massage and Seat Studio
- **Multi-Zone Pneumatic Massage**: Upper Back, Lower Back, and Cushion massage zones with independent intensity control (Off, Low, Medium, High).
- **Front Passenger & 2nd Row Controls**: Multi-seat selection menu with amber indicator underline and status telemetry.
- **Electric Actuator Adjustments**: Cushion height/tilt, seat track forward/backward sliding, and backrest recline controls.

### 4. Valet Mode Security Lockout System
- **PIN-Protected Security**: Full-screen modal overlay preventing unauthorized access to vehicle settings, personal data, and storage compartments.
- **Secure Keypad HMI**: Automotive touch keypad with PIN confirmation, auto-clearing masked digits, and tactile click feedback.
- **System Lockout State**: Dynamic status broadcasting to all IVI pages and lock confirmation indicators.

### 5. Automotive OEM Settings Architecture & Multi-Category Navigation
- **Top Header Bar**: Dual-column header featuring standalone circular sliders logo, bold "Settings" title, standard `←` return navigation, and dynamic section titles.
- **7-Category Navigation Rail**: Full automotive OEM settings hierarchy:
  - **Connectivity**: Wi-Fi network scanning, connection status, Bluetooth device pairing, and Mobile Hotspot management.
  - **Voice & Assistant**: Google Assistant voice feedback options, sensitivity calibration, and customizable wake phrases.
  - **Location**: System GPS toggle, recent location requests, and granular application location permissions.
  - **Notifications**: In-cluster urgent safety warnings, drive summaries, and scheduled quiet hours.
  - **Privacy**: Vehicle telemetry and data sharing controls, microphone privacy indicators, and valet lock mode.
  - **System**: Multi-language localization, 12h/24h clock toggle, Imperial/Metric unit selection, OTA software updates, and visual storage allocation graphs.
  - **Accessibility**: High-contrast display mode, closed captioning styling, and interactive screen magnification.
- **Dynamic Visual State Lighting**: Selected category icon illuminates in vibrant OEM **yellow** (`#FBBF24`), while unselected icons remain crisp pure **white** (`#FFFFFF`).
- **Fluid Horizontal Slide Transitions**: Smooth directional sliding animations between the primary categories and nested sub-setting views.
- **Cruise Control Suite**: Mutually exclusive Normal vs. Adaptive Cruise Control with amber radio indicators, plus Lane Centering ("Hands-Free Available") and In-Lane Repositioning toggles.
- **Contextual Help**: Integrated `ⓘ` circular info dialogs explaining individual subsystem mechanics.

### 6. Vehicle Telemetry and CAN Bus Simulator
- **Dynamic Cruising Loop**: Periodic 500 ms simulation timer modeling realistic highway driving conditions.
- **Powertrain Metrics**: Real-time calculation of vehicle cruising speed (64 to 72 km/h) and correlated engine/motor RPM (1900 to 2200 RPM).
- **Tire Pressure Monitoring (TPMS)**: Real-time 4-wheel independent pressure sensor monitoring with blue/amber warning states.
- **Oil Life Telemetry**: Fluid health percentage tracking with maintenance alert triggers.

### 7. Media Player, Audio, and Acoustic Soundstage Architecture
- **Acoustic Balance & Fade Soundstage**:
  - **Zoomed Cabin Geometry**: Focused interior cabin layout showcasing driver, passenger, and second-row seating with metallic roof contours.
  - **Theme-Blended Alpha Dissolve**: Vehicle top-view renders with a smooth cubic alpha gradient, blending effortlessly into active wallpapers (**Inspire**, **Constellation**, **Tranquil**, **Voyage**) without harsh bounding boxes.
  - **Radiating Acoustic Wave Ripples**: Animated concentric sound wave pulses continuously propagate outward in real-time from the draggable focal point.
  - **Interactive Reticle Thumb & Instant Reset**: Touch and drag positioning to adjust front/rear fade and left/right balance, with a one-touch "Reset" button restoring center equilibrium `(0, 0)`.
- **Dynamic Tone Controls**:
  - **13-Point Discrete Sliders**: Bass, Midrange, and Treble frequency bands stepping from `-6` to `+6`.
  - **Floating Teardrop Level Tooltips**: Real-time elevated badge pops up above the slider thumb on touch/drag, displaying signed numeric levels (`+1`, `0`, `-3`).
- **Playback Telemetry**: Track title, artist, album, elapsed track time, total track duration, and album artwork.
- **Interactive Timeline**: Dynamic progress bar with scrubbing and 500 ms position tracking.
- **Audio Controls**: Previous track, play/pause toggle, next track, and audio source selection.
- **Waveform Visualizer**: Animated audio spectrum visualization reflecting active media streaming states.

### 8. Lane-Keeping Assist 3D Real-Time Visualizer
- **Interactive Chassis Rendering**: 3D vehicle perspective demonstrating lane positioning and steering guidance.
- **Dynamic Lane Boundaries**: Real-time animated track boundaries displaying active lane keeping (Aid) and departure warnings (Alert) with color-coded alerts.

---

## Directory Structure

```
Apex_Vision_IVI/
├── CMakeLists.txt                # CMake build configuration for Qt 6 and QtWebEngine
├── Makefile                      # Top-level make targets (build, run, clean)
├── README.md                     # System documentation and architecture guide
├── LICENSE                       # MIT License file
├── THIRD_PARTY_LICENSES.md       # Open-source license attributions
├── .gitignore                    # Git exclusions
├── .github/                      # GitHub configurations
│   └── workflows/                # Continuous integration workflows
│       ├── build.yml             # Ubuntu Linux Qt 6 CI
│       ├── build-macos.yml       # macOS Clang & Homebrew Qt CI
│       ├── build-windows.yml     # Windows MSVC 2022 CI
│       └── release.yml           # Automated release packager
├── docs/                         # System documentation and visual media
│   └── screenshots/              # Cockpit interface screenshots
│       ├── 01_cockpit_dashboard.png
│       ├── 02_climate_seat_comfort.png
│       ├── 03_seat_comfort_massage.png
│       ├── 04_cabin_air_refresh.png
│       ├── 05_valet_security_lock.png
│       ├── 06_acoustic_soundstage_balance_fade.png
│       ├── 07_connectivity_network_settings.png
│       └── 08_voice_assistant_settings.png
├── backend/                      # C++20 backend engines
│   ├── VehicleSimulator.h/.cpp   # Vehicle physics and telemetry simulator
│   ├── VehicleBackend.h/.cpp     # Vehicle status and lighting controller
│   ├── ClimateBackend.h/.cpp     # Dual-zone HVAC and seat comfort controller
│   ├── MediaBackend.h/.cpp       # Audio and media playback state machine
│   ├── NavigationBackend.h/.cpp  # Live GPS, reverse geocoding, and map bridge
│   ├── PhoneBackend.h/.cpp       # Telephony and call management
│   └── SystemBackend.h/.cpp      # System status and display controller
├── main.cpp                      # Application entry point and QML runtime init
├── qml/                          # Qt Quick presentation layer
│   ├── Main.qml                  # Root window and viewport coordinator
│   ├── Typography.qml            # Shared typographical design tokens
│   ├── assets/                   # Vector and raster UI iconography
│   │   ├── fonts/                # Bundled Inter typeface font files
│   │   ├── icons/                # Cockpit controls, climate, settings, and media icons
│   │   └── avatars/              # OEM profile and identity avatars
│   ├── climate3d/                # 3D interactive studio views
│   │   ├── ClimateCabinView.qml  # 3D cabin airflow and thermal view
│   │   ├── SeatStudioView.qml    # 3D seat posture and massage view
│   │   ├── VehicleStudioView.qml # 3D vehicle exterior interactive studio
│   │   └── LaneKeepingCarView3D.qml # 3D lane-keeping assist chassis view
│   ├── components/               # Reusable automotive cockpit components
│   │   ├── ClimateBar.qml        # Bottom climate dock with seat flyouts
│   │   ├── Climate3DPanel.qml    # 3D climate overlay panel
│   │   ├── CabinAirRefreshOverlay.qml # PM2.5 air purification gauge overlay
│   │   ├── ValetLockOverlay.qml  # Full-screen PIN security lock overlay
│   │   ├── LaneKeepingVisualizer.qml # Interactive lane tracking & alert component
│   │   ├── NavigationPanel.qml   # 3D navigation card with WebEngine viewport
│   │   ├── MediaCard.qml         # Music player card with progress bar
│   │   ├── StatusBar.qml         # Persistent top status chrome
│   │   ├── SideNavigation.qml    # Primary app dock
│   │   ├── TemperatureControl.qml# Dual-zone rotary temperature picker
│   │   └── IconButton.qml        # Automotive touch button primitive
│   └── pages/                    # Cockpit application screens
│       ├── HomePage.qml          # Split-view dual card home screen
│       ├── VehiclePage.qml       # Vehicle settings and status display
│       ├── PhonePage.qml         # Telephony interface
│       ├── AppsPage.qml          # Application drawer
│       └── SettingsPage.qml      # Automotive settings suite with 7-category slider navigation
└── web/                          # Embedded 3D navigation web assets
    ├── map.html                  # MapLibre GL 3D perspective navigation view
    ├── osm_logo.png              # OpenStreetMap attribution logo mark
    └── osm_logo_with_name.png    # OpenStreetMap attribution badge with name
```

---

## Build and Execution

### Prerequisites

- **Compiler**: C++20 compliant compiler (GCC 11+, Clang 13+, MSVC 2019+)
- **Build System**: CMake 3.20+ and Ninja or Make
- **Framework**: Qt 6.5+ with the following components:
  - `Qt6::Core`
  - `Qt6::Gui`
  - `Qt6::Quick`
  - `Qt6::Qml`
  - `Qt6::QuickControls2`
  - `Qt6::Svg`
  - `Qt6::Network`
  - `Qt6::WebEngineQuick`

### macOS (Apple Silicon / Intel)

```bash
# 1. Install Qt 6 and QtWebEngine via Homebrew
brew install qt qtwebengine ninja

# 2. Build the application using Makefile
make

# 3. Launch the application
make run
```

### Ubuntu Linux (22.04 LTS / 24.04 LTS)

```bash
# 1. Install system build dependencies
sudo apt-get update
sudo apt-get install -y \
  build-essential cmake ninja-build \
  libgl1-mesa-dev libxkbcommon-dev libxkbcommon-x11-dev \
  libfontconfig1-dev libfreetype6-dev libasound2-dev libpulse-dev

# 2. Configure with CMake (pointing to Qt 6 installation)
cmake -B build -G Ninja -DCMAKE_BUILD_TYPE=Release

# 3. Build and launch
cmake --build build -j$(nproc)
./build/apex_vision_ivi
```

### Windows (MSVC 2022)

```cmd
:: 1. Open Visual Studio x64 Native Tools Command Prompt
:: 2. Configure with CMake
cmake -B build -G Ninja -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH="C:\Qt\6.5.3\msvc2019_64"

:: 3. Build and launch
cmake --build build --config Release --parallel
build\apex_vision_ivi.exe
```

---

## GitHub Actions Continuous Integration

The repository includes automated CI workflows in `.github/workflows/`:

- `build.yml`: Compiles and verifies the Linux Qt 6 application with CMake and Ninja on Ubuntu 22.04.
- `build-macos.yml`: Validates macOS build targets with Clang and native Homebrew Qt 6.
- `build-windows.yml`: Validates Windows build targets with MSVC 2022 and Qt 6.
- `release.yml`: Automated multi-platform release packager producing versioned binaries and distribution archives on tagged commits.

---

## Third-Party Credits and Acknowledgments

We gratefully acknowledge the following open-source projects, tools, and research:

- **Qt Project**: Cross-platform GUI and automotive application framework (Qt Quick, QML, QtWebEngine).
- **MapLibre GL JS**: High-performance open-source WebGL map rendering engine enabling hardware-accelerated 3D cockpit perspective.
- **OpenStreetMap Contributors**: Global open spatial database powering cartography and geospatial coordinates.
- **OpenFreeMap**: Community-driven 3D vector tile infrastructure providing vector building extrusions.
- **Nominatim**: OpenStreetMap search and reverse-geocoding engine for live automotive street resolution.
- **Rasmus Andersson**: Inter font family designed for computer screens and automotive digital displays.

---

## Release History & Highlights

### [v2.1.0] - Acoustic Soundstage Wave Ripples, Zoomed Cabin Fade, Tone Tooltips & 7-Category OEM Settings Suite
- **Acoustic Balance & Fade Soundstage**:
  - Zoomed vehicle cabin geometry focusing on passenger seating and silver roof structure.
  - Smooth cubic alpha gradient fading the vehicle directly into active ambient wallpapers (**Inspire**, **Constellation**, **Tranquil**, **Voyage**) without hard rectangular boundaries.
  - Concentric sound wave pulse animation actively propagating outward from the draggable focal point.
  - Interactive reticle thumb with instant "Reset" restoring acoustic center equilibrium `(0, 0)`.
- **Dynamic Tone Controls**:
  - 13-point discrete sliders (-6 to +6) for Bass, Midrange, and Treble.
  - Floating teardrop level tooltips displaying live signed values on touch or drag.
- **7-Category OEM Settings Architecture & Slide Transitions**:
  - Fluid horizontal directional slide animations across Connectivity, Voice, Location, Notifications, Privacy, System, and Accessibility.
  - Multi-tiered settings stack with persistent breadcrumb headers and fluid back transitions.
- **Lane-Keeping Assist 3D Real-Time Visualizer**:
  - Interactive vehicle chassis rendering with dynamic lane tracking boundaries and Aid/Alert state visualizers.
- **Cleaned & Optimized Assets**:
  - Purged intermediate scratch assets and test scripts; optimized bundled resources in `CMakeLists.txt`.

### [v2.0.0] - 3D Cabin & Seat Studio, Valet Lock Mode, and OEM Settings Suite
- 3D interactive multi-contour massage seats and cabin airflow studio.
- Full-screen PIN security valet lock overlay with masked keypad.
- Real-time PM2.5 air quality gauge and high-velocity cabin air refresh cycle.
- Automotive OEM settings layout with dual-column headers and visual category illumination.

---

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.  
Third-party licenses and acknowledgments are documented in [THIRD_PARTY_LICENSES.md](THIRD_PARTY_LICENSES.md).
