import QtQuick 2.0
import QtQuick.Controls 2.2

import QtLocation 5.3
import QtPositioning 5.0

//import "qml/config"

//import QtMultimedia 5.0 // get 'image not found'

import WeatherCategory 1.0

Rectangle {
    anchors.fill: parent
    color: 'transparent'

    TabbedRect {
        anchors.fill: parent
    }

    Geocoder {
        id: geocoder
        name: "Alhambra, CA"
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
        id: last_updated
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

    Plugin {
        id: aPlugin
    }

    // not good embedding these credentials here, but Plugins are so fiddly I want to
    // see things working before investing in one particular one
    // As expected, didn't work right - an OpenSSL version incompatibility
    Plugin {
        id: herePlugin
        name: "here"
        PluginParameter { name: "here.app_id"; value: "NakRhCgD3TQnba9n0h7c" }
        PluginParameter { name: "here.token"; value: "qbR95f74brodOvj02b5_EQ" }
        PluginParameter { name: "here.proxy"; value: "system" }
    }

    GeocodeModel {
        id: geocodeModel
        plugin: herePlugin
        autoUpdate: false
        query: "605 N. Marguerita #3, Alhambra, 91801"
        onLocationsChanged: {
            var result = geocodeModel.get(0)
            console.log("Got here 2") // never called
        }
    }

    // 'current' big display
    Row {
        DarkSkyIcon {
            width: 200
            height: 200
            state: darksky.currently.icon
            iconColor: "blue"
        }

        Column {
            Text { color: "white"; text: darksky.currently.temperature + "\xB0 F" }
            Text { color: "white"; text: darksky.currently.summary }
            Text { color: "white"; text: geocoder.loc.latitude }
        }

        // FIX: ugly space buffer but it will do
        Rectangle {
            color: 'transparent'
            width: 100
            height: 1
        }

        Text {
            text: "00:00"
            color: '#30C030'
            font.pointSize: 80
        }
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

        MouseArea {
            anchors.fill: parent
            onClicked: {
                hourly.incrementCurrentIndex();
                //geocodeModel.update()
                //console.log("Geocodemodel online: " + aPlugin.supportsGeocoding(Plugin.AnyGeocodingFeatures))
            }
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

    Button {
        anchors.right: last_updated.left
        anchors.bottom: parent.bottom
        width: 100
        opacity: 0.2
        rightPadding: 200
        text: "Hi"
        onClicked: {
            // TODO: Once I figure how to do a popup or something similar, set up a config area
            var c = Qt.createComponent("qml/config/Geocode.qml")
            //var window = c.createObject(c)

            //window.show()
        }
    }
}
