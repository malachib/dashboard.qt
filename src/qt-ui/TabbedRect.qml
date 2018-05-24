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
            var indent = 40;
            // setup the stroke
            ctx.lineWidth = 1
            ctx.strokeStyle = "#009b00"
            // setup the fill (transparent)
            // https://forum.qt.io/topic/51084/canvas-2d-fill-color-by-rgba-string/2
            ctx.fillStyle = "rgba(0, 20, 0, 0.3)"
            // begin a new path to draw
            ctx.beginPath()
            // top-left start point
            ctx.moveTo(0,indent)
            // left angle one line
            ctx.lineTo(indent, 0)
            // upper line
            ctx.lineTo(width,0)
            // right line
            ctx.lineTo(width,height)
            // bottom line
            ctx.lineTo(0,height)
            // left line through path closing
            ctx.closePath()
            // fill using fill style
            ctx.fill()
            // stroke using line width and stroke style
            ctx.stroke()
        }
    }
}
