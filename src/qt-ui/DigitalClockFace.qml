import QtQuick 2.0

import "file.js" as JS // polyfill for padStart() // TODO: rename it

Rectangle {
    id: root
    color: 'transparent'

    property int hours
    property int minutes
    property int seconds
    property bool is_24_hour: false
    property bool show_seconds: false
    property bool show_colons: true
    property color color
    property real pointsize: 1

    Row {
        Text {
            id: _hours
            text: {
                if(is_24_hour)
                    ampm.text = hours >= 12 ? "pm" : "am";

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
            color: show_colons ? root.color : 'transparent'
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
            color: show_colons ? root.color : 'transparent'
            font.pointSize: pointsize
            visible: show_seconds
        }

        Text {
            id: _seconds
            text: seconds
            visible: show_seconds
            font.pointSize: pointsize
            color: root.color
        }

        Text {
            id: ampm
            visible: !is_24_hour
        }
    }
}
