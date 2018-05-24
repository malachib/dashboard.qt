#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import sys

from PyQt5.QtCore import QDateTime, QObject, QUrl, pyqtSignal
from PyQt5.QtQml import QQmlApplicationEngine
from PyQt5.QtQuick import QQuickView
from PyQt5.QtWidgets import QApplication
from PyQt5.QtGui import QPainter, QColor, QPen

app = QApplication(sys.argv)
#engine = QQmlApplicationEngine()

# Create the QML user interface.
view = QQuickView()
view.setSource(QUrl('PyTest.qml'))
#view.setResizeMode(QDeclarativeView.SizeRootObjectToView)
view.setGeometry(100, 100, 400, 240)
# ala https://pythonspot.com/pyqt5-colors/
view.setColor(QColor(0, 30, 0))
view.show()

app.exec_()
