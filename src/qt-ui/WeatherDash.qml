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
        onGeocodeUpdated: darksky.refresh(loc.latitude, loc.longitude);
    }

    Weather {
        id: darksky
    }

    ListModel {
        id: additional_regions
        ListElement {
            name: "Thida's"
            location: "Cypress, CA"
        }
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
            Text { color: "white"; text: geocoder.name }
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
        y: 190
        height: 170
        id: hourly_tabrect

        Hourly {
            id: hourly
            anchors.margins: 10
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

    TabbedRect {
        anchors.right: parent.right
        anchors.margins: 10
        anchors.left: parent.left
        anchors.top: hourly_tabrect.bottom
        anchors.bottom: parent.bottom

        ListView {
            id: lst_additional_regions
            model: additional_regions
            width: parent.width
            height: parent.height

            delegate: Item {
                height: 50
                width: parent.width

                //Text { color: 'white'; text: location }
                Column {
                    Geocoder {
                        id: geocoder_aux
                        name: location
                        onGeocodeUpdated: darksky_aux.refresh(loc.latitude, loc.longitude);
                    }

                    Weather {
                        id: darksky_aux
                        onForecastUpdated:
                        {
                            console.log('got here: ' + darksky_aux.hourly.data.length)
                        }
                    }


                    /*
                    Hourly {
                        id: hourly_aux
                        height: parent.height
                        width: lst_additional_regions.width
                        model: darksky_aux.hourly.data
                        iconSize: 30
                        iconColor: "#00A010"
                        //clip: true
                    } */
                    ListView {
                        id: fake_hourly
                        anchors.fill: parent
                        model: darksky_aux.hourly.data
                        orientation: ListView.Horizontal
                        layoutDirection: Qt.LeftToRight

                        // TODO: I still have something to learn about ListView layout
                        delegate: Component {
                            Item {
                                //width: 50
                                Text { color: 'white'; text: time }
                            }
                        }
                    }
                }
            }
        }

    }

    Button {
        anchors.right: last_updated.left
        anchors.bottom: parent.bottom
        width: 100
        opacity: 0.05
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
