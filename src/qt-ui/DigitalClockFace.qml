import QtQuick 2.0

import "file.js" as JS // polyfill for padStart() // TODO: rename it

Rectangle {
    id: root
    color: 'transparent'

    property int hours
    property int minutes
    property int seconds
    property bool seconds_visible: false
    property bool is_24_hour: false
    property color color
    property real pointsize: 1

    Row {
        Text {
            id: _hours
            text: {
                var s = "" + hours;

                return s.padStart(2);
            }
            font.pointSize: pointsize
            color: root.color
        }

        Text {
            id: sep1
            text: ':'
            font.pointSize: pointsize
            color: root.color
        }

        Text {
            id: _minutes
            text: {
                var s = "" + minutes;

                return s.padStart(2, '0');
            }
            font.pointSize: pointsize
            color: root.color
        }

        Text {
            id: sep2
            text: ':'
            color: root.color
            font.pointSize: pointsize
            visible: seconds_visible
        }

        Text {
            id: _seconds
            text: seconds
            visible: seconds_visible
            font.pointSize: pointsize
            color: root.color
        }

        Text {
            id: ampm
            visible: false
        }
    }
}
