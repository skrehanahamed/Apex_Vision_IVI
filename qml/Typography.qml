/**
 * ==============================================================================
 * Project: Apex VISION IVI - Digital Cockpit & Infotainment System
 * File: Typography.qml
 * Author / Developer: Sk Rehan Ahamed
 * License: MIT
 * ==============================================================================
 */

pragma Singleton
import QtQuick

QtObject {
    id: root

    readonly property string family: "Inter"

    // =========================================================================
    // AUTOMOTIVE OEM TYPOGRAPHY SCALES (Optimized for 1920×1200 Touchscreen)
    // =========================================================================

    // Display Large: Media frequency e.g. "95.9" (64 px / SemiBold)
    readonly property font displayLarge: Qt.font({
        family: "Inter",
        pixelSize: 64,
        weight: Font.DemiBold,
        letterSpacing: -1.0
    })

    // Display Medium: Key speed/metric values (50 px / SemiBold)
    readonly property font displayMedium: Qt.font({
        family: "Inter",
        pixelSize: 50,
        weight: Font.DemiBold,
        letterSpacing: -0.5
    })

    // Clock: Top rail digital clock (24 px / SemiBold)
    readonly property font clock: Qt.font({
        family: "Inter",
        pixelSize: 24,
        weight: Font.DemiBold,
        letterSpacing: 0.2
    })

    // Value: Climate temperature, high-priority readouts (28 px / SemiBold)
    readonly property font value: Qt.font({
        family: "Inter",
        pixelSize: 28,
        weight: Font.DemiBold,
        letterSpacing: 0.3
    })

    // Heading: Station name, section titles, card headers (26 px / SemiBold)
    readonly property font heading: Qt.font({
        family: "Inter",
        pixelSize: 26,
        weight: Font.DemiBold,
        letterSpacing: 0.0
    })

    // Body: Primary navigation labels & descriptions (21 px / Regular)
    readonly property font body: Qt.font({
        family: "Inter",
        pixelSize: 21,
        weight: Font.Normal,
        letterSpacing: 0.2
    })

    // Body Medium: Emphasized body text & card titles (21 px / Medium)
    readonly property font bodyMedium: Qt.font({
        family: "Inter",
        pixelSize: 21,
        weight: Font.Medium,
        letterSpacing: 0.2
    })

    // Button: Navigation buttons, HVAC buttons, action pills (19 px / Medium)
    readonly property font button: Qt.font({
        family: "Inter",
        pixelSize: 19,
        weight: Font.Medium,
        letterSpacing: 0.4
    })

    // Status: Status bar information, sensor tags (18 px / Regular)
    readonly property font status: Qt.font({
        family: "Inter",
        pixelSize: 18,
        weight: Font.Normal,
        letterSpacing: 0.2
    })

    // Caption: Small secondary information & mode tags (15 px / Medium)
    readonly property font caption: Qt.font({
        family: "Inter",
        pixelSize: 15,
        weight: Font.Medium,
        letterSpacing: 0.3
    })
}
