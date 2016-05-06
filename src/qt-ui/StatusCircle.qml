import QtQuick 2.0

Rectangle {
    //width: parent.width<parent.height?parent.width:parent.height
    //height: width
    color: "lightgreen"
    border.color: "green"
    border.width: 1
    radius: width*0.5
    Text {
        //anchor.fill: parent
        x: width + 1
        y: height / 2
        color: "white"
        text: "STAT"
        font.family: "Andale Mono"
        //verticalAlignment: Text.AlignVCenter
    }
}
