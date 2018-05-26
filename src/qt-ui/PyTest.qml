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

    /*
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

                    DarkSkyIcon {
                        state: icon
                        width: 50
                        height: 50
                    }

                    Loader {
                        sourceComponent: DarkSkyIcon
                        // thanks to https://stackoverflow.com/questions/33536881/set-loader-item-property
                        onLoaded: item.state = icon
                    }

                    spacing: 2
                }

                spacing: 2
            }

        }

    } */

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
