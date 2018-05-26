import QtQuick 2.0
import QtQuick.Layouts 1.1

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

        Row {

            Text {
                color: "white"
                text: "    " + temperature + "\xB0 F"
            }

        }

        Row {
            /*
            Text {
                color: "white"
                text: "Precipitation: " + precipProbablity
            } */

            Text {
                color: "white"
                text: "Precip: " + precipIntensity
            }

            spacing: 2

        }

        Column {

            DarkSkyIcon {
                width: 60
                height: 60
                state: icon
                iconColor: root.iconColor
            }

            Text {
                color: "white"
                text: Qt.formatDateTime(time, "ddd h:mm ap")
            }

        }

        spacing: 2
    }
}
