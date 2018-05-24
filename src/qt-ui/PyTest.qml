import QtQuick 2.0

// python-invoked test
Rectangle {
    id: pytest

    StatusCircleContainer
    {
        x: 30
        model: 4
        leftOriented: true
    }

    TabbedRect {
        x: 30
        width: 200
        height: 200
    }
}
