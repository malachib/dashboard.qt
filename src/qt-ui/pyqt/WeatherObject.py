# -*- coding: utf-8 -*-

# adapting from http://pyqt.sourceforge.net/Docs/PyQt5/qml.html

# also using signal approach indicated by
#  http://zetcode.com/gui/pyqt5/eventssignals/
#  http://python.6.x6.nabble.com/Small-doc-fix-td5190343.html
# however, that doesn't seem to be working, so next up is to utilize example given here:
#  https://github.com/baoboa/pyqt5/blob/master/examples/qml/referenceexamples/binding.py

# timer guidance from
#  https://stackoverflow.com/questions/8600161/executing-periodic-actions-in-python

import sys

import time, threading

from PyQt5.QtCore import pyqtProperty, pyqtSignal, QCoreApplication, QObject, QUrl
from PyQt5.QtQml import qmlRegisterType, QQmlComponent, QQmlEngine

import forecastio

# This is the type that will be registered with QML.  It must be a
# sub-class of QObject.
class Weather(QObject):

    temperatureChanged = pyqtSignal(int, arguments=['temperature'])

    def foo(self):
        #print(time.ctime())
        self._temperature += 1
        # FIX: get error 'native qt signal is not callable'
        self.temperatureChanged.emit(self._temperature)
        threading.Timer(1, self.foo).start()

    def __init__(self, parent=None):
        super().__init__(parent)

        # initial test value
        self._temperature = 77

        self.foo()

    # Define the getter of the 'temperature' property.  The C++ type and
    # Python type of the property is int.
    @pyqtProperty(int, notify=temperatureChanged)
    def temperature(self):
        return self._temperature

    # Define the setter of the 'temperature' property.
    @temperature.setter
    def temperature(self, temperature):
        self._temperature = temperature
        self.temperatureChanged.emit(temperature)

# would like this async but it needs an event loop outside to kick it off (or an await)
# but our app.exec_ kind of interrupts that
def init_subsystem():
    print("got here")
    file = open("../../conf/darksky-apikey", "r")
    # read API key and yank off trailing whitespace
    api_key = file.read().rstrip()
    lat = -31.967819
    lng = 115.87718
    forecast = forecastio.load_forecast(api_key, lat, lng)
