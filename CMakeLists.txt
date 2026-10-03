# ==============================================================================
# Project: Apex VISION IVI - Digital Cockpit & Infotainment System
# Author / Developer: Sk Rehan Ahamed
# License: MIT
# ==============================================================================

cmake_minimum_required(VERSION 3.20)

project(APEX_VISION_IVI VERSION 2.6.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

if(DEFINED ENV{QT_ROOT_DIR})
    list(PREPEND CMAKE_PREFIX_PATH "$ENV{QT_ROOT_DIR}")
endif()
if(DEFINED ENV{QT_ROOT})
    list(PREPEND CMAKE_PREFIX_PATH "$ENV{QT_ROOT}")
endif()
if(DEFINED ENV{Qt6_DIR})
    list(PREPEND CMAKE_PREFIX_PATH "$ENV{Qt6_DIR}")
endif()

if(APPLE AND EXISTS "/opt/homebrew/opt/qt")
    list(PREPEND CMAKE_PREFIX_PATH "/opt/homebrew/opt/qt" "/opt/homebrew/opt/qtwebengine" "/opt/homebrew/opt/qtmultimedia")
endif()
if(EXISTS "/usr/lib/cmake/Qt6")
    list(PREPEND CMAKE_PREFIX_PATH "/usr/lib/cmake/Qt6" "/usr/lib/cmake")
endif()

find_package(Qt6 REQUIRED COMPONENTS
    Core
    Gui
    Quick
    Qml
    QuickControls2
    Svg
    Network
    Quick3D
    Quick3DHelpers
    Multimedia
)

find_package(Qt6 COMPONENTS WebEngineCore WebEngineQuick QUIET)

qt_standard_project_setup()

set(BACKEND_SOURCES
    backend/PersistenceManager.h
    backend/PersistenceManager.cpp
    backend/VehicleSimulator.h
    backend/VehicleSimulator.cpp
    backend/VehicleBackend.h
    backend/VehicleBackend.cpp
    backend/ClimateBackend.h
    backend/ClimateBackend.cpp
    backend/MediaBackend.h
    backend/MediaBackend.cpp
    backend/NavigationBackend.h
    backend/NavigationBackend.cpp
    backend/PhoneBackend.h
    backend/PhoneBackend.cpp
    backend/SystemBackend.h
    backend/SystemBackend.cpp
    backend/VideoBackend.h
    backend/VideoBackend.cpp
    backend/RejuvenateTheme.h
    backend/RejuvenateTheme.cpp
    backend/AmbientLightBackend.h
    backend/AmbientLightBackend.cpp
    backend/SeatBackend.h
    backend/SeatBackend.cpp
    backend/RejuvenateController.h
    backend/RejuvenateController.cpp
)

qt_add_executable(apex_vision_ivi
    main.cpp
    ${BACKEND_SOURCES}
)

set_source_files_properties(qml/Typography.qml PROPERTIES
    QT_QML_SINGLETON_TYPE TRUE
)

qt_add_qml_module(apex_vision_ivi
    URI ApexVision
    VERSION 1.0
    NO_CACHEGEN
    QML_FILES
        qml/Main.qml
        qml/pages/HomePage.qml
        qml/pages/VehiclePage.qml
        qml/pages/AppsPage.qml
        qml/pages/PhonePage.qml
        qml/pages/SettingsPage.qml
        qml/pages/TowingPage.qml
        qml/pages/NewsPage.qml
        qml/pages/RadioPage.qml
        qml/pages/VideoPage.qml
        qml/pages/RejuvenatePage.qml
        qml/pages/RejuvenateSession.qml
        qml/pages/ManualPage.qml
        qml/pages/ProfileSwitcherPage.qml
        qml/pages/MobileDeviceConnectionPage.qml
        qml/pages/MessagesPage.qml
        qml/pages/GamesPage.qml
        qml/components/SideNavigation.qml
        qml/components/StatusBar.qml
        qml/components/MediaCard.qml
        qml/components/NavigationPanel.qml
        qml/components/ClimateBar.qml
        qml/components/Climate3DPanel.qml
        qml/components/CabinAirRefreshOverlay.qml
        qml/components/IconButton.qml
        qml/components/TemperatureControl.qml
        qml/components/ValetLockOverlay.qml
        qml/components/LaneKeepingVisualizer.qml
        qml/components/RejuvenateThemeCard.qml
        qml/components/RejuvenateStatusCard.qml
        qml/components/RejuvenateProgress.qml
        qml/components/WelcomeScreen.qml
        qml/Typography.qml
)

# Compile raw static assets (images, fonts, sounds) into a lightning-fast binary RCC bundle
# This eliminates massive C++ source generation and avoids compiler OOM crashes on CI runners
qt_add_binary_resources(assets_rcc
    assets.qrc
    DESTINATION "${CMAKE_CURRENT_BINARY_DIR}/assets.rcc"
)
add_dependencies(apex_vision_ivi assets_rcc)

# Custom target to keep QML static assets in sync with build directory
add_custom_target(DeployQmlAssets
    COMMAND ${CMAKE_COMMAND} -E copy_directory
        ${CMAKE_CURRENT_SOURCE_DIR}/qml/assets
        ${CMAKE_CURRENT_BINARY_DIR}/qml/assets
    COMMENT "Deploying QML assets to build directory"
)
add_dependencies(apex_vision_ivi DeployQmlAssets)

target_include_directories(apex_vision_ivi PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${CMAKE_CURRENT_SOURCE_DIR}/backend
)

if(APPLE AND EXISTS "/opt/homebrew/opt/qt")
    target_include_directories(apex_vision_ivi PRIVATE
        /opt/homebrew/opt/qt/include
        /opt/homebrew/opt/qtwebengine/include
    )
endif()

target_link_libraries(apex_vision_ivi PRIVATE
    Qt6::Core
    Qt6::Gui
    Qt6::Quick
    Qt6::Qml
    Qt6::QuickControls2
    Qt6::Svg
    Qt6::Network
    Qt6::Quick3D
    Qt6::Quick3DHelpers
    Qt6::Multimedia
)

if(TARGET Qt6::WebEngineQuick)
    target_link_libraries(apex_vision_ivi PRIVATE
        Qt6::WebEngineCore
        Qt6::WebEngineQuick
    )
    target_compile_definitions(apex_vision_ivi PRIVATE HAVE_WEBENGINE=1)
endif()

# Custom target to keep 3D model meshes, textures, and assets in sync with build directory
add_custom_target(DeployClimate3DAssets
    COMMAND ${CMAKE_COMMAND} -E copy_directory
        ${CMAKE_CURRENT_SOURCE_DIR}/qml/climate3d
        ${CMAKE_CURRENT_BINARY_DIR}/qml/climate3d
    COMMENT "Deploying 3D Climate assets to build directory"
)
add_dependencies(apex_vision_ivi DeployClimate3DAssets)

# Custom target to keep Rejuvenate assets in sync with build directory
add_custom_target(DeployRejuvenateAssets
    COMMAND ${CMAKE_COMMAND} -E copy_directory
        ${CMAKE_CURRENT_SOURCE_DIR}/assets/rejuvenate
        ${CMAKE_CURRENT_BINARY_DIR}/assets/rejuvenate
    COMMENT "Deploying Rejuvenate video, audio, and theme assets to build directory"
)
add_dependencies(apex_vision_ivi DeployRejuvenateAssets)

# Custom target to keep Web & Live 3D Map assets in sync with build directory
add_custom_target(DeployWebAssets
    COMMAND ${CMAKE_COMMAND} -E copy_directory
        ${CMAKE_CURRENT_SOURCE_DIR}/web
        ${CMAKE_CURRENT_BINARY_DIR}/web
    COMMENT "Deploying Web & Live 3D Map assets to build directory"
)
add_dependencies(apex_vision_ivi DeployWebAssets)

