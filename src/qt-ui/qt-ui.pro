TEMPLATE = app

QT += positioning qml quick

CONFIG += c++11

SOURCES += main.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

DISTFILES += \
    main.py \
    pyqt/WeatherObject.py \
    pyqt/DarkSky.py \
    pyqt/Threading.py \
    pyqt/Geocoder.py    \
    qml/shader/utils.js
