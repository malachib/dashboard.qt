import QtQuick 2.0

// python-invoked test
Rectangle {
    id: pytest
    color: 'black'

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
}
