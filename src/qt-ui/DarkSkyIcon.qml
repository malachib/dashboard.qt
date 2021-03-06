import QtQuick 2.3
import QtGraphicalEffects 1.0

Rectangle {
    id: root
    color: 'transparent'
    property color iconColor: "blue"
    property real scale_exp: 1

    //. ensure that scale happens around icon center
    transform: Translate {
        x: (width - (width * scale_exp)) / 2
        y: (height - (height * scale_exp)) / 2
    }


    Image {
        // presample at a reasonably high res
        // FIX: Don't assume a square icon
        sourceSize.width: 1024
        sourceSize.height: 1024

        fillMode: Image.PreserveAspectCrop

        //anchors.fill: parent
        width: parent.width * scale_exp
        height: parent.height * scale_exp

        mipmap: true
        id: image
        visible: false // going through a transform pipeline so don't render here
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

    // change color of it
    ColorOverlay {
        id: overlay
        anchors.fill: image
        source: image
        color: iconColor
        visible: true
    }

    /*
    // now resize it with the mipmap smoothing
    // https://stackoverflow.com/questions/23286666/qml-image-smooth-property-not-working
    ShaderEffectSource {
        id: src
        sourceItem: overlay
        mipmap: true
    }

    ShaderEffect {
        anchors.fill: parent

        clip: true

        scale: 1.3
        property var source: src
    } */
}
