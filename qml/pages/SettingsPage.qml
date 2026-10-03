import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import ApexVision
import "../components"

Item {
    id: root
    objectName: "settingsPage"

    signal backRequested()

    // Default category matching user photo ("connectivity")
    property string activeCategory: "sound"
    property string activeInfoText: ""
    property int returnIndex: 1

    // Driver assistance settings states (matching hierarchical user photos)
    property string daCurrentScreen: "main" // "main" | "cruise_control" | "speed_limit_assist" | "speed_adjustment" | "lane_keeping_system" | "lane_keeping_mode" | "lane_keeping_intensity"
    property string daFromScreen: "cruise_control" // "cruise_control" | "speed_limit_assist"
    property int daSlideDir: 1 // 1: forward, -1: back
    property string cruiseControlType: "adaptive" // "normal" | "adaptive"
    property bool laneCenteringEnabled: true
    property bool predictiveSpeedAssistEnabled: false
    property bool speedWarningEnabled: false
    property int speedAdjustment: 0 // 0 to 16 km/h
    property string laneKeepingMode: "Alert"
    property string laneAlertIntensity: "Normal"
    property bool autoEmergencyBraking: true
    property bool evasiveSteeringAssist: true
    property string alertSensitivity: "Normal" // "Low" | "Normal" | "High"
    property string preCollisionMode: "Warning, braking, steering"
    property bool inLaneRepositioningEnabled: true

    // Vehicle settings states (matching user images)
    property string vehCurrentScreen: "main" // "main" | "rear_occupant_alert" | "lighting" | "autolamp_delay" | "easy_entry" | "running_board_modes" | "windows" | "remote_start" | "remote_start_climate"
    property int vehSlideDir: 1
    property bool maxIdleEnabled: true
    property string rearOccupantMode: "Alert only" // "Alert and horn" | "Alert only" | "Off"
    property bool autoHighBeamsEnabled: true
    property string autolampDelay: "20 seconds" // "Off" | "10 seconds" | "20 seconds" | "120 seconds"
    property bool childSeatInstalled: false
    property bool keyDetectionEnabled: false
    property bool easyEntrySeatAdjustment: false
    property bool easyEntryApproachDetection: true
    property string runningBoardMode: "Auto" // "Off" | "Out" | "Auto"
    property bool windowsRemoteOpen: true
    property bool courtesyWipeEnabled: false
    property bool rainSensingEnabled: true
    property bool rearWiperReverseEnabled: true
    property bool alarmAskOnExit: true
    property string alarmMotionSensors: "On"
    property string powerLiftgateMode: "Power" // "Power" | "Manual"
    property bool handsFreeLiftgateEnabled: true
    property bool liftgateChimeEnabled: true
    property bool remoteStartEnabled: true
    property string remoteStartClimate: "Auto"
    property string remoteStartSeats: "Auto"
    property string remoteStartDuration: "15 minutes"
    property bool autoUnlockEnabled: true
    property bool mislockChirpEnabled: true
    property bool switchInhibitEnabled: true
    property bool audibleFeedbackEnabled: true
    property string remoteUnlockMode: "All doors" // "All doors" | "Driver's door"
    property bool mirrorAutofoldEnabled: true
    property string doorKeypadCode: ""

    // System settings states (matching Languages & input OEM photo)
    property string sysCurrentScreen: "main" // "main" | "languages_input" | "languages_select" | "autofill_service" | "keyboard_settings" | "keyboard_onscreen" | "keyboard_physical" | "tts_settings" | "tts_engine" | "tts_language" | "personal_dictionary" | "units" | "units_temperature" | "units_measurement" | "units_pressure" | "units_weight" | "time" | "time_zone" | "reset_options" | "reset_hotspot" | "reset_paak" | "reset_apps" | "reset_connectivity" | "factory_reset"
    property int sysSlideDir: 1
    property bool factoryResetConfirmationOpen: false
    property bool resetConfirmationOpen: false
    property string resetModalType: "factory"
    property string selectedLanguage: (typeof SystemBackend !== "undefined") ? SystemBackend.selectedLanguage : "English"
    property string selectedAutofill: (typeof SystemBackend !== "undefined") ? SystemBackend.selectedAutofill : "Apex Cloud"
    property string selectedKeyboard: (typeof SystemBackend !== "undefined") ? SystemBackend.selectedKeyboard : "Apex Touch Keyboard"
    property string ttsEngine: "APEX Embedded Neural Engine"
    property string ttsLanguage: "Use system language"
    property real ttsSpeechRate: 50
    property real ttsPitch: 50
    property bool spellCheckerEnabled: true
    property bool autoCapitalizationEnabled: true
    property bool autoCorrectionEnabled: true
    property bool autofillPasswordsEnabled: true
    property bool autofillPaymentsEnabled: true
    property int pointerSpeed: (typeof SystemBackend !== "undefined") ? SystemBackend.pointerSpeed : 50
    property bool hapticFeedbackEnabled: true
    property bool soundOnKeypressEnabled: false
    property bool showLanguageSwitchKey: true
    property bool physicalUseOnscreen: false
    property string virtualKbTestInput: ""
    property bool ttsSamplePlaying: false
    property string unitsTemperature: (typeof ClimateBackend !== "undefined" && ClimateBackend.isFahrenheit) ? "Fahrenheit (°F)" : ((typeof SystemBackend !== "undefined" && typeof SystemBackend.unitsTemperature !== "undefined") ? SystemBackend.unitsTemperature : "Celsius (°C)")
    property string unitsMeasurement: "km & L/100 km"
    property string unitsPressure: "psi"
    property string unitsWeight: "Pounds (lb)"
    property bool speedometerMph: false
    property bool time24HourFormat: (typeof SystemBackend !== "undefined") ? SystemBackend.is24HourFormat : true
    property bool timeAutoZone: (typeof SystemBackend !== "undefined") ? SystemBackend.autoTimeZoneEnabled : true
    property bool timeAutoSet: (typeof SystemBackend !== "undefined") ? SystemBackend.autoTimeEnabled : true
    property string selectedTimeZone: (typeof SystemBackend !== "undefined") ? SystemBackend.selectedTimeZone : "GMT-04:00 Eastern Daylight Time"
    property int manualHour: 10
    property int manualMinute: 55
    property string manualAmPm: "PM"
    property int manualYear: 2026
    property int manualMonth: 9
    property int manualDay: 27
    property bool autoUpdatesEnabled: true

    // Profile settings states (matching OEM reference photos)
    property string profCurrentScreen: "main" // "main" | "avatar" | "security" | "lock_type" | "pattern" | "pin" | "password" | "link_profile" | "accounts" | "name"
    property int profSlideDir: 1
    property string currentProfileName: (typeof VehicleBackend !== "undefined") ? VehicleBackend.driverProfileName : "Profile 1"
    property string currentProfileRole: (typeof VehicleBackend !== "undefined" && typeof VehicleBackend.currentProfileRole !== "undefined") ? VehicleBackend.currentProfileRole : "Signed in as admin"
    property string currentProfileAvatar: (typeof VehicleBackend !== "undefined") ? VehicleBackend.driverProfileAvatar : "monogram"
    property string selectedAvatarPreview: (typeof VehicleBackend !== "undefined") ? VehicleBackend.driverProfileAvatar : "monogram"
    property string currentLockType: (typeof VehicleBackend !== "undefined" && typeof VehicleBackend.currentLockType !== "undefined") ? VehicleBackend.currentLockType : "None"
    property string profilePinCode: (typeof VehicleBackend !== "undefined" && typeof VehicleBackend.profilePinCode !== "undefined") ? VehicleBackend.profilePinCode : "1234"
    property string tempPinEntry: ""
    property var patternNodes: []
    property string profilePassword: (typeof VehicleBackend !== "undefined" && typeof VehicleBackend.profilePassword !== "undefined") ? VehicleBackend.profilePassword : ""
    property string tempPasswordEntry: ""
    property bool keyFobLinked: (typeof VehicleBackend !== "undefined" && typeof VehicleBackend.keyFobLinked !== "undefined") ? VehicleBackend.keyFobLinked : true
    property bool phoneKeyLinked: (typeof VehicleBackend !== "undefined" && typeof VehicleBackend.phoneKeyLinked !== "undefined") ? VehicleBackend.phoneKeyLinked : true
    property bool btDeviceLinked: (typeof VehicleBackend !== "undefined" && typeof VehicleBackend.btDeviceLinked !== "undefined") ? VehicleBackend.btDeviceLinked : true
    property bool deleteProfileModalOpen: false
    property bool editProfileNameOpen: false
    property string tempProfileNameInput: "Profile 1"
    property string profileToastMessage: ""

    function saveSetting(key, val) {
        if (typeof PersistenceManager !== "undefined") {
            PersistenceManager.setSetting(key, val);
        }
    }

    Connections {
        target: (typeof VehicleBackend !== "undefined") ? VehicleBackend : null
        function onDriverProfileChanged() {
            root.currentProfileName = VehicleBackend.driverProfileName;
            root.currentProfileAvatar = VehicleBackend.driverProfileAvatar;
            root.selectedAvatarPreview = VehicleBackend.driverProfileAvatar;
            if (typeof VehicleBackend.currentLockType !== "undefined") root.currentLockType = VehicleBackend.currentLockType;
            if (typeof VehicleBackend.profilePinCode !== "undefined") root.profilePinCode = VehicleBackend.profilePinCode;
            if (typeof VehicleBackend.profilePassword !== "undefined") root.profilePassword = VehicleBackend.profilePassword;
            if (typeof VehicleBackend.keyFobLinked !== "undefined") root.keyFobLinked = VehicleBackend.keyFobLinked;
            if (typeof VehicleBackend.phoneKeyLinked !== "undefined") root.phoneKeyLinked = VehicleBackend.phoneKeyLinked;
            if (typeof VehicleBackend.btDeviceLinked !== "undefined") root.btDeviceLinked = VehicleBackend.btDeviceLinked;
        }
        function onProfileSecurityChanged() {
            if (typeof VehicleBackend.currentLockType !== "undefined") root.currentLockType = VehicleBackend.currentLockType;
            if (typeof VehicleBackend.profilePinCode !== "undefined") root.profilePinCode = VehicleBackend.profilePinCode;
            if (typeof VehicleBackend.profilePassword !== "undefined") root.profilePassword = VehicleBackend.profilePassword;
            if (typeof VehicleBackend.keyFobLinked !== "undefined") root.keyFobLinked = VehicleBackend.keyFobLinked;
            if (typeof VehicleBackend.phoneKeyLinked !== "undefined") root.phoneKeyLinked = VehicleBackend.phoneKeyLinked;
            if (typeof VehicleBackend.btDeviceLinked !== "undefined") root.btDeviceLinked = VehicleBackend.btDeviceLinked;
        }
    }

    Component.onCompleted: {
        if (typeof PersistenceManager !== "undefined") {
            // Driver assistance
            root.cruiseControlType = PersistenceManager.getSetting("da_cruiseControlType", root.cruiseControlType);
            root.laneCenteringEnabled = PersistenceManager.getSetting("da_laneCenteringEnabled", root.laneCenteringEnabled);
            root.predictiveSpeedAssistEnabled = PersistenceManager.getSetting("da_predictiveSpeedAssistEnabled", root.predictiveSpeedAssistEnabled);
            root.speedWarningEnabled = PersistenceManager.getSetting("da_speedWarningEnabled", root.speedWarningEnabled);
            root.speedAdjustment = PersistenceManager.getSetting("da_speedAdjustment", root.speedAdjustment);
            root.laneKeepingMode = PersistenceManager.getSetting("da_laneKeepingMode", root.laneKeepingMode);
            root.laneAlertIntensity = PersistenceManager.getSetting("da_laneAlertIntensity", root.laneAlertIntensity);
            root.autoEmergencyBraking = PersistenceManager.getSetting("da_autoEmergencyBraking", root.autoEmergencyBraking);
            root.evasiveSteeringAssist = PersistenceManager.getSetting("da_evasiveSteeringAssist", root.evasiveSteeringAssist);
            root.alertSensitivity = PersistenceManager.getSetting("da_alertSensitivity", root.alertSensitivity);
            root.preCollisionMode = PersistenceManager.getSetting("da_preCollisionMode", root.preCollisionMode);
            root.inLaneRepositioningEnabled = PersistenceManager.getSetting("da_inLaneRepositioningEnabled", root.inLaneRepositioningEnabled);

            // Vehicle convenience & hardware
            root.maxIdleEnabled = PersistenceManager.getSetting("veh_maxIdleEnabled", root.maxIdleEnabled);
            root.rearOccupantMode = PersistenceManager.getSetting("veh_rearOccupantMode", root.rearOccupantMode);
            root.autoHighBeamsEnabled = PersistenceManager.getSetting("veh_autoHighBeamsEnabled", root.autoHighBeamsEnabled);
            root.autolampDelay = PersistenceManager.getSetting("veh_autolampDelay", root.autolampDelay);
            root.powerLiftgateMode = PersistenceManager.getSetting("veh_powerLiftgateMode", root.powerLiftgateMode);
            root.handsFreeLiftgateEnabled = PersistenceManager.getSetting("veh_handsFreeLiftgateEnabled", root.handsFreeLiftgateEnabled);
            root.liftgateChimeEnabled = PersistenceManager.getSetting("veh_liftgateChimeEnabled", root.liftgateChimeEnabled);
            root.remoteStartEnabled = PersistenceManager.getSetting("veh_remoteStartEnabled", root.remoteStartEnabled);
            root.autoUnlockEnabled = PersistenceManager.getSetting("veh_autoUnlockEnabled", root.autoUnlockEnabled);
            root.mirrorAutofoldEnabled = PersistenceManager.getSetting("veh_mirrorAutofoldEnabled", root.mirrorAutofoldEnabled);
            root.doorKeypadCode = PersistenceManager.getSetting("veh_doorKeypadCode", root.doorKeypadCode);
            root.runningBoardMode = PersistenceManager.getSetting("veh_runningBoardMode", root.runningBoardMode);
            root.windowsRemoteOpen = PersistenceManager.getSetting("veh_windowsRemoteOpen", root.windowsRemoteOpen);
            root.courtesyWipeEnabled = PersistenceManager.getSetting("veh_courtesyWipeEnabled", root.courtesyWipeEnabled);
            root.rainSensingEnabled = PersistenceManager.getSetting("veh_rainSensingEnabled", root.rainSensingEnabled);
            root.rearWiperReverseEnabled = PersistenceManager.getSetting("veh_rearWiperReverseEnabled", root.rearWiperReverseEnabled);
            root.alarmAskOnExit = PersistenceManager.getSetting("veh_alarmAskOnExit", root.alarmAskOnExit);
            root.alarmMotionSensors = PersistenceManager.getSetting("veh_alarmMotionSensors", root.alarmMotionSensors);

            // System units & keyboard preferences
            root.unitsMeasurement = PersistenceManager.getSetting("sys_unitsMeasurement", root.unitsMeasurement);
            root.unitsPressure = PersistenceManager.getSetting("sys_unitsPressure", root.unitsPressure);
            root.unitsWeight = PersistenceManager.getSetting("sys_unitsWeight", root.unitsWeight);
            root.speedometerMph = PersistenceManager.getSetting("sys_speedometerMph", root.speedometerMph);
        }
    }

    onCruiseControlTypeChanged: saveSetting("da_cruiseControlType", cruiseControlType)
    onLaneCenteringEnabledChanged: saveSetting("da_laneCenteringEnabled", laneCenteringEnabled)
    onPredictiveSpeedAssistEnabledChanged: saveSetting("da_predictiveSpeedAssistEnabled", predictiveSpeedAssistEnabled)
    onSpeedWarningEnabledChanged: saveSetting("da_speedWarningEnabled", speedWarningEnabled)
    onSpeedAdjustmentChanged: saveSetting("da_speedAdjustment", speedAdjustment)
    onLaneKeepingModeChanged: saveSetting("da_laneKeepingMode", laneKeepingMode)
    onLaneAlertIntensityChanged: saveSetting("da_laneAlertIntensity", laneAlertIntensity)
    onAutoEmergencyBrakingChanged: saveSetting("da_autoEmergencyBraking", autoEmergencyBraking)
    onEvasiveSteeringAssistChanged: saveSetting("da_evasiveSteeringAssist", evasiveSteeringAssist)
    onAlertSensitivityChanged: saveSetting("da_alertSensitivity", alertSensitivity)
    onPreCollisionModeChanged: saveSetting("da_preCollisionMode", preCollisionMode)
    onInLaneRepositioningEnabledChanged: saveSetting("da_inLaneRepositioningEnabled", inLaneRepositioningEnabled)

    onMaxIdleEnabledChanged: saveSetting("veh_maxIdleEnabled", maxIdleEnabled)
    onRearOccupantModeChanged: saveSetting("veh_rearOccupantMode", rearOccupantMode)
    onAutoHighBeamsEnabledChanged: saveSetting("veh_autoHighBeamsEnabled", autoHighBeamsEnabled)
    onAutolampDelayChanged: saveSetting("veh_autolampDelay", autolampDelay)
    onPowerLiftgateModeChanged: saveSetting("veh_powerLiftgateMode", powerLiftgateMode)
    onHandsFreeLiftgateEnabledChanged: saveSetting("veh_handsFreeLiftgateEnabled", handsFreeLiftgateEnabled)
    onLiftgateChimeEnabledChanged: saveSetting("veh_liftgateChimeEnabled", liftgateChimeEnabled)
    onRemoteStartEnabledChanged: saveSetting("veh_remoteStartEnabled", remoteStartEnabled)
    onAutoUnlockEnabledChanged: saveSetting("veh_autoUnlockEnabled", autoUnlockEnabled)
    onMirrorAutofoldEnabledChanged: saveSetting("veh_mirrorAutofoldEnabled", mirrorAutofoldEnabled)
    onDoorKeypadCodeChanged: saveSetting("veh_doorKeypadCode", doorKeypadCode)
    onRunningBoardModeChanged: saveSetting("veh_runningBoardMode", runningBoardMode)
    onWindowsRemoteOpenChanged: saveSetting("veh_windowsRemoteOpen", windowsRemoteOpen)
    onCourtesyWipeEnabledChanged: saveSetting("veh_courtesyWipeEnabled", courtesyWipeEnabled)
    onRainSensingEnabledChanged: saveSetting("veh_rainSensingEnabled", rainSensingEnabled)
    onRearWiperReverseEnabledChanged: saveSetting("veh_rearWiperReverseEnabled", rearWiperReverseEnabled)
    onAlarmAskOnExitChanged: saveSetting("veh_alarmAskOnExit", alarmAskOnExit)
    onAlarmMotionSensorsChanged: saveSetting("veh_alarmMotionSensors", alarmMotionSensors)

    onUnitsMeasurementChanged: saveSetting("sys_unitsMeasurement", unitsMeasurement)
    onUnitsPressureChanged: saveSetting("sys_unitsPressure", unitsPressure)
    onUnitsWeightChanged: saveSetting("sys_unitsWeight", unitsWeight)
    onSpeedometerMphChanged: saveSetting("sys_speedometerMph", speedometerMph)

    onProfileToastMessageChanged: {
        if (profileToastMessage !== "") {
            profToastTimer.restart();
        }
    }

    Timer {
        id: profToastTimer
        interval: 3500
        onTriggered: root.profileToastMessage = ""
    }

    property var avatarList: [
        { id: "monogram", name: "Monogram (P1)", type: "monogram", path: "" },
        { id: "bird", name: "Soaring Bird", type: "image", path: "qrc:/ApexVision/qml/assets/avatars/avatar_bird.jpg" },
        { id: "chevron", name: "Gold Chevron", type: "image", path: "qrc:/ApexVision/qml/assets/avatars/avatar_chevron.jpg" },
        { id: "geometric", name: "Art Deco Diamonds", type: "image", path: "qrc:/ApexVision/qml/assets/avatars/avatar_geometric.jpg" },
        { id: "waves", name: "Golden Waves", type: "image", path: "qrc:/ApexVision/qml/assets/avatars/avatar_waves.jpg" },
        { id: "marble", name: "Blue Swirl Marble", type: "image", path: "qrc:/ApexVision/qml/assets/avatars/avatar_marble.jpg" },
        { id: "climber", name: "Mountain Climber", type: "image", path: "qrc:/ApexVision/qml/assets/avatars/avatar_climber.jpg" },
        { id: "desert", name: "Desert Canyon Sunset", type: "image", path: "qrc:/ApexVision/qml/assets/avatars/avatar_desert.jpg" },
        { id: "phoenix", name: "Fire Phoenix", type: "image", path: "qrc:/ApexVision/qml/assets/avatars/avatar_phoenix.jpg" },
        { id: "architecture", name: "Skyscraper Architecture", type: "image", path: "qrc:/ApexVision/qml/assets/avatars/avatar_architecture.jpg" },
        { id: "fish", name: "River Trout", type: "image", path: "qrc:/ApexVision/qml/assets/avatars/avatar_fish.jpg" },
        { id: "cabin", name: "Alpine Cabin & Lake", type: "image", path: "qrc:/ApexVision/qml/assets/avatars/avatar_cabin.jpg" },
        { id: "aurora", name: "Northern Lights Aurora", type: "image", path: "qrc:/ApexVision/qml/assets/avatars/avatar_aurora.jpg" },
        { id: "twilight", name: "Twilight Hills", type: "image", path: "qrc:/ApexVision/qml/assets/avatars/avatar_twilight.jpg" },
        { id: "sunset", name: "Golden Sunset", type: "image", path: "qrc:/ApexVision/qml/assets/avatars/avatar_sunset.jpg" },
        { id: "forest", name: "Pine Forest", type: "image", path: "qrc:/ApexVision/qml/assets/avatars/avatar_forest.jpg" },
        { id: "mountain", name: "Snow Peaks", type: "image", path: "qrc:/ApexVision/qml/assets/avatars/avatar_mountain.jpg" }
    ]

    function getAvatarPath(id) {
        for (var i = 0; i < root.avatarList.length; i++) {
            if (root.avatarList[i].id === id) return root.avatarList[i].path;
        }
        return "";
    }

    Timer {
        id: ttsTimer
        interval: 3500
        onTriggered: root.ttsSamplePlaying = false
    }

    Connections {
        target: (typeof SystemBackend !== "undefined") ? SystemBackend : null
        function onIs24HourFormatChanged() {
            root.time24HourFormat = SystemBackend.is24HourFormat;
        }
        function onAutoTimeEnabledChanged() {
            root.timeAutoSet = SystemBackend.autoTimeEnabled;
        }
        function onAutoTimeZoneEnabledChanged() {
            root.timeAutoZone = SystemBackend.autoTimeZoneEnabled;
        }
        function onSelectedTimeZoneChanged() {
            root.selectedTimeZone = SystemBackend.selectedTimeZone;
        }
        function onSelectedLanguageChanged() {
            root.selectedLanguage = SystemBackend.selectedLanguage;
        }
        function onSelectedKeyboardChanged() {
            root.selectedKeyboard = SystemBackend.selectedKeyboard;
        }
        function onSelectedAutofillChanged() {
            root.selectedAutofill = SystemBackend.selectedAutofill;
        }
        function onPointerSpeedChanged() {
            root.pointerSpeed = SystemBackend.pointerSpeed;
        }
        function onUnitsTemperatureChanged() {
            root.unitsTemperature = SystemBackend.unitsTemperature;
        }
    }

    Connections {
        target: (typeof ClimateBackend !== "undefined") ? ClimateBackend : null
        function onTemperatureUnitChanged() {
            root.unitsTemperature = ClimateBackend.isFahrenheit ? "Fahrenheit (°F)" : "Celsius (°C)";
        }
    }

    // Bluetooth settings states (matching Bluetooth HMI photo)
    property bool bluetoothEnabled: true
    property bool btPairingActive: false
    property bool btSearching: false
    property bool wifiEnabled: true
    property real displayBrightness: 75
    property string dispCurrentScreen: "main" // "main" | "brightness" | "mode" | "theme" | "calm_screen"
    property int dispSlideDir: 1
    property bool dispTouchscreenBeep: true
    property string dispMode: "Auto" // "Auto" | "Light" | "Dark"
    property string dispTheme: "Constellation"
    readonly property color currentThemeAccent: {
        if (root.dispTheme === "Tranquil") return "#38BDF8";
        if (root.dispTheme === "Voyage") return "#C084FC";
        if (root.dispTheme === "Inspire") return "#22D3EE";
        return "#E08365"; // Constellation (default amber)
    }
    property var currentDate: new Date()

    // New Settings Options states (matching user reference photos)
    property bool vehicleConnectivityEnabled: true
    property bool assist911Enabled: true
    property bool voiceUseTextFromScreen: true
    property bool voiceUseScreenshot: true
    property string digitalAssistantApp: "Google Assistant"
    property bool locationEnabled: true
    property string locationAccuracyMode: "Off"
    property bool dndWhileDriving: true
    property bool notifSoundEnabled: true
    property bool notifLockScreenEnabled: true
    property bool cameraAccessEnabled: true
    property bool micAccessEnabled: true
    property bool diagnosticDataEnabled: true

    // Sub-screens for slide transitions
    property string connCurrentScreen: "main" // "main" | "wifi"
    property int connSlideDir: 1
    property string locCurrentScreen: "main" // "main" | "recent_requests" | "app_permissions"
    property int locSlideDir: 1
    property string voiceCurrentScreen: "main" // "main" | "digital_assistant" | "voice_language"
    property int voiceSlideDir: 1
    property string voiceLanguage: "English (United States)"
    property string notifCurrentScreen: "main" // "main" | "app_notifications"
    property int notifSlideDir: 1

    // Sound sub-screens and audio tuning (Matching OEM reference photos)
    property string soundCurrentScreen: "main" // "main" | "tone" | "balance_fade" | "speed_volume" | "quantum_logic" | "revel_experience" | "volume_settings" | "ringtones" | "notification_sounds"
    property int soundSlideDir: 1
    property string soundMode: "Audience"
    property string quantumLogicMode: "Audience"
    property string soundBalancePreset: "All Seats"
    property real soundFadeX: 0
    property real soundFadeY: 0
    property int soundBass: 0
    property int soundMid: 0
    property int soundTreble: 0
    property real soundQuantumLogic: 75
    property string speedCompVolume: "Medium"
    property bool isPlayingRevelDemo: false
    property int soundVolumeAudio: 1
    property int soundVolumePrompts: 10
    property int soundVolumePhone: 30
    property int soundVolumeCallRing: 10
    property string soundRingtone: "Default ringtone"
    property string soundNotificationSound: "Default notification"

    // Privacy sub-screens (Matching OEM photo 1 & 2)
    property string privCurrentScreen: "main" // "main" | "microphone" | "location" | "app_permissions" | "infotainment_data" | "ads" | "data_sharing"
    property int privSlideDir: 1
    property bool adsPersonalization: false
    property bool analyticsSharing: true
    property bool trafficSharing: true
    property bool otaDataSharing: true

    // Security sub-screens (Matching OEM photo 3)
    property string secCurrentScreen: "main" // "main" | "lock_type" | "pattern" | "pin" | "password" | "clear_credentials" | "security_update"
    property int secSlideDir: 1

    // Accessibility sub-screens (Matching OEM photo 4)
    property string accCurrentScreen: "main" // "main" | "caption_preferences" | "display_scaling"
    property int accSlideDir: 1
    property bool captionEnabled: false
    property string captionSize: "Medium"
    property string captionStyle: "White on black"
    property bool highContrastEnabled: false
    property string displayScaling: "Standard (100%)"
    property bool screenReaderEnabled: false
    property bool monoAudioEnabled: false

    Timer {
        interval: 10000
        running: true
        repeat: true
        onTriggered: root.currentDate = new Date()
    }

    // Full-screen mode for Lane-Keeping Mode & Autolamp Delay & Remote Start Climate & Remote Start Seats & Duration & Remote Unlock & Door Keypad & Profile Name & Avatar & Calm screen & Tone
    readonly property bool isFullScreenMode: (root.activeCategory === "driver_assist" && root.daCurrentScreen === "lane_keeping_mode") ||
                                             (root.activeCategory === "vehicle" && (root.vehCurrentScreen === "autolamp_delay" || root.vehCurrentScreen === "remote_start_climate" || root.vehCurrentScreen === "remote_start_seats" || root.vehCurrentScreen === "remote_start_duration" || root.vehCurrentScreen === "remote_unlock" || root.vehCurrentScreen === "door_keypad_code")) ||
                                             (root.activeCategory === "profile" && (root.profCurrentScreen === "name" || root.profCurrentScreen === "avatar")) ||
                                             (root.activeCategory === "display" && root.dispCurrentScreen === "calm_screen") ||
                                             (root.activeCategory === "sound" && root.soundCurrentScreen === "tone")

    // =========================================================================
    // 0. BACKGROUND (Matches Default BG & Valet Screen)
    // =========================================================================
    Image {
        id: settingsBgImage
        anchors.fill: parent
        source: "qrc:/ApexVision/qml/assets/default_background.png"
        fillMode: Image.PreserveAspectCrop
        smooth: true
        z: 0
    }

    // Intercept clicks
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onClicked: root.activeInfoText = ""
    }

    // =========================================================================
    // 1. MAIN TWO-COLUMN WORKSPACE
    // Left side: Settings header + Categories menu
    // Right side: Active title with standard "←" back button + Divider + Items
    // =========================================================================
    Item {
        id: contentArea
        anchors.fill: parent
        anchors.leftMargin: root.isFullScreenMode ? 28 : 44
        anchors.rightMargin: root.isFullScreenMode ? 28 : 44
        anchors.topMargin: 24
        anchors.bottomMargin: 24
        z: 5

        Behavior on anchors.leftMargin { NumberAnimation { duration: 280; easing.type: Easing.OutCubic } }
        Behavior on anchors.rightMargin { NumberAnimation { duration: 280; easing.type: Easing.OutCubic } }

        // Left Column Subtle Dark Backdrop (Gentle tint per OEM photo - not too dark)
        Rectangle {
            id: leftColumnDarkBackdrop
            anchors.left: parent.left
            anchors.leftMargin: root.isFullScreenMode ? -400 : -44
            anchors.right: leftColumn.right
            anchors.rightMargin: -20
            anchors.top: parent.top
            anchors.topMargin: -70
            anchors.bottom: parent.bottom
            anchors.bottomMargin: -80
            color: "#040810"
            opacity: root.isFullScreenMode ? 0.0 : 0.12
            visible: opacity > 0.001
            z: 0

            Behavior on opacity { NumberAnimation { duration: 240 } }
            Behavior on anchors.leftMargin { NumberAnimation { duration: 280; easing.type: Easing.OutCubic } }
        }

        // ---------------------------------------------------------------------
        // LEFT COLUMN: Header ("Settings") + Category Navigation Menu
        // ---------------------------------------------------------------------
        Item {
            id: leftColumn
            width: 330
            anchors.left: parent.left
            anchors.leftMargin: root.isFullScreenMode ? -370 : 0
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            opacity: root.isFullScreenMode ? 0.0 : 1.0
            visible: opacity > 0.001
            enabled: !root.isFullScreenMode

            Behavior on anchors.leftMargin { NumberAnimation { duration: 280; easing.type: Easing.OutCubic } }
            Behavior on opacity { NumberAnimation { duration: 240 } }

            // Top-Left Header: Circular Sliders Logo + "Settings"
            Row {
                id: leftHeaderRow
                anchors.left: parent.left
                anchors.top: parent.top
                height: 48
                spacing: 14

                // Bright blue circular logo with two slider bars (Automotive OEM settings icon)
                Image {
                    width: 38
                    height: 38
                    anchors.verticalCenter: parent.verticalCenter
                    source: "qrc:/ApexVision/qml/assets/icons/setting_sliders_logo.svg"
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                    mipmap: true

                    // Interactive subtle scale on hover
                    scale: settingsIconMouse.containsMouse ? 1.06 : 1.0
                    Behavior on scale { NumberAnimation { duration: 120 } }

                    MouseArea {
                        id: settingsIconMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            root.activeCategory = "driver_assist";
                            root.activeInfoText = "";
                        }
                    }
                }

                // "Settings" Title (Bold, pure white, no pill wrapper)
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: root.selectedLanguage.indexOf("Hindi") !== -1 ? "सेटिंग्स" : "Settings"
                    font.family: "Inter"
                    font.pixelSize: 28
                    font.weight: Font.DemiBold
                    color: "#FFFFFF"
                }
            }

            // Categories Menu with Drag/Flick support (Sound, BT, Assist, Vehicle, System, Profile)
            Flickable {
                id: leftMenuFlickable
                anchors.top: leftHeaderRow.bottom
                anchors.topMargin: 16
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.rightMargin: 14
                anchors.bottom: parent.bottom
                contentHeight: leftMenuColumn.height + 20
                clip: true
                boundsBehavior: Flickable.StopAtBounds
                flickableDirection: Flickable.VerticalFlick

                Column {
                    id: leftMenuColumn
                    width: parent.width
                    spacing: 8
                    Repeater {
                        model: [
                            { id: "sound", name: (root.selectedLanguage.indexOf("Hindi") !== -1 ? "ध्वनि" : "Sound"), icon: "qrc:/ApexVision/qml/assets/icons/setting_sound.png" },
                            { id: "bluetooth", name: (root.selectedLanguage.indexOf("Hindi") !== -1 ? "ब्लूटूथ" : "Bluetooth"), icon: "qrc:/ApexVision/qml/assets/icons/setting_bluetooth.png" },
                            { id: "driver_assist", name: (root.selectedLanguage.indexOf("Hindi") !== -1 ? "चालक सहायता" : "Driver assistance"), icon: "qrc:/ApexVision/qml/assets/icons/setting_driver_assistance.png" },
                            { id: "vehicle", name: (root.selectedLanguage.indexOf("Hindi") !== -1 ? "वाहन" : "Vehicle"), icon: "qrc:/ApexVision/qml/assets/icons/setting_vehicle_amber.png" },
                            { id: "system", name: (root.selectedLanguage.indexOf("Hindi") !== -1 ? "सिस्टम" : "System"), icon: "qrc:/ApexVision/qml/assets/icons/setting_system.png" },
                            { id: "profile", name: (root.selectedLanguage.indexOf("Hindi") !== -1 ? "प्रोफ़ाइल" : "Profile"), icon: "qrc:/ApexVision/qml/assets/icons/setting_profile.png" },
                            { id: "display", name: (root.selectedLanguage.indexOf("Hindi") !== -1 ? "डिस्प्ले" : "Display"), icon: "qrc:/ApexVision/qml/assets/icons/setting_display_white.svg" },
                            { id: "connectivity", name: (root.selectedLanguage.indexOf("Hindi") !== -1 ? "नेटवर्क और इंटरनेट" : "Network & internet"), icon: "qrc:/ApexVision/qml/assets/icons/setting_wifi_white.svg" },
                            { id: "assist_911", name: (root.selectedLanguage.indexOf("Hindi") !== -1 ? "911 सहायता" : "911 Assist"), icon: "qrc:/ApexVision/qml/assets/icons/setting_911_assist_white.svg" },
                            { id: "voice_assistant", name: (root.selectedLanguage.indexOf("Hindi") !== -1 ? "सहायक और आवाज़" : "Assistant & voice"), icon: "qrc:/ApexVision/qml/assets/icons/setting_assistant_voice_white.svg" },
                            { id: "location", name: (root.selectedLanguage.indexOf("Hindi") !== -1 ? "स्थान" : "Location"), icon: "qrc:/ApexVision/qml/assets/icons/setting_location_white.svg" },
                            { id: "notifications", name: (root.selectedLanguage.indexOf("Hindi") !== -1 ? "सूचनाएं" : "Notifications"), icon: "qrc:/ApexVision/qml/assets/icons/setting_notifications_white.svg" },
                            { id: "privacy", name: (root.selectedLanguage.indexOf("Hindi") !== -1 ? "गोपनीयता" : "Privacy"), icon: "qrc:/ApexVision/qml/assets/icons/setting_privacy_white.svg" },
                            { id: "security", name: (root.selectedLanguage.indexOf("Hindi") !== -1 ? "सुरक्षा" : "Security"), icon: "qrc:/ApexVision/qml/assets/icons/setting_security_white.svg" },
                            { id: "accessibility", name: (root.selectedLanguage.indexOf("Hindi") !== -1 ? "सुलभता" : "Accessibility"), icon: "qrc:/ApexVision/qml/assets/icons/setting_accessibility_white.svg" }
                        ]

                        // Frosted glass rounded pill highlight around selected category (matching user photo)
                        Rectangle {
                            width: parent.width
                            height: 64
                            radius: 16
                            color: root.activeCategory === modelData.id ?
                                   Qt.rgba(255, 255, 255, 0.16) :
                                   (itemMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.08) : "transparent")
                            border.color: root.activeCategory === modelData.id ?
                                          Qt.rgba(255, 255, 255, 0.28) : "transparent"
                            border.width: 1.5
                            Behavior on color { ColorAnimation { duration: 120 } }

                            Row {
                                anchors.fill: parent
                                anchors.leftMargin: 16
                                anchors.rightMargin: 16
                                spacing: 16

                                // Category Icon (Yellow when selected, White when unselected, beige badge for Bluetooth)
                                Image {
                                    anchors.verticalCenter: parent.verticalCenter
                                    width: 32
                                    height: 32
                                    source: {
                                        if (modelData.id === "bluetooth") {
                                            return root.activeCategory === "bluetooth" ?
                                                "qrc:/ApexVision/qml/assets/icons/setting_bluetooth.png" :
                                                "qrc:/ApexVision/qml/assets/icons/setting_bluetooth_white.png";
                                        }
                                        if (modelData.id === "display") {
                                            return root.activeCategory === "display" ?
                                                "qrc:/ApexVision/qml/assets/icons/setting_display_yellow.svg" :
                                                "qrc:/ApexVision/qml/assets/icons/setting_display_white.svg";
                                        }
                                        if (modelData.id === "connectivity") {
                                            return root.activeCategory === "connectivity" ?
                                                "qrc:/ApexVision/qml/assets/icons/setting_wifi_yellow.svg" :
                                                "qrc:/ApexVision/qml/assets/icons/setting_wifi_white.svg";
                                        }
                                        if (modelData.id === "assist_911") {
                                            return root.activeCategory === "assist_911" ?
                                                "qrc:/ApexVision/qml/assets/icons/setting_911_assist_yellow.svg" :
                                                "qrc:/ApexVision/qml/assets/icons/setting_911_assist_white.svg";
                                        }
                                        if (modelData.id === "voice_assistant") {
                                            return root.activeCategory === "voice_assistant" ?
                                                "qrc:/ApexVision/qml/assets/icons/setting_assistant_voice_yellow.svg" :
                                                "qrc:/ApexVision/qml/assets/icons/setting_assistant_voice_white.svg";
                                        }
                                        if (modelData.id === "location") {
                                            return root.activeCategory === "location" ?
                                                "qrc:/ApexVision/qml/assets/icons/setting_location_yellow.svg" :
                                                "qrc:/ApexVision/qml/assets/icons/setting_location_white.svg";
                                        }
                                        if (modelData.id === "notifications") {
                                            return root.activeCategory === "notifications" ?
                                                "qrc:/ApexVision/qml/assets/icons/setting_notifications_yellow.svg" :
                                                "qrc:/ApexVision/qml/assets/icons/setting_notifications_white.svg";
                                        }
                                        if (modelData.id === "privacy") {
                                            return root.activeCategory === "privacy" ?
                                                "qrc:/ApexVision/qml/assets/icons/setting_privacy_yellow.svg" :
                                                "qrc:/ApexVision/qml/assets/icons/setting_privacy_white.svg";
                                        }
                                        if (modelData.id === "security") {
                                            return root.activeCategory === "security" ?
                                                "qrc:/ApexVision/qml/assets/icons/setting_security_yellow.svg" :
                                                "qrc:/ApexVision/qml/assets/icons/setting_security_white.svg";
                                        }
                                        if (modelData.id === "accessibility") {
                                            return root.activeCategory === "accessibility" ?
                                                "qrc:/ApexVision/qml/assets/icons/setting_accessibility_yellow.svg" :
                                                "qrc:/ApexVision/qml/assets/icons/setting_accessibility_white.svg";
                                        }
                                        return root.activeCategory === modelData.id ?
                                            ("qrc:/ApexVision/qml/assets/icons/setting_" + modelData.id + "_yellow.png") :
                                            ("qrc:/ApexVision/qml/assets/icons/setting_" + modelData.id + "_white.png");
                                    }
                                    fillMode: Image.PreserveAspectFit
                                    smooth: true
                                    mipmap: true
                                }

                                // Category Label
                                Text {
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: modelData.name
                                    font.family: "Inter"
                                    font.pixelSize: 20
                                    font.weight: root.activeCategory === modelData.id ? Font.DemiBold : Font.Normal
                                    color: "#FFFFFF"
                                }
                            }

                            MouseArea {
                                id: itemMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    if (modelData.id === "sound") {
                                        root.soundCurrentScreen = "main";
                                        root.soundSlideDir = 1;
                                    } else if (modelData.id === "driver_assist") {
                                        root.daCurrentScreen = "main";
                                        root.daSlideDir = 1;
                                    } else if (modelData.id === "vehicle") {
                                        root.vehCurrentScreen = "main";
                                        root.vehSlideDir = 1;
                                    } else if (modelData.id === "system") {
                                        root.sysCurrentScreen = "main";
                                        root.sysSlideDir = 1;
                                    } else if (modelData.id === "profile") {
                                        root.profCurrentScreen = "main";
                                        root.profSlideDir = 1;
                                    } else if (modelData.id === "display") {
                                        root.dispCurrentScreen = "main";
                                        root.dispSlideDir = 1;
                                    } else if (modelData.id === "connectivity") {
                                        root.connCurrentScreen = "main";
                                        root.connSlideDir = 1;
                                    } else if (modelData.id === "voice_assistant") {
                                        root.voiceCurrentScreen = "main";
                                        root.voiceSlideDir = 1;
                                    } else if (modelData.id === "location") {
                                        root.locCurrentScreen = "main";
                                        root.locSlideDir = 1;
                                    } else if (modelData.id === "notifications") {
                                        root.notifCurrentScreen = "main";
                                        root.notifSlideDir = 1;
                                    } else if (modelData.id === "privacy") {
                                        root.privCurrentScreen = "main";
                                        root.privSlideDir = 1;
                                    } else if (modelData.id === "security") {
                                        root.secCurrentScreen = "main";
                                        root.secSlideDir = 1;
                                    } else if (modelData.id === "accessibility") {
                                        root.accCurrentScreen = "main";
                                        root.accSlideDir = 1;
                                    }
                                    root.activeCategory = modelData.id;
                                    root.activeInfoText = "";
                                }
                            }
                        }
                    }
                }
            }

            // Interactive Left Menu Dragger (Theme-colored scrollbar & draggable thumb)
            Item {
                id: leftMenuDraggerTrack
                anchors.top: leftMenuFlickable.top
                anchors.bottom: leftMenuFlickable.bottom
                anchors.right: parent.right
                anchors.rightMargin: 1
                width: 7
                visible: leftMenuFlickable.contentHeight > leftMenuFlickable.height

                // Track background line
                Rectangle {
                    anchors.fill: parent
                    radius: 3.5
                    color: Qt.rgba(255, 255, 255, 0.08)
                }

                // Draggable thumb (Frosted glass styling - translucent glass not yellow)
                Rectangle {
                    id: leftMenuDraggerThumb
                    width: parent.width
                    radius: 3.5
                    color: draggerMouse.pressed ? Qt.rgba(255, 255, 255, 0.48) :
                           (draggerMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.35) : Qt.rgba(255, 255, 255, 0.22))
                    border.color: Qt.rgba(255, 255, 255, 0.40)
                    border.width: 1

                    // Dynamic height based on visible content ratio
                    readonly property real visibleRatio: Math.min(1.0, leftMenuFlickable.height / Math.max(1, leftMenuFlickable.contentHeight))
                    height: Math.max(44, parent.height * visibleRatio)

                    // Position synced with leftMenuFlickable.contentY
                    readonly property real maxContentY: Math.max(1, leftMenuFlickable.contentHeight - leftMenuFlickable.height)
                    readonly property real maxThumbY: Math.max(1, parent.height - height)
                    y: Math.min(maxThumbY, Math.max(0, (leftMenuFlickable.contentY / maxContentY) * maxThumbY))

                    Behavior on color { ColorAnimation { duration: 120 } }

                    MouseArea {
                        id: draggerMouse
                        anchors.fill: parent
                        anchors.margins: -10
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        drag.target: leftMenuDraggerThumb
                        drag.axis: Drag.YAxis
                        drag.minimumY: 0
                        drag.maximumY: leftMenuDraggerTrack.height - leftMenuDraggerThumb.height

                        onPositionChanged: {
                            if (drag.active) {
                                var ratio = leftMenuDraggerThumb.y / Math.max(1, leftMenuDraggerTrack.height - leftMenuDraggerThumb.height);
                                leftMenuFlickable.contentY = ratio * (leftMenuFlickable.contentHeight - leftMenuFlickable.height);
                            }
                        }
                    }
                }

                // Click-to-jump on track
                MouseArea {
                    anchors.fill: parent
                    z: -1
                    cursorShape: Qt.PointingHandCursor
                    onClicked: function(mouse) {
                        var targetThumbY = mouse.y - leftMenuDraggerThumb.height / 2;
                        var maxThumbY = leftMenuDraggerTrack.height - leftMenuDraggerThumb.height;
                        var clampedY = Math.max(0, Math.min(maxThumbY, targetThumbY));
                        var ratio = clampedY / Math.max(1, maxThumbY);
                        leftMenuFlickable.contentY = ratio * (leftMenuFlickable.contentHeight - leftMenuFlickable.height);
                    }
                }
            }
        }



        // ---------------------------------------------------------------------
        // RIGHT COLUMN: Header (Standard "←" Back Button + Title) + Settings Items
        // ---------------------------------------------------------------------
        Item {
            id: rightColumn
            anchors.left: parent.left
            anchors.leftMargin: root.isFullScreenMode ? 0 : 387
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom

            Behavior on anchors.leftMargin { NumberAnimation { duration: 280; easing.type: Easing.OutCubic } }

            // =================================================================
            // DOWNWARDS TOAST NOTIFICATION (EXACT MATCH TO REFERENCE PHOTO)
            // =================================================================
            Rectangle {
                id: profToastNotification
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.bottomMargin: root.profileToastMessage !== "" ? 32 : 12
                width: Math.max(240, toastLabel.implicitWidth + 56)
                height: 52
                radius: 14
                z: 99999
                opacity: root.profileToastMessage !== "" ? 1.0 : 0.0
                scale: root.profileToastMessage !== "" ? 1.0 : 0.94
                visible: opacity > 0.001

                Behavior on anchors.bottomMargin {
                    NumberAnimation { duration: 250; easing.type: Easing.OutCubic }
                }
                Behavior on opacity {
                    NumberAnimation { duration: 200; easing.type: Easing.InOutQuad }
                }
                Behavior on scale {
                    NumberAnimation { duration: 250; easing.type: Easing.OutCubic }
                }

                // Card color with lower opacity matching card aesthetic
                color: Qt.rgba(12 / 255, 18 / 255, 30 / 255, 0.72)
                border.color: Qt.rgba(12 / 255, 18 / 255, 30 / 255, 0.72)
                border.width: 0

                // Clean white text matching card typography
                Text {
                    id: toastLabel
                    anchors.centerIn: parent
                    text: root.profileToastMessage
                    color: "#FFFFFF"
                    font.family: "Inter"
                    font.pixelSize: 16
                    font.weight: Font.Medium
                    font.letterSpacing: 0.2
                }

                // Interactive tap to dismiss
                MouseArea {
                    id: toastMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        root.profileToastMessage = "";
                        profToastTimer.stop();
                    }
                }
            }

            // Top-Right Header: Standard Back Button ("←") + Title ("Cruise Control")
            Item {
                id: rightHeaderRow
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                height: 50
                visible: !(root.activeCategory === "profile" && root.profCurrentScreen === "name") && !(root.activeCategory === "display" && root.dispCurrentScreen === "calm_screen")

                Row {
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 16

                    // Standard Back Button matching VehiclePage and other components
                    Item {
                        width: 44
                        height: 44
                        anchors.verticalCenter: parent.verticalCenter
                        visible: true

                        Image {
                            anchors.centerIn: parent
                            width: 24
                            height: 24
                            source: "qrc:/ApexVision/qml/assets/icons/nav_back_arrow.svg"
                            sourceSize: Qt.size(48, 48)
                            fillMode: Image.PreserveAspectFit
                            opacity: backMouseArea.pressed ? 0.6 : (backMouseArea.containsMouse ? 1.0 : 0.85)
                        }

                        MouseArea {
                            id: backMouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                if (root.activeCategory === "driver_assist") {
                                    if (root.daCurrentScreen === "speed_adjustment") {
                                        root.daSlideDir = -1;
                                        root.daCurrentScreen = root.daFromScreen;
                                    } else if (root.daCurrentScreen === "lane_keeping_mode" || root.daCurrentScreen === "lane_keeping_intensity") {
                                        root.daSlideDir = -1;
                                        root.daCurrentScreen = "lane_keeping_system";
                                    } else if (root.daCurrentScreen === "pre_collision_sensitivity") {
                                        root.daSlideDir = -1;
                                        root.daCurrentScreen = "pre_collision_assist";
                                    } else if (root.daCurrentScreen === "cruise_control" || root.daCurrentScreen === "speed_limit_assist" || root.daCurrentScreen === "lane_keeping_system" || root.daCurrentScreen === "pre_collision_assist") {
                                        root.daSlideDir = -1;
                                        root.daCurrentScreen = "main";
                                    } else {
                                        root.backRequested();
                                    }
                                } else if (root.activeCategory === "vehicle") {
                                    if (root.vehCurrentScreen === "autolamp_delay") {
                                        root.vehSlideDir = -1;
                                        root.vehCurrentScreen = "lighting";
                                    } else if (root.vehCurrentScreen === "remote_start_climate" || root.vehCurrentScreen === "remote_start_seats" || root.vehCurrentScreen === "remote_start_duration") {
                                        root.vehSlideDir = -1;
                                        root.vehCurrentScreen = "remote_start";
                                    } else if (root.vehCurrentScreen === "alarm_motion_sensors") {
                                        root.vehSlideDir = -1;
                                        root.vehCurrentScreen = "alarm_system";
                                    } else if (root.vehCurrentScreen === "remote_unlock") {
                                        root.vehSlideDir = -1;
                                        root.vehCurrentScreen = "locks";
                                    } else if (root.vehCurrentScreen !== "main") {
                                        root.vehSlideDir = -1;
                                        root.vehCurrentScreen = "main";
                                    } else {
                                        root.backRequested();
                                    }
                                } else if (root.activeCategory === "system") {
                                    if (root.sysCurrentScreen === "keyboard_onscreen" || root.sysCurrentScreen === "keyboard_physical") {
                                        root.sysSlideDir = -1;
                                        root.sysCurrentScreen = "keyboard_settings";
                                    } else if (root.sysCurrentScreen === "tts_engine" || root.sysCurrentScreen === "tts_language") {
                                        root.sysSlideDir = -1;
                                        root.sysCurrentScreen = "tts_settings";
                                    } else if (root.sysCurrentScreen === "languages_select" || root.sysCurrentScreen === "autofill_service" || root.sysCurrentScreen === "keyboard_settings" || root.sysCurrentScreen === "tts_settings" || root.sysCurrentScreen === "personal_dictionary") {
                                        root.sysSlideDir = -1;
                                        root.sysCurrentScreen = "languages_input";
                                    } else if (root.sysCurrentScreen === "units_temperature" || root.sysCurrentScreen === "units_measurement" || root.sysCurrentScreen === "units_pressure" || root.sysCurrentScreen === "units_weight" || root.sysCurrentScreen === "units_distance" || root.sysCurrentScreen === "units_fuel") {
                                        root.sysSlideDir = -1;
                                        root.sysCurrentScreen = "units";
                                    } else if (root.sysCurrentScreen === "time_zone" || root.sysCurrentScreen === "time_set_time" || root.sysCurrentScreen === "time_set_date") {
                                        root.sysSlideDir = -1;
                                        root.sysCurrentScreen = "time";
                                    } else if (root.sysCurrentScreen === "system_update") {
                                        if (root.returnIndex === 2) {
                                            root.backRequested();
                                        } else {
                                            root.sysSlideDir = -1;
                                            root.sysCurrentScreen = "main";
                                        }
                                    } else if (root.sysCurrentScreen === "storage" || root.sysCurrentScreen === "about" || root.sysCurrentScreen === "legal_info" || root.sysCurrentScreen === "software_licenses" || root.sysCurrentScreen === "phone_link") {
                                        root.sysSlideDir = -1;
                                        root.sysCurrentScreen = "main";
                                    } else if (root.sysCurrentScreen === "factory_reset" || root.sysCurrentScreen === "reset_hotspot" || root.sysCurrentScreen === "reset_paak" || root.sysCurrentScreen === "reset_apps" || root.sysCurrentScreen === "reset_connectivity") {
                                        root.sysSlideDir = -1;
                                        root.sysCurrentScreen = "reset_options";
                                    } else if (root.sysCurrentScreen === "languages_input" || root.sysCurrentScreen === "units" || root.sysCurrentScreen === "time" || root.sysCurrentScreen === "reset_options") {
                                        root.sysSlideDir = -1;
                                        root.sysCurrentScreen = "main";
                                    } else {
                                        root.backRequested();
                                    }
                                } else if (root.activeCategory === "profile") {
                                    if (root.profCurrentScreen === "pattern" || root.profCurrentScreen === "pin" || root.profCurrentScreen === "password") {
                                        root.profSlideDir = -1;
                                        root.profCurrentScreen = "lock_type";
                                    } else if (root.profCurrentScreen === "lock_type") {
                                        root.profSlideDir = -1;
                                        root.profCurrentScreen = "security";
                                    } else if (root.profCurrentScreen === "avatar" || root.profCurrentScreen === "security" || root.profCurrentScreen === "link_profile" || root.profCurrentScreen === "accounts" || root.profCurrentScreen === "name") {
                                        root.profSlideDir = -1;
                                        root.profCurrentScreen = "main";
                                    } else {
                                        root.backRequested();
                                    }
                                } else if (root.activeCategory === "sound") {
                                    if (root.soundCurrentScreen !== "main") {
                                        root.soundSlideDir = -1;
                                        root.soundCurrentScreen = "main";
                                    } else {
                                        root.backRequested();
                                    }
                                } else if (root.activeCategory === "display") {
                                    if (root.dispCurrentScreen !== "main") {
                                        root.dispSlideDir = -1;
                                        root.dispCurrentScreen = "main";
                                    } else {
                                        root.backRequested();
                                    }
                                } else if (root.activeCategory === "connectivity") {
                                    if (root.connCurrentScreen !== "main") {
                                        root.connSlideDir = -1;
                                        root.connCurrentScreen = "main";
                                    } else {
                                        root.backRequested();
                                    }
                                } else if (root.activeCategory === "voice_assistant") {
                                    if (root.voiceCurrentScreen !== "main") {
                                        root.voiceSlideDir = -1;
                                        root.voiceCurrentScreen = "main";
                                    } else {
                                        root.backRequested();
                                    }
                                } else if (root.activeCategory === "location") {
                                    if (root.locCurrentScreen !== "main") {
                                        root.locSlideDir = -1;
                                        root.locCurrentScreen = "main";
                                    } else {
                                        root.backRequested();
                                    }
                                } else if (root.activeCategory === "privacy") {
                                    if (root.privCurrentScreen !== "main") {
                                        root.privSlideDir = -1;
                                        root.privCurrentScreen = "main";
                                    } else {
                                        root.backRequested();
                                    }
                                } else if (root.activeCategory === "security") {
                                    if (root.secCurrentScreen === "pattern" || root.secCurrentScreen === "pin" || root.secCurrentScreen === "password") {
                                        root.secSlideDir = -1;
                                        root.secCurrentScreen = "lock_type";
                                    } else if (root.secCurrentScreen === "lock_type" || root.secCurrentScreen === "clear_credentials" || root.secCurrentScreen === "security_update") {
                                        root.secSlideDir = -1;
                                        root.secCurrentScreen = "main";
                                    } else {
                                        root.backRequested();
                                    }
                                } else if (root.activeCategory === "accessibility") {
                                    if (root.accCurrentScreen !== "main") {
                                        root.accSlideDir = -1;
                                        root.accCurrentScreen = "main";
                                    } else {
                                        root.backRequested();
                                    }
                                } else if (root.activeCategory === "notifications") {
                                    if (root.notifCurrentScreen !== "main") {
                                        root.notifSlideDir = -1;
                                        root.notifCurrentScreen = "main";
                                    } else {
                                        root.backRequested();
                                    }
                                } else if (root.activeCategory === "assist_911") {
                                    root.backRequested();
                                } else if (root.activeCategory === "bluetooth") {
                                    if (root.btPairingActive) {
                                        root.btPairingActive = false;
                                    } else {
                                        root.backRequested();
                                    }
                                } else {
                                    root.activeCategory = "driver_assist";
                                    root.daCurrentScreen = "main";
                                    root.daSlideDir = 1;
                                }
                            }
                        }
                    }

                    // Screen Title (e.g. "Driver assistance", "Vehicle", "Easy entry/exit", "Running board modes", "Windows", "Remote start setup")
                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: {
                            if (root.activeCategory === "driver_assist") {
                                if (root.daCurrentScreen === "main") return "Driver assistance";
                                if (root.daCurrentScreen === "cruise_control") return "Cruise Control";
                                if (root.daCurrentScreen === "speed_limit_assist") return "Speed Limit Assist";
                                if (root.daCurrentScreen === "lane_keeping_system") return "Lane-Keeping System";
                                if (root.daCurrentScreen === "lane_keeping_mode") return "Mode";
                                if (root.daCurrentScreen === "lane_keeping_intensity") return "Alert intensity";
                                if (root.daCurrentScreen === "speed_adjustment") return "Speed adjustment";
                                if (root.daCurrentScreen === "pre_collision_assist") return "Pre-Collision Assist";
                                if (root.daCurrentScreen === "pre_collision_sensitivity") return "Alert Sensitivity";
                                return "Driver assistance";
                            }
                            switch(root.activeCategory) {
                                case "vehicle":
                                    if (root.vehCurrentScreen === "rear_occupant_alert") return "Rear occupant alert";
                                    if (root.vehCurrentScreen === "lighting") return "Lighting";
                                    if (root.vehCurrentScreen === "autolamp_delay") return "Autolamp delay";
                                    if (root.vehCurrentScreen === "easy_entry") return "Easy entry/exit";
                                    if (root.vehCurrentScreen === "running_board_modes") return "Running board modes";
                                    if (root.vehCurrentScreen === "windows") return "Windows";
                                    if (root.vehCurrentScreen === "wipers") return "Wipers";
                                    if (root.vehCurrentScreen === "alarm_system") return "Alarm system";
                                    if (root.vehCurrentScreen === "alarm_motion_sensors") return "Motion sensors";
                                    if (root.vehCurrentScreen === "remote_start") return "Remote start setup";
                                    if (root.vehCurrentScreen === "remote_start_climate") return "Climate control";
                                    if (root.vehCurrentScreen === "remote_start_seats") return "Seats and steering wheel";
                                    if (root.vehCurrentScreen === "remote_start_duration") return "Duration";
                                    if (root.vehCurrentScreen === "power_liftgate") return "Power liftgate";
                                    if (root.vehCurrentScreen === "locks") return "Locks";
                                    if (root.vehCurrentScreen === "remote_unlock") return "Remote unlock";
                                    if (root.vehCurrentScreen === "mirrors") return "Mirrors";
                                    if (root.vehCurrentScreen === "door_keypad_code") return "Door keypad code";
                                    return "Vehicle";
                                case "sound":
                                    if (root.soundCurrentScreen === "tone") return "Tone";
                                    if (root.soundCurrentScreen === "balance_fade") return "Balance and fade";
                                    if (root.soundCurrentScreen === "speed_volume") return "Speed-compensated volume";
                                    if (root.soundCurrentScreen === "quantum_logic") return "QuantumLogic® Surround";
                                    if (root.soundCurrentScreen === "revel_experience") return "Play Revel® Experience";
                                    if (root.soundCurrentScreen === "volume_settings") return "Volume settings";
                                    if (root.soundCurrentScreen === "ringtones") return "Ringtones";
                                    if (root.soundCurrentScreen === "notification_sounds") return "Notification sounds";
                                    return (root.selectedLanguage.indexOf("Hindi") !== -1 ? "ध्वनि" : "Sound");
                                case "bluetooth": return "Bluetooth";
                                case "system":
                                    if (root.sysCurrentScreen === "languages_input") return (root.selectedLanguage.indexOf("Hindi") !== -1 ? "भाषाएं और इनपुट" : "Languages & input");
                                    if (root.sysCurrentScreen === "languages_select") return (root.selectedLanguage.indexOf("Hindi") !== -1 ? "भाषाएं" : "Languages");
                                    if (root.sysCurrentScreen === "autofill_service") return "Autofill service";
                                    if (root.sysCurrentScreen === "keyboard_settings") return "Keyboard";
                                    if (root.sysCurrentScreen === "keyboard_onscreen") return "On-screen keyboard";
                                    if (root.sysCurrentScreen === "keyboard_physical") return "Physical keyboard";
                                    if (root.sysCurrentScreen === "tts_settings") return "Text-to-speech output";
                                    if (root.sysCurrentScreen === "tts_engine") return "Preferred engine";
                                    if (root.sysCurrentScreen === "tts_language") return "Language";
                                    if (root.sysCurrentScreen === "personal_dictionary") return "Personal dictionary";
                                    if (root.sysCurrentScreen === "units") return "Units";
                                    if (root.sysCurrentScreen === "units_temperature") return "Temperature unit";
                                    if (root.sysCurrentScreen === "units_measurement") return "Measurement unit";
                                    if (root.sysCurrentScreen === "units_pressure") return "Tire pressure unit";
                                    if (root.sysCurrentScreen === "units_weight") return "Weight unit";
                                    if (root.sysCurrentScreen === "time") return "Time";
                                    if (root.sysCurrentScreen === "time_zone") return "Select time zone";
                                    if (root.sysCurrentScreen === "reset_options") return "Reset options";
                                    if (root.sysCurrentScreen === "reset_hotspot") return "Hotspot reset";
                                    if (root.sysCurrentScreen === "reset_paak") return "Phone As A Key reset";
                                    if (root.sysCurrentScreen === "reset_apps") return "App preference reset";
                                    if (root.sysCurrentScreen === "reset_connectivity") return "Connectivity reset";
                                    if (root.sysCurrentScreen === "factory_reset") return "Factory reset";
                                    if (root.sysCurrentScreen === "storage") return "Storage";
                                    if (root.sysCurrentScreen === "system_update") return "Software updates";
                                    if (root.sysCurrentScreen === "about") return "About";
                                    if (root.sysCurrentScreen === "legal_info") return "Legal information";
                                    if (root.sysCurrentScreen === "software_licenses") return "Software licenses";
                                    if (root.sysCurrentScreen === "phone_link") return "Smart Phone Link";
                                    return "System";
                                case "profile":
                                    if (root.profCurrentScreen === "avatar") return "Profile avatar";
                                    if (root.profCurrentScreen === "security") return "Security";
                                    if (root.profCurrentScreen === "lock_type") return "Choose a lock type";
                                    if (root.profCurrentScreen === "pattern") return "Set pattern lock";
                                    if (root.profCurrentScreen === "pin") return "Set PIN";
                                    if (root.profCurrentScreen === "password") return "Set password";
                                    if (root.profCurrentScreen === "link_profile") return "Link profile";
                                    if (root.profCurrentScreen === "accounts") return "Accounts";
                                    if (root.profCurrentScreen === "name") return "";
                                    return "Profile settings";
                                case "display":
                                    if (root.dispCurrentScreen === "brightness") return (root.selectedLanguage.indexOf("Hindi") !== -1 ? "ब्राइटनेस स्तर" : "Brightness level");
                                    if (root.dispCurrentScreen === "mode") return (root.selectedLanguage.indexOf("Hindi") !== -1 ? "मोड" : "Mode");
                                    if (root.dispCurrentScreen === "theme") return (root.selectedLanguage.indexOf("Hindi") !== -1 ? "थीम" : "Theme");
                                    return (root.selectedLanguage.indexOf("Hindi") !== -1 ? "डिस्प्ले" : "Display");
                                case "connectivity":
                                    if (root.connCurrentScreen === "wifi") return "Wi-Fi";
                                    return (root.selectedLanguage.indexOf("Hindi") !== -1 ? "नेटवर्क और इंटरनेट" : "Network & internet");
                                case "assist_911": return (root.selectedLanguage.indexOf("Hindi") !== -1 ? "911 सहायता" : "911 Assist");
                                case "voice_assistant":
                                    if (root.voiceCurrentScreen === "digital_assistant") return "Default digital assistant app";
                                    if (root.voiceCurrentScreen === "voice_language") return "Voice language";
                                    return (root.selectedLanguage.indexOf("Hindi") !== -1 ? "सहायक और आवाज़" : "Assistant & voice");
                                case "location":
                                    if (root.locCurrentScreen === "recent_requests") return "Recent location requests";
                                    if (root.locCurrentScreen === "app_permissions") return "App-level permissions";
                                    return (root.selectedLanguage.indexOf("Hindi") !== -1 ? "स्थान" : "Location");
                                case "notifications":
                                    if (root.notifCurrentScreen === "app_notifications") return "App notifications";
                                    return (root.selectedLanguage.indexOf("Hindi") !== -1 ? "सूचनाएं" : "Notifications");
                                case "privacy":
                                    if (root.privCurrentScreen === "microphone") return "Microphone";
                                    if (root.privCurrentScreen === "location") return "Location";
                                    if (root.privCurrentScreen === "app_permissions") return "App permissions";
                                    if (root.privCurrentScreen === "infotainment_data") return "Infotainment system data";
                                    if (root.privCurrentScreen === "ads") return "Ads";
                                    if (root.privCurrentScreen === "data_sharing") return "Data sharing with Apex";
                                    return (root.selectedLanguage.indexOf("Hindi") !== -1 ? "गोपनीयता" : "Privacy");
                                case "security":
                                    if (root.secCurrentScreen === "lock_type") return "Choose a lock type";
                                    if (root.secCurrentScreen === "pattern") return "Set pattern lock";
                                    if (root.secCurrentScreen === "pin") return "Set PIN";
                                    if (root.secCurrentScreen === "password") return "Set password";
                                    if (root.secCurrentScreen === "clear_credentials") return "Clear credentials";
                                    if (root.secCurrentScreen === "security_update") return "Security update";
                                    return (root.selectedLanguage.indexOf("Hindi") !== -1 ? "सुरक्षा" : "Security");
                                case "accessibility":
                                    if (root.accCurrentScreen === "caption_preferences") return "Caption preferences";
                                    if (root.accCurrentScreen === "display_scaling") return "Display size and text";
                                    return (root.selectedLanguage.indexOf("Hindi") !== -1 ? "सुलभता" : "Accessibility");
                                default: return "Driver assistance";
                            }
                        }
                        font.family: "Inter"
                        font.pixelSize: 30
                        font.weight: Font.DemiBold
                        color: "#FFFFFF"
                    }
                }

                // Bluetooth Master Toggle Switch (Matches photo toggle in top right)
                Rectangle {
                    id: btHeaderSwitch
                    anchors.right: parent.right
                    anchors.rightMargin: 8
                    anchors.verticalCenter: parent.verticalCenter
                    width: 74
                    height: 38
                    radius: 19
                    visible: root.activeCategory === "bluetooth"
                    color: root.bluetoothEnabled ? "#E5A97C" : "#2A3546"

                    Behavior on color { ColorAnimation { duration: 180 } }

                    // Thumb (Large circular white button on right when active)
                    Rectangle {
                        id: btSwitchThumb
                        width: 32
                        height: 32
                        radius: 16
                        color: "#FFFFFF"
                        anchors.verticalCenter: parent.verticalCenter
                        x: root.bluetoothEnabled ? (parent.width - width - 3) : 3

                        Behavior on x { NumberAnimation { duration: 180; easing.type: Easing.OutQuad } }
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            root.bluetoothEnabled = !root.bluetoothEnabled;
                        }
                    }
                }

                // 911 Assist Master Toggle & Info in Top Right (matching Photo 2)
                Row {
                    anchors.right: parent.right
                    anchors.rightMargin: 8
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 16
                    visible: root.activeCategory === "assist_911"

                    Rectangle {
                        width: 74
                        height: 38
                        radius: 19
                        color: root.assist911Enabled ? "#E08365" : "#2A3546"
                        Behavior on color { ColorAnimation { duration: 180 } }

                        Rectangle {
                            width: 32
                            height: 32
                            radius: 16
                            color: "#FFFFFF"
                            anchors.verticalCenter: parent.verticalCenter
                            x: root.assist911Enabled ? (parent.width - width - 3) : 3
                            Behavior on x { NumberAnimation { duration: 180; easing.type: Easing.OutQuad } }
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                root.assist911Enabled = !root.assist911Enabled;
                            }
                        }
                    }

                    Item {
                        width: 38
                        height: 38
                        anchors.verticalCenter: parent.verticalCenter

                        Rectangle {
                            anchors.fill: parent
                            radius: 19
                            color: a911InfoMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.16) : "transparent"

                            Text {
                                anchors.centerIn: parent
                                text: "ⓘ"
                                font.family: "Inter"
                                font.pixelSize: 22
                                font.weight: Font.Medium
                                color: Qt.rgba(255, 255, 255, 0.85)
                            }
                        }

                        MouseArea {
                            id: a911InfoMouse
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                root.activeInfoText = "In the event of a crash deploying an airbag or activating fuel shutoff, 911 Assist uses your connected phone to call 911 emergency services and provide your location.";
                            }
                        }
                    }
                }

                // Reset Sub-screens Action Buttons in Top Right
                Text {
                    id: factoryResetActionBtn
                    anchors.right: parent.right
                    anchors.rightMargin: 8
                    anchors.verticalCenter: parent.verticalCenter
                    text: {
                        if (root.sysCurrentScreen === "factory_reset") return "Erase all data";
                        if (root.sysCurrentScreen === "reset_hotspot") return "Reset hotspot";
                        if (root.sysCurrentScreen === "reset_paak") return "Reset keys";
                        if (root.sysCurrentScreen === "reset_apps") return "Reset apps";
                        if (root.sysCurrentScreen === "reset_connectivity") return "Reset settings";
                        return "";
                    }
                    color: factoryResetMouse.pressed ? "#FB923C" : (root.sysCurrentScreen === "factory_reset" || root.sysCurrentScreen === "reset_paak" ? "#EF4444" : "#FFFFFF")
                    font.family: "Inter"
                    font.pixelSize: 22
                    font.weight: Font.DemiBold
                    visible: root.activeCategory === "system" && (root.sysCurrentScreen === "factory_reset" || root.sysCurrentScreen === "reset_hotspot" || root.sysCurrentScreen === "reset_paak" || root.sysCurrentScreen === "reset_apps" || root.sysCurrentScreen === "reset_connectivity")

                    MouseArea {
                        id: factoryResetMouse
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            if (root.sysCurrentScreen === "factory_reset") root.resetModalType = "factory";
                            else if (root.sysCurrentScreen === "reset_hotspot") root.resetModalType = "hotspot";
                            else if (root.sysCurrentScreen === "reset_paak") root.resetModalType = "paak";
                            else if (root.sysCurrentScreen === "reset_apps") root.resetModalType = "apps";
                            else if (root.sysCurrentScreen === "reset_connectivity") root.resetModalType = "connectivity";
                            root.resetConfirmationOpen = true;
                            root.factoryResetConfirmationOpen = true;
                        }
                    }
                }
            }

            // Right Items Container (below header)
            Item {
                id: rightContent
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: (root.activeCategory === "display" && root.dispCurrentScreen === "calm_screen") ? parent.top : rightHeaderRow.bottom
                anchors.topMargin: (root.activeCategory === "display" && root.dispCurrentScreen === "calm_screen") ? 0 : 12
                anchors.bottom: parent.bottom

            // Info Explanation Banner (When ⓘ is clicked)
            Rectangle {
                id: infoBanner
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                height: root.activeInfoText !== "" ? 44 : 0
                visible: height > 0
                clip: true
                radius: 10
                color: Qt.rgba(30/255, 64/255, 175/255, 0.35)
                border.color: "#3B82F6"
                border.width: 1
                Behavior on height { NumberAnimation { duration: 200; easing.type: Easing.OutQuad } }

                Row {
                    anchors.fill: parent
                    anchors.leftMargin: 16
                    anchors.rightMargin: 16
                    spacing: 12

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: "ⓘ"
                        font.pixelSize: 18
                        color: "#60A5FA"
                    }

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: root.activeInfoText
                        font.family: "Inter"
                        font.pixelSize: 15
                        color: "#FFFFFF"
                    }
                }
            }

            // =================================================================
            // CATEGORY: DRIVER ASSISTANCE (3-Level Sliding Hierarchy with Transitions)
            // Level 1: Driver assistance -> Level 2: Cruise Control -> Level 3: Speed adjustment
            // =================================================================
            Item {
                id: daCategoryPanel
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: infoBanner.bottom
                anchors.topMargin: root.activeInfoText !== "" ? 12 : 0
                anchors.bottom: parent.bottom
                visible: root.activeCategory === "driver_assist"
                clip: true

                // -------------------------------------------------------------
                // LEVEL 1: Driver Assistance Main Menu (Photo 1)
                // -------------------------------------------------------------
                Item {
                    id: daLevel1View
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    x: root.daCurrentScreen === "main" ? 0 : -parent.width * 0.4
                    opacity: root.daCurrentScreen === "main" ? 1.0 : 0.0
                    enabled: root.daCurrentScreen === "main"
                    visible: opacity > 0.001

                    Behavior on x { NumberAnimation { duration: 280; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 240; easing.type: Easing.InOutQuad } }

                    Flickable {
                        anchors.fill: parent
                        contentHeight: daCol1.height + 20
                        clip: true

                        Column {
                            id: daCol1
                            width: parent.width
                            spacing: 0

                            SettingRowChevron {
                                title: "Cruise Control"
                                subtitle: root.cruiseControlType === "adaptive" ? "Adaptive" : "Normal"
                                infoText: "Maintains speed and adapts following distance based on the vehicle ahead."
                                onClicked: {
                                    root.daSlideDir = 1;
                                    root.daCurrentScreen = "cruise_control";
                                }
                                onInfoClicked: root.activeInfoText = infoText
                            }

                            SettingRowChevron {
                                title: "Speed Limit Assist"
                                infoText: "Detects posted speed limits and assists driver with speed adjustments."
                                onClicked: {
                                    root.daSlideDir = 1;
                                    root.daCurrentScreen = "speed_limit_assist";
                                }
                                onInfoClicked: root.activeInfoText = infoText
                            }

                            SettingRowChevron {
                                title: "Lane-Keeping System"
                                subtitle: root.laneKeepingMode
                                infoText: "Alerts driver with steering wheel vibration if vehicle drifts out of lane."
                                onClicked: {
                                    root.daSlideDir = 1;
                                    root.daCurrentScreen = "lane_keeping_system";
                                }
                                onInfoClicked: root.activeInfoText = infoText
                            }

                            SettingRowChevron {
                                title: "Pre-Collision Assist"
                                subtitle: root.alertSensitivity
                                infoText: "Monitors roadway ahead to detect frontal collisions and applies active emergency braking."
                                onClicked: {
                                    root.daSlideDir = 1;
                                    root.daCurrentScreen = "pre_collision_assist";
                                }
                                onInfoClicked: root.activeInfoText = infoText
                            }
                        }
                    }
                }

                // -------------------------------------------------------------
                // LEVEL 2: Cruise Control Sub-Menu (Photos 2 & 3)
                // -------------------------------------------------------------
                Item {
                    id: daCruiseView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    x: root.daCurrentScreen === "cruise_control" ? 0 :
                       (root.daCurrentScreen === "speed_adjustment" && root.daFromScreen === "cruise_control" ? -parent.width * 0.4 : parent.width)
                    opacity: root.daCurrentScreen === "cruise_control" ? 1.0 : 0.0
                    enabled: root.daCurrentScreen === "cruise_control"
                    visible: opacity > 0.001

                    Behavior on x { NumberAnimation { duration: 280; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 240; easing.type: Easing.InOutQuad } }

                    Flickable {
                        anchors.fill: parent
                        contentHeight: daCol2.height + 20
                        clip: true

                        Column {
                            id: daCol2
                            width: parent.width
                            spacing: 0

                            SettingRowRadio {
                                title: "Normal Cruise Control"
                                selected: root.cruiseControlType === "normal"
                                infoText: "Maintains a constant set speed without automatic distance gap adjustment."
                                onSelectedRequested: root.cruiseControlType = "normal"
                                onInfoClicked: root.activeInfoText = infoText
                            }

                            SettingRowRadio {
                                title: "Adaptive Cruise Control"
                                selected: root.cruiseControlType === "adaptive"
                                infoText: "Maintains speed and adapts following distance based on the vehicle ahead."
                                onSelectedRequested: root.cruiseControlType = "adaptive"
                                onInfoClicked: root.activeInfoText = infoText
                            }

                            SettingRowSwitch {
                                title: "Lane Centering"
                                subtitle: ""
                                checked: root.laneCenteringEnabled
                                infoText: "Provides continuous steering assistance to keep the vehicle centered within the lane."
                                onToggled: root.laneCenteringEnabled = !root.laneCenteringEnabled
                                onInfoClicked: root.activeInfoText = infoText
                            }

                            SettingRowSwitch {
                                title: "Predictive Speed Assist"
                                checked: root.predictiveSpeedAssistEnabled
                                infoText: "Uses navigation curve data and speed sign recognition to adapt vehicle speed ahead of curves."
                                onToggled: root.predictiveSpeedAssistEnabled = !root.predictiveSpeedAssistEnabled
                                onInfoClicked: root.activeInfoText = infoText
                            }

                            // Speed adjustment (Only visible and expands when Predictive Speed Assist is ON)
                            Item {
                                width: parent.width
                                height: root.predictiveSpeedAssistEnabled ? 64 : 0
                                opacity: root.predictiveSpeedAssistEnabled ? 1.0 : 0.0
                                visible: opacity > 0.001
                                clip: true

                                Behavior on height { NumberAnimation { duration: 220; easing.type: Easing.OutQuad } }
                                Behavior on opacity { NumberAnimation { duration: 200; easing.type: Easing.InOutQuad } }

                                SettingRowChevron {
                                    anchors.fill: parent
                                    title: "Speed adjustment"
                                    infoText: "Configure speed offset threshold over posted highway speed limits."
                                    onClicked: {
                                        root.daFromScreen = "cruise_control";
                                        root.daSlideDir = 1;
                                        root.daCurrentScreen = "speed_adjustment";
                                    }
                                    onInfoClicked: root.activeInfoText = infoText
                                }
                            }
                        }
                    }
                }

                // -------------------------------------------------------------
                // LEVEL 2B: Speed Limit Assist Sub-Menu (User Photos 1 & 2)
                // -------------------------------------------------------------
                Item {
                    id: daSpeedLimitView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    x: root.daCurrentScreen === "speed_limit_assist" ? 0 :
                       (root.daCurrentScreen === "speed_adjustment" && root.daFromScreen === "speed_limit_assist" ? -parent.width * 0.4 : parent.width)
                    opacity: root.daCurrentScreen === "speed_limit_assist" ? 1.0 : 0.0
                    enabled: root.daCurrentScreen === "speed_limit_assist"
                    visible: opacity > 0.001

                    Behavior on x { NumberAnimation { duration: 280; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 240; easing.type: Easing.InOutQuad } }

                    Flickable {
                        anchors.fill: parent
                        contentHeight: daColSL.height + 20
                        clip: true

                        Column {
                            id: daColSL
                            width: parent.width
                            spacing: 0

                            // 1. Speed warning (Toggle Switch)
                            SettingRowSwitch {
                                title: "Speed warning"
                                checked: root.speedWarningEnabled
                                infoText: "Provides warning chimes and visual notifications when the vehicle exceeds the posted speed limit."
                                onToggled: root.speedWarningEnabled = !root.speedWarningEnabled
                                onInfoClicked: root.activeInfoText = infoText
                            }

                            // 2. Speed adjustment (Only visible and expands when Speed warning is ON)
                            Item {
                                width: parent.width
                                height: root.speedWarningEnabled ? 64 : 0
                                opacity: root.speedWarningEnabled ? 1.0 : 0.0
                                visible: opacity > 0.001
                                clip: true

                                Behavior on height { NumberAnimation { duration: 220; easing.type: Easing.OutQuad } }
                                Behavior on opacity { NumberAnimation { duration: 200; easing.type: Easing.InOutQuad } }

                                SettingRowChevron {
                                    anchors.fill: parent
                                    title: "Speed adjustment"
                                    infoText: "Configure speed tolerance threshold over posted speed limit."
                                    onClicked: {
                                        root.daFromScreen = "speed_limit_assist";
                                        root.daSlideDir = 1;
                                        root.daCurrentScreen = "speed_adjustment";
                                    }
                                    onInfoClicked: root.activeInfoText = infoText
                                }
                            }
                        }
                    }
                }

                // -------------------------------------------------------------
                // LEVEL 3: Speed Adjustment Stepper View (User Photo 3)
                // -------------------------------------------------------------
                Item {
                    id: daSpeedAdjustView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    x: root.daCurrentScreen === "speed_adjustment" ? 0 : parent.width
                    opacity: root.daCurrentScreen === "speed_adjustment" ? 1.0 : 0.0
                    enabled: root.daCurrentScreen === "speed_adjustment"
                    visible: opacity > 0.001

                    Behavior on x { NumberAnimation { duration: 280; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 240; easing.type: Easing.InOutQuad } }

                    Column {
                        anchors.centerIn: parent
                        anchors.verticalCenterOffset: -20
                        spacing: 20
                        width: parent.width

                        // Stepper Row: Minus, Speed Value, Plus
                        Row {
                            anchors.horizontalCenter: parent.horizontalCenter
                            spacing: 36

                            // Minus Button
                            Rectangle {
                                anchors.verticalCenter: parent.verticalCenter
                                width: 62
                                height: 62
                                radius: 31
                                color: minusMouse.pressed ? Qt.rgba(22/255, 50/255, 92/255, 0.95) :
                                       (minusMouse.containsMouse ? Qt.rgba(28/255, 62/255, 115/255, 0.85) : Qt.rgba(22/255, 50/255, 92/255, 0.70))
                                border.color: Qt.rgba(59/255, 130/255, 246/255, 0.40)
                                border.width: 1.5

                                Text {
                                    anchors.centerIn: parent
                                    text: "–"
                                    font.family: "Inter"
                                    font.pixelSize: 32
                                    font.weight: Font.Medium
                                    color: root.speedAdjustment > 0 ? "#FFFFFF" : "#64748B"
                                }

                                MouseArea {
                                    id: minusMouse
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: root.speedAdjustment > 0 ? Qt.PointingHandCursor : Qt.ArrowCursor
                                    onClicked: {
                                        if (root.speedAdjustment > 0) root.speedAdjustment--;
                                    }
                                }
                            }

                            // Number Value
                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                text: root.speedAdjustment.toString()
                                font.family: "Inter"
                                font.pixelSize: 76
                                font.weight: Font.Bold
                                color: "#FFFFFF"
                            }

                            // Plus Button
                            Rectangle {
                                anchors.verticalCenter: parent.verticalCenter
                                width: 62
                                height: 62
                                radius: 31
                                color: plusMouse.pressed ? Qt.rgba(22/255, 50/255, 92/255, 0.95) :
                                       (plusMouse.containsMouse ? Qt.rgba(28/255, 62/255, 115/255, 0.85) : Qt.rgba(22/255, 50/255, 92/255, 0.70))
                                border.color: Qt.rgba(59/255, 130/255, 246/255, 0.40)
                                border.width: 1.5

                                Text {
                                    anchors.centerIn: parent
                                    text: "+"
                                    font.family: "Inter"
                                    font.pixelSize: 32
                                    font.weight: Font.Medium
                                    color: root.speedAdjustment < 16 ? "#FFFFFF" : "#64748B"
                                }

                                MouseArea {
                                    id: plusMouse
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: root.speedAdjustment < 16 ? Qt.PointingHandCursor : Qt.ArrowCursor
                                    onClicked: {
                                        if (root.speedAdjustment < 16) root.speedAdjustment++;
                                    }
                                }
                            }
                        }

                        // Unit text (km/h)
                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "km/h"
                            font.family: "Inter"
                            font.pixelSize: 28
                            font.weight: Font.DemiBold
                            color: "#8FA3BF"
                        }

                        Item { width: 1; height: 6 }

                        // Subtext explanation matching photo
                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: root.daFromScreen === "speed_limit_assist" ?
                                  "Allows you to set a maximum speed up to 5 MPH (10 km/h)\nover the posted speed limit" :
                                  "Allows you to set a maximum speed up to 10 MPH (16 km/h)\nover the posted speed limit"
                            font.family: "Inter"
                            font.pixelSize: 16
                            font.weight: Font.Normal
                            color: "#8FA3BF"
                            horizontalAlignment: Text.AlignHCenter
                            lineHeight: 1.35
                        }
                    }
                }

                // -------------------------------------------------------------
                // LEVEL 2C: Lane-Keeping System Sub-Menu (User Photo 1)
                // -------------------------------------------------------------
                Item {
                    id: daLaneKeepingView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    x: root.daCurrentScreen === "lane_keeping_system" ? 0 :
                       ((root.daCurrentScreen === "lane_keeping_mode" || root.daCurrentScreen === "lane_keeping_intensity") ? -parent.width * 0.4 : parent.width)
                    opacity: root.daCurrentScreen === "lane_keeping_system" ? 1.0 : 0.0
                    enabled: root.daCurrentScreen === "lane_keeping_system"
                    visible: opacity > 0.001

                    Behavior on x { NumberAnimation { duration: 280; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 240; easing.type: Easing.InOutQuad } }

                    Flickable {
                        anchors.fill: parent
                        contentHeight: daColLK.height + 20
                        clip: true

                        Column {
                            id: daColLK
                            width: parent.width
                            spacing: 0

                            // 1. Mode (Chevron Row with Subtitle "Alert", etc.)
                            SettingRowChevron {
                                title: "Mode"
                                subtitle: root.laneKeepingMode
                                infoText: "Select between lane departure vibration Alert, active steering Aid, or both."
                                onClicked: {
                                    root.daSlideDir = 1;
                                    root.daCurrentScreen = "lane_keeping_mode";
                                }
                                onInfoClicked: root.activeInfoText = infoText
                            }

                            // 2. Alert intensity (Chevron Row with Subtitle "Normal", etc.)
                            SettingRowChevron {
                                title: "Alert intensity"
                                subtitle: root.laneAlertIntensity
                                infoText: "Adjust the vibration intensity on the steering wheel during lane departure alerts."
                                onClicked: {
                                    root.daSlideDir = 1;
                                    root.daCurrentScreen = "lane_keeping_intensity";
                                }
                                onInfoClicked: root.activeInfoText = infoText
                            }
                        }
                    }
                }

                // -------------------------------------------------------------
                // LEVEL 3B: Lane-Keeping Mode Selection (User Photo 2)
                // -------------------------------------------------------------
                Item {
                    id: daLaneModeView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    x: root.daCurrentScreen === "lane_keeping_mode" ? 0 : parent.width
                    opacity: root.daCurrentScreen === "lane_keeping_mode" ? 1.0 : 0.0
                    enabled: root.daCurrentScreen === "lane_keeping_mode"
                    visible: opacity > 0.001

                    Behavior on x { NumberAnimation { duration: 280; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 240; easing.type: Easing.InOutQuad } }

                    Row {
                        anchors.fill: parent
                        anchors.topMargin: 20
                        spacing: 56

                        // Left column: Radio selections (Alert, Aid, Alert + aid)
                        Column {
                            width: 520
                            spacing: 0

                            Repeater {
                                model: ["Alert", "Aid", "Alert + aid"]

                                Item {
                                    width: parent.width
                                    height: 86

                                    Rectangle {
                                        anchors.fill: parent
                                        color: rowHover.containsMouse ? Qt.rgba(255, 255, 255, 0.06) : "transparent"
                                        radius: 12
                                    }

                                    Text {
                                        anchors.left: parent.left
                                        anchors.leftMargin: 12
                                        anchors.verticalCenter: parent.verticalCenter
                                        text: modelData
                                        font.family: "Inter"
                                        font.pixelSize: 24
                                        font.weight: Font.Medium
                                        color: root.laneKeepingMode === modelData ? "#FFFFFF" : "#CBD5E1"
                                    }

                                    // Circular Radio Indicator (Matches Photo 2)
                                    Rectangle {
                                        anchors.right: parent.right
                                        anchors.rightMargin: 16
                                        anchors.verticalCenter: parent.verticalCenter
                                        width: 34
                                        height: 34
                                        radius: 17
                                        color: "transparent"
                                        border.color: root.laneKeepingMode === modelData ? "#E5A97C" : "#5A6B82"
                                        border.width: root.laneKeepingMode === modelData ? 3.5 : 2.2

                                        Rectangle {
                                            anchors.centerIn: parent
                                            width: 14
                                            height: 14
                                            radius: 7
                                            color: "#E5A97C"
                                            visible: root.laneKeepingMode === modelData
                                        }
                                    }

                                    // Thin divider line across full row
                                    Rectangle {
                                        anchors.left: parent.left
                                        anchors.right: parent.right
                                        anchors.bottom: parent.bottom
                                        height: 1
                                        color: Qt.rgba(255, 255, 255, 0.10)
                                    }

                                    MouseArea {
                                        id: rowHover
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: root.laneKeepingMode = modelData
                                    }
                                }
                            }
                        }

                        // Right column: Animated Dynamic Lane Keeping Visualizer
                        Item {
                            width: Math.min(840, parent.width - 520 - 56)
                            height: 480
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.verticalCenterOffset: -40

                            Rectangle {
                                anchors.fill: parent
                                radius: 20
                                color: "#070C15"
                                border.color: Qt.rgba(255, 255, 255, 0.16)
                                border.width: 1.5
                                clip: true

                                LaneKeepingVisualizer {
                                    anchors.fill: parent
                                    mode: root.laneKeepingMode
                                    intensity: root.laneAlertIntensity
                                    running: root.daCurrentScreen === "lane_keeping_mode" && root.isFullScreenMode
                                }
                            }
                        }
                    }
                }

                // -------------------------------------------------------------
                // LEVEL 3C: Lane-Keeping Alert Intensity Selection (Pure Menu)
                // -------------------------------------------------------------
                Item {
                    id: daLaneIntensityView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    x: root.daCurrentScreen === "lane_keeping_intensity" ? 0 : parent.width
                    opacity: root.daCurrentScreen === "lane_keeping_intensity" ? 1.0 : 0.0
                    enabled: root.daCurrentScreen === "lane_keeping_intensity"
                    visible: opacity > 0.001

                    Behavior on x { NumberAnimation { duration: 280; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 240; easing.type: Easing.InOutQuad } }

                    Flickable {
                        anchors.fill: parent
                        contentHeight: daIntensityCol.height + 40
                        clip: true

                        Column {
                            id: daIntensityCol
                            anchors.top: parent.top
                            anchors.topMargin: 10
                            anchors.left: parent.left
                            anchors.right: parent.right
                            spacing: 0

                            Repeater {
                                model: ["Low", "Normal", "High"]

                                Item {
                                    width: parent.width
                                    height: 86

                                    Rectangle {
                                        anchors.fill: parent
                                        color: intRowHover.containsMouse ? Qt.rgba(255, 255, 255, 0.06) : "transparent"
                                        radius: 12
                                    }

                                    Text {
                                        anchors.left: parent.left
                                        anchors.leftMargin: 12
                                        anchors.verticalCenter: parent.verticalCenter
                                        text: modelData
                                        font.family: "Inter"
                                        font.pixelSize: 24
                                        font.weight: Font.Medium
                                        color: root.laneAlertIntensity === modelData ? "#FFFFFF" : "#CBD5E1"
                                    }

                                    // Circular Radio Indicator
                                    Rectangle {
                                        anchors.right: parent.right
                                        anchors.rightMargin: 16
                                        anchors.verticalCenter: parent.verticalCenter
                                        width: 34
                                        height: 34
                                        radius: 17
                                        color: "transparent"
                                        border.color: root.laneAlertIntensity === modelData ? "#E5A97C" : "#5A6B82"
                                        border.width: root.laneAlertIntensity === modelData ? 3.5 : 2.2

                                        Rectangle {
                                            anchors.centerIn: parent
                                            width: 14
                                            height: 14
                                            radius: 7
                                            color: "#E5A97C"
                                            visible: root.laneAlertIntensity === modelData
                                        }
                                    }

                                    // Thin divider line across full row
                                    Rectangle {
                                        anchors.left: parent.left
                                        anchors.right: parent.right
                                        anchors.bottom: parent.bottom
                                        height: 1
                                        color: Qt.rgba(255, 255, 255, 0.10)
                                    }

                                    MouseArea {
                                        id: intRowHover
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: root.laneAlertIntensity = modelData
                                    }
                                }
                            }
                        }
                    }
                }

                // -------------------------------------------------------------
                // LEVEL 2D: Pre-Collision Assist Sub-Menu (Matches User Photo)
                // -------------------------------------------------------------
                Item {
                    id: daPreCollisionView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    x: root.daCurrentScreen === "pre_collision_assist" ? 0 :
                       (root.daCurrentScreen === "pre_collision_sensitivity" ? -parent.width * 0.4 : parent.width)
                    opacity: root.daCurrentScreen === "pre_collision_assist" ? 1.0 : 0.0
                    enabled: root.daCurrentScreen === "pre_collision_assist"
                    visible: opacity > 0.001

                    Behavior on x { NumberAnimation { duration: 280; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 240; easing.type: Easing.InOutQuad } }

                    Flickable {
                        anchors.fill: parent
                        contentHeight: daPreColCol.height + 40
                        clip: true

                        Column {
                            id: daPreColCol
                            width: parent.width
                            spacing: 0

                            // 1. Automatic Emergency Braking (Toggle Switch + Info)
                            SettingRowSwitch {
                                title: "Automatic Emergency Braking"
                                checked: root.autoEmergencyBraking
                                infoText: "Applies vehicle brakes automatically if a collision risk is detected."
                                onToggled: root.autoEmergencyBraking = !root.autoEmergencyBraking
                                onInfoClicked: root.activeInfoText = infoText
                            }

                            // 2. Evasive Steering Assist (Toggle Switch + Info)
                            SettingRowSwitch {
                                title: "Evasive Steering Assist"
                                checked: root.evasiveSteeringAssist
                                infoText: "Provides steering assistance to help avoid collisions when braking alone is insufficient."
                                onToggled: root.evasiveSteeringAssist = !root.evasiveSteeringAssist
                                onInfoClicked: root.activeInfoText = infoText
                            }

                            // 3. Alert Sensitivity (Chevron Row + Subtitle + Info)
                            SettingRowChevron {
                                title: "Alert Sensitivity"
                                subtitle: root.alertSensitivity
                                infoText: "Adjust the distance and timing threshold for pre-collision warnings."
                                onClicked: {
                                    root.daSlideDir = 1;
                                    root.daCurrentScreen = "pre_collision_sensitivity";
                                }
                                onInfoClicked: root.activeInfoText = infoText
                            }
                        }
                    }
                }

                // -------------------------------------------------------------
                // LEVEL 3D: Pre-Collision Alert Sensitivity Selection (Pure Menu)
                // -------------------------------------------------------------
                Item {
                    id: daPreCollisionSensitivityView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    x: root.daCurrentScreen === "pre_collision_sensitivity" ? 0 : parent.width
                    opacity: root.daCurrentScreen === "pre_collision_sensitivity" ? 1.0 : 0.0
                    enabled: root.daCurrentScreen === "pre_collision_sensitivity"
                    visible: opacity > 0.001

                    Behavior on x { NumberAnimation { duration: 280; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 240; easing.type: Easing.InOutQuad } }

                    Flickable {
                        anchors.fill: parent
                        contentHeight: daPreColSensCol.height + 40
                        clip: true

                        Column {
                            id: daPreColSensCol
                            anchors.top: parent.top
                            anchors.topMargin: 10
                            anchors.left: parent.left
                            anchors.right: parent.right
                            spacing: 0

                            Repeater {
                                model: ["Low", "Normal", "High"]

                                Item {
                                    width: parent.width
                                    height: 86

                                    Rectangle {
                                        anchors.fill: parent
                                        color: sensRowHover.containsMouse ? Qt.rgba(255, 255, 255, 0.06) : "transparent"
                                        radius: 12
                                    }

                                    Text {
                                        anchors.left: parent.left
                                        anchors.leftMargin: 12
                                        anchors.verticalCenter: parent.verticalCenter
                                        text: modelData
                                        font.family: "Inter"
                                        font.pixelSize: 24
                                        font.weight: Font.Medium
                                        color: root.alertSensitivity === modelData ? "#FFFFFF" : "#CBD5E1"
                                    }

                                    // Circular Radio Indicator
                                    Rectangle {
                                        anchors.right: parent.right
                                        anchors.rightMargin: 16
                                        anchors.verticalCenter: parent.verticalCenter
                                        width: 34
                                        height: 34
                                        radius: 17
                                        color: "transparent"
                                        border.color: root.alertSensitivity === modelData ? "#E5A97C" : "#5A6B82"
                                        border.width: root.alertSensitivity === modelData ? 3.5 : 2.2

                                        Rectangle {
                                            anchors.centerIn: parent
                                            width: 14
                                            height: 14
                                            radius: 7
                                            color: "#E5A97C"
                                            visible: root.alertSensitivity === modelData
                                        }
                                    }

                                    // Thin divider line across full row
                                    Rectangle {
                                        anchors.left: parent.left
                                        anchors.right: parent.right
                                        anchors.bottom: parent.bottom
                                        height: 1
                                        color: Qt.rgba(255, 255, 255, 0.10)
                                    }

                                    MouseArea {
                                        id: sensRowHover
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: root.alertSensitivity = modelData
                                    }
                                }
                            }
                        }
                    }
                }
            }

            // =================================================================
            // CATEGORY: VEHICLE (Matching User Reference Photos)
            // =================================================================
            Item {
                id: vehicleCategoryContainer
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: infoBanner.bottom
                anchors.topMargin: root.activeInfoText !== "" ? 12 : 0
                anchors.bottom: parent.bottom
                visible: root.activeCategory === "vehicle"
                clip: true

                // -------------------------------------------------------------
                // LEVEL 1: Vehicle Main Menu (Image copy 7)
                // -------------------------------------------------------------
                Item {
                    id: vehMainView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    x: root.vehCurrentScreen === "main" ? 0 : -parent.width * 0.4
                    opacity: root.vehCurrentScreen === "main" ? 1.0 : 0.0
                    enabled: root.vehCurrentScreen === "main"
                    visible: opacity > 0.001 || x > -parent.width * 0.4

                    Behavior on x { NumberAnimation { duration: 320; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 280; easing.type: Easing.InOutQuad } }

                    // Dynamic glass scroll dragger thumb (only visible where scrolling occurs)
                    Rectangle {
                        id: vehMainDragger
                        anchors.left: parent.left
                        anchors.leftMargin: 2
                        y: vehMainFlickable.visibleArea.yPosition * vehMainFlickable.height
                        height: Math.max(36, vehMainFlickable.visibleArea.heightRatio * vehMainFlickable.height)
                        width: 3.5
                        radius: 1.75
                        color: Qt.rgba(255, 255, 255, 0.28)
                        visible: vehMainFlickable.visibleArea.heightRatio < 0.99
                        z: 10
                    }

                    Flickable {
                        id: vehMainFlickable
                        anchors.fill: parent
                        anchors.leftMargin: vehMainDragger.visible ? 16 : 0
                        contentHeight: vehicleCol.height + 40
                        clip: true
                        boundsBehavior: Flickable.DragAndOvershootBounds
                        flickableDirection: Flickable.VerticalFlick

                        Column {
                            id: vehicleCol
                            width: parent.width
                            spacing: 0

                            // Item 1: 30min max idle (Switch + Info)
                            SettingRowSwitch {
                                title: "30min max idle"
                                checked: root.maxIdleEnabled
                                infoText: "Engine automatically shuts down after 30 minutes of idling to conserve fuel."
                                onToggled: root.maxIdleEnabled = !root.maxIdleEnabled
                                onInfoClicked: root.activeInfoText = infoText
                            }

                            // Item 2: Rear occupant alert (Chevron + Subtitle + Info) -> Photo 1
                            SettingRowChevron {
                                title: "Rear occupant alert"
                                subtitle: root.rearOccupantMode
                                infoText: "Reminds you to check the rear seats before exiting the vehicle."
                                onClicked: {
                                    root.vehSlideDir = 1;
                                    root.vehCurrentScreen = "rear_occupant_alert";
                                }
                                onInfoClicked: root.activeInfoText = infoText
                            }

                            // Item 3: Lighting (Chevron + Subtitle + Info) -> Photo 2
                            SettingRowChevron {
                                title: "Lighting"
                                subtitle: root.autolampDelay
                                infoText: "Configure welcome lighting, ambient cabin colors, and exterior headlight delay."
                                onClicked: {
                                    root.vehSlideDir = 1;
                                    root.vehCurrentScreen = "lighting";
                                }
                                onInfoClicked: root.activeInfoText = infoText
                            }

                            // Item 4: Key detection alert (Switch + Info) -> Photo 1
                            SettingRowSwitch {
                                title: "Key detection alert"
                                checked: root.keyDetectionEnabled
                                infoText: "Chimes if the smart key fob is removed from the vehicle while running."
                                onToggled: root.keyDetectionEnabled = !root.keyDetectionEnabled
                                onInfoClicked: root.activeInfoText = infoText
                            }

                            // Item 5: Easy entry/exit (Chevron + Info) -> Photo 1 & 2
                            SettingRowChevron {
                                title: "Easy entry/exit"
                                infoText: "Automatically slides the driver seat back and tilts steering wheel for convenient entry."
                                onClicked: {
                                    root.vehSlideDir = 1;
                                    root.vehCurrentScreen = "easy_entry";
                                }
                                onInfoClicked: root.activeInfoText = infoText
                            }

                            // Item 6: Power running boards (Chevron + Subtitle + Info) -> Photo 1 & 3
                            SettingRowChevron {
                                title: "Power running boards"
                                subtitle: root.runningBoardMode
                                infoText: "Deploy or stow exterior running boards automatically upon door opening."
                                onClicked: {
                                    root.vehSlideDir = 1;
                                    root.vehCurrentScreen = "running_board_modes";
                                }
                                onInfoClicked: root.activeInfoText = infoText
                            }

                            // Item 7: Remote start setup (Chevron + Info) -> Photo 1 & 5
                            SettingRowChevron {
                                title: "Remote start setup"
                                infoText: "Configure cabin climate, seats, and run duration for remote ignition."
                                onClicked: {
                                    root.vehSlideDir = 1;
                                    root.vehCurrentScreen = "remote_start";
                                }
                                onInfoClicked: root.activeInfoText = infoText
                            }

                            // Item 8: Windows (Chevron + Info) -> Photo 4
                            SettingRowChevron {
                                title: "Windows"
                                infoText: "Configure convenience opening and closing features for power windows."
                                onClicked: {
                                    root.vehSlideDir = 1;
                                    root.vehCurrentScreen = "windows";
                                }
                                onInfoClicked: root.activeInfoText = infoText
                            }

                            // Item 9: Wipers (Chevron + Info)
                            SettingRowChevron {
                                title: "Wipers"
                                infoText: "Configure automatic rain sensing, courtesy wipe, and rear wiper reverse activation."
                                onClicked: {
                                    root.vehSlideDir = 1;
                                    root.vehCurrentScreen = "wipers";
                                }
                                onInfoClicked: root.activeInfoText = infoText
                            }

                            // Item 10: Alarm system (Chevron + Info)
                            SettingRowChevron {
                                title: "Alarm system"
                                infoText: "Perimeter anti-theft sensors and interior motion intrusion monitoring."
                                onClicked: {
                                    root.vehSlideDir = 1;
                                    root.vehCurrentScreen = "alarm_system";
                                }
                                onInfoClicked: root.activeInfoText = infoText
                            }

                            // Item 11: Power liftgate (Chevron + Subtitle)
                            SettingRowChevron {
                                title: "Power liftgate"
                                subtitle: root.powerLiftgateMode
                                onClicked: {
                                    root.vehSlideDir = 1;
                                    root.vehCurrentScreen = "power_liftgate";
                                }
                            }

                            // Item 12: Locks (Chevron)
                            SettingRowChevron {
                                title: "Locks"
                                onClicked: {
                                    root.vehSlideDir = 1;
                                    root.vehCurrentScreen = "locks";
                                }
                            }

                            // Item 13: Mirrors (Chevron)
                            SettingRowChevron {
                                title: "Mirrors"
                                onClicked: {
                                    root.vehSlideDir = 1;
                                    root.vehCurrentScreen = "mirrors";
                                }
                            }

                            // Item 14: Door keypad code (Chevron)
                            SettingRowChevron {
                                title: "Door keypad code"
                                onClicked: {
                                    root.vehSlideDir = 1;
                                    root.vehCurrentScreen = "door_keypad_code";
                                }
                            }

                            // Item 15: Backup start passcode (Disabled)
                            SettingRowChevron {
                                title: "Backup start passcode"
                                isEnabled: false
                                showChevron: false
                            }
                        }
                    }
                }

                // -------------------------------------------------------------
                // LEVEL 2A: Rear Occupant Alert Sub-Menu (Matches Photo 1)
                // -------------------------------------------------------------
                Item {
                    id: vehRearOccupantView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    x: root.vehCurrentScreen === "rear_occupant_alert" ? 0 : parent.width
                    opacity: root.vehCurrentScreen === "rear_occupant_alert" ? 1.0 : 0.0
                    enabled: root.vehCurrentScreen === "rear_occupant_alert"
                    visible: opacity > 0.001 || x < parent.width

                    Behavior on x { NumberAnimation { duration: 320; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 280; easing.type: Easing.InOutQuad } }

                    Flickable {
                        anchors.fill: parent
                        contentHeight: roaCol.height + 40
                        clip: true

                        Column {
                            id: roaCol
                            width: parent.width
                            spacing: 0

                            // 1. Alert and horn
                            SettingRowRadio {
                                title: "Alert and horn"
                                selected: root.rearOccupantMode === "Alert and horn"
                                infoText: "Sounds horn chimes and displays notification when rear seats may be occupied."
                                onSelectedRequested: root.rearOccupantMode = "Alert and horn"
                                onInfoClicked: root.activeInfoText = infoText
                            }

                            // 2. Alert only
                            SettingRowRadio {
                                title: "Alert only"
                                selected: root.rearOccupantMode === "Alert only"
                                infoText: "Displays visual cluster reminder without sounding the vehicle horn."
                                onSelectedRequested: root.rearOccupantMode = "Alert only"
                                onInfoClicked: root.activeInfoText = infoText
                            }

                            // 3. Off
                            SettingRowRadio {
                                title: "Off"
                                selected: root.rearOccupantMode === "Off"
                                infoText: "Disables rear occupant alert detection completely."
                                onSelectedRequested: root.rearOccupantMode = "Off"
                                onInfoClicked: root.activeInfoText = infoText
                            }

                            // 4. Child seat installed (Chevron + Info)
                            SettingRowChevron {
                                title: "Child seat installed"
                                infoText: "Configures ultrasonic sensors to accommodate installed child safety seats."
                                onClicked: root.activeInfoText = infoText
                                onInfoClicked: root.activeInfoText = infoText
                            }
                        }
                    }
                }

                // -------------------------------------------------------------
                // LEVEL 2B: Lighting Sub-Menu (Matches Photo 2)
                // -------------------------------------------------------------
                Item {
                    id: vehLightingView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    x: root.vehCurrentScreen === "lighting" ? 0 :
                       (root.vehCurrentScreen === "autolamp_delay" ? -parent.width * 0.4 : parent.width)
                    opacity: root.vehCurrentScreen === "lighting" ? 1.0 : 0.0
                    enabled: root.vehCurrentScreen === "lighting"
                    visible: opacity > 0.001 || (x > -parent.width * 0.4 && x < parent.width)

                    Behavior on x { NumberAnimation { duration: 280; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 240; easing.type: Easing.InOutQuad } }

                    Flickable {
                        anchors.fill: parent
                        contentHeight: lightCol.height + 40
                        clip: true

                        Column {
                            id: lightCol
                            width: parent.width
                            spacing: 0

                            // 1. Auto high beams (Switch + Info)
                            SettingRowSwitch {
                                title: "Auto high beams"
                                checked: root.autoHighBeamsEnabled
                                infoText: "Automatically switches between high and low beams based on oncoming traffic and lighting conditions."
                                onToggled: root.autoHighBeamsEnabled = !root.autoHighBeamsEnabled
                                onInfoClicked: root.activeInfoText = infoText
                            }

                            // 2. Autolamp delay (Chevron + Subtitle + Info)
                            SettingRowChevron {
                                title: "Autolamp delay"
                                subtitle: root.autolampDelay
                                infoText: "Keeps exterior headlamps illuminated for a set time after exiting the vehicle."
                                onClicked: {
                                    root.vehSlideDir = 1;
                                    root.vehCurrentScreen = "autolamp_delay";
                                }
                                onInfoClicked: root.activeInfoText = infoText
                            }
                        }
                    }
                }

                // -------------------------------------------------------------
                // LEVEL 3B: Autolamp Delay Sub-Menu (Matches Photo 3 with build/image copy.png)
                // -------------------------------------------------------------
                Item {
                    id: vehAutolampDelayView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    x: root.vehCurrentScreen === "autolamp_delay" ? 0 : parent.width
                    opacity: root.vehCurrentScreen === "autolamp_delay" ? 1.0 : 0.0
                    enabled: root.vehCurrentScreen === "autolamp_delay"
                    visible: opacity > 0.001 || x < parent.width

                    Behavior on x { NumberAnimation { duration: 280; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 240; easing.type: Easing.InOutQuad } }

                    Row {
                        anchors.fill: parent
                        anchors.topMargin: 20
                        spacing: 56

                        // Left column: Radio Options (Off, 10s, 20s, 120s matching user photo)
                        Column {
                            width: 520
                            spacing: 0

                            Repeater {
                                model: ["Off", "10 seconds", "20 seconds", "120 seconds"]

                                Item {
                                    width: parent.width
                                    height: 82

                                    Rectangle {
                                        anchors.fill: parent
                                        color: lampOptHover.containsMouse ? Qt.rgba(255, 255, 255, 0.06) : "transparent"
                                        radius: 12
                                    }

                                    Text {
                                        anchors.left: parent.left
                                        anchors.leftMargin: 12
                                        anchors.verticalCenter: parent.verticalCenter
                                        text: modelData
                                        font.family: "Inter"
                                        font.pixelSize: 24
                                        font.weight: root.autolampDelay === modelData ? Font.Medium : Font.Normal
                                        color: root.autolampDelay === modelData ? "#FFFFFF" : "#CBD5E1"
                                    }

                                    // Radio indicator circle (matching photo exactly)
                                    Rectangle {
                                        anchors.right: parent.right
                                        anchors.rightMargin: 16
                                        anchors.verticalCenter: parent.verticalCenter
                                        width: 34
                                        height: 34
                                        radius: 17
                                        color: "transparent"
                                        border.color: root.autolampDelay === modelData ? "#E5A97C" : "#5A6B82"
                                        border.width: root.autolampDelay === modelData ? 3.5 : 2.2
                                        Behavior on border.color { ColorAnimation { duration: 150 } }

                                        Rectangle {
                                            anchors.centerIn: parent
                                            width: 14
                                            height: 14
                                            radius: 7
                                            color: "#E5A97C"
                                            visible: root.autolampDelay === modelData
                                        }
                                    }

                                    // Row divider line
                                    Rectangle {
                                        anchors.left: parent.left
                                        anchors.right: parent.right
                                        anchors.bottom: parent.bottom
                                        height: 1
                                        color: Qt.rgba(255, 255, 255, 0.10)
                                    }

                                    MouseArea {
                                        id: lampOptHover
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: root.autolampDelay = modelData
                                    }
                                }
                            }
                        }

                        // Right column: Autolamp Delay Visualizer Card (Slight rounded rectangle image)
                        Item {
                            id: autolampCardContainer
                            width: Math.min(840, parent.width - 520 - 56)
                            height: 480
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.verticalCenterOffset: -40

                            // Masked Image with slight rounded rectangle corners
                            Item {
                                anchors.fill: parent

                                Image {
                                    id: autolampImg
                                    anchors.fill: parent
                                    source: "qrc:/ApexVision/qml/assets/autolamp_delay_preview.png"
                                    fillMode: Image.PreserveAspectCrop
                                    smooth: true
                                    mipmap: true
                                    visible: false
                                }

                                Rectangle {
                                    id: autolampMask
                                    anchors.fill: parent
                                    radius: 14
                                    color: "black"
                                    visible: false
                                    layer.enabled: true
                                }

                                MultiEffect {
                                    anchors.fill: parent
                                    source: autolampImg
                                    maskEnabled: true
                                    maskSource: autolampMask
                                }
                            }

                            // Sleek subtle border around the slight rounded rectangle
                            Rectangle {
                                anchors.fill: parent
                                radius: 14
                                color: "transparent"
                                border.color: Qt.rgba(255, 255, 255, 0.16)
                                border.width: 1.5
                            }
                        }
                    }
                }

                // -------------------------------------------------------------
                // LEVEL 2C: Easy entry/exit Sub-Menu (Matches Image 2)
                // -------------------------------------------------------------
                Item {
                    id: vehEasyEntryView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    x: root.vehCurrentScreen === "easy_entry" ? 0 : parent.width
                    opacity: root.vehCurrentScreen === "easy_entry" ? 1.0 : 0.0
                    enabled: root.vehCurrentScreen === "easy_entry"
                    visible: opacity > 0.001 || x < parent.width

                    Behavior on x { NumberAnimation { duration: 320; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 280; easing.type: Easing.InOutQuad } }

                    Flickable {
                        anchors.fill: parent
                        contentHeight: easyEntryCol.height + 40
                        clip: true

                        Column {
                            id: easyEntryCol
                            width: parent.width
                            spacing: 0

                            // 1. Seat adjustment (Switch + Info) - Default OFF
                            SettingRowSwitch {
                                title: "Seat adjustment"
                                checked: root.easyEntrySeatAdjustment
                                infoText: "Moves the driver seat rearward when turning off the ignition to allow easier vehicle entry and exit."
                                onToggled: root.easyEntrySeatAdjustment = !root.easyEntrySeatAdjustment
                                onInfoClicked: root.activeInfoText = infoText
                            }

                            // 2. Approach detection (Switch + Info) - Default ON (amber)
                            SettingRowSwitch {
                                title: "Approach detection"
                                checked: root.easyEntryApproachDetection
                                infoText: "Detects your smart key as you approach the vehicle and illuminates welcome lighting."
                                onToggled: root.easyEntryApproachDetection = !root.easyEntryApproachDetection
                                onInfoClicked: root.activeInfoText = infoText
                            }
                        }
                    }
                }

                // -------------------------------------------------------------
                // LEVEL 2D: Running board modes Sub-Menu (Matches Image 3)
                // -------------------------------------------------------------
                Item {
                    id: vehRunningBoardView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    x: root.vehCurrentScreen === "running_board_modes" ? 0 : parent.width
                    opacity: root.vehCurrentScreen === "running_board_modes" ? 1.0 : 0.0
                    enabled: root.vehCurrentScreen === "running_board_modes"
                    visible: opacity > 0.001 || x < parent.width

                    Behavior on x { NumberAnimation { duration: 320; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 280; easing.type: Easing.InOutQuad } }

                    Flickable {
                        anchors.fill: parent
                        contentHeight: rbCol.height + 40
                        clip: true

                        Column {
                            id: rbCol
                            width: parent.width
                            spacing: 0

                            // 1. Off (Radio + Info)
                            SettingRowRadio {
                                title: "Off"
                                selected: root.runningBoardMode === "Off"
                                infoText: "Keeps running boards stowed at all times."
                                onSelectedRequested: root.runningBoardMode = "Off"
                                onInfoClicked: root.activeInfoText = infoText
                            }

                            // 2. Out (Radio + Info)
                            SettingRowRadio {
                                title: "Out"
                                selected: root.runningBoardMode === "Out"
                                infoText: "Deploys running boards permanently for easier roof loading or vehicle access."
                                onSelectedRequested: root.runningBoardMode = "Out"
                                onInfoClicked: root.activeInfoText = infoText
                            }

                            // 3. Auto (Radio + Info) - Default selected with amber dot
                            SettingRowRadio {
                                title: "Auto"
                                selected: root.runningBoardMode === "Auto"
                                infoText: "Automatically deploys running boards when doors open and retracts when doors close."
                                onSelectedRequested: root.runningBoardMode = "Auto"
                                onInfoClicked: root.activeInfoText = infoText
                            }
                        }
                    }
                }

                // -------------------------------------------------------------
                // LEVEL 2E: Windows Sub-Menu (Matches Image 4)
                // -------------------------------------------------------------
                Item {
                    id: vehWindowsView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    x: root.vehCurrentScreen === "windows" ? 0 : parent.width
                    opacity: root.vehCurrentScreen === "windows" ? 1.0 : 0.0
                    enabled: root.vehCurrentScreen === "windows"
                    visible: opacity > 0.001 || x < parent.width

                    Behavior on x { NumberAnimation { duration: 320; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 280; easing.type: Easing.InOutQuad } }

                    Flickable {
                        anchors.fill: parent
                        contentHeight: winCol.height + 40
                        clip: true

                        Column {
                            id: winCol
                            width: parent.width
                            spacing: 0

                            // 1. Remote open (Switch + Info) - Default ON (amber)
                            SettingRowSwitch {
                                title: "Remote open"
                                checked: root.windowsRemoteOpen
                                infoText: "Press and hold the unlock button on your key fob to remotely lower all power windows."
                                onToggled: root.windowsRemoteOpen = !root.windowsRemoteOpen
                                onInfoClicked: root.activeInfoText = infoText
                            }
                        }
                    }
                }

                // -------------------------------------------------------------
                // LEVEL 2F: Wipers Sub-Menu (Matches reference photo)
                // -------------------------------------------------------------
                Item {
                    id: vehWipersView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    x: root.vehCurrentScreen === "wipers" ? 0 : parent.width
                    opacity: root.vehCurrentScreen === "wipers" ? 1.0 : 0.0
                    enabled: root.vehCurrentScreen === "wipers"
                    visible: opacity > 0.001 || x < parent.width

                    Behavior on x { NumberAnimation { duration: 320; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 280; easing.type: Easing.InOutQuad } }

                    Flickable {
                        anchors.fill: parent
                        contentHeight: wipersCol.height + 40
                        clip: true

                        Column {
                            id: wipersCol
                            width: parent.width
                            spacing: 0

                            // 1. Courtesy wipe (Switch) - Default OFF
                            SettingRowSwitch {
                                title: "Courtesy wipe"
                                checked: root.courtesyWipeEnabled
                                onToggled: root.courtesyWipeEnabled = !root.courtesyWipeEnabled
                            }

                            // 2. Rain sensing (Switch) - Default ON (amber)
                            SettingRowSwitch {
                                title: "Rain sensing"
                                checked: root.rainSensingEnabled
                                onToggled: root.rainSensingEnabled = !root.rainSensingEnabled
                            }

                            // 3. Rear wiper on (when in Reverse) (Switch) - Default ON (amber)
                            SettingRowSwitch {
                                title: "Rear wiper on (when in Reverse)"
                                checked: root.rearWiperReverseEnabled
                                onToggled: root.rearWiperReverseEnabled = !root.rearWiperReverseEnabled
                            }
                        }
                    }
                }

                // -------------------------------------------------------------
                // LEVEL 2G: Alarm system Sub-Menu (Matches reference photo)
                // -------------------------------------------------------------
                Item {
                    id: vehAlarmSystemView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    x: root.vehCurrentScreen === "alarm_system" ? 0 :
                       (root.vehCurrentScreen === "alarm_motion_sensors" ? -parent.width * 0.4 : parent.width)
                    opacity: root.vehCurrentScreen === "alarm_system" ? 1.0 : 0.0
                    enabled: root.vehCurrentScreen === "alarm_system"
                    visible: opacity > 0.001 || x < parent.width

                    Behavior on x { NumberAnimation { duration: 320; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 280; easing.type: Easing.InOutQuad } }

                    Flickable {
                        anchors.fill: parent
                        contentHeight: alarmCol.height + 40
                        clip: true

                        Column {
                            id: alarmCol
                            width: parent.width
                            spacing: 0

                            // 1. Ask on exit (Switch) - Default ON (amber)
                            SettingRowSwitch {
                                title: "Ask on exit"
                                checked: root.alarmAskOnExit
                                onToggled: root.alarmAskOnExit = !root.alarmAskOnExit
                            }

                            // 2. Motion sensors (Chevron) - Default "On" -> Opens Sub-Menu
                            SettingRowChevron {
                                title: "Motion sensors"
                                subtitle: root.alarmMotionSensors
                                onClicked: {
                                    root.vehSlideDir = 1;
                                    root.vehCurrentScreen = "alarm_motion_sensors";
                                }
                            }
                        }
                    }
                }

                // -------------------------------------------------------------
                // LEVEL 3H: Alarm System Motion Sensors Sub-Menu (On / Off)
                // -------------------------------------------------------------
                Item {
                    id: vehMotionSensorsView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    x: root.vehCurrentScreen === "alarm_motion_sensors" ? 0 : parent.width
                    opacity: root.vehCurrentScreen === "alarm_motion_sensors" ? 1.0 : 0.0
                    enabled: root.vehCurrentScreen === "alarm_motion_sensors"
                    visible: opacity > 0.001 || x < parent.width

                    Behavior on x { NumberAnimation { duration: 320; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 280; easing.type: Easing.InOutQuad } }

                    Flickable {
                        anchors.fill: parent
                        contentHeight: motionCol.height + 40
                        clip: true

                        Column {
                            id: motionCol
                            width: parent.width
                            spacing: 0

                            // 1. On (Radio)
                            SettingRowRadio {
                                title: "On"
                                selected: root.alarmMotionSensors === "On"
                                onSelectedRequested: root.alarmMotionSensors = "On"
                            }

                            // 2. Off (Radio)
                            SettingRowRadio {
                                title: "Off"
                                selected: root.alarmMotionSensors === "Off"
                                onSelectedRequested: root.alarmMotionSensors = "Off"
                            }
                        }
                    }
                }

                // -------------------------------------------------------------
                // LEVEL 2F: Remote start setup Sub-Menu (Matches Image 5)
                // -------------------------------------------------------------
                Item {
                    id: vehRemoteStartView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    x: root.vehCurrentScreen === "remote_start" ? 0 :
                       ((root.vehCurrentScreen === "remote_start_climate" || root.vehCurrentScreen === "remote_start_seats" || root.vehCurrentScreen === "remote_start_duration") ? -parent.width * 0.4 : parent.width)
                    opacity: root.vehCurrentScreen === "remote_start" ? 1.0 : 0.0
                    enabled: root.vehCurrentScreen === "remote_start"
                    visible: opacity > 0.001 || (x > -parent.width * 0.4 && x < parent.width)

                    Behavior on x { NumberAnimation { duration: 280; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 240; easing.type: Easing.InOutQuad } }

                    Flickable {
                        anchors.fill: parent
                        contentHeight: rsCol.height + 40
                        clip: true

                        Column {
                            id: rsCol
                            width: parent.width
                            spacing: 0

                            // 1. Remote start (Switch + Info) - Default ON (amber)
                            SettingRowSwitch {
                                title: "Remote start"
                                checked: root.remoteStartEnabled
                                infoText: "Enables starting the vehicle remotely via your smart key or mobile application."
                                onToggled: root.remoteStartEnabled = !root.remoteStartEnabled
                                onInfoClicked: root.activeInfoText = infoText
                            }

                            // 2. Climate control (Chevron + Subtitle + Info)
                            SettingRowChevron {
                                title: "Climate control"
                                subtitle: root.remoteStartClimate
                                infoText: "Automatically configures heating or cooling to comfortable cabin temperatures upon remote start."
                                onClicked: {
                                    root.vehSlideDir = 1;
                                    root.vehCurrentScreen = "remote_start_climate";
                                }
                                onInfoClicked: root.activeInfoText = infoText
                            }

                            // 3. Seats and steering wheel (Chevron + Subtitle + Info)
                            SettingRowChevron {
                                title: "Seats and steering wheel"
                                subtitle: root.remoteStartSeats
                                infoText: "Enables automatic seat heating/ventilation and steering wheel warming during remote start."
                                onClicked: {
                                    root.vehSlideDir = 1;
                                    root.vehCurrentScreen = "remote_start_seats";
                                }
                                onInfoClicked: root.activeInfoText = infoText
                            }

                            // 4. Duration (Chevron + Subtitle + Info)
                            SettingRowChevron {
                                title: "Duration"
                                subtitle: root.remoteStartDuration
                                infoText: "Select the runtime duration before the vehicle automatically shuts down."
                                onClicked: {
                                    root.vehSlideDir = 1;
                                    root.vehCurrentScreen = "remote_start_duration";
                                }
                                onInfoClicked: root.activeInfoText = infoText
                            }
                        }
                    }
                }

                // -------------------------------------------------------------
                // LEVEL 3F: Climate control Sub-Menu (Matches reference photo)
                // -------------------------------------------------------------
                Item {
                    id: vehRemoteStartClimateView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    x: root.vehCurrentScreen === "remote_start_climate" ? 0 : parent.width
                    opacity: root.vehCurrentScreen === "remote_start_climate" ? 1.0 : 0.0
                    enabled: root.vehCurrentScreen === "remote_start_climate"
                    visible: opacity > 0.001 || x < parent.width

                    Behavior on x { NumberAnimation { duration: 280; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 240; easing.type: Easing.InOutQuad } }

                    Row {
                        anchors.fill: parent
                        anchors.topMargin: 20
                        spacing: 56

                        // Left column: Radio Options ("Auto", "Last setting")
                        Column {
                            width: 520
                            spacing: 0

                            Repeater {
                                model: ["Auto", "Last setting"]

                                Item {
                                    width: parent.width
                                    height: 82

                                    Rectangle {
                                        anchors.fill: parent
                                        color: climateOptHover.containsMouse ? Qt.rgba(255, 255, 255, 0.06) : "transparent"
                                        radius: 12
                                    }

                                    Text {
                                        anchors.left: parent.left
                                        anchors.leftMargin: 12
                                        anchors.verticalCenter: parent.verticalCenter
                                        text: modelData
                                        font.family: "Inter"
                                        font.pixelSize: 24
                                        font.weight: root.remoteStartClimate === modelData ? Font.Medium : Font.Normal
                                        color: root.remoteStartClimate === modelData ? "#FFFFFF" : "#CBD5E1"
                                    }

                                    // Radio indicator circle (matching reference photo)
                                    Rectangle {
                                        anchors.right: parent.right
                                        anchors.rightMargin: 16
                                        anchors.verticalCenter: parent.verticalCenter
                                        width: 34
                                        height: 34
                                        radius: 17
                                        color: "transparent"
                                        border.color: root.remoteStartClimate === modelData ? "#E5A97C" : "#5A6B82"
                                        border.width: root.remoteStartClimate === modelData ? 3.5 : 2.2
                                        Behavior on border.color { ColorAnimation { duration: 150 } }

                                        Rectangle {
                                            anchors.centerIn: parent
                                            width: 14
                                            height: 14
                                            radius: 7
                                            color: "#E5A97C"
                                            visible: root.remoteStartClimate === modelData
                                        }
                                    }

                                    // Row divider line
                                    Rectangle {
                                        anchors.left: parent.left
                                        anchors.right: parent.right
                                        anchors.bottom: parent.bottom
                                        height: 1
                                        color: Qt.rgba(255, 255, 255, 0.10)
                                    }

                                    MouseArea {
                                        id: climateOptHover
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: root.remoteStartClimate = modelData
                                    }
                                }
                            }
                        }

                        // Right column: Remote Start Climate Visualizer Card (Identical to autolamp delay)
                        Item {
                            id: climateCardContainer
                            width: Math.min(840, parent.width - 520 - 56)
                            height: 480
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.verticalCenterOffset: -40

                            Rectangle {
                                anchors.fill: parent
                                radius: 14
                                color: "#041322"
                            }

                            // Masked Image with slight rounded rectangle corners
                            Item {
                                anchors.fill: parent

                                Image {
                                    id: climateImg
                                    anchors.fill: parent
                                    source: "qrc:/ApexVision/qml/assets/remote_start_climate_preview.png"
                                    fillMode: Image.PreserveAspectCrop
                                    smooth: true
                                    mipmap: true
                                    visible: false
                                }

                                Rectangle {
                                    id: climateMask
                                    anchors.fill: parent
                                    radius: 14
                                    color: "black"
                                    visible: false
                                    layer.enabled: true
                                }

                                MultiEffect {
                                    anchors.fill: parent
                                    source: climateImg
                                    maskEnabled: true
                                    maskSource: climateMask
                                }
                            }

                            // Sleek subtle border around the slight rounded rectangle
                            Rectangle {
                                anchors.fill: parent
                                radius: 14
                                color: "transparent"
                                border.color: Qt.rgba(255, 255, 255, 0.16)
                                border.width: 1.5
                            }
                        }
                    }
                }

                // -------------------------------------------------------------
                // LEVEL 3G: Seats and steering wheel Sub-Menu (Matches reference photo)
                // -------------------------------------------------------------
                Item {
                    id: vehRemoteStartSeatsView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    x: root.vehCurrentScreen === "remote_start_seats" ? 0 : parent.width
                    opacity: root.vehCurrentScreen === "remote_start_seats" ? 1.0 : 0.0
                    enabled: root.vehCurrentScreen === "remote_start_seats"
                    visible: opacity > 0.001 || x < parent.width

                    Behavior on x { NumberAnimation { duration: 280; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 240; easing.type: Easing.InOutQuad } }

                    Row {
                        anchors.fill: parent
                        anchors.topMargin: 20
                        spacing: 56

                        // Left column: Radio Options ("Auto", "Off" matching user photo)
                        Column {
                            width: 520
                            spacing: 0

                            Repeater {
                                model: ["Auto", "Off"]

                                Item {
                                    width: parent.width
                                    height: 82

                                    Rectangle {
                                        anchors.fill: parent
                                        color: seatsOptHover.containsMouse ? Qt.rgba(255, 255, 255, 0.06) : "transparent"
                                        radius: 12
                                    }

                                    Text {
                                        anchors.left: parent.left
                                        anchors.leftMargin: 12
                                        anchors.verticalCenter: parent.verticalCenter
                                        text: modelData
                                        font.family: "Inter"
                                        font.pixelSize: 24
                                        font.weight: root.remoteStartSeats === modelData ? Font.Medium : Font.Normal
                                        color: root.remoteStartSeats === modelData ? "#FFFFFF" : "#CBD5E1"
                                    }

                                    // Radio indicator circle (matching reference photo)
                                    Rectangle {
                                        anchors.right: parent.right
                                        anchors.rightMargin: 16
                                        anchors.verticalCenter: parent.verticalCenter
                                        width: 34
                                        height: 34
                                        radius: 17
                                        color: "transparent"
                                        border.color: root.remoteStartSeats === modelData ? "#E5A97C" : "#5A6B82"
                                        border.width: root.remoteStartSeats === modelData ? 3.5 : 2.2
                                        Behavior on border.color { ColorAnimation { duration: 150 } }

                                        Rectangle {
                                            anchors.centerIn: parent
                                            width: 14
                                            height: 14
                                            radius: 7
                                            color: "#E5A97C"
                                            visible: root.remoteStartSeats === modelData
                                        }
                                    }

                                    // Row divider line
                                    Rectangle {
                                        anchors.left: parent.left
                                        anchors.right: parent.right
                                        anchors.bottom: parent.bottom
                                        height: 1
                                        color: Qt.rgba(255, 255, 255, 0.10)
                                    }

                                    MouseArea {
                                        id: seatsOptHover
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: root.remoteStartSeats = modelData
                                    }
                                }
                            }
                        }

                        // Right column: Remote Start Seats Visualizer Card (Identical to autolamp delay)
                        Item {
                            id: seatsCardContainer
                            width: Math.min(840, parent.width - 520 - 56)
                            height: 480
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.verticalCenterOffset: -40

                            Rectangle {
                                anchors.fill: parent
                                radius: 14
                                color: "#050D14"
                            }

                            // Masked Image with slight rounded rectangle corners
                            Item {
                                anchors.fill: parent

                                Image {
                                    id: seatsImg
                                    anchors.fill: parent
                                    source: "qrc:/ApexVision/qml/assets/remote_start_seats_preview.png"
                                    fillMode: Image.PreserveAspectCrop
                                    smooth: true
                                    mipmap: true
                                    visible: false
                                }

                                Rectangle {
                                    id: seatsMask
                                    anchors.fill: parent
                                    radius: 14
                                    color: "black"
                                    visible: false
                                    layer.enabled: true
                                }

                                MultiEffect {
                                    anchors.fill: parent
                                    source: seatsImg
                                    maskEnabled: true
                                    maskSource: seatsMask
                                }
                            }

                            // Sleek subtle border around the slight rounded rectangle
                            Rectangle {
                                anchors.fill: parent
                                radius: 14
                                color: "transparent"
                                border.color: Qt.rgba(255, 255, 255, 0.16)
                                border.width: 1.5
                            }
                        }
                    }
                }

                // -------------------------------------------------------------
                // LEVEL 3H: Duration Sub-Menu (Matches reference photo)
                // -------------------------------------------------------------
                Item {
                    id: vehRemoteStartDurationView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    x: root.vehCurrentScreen === "remote_start_duration" ? 0 : parent.width
                    opacity: root.vehCurrentScreen === "remote_start_duration" ? 1.0 : 0.0
                    enabled: root.vehCurrentScreen === "remote_start_duration"
                    visible: opacity > 0.001 || x < parent.width

                    Behavior on x { NumberAnimation { duration: 280; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 240; easing.type: Easing.InOutQuad } }

                    Row {
                        anchors.fill: parent
                        anchors.topMargin: 20
                        spacing: 56

                        // Left column: Radio Options ("5 minutes", "10 minutes", "15 minutes")
                        Column {
                            width: 520
                            spacing: 0

                            Repeater {
                                model: ["5 minutes", "10 minutes", "15 minutes"]

                                Item {
                                    width: parent.width
                                    height: 82

                                    Rectangle {
                                        anchors.fill: parent
                                        color: durOptHover.containsMouse ? Qt.rgba(255, 255, 255, 0.06) : "transparent"
                                        radius: 12
                                    }

                                    Text {
                                        anchors.left: parent.left
                                        anchors.leftMargin: 12
                                        anchors.verticalCenter: parent.verticalCenter
                                        text: modelData
                                        font.family: "Inter"
                                        font.pixelSize: 24
                                        font.weight: root.remoteStartDuration === modelData ? Font.Medium : Font.Normal
                                        color: root.remoteStartDuration === modelData ? "#FFFFFF" : "#CBD5E1"
                                    }

                                    // Radio indicator circle (matching reference photo)
                                    Rectangle {
                                        anchors.right: parent.right
                                        anchors.rightMargin: 16
                                        anchors.verticalCenter: parent.verticalCenter
                                        width: 34
                                        height: 34
                                        radius: 17
                                        color: "transparent"
                                        border.color: root.remoteStartDuration === modelData ? "#E5A97C" : "#5A6B82"
                                        border.width: root.remoteStartDuration === modelData ? 3.5 : 2.2
                                        Behavior on border.color { ColorAnimation { duration: 150 } }

                                        Rectangle {
                                            anchors.centerIn: parent
                                            width: 14
                                            height: 14
                                            radius: 7
                                            color: "#E5A97C"
                                            visible: root.remoteStartDuration === modelData
                                        }
                                    }

                                    // Row divider line
                                    Rectangle {
                                        anchors.left: parent.left
                                        anchors.right: parent.right
                                        anchors.bottom: parent.bottom
                                        height: 1
                                        color: Qt.rgba(255, 255, 255, 0.10)
                                    }

                                    MouseArea {
                                        id: durOptHover
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: root.remoteStartDuration = modelData
                                    }
                                }
                            }
                        }

                        // Right column: Remote Start Duration Visualizer Card (Same image as climate control)
                        Item {
                            id: durationCardContainer
                            width: Math.min(840, parent.width - 520 - 56)
                            height: 480
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.verticalCenterOffset: -40

                            Rectangle {
                                anchors.fill: parent
                                radius: 14
                                color: "#000000"
                            }

                            // Masked Image with slight rounded rectangle corners
                            Item {
                                anchors.fill: parent

                                Image {
                                    id: durationImg
                                    anchors.fill: parent
                                    source: "qrc:/ApexVision/qml/assets/image.png"
                                    fillMode: Image.PreserveAspectCrop
                                    smooth: true
                                    mipmap: true
                                    visible: false
                                }

                                Rectangle {
                                    id: durationMask
                                    anchors.fill: parent
                                    radius: 14
                                    color: "black"
                                    visible: false
                                    layer.enabled: true
                                }

                                MultiEffect {
                                    anchors.fill: parent
                                    source: durationImg
                                    maskEnabled: true
                                    maskSource: durationMask
                                }
                            }

                            // Sleek subtle border around the slight rounded rectangle
                            Rectangle {
                                anchors.fill: parent
                                radius: 14
                                color: "transparent"
                                border.color: Qt.rgba(255, 255, 255, 0.16)
                                border.width: 1.5
                            }
                        }
                    }
                }

                // -------------------------------------------------------------
                // LEVEL 2H: Locks Sub-Menu (Matches reference photo)
                // -------------------------------------------------------------
                Item {
                    id: vehLocksView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    x: root.vehCurrentScreen === "locks" ? 0 :
                       (root.vehCurrentScreen === "remote_unlock" ? -parent.width * 0.4 : parent.width)
                    opacity: root.vehCurrentScreen === "locks" ? 1.0 : 0.0
                    enabled: root.vehCurrentScreen === "locks"
                    visible: opacity > 0.001 || x < parent.width

                    Behavior on x { NumberAnimation { duration: 320; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 280; easing.type: Easing.InOutQuad } }

                    Flickable {
                        anchors.fill: parent
                        contentHeight: locksCol.height + 40
                        clip: true

                        Column {
                            id: locksCol
                            width: parent.width
                            spacing: 0

                            // 1. Auto unlock (Switch) - Default ON
                            SettingRowSwitch {
                                title: "Auto unlock"
                                checked: root.autoUnlockEnabled
                                onToggled: root.autoUnlockEnabled = !root.autoUnlockEnabled
                            }

                            // 2. Mislock chirp (Switch) - Default ON
                            SettingRowSwitch {
                                title: "Mislock chirp"
                                checked: root.mislockChirpEnabled
                                onToggled: root.mislockChirpEnabled = !root.mislockChirpEnabled
                            }

                            // 3. Switch inhibit (Switch) - Default ON
                            SettingRowSwitch {
                                title: "Switch inhibit"
                                checked: root.switchInhibitEnabled
                                onToggled: root.switchInhibitEnabled = !root.switchInhibitEnabled
                            }

                            // 4. Remote unlock (Chevron + Subtitle) -> Opens remote_unlock screen
                            SettingRowChevron {
                                title: "Remote unlock"
                                subtitle: root.remoteUnlockMode
                                onClicked: {
                                    root.vehSlideDir = 1;
                                    root.vehCurrentScreen = "remote_unlock";
                                }
                            }

                            // 5. Audible feedback (Switch) - Default ON
                            SettingRowSwitch {
                                title: "Audible feedback"
                                checked: root.audibleFeedbackEnabled
                                onToggled: root.audibleFeedbackEnabled = !root.audibleFeedbackEnabled
                            }
                        }
                    }
                }

                // -------------------------------------------------------------
                // LEVEL 3I: Remote Unlock Full-Screen Sub-Menu (Matches user reference photo)
                // -------------------------------------------------------------
                Item {
                    id: vehRemoteUnlockView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    x: root.vehCurrentScreen === "remote_unlock" ? 0 : parent.width
                    opacity: root.vehCurrentScreen === "remote_unlock" ? 1.0 : 0.0
                    enabled: root.vehCurrentScreen === "remote_unlock"
                    visible: opacity > 0.001 || x < parent.width

                    Behavior on x { NumberAnimation { duration: 320; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 280; easing.type: Easing.InOutQuad } }

                    Row {
                        anchors.fill: parent
                        anchors.leftMargin: 20
                        anchors.rightMargin: 20
                        spacing: 40

                        // Left column: Radio Options (Aligned to top)
                        Item {
                            width: 480
                            anchors.top: parent.top
                            anchors.bottom: parent.bottom

                            Column {
                                anchors.left: parent.left
                                anchors.right: parent.right
                                anchors.top: parent.top
                                anchors.topMargin: 16
                                spacing: 0

                                SettingRowRadio {
                                    title: "All doors"
                                    selected: root.remoteUnlockMode === "All doors"
                                    onSelectedRequested: root.remoteUnlockMode = "All doors"
                                }

                                SettingRowRadio {
                                    title: "Driver's door"
                                    selected: root.remoteUnlockMode === "Driver's door"
                                    onSelectedRequested: root.remoteUnlockMode = "Driver's door"
                                }
                            }
                        }

                        // Right column: Top-down vehicle visualizer card (Aligned to top)
                        Item {
                            id: remoteUnlockCardContainer
                            width: Math.min(840, parent.width - 520 - 56)
                            height: 480
                            anchors.top: parent.top
                            anchors.topMargin: 16

                            Rectangle {
                                anchors.fill: parent
                                radius: 14
                                color: "#0B0E14"
                            }

                            Item {
                                anchors.fill: parent

                                Image {
                                    id: remoteUnlockImg
                                    anchors.fill: parent
                                    source: root.remoteUnlockMode === "All doors" ?
                                            "qrc:/ApexVision/qml/assets/remote_unlock_all.png" :
                                            "qrc:/ApexVision/qml/assets/remote_unlock_driver.png"
                                    fillMode: Image.PreserveAspectCrop
                                    smooth: true
                                    mipmap: true
                                    visible: false
                                }

                                Rectangle {
                                    id: remoteUnlockMask
                                    anchors.fill: parent
                                    radius: 14
                                    color: "black"
                                    visible: false
                                    layer.enabled: true
                                }

                                MultiEffect {
                                    anchors.fill: parent
                                    source: remoteUnlockImg
                                    maskEnabled: true
                                    maskSource: remoteUnlockMask
                                }
                            }

                            // Sleek subtle border around card
                            Rectangle {
                                anchors.fill: parent
                                radius: 14
                                color: "transparent"
                                border.color: Qt.rgba(255, 255, 255, 0.16)
                                border.width: 1.5
                            }
                        }
                    }
                }

                // -------------------------------------------------------------
                // LEVEL 2J: Mirrors Sub-Menu (Matches user reference photo)
                // -------------------------------------------------------------
                Item {
                    id: vehMirrorsView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    x: root.vehCurrentScreen === "mirrors" ? 0 : parent.width
                    opacity: root.vehCurrentScreen === "mirrors" ? 1.0 : 0.0
                    enabled: root.vehCurrentScreen === "mirrors"
                    visible: opacity > 0.001 || x < parent.width

                    Behavior on x { NumberAnimation { duration: 320; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 280; easing.type: Easing.InOutQuad } }

                    Flickable {
                        anchors.fill: parent
                        contentHeight: mirrorsCol.height + 40
                        clip: true

                        Column {
                            id: mirrorsCol
                            width: parent.width
                            spacing: 0

                            // 1. Autofold (Switch) - Default ON
                            SettingRowSwitch {
                                title: "Autofold"
                                checked: root.mirrorAutofoldEnabled
                                onToggled: root.mirrorAutofoldEnabled = !root.mirrorAutofoldEnabled
                            }
                        }
                    }
                }

                // -------------------------------------------------------------
                // LEVEL 2K: Door keypad code Full-Screen View (Matches user reference photo)
                // -------------------------------------------------------------
                Item {
                    id: vehDoorKeypadCodeView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    x: root.vehCurrentScreen === "door_keypad_code" ? 0 : parent.width
                    opacity: root.vehCurrentScreen === "door_keypad_code" ? 1.0 : 0.0
                    enabled: root.vehCurrentScreen === "door_keypad_code"
                    visible: opacity > 0.001 || x < parent.width

                    Behavior on x { NumberAnimation { duration: 320; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 280; easing.type: Easing.InOutQuad } }

                    Column {
                        anchors.centerIn: parent
                        anchors.verticalCenterOffset: -30
                        width: Math.min(760, parent.width - 60)
                        spacing: 28

                        // Text instructions
                        Column {
                            width: parent.width
                            spacing: 8

                            Text {
                                text: "Enter 5-digit factory code:"
                                font.family: "Inter"
                                font.pixelSize: 22
                                font.weight: Font.DemiBold
                                color: "#FFFFFF"
                            }

                            Text {
                                text: "To create or delete a personal keypad code, you must first enter the factory code."
                                font.family: "Inter"
                                font.pixelSize: 15
                                color: "#94A3B8"
                                wrapMode: Text.WordWrap
                                width: parent.width
                            }
                        }

                        // PIN boxes and Backspace row
                        Row {
                            spacing: 16
                            anchors.horizontalCenter: parent.horizontalCenter

                            Repeater {
                                model: 5
                                delegate: Rectangle {
                                    width: 60
                                    height: 60
                                    radius: 12
                                    color: Qt.rgba(255, 255, 255, 0.06)
                                    border.color: index === root.doorKeypadCode.length ? "#38BDF8" : Qt.rgba(255, 255, 255, 0.20)
                                    border.width: index === root.doorKeypadCode.length ? 2.5 : 1.5

                                    Behavior on border.color { ColorAnimation { duration: 150 } }

                                    Text {
                                        anchors.centerIn: parent
                                        text: index < root.doorKeypadCode.length ? "●" : ""
                                        font.family: "Inter"
                                        font.pixelSize: 26
                                        font.weight: Font.Bold
                                        color: "#FFFFFF"
                                    }
                                }
                            }

                            // Backspace Button
                            Rectangle {
                                width: 60
                                height: 60
                                radius: 12
                                color: bsMouse.pressed ? Qt.rgba(255, 255, 255, 0.14) :
                                       (bsMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.09) : Qt.rgba(255, 255, 255, 0.05))
                                border.color: Qt.rgba(255, 255, 255, 0.20)
                                border.width: 1.5

                                Text {
                                    anchors.centerIn: parent
                                    text: "⌫"
                                    font.family: "Inter"
                                    font.pixelSize: 24
                                    font.weight: Font.Medium
                                    color: root.doorKeypadCode.length > 0 ? "#FFFFFF" : Qt.rgba(255, 255, 255, 0.35)
                                }

                                MouseArea {
                                    id: bsMouse
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                        if (root.doorKeypadCode.length > 0) {
                                            root.doorKeypadCode = root.doorKeypadCode.slice(0, -1);
                                        }
                                    }
                                }
                            }
                        }

                        // Keypad buttons row
                        Row {
                            spacing: 12
                            anchors.horizontalCenter: parent.horizontalCenter

                            Repeater {
                                model: ["1·2", "3·4", "5·6", "7·8", "9·0", "Enter"]
                                delegate: Rectangle {
                                    id: keyBtn
                                    width: modelData === "Enter" ? 116 : 84
                                    height: 64
                                    radius: 12

                                    property bool isEnter: modelData === "Enter"
                                    property bool enterEnabled: isEnter && root.doorKeypadCode.length === 5

                                    color: isEnter ?
                                           (enterEnabled ? (keyMouse.pressed ? "#1D4ED8" : "#2563EB") : Qt.rgba(255, 255, 255, 0.04)) :
                                           (keyMouse.pressed ? Qt.rgba(255, 255, 255, 0.16) :
                                            (keyMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.10) : Qt.rgba(255, 255, 255, 0.06)))

                                    border.color: isEnter ?
                                                  (enterEnabled ? "#3B82F6" : Qt.rgba(255, 255, 255, 0.10)) :
                                                  Qt.rgba(255, 255, 255, 0.18)
                                    border.width: 1.5

                                    Text {
                                        anchors.centerIn: parent
                                        text: modelData
                                        font.family: "Inter"
                                        font.pixelSize: keyBtn.isEnter ? 18 : 20
                                        font.weight: Font.DemiBold
                                        color: keyBtn.isEnter ?
                                               (keyBtn.enterEnabled ? "#FFFFFF" : Qt.rgba(255, 255, 255, 0.35)) :
                                               "#FFFFFF"
                                    }

                                    MouseArea {
                                        id: keyMouse
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: {
                                            if (keyBtn.isEnter) {
                                                if (keyBtn.enterEnabled) {
                                                    // Accepted factory code
                                                    root.vehCurrentScreen = "main";
                                                }
                                            } else {
                                                if (root.doorKeypadCode.length < 5) {
                                                    root.doorKeypadCode += modelData[0];
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                // -------------------------------------------------------------
                // LEVEL 2L: Power liftgate Sub-Menu (Matches OEM Apex specs)
                // -------------------------------------------------------------
                Item {
                    id: vehPowerLiftgateView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    x: root.vehCurrentScreen === "power_liftgate" ? 0 : parent.width
                    opacity: root.vehCurrentScreen === "power_liftgate" ? 1.0 : 0.0
                    enabled: root.vehCurrentScreen === "power_liftgate"
                    visible: opacity > 0.001 || x < parent.width

                    Behavior on x { NumberAnimation { duration: 320; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 280; easing.type: Easing.InOutQuad } }

                    Flickable {
                        anchors.fill: parent
                        contentHeight: liftgateCol.height + 40
                        clip: true

                        Column {
                            id: liftgateCol
                            width: parent.width
                            spacing: 0

                            // 1. Power (Radio)
                            SettingRowRadio {
                                title: "Power"
                                selected: root.powerLiftgateMode === "Power"
                                onSelectedRequested: root.powerLiftgateMode = "Power"
                            }

                            // 2. Manual (Radio)
                            SettingRowRadio {
                                title: "Manual"
                                selected: root.powerLiftgateMode === "Manual"
                                onSelectedRequested: root.powerLiftgateMode = "Manual"
                            }

                            // 3. Hands-free liftgate (Switch) - Default ON
                            SettingRowSwitch {
                                title: "Hands-free liftgate"
                                checked: root.handsFreeLiftgateEnabled
                                onToggled: root.handsFreeLiftgateEnabled = !root.handsFreeLiftgateEnabled
                            }

                            // 4. Liftgate chime (Switch) - Default ON
                            SettingRowSwitch {
                                title: "Liftgate chime"
                                checked: root.liftgateChimeEnabled
                                onToggled: root.liftgateChimeEnabled = !root.liftgateChimeEnabled
                            }
                        }
                    }
                }
            }

            // =================================================================
            // CATEGORY: SOUND (Apex Ultima 3D Audio Experience)
            // Complete end-to-end sound options with slide transitions
            // =================================================================
            Item {
                id: soundCategoryPanel
                anchors.fill: parent
                x: root.activeCategory === "sound" ? 0 : 36
                opacity: root.activeCategory === "sound" ? 1.0 : 0.0
                visible: opacity > 0.001
                clip: true

                Behavior on x { NumberAnimation { duration: 280; easing.type: Easing.OutCubic } }
                Behavior on opacity { NumberAnimation { duration: 240; easing.type: Easing.InOutQuad } }

                // -------------------------------------------------------------
                // LEVEL 1: Main Sound Menu
                // -------------------------------------------------------------
                Item {
                    id: soundMainView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    x: root.soundCurrentScreen === "main" ? 0 : -parent.width * 0.4
                    opacity: root.soundCurrentScreen === "main" ? 1.0 : 0.0
                    enabled: root.soundCurrentScreen === "main"
                    visible: opacity > 0.001

                    Behavior on x { NumberAnimation { duration: 280; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 240; easing.type: Easing.InOutQuad } }

                    Flickable {
                        anchors.fill: parent
                        contentHeight: soundMainCol.height + 40
                        clip: true
                        boundsBehavior: Flickable.DragAndOvershootBounds
                        flickableDirection: Flickable.VerticalFlick

                        Column {
                            id: soundMainCol
                            width: parent.width
                            spacing: 0

                            // 1. Tone (Photo 1)
                            SettingRowChevron {
                                title: "Tone"
                                onClicked: {
                                    root.soundSlideDir = 1;
                                    root.soundCurrentScreen = "tone";
                                }
                            }

                            // 2. Balance and fade (Photo 1)
                            SettingRowChevron {
                                title: "Balance and fade"
                                onClicked: {
                                    root.soundSlideDir = 1;
                                    root.soundCurrentScreen = "balance_fade";
                                }
                            }

                            // 2. Speed-compensated volume (Subtitle + Chevron + Info - Photo 1)
                            SettingRowChevron {
                                title: "Speed-compensated volume"
                                subtitle: root.speedCompVolume
                                infoText: "Adjusts audio volume automatically based on vehicle speed to compensate for road and wind noise."
                                onClicked: {
                                    root.soundSlideDir = 1;
                                    root.soundCurrentScreen = "speed_volume";
                                }
                                onInfoClicked: root.activeInfoText = infoText
                            }

                            // 3. QuantumLogic® Surround (Subtitle + Chevron + Info - Photo 1 & 2)
                            SettingRowChevron {
                                title: "QuantumLogic® Surround"
                                subtitle: root.quantumLogicMode
                                infoText: "Transforms multi-channel audio recordings into an immersive, natural three-dimensional listening experience."
                                onClicked: {
                                    root.soundSlideDir = 1;
                                    root.soundCurrentScreen = "quantum_logic";
                                }
                                onInfoClicked: root.activeInfoText = infoText
                            }

                            // 4. Play Revel® Experience (Chevron + Info - Photo 1 & 2)
                            SettingRowChevron {
                                title: "Play Revel® Experience"
                                infoText: "Experience the acoustic excellence of Revel Ultima audio with a curated demonstration."
                                onClicked: {
                                    root.soundSlideDir = 1;
                                    root.soundCurrentScreen = "revel_experience";
                                }
                                onInfoClicked: root.activeInfoText = infoText
                            }

                            // 5. Volume settings (Photo 1 & 2)
                            SettingRowChevron {
                                title: "Volume settings"
                                onClicked: {
                                    root.soundSlideDir = 1;
                                    root.soundCurrentScreen = "volume_settings";
                                }
                            }

                            // 6. Ringtones (Subtitle + Chevron - Photo 2)
                            SettingRowChevron {
                                title: "Ringtones"
                                subtitle: root.soundRingtone
                                onClicked: {
                                    root.soundSlideDir = 1;
                                    root.soundCurrentScreen = "ringtones";
                                }
                            }

                            // 7. Notification sounds (Chevron - Photo 2)
                            SettingRowChevron {
                                title: "Notification sounds"
                                onClicked: {
                                    root.soundSlideDir = 1;
                                    root.soundCurrentScreen = "notification_sounds";
                                }
                            }
                        }
                    }
                }

                // -------------------------------------------------------------
                // LEVEL 2A: Tone (Bass, Midrange, Treble - Discrete Vertical Sliders)
                // Pixel-perfect match to Reference Photos 2, 3, 4, 5
                // -------------------------------------------------------------
                Item {
                    id: soundToneView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    x: root.soundCurrentScreen === "tone" ? 0 : parent.width
                    opacity: root.soundCurrentScreen === "tone" ? 1.0 : 0.0
                    enabled: root.soundCurrentScreen === "tone"
                    visible: opacity > 0.001

                    Behavior on x { NumberAnimation { duration: 280; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 240; easing.type: Easing.InOutQuad } }

                    // Centered Horizontal Layout of Sliders + Reset Button (Photo 2)
                    Row {
                        anchors.centerIn: parent
                        spacing: 68

                        // BASS SLIDER
                        Item {
                            id: bassSliderItem
                            width: 100
                            height: 380

                            readonly property real trackLength: 264
                            readonly property real stepInterval: 22 // 264 / 12
                            readonly property real thumbY: (6 - root.soundBass) * stepInterval

                            Item {
                                id: bassTrackArea
                                width: 50
                                height: parent.trackLength
                                anchors.top: parent.top
                                anchors.topMargin: 20
                                anchors.horizontalCenter: parent.horizontalCenter

                                Timer {
                                    id: bassTooltipTimer
                                    interval: 1800
                                    repeat: false
                                }

                                Rectangle {
                                    width: 4
                                    height: parent.height
                                    radius: 2
                                    color: Qt.rgba(255, 255, 255, 0.22)
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }

                                Repeater {
                                    model: 13
                                    delegate: Item {
                                        width: 44
                                        height: 22
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        y: index * bassSliderItem.stepInterval - 11
                                        z: 2

                                        Rectangle {
                                            width: index === 6 ? 6 : 4
                                            height: index === 6 ? 6 : 4
                                            radius: index === 6 ? 3 : 2
                                            color: index === 6 ? "#FFFFFF" : Qt.rgba(255, 255, 255, 0.45)
                                            anchors.centerIn: parent
                                        }

                                        MouseArea {
                                            anchors.fill: parent
                                            cursorShape: Qt.PointingHandCursor
                                            preventStealing: true
                                            onPressed: {
                                                root.soundBass = 6 - index;
                                                bassTooltipTimer.restart();
                                            }
                                        }
                                    }
                                }

                                Rectangle {
                                    width: 5
                                    radius: 2.5
                                    color: "#E5A96A"
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    y: root.soundBass >= 0 ? bassSliderItem.thumbY : 132
                                    height: Math.abs(root.soundBass) * bassSliderItem.stepInterval
                                    visible: root.soundBass !== 0
                                }

                                Rectangle {
                                    id: bassThumbRing
                                    width: 30
                                    height: 30
                                    radius: 15
                                    color: "#0B111E"
                                    border.color: "#E5A96A"
                                    border.width: 3
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    y: bassSliderItem.thumbY - 15

                                    Behavior on y {
                                        enabled: !bassMouse.pressed
                                        NumberAnimation { duration: 120; easing.type: Easing.OutCubic }
                                    }
                                }

                                Item {
                                    id: bassTooltip
                                    width: 46
                                    height: 34
                                    anchors.right: bassThumbRing.left
                                    anchors.rightMargin: 10
                                    anchors.verticalCenter: bassThumbRing.verticalCenter
                                    z: 10
                                    opacity: (bassMouse.pressed || bassTooltipTimer.running) ? 1.0 : 0.0
                                    visible: opacity > 0.001
                                    Behavior on opacity { NumberAnimation { duration: 180; easing.type: Easing.OutQuad } }

                                    Rectangle {
                                        anchors.fill: parent
                                        radius: 12
                                        color: "#E8B688"
                                    }

                                    Rectangle {
                                        width: 10
                                        height: 10
                                        radius: 2
                                        rotation: 45
                                        color: "#E8B688"
                                        anchors.verticalCenter: parent.verticalCenter
                                        anchors.right: parent.right
                                        anchors.rightMargin: -3
                                    }

                                    Text {
                                        anchors.centerIn: parent
                                        text: root.soundBass > 0 ? ("+" + root.soundBass) : ("" + root.soundBass)
                                        font.family: "Inter"
                                        font.pixelSize: 15
                                        font.weight: Font.Bold
                                        color: "#18120C"
                                    }
                                }

                                MouseArea {
                                    id: bassMouse
                                    anchors.fill: parent
                                    anchors.margins: -16
                                    z: 1
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    preventStealing: true

                                    function updatePos(mouseY) {
                                        var localY = mouseY - 16;
                                        var clampedY = Math.max(0, Math.min(bassSliderItem.trackLength, localY));
                                        var step = Math.max(0, Math.min(12, Math.round(clampedY / bassSliderItem.stepInterval)));
                                        root.soundBass = 6 - step;
                                        bassTooltipTimer.restart();
                                    }

                                    onPressed: function(mouse) { updatePos(mouse.y); }
                                    onPositionChanged: function(mouse) { if (pressed) updatePos(mouse.y); }
                                    onReleased: { bassTooltipTimer.restart(); }
                                }
                            }

                            Text {
                                anchors.top: bassTrackArea.bottom
                                anchors.topMargin: 22
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: "Bass"
                                font.family: "Inter"
                                font.pixelSize: 17
                                font.weight: Font.Medium
                                color: "#FFFFFF"
                            }
                        }

                        // MIDRANGE SLIDER
                        Item {
                            id: midSliderItem
                            width: 100
                            height: 380

                            readonly property real trackLength: 264
                            readonly property real stepInterval: 22
                            readonly property real thumbY: (6 - root.soundMid) * stepInterval

                            Item {
                                id: midTrackArea
                                width: 50
                                height: parent.trackLength
                                anchors.top: parent.top
                                anchors.topMargin: 20
                                anchors.horizontalCenter: parent.horizontalCenter

                                Timer {
                                    id: midTooltipTimer
                                    interval: 1800
                                    repeat: false
                                }

                                Rectangle {
                                    width: 4
                                    height: parent.height
                                    radius: 2
                                    color: Qt.rgba(255, 255, 255, 0.22)
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }

                                Repeater {
                                    model: 13
                                    delegate: Item {
                                        width: 44
                                        height: 22
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        y: index * midSliderItem.stepInterval - 11
                                        z: 2

                                        Rectangle {
                                            width: index === 6 ? 6 : 4
                                            height: index === 6 ? 6 : 4
                                            radius: index === 6 ? 3 : 2
                                            color: index === 6 ? "#FFFFFF" : Qt.rgba(255, 255, 255, 0.45)
                                            anchors.centerIn: parent
                                        }

                                        MouseArea {
                                            anchors.fill: parent
                                            cursorShape: Qt.PointingHandCursor
                                            preventStealing: true
                                            onPressed: {
                                                root.soundMid = 6 - index;
                                                midTooltipTimer.restart();
                                            }
                                        }
                                    }
                                }

                                Rectangle {
                                    width: 5
                                    radius: 2.5
                                    color: "#E5A96A"
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    y: root.soundMid >= 0 ? midSliderItem.thumbY : 132
                                    height: Math.abs(root.soundMid) * midSliderItem.stepInterval
                                    visible: root.soundMid !== 0
                                }

                                Rectangle {
                                    id: midThumbRing
                                    width: 30
                                    height: 30
                                    radius: 15
                                    color: "#0B111E"
                                    border.color: "#E5A96A"
                                    border.width: 3
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    y: midSliderItem.thumbY - 15

                                    Behavior on y {
                                        enabled: !midMouse.pressed
                                        NumberAnimation { duration: 120; easing.type: Easing.OutCubic }
                                    }
                                }

                                Item {
                                    id: midTooltip
                                    width: 46
                                    height: 34
                                    anchors.right: midThumbRing.left
                                    anchors.rightMargin: 10
                                    anchors.verticalCenter: midThumbRing.verticalCenter
                                    z: 10
                                    opacity: (midMouse.pressed || midTooltipTimer.running) ? 1.0 : 0.0
                                    visible: opacity > 0.001
                                    Behavior on opacity { NumberAnimation { duration: 180; easing.type: Easing.OutQuad } }

                                    Rectangle {
                                        anchors.fill: parent
                                        radius: 12
                                        color: "#E8B688"
                                    }

                                    Rectangle {
                                        width: 10
                                        height: 10
                                        radius: 2
                                        rotation: 45
                                        color: "#E8B688"
                                        anchors.verticalCenter: parent.verticalCenter
                                        anchors.right: parent.right
                                        anchors.rightMargin: -3
                                    }

                                    Text {
                                        anchors.centerIn: parent
                                        text: root.soundMid > 0 ? ("+" + root.soundMid) : ("" + root.soundMid)
                                        font.family: "Inter"
                                        font.pixelSize: 15
                                        font.weight: Font.Bold
                                        color: "#18120C"
                                    }
                                }

                                MouseArea {
                                    id: midMouse
                                    anchors.fill: parent
                                    anchors.margins: -16
                                    z: 1
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    preventStealing: true

                                    function updatePos(mouseY) {
                                        var localY = mouseY - 16;
                                        var clampedY = Math.max(0, Math.min(midSliderItem.trackLength, localY));
                                        var step = Math.max(0, Math.min(12, Math.round(clampedY / midSliderItem.stepInterval)));
                                        root.soundMid = 6 - step;
                                        midTooltipTimer.restart();
                                    }

                                    onPressed: function(mouse) { updatePos(mouse.y); }
                                    onPositionChanged: function(mouse) { if (pressed) updatePos(mouse.y); }
                                    onReleased: { midTooltipTimer.restart(); }
                                }
                            }

                            Text {
                                anchors.top: midTrackArea.bottom
                                anchors.topMargin: 22
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: "Midrange"
                                font.family: "Inter"
                                font.pixelSize: 17
                                font.weight: Font.Medium
                                color: "#FFFFFF"
                            }
                        }

                        // TREBLE SLIDER
                        Item {
                            id: trebleSliderItem
                            width: 100
                            height: 380

                            readonly property real trackLength: 264
                            readonly property real stepInterval: 22
                            readonly property real thumbY: (6 - root.soundTreble) * stepInterval

                            Item {
                                id: trebleTrackArea
                                width: 50
                                height: parent.trackLength
                                anchors.top: parent.top
                                anchors.topMargin: 20
                                anchors.horizontalCenter: parent.horizontalCenter

                                Timer {
                                    id: trebleTooltipTimer
                                    interval: 1800
                                    repeat: false
                                }

                                Rectangle {
                                    width: 4
                                    height: parent.height
                                    radius: 2
                                    color: Qt.rgba(255, 255, 255, 0.22)
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }

                                Repeater {
                                    model: 13
                                    delegate: Item {
                                        width: 44
                                        height: 22
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        y: index * trebleSliderItem.stepInterval - 11
                                        z: 2

                                        Rectangle {
                                            width: index === 6 ? 6 : 4
                                            height: index === 6 ? 6 : 4
                                            radius: index === 6 ? 3 : 2
                                            color: index === 6 ? "#FFFFFF" : Qt.rgba(255, 255, 255, 0.45)
                                            anchors.centerIn: parent
                                        }

                                        MouseArea {
                                            anchors.fill: parent
                                            cursorShape: Qt.PointingHandCursor
                                            preventStealing: true
                                            onPressed: {
                                                root.soundTreble = 6 - index;
                                                trebleTooltipTimer.restart();
                                            }
                                        }
                                    }
                                }

                                Rectangle {
                                    width: 5
                                    radius: 2.5
                                    color: "#E5A96A"
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    y: root.soundTreble >= 0 ? trebleSliderItem.thumbY : 132
                                    height: Math.abs(root.soundTreble) * trebleSliderItem.stepInterval
                                    visible: root.soundTreble !== 0
                                }

                                Rectangle {
                                    id: trebleThumbRing
                                    width: 30
                                    height: 30
                                    radius: 15
                                    color: "#0B111E"
                                    border.color: "#E5A96A"
                                    border.width: 3
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    y: trebleSliderItem.thumbY - 15

                                    Behavior on y {
                                        enabled: !trebleMouse.pressed
                                        NumberAnimation { duration: 120; easing.type: Easing.OutCubic }
                                    }
                                }

                                Item {
                                    id: trebleTooltip
                                    width: 46
                                    height: 34
                                    anchors.right: trebleThumbRing.left
                                    anchors.rightMargin: 10
                                    anchors.verticalCenter: trebleThumbRing.verticalCenter
                                    z: 10
                                    opacity: (trebleMouse.pressed || trebleTooltipTimer.running) ? 1.0 : 0.0
                                    visible: opacity > 0.001
                                    Behavior on opacity { NumberAnimation { duration: 180; easing.type: Easing.OutQuad } }

                                    Rectangle {
                                        anchors.fill: parent
                                        radius: 12
                                        color: "#E8B688"
                                    }

                                    Rectangle {
                                        width: 10
                                        height: 10
                                        radius: 2
                                        rotation: 45
                                        color: "#E8B688"
                                        anchors.verticalCenter: parent.verticalCenter
                                        anchors.right: parent.right
                                        anchors.rightMargin: -3
                                    }

                                    Text {
                                        anchors.centerIn: parent
                                        text: root.soundTreble > 0 ? ("+" + root.soundTreble) : ("" + root.soundTreble)
                                        font.family: "Inter"
                                        font.pixelSize: 15
                                        font.weight: Font.Bold
                                        color: "#18120C"
                                    }
                                }

                                MouseArea {
                                    id: trebleMouse
                                    anchors.fill: parent
                                    anchors.margins: -16
                                    z: 1
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    preventStealing: true

                                    function updatePos(mouseY) {
                                        var localY = mouseY - 16;
                                        var clampedY = Math.max(0, Math.min(trebleSliderItem.trackLength, localY));
                                        var step = Math.max(0, Math.min(12, Math.round(clampedY / trebleSliderItem.stepInterval)));
                                        root.soundTreble = 6 - step;
                                        trebleTooltipTimer.restart();
                                    }

                                    onPressed: function(mouse) { updatePos(mouse.y); }
                                    onPositionChanged: function(mouse) { if (pressed) updatePos(mouse.y); }
                                    onReleased: { trebleTooltipTimer.restart(); }
                                }
                            }

                            Text {
                                anchors.top: trebleTrackArea.bottom
                                anchors.topMargin: 22
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: "Treble"
                                font.family: "Inter"
                                font.pixelSize: 17
                                font.weight: Font.Medium
                                color: "#FFFFFF"
                            }
                        }

                        Item {
                            width: 20
                            height: 1
                        }

                        // Reset button (Photo 2)
                        Rectangle {
                            width: 120
                            height: 48
                            radius: 12
                            anchors.verticalCenter: parent.verticalCenter
                            color: resetBtnMouse.pressed ? Qt.rgba(255, 255, 255, 0.16) :
                                   (resetBtnMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.11) : Qt.rgba(255, 255, 255, 0.07))
                            border.color: Qt.rgba(255, 255, 255, 0.20)
                            border.width: 1

                            Text {
                                anchors.centerIn: parent
                                text: "Reset"
                                font.family: "Inter"
                                font.pixelSize: 17
                                font.weight: Font.DemiBold
                                color: "#FFFFFF"
                            }

                            MouseArea {
                                id: resetBtnMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    root.soundBass = 0;
                                    root.soundMid = 0;
                                    root.soundTreble = 0;
                                    bassTooltipTimer.restart();
                                    midTooltipTimer.restart();
                                    trebleTooltipTimer.restart();
                                }
                            }
                        }
                    }
                }

                // -------------------------------------------------------------
                // LEVEL 2B: Balance and fade (OEM Top-Down Cabin with Interactive Radar Scan Disc)
                // -------------------------------------------------------------
                Item {
                    id: soundBalanceFadeView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    x: root.soundCurrentScreen === "balance_fade" ? 0 : parent.width
                    opacity: root.soundCurrentScreen === "balance_fade" ? 1.0 : 0.0
                    enabled: root.soundCurrentScreen === "balance_fade"
                    visible: opacity > 0.001

                    Behavior on x { NumberAnimation { duration: 280; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 240; easing.type: Easing.InOutQuad } }

                    // Car + Soundstage Area
                    Item {
                        id: balanceStage
                        anchors.centerIn: parent
                        width: Math.min(parent.width - 40, 720)
                        height: Math.min(parent.height - 20, 540)

                        // Car Cabin Container (Natural unclipped top-down view with smooth hood gradient fade)
                        Item {
                            id: carCabinCropContainer
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.horizontalCenterOffset: -36
                            width: 400
                            height: 520
                            clip: false

                            // Top-Down Car Image - Perfectly scaled to show full front hood gradient and full cabin seats
                            Image {
                                id: carTopImg
                                width: 520
                                height: width * (1536.0 / 1024.0) // 780px
                                anchors.horizontalCenter: parent.horizontalCenter
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.verticalCenterOffset: -12
                                source: "qrc:/ApexVision/qml/assets/icons/car_top_balance_fade.png"
                                fillMode: Image.PreserveAspectFit
                                smooth: true
                                mipmap: true
                            }
                        }

                        // Cabin Boundary calculations:
                        readonly property real cabinCenterX: carCabinCropContainer.x + carCabinCropContainer.width * 0.5
                        readonly property real cabinCenterY: carCabinCropContainer.y + carCabinCropContainer.height * 0.5 - 6
                        readonly property real cabinHalfW: 72
                        readonly property real cabinHalfH: 90

                        readonly property real focalX: cabinCenterX + (root.soundFadeX / 7.0) * cabinHalfW
                        readonly property real focalY: cabinCenterY - (root.soundFadeY / 7.0) * cabinHalfH

                        // Glowing Acoustic Wave Focus Disc with Continuous Sound Waves radiating from the point
                        Item {
                            id: soundScanDisc
                            x: balanceStage.focalX - width / 2
                            y: balanceStage.focalY - height / 2
                            width: 240
                            height: 240
                            z: 5

                            Behavior on x {
                                enabled: !cabinMouse.pressed
                                NumberAnimation { duration: 220; easing.type: Easing.OutCubic }
                            }
                            Behavior on y {
                                enabled: !cabinMouse.pressed
                                NumberAnimation { duration: 220; easing.type: Easing.OutCubic }
                            }

                            // --- WARM ACOUSTIC AMBIENT ILLUMINATION (Highlights seats under the sound focus) ---
                            Rectangle {
                                anchors.centerIn: parent
                                width: 220
                                height: 220
                                radius: 110
                                color: Qt.rgba(224/255, 140/255, 70/255, 0.22)
                                border.color: Qt.rgba(229/255, 169/255, 106/255, 0.35)
                                border.width: 1.5
                            }
                            Rectangle {
                                anchors.centerIn: parent
                                width: 140
                                height: 140
                                radius: 70
                                color: Qt.rgba(235/255, 155/255, 80/255, 0.18)
                            }

                            // --- SOUND WAVE RIPPLES EXPANDING FROM THE POINT ---
                            Repeater {
                                model: 4
                                delegate: Item {
                                    id: waveItem
                                    anchors.centerIn: parent
                                    width: 32
                                    height: 32

                                    Rectangle {
                                        id: waveRing
                                        anchors.centerIn: parent
                                        width: 32
                                        height: 32
                                        radius: 16
                                        color: Qt.rgba(229/255, 169/255, 106/255, 0.04)
                                        border.color: root.currentThemeAccent
                                        border.width: 2.0
                                        opacity: 0.0

                                        SequentialAnimation {
                                            running: true
                                            loops: Animation.Infinite
                                            PauseAnimation { duration: index * 600 }
                                            ParallelAnimation {
                                                NumberAnimation {
                                                    target: waveRing
                                                    property: "scale"
                                                    from: 0.6
                                                    to: 7.2
                                                    duration: 2400
                                                    easing.type: Easing.OutCubic
                                                }
                                                SequentialAnimation {
                                                    NumberAnimation {
                                                        target: waveRing
                                                        property: "opacity"
                                                        from: 0.0
                                                        to: 0.75
                                                        duration: 300
                                                        easing.type: Easing.OutQuad
                                                    }
                                                    NumberAnimation {
                                                        target: waveRing
                                                        property: "opacity"
                                                        from: 0.75
                                                        to: 0.0
                                                        duration: 2100
                                                        easing.type: Easing.InQuad
                                                    }
                                                }
                                                NumberAnimation {
                                                    target: waveRing
                                                    property: "border.width"
                                                    from: 2.2
                                                    to: 0.8
                                                    duration: 2400
                                                }
                                            }
                                        }
                                    }
                                }
                            }

                            // --- THE FOCAL POINT (Hollow Ring Thumb) ---
                            Rectangle {
                                id: scanCenterRing
                                anchors.centerIn: parent
                                width: 34
                                height: 34
                                radius: 17
                                color: "#0B111E"
                                border.color: root.currentThemeAccent
                                border.width: 3.5

                                // Subtle inner point dot
                                Rectangle {
                                    anchors.centerIn: parent
                                    width: 6
                                    height: 6
                                    radius: 3
                                    color: "#FFFFFF"
                                    opacity: 0.9
                                }
                            }
                        }

                        // Touch and Drag Interaction Area across the cabin
                        MouseArea {
                            id: cabinMouse
                            anchors.fill: carCabinCropContainer
                            cursorShape: Qt.PointingHandCursor
                            preventStealing: true

                            function updateSoundPosition(mx, my) {
                                var relX = (mx - balanceStage.cabinCenterX) / balanceStage.cabinHalfW;
                                var relY = (balanceStage.cabinCenterY - my) / balanceStage.cabinHalfH;

                                var clampedX = Math.max(-7, Math.min(7, Math.round(relX * 7.0)));
                                var clampedY = Math.max(-7, Math.min(7, Math.round(relY * 7.0)));

                                root.soundFadeX = clampedX;
                                root.soundFadeY = clampedY;
                            }

                            onPressed: function(mouse) { updateSoundPosition(mouse.x + carCabinCropContainer.x, mouse.y + carCabinCropContainer.y); }
                            onPositionChanged: function(mouse) { if (pressed) updateSoundPosition(mouse.x + carCabinCropContainer.x, mouse.y + carCabinCropContainer.y); }
                        }

                        // Reset button (matching photo right side)
                        Rectangle {
                            id: resetBalanceBtn
                            width: 110
                            height: 46
                            radius: 12
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: carCabinCropContainer.right
                            anchors.leftMargin: 36
                            color: resetBalMouse.pressed ? Qt.rgba(255, 255, 255, 0.16) :
                                   (resetBalMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.11) : Qt.rgba(255, 255, 255, 0.07))
                            border.color: Qt.rgba(255, 255, 255, 0.20)
                            border.width: 1

                            Text {
                                anchors.centerIn: parent
                                text: "Reset"
                                font.family: "Inter"
                                font.pixelSize: 17
                                font.weight: Font.DemiBold
                                color: "#FFFFFF"
                            }

                            MouseArea {
                                id: resetBalMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    root.soundFadeX = 0;
                                    root.soundFadeY = 0;
                                }
                            }
                        }
                    }
                }

                // -------------------------------------------------------------
                // LEVEL 2C: Speed-compensated volume Sub-screen
                // -------------------------------------------------------------
                Item {
                    id: soundSpeedVolumeView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    x: root.soundCurrentScreen === "speed_volume" ? 0 : parent.width
                    opacity: root.soundCurrentScreen === "speed_volume" ? 1.0 : 0.0
                    enabled: root.soundCurrentScreen === "speed_volume"
                    visible: opacity > 0.001

                    Behavior on x { NumberAnimation { duration: 280; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 240; easing.type: Easing.InOutQuad } }

                    Flickable {
                        anchors.fill: parent
                        contentHeight: speedCol.height + 40
                        clip: true

                        Column {
                            id: speedCol
                            width: parent.width
                            spacing: 0

                            Repeater {
                                model: [
                                    { title: "Off", desc: "No speed compensation" },
                                    { title: "Low", desc: "Subtle volume adjustment at highway speeds" },
                                    { title: "Medium", desc: "Balanced compensation for city and highway driving" },
                                    { title: "High", desc: "Aggressive compensation for noisy road surfaces" }
                                ]
                                delegate: SettingRowRadio {
                                    title: modelData.title
                                    subtitle: modelData.desc
                                    selected: root.speedCompVolume === modelData.title
                                    onSelectedRequested: {
                                        root.speedCompVolume = modelData.title;
                                        root.soundSlideDir = -1;
                                        root.soundCurrentScreen = "main";
                                    }
                                }
                            }
                        }
                    }
                }

                // -------------------------------------------------------------
                // LEVEL 2D: QuantumLogic® Surround Sub-screen
                // -------------------------------------------------------------
                Item {
                    id: soundQuantumLogicView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    x: root.soundCurrentScreen === "quantum_logic" ? 0 : parent.width
                    opacity: root.soundCurrentScreen === "quantum_logic" ? 1.0 : 0.0
                    enabled: root.soundCurrentScreen === "quantum_logic"
                    visible: opacity > 0.001

                    Behavior on x { NumberAnimation { duration: 280; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 240; easing.type: Easing.InOutQuad } }

                    Flickable {
                        anchors.fill: parent
                        contentHeight: qlCol.height + 40
                        clip: true

                        Column {
                            id: qlCol
                            width: parent.width
                            spacing: 0

                            SettingRowRadio {
                                title: "Audience"
                                subtitle: "Concert hall acoustic staging with natural spatial sound"
                                selected: root.quantumLogicMode === "Audience"
                                onSelectedRequested: {
                                    root.quantumLogicMode = "Audience";
                                    root.soundSlideDir = -1;
                                    root.soundCurrentScreen = "main";
                                }
                            }

                            SettingRowRadio {
                                title: "On Stage"
                                subtitle: "360-degree expansive soundstage placing instruments all around you"
                                selected: root.quantumLogicMode === "On Stage"
                                onSelectedRequested: {
                                    root.quantumLogicMode = "On Stage";
                                    root.soundSlideDir = -1;
                                    root.soundCurrentScreen = "main";
                                }
                            }

                            SettingRowRadio {
                                title: "Off"
                                subtitle: "Standard stereo playback without 3D surround processing"
                                selected: root.quantumLogicMode === "Off"
                                onSelectedRequested: {
                                    root.quantumLogicMode = "Off";
                                    root.soundSlideDir = -1;
                                    root.soundCurrentScreen = "main";
                                }
                            }

                            Item { width: parent.width; height: 24 }

                            SettingRowSlider {
                                title: "QuantumLogic® 3D Immersion"
                                value: root.soundQuantumLogic
                                onValueChanged: root.soundQuantumLogic = value
                            }
                        }
                    }
                }

                // -------------------------------------------------------------
                // LEVEL 2E: Play Revel® Experience Sub-screen
                // -------------------------------------------------------------
                Item {
                    id: soundRevelExpView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    x: root.soundCurrentScreen === "revel_experience" ? 0 : parent.width
                    opacity: root.soundCurrentScreen === "revel_experience" ? 1.0 : 0.0
                    enabled: root.soundCurrentScreen === "revel_experience"
                    visible: opacity > 0.001

                    Behavior on x { NumberAnimation { duration: 280; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 240; easing.type: Easing.InOutQuad } }

                    Flickable {
                        anchors.fill: parent
                        contentHeight: revelCol.height + 40
                        clip: true

                        Column {
                            id: revelCol
                            width: parent.width
                            spacing: 24
                            topPadding: 16
                            bottomPadding: 24

                            // Revel Ultima Hero Card with animated demo player
                            Rectangle {
                                width: Math.min(parent.width - 16, 680)
                                height: 180
                                radius: 16
                                anchors.horizontalCenter: parent.horizontalCenter
                                gradient: Gradient {
                                    GradientStop { position: 0.0; color: Qt.rgba(224/255, 131/255, 101/255, 0.18) }
                                    GradientStop { position: 1.0; color: Qt.rgba(14/255, 20/255, 34/255, 0.75) }
                                }
                                border.color: Qt.rgba(224/255, 131/255, 101/255, 0.40)
                                border.width: 1.5

                                Column {
                                    anchors.left: parent.left
                                    anchors.leftMargin: 24
                                    anchors.verticalCenter: parent.verticalCenter
                                    spacing: 8
                                    width: parent.width - 130

                                    Text {
                                        text: "Revel® Ultima 3D Audio Experience"
                                        font.family: "Inter"
                                        font.pixelSize: 20
                                        font.weight: Font.Bold
                                        color: "#FFFFFF"
                                    }

                                    Text {
                                        text: root.isPlayingRevelDemo ? "Now playing high-resolution acoustic demonstration track..." : "Experience studio-master clarity and immersive 3D surround sound."
                                        font.family: "Inter"
                                        font.pixelSize: 14
                                        color: "#CBD5E1"
                                        wrapMode: Text.WordWrap
                                        width: parent.width
                                    }

                                    // Progress bar
                                    Rectangle {
                                        width: parent.width
                                        height: 6
                                        radius: 3
                                        color: Qt.rgba(255, 255, 255, 0.15)

                                        Rectangle {
                                            width: root.isPlayingRevelDemo ? parent.width * 0.45 : 0
                                            height: parent.height
                                            radius: 3
                                            color: "#E08365"
                                            Behavior on width { NumberAnimation { duration: 1000 } }
                                        }
                                    }
                                }

                                // Play / Pause Circle Button
                                Rectangle {
                                    width: 56
                                    height: 56
                                    radius: 28
                                    anchors.right: parent.right
                                    anchors.rightMargin: 24
                                    anchors.verticalCenter: parent.verticalCenter
                                    color: playMouse.pressed ? "#C96D50" : (playMouse.containsMouse ? "#E89275" : "#E08365")
                                    border.color: "#FFFFFF"
                                    border.width: 2

                                    Text {
                                        anchors.centerIn: parent
                                        text: root.isPlayingRevelDemo ? "❚❚" : "▶"
                                        font.pixelSize: root.isPlayingRevelDemo ? 18 : 22
                                        color: "#0E1422"
                                    }

                                    MouseArea {
                                        id: playMouse
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: root.isPlayingRevelDemo = !root.isPlayingRevelDemo
                                    }
                                }
                            }

                            // Architecture Features List
                            SettingRowChevron {
                                title: "Point Source Architecture"
                                subtitle: "Seamless tweeter and midrange acoustic alignment"
                                infoText: "Positions tweeters and midranges in close proximity to reproduce voice and high-frequency sound from a single coherent acoustic origin."
                                showChevron: false
                            }

                            SettingRowChevron {
                                title: "Clari-Fi™ Music Restoration"
                                subtitle: "Real-time acoustic reconstruction of compressed digital audio"
                                infoText: "Analyzes audio signals in real time to rebuild lost musical details, dynamics, and high frequencies from streamed media."
                                showChevron: false
                            }

                            SettingRowChevron {
                                title: "28-Speaker Cabin Immersion"
                                subtitle: "Acoustically calibrated 20-channel DSP amplification"
                                infoText: "Precision engineered speaker arrays including headliner ceiling speakers to create custom listening heights and true 3D spatial staging."
                                showChevron: false
                            }
                        }
                    }
                }

                // -------------------------------------------------------------
                // LEVEL 2F: Volume settings Sub-screen (Matching OEM Photo 3)
                // -------------------------------------------------------------
                Item {
                    id: soundVolumeSettingsView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    x: root.soundCurrentScreen === "volume_settings" ? 0 : parent.width
                    opacity: root.soundCurrentScreen === "volume_settings" ? 1.0 : 0.0
                    enabled: root.soundCurrentScreen === "volume_settings"
                    visible: opacity > 0.001

                    Behavior on x { NumberAnimation { duration: 280; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 240; easing.type: Easing.InOutQuad } }

                    Flickable {
                        anchors.fill: parent
                        contentHeight: volumeSettingsCol.height + 60
                        clip: true
                        boundsBehavior: Flickable.DragAndOvershootBounds

                        Column {
                            id: volumeSettingsCol
                            width: parent.width
                            spacing: 32
                            topPadding: 16
                            bottomPadding: 32

                            // 1. Audio Slider (Dragger matching QuantumLogic 3D)
                            Item {
                                width: parent.width
                                height: 76

                                Item {
                                    id: audioHeaderRow
                                    anchors.left: parent.left
                                    anchors.leftMargin: 12
                                    anchors.right: parent.right
                                    anchors.rightMargin: 24
                                    anchors.top: parent.top
                                    height: 28

                                    Row {
                                        anchors.left: parent.left
                                        anchors.verticalCenter: parent.verticalCenter
                                        spacing: 12

                                        Image {
                                            width: 22
                                            height: 22
                                            source: "qrc:/ApexVision/qml/assets/icons/sound_vol_audio.svg"
                                            fillMode: Image.PreserveAspectFit
                                            smooth: true
                                            anchors.verticalCenter: parent.verticalCenter
                                        }

                                        Text {
                                            text: "Audio"
                                            color: "#FFFFFF"
                                            font.family: "Inter"
                                            font.pixelSize: 18
                                            font.weight: Font.Medium
                                            anchors.verticalCenter: parent.verticalCenter
                                        }
                                    }

                                    Text {
                                        anchors.right: parent.right
                                        anchors.verticalCenter: parent.verticalCenter
                                        text: root.soundVolumeAudio <= 0 ? "Min" : (root.soundVolumeAudio >= 30 ? "Max" : ("" + root.soundVolumeAudio))
                                        color: "#FFFFFF"
                                        font.family: "Inter"
                                        font.pixelSize: 16
                                        font.weight: Font.Medium
                                    }
                                }

                                Slider {
                                    id: audioSlider
                                    anchors.left: parent.left
                                    anchors.right: parent.right
                                    anchors.leftMargin: 12
                                    anchors.rightMargin: 24
                                    anchors.top: audioHeaderRow.bottom
                                    anchors.topMargin: 10
                                    height: 36
                                    padding: 0
                                    from: 0
                                    to: 30
                                    stepSize: 1
                                    value: root.soundVolumeAudio
                                    onMoved: root.soundVolumeAudio = Math.round(value)

                                    background: Item {
                                        x: audioSlider.leftPadding
                                        y: audioSlider.topPadding + audioSlider.availableHeight / 2 - height / 2
                                        width: audioSlider.availableWidth
                                        height: 12

                                        // 1. Inactive base groove
                                        Rectangle {
                                            anchors.fill: parent
                                            radius: 6
                                            color: Qt.rgba(255, 255, 255, 0.14)
                                        }

                                        // 2. Active filled gradient portion
                                        Rectangle {
                                            anchors.left: parent.left
                                            anchors.top: parent.top
                                            anchors.bottom: parent.bottom
                                            width: audioSlider.value > 0 ? Math.max(height, audioSlider.visualPosition * parent.width) : 0
                                            radius: 6
                                            visible: audioSlider.value > 0
                                            gradient: Gradient {
                                                orientation: Gradient.Horizontal
                                                GradientStop { position: 0.0; color: "#E08365" }
                                                GradientStop { position: 0.5; color: "#F0B594" }
                                                GradientStop { position: 1.0; color: "#F7D5BC" }
                                            }
                                        }

                                        // 3. 5 discrete notch dots along track
                                        Row {
                                            id: audioNotchDotsRow
                                            anchors.fill: parent
                                            anchors.leftMargin: 20
                                            anchors.rightMargin: 20
                                            spacing: Math.max(0, (width - 5 * 5) / 4)

                                            Repeater {
                                                model: 5
                                                Rectangle {
                                                    anchors.verticalCenter: parent.verticalCenter
                                                    width: 5
                                                    height: 5
                                                    radius: 2.5
                                                    color: (20 + index * (audioNotchDotsRow.spacing + 5) + 2.5) <= (audioSlider.visualPosition * audioSlider.availableWidth) ?
                                                           "#6E2A18" : Qt.rgba(255, 255, 255, 0.35)
                                                }
                                            }
                                        }
                                    }

                                    handle: Rectangle {
                                        x: audioSlider.leftPadding + audioSlider.visualPosition * (audioSlider.availableWidth - width)
                                        y: audioSlider.topPadding + audioSlider.availableHeight / 2 - height / 2
                                        implicitWidth: 30
                                        implicitHeight: 30
                                        radius: 15
                                        color: "#0F172A"
                                        border.color: "#FFFFFF"
                                        border.width: 3.5

                                        scale: audioSlider.pressed ? 1.15 : 1.0
                                        Behavior on scale { NumberAnimation { duration: 100 } }
                                    }
                                }
                            }

                            // 2. Prompts Slider (Dragger matching QuantumLogic 3D)
                            Item {
                                width: parent.width
                                height: 80

                                Item {
                                    id: promptsHeaderRow
                                    anchors.left: parent.left
                                    anchors.leftMargin: 12
                                    anchors.right: parent.right
                                    anchors.rightMargin: 24
                                    anchors.top: parent.top
                                    height: 28

                                    Row {
                                        anchors.left: parent.left
                                        anchors.verticalCenter: parent.verticalCenter
                                        spacing: 12

                                        Image {
                                            width: 22
                                            height: 22
                                            source: "qrc:/ApexVision/qml/assets/icons/sound_vol_prompts.svg"
                                            fillMode: Image.PreserveAspectFit
                                            smooth: true
                                            anchors.verticalCenter: parent.verticalCenter
                                        }

                                        Text {
                                            text: "Prompts"
                                            color: "#FFFFFF"
                                            font.family: "Inter"
                                            font.pixelSize: 18
                                            font.weight: Font.Medium
                                            anchors.verticalCenter: parent.verticalCenter
                                        }
                                    }

                                    Text {
                                        anchors.right: parent.right
                                        anchors.verticalCenter: parent.verticalCenter
                                        text: root.soundVolumePrompts <= 0 ? "Min" : (root.soundVolumePrompts >= 30 ? "Max" : ("" + root.soundVolumePrompts))
                                        color: "#FFFFFF"
                                        font.family: "Inter"
                                        font.pixelSize: 16
                                        font.weight: Font.Medium
                                    }
                                }

                                Slider {
                                    id: promptsSlider
                                    anchors.left: parent.left
                                    anchors.right: parent.right
                                    anchors.leftMargin: 12
                                    anchors.rightMargin: 24
                                    anchors.top: promptsHeaderRow.bottom
                                    anchors.topMargin: 10
                                    height: 36
                                    padding: 0
                                    from: 0
                                    to: 30
                                    stepSize: 1
                                    value: root.soundVolumePrompts
                                    onMoved: root.soundVolumePrompts = Math.round(value)

                                    background: Item {
                                        x: promptsSlider.leftPadding
                                        y: promptsSlider.topPadding + promptsSlider.availableHeight / 2 - height / 2
                                        width: promptsSlider.availableWidth
                                        height: 12

                                        // 1. Inactive base groove
                                        Rectangle {
                                            anchors.fill: parent
                                            radius: 6
                                            color: Qt.rgba(255, 255, 255, 0.14)
                                        }

                                        // 2. Active filled gradient portion
                                        Rectangle {
                                            anchors.left: parent.left
                                            anchors.top: parent.top
                                            anchors.bottom: parent.bottom
                                            width: promptsSlider.value > 0 ? Math.max(height, promptsSlider.visualPosition * parent.width) : 0
                                            radius: 6
                                            visible: promptsSlider.value > 0
                                            gradient: Gradient {
                                                orientation: Gradient.Horizontal
                                                GradientStop { position: 0.0; color: "#E08365" }
                                                GradientStop { position: 0.5; color: "#F0B594" }
                                                GradientStop { position: 1.0; color: "#F7D5BC" }
                                            }
                                        }

                                        // 3. 5 discrete notch dots along track
                                        Row {
                                            id: promptsNotchDotsRow
                                            anchors.fill: parent
                                            anchors.leftMargin: 20
                                            anchors.rightMargin: 20
                                            spacing: Math.max(0, (width - 5 * 5) / 4)

                                            Repeater {
                                                model: 5
                                                Rectangle {
                                                    anchors.verticalCenter: parent.verticalCenter
                                                    width: 5
                                                    height: 5
                                                    radius: 2.5
                                                    color: (20 + index * (promptsNotchDotsRow.spacing + 5) + 2.5) <= (promptsSlider.visualPosition * promptsSlider.availableWidth) ?
                                                           "#6E2A18" : Qt.rgba(255, 255, 255, 0.35)
                                                }
                                            }
                                        }
                                    }

                                    handle: Rectangle {
                                        x: promptsSlider.leftPadding + promptsSlider.visualPosition * (promptsSlider.availableWidth - width)
                                        y: promptsSlider.topPadding + promptsSlider.availableHeight / 2 - height / 2
                                        implicitWidth: 30
                                        implicitHeight: 30
                                        radius: 15
                                        color: "#0F172A"
                                        border.color: "#FFFFFF"
                                        border.width: 3.5

                                        scale: promptsSlider.pressed ? 1.15 : 1.0
                                        Behavior on scale { NumberAnimation { duration: 100 } }
                                    }
                                }
                            }

                            // 3. Phone Slider (Dragger matching QuantumLogic 3D)
                            Item {
                                width: parent.width
                                height: 80

                                Item {
                                    id: phoneHeaderRow
                                    anchors.left: parent.left
                                    anchors.leftMargin: 12
                                    anchors.right: parent.right
                                    anchors.rightMargin: 24
                                    anchors.top: parent.top
                                    height: 28

                                    Row {
                                        anchors.left: parent.left
                                        anchors.verticalCenter: parent.verticalCenter
                                        spacing: 12

                                        Image {
                                            width: 22
                                            height: 22
                                            source: "qrc:/ApexVision/qml/assets/icons/sound_vol_phone.svg"
                                            fillMode: Image.PreserveAspectFit
                                            smooth: true
                                            anchors.verticalCenter: parent.verticalCenter
                                        }

                                        Text {
                                            text: "Phone"
                                            color: "#FFFFFF"
                                            font.family: "Inter"
                                            font.pixelSize: 18
                                            font.weight: Font.Medium
                                            anchors.verticalCenter: parent.verticalCenter
                                        }
                                    }

                                    Text {
                                        anchors.right: parent.right
                                        anchors.verticalCenter: parent.verticalCenter
                                        text: root.soundVolumePhone <= 0 ? "Min" : (root.soundVolumePhone >= 30 ? "Max" : ("" + root.soundVolumePhone))
                                        color: "#FFFFFF"
                                        font.family: "Inter"
                                        font.pixelSize: 16
                                        font.weight: Font.Medium
                                    }
                                }

                                Slider {
                                    id: phoneSlider
                                    anchors.left: parent.left
                                    anchors.right: parent.right
                                    anchors.leftMargin: 12
                                    anchors.rightMargin: 24
                                    anchors.top: phoneHeaderRow.bottom
                                    anchors.topMargin: 10
                                    height: 36
                                    padding: 0
                                    from: 0
                                    to: 30
                                    stepSize: 1
                                    value: root.soundVolumePhone
                                    onMoved: root.soundVolumePhone = Math.round(value)

                                    background: Item {
                                        x: phoneSlider.leftPadding
                                        y: phoneSlider.topPadding + phoneSlider.availableHeight / 2 - height / 2
                                        width: phoneSlider.availableWidth
                                        height: 12

                                        // 1. Inactive base groove
                                        Rectangle {
                                            anchors.fill: parent
                                            radius: 6
                                            color: Qt.rgba(255, 255, 255, 0.14)
                                        }

                                        // 2. Active filled gradient portion
                                        Rectangle {
                                            anchors.left: parent.left
                                            anchors.top: parent.top
                                            anchors.bottom: parent.bottom
                                            width: phoneSlider.value > 0 ? Math.max(height, phoneSlider.visualPosition * parent.width) : 0
                                            radius: 6
                                            visible: phoneSlider.value > 0
                                            gradient: Gradient {
                                                orientation: Gradient.Horizontal
                                                GradientStop { position: 0.0; color: "#E08365" }
                                                GradientStop { position: 0.5; color: "#F0B594" }
                                                GradientStop { position: 1.0; color: "#F7D5BC" }
                                            }
                                        }

                                        // 3. 5 discrete notch dots along track
                                        Row {
                                            id: phoneNotchDotsRow
                                            anchors.fill: parent
                                            anchors.leftMargin: 20
                                            anchors.rightMargin: 20
                                            spacing: Math.max(0, (width - 5 * 5) / 4)

                                            Repeater {
                                                model: 5
                                                Rectangle {
                                                    anchors.verticalCenter: parent.verticalCenter
                                                    width: 5
                                                    height: 5
                                                    radius: 2.5
                                                    color: (20 + index * (phoneNotchDotsRow.spacing + 5) + 2.5) <= (phoneSlider.visualPosition * phoneSlider.availableWidth) ?
                                                           "#6E2A18" : Qt.rgba(255, 255, 255, 0.35)
                                                }
                                            }
                                        }
                                    }

                                    handle: Rectangle {
                                        x: phoneSlider.leftPadding + phoneSlider.visualPosition * (phoneSlider.availableWidth - width)
                                        y: phoneSlider.topPadding + phoneSlider.availableHeight / 2 - height / 2
                                        implicitWidth: 30
                                        implicitHeight: 30
                                        radius: 15
                                        color: "#0F172A"
                                        border.color: "#FFFFFF"
                                        border.width: 3.5

                                        scale: phoneSlider.pressed ? 1.15 : 1.0
                                        Behavior on scale { NumberAnimation { duration: 100 } }
                                    }
                                }
                            }

                            // 4. Call ring Slider (Dragger matching QuantumLogic 3D)
                            Item {
                                width: parent.width
                                height: 80

                                Item {
                                    id: callRingHeaderRow
                                    anchors.left: parent.left
                                    anchors.leftMargin: 12
                                    anchors.right: parent.right
                                    anchors.rightMargin: 24
                                    anchors.top: parent.top
                                    height: 28

                                    Row {
                                        anchors.left: parent.left
                                        anchors.verticalCenter: parent.verticalCenter
                                        spacing: 12

                                        Image {
                                            width: 22
                                            height: 22
                                            source: "qrc:/ApexVision/qml/assets/icons/sound_vol_call_ring.svg"
                                            fillMode: Image.PreserveAspectFit
                                            smooth: true
                                            anchors.verticalCenter: parent.verticalCenter
                                        }

                                        Text {
                                            text: "Call ring"
                                            color: "#FFFFFF"
                                            font.family: "Inter"
                                            font.pixelSize: 18
                                            font.weight: Font.Medium
                                            anchors.verticalCenter: parent.verticalCenter
                                        }
                                    }

                                    Text {
                                        anchors.right: parent.right
                                        anchors.verticalCenter: parent.verticalCenter
                                        text: root.soundVolumeCallRing <= 0 ? "Min" : (root.soundVolumeCallRing >= 30 ? "Max" : ("" + root.soundVolumeCallRing))
                                        color: "#FFFFFF"
                                        font.family: "Inter"
                                        font.pixelSize: 16
                                        font.weight: Font.Medium
                                    }
                                }

                                Slider {
                                    id: callRingSlider
                                    anchors.left: parent.left
                                    anchors.right: parent.right
                                    anchors.leftMargin: 12
                                    anchors.rightMargin: 24
                                    anchors.top: callRingHeaderRow.bottom
                                    anchors.topMargin: 10
                                    height: 36
                                    padding: 0
                                    from: 0
                                    to: 30
                                    stepSize: 1
                                    value: root.soundVolumeCallRing
                                    onMoved: root.soundVolumeCallRing = Math.round(value)

                                    background: Item {
                                        x: callRingSlider.leftPadding
                                        y: callRingSlider.topPadding + callRingSlider.availableHeight / 2 - height / 2
                                        width: callRingSlider.availableWidth
                                        height: 12

                                        // 1. Inactive base groove
                                        Rectangle {
                                            anchors.fill: parent
                                            radius: 6
                                            color: Qt.rgba(255, 255, 255, 0.14)
                                        }

                                        // 2. Active filled gradient portion
                                        Rectangle {
                                            anchors.left: parent.left
                                            anchors.top: parent.top
                                            anchors.bottom: parent.bottom
                                            width: callRingSlider.value > 0 ? Math.max(height, callRingSlider.visualPosition * parent.width) : 0
                                            radius: 6
                                            visible: callRingSlider.value > 0
                                            gradient: Gradient {
                                                orientation: Gradient.Horizontal
                                                GradientStop { position: 0.0; color: "#E08365" }
                                                GradientStop { position: 0.5; color: "#F0B594" }
                                                GradientStop { position: 1.0; color: "#F7D5BC" }
                                            }
                                        }

                                        // 3. 5 discrete notch dots along track
                                        Row {
                                            id: callRingNotchDotsRow
                                            anchors.fill: parent
                                            anchors.leftMargin: 20
                                            anchors.rightMargin: 20
                                            spacing: Math.max(0, (width - 5 * 5) / 4)

                                            Repeater {
                                                model: 5
                                                Rectangle {
                                                    anchors.verticalCenter: parent.verticalCenter
                                                    width: 5
                                                    height: 5
                                                    radius: 2.5
                                                    color: (20 + index * (callRingNotchDotsRow.spacing + 5) + 2.5) <= (callRingSlider.visualPosition * callRingSlider.availableWidth) ?
                                                           "#6E2A18" : Qt.rgba(255, 255, 255, 0.35)
                                                }
                                            }
                                        }
                                    }

                                    handle: Rectangle {
                                        x: callRingSlider.leftPadding + callRingSlider.visualPosition * (callRingSlider.availableWidth - width)
                                        y: callRingSlider.topPadding + callRingSlider.availableHeight / 2 - height / 2
                                        implicitWidth: 30
                                        implicitHeight: 30
                                        radius: 15
                                        color: "#0F172A"
                                        border.color: "#FFFFFF"
                                        border.width: 3.5

                                        scale: callRingSlider.pressed ? 1.15 : 1.0
                                        Behavior on scale { NumberAnimation { duration: 100 } }
                                    }
                                }
                            }
                        }
                    }
                }

                // -------------------------------------------------------------
                // LEVEL 2G: Ringtones Sub-screen
                // -------------------------------------------------------------
                Item {
                    id: soundRingtonesView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    x: root.soundCurrentScreen === "ringtones" ? 0 : parent.width
                    opacity: root.soundCurrentScreen === "ringtones" ? 1.0 : 0.0
                    enabled: root.soundCurrentScreen === "ringtones"
                    visible: opacity > 0.001

                    Behavior on x { NumberAnimation { duration: 280; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 240; easing.type: Easing.InOutQuad } }

                    Flickable {
                        anchors.fill: parent
                        contentHeight: ringtonesCol.height + 40
                        clip: true
                        boundsBehavior: Flickable.DragAndOvershootBounds

                        Column {
                            id: ringtonesCol
                            width: parent.width
                            spacing: 0

                            Repeater {
                                model: [
                                    "Default ringtone",
                                    "Apex Chime",
                                    "Apex Symphony",
                                    "Digital Horizon",
                                    "Acoustic Melody"
                                ]

                                SettingRowRadio {
                                    title: modelData
                                    selected: root.soundRingtone === modelData
                                    onSelectedRequested: {
                                        root.soundRingtone = modelData;
                                    }
                                }
                            }
                        }
                    }
                }

                // -------------------------------------------------------------
                // LEVEL 2H: Notification sounds Sub-screen
                // -------------------------------------------------------------
                Item {
                    id: soundNotificationSoundsView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    x: root.soundCurrentScreen === "notification_sounds" ? 0 : parent.width
                    opacity: root.soundCurrentScreen === "notification_sounds" ? 1.0 : 0.0
                    enabled: root.soundCurrentScreen === "notification_sounds"
                    visible: opacity > 0.001

                    Behavior on x { NumberAnimation { duration: 280; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 240; easing.type: Easing.InOutQuad } }

                    Flickable {
                        anchors.fill: parent
                        contentHeight: notifSoundsCol.height + 40
                        clip: true
                        boundsBehavior: Flickable.DragAndOvershootBounds

                        Column {
                            id: notifSoundsCol
                            width: parent.width
                            spacing: 0

                            Repeater {
                                model: [
                                    "Default notification",
                                    "Gentle Bell",
                                    "Soft Chime",
                                    "Subtle Pulse",
                                    "Aura Tone"
                                ]

                                SettingRowRadio {
                                    title: modelData
                                    selected: root.soundNotificationSound === modelData
                                    onSelectedRequested: {
                                        root.soundNotificationSound = modelData;
                                    }
                                }
                            }
                        }
                    }
                }
            }

            // =================================================================
            // CATEGORY: BLUETOOTH (Pixel-perfect match to OEM photo)
            // =================================================================
            Item {
                id: bluetoothCategoryPanel
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                visible: root.activeCategory === "bluetooth"

                // -------------------------------------------------------------
                // VIEW 1: Connect to Bluetooth (Exact layout from user photo)
                // Visible when Bluetooth is ON and no phone is connected
                // -------------------------------------------------------------
                Item {
                    id: btConnectView
                    anchors.fill: parent
                    visible: root.bluetoothEnabled && !PhoneBackend.isConnected && !root.btPairingActive

                    Column {
                        anchors.centerIn: parent
                        anchors.verticalCenterOffset: -20
                        spacing: 18
                        width: parent.width

                        // Title: "Connect to Bluetooth"
                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "Connect to Bluetooth"
                            font.family: "Inter"
                            font.pixelSize: 32
                            font.weight: Font.Bold
                            color: "#FFFFFF"
                        }

                        // Subtitle: 2 lines centered exactly matching photo
                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "To make or receive calls, first connect your\nphone to your vehicle using Bluetooth"
                            font.family: "Inter"
                            font.pixelSize: 18
                            font.weight: Font.Normal
                            color: "#8FA3BF"
                            horizontalAlignment: Text.AlignHCenter
                            lineHeight: 1.35
                        }

                        Item { width: 1; height: 6 }

                        // "Add device" Button with warm coral/amber border
                        Rectangle {
                            id: addDeviceBtn
                            anchors.horizontalCenter: parent.horizontalCenter
                            width: 172
                            height: 48
                            radius: 12
                            color: addDevMouse.pressed ? Qt.rgba(226/255, 139/255, 82/255, 0.28) :
                                   (addDevMouse.containsMouse ? Qt.rgba(226/255, 139/255, 82/255, 0.12) : "transparent")
                            border.color: "#E28B52"
                            border.width: 1.8

                            Behavior on color { ColorAnimation { duration: 150 } }

                            Text {
                                anchors.centerIn: parent
                                text: "Add device"
                                font.family: "Inter"
                                font.pixelSize: 18
                                font.weight: Font.Medium
                                color: "#FFFFFF"
                            }

                            MouseArea {
                                id: addDevMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    root.btPairingActive = true;
                                    root.btSearching = true;
                                    btScanTimer.restart();
                                }
                            }
                        }
                    }
                }

                // -------------------------------------------------------------
                // VIEW 2: Bluetooth Device Discovery & Pairing Flow
                // -------------------------------------------------------------
                Item {
                    id: btPairingView
                    anchors.fill: parent
                    visible: root.bluetoothEnabled && root.btPairingActive

                    Timer {
                        id: btScanTimer
                        interval: 1800
                        onTriggered: {
                            root.btSearching = false;
                        }
                    }

                    Column {
                        anchors.centerIn: parent
                        spacing: 20
                        width: Math.min(parent.width - 60, 480)

                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: root.btSearching ? "Searching for devices..." : "Select Your Phone"
                            font.family: "Inter"
                            font.pixelSize: 26
                            font.weight: Font.Bold
                            color: "#FFFFFF"
                        }

                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: root.btSearching ?
                                  "Make sure Bluetooth is turned on and discoverable on your phone" :
                                  "Tap your device below to pair with APEX VISION IVI"
                            font.family: "Inter"
                            font.pixelSize: 15
                            color: "#8FA3BF"
                            horizontalAlignment: Text.AlignHCenter
                        }

                        // Searching radar/spinner animation
                        Rectangle {
                            anchors.horizontalCenter: parent.horizontalCenter
                            width: 50
                            height: 50
                            radius: 25
                            color: Qt.rgba(226/255, 139/255, 82/255, 0.15)
                            border.color: "#E28B52"
                            border.width: 1.5
                            visible: root.btSearching

                            SequentialAnimation on scale {
                                running: root.btSearching
                                loops: Animation.Infinite
                                NumberAnimation { from: 0.85; to: 1.25; duration: 800; easing.type: Easing.InOutQuad }
                                NumberAnimation { from: 1.25; to: 0.85; duration: 800; easing.type: Easing.InOutQuad }
                            }

                            Image {
                                anchors.centerIn: parent
                                width: 22
                                height: 22
                                source: "qrc:/ApexVision/qml/assets/icons/setting_bluetooth_white.png"
                                fillMode: Image.PreserveAspectFit
                            }
                        }

                        // Discovered Devices list
                        Column {
                            width: parent.width
                            spacing: 12
                            visible: !root.btSearching

                            // Device 1: iPhone 16 Pro
                            Rectangle {
                                width: parent.width
                                height: 60
                                radius: 12
                                color: Qt.rgba(255, 255, 255, 0.08)
                                border.color: Qt.rgba(255, 255, 255, 0.16)
                                border.width: 1

                                Row {
                                    anchors.left: parent.left
                                    anchors.leftMargin: 16
                                    anchors.verticalCenter: parent.verticalCenter
                                    spacing: 14

                                    Image {
                                        anchors.verticalCenter: parent.verticalCenter
                                        width: 24
                                        height: 24
                                        source: "qrc:/ApexVision/qml/assets/icons/setting_bluetooth_yellow.png"
                                        fillMode: Image.PreserveAspectFit
                                    }

                                    Column {
                                        anchors.verticalCenter: parent.verticalCenter
                                        spacing: 2
                                        Text {
                                            text: PhoneBackend.deviceName !== "" ? PhoneBackend.deviceName : "iPhone 16 Pro"
                                            font.family: "Inter"
                                            font.pixelSize: 16
                                            font.weight: Font.DemiBold
                                            color: "#FFFFFF"
                                        }
                                        Text {
                                            text: "Ready to pair • Audio & Calls"
                                            font.family: "Inter"
                                            font.pixelSize: 12
                                            color: "#8FA3BF"
                                        }
                                    }
                                }

                                Rectangle {
                                    anchors.right: parent.right
                                    anchors.rightMargin: 14
                                    anchors.verticalCenter: parent.verticalCenter
                                    width: 80
                                    height: 36
                                    radius: 8
                                    color: pair1Mouse.pressed ? "#C97036" : (pair1Mouse.containsMouse ? "#E8955C" : "#E28B52")

                                    Text {
                                        anchors.centerIn: parent
                                        text: "Pair"
                                        font.family: "Inter"
                                        font.pixelSize: 14
                                        font.weight: Font.DemiBold
                                        color: "#FFFFFF"
                                    }

                                    MouseArea {
                                        id: pair1Mouse
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: {
                                            PhoneBackend.setConnected(true);
                                            root.btPairingActive = false;
                                        }
                                    }
                                }
                            }

                            // Device 2: Pixel 9 Pro
                            Rectangle {
                                width: parent.width
                                height: 60
                                radius: 12
                                color: Qt.rgba(255, 255, 255, 0.08)
                                border.color: Qt.rgba(255, 255, 255, 0.16)
                                border.width: 1

                                Row {
                                    anchors.left: parent.left
                                    anchors.leftMargin: 16
                                    anchors.verticalCenter: parent.verticalCenter
                                    spacing: 14

                                    Image {
                                        anchors.verticalCenter: parent.verticalCenter
                                        width: 24
                                        height: 24
                                        source: "qrc:/ApexVision/qml/assets/icons/setting_bluetooth_white.png"
                                        fillMode: Image.PreserveAspectFit
                                    }

                                    Column {
                                        anchors.verticalCenter: parent.verticalCenter
                                        spacing: 2
                                        Text {
                                            text: "Google Pixel 9 Pro"
                                            font.family: "Inter"
                                            font.pixelSize: 16
                                            font.weight: Font.DemiBold
                                            color: "#FFFFFF"
                                        }
                                        Text {
                                            text: "Discovered nearby"
                                            font.family: "Inter"
                                            font.pixelSize: 12
                                            color: "#8FA3BF"
                                        }
                                    }
                                }

                                Rectangle {
                                    anchors.right: parent.right
                                    anchors.rightMargin: 14
                                    anchors.verticalCenter: parent.verticalCenter
                                    width: 80
                                    height: 36
                                    radius: 8
                                    color: pair2Mouse.pressed ? "#C97036" : (pair2Mouse.containsMouse ? "#E8955C" : "#E28B52")

                                    Text {
                                        anchors.centerIn: parent
                                        text: "Pair"
                                        font.family: "Inter"
                                        font.pixelSize: 14
                                        font.weight: Font.DemiBold
                                        color: "#FFFFFF"
                                    }

                                    MouseArea {
                                        id: pair2Mouse
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: {
                                            PhoneBackend.setConnected(true);
                                            root.btPairingActive = false;
                                        }
                                    }
                                }
                            }
                        }

                        // Cancel / Back to empty state button
                        Rectangle {
                            anchors.horizontalCenter: parent.horizontalCenter
                            width: 120
                            height: 38
                            radius: 8
                            color: cancelPairMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.12) : "transparent"
                            border.color: Qt.rgba(255, 255, 255, 0.25)
                            border.width: 1

                            Text {
                                anchors.centerIn: parent
                                text: "Cancel"
                                font.family: "Inter"
                                font.pixelSize: 15
                                color: "#CBD5E1"
                            }

                            MouseArea {
                                id: cancelPairMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    root.btPairingActive = false;
                                    root.btSearching = false;
                                }
                            }
                        }
                    }
                }

                // -------------------------------------------------------------
                // VIEW 3: Device Connected State
                // -------------------------------------------------------------
                Item {
                    id: btConnectedView
                    anchors.fill: parent
                    visible: root.bluetoothEnabled && PhoneBackend.isConnected && !root.btPairingActive

                    Column {
                        anchors.centerIn: parent
                        spacing: 24
                        width: Math.min(parent.width - 60, 480)

                        // Connected Device Card
                        Rectangle {
                            width: parent.width
                            height: 90
                            radius: 16
                            color: Qt.rgba(255, 255, 255, 0.08)
                            border.color: Qt.rgba(226/255, 139/255, 82/255, 0.4)
                            border.width: 1.5

                            Row {
                                anchors.left: parent.left
                                anchors.leftMargin: 20
                                anchors.verticalCenter: parent.verticalCenter
                                spacing: 16

                                Rectangle {
                                    width: 48
                                    height: 48
                                    radius: 24
                                    color: Qt.rgba(226/255, 139/255, 82/255, 0.18)

                                    Image {
                                        anchors.centerIn: parent
                                        width: 26
                                        height: 26
                                        source: "qrc:/ApexVision/qml/assets/icons/setting_bluetooth_yellow.png"
                                        fillMode: Image.PreserveAspectFit
                                    }
                                }

                                Column {
                                    anchors.verticalCenter: parent.verticalCenter
                                    spacing: 4

                                    Text {
                                        text: PhoneBackend.deviceName !== "" ? PhoneBackend.deviceName : "iPhone 16 Pro"
                                        font.family: "Inter"
                                        font.pixelSize: 18
                                        font.weight: Font.Bold
                                        color: "#FFFFFF"
                                    }

                                    Row {
                                        spacing: 8
                                        Rectangle {
                                            anchors.verticalCenter: parent.verticalCenter
                                            width: 8
                                            height: 8
                                            radius: 4
                                            color: "#10B981"
                                        }
                                        Text {
                                            anchors.verticalCenter: parent.verticalCenter
                                            text: "Connected • Audio & Calls • Battery " + PhoneBackend.batteryPercent + "%"
                                            font.family: "Inter"
                                            font.pixelSize: 13
                                            color: "#94A3B8"
                                        }
                                    }
                                }
                            }

                            // Disconnect Button
                            Rectangle {
                                anchors.right: parent.right
                                anchors.rightMargin: 16
                                anchors.verticalCenter: parent.verticalCenter
                                width: 104
                                height: 38
                                radius: 8
                                color: disconnectMouse.pressed ? Qt.rgba(239/255, 68/255, 68/255, 0.3) :
                                       (disconnectMouse.containsMouse ? Qt.rgba(239/255, 68/255, 68/255, 0.18) : "transparent")
                                border.color: Qt.rgba(239/255, 68/255, 68/255, 0.6)
                                border.width: 1

                                Text {
                                    anchors.centerIn: parent
                                    text: "Disconnect"
                                    font.family: "Inter"
                                    font.pixelSize: 14
                                    font.weight: Font.Medium
                                    color: "#FCA5A5"
                                }

                                MouseArea {
                                    id: disconnectMouse
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                        PhoneBackend.setConnected(false);
                                    }
                                }
                            }
                        }

                        // Secondary actions
                        Row {
                            anchors.horizontalCenter: parent.horizontalCenter
                            spacing: 16

                            Rectangle {
                                width: 160
                                height: 42
                                radius: 10
                                color: addAnotherMouse.containsMouse ? Qt.rgba(226/255, 139/255, 82/255, 0.18) : "transparent"
                                border.color: "#E28B52"
                                border.width: 1.5

                                Text {
                                    anchors.centerIn: parent
                                    text: "+ Add new device"
                                    font.family: "Inter"
                                    font.pixelSize: 15
                                    font.weight: Font.Medium
                                    color: "#FFFFFF"
                                }

                                MouseArea {
                                    id: addAnotherMouse
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                        root.btPairingActive = true;
                                        root.btSearching = true;
                                        btScanTimer.restart();
                                    }
                                }
                            }
                        }
                    }
                }

                // -------------------------------------------------------------
                // VIEW 4: Bluetooth Master Power OFF State
                // -------------------------------------------------------------
                Item {
                    id: btDisabledView
                    anchors.fill: parent
                    visible: !root.bluetoothEnabled

                    Column {
                        anchors.centerIn: parent
                        spacing: 16

                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "Bluetooth is Turned Off"
                            font.family: "Inter"
                            font.pixelSize: 28
                            font.weight: Font.Bold
                            color: "#FFFFFF"
                        }

                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "Turn on Bluetooth using the toggle above to connect devices and enable hands-free calls"
                            font.family: "Inter"
                            font.pixelSize: 16
                            color: "#8FA3BF"
                            horizontalAlignment: Text.AlignHCenter
                        }

                        Item { width: 1; height: 8 }

                        Rectangle {
                            anchors.horizontalCenter: parent.horizontalCenter
                            width: 130
                            height: 44
                            radius: 10
                            color: "#E29D68"

                            Text {
                                anchors.centerIn: parent
                                text: "Turn On"
                                font.family: "Inter"
                                font.pixelSize: 16
                                font.weight: Font.DemiBold
                                color: "#FFFFFF"
                            }

                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: root.bluetoothEnabled = true
                            }
                        }
                    }
                }
            }

            // =================================================================
            // CATEGORY: SYSTEM
            // =================================================================
            // =================================================================
            // CATEGORY: SYSTEM (Languages & input suite matching OEM photo)
            // =================================================================
            Item {
                id: systemContainer
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                clip: true
                visible: root.activeCategory === "system"

                // -------------------------------------------------------------
                // LEVEL 1: System Main View
                // -------------------------------------------------------------
                Item {
                    id: sysMainView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    x: root.sysCurrentScreen === "main" ? 0 : -parent.width * 0.4
                    opacity: root.sysCurrentScreen === "main" ? 1.0 : 0.0
                    enabled: root.sysCurrentScreen === "main"
                    visible: opacity > 0.001 || x > -parent.width * 0.4

                    Behavior on x { NumberAnimation { duration: 320; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 280; easing.type: Easing.InOutQuad } }

                    Flickable {
                        anchors.fill: parent
                        contentHeight: sysMainCol.height + 40
                        clip: true
                        boundsBehavior: Flickable.DragAndOvershootBounds
                        flickableDirection: Flickable.VerticalFlick

                        Column {
                            id: sysMainCol
                            width: parent.width
                            spacing: 0

                            SettingRowChevron {
                                iconSource: "qrc:/ApexVision/qml/assets/icons/icon_globe.svg"
                                title: "Languages & input"
                                onClicked: {
                                    root.sysSlideDir = 1;
                                    root.sysCurrentScreen = "languages_input";
                                }
                            }

                            SettingRowChevron {
                                iconSource: "qrc:/ApexVision/qml/assets/icons/icon_units_speedo.svg"
                                title: "Units"
                                subtitle: root.unitsMeasurement
                                onClicked: {
                                    root.sysSlideDir = 1;
                                    root.sysCurrentScreen = "units";
                                }
                            }

                            SettingRowChevron {
                                iconSource: "qrc:/ApexVision/qml/assets/icons/icon_time_clock.svg"
                                title: "Time"
                                subtitle: (root.time24HourFormat ? "24-hour" : "12-hour") + ((typeof SystemBackend !== "undefined" && SystemBackend.currentTime) ? (" • " + SystemBackend.currentTime) : "")
                                onClicked: {
                                    root.sysSlideDir = 1;
                                    root.sysCurrentScreen = "time";
                                }
                            }

                            SettingRowChevron {
                                iconSource: "qrc:/ApexVision/qml/assets/icons/icon_reset_options.svg"
                                title: "Reset options"
                                infoText: "Reset system settings, connectivity preferences, personal profiles, or restore factory default settings."
                                onClicked: {
                                    root.sysSlideDir = 1;
                                    root.sysCurrentScreen = "reset_options";
                                }
                                onInfoClicked: root.activeInfoText = infoText
                            }

                            SettingRowChevron {
                                iconSource: "qrc:/ApexVision/qml/assets/icons/icon_about_info.svg"
                                title: "About"
                                subtitle: "ApexOS 2.4"
                                infoText: "Vehicle hardware specifications, Linux kernel, firmware revision, and system status."
                                onClicked: {
                                    root.sysSlideDir = 1;
                                    root.sysCurrentScreen = "about";
                                }
                                onInfoClicked: root.activeInfoText = infoText
                            }

                            SettingRowChevron {
                                iconSource: "qrc:/ApexVision/qml/assets/icons/icon_legal_info.svg"
                                title: "Legal information"
                                infoText: "Open source software licenses, privacy policy, terms of service, and regulatory declarations."
                                onClicked: {
                                    root.sysSlideDir = 1;
                                    root.sysCurrentScreen = "legal_info";
                                }
                                onInfoClicked: root.activeInfoText = infoText
                            }

                            SettingRowChevron {
                                iconSource: "qrc:/ApexVision/qml/assets/icons/icon_software_licenses.svg"
                                title: "Software licenses"
                                infoText: "Third-party open source component notices and compliance details."
                                onClicked: {
                                    root.sysSlideDir = 1;
                                    root.sysCurrentScreen = "software_licenses";
                                }
                                onInfoClicked: root.activeInfoText = infoText
                            }

                            SettingRowChevron {
                                iconSource: "qrc:/ApexVision/qml/assets/icons/icon_storage.svg"
                                title: "Storage"
                                infoText: "View system drive capacity, downloaded apps, media storage, and offline navigation maps."
                                onClicked: {
                                    root.sysSlideDir = 1;
                                    root.sysCurrentScreen = "storage";
                                }
                                onInfoClicked: root.activeInfoText = infoText
                            }

                            SettingRowChevron {
                                iconSource: "qrc:/ApexVision/qml/assets/icons/icon_software_update.svg"
                                title: "Software updates"
                                infoText: "Check for over-the-air firmware updates and software security patches."
                                onClicked: {
                                    root.sysSlideDir = 1;
                                    root.sysCurrentScreen = "system_update";
                                }
                                onInfoClicked: root.activeInfoText = infoText
                            }

                            SettingRowChevron {
                                iconSource: "qrc:/ApexVision/qml/assets/icons/icon_phone_link.svg"
                                title: "Smart Phone Link"
                                subtitle: "Wireless Projection & Mirroring"
                                infoText: "Connect your smartphone for wireless projection and media integration."
                                onClicked: {
                                    root.sysSlideDir = 1;
                                    root.sysCurrentScreen = "phone_link";
                                }
                                onInfoClicked: root.activeInfoText = infoText
                            }
                        }
                    }
                }

                // -------------------------------------------------------------
                // LEVEL 2A: Languages & input Sub-Menu (Exact match to OEM photo)
                // -------------------------------------------------------------
                Item {
                    id: sysLanguagesInputView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    x: root.sysCurrentScreen === "languages_input" ? 0 :
                       (root.sysCurrentScreen === "main" ? parent.width : -parent.width * 0.4)
                    opacity: root.sysCurrentScreen === "languages_input" ? 1.0 : 0.0
                    enabled: root.sysCurrentScreen === "languages_input"
                    visible: opacity > 0.001 || (x > -parent.width * 0.4 && x < parent.width)

                    Behavior on x { NumberAnimation { duration: 320; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 280; easing.type: Easing.InOutQuad } }

                    Flickable {
                        anchors.fill: parent
                        contentHeight: sysLangInputCol.height + 40
                        clip: true
                        boundsBehavior: Flickable.DragAndOvershootBounds
                        flickableDirection: Flickable.VerticalFlick

                        Column {
                            id: sysLangInputCol
                            width: parent.width
                            spacing: 0

                            // 1. Languages
                            SettingRowChevron {
                                iconSource: "qrc:/ApexVision/qml/assets/icons/icon_translate.svg"
                                title: "Languages"
                                subtitle: root.selectedLanguage
                                onClicked: {
                                    root.sysSlideDir = 1;
                                    root.sysCurrentScreen = "languages_select";
                                }
                            }

                            // 2. Autofill service
                            SettingRowChevron {
                                iconSource: "qrc:/ApexVision/qml/assets/icons/icon_google.svg"
                                title: "Autofill service"
                                subtitle: root.selectedAutofill
                                customTrailingIcon: "qrc:/ApexVision/qml/assets/icons/icon_settings_gear.svg"
                                onClicked: {
                                    root.sysSlideDir = 1;
                                    root.sysCurrentScreen = "autofill_service";
                                }
                            }

                            // 3. Keyboard
                            SettingRowChevron {
                                indentWithIcon: true
                                title: "Keyboard"
                                subtitle: root.selectedKeyboard
                                onClicked: {
                                    root.sysSlideDir = 1;
                                    root.sysCurrentScreen = "keyboard_settings";
                                }
                            }

                            // 4. Text-to-speech output
                            SettingRowChevron {
                                indentWithIcon: true
                                title: "Text-to-speech output"
                                subtitle: root.ttsEngine
                                onClicked: {
                                    root.sysSlideDir = 1;
                                    root.sysCurrentScreen = "tts_settings";
                                }
                            }

                            // 5. Pointer speed
                            SettingRowSlider {
                                title: "Pointer speed"
                                subtitle: root.pointerSpeed <= 30 ? "Slow" : (root.pointerSpeed >= 70 ? "Fast" : "Normal")
                                value: root.pointerSpeed
                                onMovedVal: function(v) {
                                    root.pointerSpeed = v;
                                    if (typeof SystemBackend !== "undefined") SystemBackend.setPointerSpeed(v);
                                }
                            }

                            // 6. Personal dictionary
                            SettingRowChevron {
                                indentWithIcon: true
                                title: "Personal dictionary"
                                subtitle: root.selectedLanguage.indexOf("Hindi") !== -1 ? "हिंदी और अंग्रेज़ी शब्दावली" : "Custom shortcuts & terms"
                                onClicked: {
                                    root.sysSlideDir = 1;
                                    root.sysCurrentScreen = "personal_dictionary";
                                }
                            }
                        }
                    }
                }

                // -------------------------------------------------------------
                // LEVEL 2B: Units Sub-Menu
                // -------------------------------------------------------------
                Item {
                    id: sysUnitsView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    x: root.sysCurrentScreen === "units" ? 0 :
                       ((root.sysCurrentScreen === "units_temperature" || root.sysCurrentScreen === "units_measurement" || root.sysCurrentScreen === "units_pressure" || root.sysCurrentScreen === "units_weight") ? -parent.width * 0.4 :
                       (root.sysCurrentScreen === "main" ? parent.width : -parent.width * 0.4))
                    opacity: root.sysCurrentScreen === "units" ? 1.0 : 0.0
                    enabled: root.sysCurrentScreen === "units"
                    visible: opacity > 0.001 || (x > -parent.width * 0.4 && x < parent.width)

                    Behavior on x { NumberAnimation { duration: 320; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 280; easing.type: Easing.InOutQuad } }

                    Flickable {
                        anchors.fill: parent
                        contentHeight: sysUnitsCol.height + 60
                        clip: true
                        boundsBehavior: Flickable.DragAndOvershootBounds
                        flickableDirection: Flickable.VerticalFlick

                        Column {
                            id: sysUnitsCol
                            width: parent.width
                            spacing: 0

                            SettingRowChevron {
                                title: "Temperature unit"
                                subtitle: root.unitsTemperature
                                infoText: "Select temperature display unit in Celsius or Fahrenheit."
                                onClicked: {
                                    root.sysSlideDir = 1;
                                    root.sysCurrentScreen = "units_temperature";
                                }
                                onInfoClicked: root.activeInfoText = infoText
                            }

                            SettingRowChevron {
                                title: "Measurement unit"
                                subtitle: root.unitsMeasurement
                                infoText: "Select trip measurement units for distance and fuel consumption."
                                onClicked: {
                                    root.sysSlideDir = 1;
                                    root.sysCurrentScreen = "units_measurement";
                                }
                                onInfoClicked: root.activeInfoText = infoText
                            }

                            SettingRowChevron {
                                title: "Tire pressure unit"
                                subtitle: root.unitsPressure
                                infoText: "Select tire pressure unit for TPMS diagnostic readouts."
                                onClicked: {
                                    root.sysSlideDir = 1;
                                    root.sysCurrentScreen = "units_pressure";
                                }
                                onInfoClicked: root.activeInfoText = infoText
                            }

                            SettingRowChevron {
                                title: "Weight unit"
                                subtitle: root.unitsWeight
                                infoText: "Select weight unit for vehicle cargo and gross vehicle weight ratings."
                                onClicked: {
                                    root.sysSlideDir = 1;
                                    root.sysCurrentScreen = "units_weight";
                                }
                                onInfoClicked: root.activeInfoText = infoText
                            }

                            SettingRowSwitch {
                                title: "Speedometer MPH"
                                checked: root.speedometerMph
                                infoText: "Show secondary miles per hour speed notation on instrument cluster."
                                onToggled: root.speedometerMph = !root.speedometerMph
                                onInfoClicked: root.activeInfoText = infoText
                            }
                        }
                    }
                }

                // -------------------------------------------------------------
                // LEVEL 2C: Time Sub-Menu
                // -------------------------------------------------------------
                Item {
                    id: sysTimeView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    x: root.sysCurrentScreen === "time" ? 0 :
                       (root.sysCurrentScreen === "time_zone" ? -parent.width * 0.4 :
                       (root.sysCurrentScreen === "main" ? parent.width : -parent.width * 0.4))
                    opacity: root.sysCurrentScreen === "time" ? 1.0 : 0.0
                    enabled: root.sysCurrentScreen === "time"
                    visible: opacity > 0.001 || (x > -parent.width * 0.4 && x < parent.width)

                    Behavior on x { NumberAnimation { duration: 320; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 280; easing.type: Easing.InOutQuad } }

                    Flickable {
                        anchors.fill: parent
                        contentHeight: sysTimeCol.height + 40
                        clip: true
                        boundsBehavior: Flickable.DragAndOvershootBounds
                        flickableDirection: Flickable.VerticalFlick

                        Column {
                            id: sysTimeCol
                            width: parent.width
                            spacing: 0

                            SettingRowSwitch {
                                title: "Set time zone automatically"
                                checked: root.timeAutoZone
                                onToggled: {
                                    root.timeAutoZone = !root.timeAutoZone;
                                    if (typeof SystemBackend !== "undefined") {
                                        SystemBackend.autoTimeZoneEnabled = root.timeAutoZone;
                                    }
                                }
                            }

                            SettingRowChevron {
                                title: "Select time zone"
                                subtitle: root.selectedTimeZone
                                isEnabled: !root.timeAutoZone
                                opacity: root.timeAutoZone ? 0.35 : 1.0
                                showChevron: false
                                onClicked: {
                                    if (!root.timeAutoZone) {
                                        root.sysSlideDir = 1;
                                        root.sysCurrentScreen = "time_zone";
                                    }
                                }
                            }

                            SettingRowSwitch {
                                title: "Use 24-hour format"
                                checked: (typeof SystemBackend !== "undefined") ? SystemBackend.is24HourFormat : root.time24HourFormat
                                subtitle: checked ? "13:00" : "11:11"
                                onToggled: {
                                    if (typeof SystemBackend !== "undefined") {
                                        SystemBackend.setIs24HourFormat(!SystemBackend.is24HourFormat);
                                        root.time24HourFormat = SystemBackend.is24HourFormat;
                                    } else {
                                        root.time24HourFormat = !root.time24HourFormat;
                                    }
                                }
                            }
                        }
                    }
                }

                // -------------------------------------------------------------
                // -------------------------------------------------------------
                // LEVEL 2D: Reset Options Sub-Menu (Matches Image 2 & 3)
                // -------------------------------------------------------------
                Item {
                    id: sysResetOptionsView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    x: root.sysCurrentScreen === "reset_options" ? 0 :
                       ((root.sysCurrentScreen === "factory_reset" || root.sysCurrentScreen === "reset_hotspot" || root.sysCurrentScreen === "reset_paak" || root.sysCurrentScreen === "reset_apps" || root.sysCurrentScreen === "reset_connectivity") ? -parent.width * 0.4 :
                       (root.sysCurrentScreen === "main" ? parent.width : -parent.width * 0.4))
                    opacity: root.sysCurrentScreen === "reset_options" ? 1.0 : 0.0
                    enabled: root.sysCurrentScreen === "reset_options"
                    visible: opacity > 0.001 || (x > -parent.width * 0.4 && x < parent.width)

                    Behavior on x { NumberAnimation { duration: 320; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 280; easing.type: Easing.InOutQuad } }

                    Flickable {
                        anchors.fill: parent
                        contentHeight: sysResetCol.height + 40
                        clip: true
                        boundsBehavior: Flickable.DragAndOvershootBounds
                        flickableDirection: Flickable.VerticalFlick

                        Column {
                            id: sysResetCol
                            width: parent.width
                            spacing: 0

                            SettingRowChevron {
                                title: "Hotspot reset"
                                infoText: "Reset Wi-Fi hotspot configuration, connected client lists, and password to factory defaults."
                                onClicked: {
                                    root.sysSlideDir = 1;
                                    root.sysCurrentScreen = "reset_hotspot";
                                }
                                onInfoClicked: root.activeInfoText = infoText
                            }

                            SettingRowChevron {
                                title: "Phone As A Key reset"
                                infoText: "Remove all paired virtual smartphone keys and cryptographic vehicle access tokens."
                                onClicked: {
                                    root.sysSlideDir = 1;
                                    root.sysCurrentScreen = "reset_paak";
                                }
                                onInfoClicked: root.activeInfoText = infoText
                            }

                            SettingRowChevron {
                                title: "App preference reset"
                                infoText: "Reset app permissions, default applications, and notification preferences."
                                onClicked: {
                                    root.sysSlideDir = 1;
                                    root.sysCurrentScreen = "reset_apps";
                                }
                                onInfoClicked: root.activeInfoText = infoText
                            }

                            SettingRowChevron {
                                title: "Connectivity reset"
                                infoText: "Reset Bluetooth pairings, mobile network profiles, and saved Wi-Fi connections."
                                onClicked: {
                                    root.sysSlideDir = 1;
                                    root.sysCurrentScreen = "reset_connectivity";
                                }
                                onInfoClicked: root.activeInfoText = infoText
                            }

                            SettingRowChevron {
                                title: "Factory reset"
                                infoText: "Permanently erase all personal data, accounts, settings, and downloaded apps."
                                onClicked: {
                                    root.sysSlideDir = 1;
                                    root.sysCurrentScreen = "factory_reset";
                                }
                                onInfoClicked: root.activeInfoText = infoText
                            }
                        }
                    }
                }

                // -------------------------------------------------------------
                // LEVEL 3K: Factory Reset Sub-Menu (Matches Image 1)
                // -------------------------------------------------------------
                Item {
                    id: sysFactoryResetView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    x: root.sysCurrentScreen === "factory_reset" ? 0 : parent.width
                    opacity: root.sysCurrentScreen === "factory_reset" ? 1.0 : 0.0
                    enabled: root.sysCurrentScreen === "factory_reset"
                    visible: opacity > 0.001 || x < parent.width

                    Behavior on x { NumberAnimation { duration: 320; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 280; easing.type: Easing.InOutQuad } }

                    Flickable {
                        anchors.fill: parent
                        contentHeight: factoryResetCol.height + 60
                        clip: true
                        boundsBehavior: Flickable.DragAndOvershootBounds
                        flickableDirection: Flickable.VerticalFlick

                        Column {
                            id: factoryResetCol
                            width: parent.width - 32
                            anchors.horizontalCenter: parent.horizontalCenter
                            spacing: 28

                            Item { width: 1; height: 16 }

                            // Header explanation text (matches photo exact wording)
                            Text {
                                width: parent.width
                                text: "This will erase all data from your vehicle’s\ninfotainment system, including:"
                                color: "#FFFFFF"
                                font.family: "Inter"
                                font.pixelSize: 24
                                font.weight: Font.Normal
                                lineHeight: 1.3
                                wrapMode: Text.WordWrap
                            }

                            // Bulleted items (matches photo exact items)
                            Column {
                                width: parent.width
                                spacing: 18

                                Row {
                                    spacing: 14
                                    Text {
                                        text: "•"
                                        color: "#FFFFFF"
                                        font.pixelSize: 24
                                        font.weight: Font.Bold
                                    }
                                    Text {
                                        text: "Your Apex ID and User Profiles"
                                        color: "#FFFFFF"
                                        font.family: "Inter"
                                        font.pixelSize: 22
                                        font.weight: Font.Normal
                                    }
                                }

                                Row {
                                    spacing: 14
                                    Text {
                                        text: "•"
                                        color: "#FFFFFF"
                                        font.pixelSize: 24
                                        font.weight: Font.Bold
                                    }
                                    Text {
                                        text: "System and app data and settings"
                                        color: "#FFFFFF"
                                        font.family: "Inter"
                                        font.pixelSize: 22
                                        font.weight: Font.Normal
                                    }
                                }

                                Row {
                                    spacing: 14
                                    Text {
                                        text: "•"
                                        color: "#FFFFFF"
                                        font.pixelSize: 24
                                        font.weight: Font.Bold
                                    }
                                    Text {
                                        text: "Downloaded apps"
                                        color: "#FFFFFF"
                                        font.family: "Inter"
                                        font.pixelSize: 22
                                        font.weight: Font.Normal
                                    }
                                }
                            }
                        }
                    }
                }

                // -------------------------------------------------------------
                // LEVEL 3L: Hotspot Reset Sub-Menu
                // -------------------------------------------------------------
                Item {
                    id: sysResetHotspotView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    x: root.sysCurrentScreen === "reset_hotspot" ? 0 : parent.width
                    opacity: root.sysCurrentScreen === "reset_hotspot" ? 1.0 : 0.0
                    enabled: root.sysCurrentScreen === "reset_hotspot"
                    visible: opacity > 0.001 || x < parent.width

                    Behavior on x { NumberAnimation { duration: 320; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 280; easing.type: Easing.InOutQuad } }

                    Flickable {
                        anchors.fill: parent
                        contentHeight: sysHotspotResetCol.height + 60
                        clip: true
                        boundsBehavior: Flickable.DragAndOvershootBounds
                        flickableDirection: Flickable.VerticalFlick

                        Column {
                            id: sysHotspotResetCol
                            width: parent.width - 32
                            anchors.horizontalCenter: parent.horizontalCenter
                            spacing: 28

                            Item { width: 1; height: 16 }

                            Text {
                                width: parent.width
                                text: "This will reset your vehicle's Wi-Fi hotspot configuration to factory defaults, including:"
                                color: "#FFFFFF"
                                font.family: "Inter"
                                font.pixelSize: 24
                                font.weight: Font.Normal
                                lineHeight: 1.3
                                wrapMode: Text.WordWrap
                            }

                            Column {
                                width: parent.width
                                spacing: 18

                                Row {
                                    spacing: 14
                                    Text { text: "•"; color: "#FFFFFF"; font.pixelSize: 24; font.weight: Font.Bold }
                                    Text { text: "Wi-Fi hotspot network name (SSID)"; color: "#FFFFFF"; font.family: "Inter"; font.pixelSize: 22 }
                                }
                                Row {
                                    spacing: 14
                                    Text { text: "•"; color: "#FFFFFF"; font.pixelSize: 24; font.weight: Font.Bold }
                                    Text { text: "Hotspot security key and WPA2/WPA3 password"; color: "#FFFFFF"; font.family: "Inter"; font.pixelSize: 22 }
                                }
                                Row {
                                    spacing: 14
                                    Text { text: "•"; color: "#FFFFFF"; font.pixelSize: 24; font.weight: Font.Bold }
                                    Text { text: "Connected client device blocklist and allowlist"; color: "#FFFFFF"; font.family: "Inter"; font.pixelSize: 22 }
                                }
                                Row {
                                    spacing: 14
                                    Text { text: "•"; color: "#FFFFFF"; font.pixelSize: 24; font.weight: Font.Bold }
                                    Text { text: "Broadcast frequency (2.4 GHz / 5.0 GHz) settings"; color: "#FFFFFF"; font.family: "Inter"; font.pixelSize: 22 }
                                }
                            }
                        }
                    }
                }

                // -------------------------------------------------------------
                // LEVEL 3M: Phone As A Key Reset Sub-Menu
                // -------------------------------------------------------------
                Item {
                    id: sysResetPaakView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    x: root.sysCurrentScreen === "reset_paak" ? 0 : parent.width
                    opacity: root.sysCurrentScreen === "reset_paak" ? 1.0 : 0.0
                    enabled: root.sysCurrentScreen === "reset_paak"
                    visible: opacity > 0.001 || x < parent.width

                    Behavior on x { NumberAnimation { duration: 320; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 280; easing.type: Easing.InOutQuad } }

                    Flickable {
                        anchors.fill: parent
                        contentHeight: sysPaakResetCol.height + 60
                        clip: true
                        boundsBehavior: Flickable.DragAndOvershootBounds
                        flickableDirection: Flickable.VerticalFlick

                        Column {
                            id: sysPaakResetCol
                            width: parent.width - 32
                            anchors.horizontalCenter: parent.horizontalCenter
                            spacing: 24

                            Item { width: 1; height: 12 }

                            Rectangle {
                                width: parent.width
                                height: paakWarnRow.height + 24
                                radius: 12
                                color: Qt.rgba(245, 158, 11, 0.12)
                                border.color: "#F59E0B"
                                border.width: 1

                                Row {
                                    id: paakWarnRow
                                    anchors.left: parent.left
                                    anchors.right: parent.right
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.margins: 14
                                    spacing: 12

                                    Text {
                                        text: "⚠"
                                        color: "#F59E0B"
                                        font.pixelSize: 22
                                    }

                                    Text {
                                        width: parent.width - 40
                                        text: "Make sure you have your physical key fob with you before proceeding. You will need it to start the vehicle until keys are paired again."
                                        color: "#FCD34D"
                                        font.family: "Inter"
                                        font.pixelSize: 16
                                        wrapMode: Text.WordWrap
                                        lineHeight: 1.3
                                    }
                                }
                            }

                            Text {
                                width: parent.width
                                text: "This will remove all paired virtual smartphone keys from your vehicle, including:"
                                color: "#FFFFFF"
                                font.family: "Inter"
                                font.pixelSize: 24
                                font.weight: Font.Normal
                                lineHeight: 1.3
                                wrapMode: Text.WordWrap
                            }

                            Column {
                                width: parent.width
                                spacing: 18

                                Row {
                                    spacing: 14
                                    Text { text: "•"; color: "#FFFFFF"; font.pixelSize: 24; font.weight: Font.Bold }
                                    Text { text: "All paired smartphones with Phone As A Key"; color: "#FFFFFF"; font.family: "Inter"; font.pixelSize: 22 }
                                }
                                Row {
                                    spacing: 14
                                    Text { text: "•"; color: "#FFFFFF"; font.pixelSize: 24; font.weight: Font.Bold }
                                    Text { text: "Passive walk-away lock and welcome unlock permissions"; color: "#FFFFFF"; font.family: "Inter"; font.pixelSize: 22 }
                                }
                                Row {
                                    spacing: 14
                                    Text { text: "•"; color: "#FFFFFF"; font.pixelSize: 24; font.weight: Font.Bold }
                                    Text { text: "Shared digital keys and guest driver invitations"; color: "#FFFFFF"; font.family: "Inter"; font.pixelSize: 22 }
                                }
                                Row {
                                    spacing: 14
                                    Text { text: "•"; color: "#FFFFFF"; font.pixelSize: 24; font.weight: Font.Bold }
                                    Text { text: "Bluetooth Low Energy (BLE) beacon authorizations"; color: "#FFFFFF"; font.family: "Inter"; font.pixelSize: 22 }
                                }
                            }
                        }
                    }
                }

                // -------------------------------------------------------------
                // LEVEL 3N: App Preference Reset Sub-Menu
                // -------------------------------------------------------------
                Item {
                    id: sysResetAppsView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    x: root.sysCurrentScreen === "reset_apps" ? 0 : parent.width
                    opacity: root.sysCurrentScreen === "reset_apps" ? 1.0 : 0.0
                    enabled: root.sysCurrentScreen === "reset_apps"
                    visible: opacity > 0.001 || x < parent.width

                    Behavior on x { NumberAnimation { duration: 320; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 280; easing.type: Easing.InOutQuad } }

                    Flickable {
                        anchors.fill: parent
                        contentHeight: sysAppsResetCol.height + 60
                        clip: true
                        boundsBehavior: Flickable.DragAndOvershootBounds
                        flickableDirection: Flickable.VerticalFlick

                        Column {
                            id: sysAppsResetCol
                            width: parent.width - 32
                            anchors.horizontalCenter: parent.horizontalCenter
                            spacing: 28

                            Item { width: 1; height: 16 }

                            Text {
                                width: parent.width
                                text: "This will reset all preferences for:"
                                color: "#FFFFFF"
                                font.family: "Inter"
                                font.pixelSize: 24
                                font.weight: Font.Normal
                                lineHeight: 1.3
                                wrapMode: Text.WordWrap
                            }

                            Column {
                                width: parent.width
                                spacing: 18

                                Row {
                                    spacing: 14
                                    Text { text: "•"; color: "#FFFFFF"; font.pixelSize: 24; font.weight: Font.Bold }
                                    Text { text: "Disabled applications"; color: "#FFFFFF"; font.family: "Inter"; font.pixelSize: 22 }
                                }
                                Row {
                                    spacing: 14
                                    Text { text: "•"; color: "#FFFFFF"; font.pixelSize: 24; font.weight: Font.Bold }
                                    Text { text: "Notification preferences and alert sounds"; color: "#FFFFFF"; font.family: "Inter"; font.pixelSize: 22 }
                                }
                                Row {
                                    spacing: 14
                                    Text { text: "•"; color: "#FFFFFF"; font.pixelSize: 24; font.weight: Font.Bold }
                                    Text { text: "Default applications for media, navigation, and speech"; color: "#FFFFFF"; font.family: "Inter"; font.pixelSize: 22 }
                                }
                                Row {
                                    spacing: 14
                                    Text { text: "•"; color: "#FFFFFF"; font.pixelSize: 24; font.weight: Font.Bold }
                                    Text { text: "Background data and network access restrictions"; color: "#FFFFFF"; font.family: "Inter"; font.pixelSize: 22 }
                                }
                                Row {
                                    spacing: 14
                                    Text { text: "•"; color: "#FFFFFF"; font.pixelSize: 24; font.weight: Font.Bold }
                                    Text { text: "Any permission restrictions granted to vehicle apps"; color: "#FFFFFF"; font.family: "Inter"; font.pixelSize: 22 }
                                }
                            }

                            Text {
                                width: parent.width
                                text: "You will not lose any existing app data, cached files, or personal accounts."
                                color: "#93C5FD"
                                font.family: "Inter"
                                font.pixelSize: 18
                                font.weight: Font.Normal
                                lineHeight: 1.3
                                wrapMode: Text.WordWrap
                            }
                        }
                    }
                }

                // -------------------------------------------------------------
                // LEVEL 3O: Connectivity Reset Sub-Menu
                // -------------------------------------------------------------
                Item {
                    id: sysResetConnectivityView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    x: root.sysCurrentScreen === "reset_connectivity" ? 0 : parent.width
                    opacity: root.sysCurrentScreen === "reset_connectivity" ? 1.0 : 0.0
                    enabled: root.sysCurrentScreen === "reset_connectivity"
                    visible: opacity > 0.001 || x < parent.width

                    Behavior on x { NumberAnimation { duration: 320; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 280; easing.type: Easing.InOutQuad } }

                    Flickable {
                        anchors.fill: parent
                        contentHeight: sysConnResetCol.height + 60
                        clip: true
                        boundsBehavior: Flickable.DragAndOvershootBounds
                        flickableDirection: Flickable.VerticalFlick

                        Column {
                            id: sysConnResetCol
                            width: parent.width - 32
                            anchors.horizontalCenter: parent.horizontalCenter
                            spacing: 28

                            Item { width: 1; height: 16 }

                            Text {
                                width: parent.width
                                text: "This will reset all network settings on your vehicle's infotainment system, including:"
                                color: "#FFFFFF"
                                font.family: "Inter"
                                font.pixelSize: 24
                                font.weight: Font.Normal
                                lineHeight: 1.3
                                wrapMode: Text.WordWrap
                            }

                            Column {
                                width: parent.width
                                spacing: 18

                                Row {
                                    spacing: 14
                                    Text { text: "•"; color: "#FFFFFF"; font.pixelSize: 24; font.weight: Font.Bold }
                                    Text { text: "All saved Wi-Fi networks and passwords"; color: "#FFFFFF"; font.family: "Inter"; font.pixelSize: 22 }
                                }
                                Row {
                                    spacing: 14
                                    Text { text: "•"; color: "#FFFFFF"; font.pixelSize: 24; font.weight: Font.Bold }
                                    Text { text: "Paired Bluetooth phones, audio devices, and headsets"; color: "#FFFFFF"; font.family: "Inter"; font.pixelSize: 22 }
                                }
                                Row {
                                    spacing: 14
                                    Text { text: "•"; color: "#FFFFFF"; font.pixelSize: 24; font.weight: Font.Bold }
                                    Text { text: "Mobile data APN and eSIM cellular profiles"; color: "#FFFFFF"; font.family: "Inter"; font.pixelSize: 22 }
                                }
                                Row {
                                    spacing: 14
                                    Text { text: "•"; color: "#FFFFFF"; font.pixelSize: 24; font.weight: Font.Bold }
                                    Text { text: "Wi-Fi Direct and wireless screen projection links"; color: "#FFFFFF"; font.family: "Inter"; font.pixelSize: 22 }
                                }
                            }
                        }
                    }
                }

                // -------------------------------------------------------------
                // LEVEL 2E: Storage Sub-Menu (Matches Image 3)
                // -------------------------------------------------------------
                Item {
                    id: sysStorageView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    x: root.sysCurrentScreen === "storage" ? 0 : parent.width
                    opacity: root.sysCurrentScreen === "storage" ? 1.0 : 0.0
                    enabled: root.sysCurrentScreen === "storage"
                    visible: opacity > 0.001 || x < parent.width

                    Behavior on x { NumberAnimation { duration: 320; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 280; easing.type: Easing.InOutQuad } }

                    Flickable {
                        anchors.fill: parent
                        contentHeight: sysStorageCol.height + 60
                        clip: true
                        boundsBehavior: Flickable.DragAndOvershootBounds
                        flickableDirection: Flickable.VerticalFlick

                        Column {
                            id: sysStorageCol
                            width: parent.width
                            spacing: 0

                            // 1. Music & audio (0.02 GB)
                            Item {
                                width: parent.width
                                height: 86

                                Column {
                                    anchors.fill: parent
                                    anchors.leftMargin: 8
                                    anchors.rightMargin: 12
                                    anchors.verticalCenter: parent.verticalCenter
                                    spacing: 10

                                    Item {
                                        width: parent.width
                                        height: 32

                                        Row {
                                            anchors.left: parent.left
                                            anchors.verticalCenter: parent.verticalCenter
                                            spacing: 14

                                            Image {
                                                source: "qrc:/ApexVision/qml/assets/icons/icon_storage_music.svg"
                                                width: 22
                                                height: 22
                                                fillMode: Image.PreserveAspectFit
                                                anchors.verticalCenter: parent.verticalCenter
                                            }

                                            Text {
                                                text: "Music & audio"
                                                font.family: "Inter"
                                                font.pixelSize: 22
                                                font.weight: Font.DemiBold
                                                color: "#FFFFFF"
                                                anchors.verticalCenter: parent.verticalCenter
                                            }
                                        }

                                        Text {
                                            anchors.right: parent.right
                                            anchors.verticalCenter: parent.verticalCenter
                                            text: "0.02 GB"
                                            font.family: "Inter"
                                            font.pixelSize: 20
                                            font.weight: Font.Normal
                                            color: "#CBD5E1"
                                        }
                                    }

                                    Rectangle {
                                        width: parent.width
                                        height: 6
                                        radius: 3
                                        color: Qt.rgba(255, 255, 255, 0.12)

                                        Rectangle {
                                            width: Math.max(6, parent.width * 0.02)
                                            height: parent.height
                                            radius: 3
                                            color: "#38BDF8"
                                        }
                                    }
                                }
                            }

                            // 2. Other apps (1.3 GB)
                            Item {
                                width: parent.width
                                height: 86

                                Column {
                                    anchors.fill: parent
                                    anchors.leftMargin: 8
                                    anchors.rightMargin: 12
                                    anchors.verticalCenter: parent.verticalCenter
                                    spacing: 10

                                    Item {
                                        width: parent.width
                                        height: 32

                                        Row {
                                            anchors.left: parent.left
                                            anchors.verticalCenter: parent.verticalCenter
                                            spacing: 14

                                            Image {
                                                source: "qrc:/ApexVision/qml/assets/icons/icon_storage_apps.svg"
                                                width: 22
                                                height: 22
                                                fillMode: Image.PreserveAspectFit
                                                anchors.verticalCenter: parent.verticalCenter
                                            }

                                            Text {
                                                text: "Other apps"
                                                font.family: "Inter"
                                                font.pixelSize: 22
                                                font.weight: Font.DemiBold
                                                color: "#FFFFFF"
                                                anchors.verticalCenter: parent.verticalCenter
                                            }
                                        }

                                        Text {
                                            anchors.right: parent.right
                                            anchors.verticalCenter: parent.verticalCenter
                                            text: "1.3 GB"
                                            font.family: "Inter"
                                            font.pixelSize: 20
                                            font.weight: Font.Normal
                                            color: "#CBD5E1"
                                        }
                                    }

                                    Rectangle {
                                        width: parent.width
                                        height: 6
                                        radius: 3
                                        color: Qt.rgba(255, 255, 255, 0.12)

                                        Rectangle {
                                            width: Math.max(6, parent.width * 0.12)
                                            height: parent.height
                                            radius: 3
                                            color: "#38BDF8"
                                        }
                                    }
                                }
                            }

                            // 3. Navigation & Offline Maps (0.00 GB)
                            Item {
                                width: parent.width
                                height: 86

                                Column {
                                    anchors.fill: parent
                                    anchors.leftMargin: 8
                                    anchors.rightMargin: 12
                                    anchors.verticalCenter: parent.verticalCenter
                                    spacing: 10

                                    Item {
                                        width: parent.width
                                        height: 32

                                        Row {
                                            anchors.left: parent.left
                                            anchors.verticalCenter: parent.verticalCenter
                                            spacing: 14

                                            Image {
                                                source: "qrc:/ApexVision/qml/assets/icons/icon_storage_maps.svg"
                                                width: 22
                                                height: 22
                                                fillMode: Image.PreserveAspectFit
                                                anchors.verticalCenter: parent.verticalCenter
                                            }

                                            Text {
                                                text: "Navigation & maps"
                                                font.family: "Inter"
                                                font.pixelSize: 22
                                                font.weight: Font.DemiBold
                                                color: "#FFFFFF"
                                                anchors.verticalCenter: parent.verticalCenter
                                            }
                                        }

                                        Text {
                                            anchors.right: parent.right
                                            anchors.verticalCenter: parent.verticalCenter
                                            text: "0.00 GB"
                                            font.family: "Inter"
                                            font.pixelSize: 20
                                            font.weight: Font.Normal
                                            color: "#CBD5E1"
                                        }
                                    }

                                    Rectangle {
                                        width: parent.width
                                        height: 6
                                        radius: 3
                                        color: Qt.rgba(255, 255, 255, 0.12)
                                    }
                                }
                            }

                            // 4. System (66 GB with Amber Fill matching photo)
                            Item {
                                width: parent.width
                                height: 86

                                Column {
                                    anchors.fill: parent
                                    anchors.leftMargin: 8
                                    anchors.rightMargin: 12
                                    anchors.verticalCenter: parent.verticalCenter
                                    spacing: 10

                                    Item {
                                        width: parent.width
                                        height: 32

                                        Row {
                                            anchors.left: parent.left
                                            anchors.verticalCenter: parent.verticalCenter
                                            spacing: 14

                                            Image {
                                                source: "qrc:/ApexVision/qml/assets/icons/icon_storage_system.svg"
                                                width: 22
                                                height: 22
                                                fillMode: Image.PreserveAspectFit
                                                anchors.verticalCenter: parent.verticalCenter
                                            }

                                            Text {
                                                text: "System"
                                                font.family: "Inter"
                                                font.pixelSize: 22
                                                font.weight: Font.DemiBold
                                                color: "#FFFFFF"
                                                anchors.verticalCenter: parent.verticalCenter
                                            }
                                        }

                                        Text {
                                            anchors.right: parent.right
                                            anchors.verticalCenter: parent.verticalCenter
                                            text: "66 GB"
                                            font.family: "Inter"
                                            font.pixelSize: 20
                                            font.weight: Font.Normal
                                            color: "#CBD5E1"
                                        }
                                    }

                                    Rectangle {
                                        width: parent.width
                                        height: 6
                                        radius: 3
                                        color: Qt.rgba(255, 255, 255, 0.12)

                                        Rectangle {
                                            width: parent.width * 0.52
                                            height: parent.height
                                            radius: 3
                                            color: "#FB923C"
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                // -------------------------------------------------------------
                // LEVEL 2F: About Sub-Menu (Custom Non-Android Automotive Info)
                // -------------------------------------------------------------
                Item {
                    id: sysAboutView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    x: root.sysCurrentScreen === "about" ? 0 : parent.width
                    opacity: root.sysCurrentScreen === "about" ? 1.0 : 0.0
                    enabled: root.sysCurrentScreen === "about"
                    visible: opacity > 0.001 || x < parent.width

                    Behavior on x { NumberAnimation { duration: 320; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 280; easing.type: Easing.InOutQuad } }

                    Flickable {
                        anchors.fill: parent
                        contentHeight: sysAboutCol.height + 60
                        clip: true
                        boundsBehavior: Flickable.DragAndOvershootBounds
                        flickableDirection: Flickable.VerticalFlick

                        Column {
                            id: sysAboutCol
                            width: parent.width
                            spacing: 0

                            SettingRowSimple {
                                title: "Device name"
                                subtitle: "Apex Vision IVI"
                            }

                            SettingRowSimple {
                                title: "Lead Architect & Developer"
                                subtitle: "Sk Rehan Ahamed"
                            }

                            SettingRowSimple {
                                title: "Operating system"
                                subtitle: "ApexOS Automotive 2.4 LTS"
                            }

                            SettingRowSimple {
                                title: "Kernel version"
                                subtitle: "Linux 6.8.4-apex-rt (64-bit real-time)"
                            }

                            SettingRowSimple {
                                title: "UI platform"
                                subtitle: "Qt 6.7 Quick3D Hardware Accelerated"
                            }

                            SettingRowSimple {
                                title: "Build number"
                                subtitle: "APX-2026.09.27-RELEASE"
                            }

                            SettingRowSimple {
                                title: "Processor hardware"
                                subtitle: "Apex DriveCore EV-N100 Octa-Core"
                            }

                            SettingRowSimple {
                                title: "Hardware serial"
                                subtitle: "APX-8942-771B-9430"
                            }
                        }
                    }
                }

                // -------------------------------------------------------------
                // LEVEL 2G: Software Updates Sub-Menu
                // -------------------------------------------------------------
                Item {
                    id: sysSystemUpdateView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    x: root.sysCurrentScreen === "system_update" ? 0 : parent.width
                    opacity: root.sysCurrentScreen === "system_update" ? 1.0 : 0.0
                    enabled: root.sysCurrentScreen === "system_update"
                    visible: opacity > 0.001 || x < parent.width

                    Behavior on x { NumberAnimation { duration: 320; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 280; easing.type: Easing.InOutQuad } }

                    Flickable {
                        anchors.fill: parent
                        contentHeight: sysUpdateCol.height + 60
                        clip: true
                        boundsBehavior: Flickable.DragAndOvershootBounds
                        flickableDirection: Flickable.VerticalFlick

                        Column {
                            id: sysUpdateCol
                            width: parent.width - 32
                            anchors.horizontalCenter: parent.horizontalCenter
                            spacing: 28

                            Item { width: 1; height: 16 }

                            // Status Card
                            Rectangle {
                                width: parent.width
                                height: 140
                                radius: 16
                                color: Qt.rgba(255, 255, 255, 0.05)
                                border.color: Qt.rgba(255, 255, 255, 0.15)
                                border.width: 1

                                Row {
                                    anchors.fill: parent
                                    anchors.margins: 20
                                    spacing: 18

                                    Rectangle {
                                        width: 52
                                        height: 52
                                        radius: 26
                                        color: Qt.rgba(56/255, 189/255, 248/255, 0.15)
                                        border.color: "#38BDF8"
                                        border.width: 1.5
                                        anchors.verticalCenter: parent.verticalCenter

                                        Text {
                                            anchors.centerIn: parent
                                            text: "✓"
                                            color: "#38BDF8"
                                            font.pixelSize: 26
                                            font.weight: Font.Bold
                                        }
                                    }

                                    Column {
                                        anchors.verticalCenter: parent.verticalCenter
                                        spacing: 6

                                        Text {
                                            text: "Your system is up to date"
                                            color: "#FFFFFF"
                                            font.family: "Inter"
                                            font.pixelSize: 22
                                            font.weight: Font.DemiBold
                                        }

                                        Text {
                                            text: "ApexOS 2.4.0 • Release: September 2026"
                                            color: "#94A3B8"
                                            font.family: "Inter"
                                            font.pixelSize: 15
                                        }

                                        Text {
                                            text: "Last checked: Today, " + ((typeof SystemBackend !== "undefined") ? SystemBackend.currentTime : "13:58")
                                            color: "#64748B"
                                            font.family: "Inter"
                                            font.pixelSize: 14
                                        }
                                    }
                                }
                            }

                            // Check Button (Glass style with border)
                            Rectangle {
                                width: 220
                                height: 50
                                radius: 12
                                color: checkUpdateMouse.pressed ? Qt.rgba(255, 255, 255, 0.16) :
                                       (checkUpdateMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.10) : Qt.rgba(255, 255, 255, 0.05))
                                border.color: checkUpdateMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.35) : Qt.rgba(255, 255, 255, 0.20)
                                border.width: 1.5

                                Behavior on color { ColorAnimation { duration: 120 } }
                                Behavior on border.color { ColorAnimation { duration: 120 } }

                                Text {
                                    anchors.centerIn: parent
                                    text: "Check for updates"
                                    color: "#FFFFFF"
                                    font.family: "Inter"
                                    font.pixelSize: 16
                                    font.weight: Font.DemiBold
                                }

                                MouseArea {
                                    id: checkUpdateMouse
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                    }
                                }
                            }
                        }
                    }
                }

                // -------------------------------------------------------------
                // LEVEL 2H: Legal Information Sub-Menu
                // -------------------------------------------------------------
                Item {
                    id: sysLegalInfoView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    x: root.sysCurrentScreen === "legal_info" ? 0 : parent.width
                    opacity: root.sysCurrentScreen === "legal_info" ? 1.0 : 0.0
                    enabled: root.sysCurrentScreen === "legal_info"
                    visible: opacity > 0.001 || x < parent.width

                    Behavior on x { NumberAnimation { duration: 320; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 280; easing.type: Easing.InOutQuad } }

                    Flickable {
                        anchors.fill: parent
                        contentHeight: sysLegalCol.height + 60
                        clip: true
                        boundsBehavior: Flickable.DragAndOvershootBounds
                        flickableDirection: Flickable.VerticalFlick

                        Column {
                            id: sysLegalCol
                            width: parent.width
                            spacing: 0

                            SettingRowSimple {
                                title: "Third-party open source licenses"
                                subtitle: "Compliance notices for open-source frameworks and libraries"
                            }
                            SettingRowSimple {
                                title: "Vehicle safety disclosures"
                                subtitle: "Autonomous & driver assistance regulatory notices"
                            }
                            SettingRowSimple {
                                title: "Telemetry & privacy terms"
                                subtitle: "Connected vehicle data collection and user rights"
                            }
                        }
                    }
                }

                // -------------------------------------------------------------
                // LEVEL 2I: Software Licenses Sub-Menu
                // -------------------------------------------------------------
                Item {
                    id: sysSoftwareLicensesView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    x: root.sysCurrentScreen === "software_licenses" ? 0 : parent.width
                    opacity: root.sysCurrentScreen === "software_licenses" ? 1.0 : 0.0
                    enabled: root.sysCurrentScreen === "software_licenses"
                    visible: opacity > 0.001 || x < parent.width

                    Behavior on x { NumberAnimation { duration: 320; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 280; easing.type: Easing.InOutQuad } }

                    Flickable {
                        anchors.fill: parent
                        contentHeight: sysLicCol.height + 60
                        clip: true
                        boundsBehavior: Flickable.DragAndOvershootBounds
                        flickableDirection: Flickable.VerticalFlick

                        Column {
                            id: sysLicCol
                            width: parent.width
                            spacing: 0

                            SettingRowSimple {
                                title: "Qt 6.7 Quick / Quick3D"
                                subtitle: "The Qt Company • LGPLv3 License"
                            }
                            SettingRowSimple {
                                title: "Linux Kernel 6.8"
                                subtitle: "Linus Torvalds and contributors • GPLv2"
                            }
                            SettingRowSimple {
                                title: "OpenSSL Toolkit"
                                subtitle: "The OpenSSL Project • Apache License 2.0"
                            }
                            SettingRowSimple {
                                title: "FreeType Font Engine"
                                subtitle: "FreeType Project • FTL / GPLv2"
                            }
                            SettingRowSimple {
                                title: "Wayland Display Protocol"
                                subtitle: "Kristian Høgsberg and contributors • MIT License"
                            }
                        }
                    }
                }

                // -------------------------------------------------------------
                // LEVEL 2J: Smart Phone Link Sub-Menu
                // -------------------------------------------------------------
                Item {
                    id: sysPhoneLinkView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    x: root.sysCurrentScreen === "phone_link" ? 0 : parent.width
                    opacity: root.sysCurrentScreen === "phone_link" ? 1.0 : 0.0
                    enabled: root.sysCurrentScreen === "phone_link"
                    visible: opacity > 0.001 || x < parent.width

                    Behavior on x { NumberAnimation { duration: 320; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 280; easing.type: Easing.InOutQuad } }

                    Flickable {
                        anchors.fill: parent
                        contentHeight: sysPhoneLinkCol.height + 60
                        clip: true
                        boundsBehavior: Flickable.DragAndOvershootBounds
                        flickableDirection: Flickable.VerticalFlick

                        Column {
                            id: sysPhoneLinkCol
                            width: parent.width
                            spacing: 0

                            SettingRowSwitch {
                                title: "Wireless projection"
                                subtitle: "Automatically mirror smartphone media and navigation"
                                checked: true
                            }

                            SettingRowSwitch {
                                title: "Auto-connect when vehicle starts"
                                subtitle: "Connect to the last recognized driver smartphone"
                                checked: true
                            }

                            SettingRowSimple {
                                title: "Paired projection devices"
                                subtitle: "Smartphone • Connected via 5GHz Wi-Fi"
                            }
                        }
                    }
                }

                // -------------------------------------------------------------
                // LEVEL 3A: Languages Selection Sub-Menu (English, Hindi)
                // -------------------------------------------------------------
                Item {
                    id: sysLanguagesSelectView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    x: root.sysCurrentScreen === "languages_select" ? 0 : parent.width
                    opacity: root.sysCurrentScreen === "languages_select" ? 1.0 : 0.0
                    enabled: root.sysCurrentScreen === "languages_select"
                    visible: opacity > 0.001 || x < parent.width

                    Behavior on x { NumberAnimation { duration: 320; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 280; easing.type: Easing.InOutQuad } }

                    Flickable {
                        anchors.fill: parent
                        contentHeight: sysLangSelectCol.height + 40
                        clip: true
                        boundsBehavior: Flickable.DragAndOvershootBounds
                        flickableDirection: Flickable.VerticalFlick

                        Column {
                            id: sysLangSelectCol
                            width: parent.width
                            spacing: 0

                            SettingRowRadio {
                                title: "English"
                                subtitle: "English (United States)"
                                selected: root.selectedLanguage === "English"
                                onSelectedRequested: {
                                    root.selectedLanguage = "English";
                                    if (typeof SystemBackend !== "undefined") SystemBackend.setSelectedLanguage("English");
                                    root.sysSlideDir = -1;
                                    root.sysCurrentScreen = "languages_input";
                                }
                            }

                            SettingRowRadio {
                                title: "Hindi (हिन्दी)"
                                subtitle: "हिंदी (भारत)"
                                selected: root.selectedLanguage === "Hindi (हिन्दी)"
                                onSelectedRequested: {
                                    root.selectedLanguage = "Hindi (हिन्दी)";
                                    if (typeof SystemBackend !== "undefined") SystemBackend.setSelectedLanguage("Hindi (हिन्दी)");
                                    root.sysSlideDir = -1;
                                    root.sysCurrentScreen = "languages_input";
                                }
                            }
                        }
                    }
                }

                // -------------------------------------------------------------
                // LEVEL 3B: Autofill Service Sub-Menu
                // -------------------------------------------------------------
                Item {
                    id: sysAutofillServiceView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    x: root.sysCurrentScreen === "autofill_service" ? 0 : parent.width
                    opacity: root.sysCurrentScreen === "autofill_service" ? 1.0 : 0.0
                    enabled: root.sysCurrentScreen === "autofill_service"
                    visible: opacity > 0.001 || x < parent.width

                    Behavior on x { NumberAnimation { duration: 320; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 280; easing.type: Easing.InOutQuad } }

                    Flickable {
                        anchors.fill: parent
                        contentHeight: sysAutofillCol.height + 40
                        clip: true
                        boundsBehavior: Flickable.DragAndOvershootBounds
                        flickableDirection: Flickable.VerticalFlick

                        Column {
                            id: sysAutofillCol
                            width: parent.width
                            spacing: 0

                            SettingRowRadio {
                                title: "Apex Cloud Passkeys"
                                subtitle: "Autofill with Apex Cloud Profile"
                                selected: root.selectedAutofill === "Apex Cloud"
                                onSelectedRequested: {
                                    root.selectedAutofill = "Apex Cloud";
                                    if (typeof SystemBackend !== "undefined") SystemBackend.setSelectedAutofill("Apex Cloud");
                                    root.sysSlideDir = -1;
                                    root.sysCurrentScreen = "languages_input";
                                }
                            }

                            SettingRowRadio {
                                title: "None"
                                subtitle: "Do not use an autofill service"
                                selected: root.selectedAutofill === "None"
                                onSelectedRequested: {
                                    root.selectedAutofill = "None";
                                    if (typeof SystemBackend !== "undefined") SystemBackend.setSelectedAutofill("None");
                                    root.sysSlideDir = -1;
                                    root.sysCurrentScreen = "languages_input";
                                }
                            }

                            SettingRowSwitch {
                                title: "Autofill passwords"
                                checked: root.autofillPasswordsEnabled
                                infoText: "Save and automatically fill credentials saved in your Apex Profile."
                                onToggled: root.autofillPasswordsEnabled = !root.autofillPasswordsEnabled
                                onInfoClicked: root.activeInfoText = infoText
                            }

                            SettingRowSwitch {
                                title: "Autofill payment methods"
                                checked: root.autofillPaymentsEnabled
                                infoText: "Quickly fill payment cards and delivery addresses in car applications."
                                onToggled: root.autofillPaymentsEnabled = !root.autofillPaymentsEnabled
                                onInfoClicked: root.activeInfoText = infoText
                            }
                        }
                    }
                }

                // -------------------------------------------------------------
                // LEVEL 3C: Keyboard Settings Sub-Menu
                // -------------------------------------------------------------
                Item {
                    id: sysKeyboardSettingsView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    x: root.sysCurrentScreen === "keyboard_settings" ? 0 :
                       ((root.sysCurrentScreen === "keyboard_onscreen" || root.sysCurrentScreen === "keyboard_physical") ? -parent.width * 0.4 : parent.width)
                    opacity: root.sysCurrentScreen === "keyboard_settings" ? 1.0 : 0.0
                    enabled: root.sysCurrentScreen === "keyboard_settings"
                    visible: opacity > 0.001 || (x > -parent.width * 0.4 && x < parent.width)

                    Behavior on x { NumberAnimation { duration: 320; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 280; easing.type: Easing.InOutQuad } }

                    Flickable {
                        anchors.fill: parent
                        contentHeight: sysKeyboardCol.height + 40
                        clip: true
                        boundsBehavior: Flickable.DragAndOvershootBounds
                        flickableDirection: Flickable.VerticalFlick

                        Column {
                            id: sysKeyboardCol
                            width: parent.width
                            spacing: 0

                            SettingRowChevron {
                                title: "On-screen keyboard"
                                subtitle: root.selectedKeyboard + " - Multilingual typing"
                                onClicked: {
                                    root.sysSlideDir = 1;
                                    root.sysCurrentScreen = "keyboard_onscreen";
                                }
                            }

                            SettingRowChevron {
                                title: "Physical keyboard"
                                subtitle: "APEX Virtual Input Device"
                                onClicked: {
                                    root.sysSlideDir = 1;
                                    root.sysCurrentScreen = "keyboard_physical";
                                }
                            }

                            SettingRowSwitch {
                                title: "Spell checker"
                                checked: root.spellCheckerEnabled
                                infoText: "Check spelling while typing across vehicle navigation and media apps."
                                onToggled: root.spellCheckerEnabled = !root.spellCheckerEnabled
                                onInfoClicked: root.activeInfoText = infoText
                            }

                            SettingRowSwitch {
                                title: "Auto-capitalization"
                                checked: root.autoCapitalizationEnabled
                                onToggled: root.autoCapitalizationEnabled = !root.autoCapitalizationEnabled
                            }

                            SettingRowSwitch {
                                title: "Auto-correction"
                                checked: root.autoCorrectionEnabled
                                onToggled: root.autoCorrectionEnabled = !root.autoCorrectionEnabled
                            }
                        }
                    }
                }

                // -------------------------------------------------------------
                // LEVEL 3D: Text-to-speech output Sub-Menu
                // -------------------------------------------------------------
                Item {
                    id: sysTtsSettingsView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    x: root.sysCurrentScreen === "tts_settings" ? 0 :
                       ((root.sysCurrentScreen === "tts_engine" || root.sysCurrentScreen === "tts_language") ? -parent.width * 0.4 : parent.width)
                    opacity: root.sysCurrentScreen === "tts_settings" ? 1.0 : 0.0
                    enabled: root.sysCurrentScreen === "tts_settings"
                    visible: opacity > 0.001 || (x > -parent.width * 0.4 && x < parent.width)

                    Behavior on x { NumberAnimation { duration: 320; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 280; easing.type: Easing.InOutQuad } }

                    Flickable {
                        anchors.fill: parent
                        contentHeight: sysTtsCol.height + 40
                        clip: true
                        boundsBehavior: Flickable.DragAndOvershootBounds
                        flickableDirection: Flickable.VerticalFlick

                        Column {
                            id: sysTtsCol
                            width: parent.width
                            spacing: 0

                            SettingRowChevron {
                                title: "Preferred engine"
                                subtitle: root.ttsEngine
                                onClicked: {
                                    root.sysSlideDir = 1;
                                    root.sysCurrentScreen = "tts_engine";
                                }
                            }

                            SettingRowChevron {
                                title: "Language"
                                subtitle: root.ttsLanguage === "Use system language" ? ("Use system language (" + root.selectedLanguage + ")") : root.ttsLanguage
                                onClicked: {
                                    root.sysSlideDir = 1;
                                    root.sysCurrentScreen = "tts_language";
                                }
                            }

                            SettingRowSlider {
                                title: "Speech rate"
                                value: root.ttsSpeechRate
                                onMovedVal: function(v) { root.ttsSpeechRate = v; }
                            }

                            SettingRowSlider {
                                title: "Pitch"
                                value: root.ttsPitch
                                onMovedVal: function(v) { root.ttsPitch = v; }
                            }

                            SettingRowChevron {
                                title: "Listen to an example"
                                subtitle: root.ttsSamplePlaying ? "🔊 Playing demonstration audio..." : "Play a demonstration of speech synthesis"
                                showChevron: false
                                onClicked: {
                                    root.ttsSamplePlaying = true;
                                    var sampleText = (root.selectedLanguage.indexOf("Hindi") !== -1 || root.ttsLanguage.indexOf("Hindi") !== -1) ?
                                        "यह एपेक्स विज़न इंफोटेनमेंट सिस्टम में वाक् संश्लेषण का एक उदाहरण है।" :
                                        "This is an example of speech synthesis in the Apex Vision cockpit infotainment system.";
                                    if (typeof SystemBackend !== "undefined") {
                                        SystemBackend.playTtsSample(sampleText, root.ttsSpeechRate, root.ttsPitch);
                                    }
                                    ttsTimer.restart();
                                }
                            }
                        }
                    }
                }

                // -------------------------------------------------------------
                // LEVEL 4A: On-screen Keyboard Manage Sub-Menu
                // -------------------------------------------------------------
                Item {
                    id: sysOnscreenKeyboardManageView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    x: root.sysCurrentScreen === "keyboard_onscreen" ? 0 : parent.width
                    opacity: root.sysCurrentScreen === "keyboard_onscreen" ? 1.0 : 0.0
                    enabled: root.sysCurrentScreen === "keyboard_onscreen"
                    visible: opacity > 0.001 || x < parent.width

                    Behavior on x { NumberAnimation { duration: 320; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 280; easing.type: Easing.InOutQuad } }

                    Flickable {
                        anchors.fill: parent
                        contentHeight: sysOnscreenKbCol.height + 60
                        clip: true
                        boundsBehavior: Flickable.DragAndOvershootBounds
                        flickableDirection: Flickable.VerticalFlick

                        Column {
                            id: sysOnscreenKbCol
                            width: parent.width
                            spacing: 0

                            SettingRowRadio {
                                title: "Apex Touch Keyboard"
                                subtitle: "Multilingual automotive layout, gesture control, auto-corrections"
                                selected: root.selectedKeyboard === "Apex Touch Keyboard"
                                onSelectedRequested: {
                                    root.selectedKeyboard = "Apex Touch Keyboard";
                                    if (typeof SystemBackend !== "undefined") SystemBackend.setSelectedKeyboard("Apex Touch Keyboard");
                                }
                            }

                            SettingRowRadio {
                                title: "Apex Voice Dictation"
                                subtitle: "Hands-free speech recognition in car cabin"
                                selected: root.selectedKeyboard === "Apex Voice Dictation"
                                onSelectedRequested: {
                                    root.selectedKeyboard = "Apex Voice Dictation";
                                    if (typeof SystemBackend !== "undefined") SystemBackend.setSelectedKeyboard("Apex Voice Dictation");
                                }
                            }

                            SettingRowSwitch {
                                title: "Haptic feedback on keypress"
                                checked: root.hapticFeedbackEnabled
                                infoText: "Tactile vibration feedback through touchscreen when keys are tapped."
                                onToggled: root.hapticFeedbackEnabled = !root.hapticFeedbackEnabled
                                onInfoClicked: root.activeInfoText = infoText
                            }

                            SettingRowSwitch {
                                title: "Sound on keypress"
                                checked: root.soundOnKeypressEnabled
                                onToggled: root.soundOnKeypressEnabled = !root.soundOnKeypressEnabled
                            }

                            SettingRowSwitch {
                                title: "Show language switch key"
                                subtitle: "Quick toggle between English and हिन्दी on spacebar"
                                checked: root.showLanguageSwitchKey
                                onToggled: root.showLanguageSwitchKey = !root.showLanguageSwitchKey
                            }

                            // Interactive Keyboard Demo / Tester
                            Item { width: 1; height: 16 }

                            Rectangle {
                                width: parent.width - 24
                                height: 180
                                anchors.horizontalCenter: parent.horizontalCenter
                                radius: 16
                                color: Qt.rgba(255, 255, 255, 0.05)
                                border.color: Qt.rgba(255, 255, 255, 0.15)
                                border.width: 1

                                Column {
                                    anchors.fill: parent
                                    anchors.margins: 14
                                    spacing: 10

                                    Item {
                                        width: parent.width
                                        height: 24
                                        Text {
                                            text: "Virtual Keyboard Input Test:"
                                            color: "#93C5FD"
                                            font.family: "Inter"; font.pixelSize: 13; font.weight: Font.DemiBold
                                            anchors.left: parent.left
                                            anchors.verticalCenter: parent.verticalCenter
                                        }
                                        Text {
                                            text: "[Clear]"
                                            color: "#FB923C"
                                            font.family: "Inter"; font.pixelSize: 13; font.weight: Font.Bold
                                            anchors.right: parent.right
                                            anchors.verticalCenter: parent.verticalCenter
                                            MouseArea {
                                                anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                                                onClicked: root.virtualKbTestInput = ""
                                            }
                                        }
                                    }

                                    // Display Box
                                    Rectangle {
                                        width: parent.width
                                        height: 40
                                        radius: 8
                                        color: Qt.rgba(0, 0, 0, 0.4)
                                        border.color: "#FB923C"
                                        border.width: 1
                                        Text {
                                            anchors.verticalCenter: parent.verticalCenter
                                            anchors.left: parent.left
                                            anchors.leftMargin: 12
                                            anchors.right: parent.right
                                            anchors.rightMargin: 12
                                            elide: Text.ElideRight
                                            text: root.virtualKbTestInput === "" ? "Tap virtual keys below to test typing..." : root.virtualKbTestInput
                                            color: root.virtualKbTestInput === "" ? Qt.rgba(255, 255, 255, 0.4) : "#FFFFFF"
                                            font.family: "Inter"; font.pixelSize: 16
                                        }
                                    }

                                    // Mini Keypad
                                    Row {
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        spacing: 6
                                        Repeater {
                                            model: ["A", "P", "E", "X", " ", "V", "I", "S", "I", "O", "N", "⌫"]
                                            Rectangle {
                                                width: modelData === " " ? 48 : (modelData === "⌫" ? 36 : 28)
                                                height: 36
                                                radius: 6
                                                color: kbKeyMouse.pressed ? "#FB923C" : Qt.rgba(255, 255, 255, 0.12)
                                                Text {
                                                    anchors.centerIn: parent
                                                    text: modelData === " " ? "␣" : modelData
                                                    color: kbKeyMouse.pressed ? "#000000" : "#FFFFFF"
                                                    font.family: "Inter"; font.pixelSize: 14; font.weight: Font.DemiBold
                                                }
                                                MouseArea {
                                                    id: kbKeyMouse
                                                    anchors.fill: parent
                                                    cursorShape: Qt.PointingHandCursor
                                                    onClicked: {
                                                        if (modelData === "⌫") {
                                                            if (root.virtualKbTestInput.length > 0) {
                                                                root.virtualKbTestInput = root.virtualKbTestInput.substring(0, root.virtualKbTestInput.length - 1);
                                                            }
                                                        } else {
                                                            root.virtualKbTestInput += modelData;
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                // -------------------------------------------------------------
                // LEVEL 4B: Physical Keyboard Manage Sub-Menu
                // -------------------------------------------------------------
                Item {
                    id: sysPhysicalKeyboardManageView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    x: root.sysCurrentScreen === "keyboard_physical" ? 0 : parent.width
                    opacity: root.sysCurrentScreen === "keyboard_physical" ? 1.0 : 0.0
                    enabled: root.sysCurrentScreen === "keyboard_physical"
                    visible: opacity > 0.001 || x < parent.width

                    Behavior on x { NumberAnimation { duration: 320; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 280; easing.type: Easing.InOutQuad } }

                    Flickable {
                        anchors.fill: parent
                        contentHeight: sysPhysicalKbCol.height + 60
                        clip: true
                        boundsBehavior: Flickable.DragAndOvershootBounds
                        flickableDirection: Flickable.VerticalFlick

                        Column {
                            id: sysPhysicalKbCol
                            width: parent.width
                            spacing: 0

                            SettingRowSwitch {
                                title: "Use on-screen keyboard"
                                subtitle: "Keep virtual keyboard visible while physical input is connected"
                                checked: root.physicalUseOnscreen
                                onToggled: root.physicalUseOnscreen = !root.physicalUseOnscreen
                            }
                        }
                    }
                }

                // -------------------------------------------------------------
                // LEVEL 4C: Preferred TTS Engine Sub-Menu
                // -------------------------------------------------------------
                Item {
                    id: sysTtsEngineSelectView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    x: root.sysCurrentScreen === "tts_engine" ? 0 : parent.width
                    opacity: root.sysCurrentScreen === "tts_engine" ? 1.0 : 0.0
                    enabled: root.sysCurrentScreen === "tts_engine"
                    visible: opacity > 0.001 || x < parent.width

                    Behavior on x { NumberAnimation { duration: 320; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 280; easing.type: Easing.InOutQuad } }

                    Flickable {
                        anchors.fill: parent
                        contentHeight: sysTtsEngineCol.height + 40
                        clip: true
                        boundsBehavior: Flickable.DragAndOvershootBounds
                        flickableDirection: Flickable.VerticalFlick

                        Column {
                            id: sysTtsEngineCol
                            width: parent.width
                            spacing: 0

                            SettingRowRadio {
                                title: "APEX Embedded Neural Engine"
                                subtitle: "Low-latency offline automotive voice synthesis"
                                selected: root.ttsEngine === "APEX Embedded Neural Engine"
                                onSelectedRequested: {
                                    root.ttsEngine = "APEX Embedded Neural Engine";
                                    root.sysSlideDir = -1;
                                    root.sysCurrentScreen = "tts_settings";
                                }
                            }

                            SettingRowRadio {
                                title: "Apex Cloud Speech Engine"
                                subtitle: "High-definition neural vocal synthesis via connected network"
                                selected: root.ttsEngine === "Apex Cloud Speech Engine"
                                onSelectedRequested: {
                                    root.ttsEngine = "Apex Cloud Speech Engine";
                                    root.sysSlideDir = -1;
                                    root.sysCurrentScreen = "tts_settings";
                                }
                            }
                        }
                    }
                }

                // -------------------------------------------------------------
                // LEVEL 4D: TTS Language Selection Sub-Menu
                // -------------------------------------------------------------
                Item {
                    id: sysTtsLanguageSelectView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    x: root.sysCurrentScreen === "tts_language" ? 0 : parent.width
                    opacity: root.sysCurrentScreen === "tts_language" ? 1.0 : 0.0
                    enabled: root.sysCurrentScreen === "tts_language"
                    visible: opacity > 0.001 || x < parent.width

                    Behavior on x { NumberAnimation { duration: 320; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 280; easing.type: Easing.InOutQuad } }

                    Flickable {
                        anchors.fill: parent
                        contentHeight: sysTtsLangCol.height + 40
                        clip: true
                        boundsBehavior: Flickable.DragAndOvershootBounds
                        flickableDirection: Flickable.VerticalFlick

                        Column {
                            id: sysTtsLangCol
                            width: parent.width
                            spacing: 0

                            SettingRowRadio {
                                title: "Use system language"
                                subtitle: "Follow current system language (" + root.selectedLanguage + ")"
                                selected: root.ttsLanguage === "Use system language"
                                onSelectedRequested: {
                                    root.ttsLanguage = "Use system language";
                                    root.sysSlideDir = -1;
                                    root.sysCurrentScreen = "tts_settings";
                                }
                            }

                            SettingRowRadio {
                                title: "English (United States)"
                                subtitle: "en-US Natural Neural Voice"
                                selected: root.ttsLanguage === "English (United States)"
                                onSelectedRequested: {
                                    root.ttsLanguage = "English (United States)";
                                    root.sysSlideDir = -1;
                                    root.sysCurrentScreen = "tts_settings";
                                }
                            }

                            SettingRowRadio {
                                title: "English (India)"
                                subtitle: "en-IN Regional Voice"
                                selected: root.ttsLanguage === "English (India)"
                                onSelectedRequested: {
                                    root.ttsLanguage = "English (India)";
                                    root.sysSlideDir = -1;
                                    root.sysCurrentScreen = "tts_settings";
                                }
                            }

                            SettingRowRadio {
                                title: "Hindi (India) - हिन्दी"
                                subtitle: "hi-IN भारतीय वाक् संश्लेषण"
                                selected: root.ttsLanguage === "Hindi (India) - हिन्दी"
                                onSelectedRequested: {
                                    root.ttsLanguage = "Hindi (India) - हिन्दी";
                                    root.sysSlideDir = -1;
                                    root.sysCurrentScreen = "tts_settings";
                                }
                            }
                        }
                    }
                }

                // -------------------------------------------------------------
                // LEVEL 4E: Personal Dictionary Sub-Menu
                // -------------------------------------------------------------
                Item {
                    id: sysPersonalDictionaryView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    x: root.sysCurrentScreen === "personal_dictionary" ? 0 : parent.width
                    opacity: root.sysCurrentScreen === "personal_dictionary" ? 1.0 : 0.0
                    enabled: root.sysCurrentScreen === "personal_dictionary"
                    visible: opacity > 0.001 || x < parent.width

                    Behavior on x { NumberAnimation { duration: 320; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 280; easing.type: Easing.InOutQuad } }

                    Flickable {
                        anchors.fill: parent
                        contentHeight: sysDictCol.height + 40
                        clip: true
                        boundsBehavior: Flickable.DragAndOvershootBounds
                        flickableDirection: Flickable.VerticalFlick

                        Column {
                            id: sysDictCol
                            width: parent.width
                            spacing: 0

                            SettingRowChevron {
                                title: "APEX IVI"
                                subtitle: "Shortcut: apex"
                                showChevron: false
                            }

                            SettingRowChevron {
                                title: "EV Supercharger"
                                subtitle: "Shortcut: sc"
                                showChevron: false
                            }

                            SettingRowChevron {
                                title: "गति सीमा (Speed Limit)"
                                subtitle: "Shortcut: gl"
                                showChevron: false
                            }

                            SettingRowChevron {
                                title: "मार्गदर्शन (Navigation)"
                                subtitle: "Shortcut: nav"
                                showChevron: false
                            }

                            SettingRowChevron {
                                title: "+ Add word"
                                subtitle: "Add personal shortcut to dictionary"
                                showChevron: false
                            }
                        }
                    }
                }

                // -------------------------------------------------------------
                // LEVEL 3E: Units - Distance and Speed Sub-Menu
                // -------------------------------------------------------------
                Item {
                    id: sysUnitsMeasurementView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    x: root.sysCurrentScreen === "units_measurement" ? 0 : parent.width
                    opacity: root.sysCurrentScreen === "units_measurement" ? 1.0 : 0.0
                    enabled: root.sysCurrentScreen === "units_measurement"
                    visible: opacity > 0.001 || x < parent.width

                    Behavior on x { NumberAnimation { duration: 320; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 280; easing.type: Easing.InOutQuad } }

                    Flickable {
                        anchors.fill: parent
                        contentHeight: sysUnitsMeasCol.height + 40
                        clip: true
                        boundsBehavior: Flickable.DragAndOvershootBounds
                        flickableDirection: Flickable.VerticalFlick

                        Column {
                            id: sysUnitsMeasCol
                            width: parent.width
                            spacing: 0

                            SettingRowRadio {
                                title: "km & L/100 km"
                                selected: root.unitsMeasurement === "km & L/100 km"
                                onSelectedRequested: {
                                    root.unitsMeasurement = "km & L/100 km";
                                    root.sysSlideDir = -1;
                                    root.sysCurrentScreen = "units";
                                }
                            }

                            SettingRowRadio {
                                title: "mi & MPG"
                                selected: root.unitsMeasurement === "mi & MPG"
                                onSelectedRequested: {
                                    root.unitsMeasurement = "mi & MPG";
                                    root.sysSlideDir = -1;
                                    root.sysCurrentScreen = "units";
                                }
                            }

                            SettingRowRadio {
                                title: "km & km/L"
                                selected: root.unitsMeasurement === "km & km/L"
                                onSelectedRequested: {
                                    root.unitsMeasurement = "km & km/L";
                                    root.sysSlideDir = -1;
                                    root.sysCurrentScreen = "units";
                                }
                            }
                        }
                    }
                }

                // -------------------------------------------------------------
                // LEVEL 3F: Units - Temperature Sub-Menu
                // -------------------------------------------------------------
                Item {
                    id: sysUnitsTemperatureView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    x: root.sysCurrentScreen === "units_temperature" ? 0 : parent.width
                    opacity: root.sysCurrentScreen === "units_temperature" ? 1.0 : 0.0
                    enabled: root.sysCurrentScreen === "units_temperature"
                    visible: opacity > 0.001 || x < parent.width

                    Behavior on x { NumberAnimation { duration: 320; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 280; easing.type: Easing.InOutQuad } }

                    Flickable {
                        anchors.fill: parent
                        contentHeight: sysUnitsTempCol.height + 40
                        clip: true
                        boundsBehavior: Flickable.DragAndOvershootBounds
                        flickableDirection: Flickable.VerticalFlick

                        Column {
                            id: sysUnitsTempCol
                            width: parent.width
                            spacing: 0

                            SettingRowRadio {
                                title: "Fahrenheit (°F)"
                                selected: root.unitsTemperature === "Fahrenheit (°F)"
                                onSelectedRequested: {
                                    root.unitsTemperature = "Fahrenheit (°F)";
                                    if (typeof ClimateBackend !== "undefined") {
                                        ClimateBackend.setIsFahrenheit(true);
                                        ClimateBackend.setTemperatureUnit("Fahrenheit (°F)");
                                    }
                                    if (typeof SystemBackend !== "undefined") {
                                        SystemBackend.setUnitsTemperature("Fahrenheit (°F)");
                                    }
                                    root.sysSlideDir = -1;
                                    root.sysCurrentScreen = "units";
                                }
                            }

                            SettingRowRadio {
                                title: "Celsius (°C)"
                                selected: root.unitsTemperature === "Celsius (°C)"
                                onSelectedRequested: {
                                    root.unitsTemperature = "Celsius (°C)";
                                    if (typeof ClimateBackend !== "undefined") {
                                        ClimateBackend.setIsFahrenheit(false);
                                        ClimateBackend.setTemperatureUnit("Celsius (°C)");
                                    }
                                    if (typeof SystemBackend !== "undefined") {
                                        SystemBackend.setUnitsTemperature("Celsius (°C)");
                                    }
                                    root.sysSlideDir = -1;
                                    root.sysCurrentScreen = "units";
                                }
                            }
                        }
                    }
                }

                // -------------------------------------------------------------
                // LEVEL 3G: Units - Tire Pressure Sub-Menu
                // -------------------------------------------------------------
                Item {
                    id: sysUnitsPressureView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    x: root.sysCurrentScreen === "units_pressure" ? 0 : parent.width
                    opacity: root.sysCurrentScreen === "units_pressure" ? 1.0 : 0.0
                    enabled: root.sysCurrentScreen === "units_pressure"
                    visible: opacity > 0.001 || x < parent.width

                    Behavior on x { NumberAnimation { duration: 320; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 280; easing.type: Easing.InOutQuad } }

                    Flickable {
                        anchors.fill: parent
                        contentHeight: sysUnitsPressureCol.height + 40
                        clip: true
                        boundsBehavior: Flickable.DragAndOvershootBounds
                        flickableDirection: Flickable.VerticalFlick

                        Column {
                            id: sysUnitsPressureCol
                            width: parent.width
                            spacing: 0

                            SettingRowRadio {
                                title: "psi"
                                selected: root.unitsPressure === "psi"
                                onSelectedRequested: {
                                    root.unitsPressure = "psi";
                                    root.sysSlideDir = -1;
                                    root.sysCurrentScreen = "units";
                                }
                            }

                            SettingRowRadio {
                                title: "bar"
                                selected: root.unitsPressure === "bar"
                                onSelectedRequested: {
                                    root.unitsPressure = "bar";
                                    root.sysSlideDir = -1;
                                    root.sysCurrentScreen = "units";
                                }
                            }

                            SettingRowRadio {
                                title: "kPa"
                                selected: root.unitsPressure === "kPa"
                                onSelectedRequested: {
                                    root.unitsPressure = "kPa";
                                    root.sysSlideDir = -1;
                                    root.sysCurrentScreen = "units";
                                }
                            }
                        }
                    }
                }

                // -------------------------------------------------------------
                // LEVEL 3H: Units - Weight Unit Sub-Menu (Matches Image 1 & 3)
                // -------------------------------------------------------------
                Item {
                    id: sysUnitsWeightView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    x: root.sysCurrentScreen === "units_weight" ? 0 : parent.width
                    opacity: root.sysCurrentScreen === "units_weight" ? 1.0 : 0.0
                    enabled: root.sysCurrentScreen === "units_weight"
                    visible: opacity > 0.001 || x < parent.width

                    Behavior on x { NumberAnimation { duration: 320; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 280; easing.type: Easing.InOutQuad } }

                    Flickable {
                        anchors.fill: parent
                        contentHeight: sysUnitsWeightCol.height + 40
                        clip: true
                        boundsBehavior: Flickable.DragAndOvershootBounds
                        flickableDirection: Flickable.VerticalFlick

                        Column {
                            id: sysUnitsWeightCol
                            width: parent.width
                            spacing: 0

                            SettingRowRadio {
                                title: "Pounds (lb)"
                                selected: root.unitsWeight === "Pounds (lb)"
                                onSelectedRequested: {
                                    root.unitsWeight = "Pounds (lb)";
                                    root.sysSlideDir = -1;
                                    root.sysCurrentScreen = "units";
                                }
                            }

                            SettingRowRadio {
                                title: "Kilograms (kg)"
                                selected: root.unitsWeight === "Kilograms (kg)"
                                onSelectedRequested: {
                                    root.unitsWeight = "Kilograms (kg)";
                                    root.sysSlideDir = -1;
                                    root.sysCurrentScreen = "units";
                                }
                            }
                        }
                    }
                }

                // -------------------------------------------------------------
                // LEVEL 3I: Time Zone Selection Sub-Menu
                // -------------------------------------------------------------
                Item {
                    id: sysTimeZoneSelectView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    x: root.sysCurrentScreen === "time_zone" ? 0 : parent.width
                    opacity: root.sysCurrentScreen === "time_zone" ? 1.0 : 0.0
                    enabled: root.sysCurrentScreen === "time_zone"
                    visible: opacity > 0.001 || x < parent.width

                    Behavior on x { NumberAnimation { duration: 320; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 280; easing.type: Easing.InOutQuad } }

                    Flickable {
                        anchors.fill: parent
                        contentHeight: sysTimeZoneCol.height + 40
                        clip: true
                        boundsBehavior: Flickable.DragAndOvershootBounds
                        flickableDirection: Flickable.VerticalFlick

                        Column {
                            id: sysTimeZoneCol
                            width: parent.width
                            spacing: 0

                            SettingRowRadio {
                                title: "GMT+05:30 India Standard Time (IST)"
                                subtitle: "India (New Delhi, Mumbai, Kolkata)"
                                selected: root.selectedTimeZone.indexOf("GMT+05:30") !== -1
                                onSelectedRequested: {
                                    root.selectedTimeZone = "GMT+05:30 India Standard Time (IST)";
                                    if (typeof SystemBackend !== "undefined") SystemBackend.selectedTimeZone = root.selectedTimeZone;
                                    root.sysSlideDir = -1;
                                    root.sysCurrentScreen = "time";
                                }
                            }

                            SettingRowRadio {
                                title: "GMT+00:00 Greenwich Mean Time (UTC / GMT)"
                                subtitle: "United Kingdom (London), Ireland (Dublin)"
                                selected: root.selectedTimeZone.indexOf("GMT+00:00") !== -1
                                onSelectedRequested: {
                                    root.selectedTimeZone = "GMT+00:00 Greenwich Mean Time (UTC / GMT)";
                                    if (typeof SystemBackend !== "undefined") SystemBackend.selectedTimeZone = root.selectedTimeZone;
                                    root.sysSlideDir = -1;
                                    root.sysCurrentScreen = "time";
                                }
                            }

                            SettingRowRadio {
                                title: "GMT+01:00 Central European Time (CET)"
                                subtitle: "Germany (Berlin), France (Paris), Italy (Rome)"
                                selected: root.selectedTimeZone.indexOf("GMT+01:00") !== -1
                                onSelectedRequested: {
                                    root.selectedTimeZone = "GMT+01:00 Central European Time (CET)";
                                    if (typeof SystemBackend !== "undefined") SystemBackend.selectedTimeZone = root.selectedTimeZone;
                                    root.sysSlideDir = -1;
                                    root.sysCurrentScreen = "time";
                                }
                            }

                            SettingRowRadio {
                                title: "GMT+02:00 Eastern European Time (EET)"
                                subtitle: "Greece (Athens), Egypt (Cairo), Finland (Helsinki)"
                                selected: root.selectedTimeZone.indexOf("GMT+02:00") !== -1
                                onSelectedRequested: {
                                    root.selectedTimeZone = "GMT+02:00 Eastern European Time (EET)";
                                    if (typeof SystemBackend !== "undefined") SystemBackend.selectedTimeZone = root.selectedTimeZone;
                                    root.sysSlideDir = -1;
                                    root.sysCurrentScreen = "time";
                                }
                            }

                            SettingRowRadio {
                                title: "GMT+03:00 Moscow / Arabia Time (MSK / AST)"
                                subtitle: "Saudi Arabia (Riyadh), Russia (Moscow)"
                                selected: root.selectedTimeZone.indexOf("GMT+03:00") !== -1
                                onSelectedRequested: {
                                    root.selectedTimeZone = "GMT+03:00 Moscow / Arabia Time (MSK / AST)";
                                    if (typeof SystemBackend !== "undefined") SystemBackend.selectedTimeZone = root.selectedTimeZone;
                                    root.sysSlideDir = -1;
                                    root.sysCurrentScreen = "time";
                                }
                            }

                            SettingRowRadio {
                                title: "GMT+04:00 Gulf Standard Time (GST)"
                                subtitle: "United Arab Emirates (Dubai, Abu Dhabi)"
                                selected: root.selectedTimeZone.indexOf("GMT+04:00") !== -1
                                onSelectedRequested: {
                                    root.selectedTimeZone = "GMT+04:00 Gulf Standard Time (GST)";
                                    if (typeof SystemBackend !== "undefined") SystemBackend.selectedTimeZone = root.selectedTimeZone;
                                    root.sysSlideDir = -1;
                                    root.sysCurrentScreen = "time";
                                }
                            }

                            SettingRowRadio {
                                title: "GMT+08:00 China / Singapore Time (CST / SGT)"
                                subtitle: "China (Beijing, Shanghai), Singapore"
                                selected: root.selectedTimeZone.indexOf("GMT+08:00") !== -1
                                onSelectedRequested: {
                                    root.selectedTimeZone = "GMT+08:00 China / Singapore Time (CST / SGT)";
                                    if (typeof SystemBackend !== "undefined") SystemBackend.selectedTimeZone = root.selectedTimeZone;
                                    root.sysSlideDir = -1;
                                    root.sysCurrentScreen = "time";
                                }
                            }

                            SettingRowRadio {
                                title: "GMT+09:00 Japan / Korea Standard Time (JST / KST)"
                                subtitle: "Japan (Tokyo), South Korea (Seoul)"
                                selected: root.selectedTimeZone.indexOf("GMT+09:00") !== -1
                                onSelectedRequested: {
                                    root.selectedTimeZone = "GMT+09:00 Japan / Korea Standard Time (JST / KST)";
                                    if (typeof SystemBackend !== "undefined") SystemBackend.selectedTimeZone = root.selectedTimeZone;
                                    root.sysSlideDir = -1;
                                    root.sysCurrentScreen = "time";
                                }
                            }

                            SettingRowRadio {
                                title: "GMT+10:00 Australian Eastern Time (AEST)"
                                subtitle: "Australia (Sydney, Melbourne, Brisbane)"
                                selected: root.selectedTimeZone.indexOf("GMT+10:00") !== -1
                                onSelectedRequested: {
                                    root.selectedTimeZone = "GMT+10:00 Australian Eastern Time (AEST)";
                                    if (typeof SystemBackend !== "undefined") SystemBackend.selectedTimeZone = root.selectedTimeZone;
                                    root.sysSlideDir = -1;
                                    root.sysCurrentScreen = "time";
                                }
                            }

                            SettingRowRadio {
                                title: "GMT-05:00 Eastern Standard Time (EST)"
                                subtitle: "United States (New York, Miami, Washington DC)"
                                selected: root.selectedTimeZone.indexOf("GMT-05:00") !== -1
                                onSelectedRequested: {
                                    root.selectedTimeZone = "GMT-05:00 Eastern Standard Time (EST)";
                                    if (typeof SystemBackend !== "undefined") SystemBackend.selectedTimeZone = root.selectedTimeZone;
                                    root.sysSlideDir = -1;
                                    root.sysCurrentScreen = "time";
                                }
                            }

                            SettingRowRadio {
                                title: "GMT-06:00 Central Standard Time (CST)"
                                subtitle: "United States (Chicago, Dallas, Houston)"
                                selected: root.selectedTimeZone.indexOf("GMT-06:00") !== -1
                                onSelectedRequested: {
                                    root.selectedTimeZone = "GMT-06:00 Central Standard Time (CST)";
                                    if (typeof SystemBackend !== "undefined") SystemBackend.selectedTimeZone = root.selectedTimeZone;
                                    root.sysSlideDir = -1;
                                    root.sysCurrentScreen = "time";
                                }
                            }

                            SettingRowRadio {
                                title: "GMT-07:00 Mountain Standard Time (MST)"
                                subtitle: "United States (Denver, Phoenix, Salt Lake City)"
                                selected: root.selectedTimeZone.indexOf("GMT-07:00") !== -1
                                onSelectedRequested: {
                                    root.selectedTimeZone = "GMT-07:00 Mountain Standard Time (MST)";
                                    if (typeof SystemBackend !== "undefined") SystemBackend.selectedTimeZone = root.selectedTimeZone;
                                    root.sysSlideDir = -1;
                                    root.sysCurrentScreen = "time";
                                }
                            }

                            SettingRowRadio {
                                title: "GMT-08:00 Pacific Standard Time (PST)"
                                subtitle: "United States (Los Angeles, San Francisco, Seattle)"
                                selected: root.selectedTimeZone.indexOf("GMT-08:00") !== -1
                                onSelectedRequested: {
                                    root.selectedTimeZone = "GMT-08:00 Pacific Standard Time (PST)";
                                    if (typeof SystemBackend !== "undefined") SystemBackend.selectedTimeZone = root.selectedTimeZone;
                                    root.sysSlideDir = -1;
                                    root.sysCurrentScreen = "time";
                                }
                            }
                        }
                    }
                }

                // -------------------------------------------------------------
                // LEVEL 3J: Set Time Sub-Menu
                // -------------------------------------------------------------
                Item {
                    id: sysTimeSetTimeView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    x: root.sysCurrentScreen === "time_set_time" ? 0 : parent.width
                    opacity: root.sysCurrentScreen === "time_set_time" ? 1.0 : 0.0
                    enabled: root.sysCurrentScreen === "time_set_time"
                    visible: opacity > 0.001 || x < parent.width

                    Behavior on x { NumberAnimation { duration: 320; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 280; easing.type: Easing.InOutQuad } }

                    Flickable {
                        anchors.fill: parent
                        contentHeight: sysSetTimeCol.height + 60
                        clip: true
                        boundsBehavior: Flickable.DragAndOvershootBounds
                        flickableDirection: Flickable.VerticalFlick

                        Column {
                            id: sysSetTimeCol
                            width: parent.width
                            spacing: 24

                            Item { width: 1; height: 10 }

                            Text {
                                text: "Manually adjust vehicle clock"
                                color: Qt.rgba(255, 255, 255, 0.6)
                                font.family: "Inter"
                                font.pixelSize: 17
                            }

                            // Stepper container
                            Row {
                                anchors.horizontalCenter: parent.horizontalCenter
                                spacing: 20

                                // Hours Block
                                Column {
                                    spacing: 12
                                    anchors.verticalCenter: parent.verticalCenter
                                    Text {
                                        text: "HOUR"
                                        color: Qt.rgba(255, 255, 255, 0.5)
                                        font.family: "Inter"
                                        font.pixelSize: 13
                                        font.weight: Font.DemiBold
                                        anchors.horizontalCenter: parent.horizontalCenter
                                    }
                                    Rectangle {
                                        width: 48; height: 48; radius: 24
                                        color: Qt.rgba(255, 255, 255, 0.08)
                                        border.color: Qt.rgba(255, 255, 255, 0.2)
                                        Text { anchors.centerIn: parent; text: "▲"; color: "#FFFFFF"; font.pixelSize: 16 }
                                        MouseArea {
                                            anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                                            onClicked: {
                                                var maxH = root.time24HourFormat ? 23 : 12;
                                                var minH = root.time24HourFormat ? 0 : 1;
                                                root.manualHour = (root.manualHour >= maxH) ? minH : root.manualHour + 1;
                                            }
                                        }
                                    }
                                    Rectangle {
                                        width: 80; height: 64; radius: 12
                                        color: Qt.rgba(255, 255, 255, 0.06)
                                        border.color: "#FB923C"
                                        border.width: 1.5
                                        Text {
                                            anchors.centerIn: parent
                                            text: (root.manualHour < 10 ? "0" : "") + root.manualHour
                                            color: "#FFFFFF"
                                            font.family: "Inter"
                                            font.pixelSize: 32
                                            font.weight: Font.Bold
                                        }
                                    }
                                    Rectangle {
                                        width: 48; height: 48; radius: 24
                                        color: Qt.rgba(255, 255, 255, 0.08)
                                        border.color: Qt.rgba(255, 255, 255, 0.2)
                                        Text { anchors.centerIn: parent; text: "▼"; color: "#FFFFFF"; font.pixelSize: 16 }
                                        MouseArea {
                                            anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                                            onClicked: {
                                                var maxH = root.time24HourFormat ? 23 : 12;
                                                var minH = root.time24HourFormat ? 0 : 1;
                                                root.manualHour = (root.manualHour <= minH) ? maxH : root.manualHour - 1;
                                            }
                                        }
                                    }
                                }

                                Text {
                                    text: ":"
                                    color: "#FB923C"
                                    font.pixelSize: 42
                                    font.weight: Font.Bold
                                    anchors.verticalCenter: parent.verticalCenter
                                }

                                // Minutes Block
                                Column {
                                    spacing: 12
                                    anchors.verticalCenter: parent.verticalCenter
                                    Text {
                                        text: "MINUTE"
                                        color: Qt.rgba(255, 255, 255, 0.5)
                                        font.family: "Inter"
                                        font.pixelSize: 13
                                        font.weight: Font.DemiBold
                                        anchors.horizontalCenter: parent.horizontalCenter
                                    }
                                    Rectangle {
                                        width: 48; height: 48; radius: 24
                                        color: Qt.rgba(255, 255, 255, 0.08)
                                        border.color: Qt.rgba(255, 255, 255, 0.2)
                                        Text { anchors.centerIn: parent; text: "▲"; color: "#FFFFFF"; font.pixelSize: 16 }
                                        MouseArea {
                                            anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                                            onClicked: root.manualMinute = (root.manualMinute >= 59) ? 0 : root.manualMinute + 1
                                        }
                                    }
                                    Rectangle {
                                        width: 80; height: 64; radius: 12
                                        color: Qt.rgba(255, 255, 255, 0.06)
                                        border.color: "#FB923C"
                                        border.width: 1.5
                                        Text {
                                            anchors.centerIn: parent
                                            text: (root.manualMinute < 10 ? "0" : "") + root.manualMinute
                                            color: "#FFFFFF"
                                            font.family: "Inter"
                                            font.pixelSize: 32
                                            font.weight: Font.Bold
                                        }
                                    }
                                    Rectangle {
                                        width: 48; height: 48; radius: 24
                                        color: Qt.rgba(255, 255, 255, 0.08)
                                        border.color: Qt.rgba(255, 255, 255, 0.2)
                                        Text { anchors.centerIn: parent; text: "▼"; color: "#FFFFFF"; font.pixelSize: 16 }
                                        MouseArea {
                                            anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                                            onClicked: root.manualMinute = (root.manualMinute <= 0) ? 59 : root.manualMinute - 1
                                        }
                                    }
                                }

                                // AM/PM Toggle (Only when in 12-hour mode)
                                Column {
                                    visible: !root.time24HourFormat
                                    spacing: 12
                                    anchors.verticalCenter: parent.verticalCenter
                                    Text {
                                        text: "PERIOD"
                                        color: Qt.rgba(255, 255, 255, 0.5)
                                        font.family: "Inter"
                                        font.pixelSize: 13
                                        font.weight: Font.DemiBold
                                        anchors.horizontalCenter: parent.horizontalCenter
                                    }
                                    Rectangle {
                                        width: 68; height: 46; radius: 10
                                        color: root.manualAmPm === "AM" ? "#FB923C" : Qt.rgba(255, 255, 255, 0.08)
                                        border.color: root.manualAmPm === "AM" ? "#F97316" : Qt.rgba(255, 255, 255, 0.2)
                                        Text {
                                            anchors.centerIn: parent; text: "AM"
                                            color: root.manualAmPm === "AM" ? "#000000" : "#FFFFFF"
                                            font.family: "Inter"; font.pixelSize: 16; font.weight: Font.Bold
                                        }
                                        MouseArea {
                                            anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                                            onClicked: root.manualAmPm = "AM"
                                        }
                                    }
                                    Rectangle {
                                        width: 68; height: 46; radius: 10
                                        color: root.manualAmPm === "PM" ? "#FB923C" : Qt.rgba(255, 255, 255, 0.08)
                                        border.color: root.manualAmPm === "PM" ? "#F97316" : Qt.rgba(255, 255, 255, 0.2)
                                        Text {
                                            anchors.centerIn: parent; text: "PM"
                                            color: root.manualAmPm === "PM" ? "#000000" : "#FFFFFF"
                                            font.family: "Inter"; font.pixelSize: 16; font.weight: Font.Bold
                                        }
                                        MouseArea {
                                            anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                                            onClicked: root.manualAmPm = "PM"
                                        }
                                    }
                                }
                            }

                            // Action buttons
                            Row {
                                anchors.horizontalCenter: parent.horizontalCenter
                                spacing: 18

                                Rectangle {
                                    width: 140; height: 50; radius: 25
                                    color: Qt.rgba(255, 255, 255, 0.1)
                                    border.color: Qt.rgba(255, 255, 255, 0.2)
                                    Text { anchors.centerIn: parent; text: "Cancel"; color: "#FFFFFF"; font.pixelSize: 17; font.weight: Font.DemiBold }
                                    MouseArea {
                                        anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                                        onClicked: {
                                            root.sysSlideDir = -1;
                                            root.sysCurrentScreen = "time";
                                        }
                                    }
                                }

                                Rectangle {
                                    width: 160; height: 50; radius: 25
                                    color: "#FB923C"
                                    Text { anchors.centerIn: parent; text: "Save Time"; color: "#000000"; font.pixelSize: 17; font.weight: Font.Bold }
                                    MouseArea {
                                        anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                                        onClicked: {
                                            var h = root.manualHour;
                                            if (!root.time24HourFormat) {
                                                if (root.manualAmPm === "PM" && h < 12) h += 12;
                                                if (root.manualAmPm === "AM" && h === 12) h = 0;
                                            }
                                            if (typeof SystemBackend !== "undefined") {
                                                SystemBackend.setManualTime(h, root.manualMinute);
                                            }
                                            root.sysSlideDir = -1;
                                            root.sysCurrentScreen = "time";
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                // -------------------------------------------------------------
                // LEVEL 3K: Set Date Sub-Menu
                // -------------------------------------------------------------
                Item {
                    id: sysTimeSetDateView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    x: root.sysCurrentScreen === "time_set_date" ? 0 : parent.width
                    opacity: root.sysCurrentScreen === "time_set_date" ? 1.0 : 0.0
                    enabled: root.sysCurrentScreen === "time_set_date"
                    visible: opacity > 0.001 || x < parent.width

                    Behavior on x { NumberAnimation { duration: 320; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 280; easing.type: Easing.InOutQuad } }

                    Flickable {
                        anchors.fill: parent
                        contentHeight: sysSetDateCol.height + 60
                        clip: true
                        boundsBehavior: Flickable.DragAndOvershootBounds
                        flickableDirection: Flickable.VerticalFlick

                        Column {
                            id: sysSetDateCol
                            width: parent.width
                            spacing: 24

                            Item { width: 1; height: 10 }

                            Text {
                                text: "Manually adjust vehicle calendar date"
                                color: Qt.rgba(255, 255, 255, 0.6)
                                font.family: "Inter"
                                font.pixelSize: 17
                            }

                            Row {
                                anchors.horizontalCenter: parent.horizontalCenter
                                spacing: 20

                                // Month Block
                                Column {
                                    spacing: 12
                                    anchors.verticalCenter: parent.verticalCenter
                                    Text {
                                        text: "MONTH"
                                        color: Qt.rgba(255, 255, 255, 0.5)
                                        font.family: "Inter"
                                        font.pixelSize: 13
                                        font.weight: Font.DemiBold
                                        anchors.horizontalCenter: parent.horizontalCenter
                                    }
                                    Rectangle {
                                        width: 48; height: 48; radius: 24
                                        color: Qt.rgba(255, 255, 255, 0.08)
                                        border.color: Qt.rgba(255, 255, 255, 0.2)
                                        Text { anchors.centerIn: parent; text: "▲"; color: "#FFFFFF"; font.pixelSize: 16 }
                                        MouseArea {
                                            anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                                            onClicked: root.manualMonth = (root.manualMonth >= 12) ? 1 : root.manualMonth + 1
                                        }
                                    }
                                    Rectangle {
                                        width: 100; height: 64; radius: 12
                                        color: Qt.rgba(255, 255, 255, 0.06)
                                        border.color: "#FB923C"
                                        border.width: 1.5
                                        Text {
                                            readonly property var months: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
                                            anchors.centerIn: parent
                                            text: months[root.manualMonth - 1]
                                            color: "#FFFFFF"
                                            font.family: "Inter"
                                            font.pixelSize: 26
                                            font.weight: Font.Bold
                                        }
                                    }
                                    Rectangle {
                                        width: 48; height: 48; radius: 24
                                        color: Qt.rgba(255, 255, 255, 0.08)
                                        border.color: Qt.rgba(255, 255, 255, 0.2)
                                        Text { anchors.centerIn: parent; text: "▼"; color: "#FFFFFF"; font.pixelSize: 16 }
                                        MouseArea {
                                            anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                                            onClicked: root.manualMonth = (root.manualMonth <= 1) ? 12 : root.manualMonth - 1
                                        }
                                    }
                                }

                                // Day Block
                                Column {
                                    spacing: 12
                                    anchors.verticalCenter: parent.verticalCenter
                                    Text {
                                        text: "DAY"
                                        color: Qt.rgba(255, 255, 255, 0.5)
                                        font.family: "Inter"
                                        font.pixelSize: 13
                                        font.weight: Font.DemiBold
                                        anchors.horizontalCenter: parent.horizontalCenter
                                    }
                                    Rectangle {
                                        width: 48; height: 48; radius: 24
                                        color: Qt.rgba(255, 255, 255, 0.08)
                                        border.color: Qt.rgba(255, 255, 255, 0.2)
                                        Text { anchors.centerIn: parent; text: "▲"; color: "#FFFFFF"; font.pixelSize: 16 }
                                        MouseArea {
                                            anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                                            onClicked: root.manualDay = (root.manualDay >= 31) ? 1 : root.manualDay + 1
                                        }
                                    }
                                    Rectangle {
                                        width: 80; height: 64; radius: 12
                                        color: Qt.rgba(255, 255, 255, 0.06)
                                        border.color: "#FB923C"
                                        border.width: 1.5
                                        Text {
                                            anchors.centerIn: parent
                                            text: (root.manualDay < 10 ? "0" : "") + root.manualDay
                                            color: "#FFFFFF"
                                            font.family: "Inter"
                                            font.pixelSize: 32
                                            font.weight: Font.Bold
                                        }
                                    }
                                    Rectangle {
                                        width: 48; height: 48; radius: 24
                                        color: Qt.rgba(255, 255, 255, 0.08)
                                        border.color: Qt.rgba(255, 255, 255, 0.2)
                                        Text { anchors.centerIn: parent; text: "▼"; color: "#FFFFFF"; font.pixelSize: 16 }
                                        MouseArea {
                                            anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                                            onClicked: root.manualDay = (root.manualDay <= 1) ? 31 : root.manualDay - 1
                                        }
                                    }
                                }

                                // Year Block
                                Column {
                                    spacing: 12
                                    anchors.verticalCenter: parent.verticalCenter
                                    Text {
                                        text: "YEAR"
                                        color: Qt.rgba(255, 255, 255, 0.5)
                                        font.family: "Inter"
                                        font.pixelSize: 13
                                        font.weight: Font.DemiBold
                                        anchors.horizontalCenter: parent.horizontalCenter
                                    }
                                    Rectangle {
                                        width: 48; height: 48; radius: 24
                                        color: Qt.rgba(255, 255, 255, 0.08)
                                        border.color: Qt.rgba(255, 255, 255, 0.2)
                                        Text { anchors.centerIn: parent; text: "▲"; color: "#FFFFFF"; font.pixelSize: 16 }
                                        MouseArea {
                                            anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                                            onClicked: root.manualYear += 1
                                        }
                                    }
                                    Rectangle {
                                        width: 100; height: 64; radius: 12
                                        color: Qt.rgba(255, 255, 255, 0.06)
                                        border.color: "#FB923C"
                                        border.width: 1.5
                                        Text {
                                            anchors.centerIn: parent
                                            text: root.manualYear
                                            color: "#FFFFFF"
                                            font.family: "Inter"
                                            font.pixelSize: 28
                                            font.weight: Font.Bold
                                        }
                                    }
                                    Rectangle {
                                        width: 48; height: 48; radius: 24
                                        color: Qt.rgba(255, 255, 255, 0.08)
                                        border.color: Qt.rgba(255, 255, 255, 0.2)
                                        Text { anchors.centerIn: parent; text: "▼"; color: "#FFFFFF"; font.pixelSize: 16 }
                                        MouseArea {
                                            anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                                            onClicked: root.manualYear -= 1
                                        }
                                    }
                                }
                            }

                            // Action buttons
                            Row {
                                anchors.horizontalCenter: parent.horizontalCenter
                                spacing: 18

                                Rectangle {
                                    width: 140; height: 50; radius: 25
                                    color: Qt.rgba(255, 255, 255, 0.1)
                                    border.color: Qt.rgba(255, 255, 255, 0.2)
                                    Text { anchors.centerIn: parent; text: "Cancel"; color: "#FFFFFF"; font.pixelSize: 17; font.weight: Font.DemiBold }
                                    MouseArea {
                                        anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                                        onClicked: {
                                            root.sysSlideDir = -1;
                                            root.sysCurrentScreen = "time";
                                        }
                                    }
                                }

                                Rectangle {
                                    width: 160; height: 50; radius: 25
                                    color: "#FB923C"
                                    Text { anchors.centerIn: parent; text: "Save Date"; color: "#000000"; font.pixelSize: 17; font.weight: Font.Bold }
                                    MouseArea {
                                        anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                                        onClicked: {
                                            if (typeof SystemBackend !== "undefined") {
                                                SystemBackend.setManualDate(root.manualYear, root.manualMonth, root.manualDay);
                                            }
                                            root.sysSlideDir = -1;
                                            root.sysCurrentScreen = "time";
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }

            // =================================================================
            // CATEGORY: PROFILE (Fully Workable Matching Reference Photos)
            // =================================================================
            Item {
                id: profileContainer
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                visible: root.activeCategory === "profile"
                clip: true

                // -------------------------------------------------------------
                // LEVEL 1: MAIN PROFILE VIEW (Matches Image 1 & Image 4)
                // -------------------------------------------------------------
                Item {
                    id: profMainView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    x: root.profCurrentScreen === "main" ? 0 : -parent.width * 0.4
                    opacity: root.profCurrentScreen === "main" ? 1.0 : 0.0
                    enabled: root.profCurrentScreen === "main"
                    visible: opacity > 0.001 || x > -parent.width * 0.4

                    Behavior on x { NumberAnimation { duration: 320; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 280; easing.type: Easing.InOutQuad } }

                    Flickable {
                        anchors.fill: parent
                        contentHeight: profMainCol.height + 40
                        clip: true
                        boundsBehavior: Flickable.DragAndOvershootBounds
                        flickableDirection: Flickable.VerticalFlick

                        Column {
                            id: profMainCol
                            width: parent.width
                            spacing: 0

                            // Profile Header Row (Matches Image 1 & Image 4 & Image 2)
                            Item {
                                width: parent.width
                                height: 80

                                Row {
                                    anchors.left: parent.left
                                    anchors.leftMargin: 8
                                    anchors.verticalCenter: parent.verticalCenter
                                    spacing: 16

                                    // Left vertical accent bar (subtle OEM accent)
                                    Rectangle {
                                        width: 2
                                        height: 48
                                        anchors.verticalCenter: parent.verticalCenter
                                        color: Qt.rgba(255, 255, 255, 0.20)
                                    }

                                    // Avatar Circle (56x56) - 100% Circle
                                    Item {
                                        width: 56
                                        height: 56

                                        // Monogram (P1)
                                        Rectangle {
                                            anchors.fill: parent
                                            radius: 28
                                            visible: root.currentProfileAvatar === "monogram"
                                            gradient: Gradient {
                                                GradientStop { position: 0.0; color: "#2563EB" }
                                                GradientStop { position: 1.0; color: "#1D4ED8" }
                                            }
                                            Text {
                                                anchors.centerIn: parent
                                                text: root.currentProfileName.length >= 2 ? (root.currentProfileName.substring(0, 1).toUpperCase() + (root.currentProfileName.indexOf(" ") !== -1 ? root.currentProfileName.split(" ")[1].substring(0, 1) : root.currentProfileName.substring(1, 2))) : "P1"
                                                color: "#FFFFFF"
                                                font.family: "Inter"
                                                font.pixelSize: 20
                                                font.weight: Font.Bold
                                            }
                                        }

                                        // Image Avatar with True Circular Masking
                                        CircularAvatarImage {
                                            anchors.fill: parent
                                            visible: root.currentProfileAvatar !== "monogram"
                                            source: root.getAvatarPath(root.currentProfileAvatar)
                                            radius: 28
                                        }

                                        // Circular border
                                        Rectangle {
                                            anchors.fill: parent
                                            radius: 28
                                            color: "transparent"
                                            border.color: Qt.rgba(255, 255, 255, 0.25)
                                            border.width: 1.5
                                        }
                                    }

                                    Column {
                                        anchors.verticalCenter: parent.verticalCenter
                                        spacing: 4

                                        Text {
                                            text: root.currentProfileName
                                            color: "#FFFFFF"
                                            font.family: "Inter"
                                            font.pixelSize: 22
                                            font.weight: Font.DemiBold
                                        }

                                        Text {
                                            text: "Signed in as admin"
                                            color: "#94A3B8"
                                            font.family: "Inter"
                                            font.pixelSize: 15
                                        }
                                    }
                                }

                                Rectangle {
                                    anchors.bottom: parent.bottom
                                    anchors.left: parent.left
                                    anchors.right: parent.right
                                    height: 1
                                    color: Qt.rgba(255, 255, 255, 0.08)
                                }
                            }

                            SettingRowChevron {
                                title: "Switch profile"
                                subtitle: (typeof VehicleBackend !== "undefined" ? VehicleBackend.profileCount : 1) + " of 3 saved profiles · Tap to switch or add"
                                onClicked: {
                                    if (typeof pageStack !== "undefined") {
                                        pageStack.currentIndex = 11;
                                    }
                                }
                            }

                            SettingRowChevron {
                                title: "Profile name"
                                subtitle: root.currentProfileName
                                onClicked: {
                                    root.profSlideDir = 1;
                                    root.tempProfileNameInput = root.currentProfileName;
                                    root.profCurrentScreen = "name";
                                }
                            }

                            SettingRowChevron {
                                title: "Profile avatar"
                                onClicked: {
                                    root.profSlideDir = 1;
                                    root.selectedAvatarPreview = root.currentProfileAvatar;
                                    root.profCurrentScreen = "avatar";
                                }
                            }

                            SettingRowChevron {
                                title: "Link profile"
                                subtitle: root.keyFobLinked ? "Key Fob 1, Phone As A Key linked" : "No devices linked"
                                onClicked: {
                                    root.profSlideDir = 1;
                                    root.profCurrentScreen = "link_profile";
                                }
                            }

                            SettingRowChevron {
                                title: "Security"
                                subtitle: root.currentLockType === "None" ? "None" : (root.currentLockType + " lock active")
                                onClicked: {
                                    root.profSlideDir = 1;
                                    root.profCurrentScreen = "security";
                                }
                            }

                            SettingRowChevron {
                                title: "Accounts"
                                subtitle: "Apex Cloud, Google Services, Spotify"
                                onClicked: {
                                    root.profSlideDir = 1;
                                    root.profCurrentScreen = "accounts";
                                }
                            }

                            SettingRowChevron {
                                title: "Delete profile"
                                showChevron: false
                                onClicked: {
                                    root.deleteProfileModalOpen = true;
                                }
                            }
                        }
                    }
                }

                // -------------------------------------------------------------
                // LEVEL 2A: PROFILE NAME TOUCH VIEW (Exact Match to New Photo)
                // -------------------------------------------------------------
                Item {
                    id: profNameView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    x: root.profCurrentScreen === "name" ? 0 :
                       (root.profCurrentScreen === "main" ? parent.width : -parent.width * 0.4)
                    opacity: root.profCurrentScreen === "name" ? 1.0 : 0.0
                    enabled: root.profCurrentScreen === "name"
                    visible: opacity > 0.001 || (x > -parent.width * 0.4 && x < parent.width)

                    Behavior on x { NumberAnimation { duration: 320; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 280; easing.type: Easing.InOutQuad } }

                    // Top Underline Input Box (Matches Reference Photo)
                    Item {
                        id: profNameInputRow
                        anchors.top: parent.top
                        anchors.topMargin: 12
                        anchors.left: parent.left
                        anchors.leftMargin: 8
                        anchors.right: parent.right
                        anchors.rightMargin: 16
                        height: 76

                        // Back Arrow on Top Left (Touch Screen navigation)
                        Item {
                            id: profNameBackBtn
                            anchors.left: parent.left
                            anchors.verticalCenter: profNameField.verticalCenter
                            width: 44
                            height: 44

                            Text {
                                anchors.centerIn: parent
                                text: "←"
                                font.pixelSize: 26
                                font.weight: Font.DemiBold
                                color: profNameBackMouse.pressed ? "#94A3B8" : (profNameBackMouse.containsMouse ? "#FFFFFF" : "#E2E8F0")
                            }

                            MouseArea {
                                id: profNameBackMouse
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    root.profSlideDir = -1;
                                    root.profCurrentScreen = "main";
                                }
                            }
                        }

                        TextInput {
                            id: profNameField
                            anchors.top: parent.top
                            anchors.left: profNameBackBtn.right
                            anchors.leftMargin: 16
                            anchors.right: profNameClearBtn.left
                            anchors.rightMargin: 12
                            height: 38
                            text: root.tempProfileNameInput
                            color: "#FFFFFF"
                            font.family: "Inter"
                            font.pixelSize: 26
                            font.weight: Font.DemiBold
                            cursorVisible: true
                            focus: root.profCurrentScreen === "name"
                            onTextChanged: root.tempProfileNameInput = text
                            Keys.onReturnPressed: {
                                if (root.tempProfileNameInput.trim().length > 0) {
                                    root.currentProfileName = root.tempProfileNameInput.trim();
                                    if (typeof VehicleBackend !== "undefined") VehicleBackend.setDriverProfileName(root.currentProfileName);
                                    root.profileToastMessage = "Profile renamed to " + root.currentProfileName;
                                    profToastTimer.restart();
                                }
                                root.profSlideDir = -1;
                                root.profCurrentScreen = "main";
                            }
                        }

                        // (x) Clear Button
                        Rectangle {
                            id: profNameClearBtn
                            anchors.right: parent.right
                            anchors.verticalCenter: profNameField.verticalCenter
                            width: 32
                            height: 32
                            radius: 16
                            color: Qt.rgba(255, 255, 255, 0.15)
                            visible: root.tempProfileNameInput.length > 0

                            Text {
                                anchors.centerIn: parent
                                text: "✕"
                                color: "#FFFFFF"
                                font.pixelSize: 14
                                font.weight: Font.Bold
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    root.tempProfileNameInput = "";
                                    profNameField.text = "";
                                }
                            }
                        }

                        // Hairline Underline
                        Rectangle {
                            anchors.top: profNameField.bottom
                            anchors.topMargin: 4
                            anchors.left: profNameField.left
                            anchors.right: parent.right
                            height: 1.5
                            color: Qt.rgba(255, 255, 255, 0.35)
                        }

                        // Prompt Subtitle
                        Text {
                            anchors.top: profNameField.bottom
                            anchors.topMargin: 10
                            anchors.left: profNameField.left
                            text: "Enter a profile name"
                            color: "#94A3B8"
                            font.family: "Inter"
                            font.pixelSize: 15
                        }
                    }

                    // Microphone Icon on Right (Matches Photo)
                    Image {
                        anchors.top: profNameInputRow.bottom
                        anchors.topMargin: 10
                        anchors.right: parent.right
                        anchors.rightMargin: 36
                        width: 24
                        height: 24
                        source: "qrc:/ApexVision/qml/assets/icons/icon_mic.svg"
                        fillMode: Image.PreserveAspectFit

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                root.profileToastMessage = "Voice typing ready: listening...";
                                profToastTimer.restart();
                            }
                        }
                    }

                    // Touch Virtual QWERTY Keyboard (Matches Photo)
                    Item {
                        id: profKeyboardContainer
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 14
                        height: 250

                        property bool shiftActive: false

                        Column {
                            anchors.centerIn: parent
                            spacing: 8

                            // Row 1: q w e r t y u i o p
                            Row {
                                anchors.horizontalCenter: parent.horizontalCenter
                                spacing: 6
                                Repeater {
                                    model: ["q", "w", "e", "r", "t", "y", "u", "i", "o", "p"]
                                    Rectangle {
                                        width: 58; height: 50; radius: 8
                                        color: keyM1.pressed ? Qt.rgba(255, 255, 255, 0.22) :
                                               (keyM1.containsMouse ? Qt.rgba(255, 255, 255, 0.12) : Qt.rgba(255, 255, 255, 0.07))
                                        border.color: Qt.rgba(255, 255, 255, 0.12); border.width: 1
                                        Text {
                                            anchors.centerIn: parent
                                            text: profKeyboardContainer.shiftActive ? modelData.toUpperCase() : modelData
                                            color: "#FFFFFF"; font.family: "Inter"; font.pixelSize: 22; font.weight: Font.DemiBold
                                        }
                                        MouseArea {
                                            id: keyM1; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor
                                            onClicked: {
                                                var ch = profKeyboardContainer.shiftActive ? modelData.toUpperCase() : modelData;
                                                root.tempProfileNameInput += ch;
                                            }
                                        }
                                    }
                                }
                            }

                            // Row 2: a s d f g h j k l
                            Row {
                                anchors.horizontalCenter: parent.horizontalCenter
                                spacing: 6
                                Repeater {
                                    model: ["a", "s", "d", "f", "g", "h", "j", "k", "l"]
                                    Rectangle {
                                        width: 58; height: 50; radius: 8
                                        color: keyM2.pressed ? Qt.rgba(255, 255, 255, 0.22) :
                                               (keyM2.containsMouse ? Qt.rgba(255, 255, 255, 0.12) : Qt.rgba(255, 255, 255, 0.07))
                                        border.color: Qt.rgba(255, 255, 255, 0.12); border.width: 1
                                        Text {
                                            anchors.centerIn: parent
                                            text: profKeyboardContainer.shiftActive ? modelData.toUpperCase() : modelData
                                            color: "#FFFFFF"; font.family: "Inter"; font.pixelSize: 22; font.weight: Font.DemiBold
                                        }
                                        MouseArea {
                                            id: keyM2; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor
                                            onClicked: {
                                                var ch = profKeyboardContainer.shiftActive ? modelData.toUpperCase() : modelData;
                                                root.tempProfileNameInput += ch;
                                            }
                                        }
                                    }
                                }
                            }

                            // Row 3: Shift, z x c v b n m, Backspace
                            Row {
                                anchors.horizontalCenter: parent.horizontalCenter
                                spacing: 6

                                // Shift Key
                                Rectangle {
                                    width: 76; height: 50; radius: 8
                                    color: profKeyboardContainer.shiftActive ? "#38BDF8" :
                                           (keyShiftM.pressed ? Qt.rgba(255, 255, 255, 0.22) : Qt.rgba(255, 255, 255, 0.07))
                                    border.color: Qt.rgba(255, 255, 255, 0.15); border.width: 1
                                    Text {
                                        anchors.centerIn: parent
                                        text: "⇧"
                                        color: profKeyboardContainer.shiftActive ? "#0F172A" : "#FFFFFF"
                                        font.pixelSize: 22; font.weight: Font.Bold
                                    }
                                    MouseArea {
                                        id: keyShiftM; anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                                        onClicked: profKeyboardContainer.shiftActive = !profKeyboardContainer.shiftActive
                                    }
                                }

                                // Letters z x c v b n m
                                Repeater {
                                    model: ["z", "x", "c", "v", "b", "n", "m"]
                                    Rectangle {
                                        width: 58; height: 50; radius: 8
                                        color: keyM3.pressed ? Qt.rgba(255, 255, 255, 0.22) :
                                               (keyM3.containsMouse ? Qt.rgba(255, 255, 255, 0.12) : Qt.rgba(255, 255, 255, 0.07))
                                        border.color: Qt.rgba(255, 255, 255, 0.12); border.width: 1
                                        Text {
                                            anchors.centerIn: parent
                                            text: profKeyboardContainer.shiftActive ? modelData.toUpperCase() : modelData
                                            color: "#FFFFFF"; font.family: "Inter"; font.pixelSize: 22; font.weight: Font.DemiBold
                                        }
                                        MouseArea {
                                            id: keyM3; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor
                                            onClicked: {
                                                var ch = profKeyboardContainer.shiftActive ? modelData.toUpperCase() : modelData;
                                                root.tempProfileNameInput += ch;
                                            }
                                        }
                                    }
                                }

                                // Backspace Key
                                Rectangle {
                                    width: 76; height: 50; radius: 8
                                    color: keyBkM.pressed ? Qt.rgba(255, 255, 255, 0.22) :
                                           (keyBkM.containsMouse ? Qt.rgba(255, 255, 255, 0.12) : Qt.rgba(255, 255, 255, 0.07))
                                    border.color: Qt.rgba(255, 255, 255, 0.15); border.width: 1
                                    Text {
                                        anchors.centerIn: parent
                                        text: "⌫"
                                        color: "#FFFFFF"; font.pixelSize: 20; font.weight: Font.DemiBold
                                    }
                                    MouseArea {
                                        id: keyBkM; anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                                        onClicked: {
                                            if (root.tempProfileNameInput.length > 0) {
                                                root.tempProfileNameInput = root.tempProfileNameInput.slice(0, -1);
                                            }
                                        }
                                    }
                                }
                            }

                            // Row 4: Globe, Spacebar, Period, Enter
                            Row {
                                anchors.horizontalCenter: parent.horizontalCenter
                                spacing: 6

                                // Globe key
                                Rectangle {
                                    width: 60; height: 50; radius: 8
                                    color: Qt.rgba(255, 255, 255, 0.07)
                                    border.color: Qt.rgba(255, 255, 255, 0.12); border.width: 1
                                    Text {
                                        anchors.centerIn: parent
                                        text: "🌐"
                                        font.pixelSize: 20
                                    }
                                    MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor }
                                }

                                // Spacebar
                                Rectangle {
                                    width: 360; height: 50; radius: 8
                                    color: keySpaceM.pressed ? Qt.rgba(255, 255, 255, 0.22) :
                                           (keySpaceM.containsMouse ? Qt.rgba(255, 255, 255, 0.12) : Qt.rgba(255, 255, 255, 0.07))
                                    border.color: Qt.rgba(255, 255, 255, 0.15); border.width: 1
                                    Text {
                                        anchors.centerIn: parent
                                        text: "English (United States)"
                                        color: "#94A3B8"; font.family: "Inter"; font.pixelSize: 15; font.weight: Font.Medium
                                    }
                                    MouseArea {
                                        id: keySpaceM; anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                                        onClicked: root.tempProfileNameInput += " "
                                    }
                                }

                                // Period Key
                                Rectangle {
                                    width: 58; height: 50; radius: 8
                                    color: keyDotM.pressed ? Qt.rgba(255, 255, 255, 0.22) :
                                           (keyDotM.containsMouse ? Qt.rgba(255, 255, 255, 0.12) : Qt.rgba(255, 255, 255, 0.07))
                                    border.color: Qt.rgba(255, 255, 255, 0.12); border.width: 1
                                    Text {
                                        anchors.centerIn: parent
                                        text: "."
                                        color: "#FFFFFF"; font.family: "Inter"; font.pixelSize: 24; font.weight: Font.Bold
                                    }
                                    MouseArea {
                                        id: keyDotM; anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                                        onClicked: root.tempProfileNameInput += "."
                                    }
                                }

                                // Enter Key with Amber Border (Matches Photo)
                                Rectangle {
                                    width: 90; height: 50; radius: 8
                                    color: keyEnterM.pressed ? Qt.rgba(251, 146, 60, 0.25) :
                                           (keyEnterM.containsMouse ? Qt.rgba(251, 146, 60, 0.15) : Qt.rgba(255, 255, 255, 0.07))
                                    border.color: "#FB923C"
                                    border.width: 2

                                    Text {
                                        anchors.centerIn: parent
                                        text: "⏎"
                                        color: "#FFFFFF"; font.pixelSize: 22; font.weight: Font.Bold
                                    }

                                    MouseArea {
                                        id: keyEnterM; anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                                        onClicked: {
                                            if (root.tempProfileNameInput.trim().length > 0) {
                                                root.currentProfileName = root.tempProfileNameInput.trim();
                                                if (typeof VehicleBackend !== "undefined") VehicleBackend.setDriverProfileName(root.currentProfileName);
                                                root.profileToastMessage = "Profile renamed to " + root.currentProfileName;
                                                profToastTimer.restart();
                                            }
                                            root.profSlideDir = -1;
                                            root.profCurrentScreen = "main";
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                // -------------------------------------------------------------
                // LEVEL 2B: PROFILE AVATAR VIEW (Matches Image 2 & Image 3)
                // -------------------------------------------------------------
                Item {
                    id: profAvatarView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    x: root.profCurrentScreen === "avatar" ? 0 :
                       (root.profCurrentScreen === "main" ? parent.width : -parent.width * 0.4)
                    opacity: root.profCurrentScreen === "avatar" ? 1.0 : 0.0
                    enabled: root.profCurrentScreen === "avatar"
                    visible: opacity > 0.001 || (x > -parent.width * 0.4 && x < parent.width)

                    Behavior on x { NumberAnimation { duration: 320; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 280; easing.type: Easing.InOutQuad } }

                    // Left Column (Big Preview + Profile Name + Save Button)
                    Item {
                        id: profAvatarLeftCol
                        anchors.left: parent.left
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        width: 250

                        Column {
                            anchors.centerIn: parent
                            spacing: 18

                            // Large Circular Avatar (170x170)
                            Item {
                                anchors.horizontalCenter: parent.horizontalCenter
                                width: 170
                                height: 170

                                // Large Monogram Preview
                                Rectangle {
                                    anchors.fill: parent
                                    radius: 85
                                    visible: root.selectedAvatarPreview === "monogram"
                                    gradient: Gradient {
                                        GradientStop { position: 0.0; color: "#2563EB" }
                                        GradientStop { position: 1.0; color: "#1D4ED8" }
                                    }
                                    Text {
                                        anchors.centerIn: parent
                                        text: root.currentProfileName.length >= 2 ? (root.currentProfileName.substring(0, 1).toUpperCase() + (root.currentProfileName.indexOf(" ") !== -1 ? root.currentProfileName.split(" ")[1].substring(0, 1) : root.currentProfileName.substring(1, 2))) : "P1"
                                        color: "#FFFFFF"
                                        font.family: "Inter"
                                        font.pixelSize: 60
                                        font.weight: Font.Bold
                                    }
                                }

                                // Large Image Preview with True Circular Masking
                                CircularAvatarImage {
                                    anchors.fill: parent
                                    visible: root.selectedAvatarPreview !== "monogram"
                                    source: root.getAvatarPath(root.selectedAvatarPreview)
                                    radius: 85
                                }

                                // Outer glowing cyan ring border
                                Rectangle {
                                    anchors.fill: parent
                                    radius: 85
                                    color: "transparent"
                                    border.color: "#38BDF8"
                                    border.width: 3.5
                                }
                            }

                            // Profile Name
                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: root.currentProfileName
                                color: "#FFFFFF"
                                font.family: "Inter"
                                font.pixelSize: 24
                                font.weight: Font.DemiBold
                            }

                            // Save Button (Matches Image 3)
                            Rectangle {
                                anchors.horizontalCenter: parent.horizontalCenter
                                width: 140
                                height: 48
                                radius: 12
                                color: saveAvatarMouse.pressed ? Qt.rgba(255, 255, 255, 0.20) :
                                       (saveAvatarMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.12) : Qt.rgba(255, 255, 255, 0.06))
                                border.color: "#FB923C"
                                border.width: 1.5

                                Text {
                                    anchors.centerIn: parent
                                    text: "Save"
                                    color: "#FFFFFF"
                                    font.family: "Inter"
                                    font.pixelSize: 17
                                    font.weight: Font.DemiBold
                                }

                                MouseArea {
                                    id: saveAvatarMouse
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                        root.currentProfileAvatar = root.selectedAvatarPreview;
                                        if (typeof VehicleBackend !== "undefined") VehicleBackend.setDriverProfileAvatar(root.currentProfileAvatar, root.getAvatarPath(root.currentProfileAvatar));
                                        root.profileToastMessage = "Avatar saved successfully";
                                        profToastTimer.restart();
                                        root.profSlideDir = -1;
                                        root.profCurrentScreen = "main";
                                    }
                                }
                            }
                        }
                    }

                    // Right Side: Scrollable Grid of Avatars
                    Item {
                        anchors.left: profAvatarLeftCol.right
                        anchors.leftMargin: 16
                        anchors.right: parent.right
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom

                        Flickable {
                            anchors.fill: parent
                            contentHeight: avatarGrid.height + 40
                            clip: true
                            boundsBehavior: Flickable.DragAndOvershootBounds
                            flickableDirection: Flickable.VerticalFlick

                            Grid {
                                id: avatarGrid
                                anchors.horizontalCenter: parent.horizontalCenter
                                columns: 3
                                spacing: 22

                                Repeater {
                                    model: root.avatarList

                                    Item {
                                        width: 104
                                        height: 104

                                        // Glowing Selection Ring
                                        Rectangle {
                                            anchors.centerIn: parent
                                            width: 104
                                            height: 104
                                            radius: 52
                                            color: "transparent"
                                            border.color: "#38BDF8"
                                            border.width: 3.5
                                            visible: root.selectedAvatarPreview === modelData.id
                                        }

                                        // Avatar Circle (90x90)
                                        Item {
                                            anchors.centerIn: parent
                                            width: 90
                                            height: 90

                                            // Monogram circle
                                            Rectangle {
                                                anchors.fill: parent
                                                radius: 45
                                                visible: modelData.type === "monogram"
                                                gradient: Gradient {
                                                    GradientStop { position: 0.0; color: "#2563EB" }
                                                    GradientStop { position: 1.0; color: "#1D4ED8" }
                                                }
                                                Text {
                                                    anchors.centerIn: parent
                                                    text: "P1"
                                                    color: "#FFFFFF"
                                                    font.family: "Inter"
                                                    font.pixelSize: 32
                                                    font.weight: Font.Bold
                                                }
                                            }

                                            // Image avatar with True Circular Masking
                                            CircularAvatarImage {
                                                anchors.fill: parent
                                                visible: modelData.type === "image"
                                                source: modelData.path
                                                radius: 45
                                            }

                                            // Subtle circle outline
                                            Rectangle {
                                                anchors.fill: parent
                                                radius: 45
                                                color: "transparent"
                                                border.color: Qt.rgba(255, 255, 255, 0.15)
                                                border.width: 1
                                            }
                                        }

                                        MouseArea {
                                            anchors.fill: parent
                                            hoverEnabled: true
                                            cursorShape: Qt.PointingHandCursor
                                            onClicked: {
                                                root.selectedAvatarPreview = modelData.id;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                // -------------------------------------------------------------
                // LEVEL 2C: SECURITY VIEW (Matches Image 5)
                // -------------------------------------------------------------
                Item {
                    id: profSecurityView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    x: root.profCurrentScreen === "security" ? 0 :
                       (root.profCurrentScreen === "main" ? parent.width : -parent.width * 0.4)
                    opacity: root.profCurrentScreen === "security" ? 1.0 : 0.0
                    enabled: root.profCurrentScreen === "security"
                    visible: opacity > 0.001 || (x > -parent.width * 0.4 && x < parent.width)

                    Behavior on x { NumberAnimation { duration: 320; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 280; easing.type: Easing.InOutQuad } }

                    Flickable {
                        anchors.fill: parent
                        contentHeight: profSecCol.height + 40
                        clip: true
                        boundsBehavior: Flickable.DragAndOvershootBounds
                        flickableDirection: Flickable.VerticalFlick

                        Column {
                            id: profSecCol
                            width: parent.width
                            spacing: 0

                            SettingRowChevron {
                                iconSource: "qrc:/ApexVision/qml/assets/icons/icon_profile_lock.svg"
                                title: "Profile lock"
                                subtitle: root.currentLockType
                                onClicked: {
                                    root.profSlideDir = 1;
                                    root.profCurrentScreen = "lock_type";
                                }
                            }

                            SettingRowChevron {
                                title: "Clear credentials"
                                subtitle: "Remove all certificates"
                                showChevron: false
                                onClicked: {
                                    root.profileToastMessage = "Certificates and credentials removed";
                                    profToastTimer.restart();
                                }
                            }

                            SettingRowChevron {
                                title: "Security update"
                                subtitle: "November 5, 2026"
                                onClicked: {
                                    root.profileToastMessage = "Security patch is up to date";
                                    profToastTimer.restart();
                                }
                            }
                        }
                    }
                }

                // -------------------------------------------------------------
                // LEVEL 3: CHOOSE A LOCK TYPE VIEW (Matches Reference Image)
                // -------------------------------------------------------------
                Item {
                    id: profLockTypeView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    x: root.profCurrentScreen === "lock_type" ? 0 :
                       (root.profCurrentScreen === "pattern" || root.profCurrentScreen === "pin" || root.profCurrentScreen === "password" ? -parent.width * 0.4 : parent.width)
                    opacity: root.profCurrentScreen === "lock_type" ? 1.0 : 0.0
                    enabled: root.profCurrentScreen === "lock_type"
                    visible: opacity > 0.001 || (x > -parent.width * 0.4 && x < parent.width)

                    Behavior on x { NumberAnimation { duration: 320; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 280; easing.type: Easing.InOutQuad } }

                    Flickable {
                        anchors.fill: parent
                        contentHeight: profLockCol.height + 40
                        clip: true
                        boundsBehavior: Flickable.DragAndOvershootBounds
                        flickableDirection: Flickable.VerticalFlick

                        Column {
                            id: profLockCol
                            width: parent.width
                            spacing: 0

                            // None
                            SettingRowChevron {
                                title: "None"
                                subtitle: root.currentLockType === "None" ? "Current screen lock" : ""
                                showChevron: false
                                onClicked: {
                                    root.currentLockType = "None";
                                    if (typeof VehicleBackend !== "undefined") VehicleBackend.setCurrentLockType("None");
                                    root.profileToastMessage = "Screen lock removed";
                                    profToastTimer.restart();
                                    root.profSlideDir = -1;
                                    root.profCurrentScreen = "security";
                                }
                            }

                            // Pattern
                            SettingRowChevron {
                                title: "Pattern"
                                subtitle: root.currentLockType === "Pattern" ? "Current screen lock" : ""
                                showChevron: true
                                onClicked: {
                                    root.profSlideDir = 1;
                                    root.patternNodes = [];
                                    root.profCurrentScreen = "pattern";
                                }
                            }

                            // PIN
                            SettingRowChevron {
                                title: "PIN"
                                subtitle: root.currentLockType === "PIN" ? "Current screen lock" : ""
                                showChevron: true
                                onClicked: {
                                    root.profSlideDir = 1;
                                    root.tempPinEntry = "";
                                    root.profCurrentScreen = "pin";
                                }
                            }

                            // Password
                            SettingRowChevron {
                                title: "Password"
                                subtitle: root.currentLockType === "Password" ? "Current screen lock" : ""
                                showChevron: true
                                onClicked: {
                                    root.profSlideDir = 1;
                                    root.tempPasswordEntry = "";
                                    root.profCurrentScreen = "password";
                                }
                            }
                        }
                    }
                }

                // -------------------------------------------------------------
                // LEVEL 4A: PIN SETUP VIEW
                // -------------------------------------------------------------
                Item {
                    id: profPinView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    x: root.profCurrentScreen === "pin" ? 0 : parent.width
                    opacity: root.profCurrentScreen === "pin" ? 1.0 : 0.0
                    enabled: root.profCurrentScreen === "pin"
                    visible: opacity > 0.001 || x < parent.width

                    Behavior on x { NumberAnimation { duration: 320; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 280; easing.type: Easing.InOutQuad } }

                    Column {
                        anchors.centerIn: parent
                        spacing: 20

                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "Enter a 4-digit PIN for " + root.currentProfileName
                            color: "#94A3B8"
                            font.family: "Inter"
                            font.pixelSize: 18
                        }

                        // PIN Indicator Dots
                        Row {
                            anchors.horizontalCenter: parent.horizontalCenter
                            spacing: 18
                            Repeater {
                                model: 4
                                Rectangle {
                                    width: 18; height: 18; radius: 9
                                    color: index < root.tempPinEntry.length ? "#38BDF8" : "transparent"
                                    border.color: index < root.tempPinEntry.length ? "#38BDF8" : Qt.rgba(255, 255, 255, 0.4)
                                    border.width: 2
                                    Behavior on color { ColorAnimation { duration: 100 } }
                                }
                            }
                        }

                        Item { width: 1; height: 6 }

                        // 3x4 Keypad
                        Grid {
                            anchors.horizontalCenter: parent.horizontalCenter
                            columns: 3
                            spacing: 14

                            Repeater {
                                model: ["1", "2", "3", "4", "5", "6", "7", "8", "9", "⌫", "0", "OK"]

                                Rectangle {
                                    width: 76; height: 60; radius: 14
                                    color: modelData === "OK" ? (root.tempPinEntry.length === 4 ? "#2563EB" : Qt.rgba(255, 255, 255, 0.04)) :
                                           (keyMouse.pressed ? Qt.rgba(255, 255, 255, 0.16) :
                                           (keyMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.10) : Qt.rgba(255, 255, 255, 0.05)))
                                    border.color: Qt.rgba(255, 255, 255, 0.12)
                                    border.width: 1

                                    Text {
                                        anchors.centerIn: parent
                                        text: modelData
                                        color: modelData === "OK" ? (root.tempPinEntry.length === 4 ? "#FFFFFF" : "#64748B") : "#FFFFFF"
                                        font.family: "Inter"
                                        font.pixelSize: modelData === "OK" ? 18 : 24
                                        font.weight: Font.DemiBold
                                    }

                                    MouseArea {
                                        id: keyMouse
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: {
                                            if (modelData === "⌫") {
                                                if (root.tempPinEntry.length > 0) root.tempPinEntry = root.tempPinEntry.slice(0, -1);
                                            } else if (modelData === "OK") {
                                                if (root.tempPinEntry.length === 4) {
                                                    root.profilePinCode = root.tempPinEntry;
                                                    root.currentLockType = "PIN";
                                                    if (typeof VehicleBackend !== "undefined") VehicleBackend.setProfilePinCode(root.profilePinCode);
                                                    root.profileToastMessage = "PIN lock configured";
                                                    profToastTimer.restart();
                                                    root.profSlideDir = -1;
                                                    root.profCurrentScreen = "security";
                                                }
                                            } else {
                                                if (root.tempPinEntry.length < 4) root.tempPinEntry += modelData;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                // -------------------------------------------------------------
                // LEVEL 4B: PATTERN SETUP VIEW
                // -------------------------------------------------------------
                Item {
                    id: profPatternView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    x: root.profCurrentScreen === "pattern" ? 0 : parent.width
                    opacity: root.profCurrentScreen === "pattern" ? 1.0 : 0.0
                    enabled: root.profCurrentScreen === "pattern"
                    visible: opacity > 0.001 || x < parent.width

                    Behavior on x { NumberAnimation { duration: 320; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 280; easing.type: Easing.InOutQuad } }

                    Column {
                        anchors.centerIn: parent
                        spacing: 24

                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "Connect at least 4 dots for unlock pattern"
                            color: "#94A3B8"
                            font.family: "Inter"
                            font.pixelSize: 18
                        }

                        // 3x3 Dot Grid
                        Grid {
                            anchors.horizontalCenter: parent.horizontalCenter
                            columns: 3
                            spacing: 36

                            Repeater {
                                model: 9

                                Rectangle {
                                    width: 44; height: 44; radius: 22
                                    property bool selected: root.patternNodes.indexOf(index) !== -1
                                    color: selected ? "#38BDF8" : Qt.rgba(255, 255, 255, 0.15)
                                    border.color: selected ? "#38BDF8" : Qt.rgba(255, 255, 255, 0.3)
                                    border.width: selected ? 3 : 1

                                    Rectangle {
                                        anchors.centerIn: parent
                                        width: 14; height: 14; radius: 7
                                        color: "#FFFFFF"
                                    }

                                    MouseArea {
                                        anchors.fill: parent
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: {
                                            var idx = root.patternNodes.indexOf(index);
                                            var copy = root.patternNodes.slice();
                                            if (idx === -1) {
                                                copy.push(index);
                                            } else {
                                                copy.splice(idx, 1);
                                            }
                                            root.patternNodes = copy;
                                        }
                                    }
                                }
                            }
                        }

                        Row {
                            anchors.horizontalCenter: parent.horizontalCenter
                            spacing: 16

                            Rectangle {
                                width: 110; height: 44; radius: 10
                                color: Qt.rgba(255, 255, 255, 0.08)
                                Text { anchors.centerIn: parent; text: "Clear"; color: "#FFFFFF"; font.family: "Inter"; font.pixelSize: 16 }
                                MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: root.patternNodes = []; }
                            }

                            Rectangle {
                                width: 140; height: 44; radius: 10
                                color: root.patternNodes.length >= 4 ? "#2563EB" : Qt.rgba(255, 255, 255, 0.06)
                                Text { anchors.centerIn: parent; text: "Confirm"; color: root.patternNodes.length >= 4 ? "#FFFFFF" : "#64748B"; font.family: "Inter"; font.pixelSize: 16; font.weight: Font.DemiBold }
                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                        if (root.patternNodes.length >= 4) {
                                            root.currentLockType = "Pattern";
                                            if (typeof VehicleBackend !== "undefined") VehicleBackend.setCurrentLockType("Pattern");
                                            root.profileToastMessage = "Pattern lock set";
                                            profToastTimer.restart();
                                            root.profSlideDir = -1;
                                            root.profCurrentScreen = "security";
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                // -------------------------------------------------------------
                // LEVEL 4C: PASSWORD SETUP VIEW
                // -------------------------------------------------------------
                Item {
                    id: profPasswordView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    x: root.profCurrentScreen === "password" ? 0 : parent.width
                    opacity: root.profCurrentScreen === "password" ? 1.0 : 0.0
                    enabled: root.profCurrentScreen === "password"
                    visible: opacity > 0.001 || x < parent.width

                    Behavior on x { NumberAnimation { duration: 320; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 280; easing.type: Easing.InOutQuad } }

                    Column {
                        anchors.centerIn: parent
                        spacing: 24
                        width: Math.min(parent.width - 40, 480)

                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "Set a password for " + root.currentProfileName
                            color: "#94A3B8"
                            font.family: "Inter"
                            font.pixelSize: 18
                        }

                        Rectangle {
                            width: parent.width
                            height: 54
                            radius: 12
                            color: Qt.rgba(255, 255, 255, 0.07)
                            border.color: Qt.rgba(255, 255, 255, 0.2)
                            border.width: 1.5

                            TextInput {
                                id: profPwdInput
                                anchors.fill: parent
                                anchors.leftMargin: 16
                                anchors.rightMargin: 16
                                verticalAlignment: TextInput.AlignVCenter
                                color: "#FFFFFF"
                                font.family: "Inter"
                                font.pixelSize: 18
                                echoMode: TextInput.Password
                                text: root.tempPasswordEntry
                                onTextChanged: root.tempPasswordEntry = text
                            }
                        }

                        Row {
                            anchors.horizontalCenter: parent.horizontalCenter
                            spacing: 16

                            Rectangle {
                                width: 120; height: 46; radius: 10
                                color: Qt.rgba(255, 255, 255, 0.08)
                                Text { anchors.centerIn: parent; text: "Cancel"; color: "#FFFFFF"; font.family: "Inter"; font.pixelSize: 16 }
                                MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: { root.profSlideDir = -1; root.profCurrentScreen = "security"; } }
                            }

                            Rectangle {
                                width: 140; height: 46; radius: 10
                                color: root.tempPasswordEntry.length >= 4 ? "#2563EB" : Qt.rgba(255, 255, 255, 0.06)
                                Text { anchors.centerIn: parent; text: "Save"; color: root.tempPasswordEntry.length >= 4 ? "#FFFFFF" : "#64748B"; font.family: "Inter"; font.pixelSize: 16; font.weight: Font.DemiBold }
                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                        if (root.tempPasswordEntry.length >= 4) {
                                            root.profilePassword = root.tempPasswordEntry;
                                            root.currentLockType = "Password";
                                            if (typeof VehicleBackend !== "undefined") VehicleBackend.setProfilePassword(root.profilePassword);
                                            root.profileToastMessage = "Password configured";
                                            profToastTimer.restart();
                                            root.profSlideDir = -1;
                                            root.profCurrentScreen = "security";
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                // -------------------------------------------------------------
                // LEVEL 2D: LINK PROFILE VIEW
                // -------------------------------------------------------------
                Item {
                    id: profLinkView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    x: root.profCurrentScreen === "link_profile" ? 0 :
                       (root.profCurrentScreen === "main" ? parent.width : -parent.width * 0.4)
                    opacity: root.profCurrentScreen === "link_profile" ? 1.0 : 0.0
                    enabled: root.profCurrentScreen === "link_profile"
                    visible: opacity > 0.001 || (x > -parent.width * 0.4 && x < parent.width)

                    Behavior on x { NumberAnimation { duration: 320; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 280; easing.type: Easing.InOutQuad } }

                    Flickable {
                        anchors.fill: parent
                        contentHeight: profLinkCol.height + 40
                        clip: true
                        boundsBehavior: Flickable.DragAndOvershootBounds
                        flickableDirection: Flickable.VerticalFlick

                        Column {
                            id: profLinkCol
                            width: parent.width
                            spacing: 0

                            SettingRowSwitch {
                                title: "Link Key Fob 1"
                                subtitle: "Automatically select " + root.currentProfileName + " when Key Fob 1 unlocks car"
                                checked: root.keyFobLinked
                                onToggled: {
                                    root.keyFobLinked = !root.keyFobLinked;
                                    if (typeof VehicleBackend !== "undefined") VehicleBackend.setKeyFobLinked(root.keyFobLinked);
                                }
                            }

                            SettingRowSwitch {
                                title: "Phone As A Key link"
                                subtitle: "Link smartphone virtual key via Bluetooth Low Energy"
                                checked: root.phoneKeyLinked
                                onToggled: {
                                    root.phoneKeyLinked = !root.phoneKeyLinked;
                                    if (typeof VehicleBackend !== "undefined") VehicleBackend.setPhoneKeyLinked(root.phoneKeyLinked);
                                }
                            }

                            SettingRowSwitch {
                                title: "Bluetooth Device link"
                                subtitle: "Select " + root.currentProfileName + " when Reno's Phone connects"
                                checked: root.btDeviceLinked
                                onToggled: {
                                    root.btDeviceLinked = !root.btDeviceLinked;
                                    if (typeof VehicleBackend !== "undefined") VehicleBackend.setBtDeviceLinked(root.btDeviceLinked);
                                }
                            }

                            SettingRowSwitch {
                                title: "Easy entry seat memory link"
                                subtitle: "Restore personalized seat, mirrors, and steering position upon entry"
                                checked: true
                            }
                        }
                    }
                }

                // -------------------------------------------------------------
                // LEVEL 2E: ACCOUNTS VIEW
                // -------------------------------------------------------------
                Item {
                    id: profAccountsView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    x: root.profCurrentScreen === "accounts" ? 0 :
                       (root.profCurrentScreen === "main" ? parent.width : -parent.width * 0.4)
                    opacity: root.profCurrentScreen === "accounts" ? 1.0 : 0.0
                    enabled: root.profCurrentScreen === "accounts"
                    visible: opacity > 0.001 || (x > -parent.width * 0.4 && x < parent.width)

                    Behavior on x { NumberAnimation { duration: 320; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 280; easing.type: Easing.InOutQuad } }

                    Flickable {
                        anchors.fill: parent
                        contentHeight: profAccCol.height + 40
                        clip: true
                        boundsBehavior: Flickable.DragAndOvershootBounds
                        flickableDirection: Flickable.VerticalFlick

                        Column {
                            id: profAccCol
                            width: parent.width
                            spacing: 0

                            SettingRowSimple {
                                title: "Apex Cloud Account"
                                subtitle: "driver1@apex.vision • Active & Synchronized"
                            }

                            SettingRowSimple {
                                title: "Google Automotive Services"
                                subtitle: "Connected • Google Maps, Assistant, and Play Store"
                            }

                            SettingRowSimple {
                                title: "Spotify Premium"
                                subtitle: "Connected • Personalized music and recommendations"
                            }
                        }
                    }
                }
            }

            // =================================================================
            // CATEGORY: DISPLAY
            // =================================================================
            // CATEGORY: DISPLAY (Matches Reference Photos Image 1, 2 & 3)
            // =================================================================
            Item {
                id: displayContainer
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                visible: root.activeCategory === "display"
                clip: true

                // -------------------------------------------------------------
                // LEVEL 1: MAIN DISPLAY VIEW (Matches Image 1)
                // -------------------------------------------------------------
                Item {
                    id: dispMainView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    x: root.dispCurrentScreen === "main" ? 0 : -parent.width * 0.4
                    opacity: root.dispCurrentScreen === "main" ? 1.0 : 0.0
                    enabled: root.dispCurrentScreen === "main"
                    visible: opacity > 0.001 || x > -parent.width * 0.4

                    Behavior on x { NumberAnimation { duration: 320; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 280; easing.type: Easing.InOutQuad } }

                    Column {
                        width: parent.width
                        spacing: 0

                        SettingRowChevron {
                            title: "Brightness level"
                            showChevron: true
                            onClicked: {
                                root.dispSlideDir = 1;
                                root.dispCurrentScreen = "brightness";
                            }
                        }

                        SettingRowChevron {
                            title: "Mode"
                            subtitle: root.dispMode
                            infoText: "Select automatic, light, or dark display color scheme."
                            showChevron: true
                            onClicked: {
                                root.dispSlideDir = 1;
                                root.dispCurrentScreen = "mode";
                            }
                            onInfoClicked: root.activeInfoText = infoText
                        }

                        SettingRowChevron {
                            title: "Theme"
                            subtitle: root.dispTheme
                            infoText: "Select visual theme accents for cockpit display styling."
                            showChevron: true
                            onClicked: {
                                root.dispSlideDir = 1;
                                root.dispCurrentScreen = "theme";
                            }
                            onInfoClicked: root.activeInfoText = infoText
                        }

                        SettingRowChevron {
                            title: "Calm screen"
                            showChevron: true
                            onClicked: {
                                root.dispSlideDir = 1;
                                root.dispCurrentScreen = "calm_screen";
                            }
                        }

                        SettingRowSwitch {
                            title: "Touchscreen beep"
                            checked: root.dispTouchscreenBeep
                            infoText: "Sound confirmation when tapping on interactive screen controls."
                            onToggled: root.dispTouchscreenBeep = !root.dispTouchscreenBeep
                        }
                    }
                }

                // -------------------------------------------------------------
                // LEVEL 2A: BRIGHTNESS LEVEL SUB-SCREEN (Matches Image 2)
                // -------------------------------------------------------------
                Item {
                    id: dispBrightnessView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    x: root.dispCurrentScreen === "brightness" ? 0 : parent.width
                    opacity: root.dispCurrentScreen === "brightness" ? 1.0 : 0.0
                    enabled: root.dispCurrentScreen === "brightness"
                    visible: opacity > 0.001 || x < parent.width

                    Behavior on x { NumberAnimation { duration: 320; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 280; easing.type: Easing.InOutQuad } }

                    Column {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.top: parent.top
                        anchors.topMargin: 12
                        spacing: 28

                        // 1. Instrument panel brightness with custom OEM slider (Matches Image 2)
                        Column {
                            width: parent.width
                            spacing: 14

                            Text {
                                text: "Instrument panel brightness"
                                font.family: "Inter"
                                font.pixelSize: 18
                                font.weight: Font.DemiBold
                                color: "#FFFFFF"
                            }

                            // Standalone custom slider with peach gradient track & 5 dots
                            Item {
                                width: parent.width
                                height: 40

                                Slider {
                                    id: instBrightnessSlider
                                    anchors.left: parent.left
                                    anchors.right: parent.right
                                    anchors.verticalCenter: parent.verticalCenter
                                    padding: 0
                                    leftPadding: 16
                                    rightPadding: 16
                                    from: 10
                                    to: 100
                                    stepSize: 1
                                    value: Math.max(10, root.displayBrightness)
                                    onMoved: {
                                        root.displayBrightness = value;
                                        SystemBackend.setBrightness(value);
                                    }

                                    background: Item {
                                        x: instBrightnessSlider.leftPadding
                                        y: instBrightnessSlider.topPadding + instBrightnessSlider.availableHeight / 2 - height / 2
                                        width: instBrightnessSlider.availableWidth
                                        height: 10

                                        // 1. Inactive / Empty Base Track Groove
                                        Rectangle {
                                            anchors.fill: parent
                                            radius: 5
                                            color: Qt.rgba(255, 255, 255, 0.14)
                                        }

                                        // 2. Active Filled Portion (from left up to dragger position)
                                        Rectangle {
                                            anchors.left: parent.left
                                            anchors.top: parent.top
                                            anchors.bottom: parent.bottom
                                            width: Math.max(height, instBrightnessSlider.visualPosition * parent.width)
                                            radius: 5
                                            gradient: Gradient {
                                                orientation: Gradient.Horizontal
                                                GradientStop { position: 0.0; color: "#E08365" }
                                                GradientStop { position: 0.5; color: "#F0B594" }
                                                GradientStop { position: 1.0; color: "#F7D5BC" }
                                            }
                                        }

                                        // 3. 5 discrete notch dots along the track
                                        Row {
                                            id: notchDotsRow
                                            anchors.fill: parent
                                            anchors.leftMargin: 20
                                            anchors.rightMargin: 20
                                            spacing: Math.max(0, (width - 5 * 5) / 4)

                                            Repeater {
                                                model: 5
                                                Rectangle {
                                                    anchors.verticalCenter: parent.verticalCenter
                                                    width: 5
                                                    height: 5
                                                    radius: 2.5
                                                    color: (20 + index * (notchDotsRow.spacing + 5) + 2.5) <= (instBrightnessSlider.visualPosition * instBrightnessSlider.availableWidth) ?
                                                           "#6E2A18" : Qt.rgba(255, 255, 255, 0.35)
                                                }
                                            }
                                        }
                                    }

                                    handle: Rectangle {
                                        x: instBrightnessSlider.leftPadding + instBrightnessSlider.visualPosition * (instBrightnessSlider.availableWidth - width)
                                        y: instBrightnessSlider.topPadding + instBrightnessSlider.availableHeight / 2 - height / 2
                                        implicitWidth: 30
                                        implicitHeight: 30
                                        radius: 15
                                        color: "#0F172A"
                                        border.color: "#FFFFFF"
                                        border.width: 3.5

                                        scale: instBrightnessSlider.pressed ? 1.15 : 1.0
                                        Behavior on scale { NumberAnimation { duration: 100 } }
                                    }
                                }
                            }
                        }

                        // Separator Line
                        Rectangle {
                            width: parent.width
                            height: 1
                            color: Qt.rgba(255, 255, 255, 0.08)
                        }

                        // 2. Touchscreen brightness offset Stepper (Matches Image 2)
                        Column {
                            width: parent.width
                            spacing: 24

                            Row {
                                width: parent.width
                                spacing: 10

                                Text {
                                    text: "Touchscreen brightness offset"
                                    font.family: "Inter"
                                    font.pixelSize: 18
                                    font.weight: Font.DemiBold
                                    color: "#FFFFFF"
                                    anchors.verticalCenter: parent.verticalCenter
                                }

                                Item {
                                    width: 32
                                    height: 32
                                    anchors.verticalCenter: parent.verticalCenter

                                    Text {
                                        anchors.centerIn: parent
                                        text: "ⓘ"
                                        font.pixelSize: 18
                                        color: "#94A3B8"
                                    }
                                    MouseArea {
                                        anchors.fill: parent
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: root.activeInfoText = "Adjust touchscreen brightness relative to the instrument cluster level."
                                    }
                                }
                            }

                            // Stepper Controls [-] 0 [+]
                            Row {
                                anchors.horizontalCenter: parent.horizontalCenter
                                spacing: 48

                                // Minus Button
                                Rectangle {
                                    width: 56
                                    height: 56
                                    radius: 28
                                    anchors.verticalCenter: parent.verticalCenter
                                    color: minusMouseArea.pressed ? Qt.rgba(255, 255, 255, 0.18) : (minusMouseArea.containsMouse ? Qt.rgba(255, 255, 255, 0.12) : Qt.rgba(255, 255, 255, 0.08))
                                    border.color: Qt.rgba(255, 255, 255, 0.20)
                                    border.width: 1

                                    Text {
                                        anchors.centerIn: parent
                                        text: "−"
                                        color: "#FFFFFF"
                                        font.family: "Inter"
                                        font.pixelSize: 28
                                        font.weight: Font.Bold
                                    }

                                    MouseArea {
                                        id: minusMouseArea
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: {
                                            if (root.dispBrightnessOffset > -5) root.dispBrightnessOffset--;
                                        }
                                    }
                                }

                                // Offset Readout Value
                                Text {
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: root.dispBrightnessOffset > 0 ? ("+" + root.dispBrightnessOffset) : ("" + root.dispBrightnessOffset)
                                    font.family: "Inter"
                                    font.pixelSize: 44
                                    font.weight: Font.Bold
                                    color: "#FFFFFF"
                                }

                                // Plus Button
                                Rectangle {
                                    width: 56
                                    height: 56
                                    radius: 28
                                    anchors.verticalCenter: parent.verticalCenter
                                    color: plusMouseArea.pressed ? Qt.rgba(255, 255, 255, 0.18) : (plusMouseArea.containsMouse ? Qt.rgba(255, 255, 255, 0.12) : Qt.rgba(255, 255, 255, 0.08))
                                    border.color: Qt.rgba(255, 255, 255, 0.20)
                                    border.width: 1

                                    Text {
                                        anchors.centerIn: parent
                                        text: "+"
                                        color: "#FFFFFF"
                                        font.family: "Inter"
                                        font.pixelSize: 28
                                        font.weight: Font.Bold
                                    }

                                    MouseArea {
                                        id: plusMouseArea
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: {
                                            if (root.dispBrightnessOffset < 5) root.dispBrightnessOffset++;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                // -------------------------------------------------------------
                // LEVEL 2B: MODE SUB-SCREEN (Matches Image 3)
                // -------------------------------------------------------------
                Item {
                    id: dispModeView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    x: root.dispCurrentScreen === "mode" ? 0 : parent.width
                    opacity: root.dispCurrentScreen === "mode" ? 1.0 : 0.0
                    enabled: root.dispCurrentScreen === "mode"
                    visible: opacity > 0.001 || x < parent.width

                    Behavior on x { NumberAnimation { duration: 320; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 280; easing.type: Easing.InOutQuad } }

                    Column {
                        width: parent.width
                        spacing: 0

                        Repeater {
                            model: ["Auto", "Light", "Dark"]
                            delegate: Item {
                                width: parent.width
                                height: 72

                                Rectangle {
                                    anchors.fill: parent
                                    color: modeRowMouse.pressed ? Qt.rgba(255, 255, 255, 0.08) : (modeRowMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.04) : "transparent")
                                    Behavior on color { ColorAnimation { duration: 150 } }
                                }

                                Text {
                                    anchors.left: parent.left
                                    anchors.leftMargin: 8
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: modelData
                                    color: "#FFFFFF"
                                    font.family: "Inter"
                                    font.pixelSize: 20
                                    font.weight: Font.Medium
                                }

                                // Radio Circle (Matches Image 3)
                                Rectangle {
                                    anchors.right: parent.right
                                    anchors.rightMargin: 12
                                    anchors.verticalCenter: parent.verticalCenter
                                    width: 26
                                    height: 26
                                    radius: 13
                                    color: "transparent"
                                    border.color: root.dispMode === modelData ? "#E08365" : Qt.rgba(148, 163, 184, 0.5)
                                    border.width: 2

                                    // Selected Inner Peach Dot
                                    Rectangle {
                                        anchors.centerIn: parent
                                        width: 14
                                        height: 14
                                        radius: 7
                                        color: "#E08365"
                                        visible: root.dispMode === modelData
                                    }
                                }

                                Rectangle {
                                    anchors.left: parent.left
                                    anchors.right: parent.right
                                    anchors.bottom: parent.bottom
                                    height: 1
                                    color: Qt.rgba(255, 255, 255, 0.08)
                                }

                                MouseArea {
                                    id: modeRowMouse
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                        root.dispMode = modelData;
                                    }
                                }
                            }
                        }
                    }
                }

                // -------------------------------------------------------------
                // LEVEL 2C: THEME SUB-SCREEN (Bespoke Native AOSP Theme Cards)
                // -------------------------------------------------------------
                Item {
                    id: dispThemeView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    x: root.dispCurrentScreen === "theme" ? 0 : parent.width
                    opacity: root.dispCurrentScreen === "theme" ? 1.0 : 0.0
                    enabled: root.dispCurrentScreen === "theme"
                    visible: opacity > 0.001 || x < parent.width

                    Behavior on x { NumberAnimation { duration: 320; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 280; easing.type: Easing.InOutQuad } }

                    Column {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.top: parent.top
                        anchors.topMargin: 8
                        spacing: 12

                        Repeater {
                            model: [
                                {
                                    name: "Constellation",
                                    desc: "Warm celestial amber horizon",
                                    accent: "#E08365",
                                    gradStart: "#09101F",
                                    gradEnd: "#141A2E"
                                },
                                {
                                    name: "Tranquil",
                                    desc: "Serene azure ocean curve",
                                    accent: "#38BDF8",
                                    gradStart: "#061021",
                                    gradEnd: "#0D203D"
                                },
                                {
                                    name: "Voyage",
                                    desc: "Royal amethyst twilight stream",
                                    accent: "#C084FC",
                                    gradStart: "#0A0A1F",
                                    gradEnd: "#181436"
                                },
                                {
                                    name: "Inspire",
                                    desc: "Radiant electric cyan ribbons",
                                    accent: "#22D3EE",
                                    gradStart: "#061322",
                                    gradEnd: "#0A253E"
                                }
                            ]

                            delegate: Item {
                                readonly property bool isSelected: root.dispTheme === modelData.name
                                width: parent.width
                                height: 74

                                Rectangle {
                                    id: cardBase
                                    anchors.fill: parent
                                    anchors.rightMargin: 8
                                    radius: 16
                                    color: isSelected ? Qt.rgba(20 / 255, 30 / 255, 52 / 255, 0.92) : Qt.rgba(14 / 255, 20 / 255, 34 / 255, 0.70)
                                    border.color: isSelected ? modelData.accent : (cardMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.22) : Qt.rgba(255, 255, 255, 0.08))
                                    border.width: isSelected ? 2.0 : 1.0
                                    clip: true

                                    Behavior on color { ColorAnimation { duration: 180 } }
                                    Behavior on border.color { ColorAnimation { duration: 180 } }

                                    // Subtle selection halo glow
                                    Rectangle {
                                        anchors.fill: parent
                                        anchors.margins: -1
                                        radius: 16
                                        color: "transparent"
                                        border.color: isSelected ? Qt.rgba(224 / 255, 131 / 255, 101 / 255, 0.25) : "transparent"
                                        border.width: 3
                                        visible: isSelected
                                    }

                                    // Native GPU Canvas for the signature atmospheric theme lighting
                                    Canvas {
                                        id: themeCanvas
                                        anchors.fill: parent
                                        antialiasing: true
                                        renderTarget: Canvas.FramebufferObject

                                        onPaint: {
                                            var ctx = getContext("2d");
                                            ctx.reset();
                                            var w = width;
                                            var h = height;

                                            if (modelData.name === "Constellation") {
                                                // 1. Warm amber celestial glow field
                                                var amb = ctx.createRadialGradient(w - 70, h * 0.5, 10, w - 70, h * 0.5, 140);
                                                amb.addColorStop(0.0, "rgba(255, 167, 38, 0.35)");
                                                amb.addColorStop(0.6, "rgba(230, 81, 0, 0.12)");
                                                amb.addColorStop(1.0, "rgba(230, 81, 0, 0.0)");
                                                ctx.fillStyle = amb;
                                                ctx.fillRect(w - 220, 0, 220, h);

                                                // 2. Sweeping golden horizon curve
                                                var lineGrad = ctx.createLinearGradient(w - 240, h, w - 18, h * 0.35);
                                                lineGrad.addColorStop(0.0, "rgba(255, 112, 67, 0.0)");
                                                lineGrad.addColorStop(0.5, "rgba(255, 167, 38, 0.70)");
                                                lineGrad.addColorStop(1.0, "rgba(255, 236, 179, 0.95)");
                                                ctx.strokeStyle = lineGrad;
                                                ctx.lineWidth = 2.5;
                                                ctx.beginPath();
                                                ctx.moveTo(w - 240, h - 8);
                                                ctx.bezierCurveTo(w - 140, h - 10, w - 70, h * 0.56, w - 18, h * 0.35);
                                                ctx.stroke();

                                                // 3. Subtle warm fill below curve
                                                var fillGrad = ctx.createLinearGradient(w - 200, 0, w - 18, 0);
                                                fillGrad.addColorStop(0.0, "rgba(255, 112, 67, 0.0)");
                                                fillGrad.addColorStop(0.7, "rgba(255, 167, 38, 0.14)");
                                                fillGrad.addColorStop(1.0, "rgba(255, 213, 79, 0.30)");
                                                ctx.fillStyle = fillGrad;
                                                ctx.beginPath();
                                                ctx.moveTo(w - 240, h - 8);
                                                ctx.bezierCurveTo(w - 140, h - 10, w - 70, h * 0.56, w - 18, h * 0.35);
                                                ctx.lineTo(w - 18, h);
                                                ctx.lineTo(w - 240, h);
                                                ctx.closePath();
                                                ctx.fill();

                                                // 4. Amber horizontal light flare
                                                var flare = ctx.createLinearGradient(w - 120, 0, w - 18, 0);
                                                flare.addColorStop(0.0, "rgba(255, 183, 77, 0.0)");
                                                flare.addColorStop(0.6, "rgba(255, 183, 77, 0.28)");
                                                flare.addColorStop(1.0, "rgba(255, 248, 225, 0.85)");
                                                ctx.fillStyle = flare;
                                                ctx.fillRect(w - 120, h * 0.20, 102, h * 0.60);

                                                // 5. Vertical light bar
                                                ctx.fillStyle = "#FFF9C4";
                                                ctx.fillRect(w - 20, h * 0.18, 3, h * 0.64);

                                            } else if (modelData.name === "Tranquil") {
                                                // 1. Deep blue atmospheric ambient glow
                                                var amb = ctx.createRadialGradient(w - 100, h * 0.45, 10, w - 100, h * 0.45, 130);
                                                amb.addColorStop(0.0, "rgba(41, 182, 246, 0.30)");
                                                amb.addColorStop(0.7, "rgba(2, 136, 209, 0.10)");
                                                amb.addColorStop(1.0, "rgba(2, 136, 209, 0.0)");
                                                ctx.fillStyle = amb;
                                                ctx.fillRect(w - 240, 0, 240, h);

                                                // 2. High-curvature serene azure arc
                                                var lineGrad = ctx.createLinearGradient(w - 250, h - 4, w - 18, h * 0.50);
                                                lineGrad.addColorStop(0.0, "rgba(3, 169, 244, 0.0)");
                                                lineGrad.addColorStop(0.4, "rgba(56, 189, 248, 0.85)");
                                                lineGrad.addColorStop(0.7, "rgba(186, 230, 253, 0.95)");
                                                lineGrad.addColorStop(1.0, "rgba(56, 189, 248, 0.35)");
                                                ctx.strokeStyle = lineGrad;
                                                ctx.lineWidth = 3.0;
                                                ctx.beginPath();
                                                ctx.moveTo(w - 250, h - 4);
                                                ctx.bezierCurveTo(w - 160, h * 0.22, w - 80, h * 0.16, w - 18, h * 0.52);
                                                ctx.stroke();

                                                // 3. Secondary subtle counter-glow
                                                var subGrad = ctx.createLinearGradient(w - 180, h * 0.7, w - 30, h * 0.65);
                                                subGrad.addColorStop(0.0, "rgba(14, 165, 233, 0.0)");
                                                subGrad.addColorStop(1.0, "rgba(56, 189, 248, 0.20)");
                                                ctx.strokeStyle = subGrad;
                                                ctx.lineWidth = 1.5;
                                                ctx.beginPath();
                                                ctx.moveTo(w - 180, h * 0.7);
                                                ctx.bezierCurveTo(w - 110, h * 0.55, w - 60, h * 0.58, w - 24, h * 0.65);
                                                ctx.stroke();

                                            } else if (modelData.name === "Voyage") {
                                                // 1. Violet twilight ambient glow
                                                var amb = ctx.createRadialGradient(w - 70, h * 0.5, 10, w - 70, h * 0.5, 130);
                                                amb.addColorStop(0.0, "rgba(171, 71, 188, 0.35)");
                                                amb.addColorStop(0.7, "rgba(106, 27, 154, 0.12)");
                                                amb.addColorStop(1.0, "rgba(106, 27, 154, 0.0)");
                                                ctx.fillStyle = amb;
                                                ctx.fillRect(w - 220, 0, 220, h);

                                                // 2. Upward flowing royal purple stream
                                                var lineGrad = ctx.createLinearGradient(w - 240, h * 0.16, w - 18, h * 0.50);
                                                lineGrad.addColorStop(0.0, "rgba(142, 36, 170, 0.0)");
                                                lineGrad.addColorStop(0.5, "rgba(192, 132, 252, 0.85)");
                                                lineGrad.addColorStop(1.0, "rgba(243, 232, 255, 0.95)");
                                                ctx.strokeStyle = lineGrad;
                                                ctx.lineWidth = 3.0;
                                                ctx.beginPath();
                                                ctx.moveTo(w - 240, h * 0.16);
                                                ctx.bezierCurveTo(w - 140, h * 0.16, w - 70, h * 0.68, w - 18, h * 0.50);
                                                ctx.stroke();

                                                // 3. Purple flare beam
                                                var flare = ctx.createLinearGradient(w - 120, 0, w - 18, 0);
                                                flare.addColorStop(0.0, "rgba(168, 85, 247, 0.0)");
                                                flare.addColorStop(0.6, "rgba(192, 132, 252, 0.32)");
                                                flare.addColorStop(1.0, "rgba(243, 232, 255, 0.85)");
                                                ctx.fillStyle = flare;
                                                ctx.fillRect(w - 120, h * 0.22, 102, h * 0.56);

                                                // 4. Vertical lavender light bar
                                                ctx.fillStyle = "#F3E8FF";
                                                ctx.fillRect(w - 20, h * 0.20, 3, h * 0.60);

                                            } else if (modelData.name === "Inspire") {
                                                // 1. Neon cyan atmosphere
                                                var amb = ctx.createRadialGradient(w - 70, h * 0.5, 10, w - 70, h * 0.5, 130);
                                                amb.addColorStop(0.0, "rgba(34, 211, 238, 0.35)");
                                                amb.addColorStop(0.7, "rgba(8, 145, 178, 0.12)");
                                                amb.addColorStop(1.0, "rgba(8, 145, 178, 0.0)");
                                                ctx.fillStyle = amb;
                                                ctx.fillRect(w - 220, 0, 220, h);

                                                // 2. Dual crossing cyan beams
                                                var g1 = ctx.createLinearGradient(w - 240, h * 0.82, w - 18, h * 0.44);
                                                g1.addColorStop(0.0, "rgba(6, 182, 212, 0.0)");
                                                g1.addColorStop(0.5, "rgba(34, 211, 238, 0.85)");
                                                g1.addColorStop(1.0, "rgba(207, 250, 254, 0.95)");
                                                ctx.strokeStyle = g1;
                                                ctx.lineWidth = 2.5;
                                                ctx.beginPath();
                                                ctx.moveTo(w - 240, h * 0.82);
                                                ctx.bezierCurveTo(w - 140, h * 0.78, w - 60, h * 0.52, w - 18, h * 0.44);
                                                ctx.stroke();

                                                var g2 = ctx.createLinearGradient(w - 210, h * 0.18, w - 18, h * 0.54);
                                                g2.addColorStop(0.0, "rgba(34, 211, 238, 0.0)");
                                                g2.addColorStop(0.5, "rgba(6, 182, 212, 0.75)");
                                                g2.addColorStop(1.0, "rgba(165, 243, 252, 0.90)");
                                                ctx.strokeStyle = g2;
                                                ctx.lineWidth = 2.0;
                                                ctx.beginPath();
                                                ctx.moveTo(w - 210, h * 0.18);
                                                ctx.bezierCurveTo(w - 120, h * 0.22, w - 60, h * 0.48, w - 18, h * 0.54);
                                                ctx.stroke();

                                                // 3. Electric cyan emitter flare
                                                var flare = ctx.createLinearGradient(w - 110, 0, w - 18, 0);
                                                flare.addColorStop(0.0, "rgba(34, 211, 238, 0.0)");
                                                flare.addColorStop(0.6, "rgba(34, 211, 238, 0.35)");
                                                flare.addColorStop(1.0, "rgba(236, 254, 255, 0.90)");
                                                ctx.fillStyle = flare;
                                                ctx.fillRect(w - 110, h * 0.24, 92, h * 0.52);

                                                // 4. Vertical emitter bar
                                                ctx.fillStyle = "#ECFEFF";
                                                ctx.fillRect(w - 20, h * 0.22, 3, h * 0.56);
                                            }
                                        }
                                    }

                                    // Typography on Left
                                    Column {
                                        anchors.left: parent.left
                                        anchors.leftMargin: 24
                                        anchors.verticalCenter: parent.verticalCenter
                                        spacing: 4

                                        Text {
                                            text: modelData.name
                                            color: isSelected ? "#FFFFFF" : Qt.rgba(255, 255, 255, 0.88)
                                            font.family: "Inter"
                                            font.pixelSize: 21
                                            font.weight: isSelected ? Font.DemiBold : Font.Medium
                                        }

                                        Text {
                                            text: modelData.desc
                                            color: isSelected ? Qt.rgba(255, 255, 255, 0.65) : Qt.rgba(255, 255, 255, 0.42)
                                            font.family: "Inter"
                                            font.pixelSize: 13
                                            font.weight: Font.Normal
                                        }
                                    }
                                }

                                MouseArea {
                                    id: cardMouse
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                        root.dispTheme = modelData.name;
                                    }
                                }
                            }
                        }
                    }
                }

                // -------------------------------------------------------------
                // LEVEL 2D: CALM SCREEN (Matches User Reference Photo Exactly)
                // -------------------------------------------------------------
                Item {
                    id: dispCalmScreenView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    x: root.dispCurrentScreen === "calm_screen" ? 0 : parent.width
                    opacity: root.dispCurrentScreen === "calm_screen" ? 1.0 : 0.0
                    enabled: root.dispCurrentScreen === "calm_screen"
                    visible: opacity > 0.001 || x < parent.width

                    Behavior on x { NumberAnimation { duration: 320; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 280; easing.type: Easing.InOutQuad } }

                    // Calm Screen Centered Content (Matches User Reference Photo)
                    Column {
                        anchors.centerIn: parent
                        spacing: 16
                        width: parent.width

                        // Day Name (e.g. "Tuesday")
                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: Qt.formatDateTime(root.currentDate, "dddd")
                            font.family: "Inter"
                            font.pixelSize: 48
                            font.weight: Font.Normal
                            color: "#FFFFFF"
                        }

                        // Subtle Horizontal Divider Line
                        Rectangle {
                            anchors.horizontalCenter: parent.horizontalCenter
                            width: 380
                            height: 1
                            color: Qt.rgba(255, 255, 255, 0.22)
                        }

                        // Formatted Date (e.g. "May 27, 2025")
                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: Qt.formatDateTime(root.currentDate, "MMMM d, yyyy")
                            font.family: "Inter"
                            font.pixelSize: 26
                            font.weight: Font.Normal
                            color: Qt.rgba(255, 255, 255, 0.72)
                        }
                    }

                    // Tap anywhere to exit Calm Screen
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            root.dispSlideDir = -1;
                            root.dispCurrentScreen = "main";
                        }
                    }
                }
            }

            // =================================================================
            // CATEGORY: NETWORK & INTERNET (Connectivity - Matching Photo 1)
            // =================================================================
            // =================================================================
            // CATEGORY: NETWORK & INTERNET (Connectivity - Matching Photo 1)
            // Strictly 2 options on main screen with smooth slide transition to Wi-Fi sub-screen
            // =================================================================
            Item {
                id: connectivityContainer
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: parent.width
                x: root.activeCategory === "connectivity" ? 0 : 36
                opacity: root.activeCategory === "connectivity" ? 1.0 : 0.0
                visible: opacity > 0.001
                clip: true

                Behavior on x { NumberAnimation { duration: 280; easing.type: Easing.OutCubic } }
                Behavior on opacity { NumberAnimation { duration: 240; easing.type: Easing.InOutQuad } }

                // Screen 1: Main (Strictly 2 options: Vehicle Connectivity & Wi-Fi)
                Item {
                    id: connMainView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    x: root.connCurrentScreen === "main" ? 0 : -parent.width * 0.4
                    opacity: root.connCurrentScreen === "main" ? 1.0 : 0.0
                    enabled: root.connCurrentScreen === "main"
                    visible: opacity > 0.001 || (x > -parent.width * 0.4 && x < parent.width)

                    Behavior on x { NumberAnimation { duration: 280; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 240; easing.type: Easing.InOutQuad } }

                    Flickable {
                        anchors.fill: parent
                        contentHeight: connCol.height + 40
                        clip: true
                        boundsBehavior: Flickable.DragAndOvershootBounds
                        flickableDirection: Flickable.VerticalFlick

                        Column {
                            id: connCol
                            width: parent.width
                            spacing: 0

                            // Row 1: Vehicle Connectivity (Switch + Info button, matching Photo 1)
                            SettingRowSwitch {
                                title: "Vehicle Connectivity"
                                subtitle: "Controls the vehicle's cellular and Wi-Fi connections for services and Software Updates, if available."
                                checked: root.vehicleConnectivityEnabled
                                infoText: "Controls the vehicle's cellular and Wi-Fi connections for services and Software Updates, if available."
                                onToggled: {
                                    root.vehicleConnectivityEnabled = !root.vehicleConnectivityEnabled;
                                }
                            }

                            // Row 2: Wi-Fi (Chevron + Info button, matching Photo 1 strictly)
                            SettingRowChevron {
                                title: "Wi-Fi"
                                subtitle: ""
                                infoText: "View available Wi-Fi networks and manage wireless connections."
                                onClicked: {
                                    root.connSlideDir = 1;
                                    root.connCurrentScreen = "wifi";
                                }
                            }
                        }
                    }
                }

                // Screen 2: Wi-Fi Sub-screen (Slide Transition)
                Item {
                    id: connWifiView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    x: root.connCurrentScreen === "wifi" ? 0 : parent.width
                    opacity: root.connCurrentScreen === "wifi" ? 1.0 : 0.0
                    enabled: root.connCurrentScreen === "wifi"
                    visible: opacity > 0.001 || (x > -parent.width * 0.4 && x < parent.width)

                    Behavior on x { NumberAnimation { duration: 280; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 240; easing.type: Easing.InOutQuad } }

                    Flickable {
                        anchors.fill: parent
                        contentHeight: wifiCol.height + 60
                        clip: true
                        boundsBehavior: Flickable.DragAndOvershootBounds
                        flickableDirection: Flickable.VerticalFlick

                        Column {
                            id: wifiCol
                            width: parent.width
                            spacing: 0

                            SettingRowSwitch {
                                title: "Use Wi-Fi"
                                subtitle: root.wifiEnabled ? "Connected to Apex_Fast5G" : "Wi-Fi is turned off"
                                checked: root.wifiEnabled
                                onToggled: {
                                    root.wifiEnabled = !root.wifiEnabled;
                                }
                            }

                            // Available Networks Header
                            Item {
                                width: parent.width
                                height: 50
                                visible: root.wifiEnabled

                                Text {
                                    anchors.left: parent.left
                                    anchors.leftMargin: 8
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: "Available networks"
                                    font.family: "Inter"
                                    font.pixelSize: 18
                                    font.weight: Font.DemiBold
                                    color: root.currentThemeAccent
                                }
                            }

                            SettingRowChevron {
                                visible: root.wifiEnabled
                                title: "Apex_Fast5G"
                                subtitle: "Connected • 5 GHz • Secured (WPA3)"
                            }

                            SettingRowChevron {
                                visible: root.wifiEnabled
                                title: "Supercharge_HQ"
                                subtitle: "Saved • Secured (WPA2)"
                            }

                            SettingRowChevron {
                                visible: root.wifiEnabled
                                title: "Guest_Net"
                                subtitle: "Open network"
                            }

                            SettingRowChevron {
                                visible: root.wifiEnabled
                                title: "Add network"
                                subtitle: "Connect to a hidden or manual Wi-Fi network"
                            }
                        }
                    }
                }
            }

            // =================================================================
            // CATEGORY: 911 ASSIST (Matching Photo 2)
            // =================================================================
            Item {
                id: assist911Container
                anchors.fill: parent
                x: root.activeCategory === "assist_911" ? 0 : 36
                opacity: root.activeCategory === "assist_911" ? 1.0 : 0.0
                visible: opacity > 0.001
                clip: true

                Behavior on x { NumberAnimation { duration: 280; easing.type: Easing.OutCubic } }
                Behavior on opacity { NumberAnimation { duration: 240; easing.type: Easing.InOutQuad } }

                // Centered Prompt & Action Button (matching Photo 2)
                Column {
                    anchors.centerIn: parent
                    anchors.verticalCenterOffset: -30
                    spacing: 28
                    width: Math.min(parent.width - 64, 620)

                    Text {
                        width: parent.width
                        text: "You need to pair and connect a phone to use 911 Assist"
                        font.family: "Inter"
                        font.pixelSize: 26
                        font.weight: Font.DemiBold
                        color: "#FFFFFF"
                        wrapMode: Text.WordWrap
                        lineHeight: 1.25
                    }

                    // Button: "Bluetooth settings" (Matches dark blue rounded card in Photo 2)
                    Rectangle {
                        width: 250
                        height: 56
                        radius: 14
                        color: btSetMouse.pressed ? "#1E3A5F" : (btSetMouse.containsMouse ? "#2D5A8E" : "#254870")
                        border.color: btSetMouse.containsMouse ? "#60A5FA" : "#3B82F6"
                        border.width: 1.5
                        Behavior on color { ColorAnimation { duration: 120 } }

                        Text {
                            anchors.centerIn: parent
                            text: "Bluetooth settings"
                            font.family: "Inter"
                            font.pixelSize: 20
                            font.weight: Font.DemiBold
                            color: "#FFFFFF"
                        }

                        MouseArea {
                            id: btSetMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                root.activeCategory = "bluetooth";
                            }
                        }
                    }

                    // Explanatory note
                    Text {
                        width: parent.width
                        text: "In the event of a crash deploying an airbag or activating fuel shutoff, 911 Assist uses your connected phone to call 911 emergency services and provide your vehicle's location."
                        font.family: "Inter"
                        font.pixelSize: 15
                        color: "#94A3B8"
                        wrapMode: Text.WordWrap
                        lineHeight: 1.3
                    }
                }
            }

            // =================================================================
            // CATEGORY: ASSISTANT & VOICE (Matching Photo 3)
            // =================================================================
            Item {
                id: voiceAssistantContainer
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: parent.width
                x: root.activeCategory === "voice_assistant" ? 0 : 36
                opacity: root.activeCategory === "voice_assistant" ? 1.0 : 0.0
                visible: opacity > 0.001
                clip: true

                Behavior on x { NumberAnimation { duration: 280; easing.type: Easing.OutCubic } }
                Behavior on opacity { NumberAnimation { duration: 240; easing.type: Easing.InOutQuad } }

                // Screen 1: Main Assistant Settings
                Item {
                    id: voiceMainView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    x: root.voiceCurrentScreen === "main" ? 0 : -parent.width * 0.4
                    opacity: root.voiceCurrentScreen === "main" ? 1.0 : 0.0
                    enabled: root.voiceCurrentScreen === "main"
                    visible: opacity > 0.001 || (x > -parent.width * 0.4 && x < parent.width)

                    Behavior on x { NumberAnimation { duration: 280; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 240; easing.type: Easing.InOutQuad } }

                    Flickable {
                        anchors.fill: parent
                        contentHeight: voiceCol.height + 40
                        clip: true
                        boundsBehavior: Flickable.DragAndOvershootBounds
                        flickableDirection: Flickable.VerticalFlick

                        Column {
                            id: voiceCol
                            width: parent.width
                            spacing: 0

                            // Row 1: Digital assistant app (Google Assistant icon + Settings gear, matching Photo 3)
                            SettingRowChevron {
                                title: "Digital assistant app"
                                subtitle: root.digitalAssistantApp
                                iconSource: "qrc:/ApexVision/qml/assets/icons/icon_google_assistant.svg"
                                customTrailingIcon: "qrc:/ApexVision/qml/assets/icons/icon_settings_gear.svg"
                                showChevron: false
                                onClicked: {
                                    root.voiceSlideDir = 1;
                                    root.voiceCurrentScreen = "digital_assistant";
                                }
                            }

                            // Row 2: Use text from screen (Toggle switch, matching Photo 3)
                            SettingRowSwitch {
                                title: "Use text from screen"
                                subtitle: "Allow the assist app to access the screen contents as text"
                                checked: root.voiceUseTextFromScreen
                                onToggled: {
                                    root.voiceUseTextFromScreen = !root.voiceUseTextFromScreen;
                                }
                            }

                            // Row 3: Use screenshot (Toggle switch, matching Photo 3)
                            SettingRowSwitch {
                                title: "Use screenshot"
                                subtitle: "Allow the assist app to access an image of the screen"
                                checked: root.voiceUseScreenshot
                                onToggled: {
                                    root.voiceUseScreenshot = !root.voiceUseScreenshot;
                                }
                            }

                            // Row 4: Voice wake word
                            SettingRowSwitch {
                                title: "Voice wake word (\"Hey Google\")"
                                subtitle: "Say wake word while driving for hands-free assistance"
                                checked: true
                            }

                            // Row 5: Voice language
                            SettingRowChevron {
                                title: "Voice language"
                                subtitle: root.voiceLanguage
                                onClicked: {
                                    root.voiceSlideDir = 1;
                                    root.voiceCurrentScreen = "voice_language";
                                }
                            }

                            // Row 6: Offline speech recognition
                            SettingRowSwitch {
                                title: "Offline speech recognition"
                                subtitle: "Process common in-car navigation & climate commands locally without internet"
                                checked: true
                            }
                        }
                    }
                }

                // Screen 2: Digital Assistant App Selection Sub-screen (Slide Transition)
                Item {
                    id: voiceAssistantSelectView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    x: root.voiceCurrentScreen === "digital_assistant" ? 0 : parent.width
                    opacity: root.voiceCurrentScreen === "digital_assistant" ? 1.0 : 0.0
                    enabled: root.voiceCurrentScreen === "digital_assistant"
                    visible: opacity > 0.001 || (x > -parent.width * 0.4 && x < parent.width)

                    Behavior on x { NumberAnimation { duration: 280; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 240; easing.type: Easing.InOutQuad } }

                    Flickable {
                        anchors.fill: parent
                        contentHeight: asstCol.height + 40
                        clip: true

                        Column {
                            id: asstCol
                            width: parent.width
                            spacing: 0

                            SettingRowRadio {
                                title: "Google Assistant"
                                subtitle: "Default automotive voice assistant"
                                selected: root.digitalAssistantApp === "Google Assistant"
                                onSelectedRequested: {
                                    root.digitalAssistantApp = "Google Assistant";
                                    root.voiceSlideDir = -1;
                                    root.voiceCurrentScreen = "main";
                                }
                            }

                            SettingRowRadio {
                                title: "Apex Automotive Voice AI"
                                subtitle: "Onboard neural voice assistant with offline capabilities"
                                selected: root.digitalAssistantApp === "Apex Automotive Voice AI"
                                onSelectedRequested: {
                                    root.digitalAssistantApp = "Apex Automotive Voice AI";
                                    root.voiceSlideDir = -1;
                                    root.voiceCurrentScreen = "main";
                                }
                            }

                            SettingRowRadio {
                                title: "Amazon Alexa"
                                subtitle: "Alexa Auto integration"
                                selected: root.digitalAssistantApp === "Amazon Alexa"
                                onSelectedRequested: {
                                    root.digitalAssistantApp = "Amazon Alexa";
                                    root.voiceSlideDir = -1;
                                    root.voiceCurrentScreen = "main";
                                }
                            }

                            SettingRowRadio {
                                title: "None"
                                subtitle: "Disable digital assistant app"
                                selected: root.digitalAssistantApp === "None"
                                onSelectedRequested: {
                                    root.digitalAssistantApp = "None";
                                    root.voiceSlideDir = -1;
                                    root.voiceCurrentScreen = "main";
                                }
                            }
                        }
                    }
                }

                // Screen 3: Voice Language Selection Sub-screen (Slide Transition)
                Item {
                    id: voiceLanguageSelectView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    x: root.voiceCurrentScreen === "voice_language" ? 0 : parent.width
                    opacity: root.voiceCurrentScreen === "voice_language" ? 1.0 : 0.0
                    enabled: root.voiceCurrentScreen === "voice_language"
                    visible: opacity > 0.001 || (x > -parent.width * 0.4 && x < parent.width)

                    Behavior on x { NumberAnimation { duration: 280; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 240; easing.type: Easing.InOutQuad } }

                    Flickable {
                        anchors.fill: parent
                        contentHeight: voiceLangCol.height + 40
                        clip: true
                        boundsBehavior: Flickable.DragAndOvershootBounds
                        flickableDirection: Flickable.VerticalFlick

                        Column {
                            id: voiceLangCol
                            width: parent.width
                            spacing: 0

                            Repeater {
                                model: [
                                    { title: "English (United States)", subtitle: "Apex Neural Voice (Natural US)" },
                                    { title: "English (United Kingdom)", subtitle: "Apex Neural Voice (Natural UK)" },
                                    { title: "English (India)", subtitle: "Apex Neural Voice (Natural IN)" },
                                    { title: "Hindi (हिन्दी)", subtitle: "एपेक्स न्यूरल वॉयस" },
                                    { title: "Spanish (Español)", subtitle: "Voz neuronal de Apex" },
                                    { title: "French (Français)", subtitle: "Voix neuronale Apex" },
                                    { title: "German (Deutsch)", subtitle: "Apex Neuronale Stimme" },
                                    { title: "Japanese (日本語)", subtitle: "Apex ニューラルボイス" }
                                ]

                                SettingRowRadio {
                                    title: modelData.title
                                    subtitle: modelData.subtitle
                                    selected: root.voiceLanguage === modelData.title
                                    onSelectedRequested: {
                                        root.voiceLanguage = modelData.title;
                                        root.voiceSlideDir = -1;
                                        root.voiceCurrentScreen = "main";
                                    }
                                }
                            }
                        }
                    }
                }
            }

            // =================================================================
            // CATEGORY: LOCATION (Matching Photo 4 & 5)
            // =================================================================
            Item {
                id: locationContainer
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: parent.width
                x: root.activeCategory === "location" ? 0 : 36
                opacity: root.activeCategory === "location" ? 1.0 : 0.0
                visible: opacity > 0.001
                clip: true

                Behavior on x { NumberAnimation { duration: 280; easing.type: Easing.OutCubic } }
                Behavior on opacity { NumberAnimation { duration: 240; easing.type: Easing.InOutQuad } }

                // Screen 1: Main Location Settings
                Item {
                    id: locMainView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    x: root.locCurrentScreen === "main" ? 0 : -parent.width * 0.4
                    opacity: root.locCurrentScreen === "main" ? 1.0 : 0.0
                    enabled: root.locCurrentScreen === "main"
                    visible: opacity > 0.001 || (x > -parent.width * 0.4 && x < parent.width)

                    Behavior on x { NumberAnimation { duration: 280; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 240; easing.type: Easing.InOutQuad } }

                    Flickable {
                        anchors.fill: parent
                        contentHeight: locCol.height + 60
                        clip: true
                        boundsBehavior: Flickable.DragAndOvershootBounds
                        flickableDirection: Flickable.VerticalFlick

                        Column {
                            id: locCol
                            width: parent.width
                            spacing: 0

                            // Row 1: Use location (Switch + Info button, matching Photo 4)
                            SettingRowSwitch {
                                title: "Use location"
                                subtitle: "Allow access to the vehicle's location."
                                checked: root.locationEnabled
                                infoText: "Allow authorized applications and automotive services to access vehicle GPS coordinates."
                                onToggled: {
                                    root.locationEnabled = !root.locationEnabled;
                                }
                            }

                            // Row 2: Recent Location Requests (Chevron, matching Photo 4)
                            SettingRowChevron {
                                title: "Recent Location Requests"
                                subtitle: "Apex Maps (2 min ago), Weather Service (14 min ago)"
                                onClicked: {
                                    root.locSlideDir = 1;
                                    root.locCurrentScreen = "recent_requests";
                                }
                            }

                            // Row 3: App-level permissions (Chevron, matching Photo 4)
                            SettingRowChevron {
                                title: "App-level permissions"
                                subtitle: "12 of 14 apps currently have access to location"
                                onClicked: {
                                    root.locSlideDir = 1;
                                    root.locCurrentScreen = "app_permissions";
                                }
                            }

                            // Section Header: Location Services (Amber/Peach text matching Photo 4 & 5)
                            Item {
                                width: parent.width
                                height: 52

                                Text {
                                    anchors.left: parent.left
                                    anchors.leftMargin: 8
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: "Location Services"
                                    font.family: "Inter"
                                    font.pixelSize: 20
                                    font.weight: Font.DemiBold
                                    color: root.currentThemeAccent
                                }
                            }

                            // Row 4: Location Accuracy (Clickable row, matching Photo 5)
                            SettingRowChevron {
                                title: "Location Accuracy"
                                subtitle: root.locationAccuracyMode
                                onClicked: {
                                    root.locationAccuracyMode = root.locationAccuracyMode === "Off" ? "High accuracy (GPS & Wi-Fi)" : "Off";
                                }
                            }

                            // Footnote Note with (i) icon (Matching Photo 5)
                            Item {
                                width: parent.width
                                height: Math.max(80, noteRow.implicitHeight + 28)

                                Rectangle {
                                    anchors.fill: parent
                                    anchors.margins: 4
                                    radius: 12
                                    color: Qt.rgba(255, 255, 255, 0.05)
                                    border.color: Qt.rgba(255, 255, 255, 0.12)
                                    border.width: 1

                                    Row {
                                        id: noteRow
                                        anchors.fill: parent
                                        anchors.leftMargin: 16
                                        anchors.rightMargin: 16
                                        spacing: 14

                                        Item {
                                            width: 28
                                            height: 28
                                            anchors.verticalCenter: parent.verticalCenter

                                            Rectangle {
                                                anchors.fill: parent
                                                radius: 14
                                                color: Qt.rgba(255, 255, 255, 0.16)
                                                border.color: Qt.rgba(255, 255, 255, 0.35)
                                                border.width: 1

                                                Text {
                                                    anchors.centerIn: parent
                                                    text: "ⓘ"
                                                    font.family: "Inter"
                                                    font.pixelSize: 16
                                                    font.weight: Font.DemiBold
                                                    color: "#FFFFFF"
                                                }
                                            }
                                        }

                                        Text {
                                            width: parent.width - 50
                                            anchors.verticalCenter: parent.verticalCenter
                                            text: "Apex may use sources like GPS, Wi-Fi, mobile networks, and sensors to help estimate your vehicle's location."
                                            font.family: "Inter"
                                            font.pixelSize: 15
                                            color: "#E2E8F0"
                                            wrapMode: Text.WordWrap
                                            lineHeight: 1.35
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                // Screen 2: Recent Location Requests Sub-screen (Slide Transition)
                Item {
                    id: locRecentRequestsView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    x: root.locCurrentScreen === "recent_requests" ? 0 : parent.width
                    opacity: root.locCurrentScreen === "recent_requests" ? 1.0 : 0.0
                    enabled: root.locCurrentScreen === "recent_requests"
                    visible: opacity > 0.001 || (x > -parent.width * 0.4 && x < parent.width)

                    Behavior on x { NumberAnimation { duration: 280; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 240; easing.type: Easing.InOutQuad } }

                    Flickable {
                        anchors.fill: parent
                        contentHeight: recentLocCol.height + 40
                        clip: true

                        Column {
                            id: recentLocCol
                            width: parent.width
                            spacing: 0

                            SettingRowChevron {
                                title: "Apex Navigation & Maps"
                                subtitle: "2 min ago • High accuracy GPS"
                            }

                            SettingRowChevron {
                                title: "Apex Weather Service"
                                subtitle: "14 min ago • Approximate network location"
                            }

                            SettingRowChevron {
                                title: "Emergency 911 Assist"
                                subtitle: "Standby • Direct GNSS crash sensor link"
                            }

                            SettingRowChevron {
                                title: "EV Charging Station Finder"
                                subtitle: "45 min ago • High accuracy GPS"
                            }
                        }
                    }
                }

                // Screen 3: App-Level Location Permissions Sub-screen (Slide Transition)
                Item {
                    id: locAppPermissionsView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    x: root.locCurrentScreen === "app_permissions" ? 0 : parent.width
                    opacity: root.locCurrentScreen === "app_permissions" ? 1.0 : 0.0
                    enabled: root.locCurrentScreen === "app_permissions"
                    visible: opacity > 0.001 || (x > -parent.width * 0.4 && x < parent.width)

                    Behavior on x { NumberAnimation { duration: 280; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 240; easing.type: Easing.InOutQuad } }

                    Flickable {
                        anchors.fill: parent
                        contentHeight: appPermCol.height + 40
                        clip: true

                        Column {
                            id: appPermCol
                            width: parent.width
                            spacing: 0

                            SettingRowSwitch {
                                title: "Apex Navigation & Maps"
                                subtitle: "Allowed all the time"
                                checked: true
                            }

                            SettingRowSwitch {
                                title: "Apex Weather Service"
                                subtitle: "Allowed only while in use"
                                checked: true
                            }

                            SettingRowSwitch {
                                title: "Emergency 911 Assist"
                                subtitle: "Allowed all the time"
                                checked: true
                            }

                            SettingRowSwitch {
                                title: "EV Charging Finder"
                                subtitle: "Allowed only while in use"
                                checked: true
                            }

                            SettingRowSwitch {
                                title: "Media Streaming Audio"
                                subtitle: "Ask every time"
                                checked: false
                            }
                        }
                    }
                }
            }

            // =================================================================
            // CATEGORY: NOTIFICATIONS
            // =================================================================
            Item {
                id: notificationsContainer
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: parent.width
                x: root.activeCategory === "notifications" ? 0 : 36
                opacity: root.activeCategory === "notifications" ? 1.0 : 0.0
                visible: opacity > 0.001
                clip: true

                Behavior on x { NumberAnimation { duration: 280; easing.type: Easing.OutCubic } }
                Behavior on opacity { NumberAnimation { duration: 240; easing.type: Easing.InOutQuad } }

                // Screen 1: Main Notifications Settings
                Item {
                    id: notifMainView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    x: root.notifCurrentScreen === "main" ? 0 : -parent.width * 0.4
                    opacity: root.notifCurrentScreen === "main" ? 1.0 : 0.0
                    enabled: root.notifCurrentScreen === "main"
                    visible: opacity > 0.001 || (x > -parent.width * 0.4 && x < parent.width)

                    Behavior on x { NumberAnimation { duration: 280; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 240; easing.type: Easing.InOutQuad } }

                    Flickable {
                        anchors.fill: parent
                        contentHeight: notifCol.height + 40
                        clip: true
                        boundsBehavior: Flickable.DragAndOvershootBounds
                        flickableDirection: Flickable.VerticalFlick

                        Column {
                            id: notifCol
                            width: parent.width
                            spacing: 0

                            SettingRowSwitch {
                                title: "Do Not Disturb while driving"
                                subtitle: "Mute alerts and incoming message notifications automatically when vehicle is in motion"
                                checked: root.dndWhileDriving
                                onToggled: {
                                    root.dndWhileDriving = !root.dndWhileDriving;
                                }
                            }

                            SettingRowChevron {
                                title: "App notifications"
                                subtitle: "Manage per-application alert permissions and pop-up priority"
                                onClicked: {
                                    root.notifSlideDir = 1;
                                    root.notifCurrentScreen = "app_notifications";
                                }
                            }

                            SettingRowSwitch {
                                title: "Notification sound"
                                subtitle: "Play audible chime for incoming priority alerts"
                                checked: root.notifSoundEnabled
                                onToggled: {
                                    root.notifSoundEnabled = !root.notifSoundEnabled;
                                }
                            }

                            SettingRowSwitch {
                                title: "Show on lock screen"
                                subtitle: "Display critical vehicle notifications in Calm Screen and locked mode"
                                checked: root.notifLockScreenEnabled
                                onToggled: {
                                    root.notifLockScreenEnabled = !root.notifLockScreenEnabled;
                                }
                            }
                        }
                    }
                }

                // Screen 2: App Notifications Sub-screen (Slide Transition)
                Item {
                    id: notifAppNotificationsView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    x: root.notifCurrentScreen === "app_notifications" ? 0 : parent.width
                    opacity: root.notifCurrentScreen === "app_notifications" ? 1.0 : 0.0
                    enabled: root.notifCurrentScreen === "app_notifications"
                    visible: opacity > 0.001 || (x > -parent.width * 0.4 && x < parent.width)

                    Behavior on x { NumberAnimation { duration: 280; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 240; easing.type: Easing.InOutQuad } }

                    Flickable {
                        anchors.fill: parent
                        contentHeight: appNotifCol.height + 40
                        clip: true
                        boundsBehavior: Flickable.DragAndOvershootBounds
                        flickableDirection: Flickable.VerticalFlick

                        Column {
                            id: appNotifCol
                            width: parent.width
                            spacing: 0

                            SettingRowSwitch {
                                title: "Apex Navigation & Traffic"
                                subtitle: "Turn-by-turn guidance and dynamic rerouting alerts"
                                checked: true
                            }

                            SettingRowSwitch {
                                title: "EV Battery & Charging"
                                subtitle: "Low charge warnings, charging complete notifications"
                                checked: true
                            }

                            SettingRowSwitch {
                                title: "Vehicle Health & Tire Pressure"
                                subtitle: "Maintenance reminders, TPMS alerts, and fault warnings"
                                checked: true
                            }

                            SettingRowSwitch {
                                title: "Phone Link & Messages"
                                subtitle: "Incoming call popups and SMS voice readouts"
                                checked: true
                            }

                            SettingRowSwitch {
                                title: "Weather & Hazard Warnings"
                                subtitle: "Severe weather alerts, black ice warnings along route"
                                checked: true
                            }

                            SettingRowSwitch {
                                title: "Media & Entertainment"
                                subtitle: "Audio track change banners and podcast chapter alerts"
                                checked: false
                            }
                        }
                    }
                }
            }

            // =================================================================
            // CATEGORY: PRIVACY (Replicated from OEM Apex Digital Experience)
            // =================================================================
            Item {
                id: privacyContainer
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: parent.width
                x: root.activeCategory === "privacy" ? 0 : 36
                opacity: root.activeCategory === "privacy" ? 1.0 : 0.0
                visible: opacity > 0.001
                clip: true

                Behavior on x { NumberAnimation { duration: 280; easing.type: Easing.OutCubic } }
                Behavior on opacity { NumberAnimation { duration: 240; easing.type: Easing.InOutQuad } }

                // --- MAIN PRIVACY MENU (Photo 1 & 2) ---
                Item {
                    id: privMainView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    x: root.privCurrentScreen === "main" ? 0 : -parent.width * 0.4
                    opacity: root.privCurrentScreen === "main" ? 1.0 : 0.0
                    enabled: root.privCurrentScreen === "main"
                    visible: opacity > 0.001 || (x > -parent.width * 0.4 && x < parent.width)

                    Behavior on x { NumberAnimation { duration: 320; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 280; easing.type: Easing.InOutQuad } }

                    Flickable {
                        anchors.fill: parent
                        contentHeight: privMainCol.height + 40
                        clip: true
                        boundsBehavior: Flickable.DragAndOvershootBounds
                        flickableDirection: Flickable.VerticalFlick

                        Column {
                            id: privMainCol
                            width: parent.width
                            spacing: 0

                            SettingRowChevron {
                                iconSource: "qrc:/ApexVision/qml/assets/icons/icon_mic_privacy.svg"
                                title: "Microphone"
                                subtitle: "Control app access to microphone"
                                onClicked: {
                                    root.privSlideDir = 1;
                                    root.privCurrentScreen = "microphone";
                                }
                            }

                            SettingRowChevron {
                                iconSource: "qrc:/ApexVision/qml/assets/icons/setting_location_white.svg"
                                title: "Location"
                                subtitle: "Control app access to your location"
                                onClicked: {
                                    root.privSlideDir = 1;
                                    root.privCurrentScreen = "location";
                                }
                            }

                            SettingRowChevron {
                                iconSource: "qrc:/ApexVision/qml/assets/icons/icon_app_permissions.svg"
                                title: "App permissions"
                                subtitle: "Control app access to your data"
                                onClicked: {
                                    root.privSlideDir = 1;
                                    root.privCurrentScreen = "app_permissions";
                                }
                            }

                            SettingRowChevron {
                                iconSource: "qrc:/ApexVision/qml/assets/icons/icon_privacy_infotainment.svg"
                                title: "Infotainment system data"
                                subtitle: "Manage activities and info saved on this system"
                                onClicked: {
                                    root.privSlideDir = 1;
                                    root.privCurrentScreen = "infotainment_data";
                                }
                            }

                            SettingRowChevron {
                                iconSource: "qrc:/ApexVision/qml/assets/icons/icon_settings_gear.svg"
                                title: "Ads"
                                subtitle: "Manage ads personalization on this device"
                                onClicked: {
                                    root.privSlideDir = 1;
                                    root.privCurrentScreen = "ads";
                                }
                            }

                            // OEM Section Header: "Apex" (Amber/Gold accent)
                            Item {
                                width: parent.width
                                height: 48

                                Text {
                                    anchors.left: parent.left
                                    anchors.leftMargin: 8
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: "Apex"
                                    font.family: "Inter"
                                    font.pixelSize: 18
                                    font.weight: Font.DemiBold
                                    color: root.currentThemeAccent
                                }
                            }

                            SettingRowChevron {
                                iconSource: "qrc:/ApexVision/qml/assets/icons/icon_data_sharing_apex.svg"
                                title: "Data sharing with Apex"
                                subtitle: "Manage connected features and sharing data with Apex"
                                onClicked: {
                                    root.privSlideDir = 1;
                                    root.privCurrentScreen = "data_sharing";
                                }
                            }
                        }
                    }
                }

                // --- SUB-SCREEN 1: MICROPHONE ---
                Item {
                    id: privMicView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    x: root.privCurrentScreen === "microphone" ? 0 : parent.width
                    opacity: root.privCurrentScreen === "microphone" ? 1.0 : 0.0
                    enabled: root.privCurrentScreen === "microphone"
                    visible: opacity > 0.001 || (x > -parent.width * 0.4 && x < parent.width)

                    Behavior on x { NumberAnimation { duration: 320; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 280; easing.type: Easing.InOutQuad } }

                    Flickable {
                        anchors.fill: parent
                        contentHeight: privMicCol.height + 40
                        clip: true
                        boundsBehavior: Flickable.DragAndOvershootBounds
                        flickableDirection: Flickable.VerticalFlick

                        Column {
                            id: privMicCol
                            width: parent.width
                            spacing: 0

                            SettingRowSwitch {
                                title: "Microphone access"
                                subtitle: "Allow apps and system features to access vehicle microphones"
                                checked: root.micAccessEnabled
                                onToggled: {
                                    root.micAccessEnabled = !root.micAccessEnabled;
                                }
                            }

                            Item {
                                width: parent.width
                                height: 48

                                Text {
                                    anchors.left: parent.left
                                    anchors.leftMargin: 8
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: "Recent access"
                                    font.family: "Inter"
                                    font.pixelSize: 18
                                    font.weight: Font.DemiBold
                                    color: root.currentThemeAccent
                                }
                            }

                            SettingRowChevron {
                                title: "Apex Voice Assistant"
                                subtitle: "Accessed 2 mins ago • Allowed all the time"
                                showChevron: false
                            }

                            SettingRowChevron {
                                title: "Hands-Free Bluetooth Call"
                                subtitle: "Accessed 18 mins ago • Allowed while in use"
                                showChevron: false
                            }

                            SettingRowChevron {
                                title: "In-Cabin Voice Notes"
                                subtitle: "Allowed while in use"
                                showChevron: false
                            }
                        }
                    }
                }

                // --- SUB-SCREEN 2: LOCATION ---
                Item {
                    id: privLocView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    x: root.privCurrentScreen === "location" ? 0 : parent.width
                    opacity: root.privCurrentScreen === "location" ? 1.0 : 0.0
                    enabled: root.privCurrentScreen === "location"
                    visible: opacity > 0.001 || (x > -parent.width * 0.4 && x < parent.width)

                    Behavior on x { NumberAnimation { duration: 320; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 280; easing.type: Easing.InOutQuad } }

                    Flickable {
                        anchors.fill: parent
                        contentHeight: privLocCol.height + 40
                        clip: true
                        boundsBehavior: Flickable.DragAndOvershootBounds
                        flickableDirection: Flickable.VerticalFlick

                        Column {
                            id: privLocCol
                            width: parent.width
                            spacing: 0

                            SettingRowSwitch {
                                title: "Location access"
                                subtitle: "Use precise vehicle GPS location for navigation and road safety features"
                                checked: root.locationEnabled
                                onToggled: {
                                    root.locationEnabled = !root.locationEnabled;
                                }
                            }

                            Item {
                                width: parent.width
                                height: 48

                                Text {
                                    anchors.left: parent.left
                                    anchors.leftMargin: 8
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: "Recent location requests"
                                    font.family: "Inter"
                                    font.pixelSize: 18
                                    font.weight: Font.DemiBold
                                    color: root.currentThemeAccent
                                }
                            }

                            SettingRowChevron {
                                title: "Apex Navigation"
                                subtitle: "Accessed just now • Precise location"
                                showChevron: false
                            }

                            SettingRowChevron {
                                title: "Weather & Climate Forecast"
                                subtitle: "Accessed 14 mins ago • Approximate location"
                                showChevron: false
                            }

                            SettingRowChevron {
                                title: "Apex 911 Emergency Assist"
                                subtitle: "Always allowed • Vehicle crash telemetry"
                                showChevron: false
                            }
                        }
                    }
                }

                // --- SUB-SCREEN 3: APP PERMISSIONS ---
                Item {
                    id: privPermView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    x: root.privCurrentScreen === "app_permissions" ? 0 : parent.width
                    opacity: root.privCurrentScreen === "app_permissions" ? 1.0 : 0.0
                    enabled: root.privCurrentScreen === "app_permissions"
                    visible: opacity > 0.001 || (x > -parent.width * 0.4 && x < parent.width)

                    Behavior on x { NumberAnimation { duration: 320; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 280; easing.type: Easing.InOutQuad } }

                    Flickable {
                        anchors.fill: parent
                        contentHeight: privPermCol.height + 40
                        clip: true
                        boundsBehavior: Flickable.DragAndOvershootBounds
                        flickableDirection: Flickable.VerticalFlick

                        Column {
                            id: privPermCol
                            width: parent.width
                            spacing: 0

                            SettingRowChevron {
                                title: "Body & Vehicle Sensors"
                                subtitle: "3 of 3 apps allowed (ADAS, Telemetry, Drive Modes)"
                            }

                            SettingRowChevron {
                                title: "Camera"
                                subtitle: "2 of 4 apps allowed (360 Surround, Dashcam)"
                            }

                            SettingRowChevron {
                                title: "Contacts & Call logs"
                                subtitle: "1 of 2 apps allowed (Bluetooth Phone Link)"
                            }

                            SettingRowChevron {
                                title: "Location"
                                subtitle: "4 of 7 apps allowed (Maps, Weather, Safety, EV charging)"
                            }

                            SettingRowChevron {
                                title: "Microphone"
                                subtitle: "3 of 5 apps allowed (Assistant, Phone, Voice Memo)"
                            }

                            SettingRowChevron {
                                title: "Storage & Media Files"
                                subtitle: "5 of 5 apps allowed"
                            }
                        }
                    }
                }

                // --- SUB-SCREEN 4: INFOTAINMENT SYSTEM DATA ---
                Item {
                    id: privInfoDataView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    x: root.privCurrentScreen === "infotainment_data" ? 0 : parent.width
                    opacity: root.privCurrentScreen === "infotainment_data" ? 1.0 : 0.0
                    enabled: root.privCurrentScreen === "infotainment_data"
                    visible: opacity > 0.001 || (x > -parent.width * 0.4 && x < parent.width)

                    Behavior on x { NumberAnimation { duration: 320; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 280; easing.type: Easing.InOutQuad } }

                    Flickable {
                        anchors.fill: parent
                        contentHeight: privInfoDataCol.height + 40
                        clip: true
                        boundsBehavior: Flickable.DragAndOvershootBounds
                        flickableDirection: Flickable.VerticalFlick

                        Column {
                            id: privInfoDataCol
                            width: parent.width
                            spacing: 0

                            SettingRowSwitch {
                                title: "Activity history"
                                subtitle: "Save interactions and media history to personalize in-cabin recommendations"
                                checked: true
                            }

                            SettingRowSwitch {
                                title: "Diagnostics & system logs"
                                subtitle: "Automatically submit performance telemetry to optimize system responsiveness"
                                checked: root.diagnosticDataEnabled
                                onToggled: {
                                    root.diagnosticDataEnabled = !root.diagnosticDataEnabled;
                                }
                            }

                            SettingRowChevron {
                                title: "Clear infotainment cache"
                                subtitle: "Delete temporary audio thumbnails, album art, and cached map tiles"
                            }

                            SettingRowChevron {
                                title: "Delete navigation history"
                                subtitle: "Erase recent destinations, favorite waypoints, and search logs"
                            }
                        }
                    }
                }

                // --- SUB-SCREEN 5: ADS ---
                Item {
                    id: privAdsView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    x: root.privCurrentScreen === "ads" ? 0 : parent.width
                    opacity: root.privCurrentScreen === "ads" ? 1.0 : 0.0
                    enabled: root.privCurrentScreen === "ads"
                    visible: opacity > 0.001 || (x > -parent.width * 0.4 && x < parent.width)

                    Behavior on x { NumberAnimation { duration: 320; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 280; easing.type: Easing.InOutQuad } }

                    Flickable {
                        anchors.fill: parent
                        contentHeight: privAdsCol.height + 40
                        clip: true
                        boundsBehavior: Flickable.DragAndOvershootBounds
                        flickableDirection: Flickable.VerticalFlick

                        Column {
                            id: privAdsCol
                            width: parent.width
                            spacing: 0

                            SettingRowSwitch {
                                title: "Ads personalization"
                                subtitle: "Manage ads personalization on this device"
                                checked: root.adsPersonalization
                                onToggled: {
                                    root.adsPersonalization = !root.adsPersonalization;
                                }
                            }

                            SettingRowChevron {
                                title: "Reset advertising ID"
                                subtitle: "Generate a fresh anonymous identifier for connected partner promotions"
                            }

                            SettingRowChevron {
                                title: "Delete advertising ID"
                                subtitle: "Remove advertising ID so partner services cannot build interest profiles"
                            }
                        }
                    }
                }

                // --- SUB-SCREEN 6: DATA SHARING WITH APEX ---
                Item {
                    id: privDataSharingView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    x: root.privCurrentScreen === "data_sharing" ? 0 : parent.width
                    opacity: root.privCurrentScreen === "data_sharing" ? 1.0 : 0.0
                    enabled: root.privCurrentScreen === "data_sharing"
                    visible: opacity > 0.001 || (x > -parent.width * 0.4 && x < parent.width)

                    Behavior on x { NumberAnimation { duration: 320; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 280; easing.type: Easing.InOutQuad } }

                    Flickable {
                        anchors.fill: parent
                        contentHeight: privDataSharingCol.height + 40
                        clip: true
                        boundsBehavior: Flickable.DragAndOvershootBounds
                        flickableDirection: Flickable.VerticalFlick

                        Column {
                            id: privDataSharingCol
                            width: parent.width
                            spacing: 0

                            SettingRowSwitch {
                                title: "Connected vehicle features"
                                subtitle: "Enable remote lock, climate precondition, and status sync via Apex mobile app"
                                checked: root.analyticsSharing
                                onToggled: {
                                    root.analyticsSharing = !root.analyticsSharing;
                                }
                            }

                            SettingRowSwitch {
                                title: "Live traffic & hazard sharing"
                                subtitle: "Anonymously share road condition telemetry and speed data to assist other drivers"
                                checked: root.trafficSharing
                                onToggled: {
                                    root.trafficSharing = !root.trafficSharing;
                                }
                            }

                            SettingRowSwitch {
                                title: "Over-the-Air improvement data"
                                subtitle: "Share diagnostic data to help improve Apex firmware and autonomous features"
                                checked: root.otaDataSharing
                                onToggled: {
                                    root.otaDataSharing = !root.otaDataSharing;
                                }
                            }

                            SettingRowChevron {
                                title: "Apex privacy statement"
                                subtitle: "Read complete legal documentation on how vehicle data is secured"
                            }
                        }
                    }
                }
            }

            // =================================================================
            // CATEGORY: SECURITY (Complete Profile Security replica + OEM specs)
            // =================================================================
            Item {
                id: securityContainer
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: parent.width
                x: root.activeCategory === "security" ? 0 : 36
                opacity: root.activeCategory === "security" ? 1.0 : 0.0
                visible: opacity > 0.001
                clip: true

                Behavior on x { NumberAnimation { duration: 280; easing.type: Easing.OutCubic } }
                Behavior on opacity { NumberAnimation { duration: 240; easing.type: Easing.InOutQuad } }

                // --- MAIN SECURITY MENU (Photo 3) ---
                Item {
                    id: secMainView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    x: root.secCurrentScreen === "main" ? 0 : -parent.width * 0.4
                    opacity: root.secCurrentScreen === "main" ? 1.0 : 0.0
                    enabled: root.secCurrentScreen === "main"
                    visible: opacity > 0.001 || (x > -parent.width * 0.4 && x < parent.width)

                    Behavior on x { NumberAnimation { duration: 320; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 280; easing.type: Easing.InOutQuad } }

                    Flickable {
                        anchors.fill: parent
                        contentHeight: secMainCol.height + 40
                        clip: true
                        boundsBehavior: Flickable.DragAndOvershootBounds
                        flickableDirection: Flickable.VerticalFlick

                        Column {
                            id: secMainCol
                            width: parent.width
                            spacing: 0

                            SettingRowChevron {
                                iconSource: "qrc:/ApexVision/qml/assets/icons/icon_profile_lock.svg"
                                title: "Profile lock"
                                subtitle: root.currentLockType
                                onClicked: {
                                    root.secSlideDir = 1;
                                    root.secCurrentScreen = "lock_type";
                                }
                            }

                            SettingRowChevron {
                                title: "Clear credentials"
                                subtitle: "Remove all certificates"
                                onClicked: {
                                    root.secSlideDir = 1;
                                    root.secCurrentScreen = "clear_credentials";
                                }
                            }

                            SettingRowChevron {
                                iconSource: "qrc:/ApexVision/qml/assets/icons/icon_security_update.svg"
                                title: "Security update"
                                subtitle: "November 5, 2026"
                                onClicked: {
                                    root.secSlideDir = 1;
                                    root.secCurrentScreen = "security_update";
                                }
                            }
                        }
                    }
                }

                // --- LEVEL 2: CHOOSE A LOCK TYPE (Copied from Profile Security) ---
                Item {
                    id: secLockTypeView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    x: root.secCurrentScreen === "lock_type" ? 0 :
                       (root.secCurrentScreen === "pattern" || root.secCurrentScreen === "pin" || root.secCurrentScreen === "password" ? -parent.width * 0.4 : parent.width)
                    opacity: root.secCurrentScreen === "lock_type" ? 1.0 : 0.0
                    enabled: root.secCurrentScreen === "lock_type"
                    visible: opacity > 0.001 || (x > -parent.width * 0.4 && x < parent.width)

                    Behavior on x { NumberAnimation { duration: 320; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 280; easing.type: Easing.InOutQuad } }

                    Flickable {
                        anchors.fill: parent
                        contentHeight: secLockCol.height + 40
                        clip: true
                        boundsBehavior: Flickable.DragAndOvershootBounds
                        flickableDirection: Flickable.VerticalFlick

                        Column {
                            id: secLockCol
                            width: parent.width
                            spacing: 0

                            // None
                            SettingRowChevron {
                                title: "None"
                                subtitle: root.currentLockType === "None" ? "Current screen lock" : ""
                                showChevron: false
                                onClicked: {
                                    root.currentLockType = "None";
                                    root.secSlideDir = -1;
                                    root.secCurrentScreen = "main";
                                }
                            }

                            // Pattern
                            SettingRowChevron {
                                title: "Pattern"
                                subtitle: root.currentLockType === "Pattern" ? "Current screen lock" : ""
                                showChevron: true
                                onClicked: {
                                    root.secSlideDir = 1;
                                    root.patternNodes = [];
                                    root.secCurrentScreen = "pattern";
                                }
                            }

                            // PIN
                            SettingRowChevron {
                                title: "PIN"
                                subtitle: root.currentLockType === "PIN" ? "Current screen lock" : ""
                                showChevron: true
                                onClicked: {
                                    root.secSlideDir = 1;
                                    root.tempPinEntry = "";
                                    root.secCurrentScreen = "pin";
                                }
                            }

                            // Password
                            SettingRowChevron {
                                title: "Password"
                                subtitle: root.currentLockType === "Password" ? "Current screen lock" : ""
                                showChevron: true
                                onClicked: {
                                    root.secSlideDir = 1;
                                    root.tempPasswordEntry = "";
                                    root.secCurrentScreen = "password";
                                }
                            }
                        }
                    }
                }

                // --- LEVEL 3A: PIN SETUP VIEW (Copied from Profile Security) ---
                Item {
                    id: secPinView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    x: root.secCurrentScreen === "pin" ? 0 : parent.width
                    opacity: root.secCurrentScreen === "pin" ? 1.0 : 0.0
                    enabled: root.secCurrentScreen === "pin"
                    visible: opacity > 0.001 || x < parent.width

                    Behavior on x { NumberAnimation { duration: 320; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 280; easing.type: Easing.InOutQuad } }

                    Column {
                        anchors.centerIn: parent
                        spacing: 20

                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "Enter a 4-digit PIN for " + root.currentProfileName
                            color: "#94A3B8"
                            font.family: "Inter"
                            font.pixelSize: 18
                        }

                        // PIN Indicator Dots
                        Row {
                            anchors.horizontalCenter: parent.horizontalCenter
                            spacing: 18
                            Repeater {
                                model: 4
                                Rectangle {
                                    width: 18; height: 18; radius: 9
                                    color: index < root.tempPinEntry.length ? "#38BDF8" : "transparent"
                                    border.color: index < root.tempPinEntry.length ? "#38BDF8" : Qt.rgba(255, 255, 255, 0.4)
                                    border.width: 2
                                    Behavior on color { ColorAnimation { duration: 100 } }
                                }
                            }
                        }

                        Item { width: 1; height: 6 }

                        // 3x4 Keypad
                        Grid {
                            anchors.horizontalCenter: parent.horizontalCenter
                            columns: 3
                            spacing: 14

                            Repeater {
                                model: ["1", "2", "3", "4", "5", "6", "7", "8", "9", "⌫", "0", "OK"]

                                Rectangle {
                                    width: 76; height: 60; radius: 14
                                    color: modelData === "OK" ? (root.tempPinEntry.length === 4 ? "#2563EB" : Qt.rgba(255, 255, 255, 0.04)) :
                                           (secKeyMouse.pressed ? Qt.rgba(255, 255, 255, 0.16) :
                                           (secKeyMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.10) : Qt.rgba(255, 255, 255, 0.05)))
                                    border.color: Qt.rgba(255, 255, 255, 0.12)
                                    border.width: 1

                                    Text {
                                        anchors.centerIn: parent
                                        text: modelData
                                        color: modelData === "OK" ? (root.tempPinEntry.length === 4 ? "#FFFFFF" : "#64748B") : "#FFFFFF"
                                        font.family: "Inter"
                                        font.pixelSize: modelData === "OK" ? 18 : 24
                                        font.weight: Font.DemiBold
                                    }

                                    MouseArea {
                                        id: secKeyMouse
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: {
                                            if (modelData === "⌫") {
                                                if (root.tempPinEntry.length > 0) root.tempPinEntry = root.tempPinEntry.slice(0, -1);
                                            } else if (modelData === "OK") {
                                                if (root.tempPinEntry.length === 4) {
                                                    root.profilePinCode = root.tempPinEntry;
                                                    root.currentLockType = "PIN";
                                                    root.secSlideDir = -1;
                                                    root.secCurrentScreen = "main";
                                                }
                                            } else {
                                                if (root.tempPinEntry.length < 4) root.tempPinEntry += modelData;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                // --- LEVEL 3B: PATTERN SETUP VIEW (Copied from Profile Security) ---
                Item {
                    id: secPatternView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    x: root.secCurrentScreen === "pattern" ? 0 : parent.width
                    opacity: root.secCurrentScreen === "pattern" ? 1.0 : 0.0
                    enabled: root.secCurrentScreen === "pattern"
                    visible: opacity > 0.001 || x < parent.width

                    Behavior on x { NumberAnimation { duration: 320; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 280; easing.type: Easing.InOutQuad } }

                    Column {
                        anchors.centerIn: parent
                        spacing: 24

                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "Connect at least 4 dots for unlock pattern"
                            color: "#94A3B8"
                            font.family: "Inter"
                            font.pixelSize: 18
                        }

                        // 3x3 Dot Grid
                        Grid {
                            anchors.horizontalCenter: parent.horizontalCenter
                            columns: 3
                            spacing: 36

                            Repeater {
                                model: 9

                                Rectangle {
                                    width: 44; height: 44; radius: 22
                                    property bool selected: root.patternNodes.indexOf(index) !== -1
                                    color: selected ? "#38BDF8" : Qt.rgba(255, 255, 255, 0.15)
                                    border.color: selected ? "#38BDF8" : Qt.rgba(255, 255, 255, 0.3)
                                    border.width: selected ? 3 : 1

                                    Rectangle {
                                        anchors.centerIn: parent
                                        width: 14; height: 14; radius: 7
                                        color: "#FFFFFF"
                                    }

                                    MouseArea {
                                        anchors.fill: parent
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: {
                                            var idx = root.patternNodes.indexOf(index);
                                            var copy = root.patternNodes.slice();
                                            if (idx === -1) {
                                                copy.push(index);
                                            } else {
                                                copy.splice(idx, 1);
                                            }
                                            root.patternNodes = copy;
                                        }
                                    }
                                }
                            }
                        }

                        Row {
                            anchors.horizontalCenter: parent.horizontalCenter
                            spacing: 16

                            Rectangle {
                                width: 110; height: 44; radius: 10
                                color: Qt.rgba(255, 255, 255, 0.08)
                                Text { anchors.centerIn: parent; text: "Clear"; color: "#FFFFFF"; font.family: "Inter"; font.pixelSize: 16 }
                                MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: root.patternNodes = []; }
                            }

                            Rectangle {
                                width: 140; height: 44; radius: 10
                                color: root.patternNodes.length >= 4 ? "#2563EB" : Qt.rgba(255, 255, 255, 0.06)
                                Text { anchors.centerIn: parent; text: "Confirm"; color: root.patternNodes.length >= 4 ? "#FFFFFF" : "#64748B"; font.family: "Inter"; font.pixelSize: 16; font.weight: Font.DemiBold }
                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                        if (root.patternNodes.length >= 4) {
                                            root.currentLockType = "Pattern";
                                            if (typeof VehicleBackend !== "undefined") VehicleBackend.setCurrentLockType("Pattern");
                                            root.secSlideDir = -1;
                                            root.secCurrentScreen = "main";
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                // --- LEVEL 3C: PASSWORD SETUP VIEW (Copied from Profile Security) ---
                Item {
                    id: secPasswordView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    x: root.secCurrentScreen === "password" ? 0 : parent.width
                    opacity: root.secCurrentScreen === "password" ? 1.0 : 0.0
                    enabled: root.secCurrentScreen === "password"
                    visible: opacity > 0.001 || x < parent.width

                    Behavior on x { NumberAnimation { duration: 320; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 280; easing.type: Easing.InOutQuad } }

                    Column {
                        anchors.centerIn: parent
                        spacing: 24
                        width: Math.min(parent.width - 40, 480)

                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "Set a password for " + root.currentProfileName
                            color: "#94A3B8"
                            font.family: "Inter"
                            font.pixelSize: 18
                        }

                        Rectangle {
                            width: parent.width
                            height: 54
                            radius: 12
                            color: Qt.rgba(255, 255, 255, 0.07)
                            border.color: Qt.rgba(255, 255, 255, 0.2)
                            border.width: 1.5

                            TextInput {
                                id: secPwdInput
                                anchors.fill: parent
                                anchors.leftMargin: 16
                                anchors.rightMargin: 16
                                verticalAlignment: TextInput.AlignVCenter
                                color: "#FFFFFF"
                                font.family: "Inter"
                                font.pixelSize: 18
                                echoMode: TextInput.Password
                                text: root.tempPasswordEntry
                                onTextChanged: root.tempPasswordEntry = text
                            }
                        }

                        Row {
                            anchors.horizontalCenter: parent.horizontalCenter
                            spacing: 16

                            Rectangle {
                                width: 120; height: 46; radius: 10
                                color: Qt.rgba(255, 255, 255, 0.08)
                                Text { anchors.centerIn: parent; text: "Cancel"; color: "#FFFFFF"; font.family: "Inter"; font.pixelSize: 16 }
                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                        root.secSlideDir = -1;
                                        root.secCurrentScreen = "lock_type";
                                    }
                                }
                            }

                            Rectangle {
                                width: 140; height: 46; radius: 10
                                color: root.tempPasswordEntry.length >= 4 ? "#2563EB" : Qt.rgba(255, 255, 255, 0.06)
                                Text {
                                    anchors.centerIn: parent
                                    text: "Confirm"
                                    color: root.tempPasswordEntry.length >= 4 ? "#FFFFFF" : "#64748B"
                                    font.family: "Inter"; font.pixelSize: 16; font.weight: Font.DemiBold
                                }
                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                        if (root.tempPasswordEntry.length >= 4) {
                                            root.profilePassword = root.tempPasswordEntry;
                                            root.currentLockType = "Password";
                                            if (typeof VehicleBackend !== "undefined") VehicleBackend.setProfilePassword(root.profilePassword);
                                            root.secSlideDir = -1;
                                            root.secCurrentScreen = "main";
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                // --- LEVEL 2B: CLEAR CREDENTIALS ---
                Item {
                    id: secClearCredView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    x: root.secCurrentScreen === "clear_credentials" ? 0 : parent.width
                    opacity: root.secCurrentScreen === "clear_credentials" ? 1.0 : 0.0
                    enabled: root.secCurrentScreen === "clear_credentials"
                    visible: opacity > 0.001 || (x > -parent.width * 0.4 && x < parent.width)

                    Behavior on x { NumberAnimation { duration: 320; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 280; easing.type: Easing.InOutQuad } }

                    Flickable {
                        anchors.fill: parent
                        contentHeight: secClearCredCol.height + 40
                        clip: true
                        boundsBehavior: Flickable.DragAndOvershootBounds
                        flickableDirection: Flickable.VerticalFlick

                        Column {
                            id: secClearCredCol
                            width: parent.width
                            spacing: 0

                            SettingRowChevron {
                                title: "Clear all certificates"
                                subtitle: "Remove all user-installed credentials, VPN profiles, and enterprise keys"
                            }

                            SettingRowChevron {
                                title: "Trusted credentials"
                                subtitle: "Display pre-installed Apex CA authority certificates"
                            }

                            SettingRowChevron {
                                title: "User credentials"
                                subtitle: "No custom user certificates currently installed"
                            }
                        }
                    }
                }

                // --- LEVEL 2C: SECURITY UPDATE ---
                Item {
                    id: secUpdateView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    x: root.secCurrentScreen === "security_update" ? 0 : parent.width
                    opacity: root.secCurrentScreen === "security_update" ? 1.0 : 0.0
                    enabled: root.secCurrentScreen === "security_update"
                    visible: opacity > 0.001 || (x > -parent.width * 0.4 && x < parent.width)

                    Behavior on x { NumberAnimation { duration: 320; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 280; easing.type: Easing.InOutQuad } }

                    Flickable {
                        anchors.fill: parent
                        contentHeight: secUpdateCol.height + 40
                        clip: true
                        boundsBehavior: Flickable.DragAndOvershootBounds
                        flickableDirection: Flickable.VerticalFlick

                        Column {
                            id: secUpdateCol
                            width: parent.width
                            spacing: 0

                            SettingRowSimple {
                                title: "Apex Security Patch Level"
                                subtitle: "November 5, 2026"
                            }

                            SettingRowSimple {
                                title: "Hardware Root-of-Trust"
                                subtitle: "Apex Secure Element • Enforced & Protected"
                            }

                            SettingRowSimple {
                                title: "Kernel Integrity"
                                subtitle: "Verified Boot 2.0 (DM-Verity Active)"
                            }

                            SettingRowChevron {
                                title: "Check for security updates"
                                subtitle: "System verified up to date"
                            }
                        }
                    }
                }
            }

            // =================================================================
            // CATEGORY: ACCESSIBILITY (Replicated from OEM Apex Digital Experience)
            // =================================================================
            Item {
                id: accessibilityContainer
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: parent.width
                x: root.activeCategory === "accessibility" ? 0 : 36
                opacity: root.activeCategory === "accessibility" ? 1.0 : 0.0
                visible: opacity > 0.001
                clip: true

                Behavior on x { NumberAnimation { duration: 280; easing.type: Easing.OutCubic } }
                Behavior on opacity { NumberAnimation { duration: 240; easing.type: Easing.InOutQuad } }

                // --- MAIN ACCESSIBILITY MENU (Photo 4) ---
                Item {
                    id: accMainView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    x: root.accCurrentScreen === "main" ? 0 : -parent.width * 0.4
                    opacity: root.accCurrentScreen === "main" ? 1.0 : 0.0
                    enabled: root.accCurrentScreen === "main"
                    visible: opacity > 0.001 || (x > -parent.width * 0.4 && x < parent.width)

                    Behavior on x { NumberAnimation { duration: 320; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 280; easing.type: Easing.InOutQuad } }

                    Flickable {
                        anchors.fill: parent
                        contentHeight: accMainCol.height + 40
                        clip: true
                        boundsBehavior: Flickable.DragAndOvershootBounds
                        flickableDirection: Flickable.VerticalFlick

                        Column {
                            id: accMainCol
                            width: parent.width
                            spacing: 0

                            // OEM Section Header: "Captions" (Photo 4 Amber/Gold accent)
                            Item {
                                width: parent.width
                                height: 48

                                Text {
                                    anchors.left: parent.left
                                    anchors.leftMargin: 8
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: "Captions"
                                    font.family: "Inter"
                                    font.pixelSize: 18
                                    font.weight: Font.DemiBold
                                    color: root.currentThemeAccent
                                }
                            }

                            SettingRowChevron {
                                iconSource: "qrc:/ApexVision/qml/assets/icons/icon_accessibility_captions.svg"
                                title: "Caption preferences"
                                subtitle: root.captionEnabled ? "On" : "Off"
                                onClicked: {
                                    root.accSlideDir = 1;
                                    root.accCurrentScreen = "caption_preferences";
                                }
                            }

                            // Section Header: "Display & Audio"
                            Item {
                                width: parent.width
                                height: 48

                                Text {
                                    anchors.left: parent.left
                                    anchors.leftMargin: 8
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: "Display & Audio"
                                    font.family: "Inter"
                                    font.pixelSize: 18
                                    font.weight: Font.DemiBold
                                    color: root.currentThemeAccent
                                }
                            }

                            SettingRowSwitch {
                                title: "High contrast text"
                                subtitle: "Enhance text contrast for easier readability in bright daylight"
                                checked: root.highContrastEnabled
                                onToggled: {
                                    root.highContrastEnabled = !root.highContrastEnabled;
                                }
                            }

                            SettingRowChevron {
                                title: "Display size and text"
                                subtitle: root.displayScaling
                                onClicked: {
                                    root.accSlideDir = 1;
                                    root.accCurrentScreen = "display_scaling";
                                }
                            }

                            SettingRowSwitch {
                                title: "Screen reader voice guidance"
                                subtitle: "Audible spoken feedback when tapping buttons and menus"
                                checked: root.screenReaderEnabled
                                onToggled: {
                                    root.screenReaderEnabled = !root.screenReaderEnabled;
                                }
                            }

                            SettingRowSwitch {
                                title: "Mono audio"
                                subtitle: "Combine left and right audio channels to play together in all cabin speakers"
                                checked: root.monoAudioEnabled
                                onToggled: {
                                    root.monoAudioEnabled = !root.monoAudioEnabled;
                                }
                            }
                        }
                    }
                }

                // --- SUB-SCREEN 1: CAPTION PREFERENCES ---
                Item {
                    id: accCaptionView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    x: root.accCurrentScreen === "caption_preferences" ? 0 : parent.width
                    opacity: root.accCurrentScreen === "caption_preferences" ? 1.0 : 0.0
                    enabled: root.accCurrentScreen === "caption_preferences"
                    visible: opacity > 0.001 || (x > -parent.width * 0.4 && x < parent.width)

                    Behavior on x { NumberAnimation { duration: 320; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 280; easing.type: Easing.InOutQuad } }

                    Flickable {
                        anchors.fill: parent
                        contentHeight: accCaptionCol.height + 40
                        clip: true
                        boundsBehavior: Flickable.DragAndOvershootBounds
                        flickableDirection: Flickable.VerticalFlick

                        Column {
                            id: accCaptionCol
                            width: parent.width
                            spacing: 0

                            SettingRowSwitch {
                                title: "Show captions"
                                subtitle: "Display closed captions for media, alerts, and navigation audio"
                                checked: root.captionEnabled
                                onToggled: {
                                    root.captionEnabled = !root.captionEnabled;
                                }
                            }

                            Item {
                                width: parent.width
                                height: 48

                                Text {
                                    anchors.left: parent.left
                                    anchors.leftMargin: 8
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: "Caption size"
                                    font.family: "Inter"
                                    font.pixelSize: 18
                                    font.weight: Font.DemiBold
                                    color: root.currentThemeAccent
                                }
                            }

                            SettingRowRadio {
                                title: "Small"
                                selected: root.captionSize === "Small"
                                onSelectedRequested: {
                                    root.captionSize = "Small";
                                }
                            }

                            SettingRowRadio {
                                title: "Medium (Default)"
                                selected: root.captionSize === "Medium"
                                onSelectedRequested: {
                                    root.captionSize = "Medium";
                                }
                            }

                            SettingRowRadio {
                                title: "Large"
                                selected: root.captionSize === "Large"
                                onSelectedRequested: {
                                    root.captionSize = "Large";
                                }
                            }

                            Item {
                                width: parent.width
                                height: 48

                                Text {
                                    anchors.left: parent.left
                                    anchors.leftMargin: 8
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: "Caption style"
                                    font.family: "Inter"
                                    font.pixelSize: 18
                                    font.weight: Font.DemiBold
                                    color: root.currentThemeAccent
                                }
                            }

                            SettingRowRadio {
                                title: "White text on black background"
                                selected: root.captionStyle === "White on black"
                                onSelectedRequested: {
                                    root.captionStyle = "White on black";
                                }
                            }

                            SettingRowRadio {
                                title: "Yellow text on black background"
                                selected: root.captionStyle === "Yellow on black"
                                onSelectedRequested: {
                                    root.captionStyle = "Yellow on black";
                                }
                            }

                            SettingRowRadio {
                                title: "Yellow text on transparent background"
                                selected: root.captionStyle === "Yellow on transparent"
                                onSelectedRequested: {
                                    root.captionStyle = "Yellow on transparent";
                                }
                            }
                        }
                    }
                }

                // --- SUB-SCREEN 2: DISPLAY SIZE AND TEXT ---
                Item {
                    id: accDisplayScaleView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    x: root.accCurrentScreen === "display_scaling" ? 0 : parent.width
                    opacity: root.accCurrentScreen === "display_scaling" ? 1.0 : 0.0
                    enabled: root.accCurrentScreen === "display_scaling"
                    visible: opacity > 0.001 || (x > -parent.width * 0.4 && x < parent.width)

                    Behavior on x { NumberAnimation { duration: 320; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 280; easing.type: Easing.InOutQuad } }

                    Flickable {
                        anchors.fill: parent
                        contentHeight: accDisplayScaleCol.height + 40
                        clip: true
                        boundsBehavior: Flickable.DragAndOvershootBounds
                        flickableDirection: Flickable.VerticalFlick

                        Column {
                            id: accDisplayScaleCol
                            width: parent.width
                            spacing: 0

                            Item {
                                width: parent.width
                                height: 48

                                Text {
                                    anchors.left: parent.left
                                    anchors.leftMargin: 8
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: "Display scale"
                                    font.family: "Inter"
                                    font.pixelSize: 18
                                    font.weight: Font.DemiBold
                                    color: root.currentThemeAccent
                                }
                            }

                            SettingRowRadio {
                                title: "Standard (100%)"
                                subtitle: "Default interface scaling for Apex Vision IVI"
                                selected: root.displayScaling === "Standard (100%)"
                                onSelectedRequested: {
                                    root.displayScaling = "Standard (100%)";
                                }
                            }

                            SettingRowRadio {
                                title: "Large (115%)"
                                subtitle: "Enlarges buttons, labels, and status bar text"
                                selected: root.displayScaling === "Large (115%)"
                                onSelectedRequested: {
                                    root.displayScaling = "Large (115%)";
                                }
                            }

                            SettingRowRadio {
                                title: "Largest (130%)"
                                subtitle: "Maximum visibility and touch target sizing"
                                selected: root.displayScaling === "Largest (130%)"
                                onSelectedRequested: {
                                    root.displayScaling = "Largest (130%)";
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

    // =========================================================================
    // REUSABLE ROW COMPONENTS (Radio, Switch, Chevron, Slider)
    // Reusable True Circular Image using MultiEffect Masking
    component CircularAvatarImage: Item {
        id: circAvatar
        property string source: ""
        property real radius: width / 2

        Image {
            id: avatarImg
            anchors.fill: parent
            source: circAvatar.source
            fillMode: Image.PreserveAspectCrop
            visible: false
            asynchronous: true
        }

        Rectangle {
            id: avatarMask
            anchors.fill: parent
            radius: circAvatar.radius
            color: "black"
            visible: false
            layer.enabled: true
        }

        MultiEffect {
            anchors.fill: parent
            source: avatarImg
            maskEnabled: true
            maskSource: avatarMask
        }
    }

    // Component 0: SettingRowSimple (Informational display row)
    component SettingRowSimple: Item {
        id: simpleRow
        property string title: ""
        property string subtitle: ""
        width: parent.width
        height: subtitle !== "" ? 88 : 72

        Column {
            anchors.left: parent.left
            anchors.leftMargin: 8
            anchors.right: parent.right
            anchors.rightMargin: 8
            anchors.verticalCenter: parent.verticalCenter
            spacing: 5

            Text {
                text: simpleRow.title
                font.family: "Inter"
                font.pixelSize: 22
                font.weight: Font.DemiBold
                color: "#FFFFFF"
            }

            Text {
                visible: simpleRow.subtitle !== ""
                text: simpleRow.subtitle
                font.family: "Inter"
                font.pixelSize: 15
                color: "#93C5FD"
            }
        }

        Rectangle {
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            height: 1
            color: Qt.rgba(255, 255, 255, 0.08)
        }
    }

    // Component 1: SettingRowRadio (Radio Button matching user reference photo)
    component SettingRowRadio: Item {
        id: radioRow
        property string title: ""
        property string subtitle: ""
        property bool selected: false
        property string infoText: ""
        signal selectedRequested()
        signal infoClicked()

        width: parent.width
        height: subtitle !== "" ? 92 : 80

        Rectangle {
            anchors.fill: parent
            anchors.margins: -2
            radius: 12
            color: radioMainMouse.pressed ? Qt.rgba(255, 255, 255, 0.08) :
                   (radioMainMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.04) : "transparent")
            Behavior on color { ColorAnimation { duration: 120 } }
        }

        Column {
            anchors.left: parent.left
            anchors.leftMargin: 8
            anchors.verticalCenter: parent.verticalCenter
            spacing: 5

            Text {
                text: radioRow.title
                font.family: "Inter"
                font.pixelSize: 22
                font.weight: Font.DemiBold
                color: "#FFFFFF"
            }

            Text {
                visible: radioRow.subtitle !== ""
                text: radioRow.subtitle
                font.family: "Inter"
                font.pixelSize: 15
                color: "#93C5FD"
            }
        }

        // Info (ⓘ) Icon Button
        Item {
            id: infoBtn
            width: 38
            height: 38
            anchors.right: parent.right
            anchors.rightMargin: 12
            anchors.verticalCenter: parent.verticalCenter
            visible: radioRow.infoText !== ""

            Rectangle {
                anchors.fill: parent
                radius: 19
                color: infoMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.16) : "transparent"

                Text {
                    anchors.centerIn: parent
                    text: "ⓘ"
                    font.family: "Inter"
                    font.pixelSize: 20
                    font.weight: Font.Medium
                    color: infoMouse.containsMouse ? "#FFFFFF" : Qt.rgba(255, 255, 255, 0.70)
                }
            }

            MouseArea {
                id: infoMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: radioRow.infoClicked()
            }
        }

        // Radio Button (Amber when selected matching user photo)
        Item {
            anchors.right: infoBtn.visible ? infoBtn.left : parent.right
            anchors.rightMargin: infoBtn.visible ? 28 : 20
            anchors.verticalCenter: parent.verticalCenter
            width: 32
            height: 32

            Rectangle {
                anchors.fill: parent
                radius: 16
                color: "transparent"
                border.color: radioRow.selected ? "#FB923C" : Qt.rgba(255, 255, 255, 0.50)
                border.width: 2.2
                Behavior on border.color { ColorAnimation { duration: 150 } }

                // Inner solid amber dot when selected
                Rectangle {
                    anchors.centerIn: parent
                    width: 16
                    height: 16
                    radius: 8
                    color: "#FB923C"
                    visible: radioRow.selected
                    opacity: radioRow.selected ? 1.0 : 0.0
                    scale: radioRow.selected ? 1.0 : 0.4
                    Behavior on scale { NumberAnimation { duration: 150; easing.type: Easing.OutBack } }
                    Behavior on opacity { NumberAnimation { duration: 150 } }
                }
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: radioRow.selectedRequested()
            }
        }

        MouseArea {
            id: radioMainMouse
            anchors.fill: parent
            anchors.rightMargin: 90
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: radioRow.selectedRequested()
        }

        // Bottom hairline separator
        Rectangle {
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            height: 1
            color: Qt.rgba(255, 255, 255, 0.10)
        }
    }

    // Component 2: SettingRowSwitch (Amber Toggle Switch matching user photo)
    component SettingRowSwitch: Item {
        id: switchRow
        property string title: ""
        property string subtitle: ""
        property bool checked: false
        property string infoText: ""
        signal toggled()
        signal infoClicked()

        width: parent.width
        height: subtitle !== "" ? Math.max(92, textCol.implicitHeight + 28) : 80

        Rectangle {
            anchors.fill: parent
            anchors.margins: -2
            radius: 12
            color: switchMainMouse.pressed ? Qt.rgba(255, 255, 255, 0.08) :
                   (switchMainMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.04) : "transparent")
            Behavior on color { ColorAnimation { duration: 120 } }
        }

        Column {
            id: textCol
            anchors.left: parent.left
            anchors.leftMargin: 8
            anchors.right: swInfoBtn.visible ? swInfoBtn.left : swTrack.left
            anchors.rightMargin: 20
            anchors.verticalCenter: parent.verticalCenter
            spacing: 5

            Text {
                width: parent.width
                text: switchRow.title
                font.family: "Inter"
                font.pixelSize: 22
                font.weight: Font.DemiBold
                color: "#FFFFFF"
                wrapMode: Text.WordWrap
            }

            Text {
                visible: switchRow.subtitle !== ""
                width: parent.width
                text: switchRow.subtitle
                font.family: "Inter"
                font.pixelSize: 15
                color: "#93C5FD"
                wrapMode: Text.WordWrap
            }
        }

        // Info (ⓘ) Icon Button
        Item {
            id: swInfoBtn
            width: 38
            height: 38
            anchors.right: parent.right
            anchors.rightMargin: 12
            anchors.verticalCenter: parent.verticalCenter
            visible: switchRow.infoText !== ""

            Rectangle {
                anchors.fill: parent
                radius: 19
                color: swInfoMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.16) : "transparent"

                Text {
                    anchors.centerIn: parent
                    text: "ⓘ"
                    font.family: "Inter"
                    font.pixelSize: 20
                    font.weight: Font.Medium
                    color: swInfoMouse.containsMouse ? "#FFFFFF" : Qt.rgba(255, 255, 255, 0.70)
                }
            }

            MouseArea {
                id: swInfoMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    if (switchRow.infoText !== "") root.activeInfoText = switchRow.infoText;
                    switchRow.infoClicked();
                }
            }
        }

        // Toggle Switch (OEM Peach Track when active matching user photo)
        Rectangle {
            id: swTrack
            anchors.right: swInfoBtn.visible ? swInfoBtn.left : parent.right
            anchors.rightMargin: swInfoBtn.visible ? 24 : 16
            anchors.verticalCenter: parent.verticalCenter
            width: 66
            height: 36
            radius: 18
            color: switchRow.checked ? "#E08365" : Qt.rgba(255, 255, 255, 0.16)
            border.color: switchRow.checked ? "#E08365" : Qt.rgba(255, 255, 255, 0.30)
            border.width: 1
            Behavior on color { ColorAnimation { duration: 150 } }

            Rectangle {
                width: 30
                height: 30
                radius: 15
                color: "#FFFFFF"
                anchors.verticalCenter: parent.verticalCenter
                x: switchRow.checked ? parent.width - width - 3 : 3
                Behavior on x { NumberAnimation { duration: 180; easing.type: Easing.OutQuad } }
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: switchRow.toggled()
            }
        }

        MouseArea {
            id: switchMainMouse
            anchors.fill: parent
            anchors.rightMargin: 90
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: switchRow.toggled()
        }

        // Bottom hairline separator
        Rectangle {
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            height: 1
            color: Qt.rgba(255, 255, 255, 0.10)
        }
    }

    // Component 3: SettingRowChevron
    component SettingRowChevron: Item {
        id: chevronRow
        property string title: ""
        property string subtitle: ""
        property string infoText: ""
        property string iconSource: ""
        property string customTrailingIcon: ""
        property bool indentWithIcon: false
        property bool isEnabled: true
        property bool showChevron: true
        property string titleColor: ""
        signal clicked()
        signal infoClicked()

        width: parent.width
        height: subtitle !== "" ? 92 : 80

        Rectangle {
            anchors.fill: parent
            anchors.margins: -2
            radius: 12
            color: chMainMouse.pressed ? Qt.rgba(255, 255, 255, 0.08) :
                   (chMainMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.04) : "transparent")
            Behavior on color { ColorAnimation { duration: 120 } }
        }

        Row {
            anchors.left: parent.left
            anchors.leftMargin: 8
            anchors.verticalCenter: parent.verticalCenter
            spacing: 16

            Item {
                visible: chevronRow.iconSource !== "" || chevronRow.indentWithIcon
                width: visible ? 28 : 0
                height: 28
                anchors.verticalCenter: parent.verticalCenter

                Image {
                    visible: chevronRow.iconSource !== ""
                    anchors.centerIn: parent
                    width: 24
                    height: 24
                    source: chevronRow.iconSource
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                    mipmap: true
                }
            }

            Column {
                anchors.verticalCenter: parent.verticalCenter
                spacing: 5

                Text {
                    text: chevronRow.title
                    font.family: "Inter"
                    font.pixelSize: 22
                    font.weight: Font.DemiBold
                    color: chevronRow.titleColor !== "" ? chevronRow.titleColor : (chevronRow.isEnabled ? "#FFFFFF" : "#64748B")
                }

                Text {
                    visible: chevronRow.subtitle !== ""
                    text: chevronRow.subtitle
                    font.family: "Inter"
                    font.pixelSize: 15
                    color: "#93C5FD"
                }
            }
        }

        // Info (ⓘ) Icon Button
        Item {
            id: chInfoBtn
            width: 38
            height: 38
            anchors.right: parent.right
            anchors.rightMargin: 12
            anchors.verticalCenter: parent.verticalCenter
            visible: chevronRow.infoText !== ""

            Rectangle {
                anchors.fill: parent
                radius: 19
                color: chInfoMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.16) : "transparent"

                Text {
                    anchors.centerIn: parent
                    text: "ⓘ"
                    font.family: "Inter"
                    font.pixelSize: 20
                    font.weight: Font.Medium
                    color: chInfoMouse.containsMouse ? "#FFFFFF" : Qt.rgba(255, 255, 255, 0.70)
                }
            }

            MouseArea {
                id: chInfoMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    if (chevronRow.infoText !== "") root.activeInfoText = chevronRow.infoText;
                    chevronRow.infoClicked();
                }
            }
        }

        // Chevron (>) or Custom Trailing Icon (e.g. Gear)
        Item {
            anchors.right: chInfoBtn.visible ? chInfoBtn.left : parent.right
            anchors.rightMargin: chInfoBtn.visible ? 30 : 20
            anchors.verticalCenter: parent.verticalCenter
            width: 32
            height: 32
            visible: (chevronRow.showChevron && chevronRow.customTrailingIcon === "") || chevronRow.customTrailingIcon !== ""

            Text {
                anchors.centerIn: parent
                visible: chevronRow.customTrailingIcon === ""
                text: "›"
                font.pixelSize: 32
                font.weight: Font.DemiBold
                color: "#CBD5E1"
            }

            Image {
                anchors.centerIn: parent
                visible: chevronRow.customTrailingIcon !== ""
                width: 24
                height: 24
                source: chevronRow.customTrailingIcon
                fillMode: Image.PreserveAspectFit
                smooth: true
                mipmap: true
            }
        }

        MouseArea {
            id: chMainMouse
            anchors.fill: parent
            anchors.rightMargin: 80
            enabled: chevronRow.isEnabled
            hoverEnabled: chevronRow.isEnabled
            cursorShape: chevronRow.isEnabled ? Qt.PointingHandCursor : Qt.ArrowCursor
            onClicked: chevronRow.clicked()
        }

        // Bottom hairline separator
        Rectangle {
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            height: 1
            color: Qt.rgba(255, 255, 255, 0.10)
        }
    }

    // Component 4: SettingRowSlider (Matching Exact OEM Reference Photo)
    component SettingRowSlider: Item {
        id: sliderRow
        property string title: ""
        property string subtitle: ""
        property real from: 0
        property real to: 100
        property real value: 50
        signal movedVal(real val)

        width: parent.width
        height: 86

        Column {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: 8
            anchors.rightMargin: 20
            anchors.verticalCenter: parent.verticalCenter
            spacing: 8

            // Custom Slider matching OEM Photo
            Slider {
                id: customSlider
                width: parent.width
                padding: 0
                leftPadding: 16
                rightPadding: 16
                from: sliderRow.from
                to: sliderRow.to
                value: sliderRow.value
                onMoved: sliderRow.movedVal(value)

                background: Item {
                    x: customSlider.leftPadding
                    y: customSlider.topPadding + customSlider.availableHeight / 2 - height / 2
                    implicitWidth: 380
                    implicitHeight: 12
                    width: customSlider.availableWidth
                    height: 12

                    // 1. Inactive / Empty Base Track Groove
                    Rectangle {
                        anchors.fill: parent
                        radius: 6
                        color: Qt.rgba(255, 255, 255, 0.14)
                    }

                    // 2. Active Filled Portion (from left up to dragger knob)
                    Rectangle {
                        anchors.left: parent.left
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        width: Math.max(height, customSlider.visualPosition * parent.width)
                        radius: 6
                        gradient: Gradient {
                            orientation: Gradient.Horizontal
                            GradientStop { position: 0.0; color: "#E08365" }
                            GradientStop { position: 0.5; color: "#F0B594" }
                            GradientStop { position: 1.0; color: "#F7D5BC" }
                        }
                    }

                    // 3. 5 discrete notch dots along the track (matching user photo)
                    Row {
                        id: sliderNotchDotsRow
                        anchors.fill: parent
                        anchors.leftMargin: 20
                        anchors.rightMargin: 20
                        spacing: Math.max(0, (width - 5 * 5) / 4)

                        Repeater {
                            model: 5
                            Rectangle {
                                anchors.verticalCenter: parent.verticalCenter
                                width: 5
                                height: 5
                                radius: 2.5
                                color: (20 + index * (sliderNotchDotsRow.spacing + 5) + 2.5) <= (customSlider.visualPosition * customSlider.availableWidth) ?
                                       "#6E2A18" : Qt.rgba(255, 255, 255, 0.35)
                            }
                        }
                    }
                }

                handle: Rectangle {
                    x: customSlider.leftPadding + customSlider.visualPosition * (customSlider.availableWidth - width)
                    y: customSlider.topPadding + customSlider.availableHeight / 2 - height / 2
                    implicitWidth: 30
                    implicitHeight: 30
                    radius: 15
                    color: "#0F172A"
                    border.color: "#FFFFFF"
                    border.width: 3.5

                    scale: customSlider.pressed ? 1.15 : 1.0
                    Behavior on scale { NumberAnimation { duration: 100 } }
                }
            }

            // Title underneath track (matches reference photo "rightness level")
            Row {
                width: parent.width
                Text {
                    text: sliderRow.title
                    font.family: "Inter"
                    font.pixelSize: 17
                    font.weight: Font.Medium
                    color: "#8FA0B8"
                }

                Item { width: 1; height: 1 }

                Text {
                    visible: sliderRow.subtitle !== ""
                    text: sliderRow.subtitle
                    font.family: "Inter"
                    font.pixelSize: 15
                    color: "#64748B"
                }
            }
        }

        Rectangle {
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            height: 1
            color: Qt.rgba(255, 255, 255, 0.08)
        }
    }

    // Reset Confirmation Dialog Modal
    Rectangle {
        id: factoryResetModal
        anchors.fill: parent
        color: Qt.rgba(0, 0, 0, 0.72)
        visible: root.factoryResetConfirmationOpen || root.resetConfirmationOpen
        opacity: visible ? 1.0 : 0.0
        z: 9999

        Behavior on opacity { NumberAnimation { duration: 200 } }

        MouseArea {
            anchors.fill: parent
            onClicked: {} // Block underlying clicks
        }

        Rectangle {
            width: 520
            height: 270
            radius: 20
            color: "#161B22"
            border.color: Qt.rgba(255, 255, 255, 0.20)
            border.width: 1.5
            anchors.centerIn: parent

            Column {
                anchors.fill: parent
                anchors.margins: 24
                spacing: 16

                Text {
                    text: {
                        if (root.resetModalType === "hotspot") return "Reset Wi-Fi hotspot?";
                        if (root.resetModalType === "paak") return "Reset Phone As A Key?";
                        if (root.resetModalType === "apps") return "Reset app preferences?";
                        if (root.resetModalType === "connectivity") return "Reset network settings?";
                        return "Erase all data?";
                    }
                    color: "#FFFFFF"
                    font.family: "Inter"
                    font.pixelSize: 22
                    font.weight: Font.Bold
                }

                Text {
                    width: parent.width
                    text: {
                        if (root.resetModalType === "hotspot") return "Vehicle Wi-Fi hotspot configuration, password, and connected client lists will be restored to factory defaults.";
                        if (root.resetModalType === "paak") return "All paired smartphone virtual keys and digital access tokens will be removed. You will need your physical key fob to operate the vehicle.";
                        if (root.resetModalType === "apps") return "This will reset all app permissions, default applications, and notification preferences. Existing app data and files will not be deleted.";
                        if (root.resetModalType === "connectivity") return "All paired Bluetooth devices, saved Wi-Fi networks, and network profiles will be removed from the vehicle.";
                        return "All personal profiles, accounts, media preferences, and custom settings will be permanently wiped. This cannot be undone.";
                    }
                    color: "#94A3B8"
                    font.family: "Inter"
                    font.pixelSize: 15
                    wrapMode: Text.WordWrap
                    lineHeight: 1.3
                }

                Item { width: 1; height: 1 }

                Row {
                    anchors.right: parent.right
                    spacing: 14

                    Rectangle {
                        width: 110
                        height: 44
                        radius: 10
                        color: Qt.rgba(255, 255, 255, 0.08)
                        Text {
                            anchors.centerIn: parent
                            text: "Cancel"
                            color: "#FFFFFF"
                            font.family: "Inter"; font.pixelSize: 16; font.weight: Font.DemiBold
                        }
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                root.factoryResetConfirmationOpen = false;
                                root.resetConfirmationOpen = false;
                            }
                        }
                    }

                    Rectangle {
                        width: 160
                        height: 44
                        radius: 10
                        color: (root.resetModalType === "factory" || root.resetModalType === "paak") ? "#DC2626" : "#FB923C"
                        Text {
                            anchors.centerIn: parent
                            text: {
                                if (root.resetModalType === "hotspot") return "Reset hotspot";
                                if (root.resetModalType === "paak") return "Reset keys";
                                if (root.resetModalType === "apps") return "Reset apps";
                                if (root.resetModalType === "connectivity") return "Reset settings";
                                return "Erase everything";
                            }
                            color: "#FFFFFF"
                            font.family: "Inter"; font.pixelSize: 16; font.weight: Font.Bold
                        }
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                root.factoryResetConfirmationOpen = false;
                                root.resetConfirmationOpen = false;
                                root.sysSlideDir = -1;
                                root.sysCurrentScreen = "reset_options";
                            }
                        }
                    }
                }
            }
        }
    }

    // Edit Profile Name Modal
    Rectangle {
        id: editProfileNameModal
        anchors.fill: parent
        color: Qt.rgba(0, 0, 0, 0.72)
        visible: root.editProfileNameOpen
        z: 100

        MouseArea { anchors.fill: parent }

        Rectangle {
            width: 480
            height: 240
            radius: 20
            color: "#161B22"
            border.color: Qt.rgba(255, 255, 255, 0.20)
            border.width: 1.5
            anchors.centerIn: parent

            Column {
                anchors.fill: parent
                anchors.margins: 24
                spacing: 16

                Text {
                    text: "Edit profile name"
                    color: "#FFFFFF"
                    font.family: "Inter"
                    font.pixelSize: 22
                    font.weight: Font.Bold
                }

                Rectangle {
                    width: parent.width
                    height: 50
                    radius: 10
                    color: Qt.rgba(255, 255, 255, 0.08)
                    border.color: Qt.rgba(255, 255, 255, 0.25)
                    border.width: 1

                    TextInput {
                        id: profNameInput
                        anchors.fill: parent
                        anchors.leftMargin: 16
                        anchors.rightMargin: 16
                        verticalAlignment: TextInput.AlignVCenter
                        color: "#FFFFFF"
                        font.family: "Inter"
                        font.pixelSize: 17
                        text: root.tempProfileNameInput
                        onTextChanged: root.tempProfileNameInput = text
                    }
                }

                Item { width: 1; height: 1 }

                Row {
                    anchors.right: parent.right
                    spacing: 14

                    Rectangle {
                        width: 110
                        height: 44
                        radius: 10
                        color: Qt.rgba(255, 255, 255, 0.08)
                        Text {
                            anchors.centerIn: parent
                            text: "Cancel"
                            color: "#FFFFFF"
                            font.family: "Inter"; font.pixelSize: 16; font.weight: Font.DemiBold
                        }
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: root.editProfileNameOpen = false
                        }
                    }

                    Rectangle {
                        width: 130
                        height: 44
                        radius: 10
                        color: root.tempProfileNameInput.trim().length > 0 ? "#2563EB" : Qt.rgba(255, 255, 255, 0.08)
                        Text {
                            anchors.centerIn: parent
                            text: "Save"
                            color: root.tempProfileNameInput.trim().length > 0 ? "#FFFFFF" : "#64748B"
                            font.family: "Inter"; font.pixelSize: 16; font.weight: Font.Bold
                        }
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                if (root.tempProfileNameInput.trim().length > 0) {
                                    root.currentProfileName = root.tempProfileNameInput.trim();
                                    if (typeof VehicleBackend !== "undefined") VehicleBackend.setDriverProfileName(root.currentProfileName);
                                    root.profileToastMessage = "Profile renamed to " + root.currentProfileName;
                                    profToastTimer.restart();
                                    root.editProfileNameOpen = false;
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    // Delete Profile Modal
    Rectangle {
        id: deleteProfileModal
        anchors.fill: parent
        color: Qt.rgba(0, 0, 0, 0.75)
        visible: root.deleteProfileModalOpen
        z: 100

        MouseArea { anchors.fill: parent }

        Rectangle {
            width: 520
            height: 280
            radius: 20
            color: "#161B22"
            border.color: Qt.rgba(239, 68, 68, 0.40)
            border.width: 1.5
            anchors.centerIn: parent

            Column {
                anchors.fill: parent
                anchors.margins: 24
                spacing: 16

                Text {
                    text: "Delete " + root.currentProfileName + "?"
                    color: "#FFFFFF"
                    font.family: "Inter"
                    font.pixelSize: 22
                    font.weight: Font.Bold
                }

                Text {
                    width: parent.width
                    text: "All personalized seat configurations, mirror angles, climate and audio presets, paired device links, and cloud synchronization data will be permanently wiped."
                    color: "#94A3B8"
                    font.family: "Inter"
                    font.pixelSize: 15
                    wrapMode: Text.WordWrap
                    lineHeight: 1.3
                }

                Item { width: 1; height: 1 }

                Row {
                    anchors.right: parent.right
                    spacing: 14

                    Rectangle {
                        width: 110
                        height: 44
                        radius: 10
                        color: Qt.rgba(255, 255, 255, 0.08)
                        Text {
                            anchors.centerIn: parent
                            text: "Cancel"
                            color: "#FFFFFF"
                            font.family: "Inter"; font.pixelSize: 16; font.weight: Font.DemiBold
                        }
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: root.deleteProfileModalOpen = false
                        }
                    }

                    Rectangle {
                        width: 150
                        height: 44
                        radius: 10
                        color: "#DC2626"
                        Text {
                            anchors.centerIn: parent
                            text: "Delete profile"
                            color: "#FFFFFF"
                            font.family: "Inter"; font.pixelSize: 16; font.weight: Font.Bold
                        }
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                if (typeof VehicleBackend !== "undefined") {
                                    VehicleBackend.deleteProfile(VehicleBackend.currentProfileId);
                                    root.currentProfileName = VehicleBackend.driverProfileName;
                                    root.currentProfileAvatar = VehicleBackend.driverProfileAvatar;
                                }
                                root.deleteProfileModalOpen = false;
                                root.profileToastMessage = "Profile removed";
                                profToastTimer.restart();
                            }
                        }
                    }
                }
            }
        }
    }
}
