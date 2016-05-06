import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.3

ApplicationWindow {
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
            MenuItem {
                text: qsTr("Exit")
                onTriggered: Qt.quit();
            }
        }
    }

    MainForm {
        anchors.fill: parent
        button1.onClicked: messageDialog.show(qsTr("Button 1 pressed"))
        button2.onClicked: messageDialog.show(qsTr("Button 2 pressed"))
    }

    MessageDialog {
        id: messageDialog
        title: qsTr("May I have your attention, please?")

        function show(caption) {
            messageDialog.text = caption;
            messageDialog.open();
        }
    }

    ColumnLayout
    {
        //width: 30
        height: parent.height
        //spacing: 6

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
        }
    }
}
