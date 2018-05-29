import QtQuick 2.0

import "file.js" as JS // polyfill for padStart() // TODO: rename it

Rectangle {
    id: root
    //color: 'transparent'

    property int hours
    property int minutes
    property int seconds
    property bool is_24_hour: false
    property bool show_seconds: false
    property bool show_colons: true
    property color color
    property real pointsize: 1

    FontLoader {
        id: clockFont; source: "fonts/digital_counter_7_italic.ttf"
    }

    Row {
        Text {
            font.family: clockFont.name
            font.pointSize: pointsize
            color: 'black'
            text: '.00:00'
        }
    }

    Row {
        // Zeee dot
        Text {
            id: ampm
            text: '.'
            font.family: clockFont.name
            font.pointSize: pointsize
            visible: !is_24_hour
            color: hours >= 12 ? root.color : "transparent"
        }

        Text {
            id: _hours
            text: {
                var __hours = hours
                if(!is_24_hour && __hours > 12)
                    __hours -= 12;

                var s = "" + __hours;

                return s.padStart(2);
            }
            font.family: clockFont.name
            font.pointSize: pointsize
            color: root.color
        }

        Text {
            id: sep1
            text: ':'
            font.family: clockFont.name
            font.pointSize: pointsize
            color: show_colons ? root.color : 'transparent'
        }

        Text {
            id: _minutes
            text: {
                var s = "" + minutes;

                return s.padStart(2, '0');
            }
            font.family: clockFont.name
            font.pointSize: pointsize
            color: root.color
        }

        Text {
            id: sep2
            text: ':'
            color: show_colons ? root.color : 'transparent'
            font.family: clockFont.name
            font.pointSize: pointsize
            visible: show_seconds
        }

        Text {
            id: _seconds
            text: seconds
            visible: show_seconds
            font.family: clockFont.name
            font.pointSize: pointsize
            color: root.color
        }
    }
}
