import QtQuick 2.0
import QtGraphicalEffects 1.0

Rectangle {
    color: 'transparent'
    Image {
        // FIX: nasty pixellation on these SVG's, what the hell...
        // looks like it's presampled... ugh , here's a hack I don't
        // fully understand though https://stackoverflow.com/questions/37976644/how-to-make-svg-icons-crisp-again-in-qt-5-6-on-high-dpi-screens
        anchors.fill: parent
        sourceSize.width: 1024
        sourceSize.height: 1024
        antialiasing: true
        id: image
        //fillMode: Image.PreserveAspectFit
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
