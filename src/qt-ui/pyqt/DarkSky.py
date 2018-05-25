# -*- coding: utf-8 -*-

import forecastio

from PyQt5.QtCore import pyqtProperty, pyqtSignal, pyqtSlot, QCoreApplication, QObject, QUrl, QThreadPool, QRunnable
from PyQt5.QtQml import QQmlListProperty

api_key = ""

# wrapper around forecastio wrapper
class DataPoint(QObject):

    def __init__(self, datapoint, parent=None):
        super().__init__(parent)

        self._datapoint = datapoint

    # pyQT will auto-convert this to a C++ QString from a python string
    @pyqtProperty('QString', constant=True)
    def summary(self):
        return self._datapoint.summary

class DataBlock(QObject):

    def __init__(self, datablock, parent=None):
        super().__init__(parent)

        self._transformed = [DataPoint(v) for v in datablock.data]
        self._datablock = datablock
        self._data = QQmlListProperty(DataPoint, self, self._transformed)

    @pyqtProperty('QString', constant=True)
    def summary(self):
        return self._datablock.summary

    # guidance here http://pyqt.sourceforge.net/Docs/PyQt5/qml.html
    @pyqtProperty(QQmlListProperty, constant=True)
    def data(self):
        return self._data;

# a fake NATIVE darksky datapoint, not a qml-friendly one
class FakeDataPoint:
    summary = "Unassigned Datapoint"

    def __init__(self, summary = "Fake Datapoint", parent=None):
        super().__init__()

        self.summary = summary


# a fake NATIVE darksky datablock, not a qml-friendly one
class FakeDataBlock:
    summary = "Fake Data Block (summary)"

    def __init__(self, data, parent=None):
        super().__init__()

        self._data = data

    @property
    def data(self):
        #print("FakeDataBlock count: ", len(self._data))
        return self._data

class StaticForecast:
    def hourly(self):
        hourlydata = [FakeDataPoint(str('Fake Hourly: ') + str(i)) for i in range(10)]
        #print("StaticForecast.hourly count: ", len(hourlydata))
        self._hourly = FakeDataBlock(hourlydata)
        return self._hourly

    def currently():
        return FakeDataPoint
