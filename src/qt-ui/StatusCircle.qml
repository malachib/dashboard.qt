import QtQuick 2.0

Rectangle
{
    color: "transparent"
    /*
    //width: parent.width<parent.height?parent.width:parent.height
    //height: width
    color: "lightgreen"
    border.color: "green"
    border.width: 1
    radius: width*0.5 */
    Text {
        id: textArea
        //anchor.fill: parent
        x: width + 1
        y: height / 2
        color: "white"
        text: "STAT"
        font.family: "Andale Mono"
        //verticalAlignment: Text.AlignVCenter
    }

    property real startCircumference;
    property real endCircumference;

    Behavior on startCircumference
    {
        SmoothedAnimation { velocity: 5; duration: 1000 }
    }

    // TODO: exempt text from being rotated
    NumberAnimation on rotation {
      from: 0;
      to: 360;
      loops: Animation.Infinite;
      duration: 2000
    }

    Timer
    {
        interval: 1000;
        running: true;
        repeat: true;
        onTriggered:
        {
            startCircumference = Math.random() * (Math.PI * 2);
            //endCircumference = Math.random() * (Math.PI - startCircumference);
            //endCircumference += startCircumference;
            //textArea.text = Date().toString();
            //textArea.text = qsTr("" + startCircumference);
            //canvas.requestPaint();
        }
    }
    // FIX: doing timer like this probably grossly inefficient
    Timer
    {
        interval: 50;
        running: true;
        repeat: true;
        onTriggered:
        {
            // FIX: if we are gonna do this, only trigger the timer
            // when property actually changes
            canvas.requestPaint();
        }
    }

    // inner circle to make outer wedge look more like a small chunk
    Rectangle
    {
        z: 1
        color: "red"
        x: parent.width / 8
        y: parent.height / 8
        width: parent.width / (8/6)
        height: parent.height / (8/6)
        radius: width*0.5
    }

    Canvas
    {
        id: canvas
        anchors.fill: parent
        onPaint:
        {
            var ctx = getContext("2d");
            var radius = width / 2;
            //startCircumference = Math.PI * 0.5;
            endCircumference = Math.PI * 2;
            ctx.reset();

            //ctx.fillStyle = "rgba(255,255,255,0.5)";
            //ctx.globalAlpha = 0.5;
            //ctx.globalAlpha = 1;

            var centreX = width / 2;
            var centreY = height / 2;

            ctx.beginPath();
            ctx.fillStyle = "transparent";
            ctx.moveTo(centreX, centreY);
            ctx.arc(centreX, centreY, radius, 0, startCircumference, false);
            ctx.lineTo(centreX, centreY);
            ctx.fill();

            ctx.beginPath();
            ctx.fillStyle = "rgba(255,50,50,1)";
            ctx.moveTo(centreX, centreY);
            ctx.arc(centreX, centreY, radius, startCircumference, endCircumference, false);
            ctx.lineTo(centreX, centreY);
            ctx.fill();
        }
    }

}
