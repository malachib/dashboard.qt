import QtQuick 2.0
import QtQuick.Controls 2.2
//import QtMultimedia 5.0 // get 'image not found'
import WeatherCategory 1.0

Rectangle {
    anchors.fill: parent
    color: 'transparent'

    TabbedRect {
        anchors.fill: parent
    }

    Weather {
        id: darksky
    }

    Timer {
        interval: 1000 * 60 * 60; // 1 hour
        running: true;
        repeat: true
        triggeredOnStart: true
        onTriggered: darksky.refresh(-31.967819, 115.87718)
    }

    Text {
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 10
        opacity: 0.2
        color: "white"
        text: Qt.formatDateTime(darksky.currently.time, "h:mm ap")
    }

    /*
    Video {
        id: video
        width : 800
        height : 600
        source: "images/bg.mov"
    } */

    DarkSkyIcon {
        width: 200
        height: 200
        state: darksky.currently.icon
        iconColor: "blue"
    }


    TabbedRect {
        color: 'transparent'
        anchors.right: parent.right
        anchors.margins: 10
        anchors.left: parent.left
        //x: 50
        y: 200
        height: 220
        Hourly {
            id: hourly
            anchors.margins: 30
            model: darksky.hourly.data
            iconColor: "#00A010"
            clip: true
        }

        Timer {
            interval: 5000
            repeat: true
            running: true
            onTriggered: {
                if(hourly.currentIndex == hourly.count - 1)
                    hourly.currentIndex = 0
                hourly.incrementCurrentIndex()
            }
        }
    }

}
