import QtQuick 2.0
import WeatherCategory 1.0

Rectangle {

    Weather {
        id: w1
    }

    DarkSkyIcon {
        width: 200
        height: 200
        state: w1.currently.icon
        iconColor: "blue"
    }


    Rectangle {
        color: 'transparent'
        x: 50
        y: 200
        height: 200
        width: 600
        Hourly {
            model: w1.hourly.data
            iconColor: "#00A010"
        }
    }

}
