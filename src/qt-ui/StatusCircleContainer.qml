import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.3

ColumnLayout
{
    height: parent.height
    property bool leftOriented: false
    property int model: 5

    Repeater
    {
        model: parent.model
        Item
        {
            height: 40

            /*
            Rectangle
            {
                width: 40
                height: 40
                color: "#666666"
            }*/

            Loader
            {
                visible: false
                id: loader1
                // this does boot the app a little faster, but the rpi loads each circle super slow
                // still - I bet used less granularly async will be helpful (a whole panel of circles
                // instead of 1)
                //asynchronous: true
                source: "StatusCircle.qml"
                width: 40
                height: 40
                onLoaded:
                {
                    item.leftOriented = leftOriented;
                    visible = true;
                }
            }
        }
    }
}
