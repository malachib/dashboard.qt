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

init_subsystem()

#raw_test3()

app = QApplication(sys.argv)
#engine = QQmlApplicationEngine()

# from http://pyqt.sourceforge.net/Docs/PyQt5/qml.html
# Register the Python type.  Its URI is 'People', it's v1.0 and the type
# will be called 'Person' in QML.
qmlRegisterType(Weather, 'WeatherCategory', 1, 0, 'Weather')
qmlRegisterType(DataPoint, 'WeatherCategory', 1, 0, 'DataPoint')
qmlRegisterType(DataBlock, 'WeatherCategory', 1, 0, 'DataBlock')

# Create the QML user interface.
view = QQuickView()
view.setSource(QUrl('PyTest.qml'))
#view.setResizeMode(QDeclarativeView.SizeRootObjectToView)
view.setGeometry(100, 100, 600, 440)
# ala https://pythonspot.com/pyqt5-colors/
view.setColor(QColor(0, 30, 0))
view.show()

app.exec_()
