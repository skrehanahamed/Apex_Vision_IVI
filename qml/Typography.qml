pragma Singleton
import QtQuick

QtObject {
    id: root

    readonly property string family: "Inter"

    // =========================================================================
    // AUTOMOTIVE OEM TYPOGRAPHY SCALES (Optimized for 1920×1200 Touchscreen)
    // =========================================================================

    // Display Large: Media frequency e.g. "95.9" (58 px / SemiBold)
    readonly property font displayLarge: Qt.font({
        family: "Inter",
        pixelSize: 58,
        weight: Font.DemiBold,
        letterSpacing: -1.0
    })

    // Display Medium: Key speed/metric values (46 px / SemiBold)
    readonly property font displayMedium: Qt.font({
        family: "Inter",
        pixelSize: 46,
        weight: Font.DemiBold,
        letterSpacing: -0.5
    })

    // Clock: Top rail digital clock (20 px / SemiBold)
    readonly property font clock: Qt.font({
        family: "Inter",
        pixelSize: 20,
        weight: Font.DemiBold,
        letterSpacing: 0.2
    })

    // Value: Climate temperature, high-priority readouts (24 px / SemiBold)
    readonly property font value: Qt.font({
        family: "Inter",
        pixelSize: 24,
        weight: Font.DemiBold,
        letterSpacing: 0.3
    })

    // Heading: Station name, section titles, card headers (22 px / SemiBold)
    readonly property font heading: Qt.font({
        family: "Inter",
        pixelSize: 22,
        weight: Font.DemiBold,
        letterSpacing: 0.0
    })

    // Body: Primary navigation labels & descriptions (18 px / Regular)
    readonly property font body: Qt.font({
        family: "Inter",
        pixelSize: 18,
        weight: Font.Normal,
        letterSpacing: 0.2
    })

    // Body Medium: Emphasized body text & card titles (18 px / Medium)
    readonly property font bodyMedium: Qt.font({
        family: "Inter",
        pixelSize: 18,
        weight: Font.Medium,
        letterSpacing: 0.2
    })

    // Button: Navigation buttons, HVAC buttons, action pills (16 px / Medium)
    readonly property font button: Qt.font({
        family: "Inter",
        pixelSize: 16,
        weight: Font.Medium,
        letterSpacing: 0.4
    })

    // Status: Status bar information, sensor tags (15 px / Regular)
    readonly property font status: Qt.font({
        family: "Inter",
        pixelSize: 15,
        weight: Font.Normal,
        letterSpacing: 0.2
    })

    // Caption: Small secondary information & mode tags (13 px / Medium)
    readonly property font caption: Qt.font({
        family: "Inter",
        pixelSize: 13,
        weight: Font.Medium,
        letterSpacing: 0.3
    })
}
