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
    property int itemWidth: 130
    // doesn't do justification/alignment nicely, so probably phase this out
    property real scale_exp: 1

    highlightMoveDuration: 6000
    highlightMoveVelocity: 15

    FontLoader {
        id: _font; source: "fonts/REZ.ttf"
    }

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

            // summary, rotated
            Item {
                id: text_summary_item
                //anchors.bottom: parent.bottom

                //width:text_summary_rect.height
                clip: true
                width: text_summary.height
                height: parent.height
                visible: showSummary

                TabbedRect {
                    anchors.fill: parent
                    opacity: 0.5
                    indent: parent.width
                }

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
                        id: text_summary
                        color: "white"
                        text: summary
                    }
                }
            }

            Column {
                id: detail
                anchors.bottom: parent.bottom

                Row {

                    Column {
                        Text {
                            color: root.iconColor;
                            font.pointSize: 15
                            font.family: _font.name
                            opacity: 0.5
                            text: Qt.formatDateTime(time, "ddd").toLowerCase();
                            scale: scale_exp
                        }

                        Text {
                            color: "white"
                            text: temperature.toFixed(1) + "\xB0 F  "
                            scale: scale_exp
                        }

                        DarkSkyIcon {
                            width: iconSize
                            height: iconSize
                            scale_exp: 1.5
                            state: icon
                            iconColor: root.iconColor
                        }
                    }

                    Item {
                        width: 10
                        anchors.bottom: parent.bottom
                        height: parent.height

                        TabbedRect {
                            anchors.fill: parent
                            indent: 10
                            upperLeftIndent: false
                            upperRightIndent: true
                            opacity: 0.15
                        }

                        // precip semi-chart
                        LinearGradient {
                            width: parent.width
                            height: {
                                //var precipIntensity = 7.5; // synthetic test value
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
                    }

                    spacing: 2
                }

                Text {
                    id: _time
                    color: "white"
                    text:
                    {
                        // TODO: Add a version which shows +1, +2 etc. for days ahead of where we are
                        return Qt.formatDateTime(time, "h:mm ap").toLowerCase();
                    }
                    scale: scale_exp
                }
            }

            spacing: 1
        }

        // asthetic top line
        Rectangle {
            width: itemWidth - 30
            x: 15 + (showSummary ? text_summary_item.width : 0)
            height: 2
            border.color: '#002000'
            y: detail.y / 2
        }
    }
}
