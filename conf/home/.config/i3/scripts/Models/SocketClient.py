#!/usr/bin/python3
# -*- encoding: utf-8 -*-

import socket
import sys

class SocketClient:
    # Create a UDS socket
    sock = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)

    # Connect the socket to the port where the server is listening
    server_address = '/var/run/keycounter.socket'
    

    def get_pulsations_current(self):
        #print('Conectando a {}'.format(server_address))
        try:
            self.sock.connect(self.server_address)
        except socket.error as msg:
            #print(msg)
            return None
            sys.exit(1)
        try:
            # Pido cantidad de pulsaciones actual
            message = b'pulsations_current'
            #print('Enviando {!r}'.format(message))
            self.sock.sendall(message)

            # Recibo la cantidad de pulsaciones
            data = self.sock.recv(2048)
            #print('Recibido {!r}'.format(data.decode("utf-8")))

            # Devuelvo las pulsaciones.
            return str(data.decode("utf-8"))

        finally:
            #print('closing socket')
            self.sock.close()
