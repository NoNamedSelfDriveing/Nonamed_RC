import RPi.GPIO as GPIO

GPIO.setmode(GPIO.BCM)

class Servo:
    def __init__(self, pin):
        GPIO.setup(pin, GPIO.OUT)
        self.angle = 90
        self.turnMode = 0
        self.turnSpeed = 1
        self.pwm = GPIO.PWM(pin, 50)
        self.pwm.start(6.5)

    def move(self):
        duty = float(self.angle) / 20.0 + 2.5  # 6.5 is 90dgree
        self.pwm.ChangeDutyCycle(duty)

    def set_angle(self, angle):
        if not(angle > 160 or angle < 20):
            self.angle = angle
        
        return self.angle
        
