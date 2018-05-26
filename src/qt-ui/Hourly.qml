import QtQuick 2.0

ListView {
    id: root
    anchors.fill: parent
    orientation: ListView.Horizontal
    layoutDirection: Qt.LeftToRight
    property color iconColor: "blue"

    delegate: Column
    {
        Text {
            color: "white"
            text: summary
        }
        Text {
            color: "white"
            text: Qt.formatDateTime(time, "h:mm ap")
        }
        Text {
            color: "white"
            text: temperature
        }

        DarkSkyIcon {
            width: 100
            height: 100
            state: icon
            iconColor: root.iconColor
        }

        /*
        Loader {
            sourceComponent: DarkSkyIcon
            // thanks to https://stackoverflow.com/questions/33536881/set-loader-item-property
            onLoaded: item.state = icon
        } */

        spacing: 2
    }

    spacing: 2
}
