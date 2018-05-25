# -*- coding: utf-8 -*-

import forecastio

from PyQt5.QtCore import pyqtProperty, pyqtSignal, pyqtSlot, QCoreApplication, QObject, QUrl, QThreadPool, QRunnable

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

        self._datablock = datablock
        self._transformed = [DataPoint(v) for v in datablock.data]

    def wrap(self):
        return self._transformed

class FakeDataPoint:
    summary = "Fake Datapoint"

class StaticForecast:
    def currently():
        return FakeDataPoint
