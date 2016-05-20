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

            Loader
            {
                visible: false
                id: loader1
                asynchronous: true
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
