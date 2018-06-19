# Dashboard

Can't we get a pretty metrics/uptime/input monitor?  Are butt-ugly and ghastly the only games in town?

# Python Dependencies

## Weather

We use an API library dependency found here:

https://github.com/ZeevG/python-forecast.io

As well as pytz for time zone conversions

Since this is a python3.x project, pip3 is recommended
(pip3 installation help here https://stackoverflow.com/questions/6587507/how-to-install-pip-with-python-3)

# QT

## Debian

Modules needed:

`sudo apt-get install qt5-default qml-module-qtquick-controls qml-module-qtquick-controls2 qml-module-qtlocation qml-module-qtpositioning`

I think also

`sudo apt-get install qml-module-qtquick-templates2`

At present, https://packages.debian.org/buster/libs/qml-module-qtcharts indicates we can't easily insdtall qtcharts yet

## Raspbian

For pyqt, regular pip install won't do.  Use:

`sudo apt-get install pyqt5-dev pyqt5-dev-tools python3-pyqt5.qtquick`

## macOS

Do `pip3 install pyqt5`

Also experimenting with `pip3 install PyQtChart`
