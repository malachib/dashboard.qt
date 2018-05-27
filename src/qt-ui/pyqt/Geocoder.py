# -*- coding: utf-8 -*-

from PyQt5.QtCore import pyqtProperty, pyqtSignal, pyqtSlot, QCoreApplication, QObject, QUrl, QThreadPool, QRunnable
from PyQt5.QtPositioning import QGeoCoordinate

from pyqt.Threading import Worker, threadpool

import geocoder

# This is the type that will be registered with QML.  It must be a
# sub-class of QObject.
class Geocoder(QObject):

    geocodeUpdated = pyqtSignal(QGeoCoordinate, arguments=['geocode'])

    def blocking_refresh(self):
        self._g = geocoder.arcgis(self._name)
        self._result = QGeoCoordinate(self._g[0].lat, self._g[0].lng)
        self.geocodeUpdated.emit(self._result)
        print("Emitted: ", self._g[0])

    def __init__(self, parent=None):
        super().__init__(parent)

        self._result = QGeoCoordinate(0, 0)

    @pyqtProperty('QString')
    def name(self):
        return self._name

    @name.setter
    def name(self, value):
        self._name = value
        worker = Worker(self.blocking_refresh)
        threadpool.start(worker)

    @pyqtProperty(QGeoCoordinate)
    # still says non notifiable.  Try a string, maybe it doesnt like the QGeoCoordinate
    def loc(self, notify=geocodeUpdated):
        return self._result

