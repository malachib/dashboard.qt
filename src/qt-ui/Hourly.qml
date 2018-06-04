import QtQuick 2.0
import QtQuick.Layouts 1.1
import QtGraphicalEffects 1.0

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

            /*
            Rectangle {
                height: parent.height
                width: 1
                color: 'green'
            } */

            Item {
                //anchors.bottom: parent.bottom

                //width:text_summary_rect.height
                clip: true
                width: text_summary.height
                height: parent.height
                visible: showSummary

                Rectangle {
                    id: text_summary_rect
                    //width: parent.height
                    width: text_summary.width
                    height: text_summary.height
                    color: 'transparent'
                    //opacity: 0.5
                    /* Cheezy way to account for bottomLeft rotation instead of topLeft,
                     * because it ends up putting the text on the wrong (left) side instead of the
                     * right.  Trouble is, if we use TopLeft rotation, a mysterious margin shows
                     * up below the resulting text.  So either way we have to adjust */
                    anchors.leftMargin: height

                    transformOrigin: Item.BottomLeft

                    rotation: -90

                    //anchors.margins: 10

                    anchors.left: parent.left
                    anchors.bottom: parent.bottom

                    Text {
                        //transformOrigin: Item.TopLeft

                        id: text_summary
                        //width: 30
                        //anchors.bottom: parent.bottom
                        //horizontalAlignment: Text.AlignHCenter
                        //rotation: -90
                        color: "white"
                        text: summary
                    }
                }
            }

            Column {
                id: detail

                /*
                Text {
                    color: "white"
                    text: "Precip: " + precipIntensity
                } */

                Row {

                    Column {
                        Text {
                            color: "white"
                            text: temperature.toFixed(1) + "\xB0 F"
                        }

                        DarkSkyIcon {
                            width: iconSize
                            height: iconSize
                            state: icon
                            iconColor: root.iconColor
                        }
                    }

                    LinearGradient {
                        //anchors.fill: parent
                        width: 10
                        anchors.bottom: parent.bottom
                        height: {
                            var ceiling = 7.5; // 7.5 represents entry into 'heavy rain' category, and where we top
                            var h = Math.min(ceiling, precipIntensity) * parent.height / ceiling;
                            return h;
                        }
                        start: Qt.point(0, height - parent.height)
                        end: Qt.point(0, height)
                        gradient: Gradient {
                            GradientStop { position: 0.0; color: "blue" }
                            GradientStop { position: 1.0; color: "white" }
                        }
                    }

                    spacing: 2
                }

                Text {
                    id: _time
                    color: "white"
                    text: Qt.formatDateTime(time, "ddd h:mm ap")
                }
            }

            spacing: 1
        }
    }
}
