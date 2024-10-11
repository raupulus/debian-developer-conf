#!/usr/bin/python3
# -*- encoding: utf-8 -*-

import socket
import json
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
            return "N/D"

        try:
            # Pido cantidad de pulsaciones actual
            message = b'pulsations_current'
            sock.sendall(message)

            # Recibo la cantidad de pulsaciones
            data = sock.recv(2048)
            response = data.decode("utf-8")

            try:
                # Parsear el JSON
                json_data = json.loads(response)
                pulsations_total = json_data["session"]["pulsations_total"]
                pulsations_current = json_data["streak"]["pulsations_current"]
                pulsation_average = json_data["streak"]["pulsation_average"]

                # Formatear la cadena
                formatted_output = f"{pulsations_current}/{pulsation_average}AVG/{pulsations_total}T"
                return formatted_output

            except (json.JSONDecodeError, KeyError):
                return "N/D"

        finally:
            sock.close()

    def run(self):
        pulsations_info = self.get_pulsations_current()
        text = f' {pulsations_info}'

        self.output = {
            "full_text": text,
            "color": self.color
        }
