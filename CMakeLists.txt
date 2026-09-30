cmake_minimum_required(VERSION 3.20)

project(APEX_VISION_IVI VERSION 2.4.0 LANGUAGES CXX)

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

find_package(Qt6 REQUIRED COMPONENTS
    Core
    Gui
    Quick
    Qml
    QuickControls2
    Svg
    WebEngineCore
    WebEngineQuick
    Network
    Quick3D
    Quick3DHelpers
    Multimedia
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

file(GLOB NEWS_IMAGE_ASSETS RELATIVE "${CMAKE_CURRENT_SOURCE_DIR}" CONFIGURE_DEPENDS "qml/assets/news_images/*.jpg")

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
        qml/pages/TowingPage.qml
        qml/pages/NewsPage.qml
        qml/pages/RadioPage.qml
        qml/pages/VideoPage.qml
        qml/pages/RejuvenatePage.qml
        qml/pages/RejuvenateSession.qml
        qml/pages/ManualPage.qml
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
        qml/assets/icons/icon_ambient_lighting.png
        qml/assets/icons/icon_auto_hold.png
        qml/assets/icons/icon_auto_hold_amber.png
        qml/assets/icons/icon_seats.png
        qml/assets/icons/icon_valet_mode.png
        qml/assets/icons/icon_vehicle_status.png
        qml/assets/icons/icon_vehicle_settings.png
        qml/assets/icons/icon_tire_pressure.png
        qml/assets/icons/icon_oil_life.png
        qml/assets/icons/icon_trunk.svg
        qml/assets/icons/icon_trunk_suv.png
        qml/assets/icons/icon_brightness.svg

        # Status Bar & Connectivity
        qml/assets/icons/status_notification.png
        qml/assets/icons/status_tower.png
        qml/assets/icons/status_gps.png
        qml/assets/default_background.png
        qml/assets/autolamp_delay_preview.png
        qml/assets/autolamp_card.png
        qml/assets/remote_start_climate_preview.png
        qml/assets/remote_start_seats_preview.png
        qml/assets/image.png
        "qml/assets/image copy.png"
        "qml/assets/image copy 2.png"
        qml/assets/theme_constellation.png
        qml/assets/theme_tranquil.png
        qml/assets/theme_voyage.png
        qml/assets/theme_inspire.png
        qml/assets/icons/car_top_balance_fade.png
        qml/assets/remote_unlock_all.png
        qml/assets/remote_unlock_driver.png
        qml/assets/icons/image.png
        qml/assets/vehicle_studio_bg.png
        qml/assets/icons/compass.svg
        qml/assets/icons/bluetooth.svg

        # Media Player & Audio
        qml/assets/icons/play.svg
        qml/assets/icons/pause.svg
        qml/assets/icons/skip_next.svg
        qml/assets/icons/skip_prev.svg
        qml/assets/icons/radio_source.svg
        qml/assets/icons/radio_keypad.svg
        qml/assets/icons/preset_star_add.svg
        qml/assets/icons/preset_star_arrow.svg
        qml/assets/icons/star_glow_filled.svg
        qml/assets/icons/music_note_coral.svg
        qml/assets/icons/usb_source.svg
        qml/assets/icons/phone_add.svg

        # YouTube & Video Icons
        qml/assets/icons/yt_cat_all.svg
        qml/assets/icons/yt_cat_trending.svg
        qml/assets/icons/yt_cat_music.svg
        qml/assets/icons/yt_cat_gaming.svg
        qml/assets/icons/yt_cat_movies.svg
        qml/assets/icons/yt_cat_podcasts.svg
        qml/assets/icons/yt_cat_live.svg
        qml/assets/icons/yt_cat_search.svg
        qml/assets/icons/yt_keyboard.svg
        qml/assets/icons/yt_shift.svg
        qml/assets/icons/yt_backspace.svg
        qml/assets/icons/yt_fullscreen.svg
        qml/assets/icons/yt_close.svg
        qml/assets/icons/yt_chevron_down.svg
        qml/assets/icons/yt_play.svg

        # Map & Search Controls
        qml/assets/icons/search.svg
        qml/assets/icons/icon_search_white.svg
        qml/assets/icons/plus.svg
        qml/assets/icons/minus.svg

        # Climate & Seat Comfort
        qml/assets/icons/seat_comfort_icon.png
        qml/assets/icons/seat_comfort_icon_passenger.png
        qml/assets/icons/seat_second_row_render.png
        "qml/assets/icons/image copy 2.png"
        qml/assets/icons/seat_passenger_render.png
        "qml/assets/icons/image copy 3.png"
        "qml/assets/icons/image copy 4.png"
        "qml/assets/icons/image copy 5.png"
        "qml/assets/icons/image copy 6.png"
        "qml/assets/icons/image copy 7.png"
        "qml/assets/icons/image copy 9.png"
        "qml/assets/icons/image copy 10.png"
        qml/assets/icons/setting_sound.png
        qml/assets/icons/setting_sound_white.png
        qml/assets/icons/setting_sound_yellow.png
        qml/assets/icons/sound_vol_audio.svg
        qml/assets/icons/sound_vol_prompts.svg
        qml/assets/icons/sound_vol_phone.svg
        qml/assets/icons/sound_vol_call_ring.svg
        qml/assets/icons/setting_bluetooth.png
        qml/assets/icons/setting_bluetooth_white.png
        qml/assets/icons/setting_bluetooth_yellow.png
        qml/assets/icons/setting_driver_assistance.png
        qml/assets/icons/setting_driver_assistance_white.png
        qml/assets/icons/setting_driver_assistance_yellow.png
        qml/assets/icons/setting_driver_assist_white.png
        qml/assets/icons/setting_driver_assist_yellow.png
        qml/assets/icons/setting_vehicle_amber.png
        qml/assets/icons/setting_vehicle_white.png
        qml/assets/icons/setting_vehicle_yellow.png
        qml/assets/icons/setting_system.png
        qml/assets/icons/setting_system_white.png
        qml/assets/icons/setting_system_yellow.png
        qml/assets/icons/setting_profile.png
        qml/assets/icons/setting_profile_white.png
        qml/assets/icons/setting_profile_yellow.png
        qml/assets/icons/setting_sliders_logo.svg
        qml/assets/icons/setting_sliders_logo.png
        qml/assets/icons/setting_sliders_white.svg
        qml/assets/icons/app_navigation.svg
        qml/assets/icons/app_store.svg
        qml/assets/icons/app_assistant.svg
        qml/assets/icons/app_rejuvenate.svg
        qml/assets/icons/calm_wordmark.svg
        qml/assets/icons/rej_seat_recline.svg
        qml/assets/icons/rej_head_airflow.svg
        qml/assets/icons/rej_thermometer.svg
        qml/assets/icons/rej_seat_heat.svg
        qml/assets/icons/rej_seat_cushion.svg
        qml/assets/icons/rej_fragrance.svg
        qml/assets/icons/rej_seat_upright.svg
        qml/assets/icons/rej_seat_massage.svg
        qml/assets/icons/rej_sparkle.svg
        qml/assets/icons/rejuvenate_icons_4k.png
        qml/assets/icons/rejuvenate_timeline_icons.png
        qml/assets/icons/rejuvenate_icons_relax.png
        qml/assets/icons/rejuvenate_icons_invigorate.png
        qml/assets/icons/rejuvenate_ico_0.png
        qml/assets/icons/rejuvenate_ico_1.png
        qml/assets/icons/rejuvenate_ico_2.png
        qml/assets/icons/rejuvenate_ico_3.png
        qml/assets/icons/rejuvenate_ico_4.png
        qml/assets/icons/rejuvenate_ico_5.png
        qml/assets/icons/rejuvenate_ico_6.png
        qml/assets/icons/rejuvenate_ico_7.png
        qml/assets/icons/rejuvenate_ico_8.png
        qml/assets/icons/rejuvenate_ico_9.png
        qml/assets/icons/rejuvenate_ico_10.png
        qml/assets/icons/rejuvenate_ico_11.png
        qml/assets/icons/app_phone.svg
        qml/assets/icons/app_am.svg
        qml/assets/icons/app_fm.svg
        qml/assets/icons/app_siriusxm.svg
        qml/assets/icons/app_satellite_radio.svg
        qml/assets/icons/app_bluetooth.svg
        qml/assets/icons/app_messages.svg
        qml/assets/icons/app_media.svg
        qml/assets/icons/app_trailer.svg
        qml/assets/icons/app_carplay.svg
        qml/assets/icons/app_hotspot.svg
        qml/assets/icons/app_manual.svg
        qml/assets/icons/app_updates.svg
        qml/assets/icons/app_games.svg
        qml/assets/icons/app_news.svg
        qml/assets/icons/app_video.svg
        qml/assets/icons/app_projection.svg
        qml/assets/icons/icon_globe.svg
        qml/assets/icons/icon_units_speedo.svg
        qml/assets/icons/icon_time_clock.svg
        qml/assets/icons/icon_reset_options.svg
        qml/assets/icons/icon_software_update.svg
        qml/assets/icons/icon_about_info.svg
        qml/assets/icons/icon_legal_info.svg
        qml/assets/icons/icon_software_licenses.svg
        qml/assets/icons/icon_storage.svg
        qml/assets/icons/icon_phone_link.svg
        qml/assets/icons/icon_storage_music.svg
        qml/assets/icons/icon_storage_apps.svg
        qml/assets/icons/icon_storage_maps.svg
        qml/assets/icons/icon_storage_system.svg
        qml/assets/icons/icon_profile_lock.svg
        qml/assets/icons/icon_mic.svg
        qml/assets/icons/setting_display_white.svg
        qml/assets/icons/setting_display_yellow.svg
        qml/assets/icons/setting_wifi_white.svg
        qml/assets/icons/setting_wifi_yellow.svg
        qml/assets/icons/setting_911_assist_white.svg
        qml/assets/icons/setting_911_assist_yellow.svg
        qml/assets/icons/setting_assistant_voice_white.svg
        qml/assets/icons/setting_assistant_voice_yellow.svg
        qml/assets/icons/setting_location_white.svg
        qml/assets/icons/setting_location_yellow.svg
        qml/assets/icons/setting_notifications_white.svg
        qml/assets/icons/setting_notifications_yellow.svg
        qml/assets/icons/setting_privacy_white.svg
        qml/assets/icons/setting_privacy_yellow.svg
        qml/assets/icons/setting_security_white.svg
        qml/assets/icons/setting_security_yellow.svg
        qml/assets/icons/setting_accessibility_white.svg
        qml/assets/icons/setting_accessibility_yellow.svg
        qml/assets/icons/icon_mic_privacy.svg
        qml/assets/icons/icon_app_permissions.svg
        qml/assets/icons/icon_privacy_infotainment.svg
        qml/assets/icons/icon_data_sharing_apex.svg
        qml/assets/icons/icon_security_update.svg
        qml/assets/icons/icon_accessibility_captions.svg
        qml/assets/icons/icon_sound_fader.svg
        qml/assets/icons/icon_google_assistant.svg
        qml/assets/avatars/avatar_climber.jpg
        qml/assets/avatars/avatar_desert.jpg
        qml/assets/avatars/avatar_phoenix.jpg
        qml/assets/avatars/avatar_architecture.jpg
        qml/assets/avatars/avatar_fish.jpg
        qml/assets/avatars/avatar_cabin.jpg
        qml/assets/avatars/avatar_aurora.jpg
        qml/assets/avatars/avatar_sunset.jpg
        qml/assets/avatars/avatar_twilight.jpg
        qml/assets/avatars/avatar_bird.jpg
        qml/assets/avatars/avatar_mountain.jpg
        qml/assets/avatars/avatar_forest.jpg
        qml/assets/avatars/avatar_chevron.jpg
        qml/assets/avatars/avatar_geometric.jpg
        qml/assets/avatars/avatar_waves.jpg
        qml/assets/avatars/avatar_marble.jpg
        qml/assets/avatars/avatar_bird.svg
        qml/assets/avatars/avatar_chevron.svg
        qml/assets/avatars/avatar_diamond.svg
        qml/assets/avatars/avatar_waves.svg
        qml/assets/avatars/avatar_marble.svg
        qml/assets/icons/icon_translate.svg
        qml/assets/icons/icon_google.svg
        qml/assets/icons/icon_settings_gear.svg
        qml/assets/icons/setting_back_return.svg
        qml/assets/icons/setting_back_return.png
        qml/assets/icons/seat_menu_second_row_blue.png
        qml/assets/icons/seat_menu_second_row_amber.png
        qml/assets/icons/seat_menu_passenger_blue.png
        qml/assets/icons/seat_menu_passenger_amber.png
        qml/assets/icons/seat_menu_adjust_massage_blue.png
        qml/assets/icons/seat_menu_adjust_massage_amber.png
        qml/assets/icons/icon_tire_pressure_blue.png
        qml/assets/icons/icon_tire_pressure_amber.png
        qml/assets/icons/icon_oil_life_blue.png
        qml/assets/icons/icon_oil_life_amber.png
        qml/assets/icons/lane_assist_aid.jpg
        qml/assets/icons/lane_assist_alert.jpg
        qml/assets/icons/lane_assist_car.png
        qml/assets/icons/lane_assist_body_bg.png
        qml/assets/icons/lane_assist_body_fg.png
        qml/assets/icons/lane_assist_wheel_1.png
        qml/assets/icons/lane_assist_wheel_2.png
        qml/assets/icons/lane_assist_wheel_3.png
        qml/assets/icons/lane_assist_wheel_4.png
        qml/assets/icons/lane_assist_steering.png
        qml/assets/icons/lane_track_left.png
        qml/assets/icons/lane_track_right.png
        qml/assets/icons/lane_track_left_alert.png
        qml/assets/icons/wheel_disc_rl.png
        qml/assets/icons/wheel_disc_fl.png
        qml/assets/icons/icon_passenger_recline_back.png
        qml/assets/icons/icon_passenger_recline_fwd.png
        qml/assets/icons/icon_passenger_cushion_down.png
        qml/assets/icons/icon_passenger_cushion_up.png
        qml/assets/icons/icon_seat_second_row.svg
        qml/assets/icons/icon_seat_passenger.svg
        qml/assets/icons/icon_seat_adjust_massage.svg
        qml/assets/icons/icon_seat_recline_forward.svg
        qml/assets/icons/icon_seat_recline_backward.svg
        qml/assets/icons/icon_seat_slide_forward.svg
        qml/assets/icons/icon_seat_slide_backward.svg
        qml/assets/icons/icon_seat_preset.svg
        qml/assets/icons/icon_power.svg
        qml/assets/icons/icon_seat_minus.svg
        qml/assets/icons/icon_seat_plus.svg
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
        qml/assets/icons/icon_left_close.png
        qml/assets/icons/icon_left_power.png
        qml/assets/icons/icon_left_defrost.png
        qml/assets/icons/icon_left_defrost_yellow.png
        qml/assets/icons/icon_left_face.png
        qml/assets/icons/icon_left_face_yellow.png
        qml/assets/icons/icon_rear_face.png
        qml/assets/icons/icon_rear_face_yellow.png
        qml/assets/icons/icon_left_feet.png
        qml/assets/icons/icon_left_feet_yellow.png
        qml/assets/icons/icon_left_sync.png
        qml/assets/icons/icon_right_recirc.png
        qml/assets/icons/icon_right_max_ac.png
        qml/assets/icons/icon_right_refresh.png

        # Automotive News Vector Icons
        qml/assets/icons/news_car.svg
        qml/assets/icons/news_globe.svg
        qml/assets/icons/news_cpu.svg
        qml/assets/icons/news_trending.svg
        qml/assets/icons/news_zap.svg
        qml/assets/icons/news_speaker.svg
        qml/assets/icons/news_speaker_mute.svg
        qml/assets/icons/news_radio.svg
        qml/assets/icons/news_paper.svg
        qml/assets/icons/news_refresh.svg
        qml/assets/icons/news_play.svg
        qml/assets/icons/news_pause.svg
        qml/assets/icons/news_skip_back.svg
        qml/assets/icons/news_skip_forward.svg
        qml/assets/icons/news_clock.svg
        qml/assets/icons/news_sparkles.svg
        qml/assets/icons/news_rss.svg
        qml/assets/icons/news_mic.svg
        qml/assets/icons/news_waveform.svg
        qml/assets/icons/news_arrow_left.svg
        qml/assets/icons/news_chevron_left.svg
        qml/assets/icons/news_chevron_right.svg
        qml/assets/icons/news_bookmark.svg
        qml/assets/icons/news_bookmark_filled.svg
        ${NEWS_IMAGE_ASSETS}

        # Web & Live 3D Map
        web/map.html
        web/maplibre-gl.js
        web/maplibre-gl.css
        web/three.min.js
        web/GLTFLoader.js
        web/lincoln_zephyr.glb
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
    Qt6::WebEngineCore
    Qt6::WebEngineQuick
    Qt6::Network
    Qt6::Quick3D
    Qt6::Quick3DHelpers
    Qt6::Multimedia
)

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

