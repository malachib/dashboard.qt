import QtQuick 2.0
import QtQuick.Layouts 1.1

ListView {
    id: root
    anchors.fill: parent
    orientation: ListView.Horizontal
    layoutDirection: Qt.LeftToRight
    property color iconColor: "blue"

    delegate: Rectangle
    {
        color: 'transparent'
        width: 150
        height: parent.height
        //anchors.margins: 10
        border.color: '#002000'
        border.width: 0.5
        opacity: 0.8

        Row {
            //anchors.bottom: parent.bottom
            height: parent.height

            Text {
                width: 30
                //height: 30
                anchors.bottom: parent.bottom
                anchors.margins: 10
                rotation: -90
                color: "white"
                text: summary
            }

            Column {

                Text {
                    color: "white"
                    text: "    " + temperature + "\xB0 F"
                }

                Text {
                    color: "white"
                    text: "Precip: " + precipIntensity
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
            }
        }
    }
}
