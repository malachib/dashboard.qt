import QtQuick 2.0
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.0
import QtQuick.Window 2.2

import QtLocation 5.3
import QtPositioning 5.0

import QtGraphicalEffects 1.0

import "qml/shader"
import "."

//import "qml/config"

//import QtMultimedia 5.0 // get 'image not found'

import WeatherCategory 1.0

Rectangle {
    anchors.fill: parent
    color: 'transparent'
    id: root
    property string primary_location: "Alhambra, CA"

    signal toggleFullScreen()

    FontLoader {
        id: fontRez; source: "fonts/REZ.ttf"
    }

    // focus: true needed for keys.onPressed.  Hopefully it doesnt mess anything up
    focus: true
    Keys.onPressed: {
        switch(event.key)
        {
            case Qt.Key_F11:
                toggleFullScreen()

            case Qt.Key_Q:
                quit();
        }
    }

    TabbedRect {
        anchors.fill: parent
    }

    Geocoder {
        id: geocoder
        name: primary_location
        onGeocodeUpdated: darksky.refresh(loc.latitude, loc.longitude);
    }

    Timer {
        interval: 1000 * 60 * 60 // once every hour
        running: true
        repeat: true
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
            // just to make top left hang off the edge a bit, since most icons are whitespace in that
            // area
            transform: Translate {
                x: -50
                y: -50
            }

            width: 300
            height: 300
            state: darksky.currently.icon
            iconColor: Style.iconColor
            id: icon
        }

        Column {
            transform: [
                Translate {
                    x: -20
                },

                Scale {
                    xScale: 2.2
                    yScale: 2.2
                }
            ]

            Text { color: "white"; text: darksky.currently.temperature + "\xB0 F" }

            Text
            {
                color: "white"; text: geocoder.name
            }

            Rectangle {
                color: Style.iconColor
                opacity: 0.3
                width: 1
                height: 20
            }

            Text
            {
                font.pointSize: 30
                font.family: fontRez.name
                color: "white";
                //color: Style.iconColor
                opacity: 0.8
                text: darksky.currently.summary
            }
        }

        // FIX: ugly space buffer but it will do
        Rectangle {
            id: spacer
            color: 'transparent'
            width: 200
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
            pointsize: 120
        }
    }

    Row {
        y: 100
        x: 200

        Loader {
            width: 400
            height: 100
            id: weatherChart
            objectName: "WeatherChart"
            //source: 'WeatherChart.qml'
        }

        /*
        WeatherChart {
            width: 400
            height: 100
            model: darksky.hourly.data
        }

        Text {
            color: 'white'
            text: 'here I am'
        } */
    }

    // where we draw the main hourly thingy
    Item {
        id: _hourly_tabrect
        anchors.right: parent.right
        anchors.margins: 10
        anchors.left: parent.left
        y: 220
        height: 180

        OpacityMask {
            source: _hourly
            maskSource: hourly_mask
            anchors.fill: parent
        }

        // do this to clip the corners
        TabbedRect {
            id: hourly_mask
            visible: false
            anchors.fill: parent
            color: 'transparent' // mask only the inside
            fill: 'blue'
        }

        TabbedRect {
            anchors.fill: parent
            id: hourly_tabrect
            visible: true
        }


        ZoomBlur {
            scale: 0.9
            anchors.fill: parent
            source: _hourly
            id: __hourly
            length: 9
            opacity: 0.2
            samples: 16
            transparentBorder: true
        }

        ZoomBlur {
            scale: 0.8
            anchors.fill: parent
            source: __hourly
            id: ___hourly
            length: 9
            opacity: 0.05
            samples: 16
            transparentBorder: true
        }

        Item {
            anchors.fill: parent
            id: _hourly
            // NOTE: This was set to false for some reason.  Diagnostics?  on debian-dev, it clearly
            // looks proper with this = true
            visible: true

            Hourly {
                id: hourly
                anchors.margins: 10
                anchors.fill: parent
                model: darksky.hourly.data
                iconColor: Style.iconColor

                itemWidth: 160
                iconSize: 110

                clip: true
                opacity: 0.9
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
                interval: 6000
                repeat: true
                running: true
                onTriggered: {
                    if(hourly.currentIndex === hourly.count - 1)
                    {
                        console.log('got here')
                        stop();
                        var v = hourly.highlightMoveVelocity;
                        hourly.highlightMoveVelocity = 150;
                        hourly.currentIndex = 0
                        hourly.highlightMoveVelocity = v;
                        start();
                    }
                    else
                        hourly.incrementCurrentIndex()
                }
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
        anchors.top: _hourly_tabrect.bottom
        anchors.bottom: parent.bottom

        ListView {
            model: additional_regions
            anchors.fill: parent
            opacity: 0.8

            // per-hourly-batch item
            delegate: Item {
                height: 100
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
                        //anchors.bottom: parent.bottom
                        // FIX: Don't think this AlignBottom is a good substitute for the above anchors
                        Layout.alignment: Qt.AlignBottom

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
                        iconSize: 40
                        itemWidth: 120
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

    // to link back to python code
    signal quit()

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
            root.quit()
        }
    }
}
