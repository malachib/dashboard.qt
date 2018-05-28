import QtQuick 2.0

Item {
    id: root

    property int hours
    property int minutes
    property int seconds
    property bool seconds_visible: false
    property color color
    property real pointsize: 1

    Row {
        Text {
            id: _hours
            text: hours
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
            text: minutes
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
    }
}
