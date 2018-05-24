import QtQuick 2.0

// python-invoked test
Rectangle {
    id: pytest
    StatusCircleContainer
    {
        x: 60
        model: 4
        leftOriented: true
    }

    TabbedRect {

    }
}
