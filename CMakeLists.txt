cmake_minimum_required(VERSION 3.20)

project(APEX_VISION_IVI LANGUAGES CXX)

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
    list(PREPEND CMAKE_PREFIX_PATH "/opt/homebrew/opt/qt" "/opt/homebrew/opt/qtwebengine")
endif()

find_package(Qt6 REQUIRED COMPONENTS
    Core
    Gui
    Quick
    Qml
    QuickControls2
    Svg
    WebEngineQuick
    Network
)

qt_standard_project_setup()

set(BACKEND_SOURCES
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
    QML_FILES
        qml/Main.qml
        qml/pages/HomePage.qml
        qml/pages/VehiclePage.qml
        qml/pages/AppsPage.qml
        qml/pages/PhonePage.qml
        qml/pages/SettingsPage.qml
        qml/components/SideNavigation.qml
        qml/components/StatusBar.qml
        qml/components/MediaCard.qml
        qml/components/NavigationPanel.qml
        qml/components/ClimateBar.qml
        qml/components/IconButton.qml
        qml/components/TemperatureControl.qml
        qml/Typography.qml
    RESOURCES
        # Fonts
        qml/assets/fonts/Inter-Regular.ttf
        qml/assets/fonts/Inter-Medium.ttf
        qml/assets/fonts/Inter-SemiBold.ttf
        qml/assets/fonts/Inter-Bold.ttf

        # Branding & Navigation
        qml/assets/icons/apex_logo.png
        qml/assets/icons/icon_home.png
        qml/assets/icons/icon_car.png
        qml/assets/icons/icon_menu.png
        qml/assets/icons/nav_home.svg
        qml/assets/icons/nav_vehicle.svg
        qml/assets/icons/nav_phone.svg
        qml/assets/icons/nav_settings.svg

        # Status Bar & Connectivity
        qml/assets/icons/status_notification.png
        qml/assets/icons/status_tower.png
        qml/assets/icons/status_gps.png
        "qml/assets/icons/image copy.png"
        qml/assets/icons/compass.svg
        qml/assets/icons/bluetooth.svg

        # Media Player & Audio
        qml/assets/icons/play.svg
        qml/assets/icons/pause.svg
        qml/assets/icons/skip_next.svg
        qml/assets/icons/skip_prev.svg
        qml/assets/icons/radio_source.svg
        qml/assets/icons/phone_add.svg

        # Map & Search Controls
        qml/assets/icons/search.svg
        qml/assets/icons/plus.svg
        qml/assets/icons/minus.svg

        # Climate & Seat Comfort
        qml/assets/icons/seat_comfort_icon.png
        qml/assets/icons/seat_comfort_icon_passenger.png
        qml/assets/icons/icon_fan.png
        qml/assets/icons/icon_airflow_seat.png
        qml/assets/icons/chevron_up.svg
        qml/assets/icons/chevron_down.svg
        qml/assets/icons/icon_seat_auto.png
        qml/assets/icons/icon_seat_auto_passenger.png
        qml/assets/icons/icon_seat_vent.png
        qml/assets/icons/icon_seat_vent_blue_passenger.png
        qml/assets/icons/icon_seat_vent_passenger.png
        qml/assets/icons/icon_seat_vent_driver.png
        qml/assets/icons/icon_seat_heat.png
        qml/assets/icons/icon_seat_heat_passenger.png
        qml/assets/icons/icon_steering_heat.png
        qml/assets/icons/defrost_front.svg
        qml/assets/icons/defrost_rear.svg

        # Web & Live 3D Map
        web/map.html
        web/osm_logo.png
        web/osm_logo_with_name.png
)

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
    Qt6::WebEngineQuick
    Qt6::Network
)
