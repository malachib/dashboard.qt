import QtQuick 2.0

Rectangle
{
    //color: 'yellow'
    color: 'transparent'

    // lifted from https://forum.qt.io/topic/63664/how-to-draw-a-polygon-with-qml/7
    Canvas {
        id: tabrect_root
        width: parent.width
        height: parent.height
        onPaint: {
            // get context to draw with
            var ctx = getContext("2d")
            // setup the stroke
            ctx.lineWidth = 4
            ctx.strokeStyle = "#009b00"
            // setup the fill
            ctx.fillStyle = "#004b00"
            // begin a new path to draw
            ctx.beginPath()
            // top-left start point
            ctx.moveTo(50,50)
            // upper line
            ctx.lineTo(150,50)
            // right line
            ctx.lineTo(150,150)
            // bottom line
            ctx.lineTo(50,150)
            // left line through path closing
            ctx.closePath()
            // fill using fill style
            ctx.fill()
            // stroke using line width and stroke style
            ctx.stroke()
        }
    }
}
