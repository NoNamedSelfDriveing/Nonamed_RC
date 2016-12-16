import time
import sys
import cv2
from multiprocessing import Process

from Capture import Capture
from Servo import Servo

x_angle = 90
y_angle = 90

x_servo = Servo(23)
y_servo = Servo(24)

cam = Capture()

def img():

    while True:
        cam.get_img()
        cv2.imshow('test', cam.img)

        cv2.waitKey(50)


img_process = Process(target=img)
img_process.start()

while True:
    
    x_angle = x_servo.set_angle(x_angle)
    y_angle = y_servo.set_angle(y_angle)

    x_servo.move()
    y_servo.move()

    time.sleep(0.05)

