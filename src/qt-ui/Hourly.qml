import QtQuick 2.0
import QtQuick.Layouts 1.1

ListView {
    id: root
    orientation: ListView.Horizontal
    layoutDirection: Qt.LeftToRight
    property color iconColor: "blue"
    property real iconSize: 60
    property bool showSummary: true
    property int itemWidth: 150

    delegate: Rectangle
    {
        color: 'transparent'
        width: itemWidth
        height: parent.height
        //anchors.margins: 10
        border.color: '#002000'
        border.width: 0.5

        Row {
            //anchors.bottom: parent.bottom
            // trying to get text_summary to 'horizontally center' within its rotated scope
            height: parent.height

            Item {
                width: text_summary.width
                height: text_summary.height
                visible: showSummary

                anchors.bottom: parent.bottom
                anchors.margins: 10
            Text {
                id: text_summary
                width: 30
                //anchors.bottom: parent.bottom
                //horizontalAlignment: Text.AlignHCenter
                rotation: -90
                color: "white"
                text: summary
            }
            }

            Column {

                Text {
                    color: "white"
                    text: temperature + "\xB0 F"
                }

                Text {
                    color: "white"
                    text: "Precip: " + precipIntensity
                }

                Column {
                    DarkSkyIcon {
                        width: iconSize
                        height: iconSize
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
