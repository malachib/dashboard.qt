#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import sys

from PyQt5.QtCore import QDateTime, QObject, QUrl, pyqtSignal
from PyQt5.QtQml import QQmlApplicationEngine
from PyQt5.QtQuick import QQuickView
from PyQt5.QtWidgets import QApplication
from PyQt5.QtGui import QPainter, QColor, QPen
from PyQt5.QtQml import qmlRegisterType, QQmlComponent, QQmlEngine

from pyqt.WeatherObject import *
from pyqt.Geocoder import Geocoder

#geocode_test1()

init_subsystem()

#raw_test3()

app = QApplication(sys.argv)
engine = QQmlEngine(app)
#engine = QQmlApplicationEngine()

# doesn't quite work because we aren't actually using the component associated
# with this engine
engine.quit.connect(app.quit)

# from http://pyqt.sourceforge.net/Docs/PyQt5/qml.html
# Register the Python type.  Its URI is 'People', it's v1.0 and the type
# will be called 'Person' in QML.
qmlRegisterType(Weather, 'WeatherCategory', 1, 0, 'Weather')
qmlRegisterType(DataPoint, 'WeatherCategory', 1, 0, 'DataPoint')
qmlRegisterType(DataBlock, 'WeatherCategory', 1, 0, 'DataBlock')
qmlRegisterType(Geocoder, 'WeatherCategory', 1, 0, 'Geocoder')

component = QQmlComponent(engine)
component.loadUrl(QUrl('WeatherDash.qml'))

# Create the QML user interface.  Auto creates its own engine
view = QQuickView()

engine2 = view.engine
# Does not run
#engine2.quit.connect(app.quit)

#view.setSource(QUrl('PyTest.qml'))
# To Satisfy cool-retro-term needs
view.rootContext().setContextProperty('devicePixelRatio', app.devicePixelRatio())

view.setSource(QUrl('WeatherDash.qml'))
#view.setResizeMode(QDeclarativeView.SizeRootObjectToView)
view.setGeometry(100, 100, 750, 480)
# ala https://pythonspot.com/pyqt5-colors/
view.setColor(QColor(0, 30, 0))

view.show()

is_full_screen = False

# technique lifted from https://stackoverflow.com/questions/19131084/pyqt5-qml-signal-to-python-slot
# and augmented from https://stackoverflow.com/questions/30586983/how-to-close-pyqt5-program-from-qml
# could refine with https://stackoverflow.com/questions/24111717/how-to-bind-buttons-in-qt-quick-to-python-pyqt-5
# not 100% ideal, but adequate and interesting
def on_quit():
    app.quit()

def on_toggle_fullscreen():
    global is_full_screen
    if is_full_screen:
        view.show()
    else:
        view.showFullScreen()
    is_full_screen = not is_full_screen

weather_dash = view.rootObject()
weather_dash.quit.connect(on_quit)
weather_dash.toggleFullScreen.connect(on_toggle_fullscreen)

# may want to do this slightly differently, though I prefer QML doing the heavy lifting
# http://doc.qt.io/qt-5/qqmlcomponent.html
#weather_chart = view.findChild(Loader, "WeatherChart")

# this does work
#view.showFullScreen()

app.exec_()
