#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# not using 'hasattr' according to https://hynek.me/articles/hasattr/

import forecastio

from PyQt5.QtCore import pyqtProperty, pyqtSignal, pyqtSlot, QObject, QUrl, QThreadPool, QRunnable, QDateTime
from PyQt5.QtQml import QQmlListProperty
from datetime import date, datetime

api_key = ""

import pytz

# wrapper around forecastio wrapper
class DataPoint(QObject):

    def __init__(self, datapoint, parent=None):
        super().__init__(parent)

        self._datapoint = datapoint

    # pyQT will auto-convert this to a C++ QString from a python string
    @pyqtProperty('QString', constant=True)
    def summary(self):
        return self._datapoint.summary

    @pyqtProperty('QString', constant=True)
    def icon(self):
        # FIX: getting more of these than we expect or render
        # print("Icon: '" + self._datapoint.icon + "'")
        return self._datapoint.icon

    @pyqtProperty('QString', constant=True)
    def precipType(self):
        return self._datapoint.precipType

    @pyqtProperty(float, constant=True)
    def temperature(self):
        v = getattr(self._datapoint, "temperature", None)
        if v is not None:
            return v
        else:
            # do a warning here, runtime could show know better than to call this
            return -1
        #return self._datapoint.temperature

    @pyqtProperty(QDateTime, constant=True)
    def time(self):
        utctime = self._datapoint.time
        _utctime = pytz.utc.localize(utctime)
        adjustedtime = _utctime.astimezone(pytz.timezone("America/Los_Angeles"))

        return adjustedtime

    @pyqtProperty(float, constant=True)
    def precipProbablity(self):
        v = getattr(self._datapoint, "precipProbablity", None)
        if v is not None:
            return v
        else:
            return -1

    @pyqtProperty(float, constant=True)
    def precipIntensity(self):
        return self._datapoint.precipIntensity

    @pyqtProperty(float, constant=True)
    def uvIndex(self):
        return self._datapoint.uvIndex

    @pyqtProperty(float, constant=True)
    def ozone(self):
        return self._datapoint.ozone

    @pyqtProperty(float, constant=True)
    def windGust(self):
        return self._datapoint.windGust


class HourlyDataPoint(DataPoint):

    def __init__(self, datapoint, parent=DataPoint):
        super().__init__(datapoint)

class DailyDataPoint(DataPoint):

    def __init__(self, datapoint, parent=DataPoint):
        super(datapoint).__init__(datapoint)

class CurrentlyDataPoint(DataPoint):

    def __init__(self, datapoint, parent=DataPoint):
        super(datapoint).__init__(datapoint)

    @pyqtProperty(float, constant=True)
    def nearestStormDistance(self):
        return self._datapoint.nearestStormDistance


class DataBlock(QObject):

    def __init__(self, datablock, DataPointType, parent=None):
        super().__init__(parent)

        self._transformed = [DataPointType(v) for v in datablock.data]
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
    temperature = 0
    time = datetime.now()
    precipProbablity = 0.5
    precipIntensity = 0
    icon = "clear-day"

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
        return self._data

class StaticForecast:
    def daily(self):
        hourlydata = [FakeDataPoint(str('Fake Daily: ') + str(i)) for i in range(10)]
        return FakeDataBlock(hourlydata)

    def hourly(self):
        hourlydata = [FakeDataPoint(str('Fake Hourly: ') + str(i)) for i in range(10)]
        #print("StaticForecast.hourly count: ", len(hourlydata))
        self._hourly = FakeDataBlock(hourlydata)
        return self._hourly

    def currently(self):
        return FakeDataPoint()
