#!/usr/bin/python3
# -*- encoding: utf-8 -*-

import socket
import sys
from i3pystatus import IntervalModule

class SocketClient(IntervalModule):

    color = "#00FF00"
    interval = 1

    settings = (
        ("format", "Format string"),
    )

    def get_pulsations_current(self):
        # Create a UDS socket
        sock = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)

        # Connect the socket to the port where the server is listening
        server_address = '/var/run/keycounter.socket'

        try:
            sock.connect(server_address)
        except socket.error as msg:
            return None

        try:
            # Pido cantidad de pulsaciones actual
            message = b'pulsations_current'
            #print('Enviando {!r}'.format(message))
            sock.sendall(message)

            # Recibo la cantidad de pulsaciones
            data = sock.recv(2048)
            #print('Recibido {!r}'.format(data.decode("utf-8")))

            # Devuelvo las pulsaciones.
            return str(data.decode("utf-8"))

        finally:
            #print('closing socket')
           sock.close()

    def run(self):
        if self.get_pulsations_current():
            text = ' ' + self.get_pulsations_current()
        else:
            text = ''

        self.output = {
            "full_text": text,
            "color": self.color
        }