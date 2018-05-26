import QtQuick 2.2
import QtGraphicalEffects 1.0
import WeatherCategory 1.0

// python-invoked test
Rectangle {
    id: pytest
    color: 'black'

    Weather {
        id: w1
    }

    Timer {
        interval: 2000;
        running: true;
        repeat: true
        onTriggered: w1.refresh(-31.967819, 115.87718)
    }


    StatusCircleContainer
    {
        x: 30
        model: 4
        leftOriented: true
    }

    TabbedRect {
        x: 30
        width: 300
        height: 200
    }

    Image {
        id: therm
        fillMode: Image.PreserveAspectFit
        width: 70
        x: 200
        antialiasing: true
        source: "images/thermometer-outlined-symbol-of-stroke.svg"
        visible: false
    }

    ColorOverlay{
            anchors.fill: therm
            source:therm
            color:"blue"
            //transform:rotation
            antialiasing: true
    }

    Component {
        // translates from darksky to our own weather icon
        id: weatherIcon

        Item {
            Image {
                id: image
            }

            // stuff in datapoint.icon into here
            states: [
                State {
                    name: "rain"
                    PropertyChanges {
                        target: image
                        source: "images/weather-iconic/raindrop.svg"
                    }
                },
                State {
                    name: "clear-day"
                    PropertyChanges {
                        target: image
                        source: "images/weather-iconic/sun.svg"
                    }
                },
                State {
                    name: "wind"
                    PropertyChanges {
                        target: image
                        source: "images/weather-iconic/wind.svg"
                    }
                },
                State {
                    name: "cloudy"
                    PropertyChanges {
                        target: image
                        source: "images/weather-iconic/clouds.svg"
                    }
                },
                State {
                    name: "partly-cloudy-day"
                    PropertyChanges {
                        target: image
                        source: "images/weather-iconic/sun-cloud.svg"
                    }
                },
                State {
                    name: "partly-cloudy-night"
                    PropertyChanges {
                        target: image
                        source: "images/weather-iconic/moon-cloud.svg"
                    }
                },
                State {
                    name: "clear-night"
                    PropertyChanges {
                        target: image
                        source: "images/weather-iconic/moon.svg"
                    }
                }

            ]

            ColorOverlay {
                anchors.fill: image
                source: image
                color:"blue"
                //transform:rotation
                antialiasing: true
            }
        }
    }

    Rectangle {
        color: 'transparent'
        x: 200
        y: 200
        width: 300
        height: 200

        Row {
            anchors.fill: parent
            id : mainContainer

            ListView {
                id: hourly_view
                anchors.fill: parent
                model: w1.hourly.data


                delegate: Row
                {
                    Text {
                        color: "white"
                        text: summary
                    }
                    Text {
                        color: "white"
                        text: time
                    }
                    Text {
                        color: "white"
                        text: temperature
                    }

                    Loader {
                        sourceComponent: weatherIcon
                        // thanks to https://stackoverflow.com/questions/33536881/set-loader-item-property
                        onLoaded: item.state = icon
                    }

                    spacing: 2
                }

                spacing: 2
            }

        }

    }

    AnimatedImage {
        id: anim
        source: "images/anim01.svg"
        x: 200
        y: 100
    }

    Rectangle {
        property int frames: anim.frameCount

        width: 4; height: 8
        x: (anim.width - width) * anim.currentFrame / frames
        y: anim.height
        color: "red"
    }

    Text {
        x: 200
        color: "white"
        id: name
        text: qsTr("text")
    }

    Text {
        x: 200
        y: 50
        color: "white"
        id: current_temp
        //text: qsTr("text")
        //text: w1.current_summary
        text: w1.current.summary
    }

    Binding {
        target: name
        property: 'text'
        value: w1.temperature
    }

    /*

    Binding {
        id: b_current
        value: w1.current
    }

    Binding {
        id: b1
        target: current_temp
        property: 'text'
        value: w1.current.summary
    } */
}
