# Apex VISION IVI - Automotive In-Vehicle Infotainment System

<div align="center">

![APEX Logo](qml/assets/icons/apex_logo.png)

### Production-Grade Automotive Human-Machine Interface (HMI) and Digital Cockpit Head Unit

[![Platform](https://img.shields.io/badge/Platform-Qt%206%20%7C%20C%2B%2B20-41CD52.svg?style=for-the-badge&logo=qt&logoColor=white)](https://www.qt.io/)
[![Standard](https://img.shields.io/badge/Standard-ISO%2026262%20%7C%20MISRA%20C%2B%2B-00599C.svg?style=for-the-badge&logo=c%2B%2B&logoColor=white)](https://isocpp.org/)
[![Version](https://img.shields.io/badge/Version-v2.5.0-007ACC.svg?style=for-the-badge&logo=semver)](CMakeLists.txt)
[![macOS CI](https://img.shields.io/badge/macOS%20CI-Passing-brightgreen.svg?style=for-the-badge&logo=apple)](.github/workflows/build-macos.yml)
[![Ubuntu CI](https://img.shields.io/badge/Ubuntu%20CI-Passing-brightgreen.svg?style=for-the-badge&logo=ubuntu)](.github/workflows/build.yml)
[![Windows CI](https://img.shields.io/badge/Windows%20CI-Passing-brightgreen.svg?style=for-the-badge&logo=windows)](.github/workflows/build-windows.yml)
[![Releases](https://img.shields.io/badge/Release-v2.5.0-blueviolet.svg?style=for-the-badge&logo=github)](https://github.com/skrehanahamed/Apex_Vision_IVI/releases)
[![Developer](https://img.shields.io/badge/Developer-Sk%20Rehan%20Ahamed-FF6D00.svg?style=for-the-badge&logo=github)](https://github.com/skrehanahamed)
[![License](https://img.shields.io/badge/License-MIT-blue.svg?style=for-the-badge)](LICENSE)

<br/>

<sub>Made by <b>Sk Rehan Ahamed</b> with the help of <b>Antigravity</b></sub>

</div>

---

## Executive Overview

Apex VISION IVI is a production-grade automotive In-Vehicle Infotainment (IVI) system and digital cockpit head unit engineered with Qt 6 (QML / Qt Quick), WebEngine WebGL 3D acceleration, and modern C++20. Modeled on modern connected electric vehicle (EV) widescreen cockpit architectures, the system features a hardware-accelerated dual-viewport dashboard, live 3D perspective cockpit navigation powered by a custom **Three.js WebGL CustomLayer** rendering an authentic **Lincoln Zephyr luxury sedan in pearl white**, real-time vector 3D building extrusions, a circular **Google Automotive Speedometer Cluster** with live speed physics and speed limit warnings, a **3-in-1 Cockpit View Mode Switcher** (Perspective / North-up / Overview), an integrated native **YouTube Video Streaming Suite** with infinite feed browsing and seamless Up Next recommendations, the **OrbitXM Satellite Radio Suite** with 18 curated live audio stations, dynamic artwork carousel, quick preset bar, and authentic Grand Theft Auto radio station logos, the **APEX Rejuvenate™ Stationary Wellness Immersion Suite** synchronized across vehicle climate, motorized seating, and ambient lighting, a **Digital Owner's Manual with 2-Page Visual Search and Hotspot Mapping**, full HVAC and seat comfort management, 3D interactive vehicle and cabin studios, multi-contour massage seat control, full-screen valet security locking, and a modern OEM cockpit settings suite.

The architecture strictly decouples the QML presentation layer from deterministic C++ backend controllers, establishing an automotive-compliant state machine that manages live telemetry, reverse geocode lookups, thermal comfort states, valet access arbitration, YouTube network extraction, multi-sensory wellness orchestration, and vehicle safety interlocks.

---

## System Architecture

The software architecture strictly adheres to automotive digital cockpit best practices, decoupling the declarative presentation layer from deterministic, thread-safe C++20 backend controllers:

<div align="center">

![Apex Vision IVI System Architecture](docs/architecture_diagram.png)

</div>

<details>
<summary><b>Click to expand Interactive Mermaid Flowchart</b></summary>

```mermaid
graph TD
    subgraph QML["Presentation Layer (Qt Quick / QML)"]
        Main["Main.qml (Viewport Coordinator)"]
        Home["HomePage (Dual-Card Dashboard)"]
        NavView["NavigationPanel (3D WebEngine Map, Zephyr & HUD)"]
        RadioView["OrbitXM & RadioPage (18-Ch Satellite Broadcast)"]
        ClimateView["ClimateBar & 3D Cabin (HVAC / PM2.5)"]
        VehicleView["VehiclePage (3D Studio & Valet Security)"]
        VideoView["VideoPage (YouTube Streamer & UpNext)"]
        RejView["RejuvenatePage (Stationary Immersion)"]
        ManualView["ManualPage (2-Page Visual Search)"]
        SettingsView["SettingsPage (7-Category OEM Suite)"]
    end

    subgraph Backend["Core Backend Controllers (Modern C++20)"]
        NavB["NavigationBackend (3-in-1 View Switcher)"]
        MedB["MediaBackend (OrbitXM & AudioDSP Engine)"]
        ClimB["ClimateBackend (Dual-Zone HVAC)"]
        VehB["VehicleBackend & Valet (CAN Arbitration & PIN)"]
        SeatB["SeatBackend (3D Actuators & Massage)"]
        LightB["AmbientLightBackend (Multi-Zone RGB Theme)"]
        VidB["VideoBackend (Async Stream Extractor)"]
        RejC["RejuvenateController (Sensory Timeline)"]
        SysB["SystemBackend (Hardware Diagnostics)"]
    end

    subgraph External["Hardware Simulation & Cloud Services"]
        CAN["VehicleSimulator (500ms CAN Telemetry Loop)"]
        MAP["MapLibre GL 3D Engine (Extruded Planet Tiles)"]
        CAR["Three.js WebGL CustomLayer (Lincoln Zephyr 3D White Model)"]
        HUD["Google Automotive UI (Speedometer Cluster & HUD)"]
        SXM["OrbitXM & GTA Endpoints (18 Live Radio Decoders)"]
        YT["YouTube Endpoint Scraper (No-Key Stream Extractor)"]
        GEO["Nominatim & IP Geocoder (Live HTTPS Geocoding)"]
    end

    Main --> Home
    Main --> ClimateView
    Main --> VehicleView
    Main --> VideoView
    Main --> RejView
    Main --> ManualView

    NavView <--> NavB
    RadioView <--> MedB
    ClimateView <--> ClimB
    VehicleView <--> VehB
    VehicleView <--> SeatB
    RejView <--> RejC
    VideoView <--> VidB
    SettingsView <--> MedB

    RejC -.-> ClimB
    RejC -.-> SeatB
    RejC -.-> LightB

    NavB --> MAP
    NavB --> CAR
    NavB --> HUD
    NavB --> GEO
    MedB --> SXM
    VidB --> YT
    CAN --> VehB
```

</details>

<details>
<summary><b>Click to expand PlantUML Architecture Specification</b></summary>

```plantuml
@startuml Apex_Vision_Architecture
!theme plain
skinparam backgroundColor #0A0E14
skinparam componentStyle uml2
skinparam roundCorner 10
skinparam defaultFontName "Inter, Helvetica, Arial, sans-serif"
skinparam defaultFontSize 12
skinparam defaultFontColor #E6EDF3
skinparam dpi 200

skinparam package {
  BackgroundColor #131822
  BorderColor #2D3748
  FontColor #60A5FA
  FontStyle bold
}

skinparam component {
  BackgroundColor #1A2234
  BorderColor #3B82F6
  FontColor #F8FAFC
}

skinparam arrow {
  Color #60A5FA
  FontColor #94A3B8
}

package "Presentation Layer (Qt Quick / QML)" as QML {
  [Main.qml\nViewport Coordinator] as Main
  [HomePage\nDual-Card Split Dashboard] as Home
  [NavigationPanel\n3D Perspective Map & Zephyr] as NavView
  [OrbitXM & RadioPage\n18-Ch Satellite Broadcast] as RadioView
  [ClimateBar & 3D Cabin\nHVAC & Air Refresh] as ClimateView
  [Vehicle & Seats\n3D Studio & Valet Security] as VehicleView
  [VideoPage\nYouTube Streamer & UpNext] as VideoView
  [RejuvenatePage\nStationary Immersion] as RejView
  [ManualPage\n2-Page Visual Search] as ManualView
  [SettingsPage\n7-Category OEM Suite] as SettingsView
}

package "Core Backend Controllers (Modern C++20)" as Backend {
  [NavigationBackend\n3-in-1 View Switcher] as NavB
  [MediaBackend\nOrbitXM & AudioDSP Engine] as MedB
  [ClimateBackend\nDual-Zone HVAC] as ClimB
  [VehicleBackend & Valet\nCAN Arbitration & PIN] as VehB
  [SeatBackend\n3D Actuators & Massage] as SeatB
  [AmbientLightBackend\nMulti-Zone RGB Theme] as LightB
  [VideoBackend\nAsync Stream Extractor] as VidB
  [RejuvenateController\nSensory Timeline] as RejC
  [SystemBackend\nHardware Diagnostics] as SysB
}

package "Hardware Simulation & Cloud Services" as External {
  [VehicleSimulator\n500ms CAN Telemetry Loop] as CAN
  [MapLibre GL 3D Engine\nExtruded Planet Tiles] as OSM
  [Three.js WebGL CustomLayer\nLincoln Zephyr 3D White Model] as CAR
  [Google Automotive UI\nSpeedometer Cluster & HUD] as HUD
  [OrbitXM & GTA Endpoints\n18 Live Radio Decoders] as SXM
  [YouTube Endpoint Scraper\nNo-Key Stream Extractor] as YT
  [Nominatim & IP Geocoder\nLive HTTPS Geocoding] as GEO
}

Main -down-> Home
Main -down-> ClimateView
Main -down-> VehicleView
Main -down-> VideoView
Main -down-> RejView
Main -down-> ManualView

NavView <--> NavB : Q_PROPERTY / Qt Signals
RadioView <--> MedB : Station Art & Presets
ClimateView <--> ClimB : Dual-Zone Thermal
VehicleView <--> VehB : CAN Telemetry & PIN Lock
VehicleView <--> SeatB : 3D Actuators & Massage
RejView <--> RejC : Immersion Timeline
VideoView <--> VidB : Video Feed & UpNext
SettingsView <--> MedB : Tone & Soundstage

RejC -right-> ClimB : 22°C Auto Airflow
RejC -right-> SeatB : 45° Recline & Wave Massage
RejC -right-> LightB : Aurora Ambient Glow

NavB --> OSM : WebChannel Integration
NavB --> CAR : Heading & Pitch Synchronizer
NavB --> HUD : Speedometer & Speed Limit Warnings
NavB --> GEO : HTTPS Reverse Geocoding
MedB --> SXM : Satellite Audio Decoders
VidB --> YT : Asynchronous QNAM
CAN --> VehB : 500ms Simulation Loop

@enduml
```

</details>

---

## Visual Showcase and Subsystem Tour

<div align="center">

### 1. Dual-Card Cockpit Home and Status Chrome
![Apex VISION Cockpit Dashboard](docs/screenshots/01_cockpit_dashboard.png)
*Widescreen digital cockpit head unit featuring live 3D perspective navigation card with Three.js Lincoln Zephyr sedan in pearl white, media player with waveform visualizer, persistent top status bar, and automotive dock controls.*

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

<br/>

### 9. Native YouTube Video Feed & Categorical Browser
![Native YouTube Video Feed](docs/screenshots/09_youtube_video_feed.png)
*Native YouTube video browsing with integrated search, touch keyboard, 7 category tabs (All, Trending, Music, Gaming, Movies, Podcasts, Live), infinite scroll, channel badges, view counts, and duration badges.*

<br/>

### 10. Cinematic Embedded YouTube Player with Instant Up Next Queue
![Embedded YouTube Player and Up Next](docs/screenshots/10_youtube_player_upnext.png)
*16:9 embedded player with full automotive controls, fullscreen expand within cockpit frame, and seamless instant-switching Up Next recommendations queue.*

<br/>

### 11. High-Precision Cockpit 3D Navigation with Pearl White Lincoln Zephyr
![Clean OpenStreetMap Navigation](docs/screenshots/11_navigation_map.png)
*Modern 3D cockpit perspective navigation powered by MapLibre GL and a custom Three.js WebGL layer rendering the authentic Lincoln Zephyr sedan in pearl white, aligned with dynamic 3D street projection.*

<br/>

### 12. OrbitXM Satellite Radio Suite & 18-Channel Broadcast
![OrbitXM Satellite Radio Suite](docs/screenshots/12_orbitxm_satellite_radio.png)
*Full-screen OrbitXM satellite radio suite featuring 18 curated live digital channels, dynamic album artwork showcase, quick-access preset bar with authentic Grand Theft Auto in-game station vectors, and one-touch channel tuning.*

<br/>

### 13. APEX Rejuvenate™ Multi-Sensory Wellness Suite
![APEX Rejuvenate Wellness Suite](docs/screenshots/13_rejuvenate_wellness_suite.png)
*Stationary in-cabin mindfulness experience in partnership with Calm, featuring theme cards (Waterfall, Ocean, Aurora), synchronized seat posture, micro-climate airflow, and ambient lighting.*

<br/>

### 14. Active Rejuvenation Immersion & Vehicle Actuator Synchronization
![Active Rejuvenation Immersion](docs/screenshots/14_rejuvenate_session_active.png)
*Active wellness immersion displaying looping 4K nature video backdrops, spatial acoustics, interactive timeline milestones, countdown timer, and automatic vehicle safety park interlocks.*

<br/>

### 15. Digital Owner's Manual & Categorical Guide
![Digital Owner's Manual Categories](docs/screenshots/15_owners_manual_categories.png)
*Full-featured digital handbook featuring interactive left draggable track thumb, categorized system guides, instant search, and sliding navigation stack animations.*

<br/>

### 16. Dual-View Visual Search with Cockpit & Exterior SUV Hotspot Pins
![Digital Owner's Manual Visual Search](docs/screenshots/16_owners_manual_visual_search.png)
*Interactive visual exploration interface featuring high-resolution luxury cockpit and exterior SUV technical illustrations with touch beacon pins, hover callouts, and page navigation.*

<br/>

### 17. Deep-Dive Topics Reader & Emergency Safety Guides
![Digital Owner's Manual Topics Detail](docs/screenshots/17_owners_manual_topics_detail.png)
*Drill-down topic reader with fluid horizontal sliding transitions, contextual safety warning banners, read-time badges, and direct breadcrumb navigation.*

<br/>

### 18. Expanded Full-Bleed 3D Cockpit Navigation & Google Automotive HUD
![Expanded 3D Cockpit Navigation](docs/screenshots/18_navigation_expanded_3d.png)
*Full-bleed 3D cockpit perspective navigation featuring Three.js Lincoln Zephyr luxury sedan in pearl white, Google Automotive floating search card with category POI carousel, circular HUD speedometer with live speed physics and speed limit warnings, and 3-in-1 view mode switcher (Perspective / North-up / Overview).*

<br/>

### 19. Dual-Viewport Cockpit with Live Google Vector 3D Map and OrbitXM
![Cockpit Homescreen OrbitXM](docs/screenshots/19_cockpit_homescreen_orbitxm.png)
*Dual-card cockpit dashboard with live hardware-accelerated Google 3D perspective vector map, Three.js Lincoln Zephyr sedan, dynamic street projection, and the OrbitXM live streaming card with now-playing artwork.*

</div>

---

## Subsystem Specifications

### 1. APEX Rejuvenate™ Multi-Sensory Wellness Suite (Stationary Immersion)
- **Multi-Sensory Orchestration Controller (`RejuvenateController`)**: State machine orchestrating synchronous transitions across vehicle subsystems during stationary parking:
  - **Motorized Seating (`SeatBackend`)**: Automatic seat transition from driving posture to **Relax Mode** (45° ergonomic recline) upon start, activating continuous pneumatic wave massage at Level 2, and automatic restoration to standard upright position upon completion.
  - **Micro-Climate Control (`ClimateBackend`)**: Temperature regulation to 22.0°C with automated gentle ambient cabin airflow (`AUTO` mode, A/C engaged).
  - **Spatial Ambient Lighting (`AmbientLightBackend`)**: Dynamic color transitions matching themes (e.g. Cyan Blue `#24D9FF` for Aurora, Deep Aqua for Ocean) with breathing brightness modulation.
- **Calm Audio/Visual Integration**: Integrated high-definition looping nature videos, soothing binaural audio streams, and synchronized timeline milestones (Preparing, In Progress, Concluding).
- **Automotive Safety Park Interlock**: Mandatory transmission Park (`P`) monitor. Shifting gears into Drive (`D`) or Reverse (`R`) immediately pauses the immersion, triggers an elevated safety modal, and safely halts motorized actuators.

### 2. Digital Owner's Manual & Visual Hotspot Navigation
- **3-Mode Tabbed Navigation**: Seamless switching between **Categories**, **Visual search**, and **Bookmarks** with sliding amber indicator underline.
- **2-Page Visual Search (Cockpit & Exterior SUV)**:
  - **Page 1 (Luxury Cockpit Interior)**: Interactive touch pins for Steering Controls, Digital Cockpit Cluster, 15.6" Infotainment Display, Center Console, Ambient Air Vents, and Seat Memory.
  - **Page 2 (Exterior SUV Perspective)**: Touch pins for Matrix LED Headlights, Front Radar & LiDAR sensors, Smart Keyless Mirrors, Power Charge Port, and Hands-Free Power Liftgate.
  - **Adaptive Hover Tooltips**: Responsive tooltips that automatically detect viewport boundaries to prevent edge clipping.
- **Fluid Horizontal Navigation Stack**:
  - Decoupled header layout with bidirectional horizontal slide animations for category breadcrumb titles (`0 → -60px` / `60px → 0`).
  - True off-screen content transitions (`100% viewport width → 0`) eliminating view overlap during drill-down into topics and articles.
- **Real-Time Touch Keyboard Search**:
  - Live query filtering across all manual chapters and subtopics.
  - Built-in automotive on-screen touch keyboard with Shift, Space, and Backspace.
- **Interactive Capsule Dragger**: Custom touch-target draggable capsule thumb synchronized bidirectionally with `Flickable.contentY`.

### 3. Native YouTube Video Hub & Embedded Streaming Engine
- **Asynchronous Scraping Engine (`VideoBackend`)**: Native C++ network client interacting directly with YouTube endpoints via `QNetworkAccessManager`, parsing initial data payloads and search streams without third-party API keys or quota limits.
- **7 Automotive Categorical Feeds**: One-touch category filtering for `All`, `Trending`, `Music`, `Gaming`, `Movies`, `Podcasts`, and `Live`.
- **Infinite Drag-Scroll Pagination**: Dynamic scroll-depth monitoring triggering automatic pre-fetching and append operations for seamless browsing.
- **Embedded Sandbox Player**: Hardware-accelerated QtWebEngineView loading sandbox embeds with Chromium flag `--autoplay-policy=no-user-gesture-required`.
- **Seamless Up Next Queue**: Tap-to-play related videos leveraging the YouTube iframe API (`loadVideoById`) for immediate in-place transitions without reload latency.
- **Cockpit-Preserving Fullscreen**: Full-bleed workspace expansion with permanent visibility of the left navigation rail, right status/slider bar, and bottom climate control dock.

### 4. 3D Cockpit Navigation and Geospatial Engine
- **Three.js WebGL CustomLayer**: High-performance WebGL layer seamlessly integrated into the MapLibre GL 3D perspective pipeline, rendering the authentic **Lincoln Zephyr luxury sedan in pearl white** with panoramic black glass roof, chrome trim, and high-fidelity chassis geometry.
- **Dynamic 3D Screen Bounding Corner Projection**: Real-time projection of all 8 3D vehicle vertices to 2D screen coordinates, calculating `max(y) + 18px` so the current street badge never clips or overlaps the car at any pitch, zoom, rotation, or screen dimension.
- **Circular Google Automotive Speedometer & HUD Physics**: Dual-ring speedometer cluster with live vehicle speed readout (`km/h`), speed limit warning sign, and dynamic vehicle acceleration/braking physics.
- **3-in-1 Cockpit View Mode Switcher**: Single interactive control switching seamlessly between:
  - **Perspective 3D**: 58° forward-looking driving pitch following car heading.
  - **North-Up 2D**: 0° top-down orientation aligned with true geographic North.
  - **Route Overview**: High-altitude macroscopic zoom framing the entire active journey.
- **Spacious Trip Arrival & Route Summary Card**: Clean spacious card displaying route destination, total distance, elapsed trip time, and average speed upon waypoint arrival.
- **Refactored Search & Category POI Navigation**: Floating Google Automotive search bar with inline category carousel (Gas, Restaurant, Grocery, Coffee), distance-sorted POI discovery, and Nominatim reverse geocoding with JSON headers.
- **Base Cartography & Extruded 3D Buildings**: Hardware-accelerated MapLibre GL vector and raster tiles with vector 3D building extrusions (OpenFreeMap planet tiles) and local offline asset caching.

### 5. HVAC, Climate, and Cabin Air Purification
- **Dual-Zone Temperature Control**: Independent driver and passenger thermal regulation ranging from 16.0°C to 28.0°C with fine-grained 0.5°C stepping.
- **3D Interactive Cabin Studio**: Real-time 3D rendered cabin view with interactive directional airflow vents.
- **Cabin Air Refresh Overlay**: Real-time cabin air purification loop with animated air particle streams and live PM2.5 index gauges.
- **3-Level Seat Ventilation & Heating**: Independent seat cooling and PTC heating control with 3-stage visual state feedback.
- **Defrost Modes**: Dedicated MAX Front Windshield Defrost and Rear Heated Glass controls.

### 6. Multi-Contour Massage and Seat Studio
- **Multi-Zone Pneumatic Massage**: Upper Back, Lower Back, and Cushion massage zones with independent intensity control (Off, Low, Medium, High).
- **Front Passenger & 2nd Row Controls**: Multi-seat selection menu with amber indicator underline and status telemetry.
- **Electric Actuator Adjustments**: Cushion height/tilt, seat track forward/backward sliding, and backrest recline controls.

### 7. Valet Mode Security Lockout System
- **PIN-Protected Security**: Full-screen modal overlay preventing unauthorized access to vehicle settings, personal data, and storage compartments.
- **Secure Keypad HMI**: Automotive touch keypad with PIN confirmation, auto-clearing masked digits, and tactile click feedback.
- **System Lockout State**: Dynamic status broadcasting to all IVI pages and lock confirmation indicators.

### 8. Automotive OEM Settings Architecture & Multi-Category Navigation
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

### 9. Media Player, OrbitXM Satellite Radio, and Acoustic Soundstage Architecture
- **OrbitXM™ Satellite Radio Suite**:
  - **18 Curated Satellite Channels**: Broadcast channels spanning regional Indian hits (**Bollywood Hits**, **Ishq & Melodies**, **Retro**, **90s Rewind**, **Punjabi Swag**, **South Wave**, **Desi Hip-Hop**, **Indie Spotlight**, **Bangla Modern**, **Acoustic Sessions**, **Bhakti & Dhyan**, **Classical Ragas**), live sports (**Cricket Live India**), 24x7 news (**Samachar 24x7**), and authentic in-game **Grand Theft Auto Radio Stations** (**Flash FM**, **Los Santos Rock Radio**, **Non-Stop-Pop FM**, **Radio Los Santos**).
  - **Authentic Radio Logos**: Genuine vector and high-resolution station emblems faithfully preserved and loaded across dark-mode cards and HUD pills.
  - **High-Definition Station Art Carousel**: Dynamic 3-card rotating visual art carousel showcasing vibrant station graphics with smooth swipe navigation and automated backdrop lighting.
  - **Fluid Channel Grid Pagination & Preset Bar**: Normalized 150x62 station logo containers with pagination indicators and instant one-touch preset tuning.
- **Acoustic Balance & Fade Soundstage**:
  - **Zoomed Cabin Geometry**: Focused interior cabin layout showcasing driver, passenger, and second-row seating with metallic roof contours.
  - **Theme-Blended Alpha Dissolve**: Vehicle top-view renders with a smooth cubic alpha gradient, blending effortlessly into active wallpapers (**Inspire**, **Constellation**, **Tranquil**, **Voyage**) without harsh bounding boxes.
  - **Radiating Acoustic Wave Ripples**: Animated concentric sound wave pulses continuously propagate outward in real-time from the draggable focal point.
  - **Interactive Reticle Thumb & Instant Reset**: Touch and drag positioning to adjust front/rear fade and left/right balance, with a one-touch "Reset" button restoring center equilibrium `(0, 0)`.
- **Dynamic Tone Controls**: 13-point discrete sliders (-6 to +6) for Bass, Midrange, and Treble with floating teardrop level tooltips.
- **Digital Radio Tuner & Frequency Keypad**: Multi-band AM, FM, and satellite tuner with numeric frequency entry, preset bookmarking, and live waveform monitor.

### 10. Direct Full-Screen Cockpit Navigation & Google 3D Vector Map Engine
- **Direct App Launch**: Launching Navigation from the Applications drawer seamlessly opens the full-screen 3D Google Vector / WebGL perspective map directly (`openFullNavigation()`), bypassing intermediate compact cards.
- **Three.js WebGL CustomLayer**: Renders an authentic Lincoln Zephyr luxury sedan in pearl white with high-gloss clearcoat, metallic flakes, and tinted glass roof on top of live vector map tiles.
- **Dynamic 3D Screen Bounding Projection**: Continually projects an 8-corner 3D bounding box into 2D viewport coordinates, positioning street name pills dynamically above the vehicle body with zero clipping or occlusion across all aspect ratios.
- **Google Automotive Circular HUD Speedometer**: Modern dual-ring circular cluster with live digital speed physics, warning speed limit sign, and dynamic acceleration curves.
- **3-in-1 Cockpit View Mode Switcher**: Instant single-touch view switching:
  - **Perspective 3D**: 58-degree pitch with automated heading synchronization.
  - **North-Up 2D**: Flat orthographic map with dynamic compass needle alignment.
  - **Route Overview**: Complete trip overview displaying route polyline, destination arrival ETA, trip distance, and average speed.

### 11. Security Hardening & Zero-Leak Secret Scanning Architecture
- **Dynamic Secret Resolution**: Completely eliminates hardcoded API credentials from version control. At startup, `NavigationBackend` dynamically searches for credentials from:
  1. `config.json` (git-ignored local file)
  2. `.env` file (git-ignored local file)
  3. System environment variable (`GOOGLE_MAPS_API_KEY`)
- **Developer Templates**: Provides safe, version-controlled templates `config.example.json` and `.env.example` for rapid developer onboarding.
- **WebEngine Runtime Bridge**: Injects credentials securely into the WebEngine JavaScript runtime via `window.setGoogleApiKey(...)` without exposing keys in static web files.

### 12. High-Performance Binary Resource Pipeline & NO_CACHEGEN Multi-Platform Build Engine
- **Precompiled Binary RCC Bundling**: Static image, font, and audio assets compile directly into a precompiled binary `.rcc` bundle (`assets.rcc`) using `qt_add_binary_resources`, avoiding gigantic C++ byte-array files and eliminating compiler Out-Of-Memory (OOM) crashes.
- **NO_CACHEGEN Ahead-Of-Time Optimization**: Uses `NO_CACHEGEN` inside `qt_add_qml_module` to bypass the Qt 6.5 `qmlcachegen` recursive AST compiler crash (`0xC0000005` Access Violation on Windows MSVC and `143` SIGTERM on Ubuntu Linux), slashing CI build duration from 5+ minutes to under 20 seconds.
- **Cross-Platform Parity**: Fully validated across Linux (Ubuntu 22.04 / 24.04), Windows 2022 (MSVC), and macOS (Apple Silicon & Intel).

---

## Directory Structure

```
Apex_Vision_IVI/
├── CMakeLists.txt                # CMake build configuration for Qt 6, QtWebEngine, and Multimedia
├── Makefile                      # Top-level make targets (build, run, clean)
├── README.md                     # System documentation and architecture guide
├── LICENSE                       # MIT License file
├── config.example.json           # Template configuration for Google Maps API credentials
├── .env.example                  # Template environment file for developer setup
├── .gitignore                    # Git exclusions
├── .github/                      # GitHub configurations
│   └── workflows/                # Continuous integration workflows
│       ├── build.yml             # Ubuntu Linux Qt 6 CI
│       ├── build-macos.yml       # macOS Clang & Homebrew Qt CI
│       ├── build-windows.yml     # Windows MSVC 2022 CI
│       └── release.yml           # Automated release packager
├── assets/                       # Deployed external runtime assets
│   └── rejuvenate/               # High-definition audio, video, and theme configurations
│       ├── audio/                # Nature acoustic soundscapes (Waterfall, Ocean, Aurora)
│       ├── images/               # High-res preview cards and thumbnails
│       ├── themes/               # Theme JSON manifests with actuator sync parameters
│       └── video/                # Hardware-optimized looping nature MP4 backdrops
├── docs/                         # System documentation and visual media
│   └── screenshots/              # Cockpit interface screenshots (01 to 19)
│       ├── 01_cockpit_dashboard.png
│       ├── 02_climate_seat_comfort.png
│       ├── 03_seat_comfort_massage.png
│       ├── 04_cabin_air_refresh.png
│       ├── 05_valet_security_lock.png
│       ├── 06_acoustic_soundstage_balance_fade.png
│       ├── 07_connectivity_network_settings.png
│       ├── 08_voice_assistant_settings.png
│       ├── 09_youtube_video_feed.png
│       ├── 10_youtube_player_upnext.png
│       ├── 11_navigation_map.png
│       ├── 12_orbitxm_satellite_radio.png
│       ├── 13_rejuvenate_wellness_suite.png
│       ├── 14_rejuvenate_session_active.png
│       ├── 15_owners_manual_categories.png
│       ├── 16_owners_manual_visual_search.png
│       ├── 17_owners_manual_topics_detail.png
│       ├── 18_navigation_expanded_3d.png
│       └── 19_cockpit_homescreen_orbitxm.png
├── backend/                      # C++20 backend engines
│   ├── VehicleSimulator.h/.cpp   # Vehicle physics and telemetry simulator
│   ├── VehicleBackend.h/.cpp     # Vehicle status and lighting controller
│   ├── ClimateBackend.h/.cpp     # Dual-zone HVAC and seat comfort controller
│   ├── MediaBackend.h/.cpp       # Audio and media playback state machine
│   ├── NavigationBackend.h/.cpp  # Live GPS, reverse geocoding, and map bridge
│   ├── PhoneBackend.h/.cpp       # Telephony and call management
│   ├── SystemBackend.h/.cpp      # System status and display controller
│   ├── VideoBackend.h/.cpp       # Native YouTube scraping and video player controller
│   ├── RejuvenateController.h/.cpp # Multi-sensory wellness orchestration controller
│   ├── RejuvenateTheme.h/.cpp    # Wellness theme and actuator manifest loader
│   ├── SeatBackend.h/.cpp        # Motorized seat posture and massage controller
│   └── AmbientLightBackend.h/.cpp# Dynamic RGB interior ambient light manager
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
│   │   ├── IconButton.qml        # Automotive touch button primitive
│   │   ├── RejuvenateThemeCard.qml # Theme card with interactive preview
│   │   ├── RejuvenateStatusCard.qml# Actuator telemetry sync card
│   │   └── RejuvenateProgress.qml# Interactive session progress timeline
│   └── pages/                    # Cockpit application screens
│       ├── HomePage.qml          # Split-view dual card home screen
│       ├── VehiclePage.qml       # Vehicle settings and status display
│       ├── PhonePage.qml         # Telephony interface
│       ├── AppsPage.qml          # Application drawer
│       ├── SettingsPage.qml      # Automotive settings suite with 7-category slider navigation
│       ├── VideoPage.qml         # Native YouTube video streaming hub
│       ├── RadioPage.qml         # Multi-band digital radio tuner
│       ├── NewsPage.qml          # Live automotive news reader
│       ├── TowingPage.qml        # Towing & trailer management
│       ├── RejuvenatePage.qml    # APEX Rejuvenate™ stationary wellness portal
│       ├── RejuvenateSession.qml # Full-screen multi-sensory immersion session
│       └── ManualPage.qml        # Digital Owner's Manual with 2-page visual search
└── web/                          # Embedded 3D navigation web assets
    ├── map.html                  # MapLibre GL 3D perspective navigation view
    ├── maplibre-gl.js            # Bundled MapLibre GL engine runtime
    ├── maplibre-gl.css           # MapLibre stylesheet
    ├── three.min.js              # Bundled Three.js 3D WebGL engine
    ├── GLTFLoader.js             # Three.js GLTF/GLB asset loader
    └── lincoln_zephyr.glb        # Lincoln Zephyr authentic 3D car model
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
  - `Qt6::Multimedia`

### Developer Environment & API Configuration

Apex VISION IVI uses dynamic secret resolution to load API keys without hardcoding them in version control.

1. **Option A: JSON Configuration (Recommended)**:
   ```bash
   cp config.example.json config.json
   # Edit config.json and enter your Google Maps API key
   ```

2. **Option B: Environment Variables**:
   ```bash
   cp .env.example .env
   # Or export directly in your shell:
   export GOOGLE_MAPS_API_KEY="YOUR_GOOGLE_MAPS_API_KEY"
   ```

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

- **Qt Project**: Cross-platform GUI and automotive application framework (Qt Quick, QML, QtWebEngine, QtMultimedia).
- **MapLibre GL JS**: High-performance open-source WebGL map rendering engine enabling hardware-accelerated 3D cockpit perspective.
- **OpenStreetMap Contributors**: Global open spatial database powering cartography and geospatial coordinates.
- **OpenFreeMap**: Community-driven 3D vector tile infrastructure providing vector building extrusions.
- **Nominatim**: OpenStreetMap search and reverse-geocoding engine for live automotive street resolution.
- **Rasmus Andersson**: Inter font family designed for computer screens and automotive digital displays.

---

## Release History & Highlights

### [v2.5.0] - OrbitXM Satellite Radio Suite, Direct Full-Screen Navigation, Security Hardening & CI Multi-Platform Stabilization
- **OrbitXM Satellite Radio Suite & 18-Channel Broadcast**:
  - Curated 18-channel portfolio across global music, live sports, 24x7 news, and authentic in-game Grand Theft Auto radio stations.
  - High-definition rotating station art carousel with smooth swipe physics and persistent quick-preset bar.
  - Authentic vector logos for GTA Flash FM, GTA Los Santos Rock Radio, GTA Non-Stop-Pop FM, and GTA Radio Los Santos.
- **Direct Full-Screen Cockpit Navigation**:
  - One-touch direct launch into full-screen 3D Google Vector perspective navigation from the Apps drawer, bypassing compact split layouts.
  - Viewport-aware vector canvas resizing with automated heading and camera pitch synchronization.
- **Security Hardening & Secret Scanning Protection**:
  - Elimination of hardcoded secrets from source code; dynamic API key loading via local git-ignored `config.json` and `.env`.
  - Added `config.example.json` and `.env.example` templates for streamlined developer configuration.
  - Runtime WebEngine key injection via `window.setGoogleApiKey(...)`.
- **High-Performance Multi-Platform CI/CD Optimization**:
  - Integrated `NO_CACHEGEN` into `qt_add_qml_module`, resolving `qmlcachegen` crashes on Windows MSVC (`0xC0000005`) and Ubuntu (`143`).
  - Switched asset compilation to high-speed binary `qt_add_binary_resources(assets.rcc)`, slashing build duration from minutes to seconds.
  - Verified continuous integration across Ubuntu 22.04, Windows 2022, and macOS.
- **Developer Authorship Attribution**:
  - Integrated developer attribution banner across C++, QML, and CMake source files, and embedded developer credentials into the Settings > System > About UI.

### [v2.4.0] - Lincoln Zephyr 3D White Model, Automotive HUD Speedometer & Map Navigation Polish
- **Lincoln Zephyr 3D Model with Pearl White Automotive Finish**:
  - Embedded binary GLTF model (`lincoln_zephyr.glb`) rendered in true 3D perspective via Three.js WebGL CustomLayer.
  - Pearl white multi-layer metallic paint shader with gloss clearcoat and tinted panoramic glass roof.
  - Real-time orientation and elevation lock to vehicle heading and road level coordinates.
- **Dynamic 3D Screen Bounding Projection for Street Labels**:
  - Full 8-corner 3D bounding box projected continuously into 2D viewport coordinates.
  - Dynamically computes `maxY + 18px` positioning so the street name pill never overlaps or clips the vehicle body at any zoom, pitch, heading angle, or display aspect ratio.
- **Google Automotive Circular HUD Speedometer**:
  - Modern dual-ring circular cluster with live digital speed (`km/h`), warning speed limit sign, and dynamic vehicle speed physics.
  - Optimized positioning 32px above the Google badge preventing layout collision.
- **3-in-1 Cockpit View Mode Switcher**:
  - Seamless single-touch navigation modes: **Perspective 3D** (58° pitch with heading lock), **North-Up 2D** (flat map with compass needle synchronization), and **Route Overview**.
- **Spacious Trip Arrival & Route Summary Card**:
  - Clean spacious card displaying destination name, arrival ETA, trip distance, and calculated average speed.
- **Refactored Search, Categories & CORS Resolution**:
  - Floating Google Automotive search bar with inline category carousel (Gas, Restaurant, Grocery, Coffee).
  - Switched from CORS-blocked endpoints to Nominatim reverse geocoding with JSON headers.
  - Silenced benign web console logging in QML terminal.

### [v2.3.0] - APEX Rejuvenate™ Multi-Sensory Wellness Suite, Digital Owner's Manual & Visual Search Navigation Stack
- **APEX Rejuvenate™ Stationary Wellness Immersion Suite**:
  - Integrated `RejuvenateController` state machine managing automated transitions across vehicle comfort subsystems.
  - Multi-actuator synchronization: Motorized relaxation recline (45°), wave pneumatic massage cycle, dual-zone micro-climate regulation, and cyan/amber ambient illumination.
  - High-definition nature video backdrops with looping video playback and spatial audio acoustic streams.
  - Safety Park Interlock & Drive Motion Monitor: Real-time Park (`P`) transmission lock validation, gear shifting detection, and safety alert modal with automatic session termination.
  - Interactive session timeline milestones: *Preparing*, *Active*, and *Concluding* with real-time countdown timer.
- **Digital Owner's Manual & Visual Hotspot Navigation**:
  - 3-Mode navigation: **Categories**, **Visual search**, and **Bookmarks** with sliding amber indicator underline.
  - 2-Page visual search (Cockpit Interior and Exterior SUV views) with interactive touch beacon pins, hover callouts, and direct topic linkage.
  - Fluid horizontal navigation stack with decoupled header breadcrumb transitions and true off-screen content transitions (`100% viewport width → 0`).
  - Real-time search engine with instant query filtering and embedded automotive touch keyboard.
  - Interactive left vertical draggable track thumb with generous touch target bounds.
- **Asset Optimization & Repository Hardening**:
  - Removed unwanted mock assets and compressed nature backdrops to fast-loading looping H.264 MP4s.
  - Updated architectural diagrams, directory trees, and complete 17-screenshot subsystem gallery.

### [v2.2.0] - Native YouTube Video Streaming Suite, Infinite Feed, Instant Up Next Queue & Enhanced OSM Navigation
- Native YouTube video hub with `VideoBackend` scraping, infinite drag-scroll, and category feeds.
- 16:9 embedded player with auto-hiding controls and zero-latency Up Next recommendations queue.
- Official OpenStreetMap raster tile infrastructure (`tile.openstreetmap.de` & `tile.openstreetmap.fr`).
- Multi-band digital radio tuner with frequency keypad and live waveform monitor.

### [v2.1.0] - Acoustic Soundstage Wave Ripples, Zoomed Cabin Fade, Tone Tooltips & 7-Category OEM Settings Suite
- Acoustic balance and fader soundstage with zoomed vehicle cabin and concentric sound wave pulse animation.
- Dynamic 13-point discrete tone sliders with floating teardrop level tooltips.
- 7-category OEM settings architecture with fluid horizontal slide animations.

### [v2.0.0] - 3D Cabin & Seat Studio, Valet Lock Mode, and OEM Settings Suite
- 3D interactive multi-contour massage seats and cabin airflow studio.
- Full-screen PIN security valet lock overlay with masked keypad.
- Real-time PM2.5 air quality gauge and high-velocity cabin air refresh cycle.

---

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.  
Third-party licenses and acknowledgments are documented in [THIRD_PARTY_LICENSES.md](THIRD_PARTY_LICENSES.md).
