import QtQuick 2.0
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

    Text {
        x: 200
        color: "white"
        id: name
        text: qsTr("text")
    }

    Binding {
        target: name
        property: 'text'
        value: w1.temperature
    }
}
