import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.3
import QtQuick.Window 2.0

ApplicationWindow {
    id: root
    visible: true
    width: 640
    height: 480
    color: "#222222"
    title: qsTr("Hello World")

    menuBar: MenuBar {
        Menu {
            title: qsTr("File")
            MenuItem {
                text: qsTr("&Open")
                onTriggered: console.log("Open action triggered");
            }
            MenuSeparator {}

            MenuItem {
                text: qsTr("Nifty")
                onTriggered:
                {
                    // https://stackoverflow.com/questions/8327894/how-can-i-create-a-new-window-from-within-qml
                    // neat but I want actually a popup.  This does more of an overlay.  cool, but not
                    // what I need
                    var component = Qt.createComponent("py-test.qml");
                    var window = component.createObject(root)

                    // this doesn't do what I expected
                    //window.show()
                }
            }

            MenuItem {
                text: qsTr("Nifty 2")
                onTriggered: winld.active = true
            }

            MenuItem {
                text: qsTr("Exit")
                onTriggered: Qt.quit();
            }
        }

        Menu {
            title: qsTr("Edit")
            MenuItem {
                text: qsTr("TEST")
            }
            MenuItem {
                text: qsTr("TEST2")
            }
        }
    }

    Loader {
        id: winld
        active: false
        sourceComponent: Window {
            width: 300
            height: 300
            //color: 'green'
            color: '#002000'
            visible: true
            //onClosing: winld.active = false
            PyTest {

            }
        }
    }

    MainForm {
        anchors.fill: parent
        button1.onClicked:
        {
            leftTriumverate.state = "on";
            //messageDialog.show(qsTr("Button 1 pressed"))
            //leftTriumverate.state = "off";
        }
        button2.onClicked:
        {
            leftTriumverate.state = "off";
            //messageDialog.show(qsTr("Button 2 pressed"))
        }
    }

    MessageDialog {
        id: messageDialog
        title: qsTr("May I have your attention, please?")

        function show(caption) {
            messageDialog.text = caption;
            messageDialog.open();
        }
    }


    StatusCircleContainer
    {
        // bringing in from edges because of my goofy TV
        x: parent.width - 100
        leftOriented: false
    }

    StatusCircleContainer
    {
        x: 60
        model: 4
        leftOriented: true
    }

    ColumnLayout
    {
        //width: 30
        // FIX: temporarily bringing in from edges because of my goofy TV
        x: 60
        //height: parent.height - 100
        //spacing: 6

        Rectangle
        {
            id: leftTriumverate
            transitions: Transition {
                NumberAnimation
                {
                    properties: "x,y";
                    easing.type: Easing.InOutQuad;
                    duration: 200
                }
            }

            states:
            [
                State
                {
                    name: "on"
                    PropertyChanges {
                        target: c1
                        x: 10
                        y: -10
                    }
                    PropertyChanges {
                        target: c2
                        x: 20
                    }
                    PropertyChanges {
                        target: c3
                        x: 10
                        y: 10
                    }
                },
                State
                {
                    name: "off"
                    //PropertyChanges {
                    //    target: c1
                    //    x: 0
                    //}
                }

            ]

            StatusCircle
            {
                id: c1
                width: 20
                height: 20
            }
            StatusCircle
            {
                id: c2
                width: 20
                height: 20
            }
            StatusCircle
            {
                id: c3
                //x: 5
                width: 20
                height: 20
            }
        }

        //StatusCircle
        /*
        StatusCircle
        {
            id: s1
            Layout.preferredWidth: 40
            Layout.preferredHeight: 40
        }
        StatusCircle
        {
            id: s2
            Layout.preferredWidth: 40
            Layout.preferredHeight: 40
        }
        StatusCircle
        {
            id: s3
            Layout.preferredWidth: 40
            Layout.preferredHeight: 40
        }
        Rectangle
        {
            color: "orange"
            Layout.preferredWidth: 40
            Layout.preferredHeight: 40
        } */
    }
}
