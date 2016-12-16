import cv2
import socket
import numpy


class Capture:
    def __init__(self):
        self.camera_port = 0 
        self.camera = cv2.VideoCapture(self.camera_port)
	self.img = 0

    def get_img(self):
        retVal, self.img = self.camera.read()
	self.img = self.img

class Socket():
    def __init__(self):
        self.UDP_socket = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

    def set_addr(self, addr, port):
        self.addr = addr
        self.port = port

    def send_img(self, image):
        client_addr = (self.addr, self.port)
        img.resize(640, 480)
        cv2.imshow('frame', image)
