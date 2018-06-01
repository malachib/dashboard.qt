import QtQuick 2.0
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.0

import QtLocation 5.3
import QtPositioning 5.0

import "qml/shader"

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

    Timer {
        interval: 1000 * 60 * 60 // once every hour
        running: true
        onTriggered: darksky.refresh(geocoder.loc.latitude, geocoder.loc.longitude)
    }


    Weather {
        id: darksky
    }

    /*
      fiddling with his source code, but not there yet
    ApplicationSettings {
        id: appSettings
    }

    ShaderTerminal {
        //property alias title: terminal.title
        id: mainShader
        //dispX: (12 / width) * appSettings.windowScaling
        //dispY: (12 / height) * appSettings.windowScaling
        anchors.right: parent.right
        width: 200
        height: 100
        y: 100
        source: current_disp
        blurredSource: current_disp

        Loader{
                id: frame
                anchors.fill: parent

                property real displacementLeft: item ? item.displacementLeft : 0
                property real displacementTop: item ? item.displacementTop : 0
                property real displacementRight: item ? item.displacementRight : 0
                property real displacementBottom: item ? item.displacementBottom : 0

                asynchronous: true
                visible: status === Loader.Ready

                z: 2.1
                source: appSettings.frameSource
            }
    }

    Rectangle {
        id: terminalWindow // EXPERIMENTAL: to satisfy ShaderTerminal
        anchors.right: parent.right
        width: 200
        height: 100

        Rectangle {
            anchors.fill: parent
        }
    }

    */

    Text {
        id: last_updated
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 10
        opacity: 0.2
        color: "white"
        text: Qt.formatDateTime(darksky.currently.time, "h:mm ap")
    }

    GridLayout {
        rows: 3
    }

    // 'current' big display
    Row {
        id: current_disp

        DarkSkyIcon {
            width: 200
            height: 200
            state: darksky.currently.icon
            iconColor: "blue"
        }

        Column {
            transform: Scale {
                origin.x: 0
                origin.y: 0
                xScale: 1.5
                yScale: 1.5
            }

            Text { color: "white"; text: darksky.currently.temperature + "\xB0 F" }
            Text { color: "white"; text: darksky.currently.summary }
            Text { color: "white"; text: geocoder.name }
        }

        // FIX: ugly space buffer but it will do
        Rectangle {
            id: spacer
            color: 'transparent'
            width: 100
            height: 1
        }

        /*
        Text {
            text: "00:00"
            color: '#30C030'
            font.pointSize: 80
        } */

        Timer {
            interval: 1000
            running: true
            repeat: true
            onTriggered: {
                var date = new Date();

                clock.hours = date.getHours();
                clock.minutes = date.getMinutes();
                clock.show_colons = !clock.show_colons;
            }
        }

        // Shouldn't have to do anchor but for some reason we do
        // clock face now looks right but still not animated or populated
        DigitalClockFace {
            id: clock
            is_24_hour: false
            anchors.left: spacer.right
            color: '#30C030'
            pointsize: 80
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
            anchors.fill: parent
            model: darksky.hourly.data
            iconColor: "#00A010"
            clip: true
            opacity: 0.8
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


    ListModel {
        id: additional_regions
        ListElement { name: "Thida's"; location: "Cypress, CA" }
    }


    TabbedRect {
        anchors.right: parent.right
        anchors.margins: 10
        anchors.left: parent.left
        anchors.top: hourly_tabrect.bottom
        anchors.bottom: parent.bottom

        ListView {
            model: additional_regions
            anchors.fill: parent
            opacity: 0.8

            // per-hourly-batch item
            delegate: Item {
                height: 75
                width: parent.width

                Geocoder {
                    id: geocoder_aux
                    name: location
                    onGeocodeUpdated: darksky_aux.refresh(loc.latitude, loc.longitude);
                }

                Weather { id: darksky_aux }

                RowLayout {
                    anchors.fill: parent

                    Item {
                        //width: text_summary.width
                        //height: parent.height
                        //color: 'blue'
                        Layout.minimumWidth:  text_summary.width
                        Layout.minimumHeight: 20
                        Layout.maximumHeight: parent.height
                        //Layout.fillWidth: true
                        anchors.bottom: parent.bottom

                        Text {
                            id: text_summary
                            width: 30
                            //anchors.bottom: parent.bottom
                            //horizontalAlignment: Text.AlignHCenter
                            rotation: -90
                            color: "white"
                            text: name
                        }

                    }

                    Hourly {
                        showSummary: false
                        model: darksky_aux.hourly.data
                        iconSize: 30
                        itemWidth: 100
                        iconColor: "#00A010"
                        //anchors.fill: parent
                        Layout.fillWidth: true
                        Layout.minimumHeight: 20
                        Layout.preferredHeight: parent.height

                        //clip: true
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
        text: "Config"
        onClicked: {
            // TODO: Once I figure how to do a popup or something similar, set up a config area
            var c = Qt.createComponent("qml/config/Geocode.qml")
            //var window = c.createObject(c)

            //window.show()
        }
    }
}
