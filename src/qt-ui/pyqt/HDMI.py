# some guidance from https://sourceforge.net/p/raspberry-gpio-python/wiki/Inputs/
# and http://henrysbench.capnfatz.com/henrys-bench/arduino-sensors-and-input/arduino-hc-sr501-motion-sensor-tutorial/

from subprocess import call

def screen_on(value):
    call(["vcgencmd", "display_power", "1" if value else "0"])

try:
    import threading
    import RPi.GPIO as GPIO
    import time

    channel = 8

    t = 0

    def pir_activity(channel):
        global t
        value = GPIO.input(channel)
        print('PIR callback: {}'.format(value))
        if value == True:
            if t != 0:
                t.cancel()
            screen_on(True)
        else:
            t = threading.Timer(60.0, screen_on, [False])
            t.start()


    GPIO.setmode(GPIO.BOARD)
    # bouncetime is in milliseconds
    GPIO.setup(channel, GPIO.IN, pull_up_down=GPIO.PUD_DOWN, bouncetime=250)
    GPIO.add_event_detect(channel, GPIO.BOTH, callback=pir_activity)

except ImportError:
	print('not attempting GPIO/screen blank')
