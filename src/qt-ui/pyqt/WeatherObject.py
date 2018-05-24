# -*- coding: utf-8 -*-

# adapting from http://pyqt.sourceforge.net/Docs/PyQt5/qml.html

# also using signal approach indicated by
#  http://zetcode.com/gui/pyqt5/eventssignals/
#  http://python.6.x6.nabble.com/Small-doc-fix-td5190343.html

import sys

from PyQt5.QtCore import pyqtProperty, pyqtSignal, QCoreApplication, QObject, QUrl
from PyQt5.QtQml import qmlRegisterType, QQmlComponent, QQmlEngine

# This is the type that will be registered with QML.  It must be a
# sub-class of QObject.
class Weather(QObject):
    temperatureChanged = pyqtSignal(int, arguments=['temperature'])

    def __init__(self, parent=None):
        super().__init__(parent)

        # initial test value
        self._temperature = 77

    # Define the getter of the 'temperature' property.  The C++ type and
    # Python type of the property is int.
    @pyqtProperty(int, notify=temperatureChanged)
    def temperature(self):
        return self._temperature

    # Define the setter of the 'temperature' property.
    @temperature.setter
    def temperature(self, temperature):
        self._temperature = temperature
        self.temperatureChanged(temperature)

def test_weather_1():
    print("got here")
