import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../components"

Item {
    id: root

    property bool climateOpen: false

    RowLayout {
        anchors.fill: parent
        anchors.topMargin: 8
        anchors.bottomMargin: 8
        anchors.leftMargin: 0
        anchors.rightMargin: 12
        spacing: 16

        // Navigation Area (Left / Center: ~62% width)
        NavigationPanel {
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.preferredWidth: 62
        }

        // Media Card (Right: ~38% width)
        MediaCard {
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.preferredWidth: 38
        }
    }
}
