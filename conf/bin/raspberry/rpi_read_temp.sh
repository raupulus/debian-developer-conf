#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2021 Raúl Caro Pastorino
## @license    https://wwww.gnu.org/licenses/gpl.txt
## @email      public@raupulus.dev
## @web        https://raupulus.dev
## @gitlab     https://gitlab.com/raupulus
## @github     https://github.com/raupulus
## @twitter    https://twitter.com/raupulus
##
##             Applied Style Guide:
## @style      https://gitlab.com/raupulus/bash-guide-style

############################
##      INSTRUCTIONS      ##
############################
##

###########################
##       FUNCTIONS       ##
###########################

import os
import time

def measure_temp():
    """
    Devuelve la temperatura
    """
    temp = os.popen("vcgencmd measure_temp").readline()
    return (temp.replace("temp=","").replace("\'C", ""))

while True:
    temperatura = measure_temp()

    if float(temperatura) > float("62.5"):
        print("Temperatura ALTA: " + temperatura)
    else:
        print("Temperatura NORMAL: " + temperatura)

    time.sleep(1)
