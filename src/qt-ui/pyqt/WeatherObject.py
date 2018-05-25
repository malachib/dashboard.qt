# -*- coding: utf-8 -*-

# adapting from http://pyqt.sourceforge.net/Docs/PyQt5/qml.html

# also using signal approach indicated by
#  http://zetcode.com/gui/pyqt5/eventssignals/
#  http://python.6.x6.nabble.com/Small-doc-fix-td5190343.html
# however, that doesn't seem to be working, so next up is to utilize example given here:
#  https://github.com/baoboa/pyqt5/blob/master/examples/qml/referenceexamples/binding.py

# timer guidance from
#  https://stackoverflow.com/questions/8600161/executing-periodic-actions-in-python

# callback from QML (aka slots) guidance from
#  https://stackoverflow.com/questions/19131084/pyqt5-qml-signal-to-python-slot

import sys

import time, threading

from PyQt5.QtCore import pyqtProperty, pyqtSignal, pyqtSlot, QCoreApplication, QObject, QUrl, QThreadPool, QRunnable
from PyQt5.QtQml import qmlRegisterType, QQmlComponent, QQmlEngine, QQmlListProperty

import forecastio

from pyqt.DarkSky import DataPoint, DataBlock, StaticForecast
from pyqt.Threading import Worker

api_key = ""
counter = 0

threadpool = QThreadPool()
print("Multithreading with maximum %d threads" % threadpool.maxThreadCount())


# This is the type that will be registered with QML.  It must be a
# sub-class of QObject.
class Weather(QObject):

    temperatureChanged = pyqtSignal(int, arguments=['temperature'])

    forecastChanged = pyqtSignal(DataPoint, arguments=['forecast'])

    def foo(self):
        #print(time.ctime())
        self._temperature += 1
        # FIX: get error 'native qt signal is not callable'
        self.temperatureChanged.emit(self._temperature)
        threading.Timer(1, self.foo).start()

    # blocking call, call this via threadpool/worker
    def blocking_refresh(self, lat, lng):
        print("refreshing forecast: ", lat, ", ", lng)
        #self._forecast = forecastio.load_forecast(api_key, lat, lng)
        #self._datapoint = DataPoint(self._forecast.currently())
        self.forecastChanged.emit(self._datapoint)

    def __init__(self, parent=None):
        super().__init__(parent)

        # initial test value
        self._temperature = 77
        self._forecast = StaticForecast

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

    @pyqtSlot(float, float)
    def refresh(self, lat, lng):
        worker = Worker(self.blocking_refresh, lat, lng)
        threadpool.start(worker)

    # guidance here http://pyqt.sourceforge.net/Docs/PyQt5/qml.html
    @pyqtProperty(QQmlListProperty, notify=forecastChanged)
    def hourly(self):
        __hourly = self._forecast.hourly(self._forecast);
        datablock = DataBlock(__hourly);
        self._wrapped = datablock.wrap()

        #print("Weather.hourly().len =", len(wrapped))

        self._hourly = QQmlListProperty(DataPoint, self, self._wrapped)
        return self._hourly;

    @pyqtProperty(DataPoint, notify=forecastChanged)
    def current(self):
        self._datapoint = DataPoint(self._forecast.currently())
        return self._datapoint

    # stop-gap, because I can't get binding on above current.summary to work
    # (says always that 'current' is null, and can't get summary from it)
    @pyqtProperty('QString', notify=forecastChanged)
    def current_summary(self):
        return self._forecast.currently().summary


# would like this async but it needs an event loop outside to kick it off (or an await)
# but our app.exec_ kind of interrupts that
def init_subsystem():
    global api_key
    file = open("../../conf/darksky-apikey", "r")
    # read API key and yank off trailing whitespace
    api_key = file.read().rstrip()

def raw_test1():
    lat = -31.967819
    lng =  115.87718
    _forecast = forecastio.load_forecast(api_key, lat, lng)
    DataPoint(_forecast.currently())
    print("raw_test1: done")

# works, not called
def raw_test2():
    f = StaticForecast()

    hourly = f.hourly()

    for i in hourly:
        print(i.summary)

# works also, also not called
def raw_test3():
    lat = -31.967819
    lng =  115.87718
    _forecast = forecastio.load_forecast(api_key, lat, lng)
    #DataPoint(_forecast.currently())
    hourly = DataBlock(_forecast.hourly())
    _hourly = hourly.wrap()

    for i in _hourly:
        print(i.summary)

