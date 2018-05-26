import QtQuick 2.0

ListView {
    anchors.fill: parent
    orientation: ListView.Horizontal
    layoutDirection: Qt.LeftToRight

    delegate: Column
    {
        Text {
            color: "white"
            text: summary
        }
        Text {
            color: "white"
            text: time
        }
        Text {
            color: "white"
            text: temperature
        }

        DarkSkyIcon {
            width: 100
            height: 100
            state: icon
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
