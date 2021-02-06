#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2021 Raúl Caro Pastorino
## @license    https://wwww.gnu.org/licenses/gpl.txt
## @email      raul@fryntiz.dev
## @web        https://fryntiz.es
## @gitlab     https://gitlab.com/fryntiz
## @github     https://github.com/fryntiz
## @twitter    https://twitter.com/fryntiz
##
##             Applied Style Guide:
## @style      https://gitlab.com/fryntiz/bash-guide-style

############################
##      INSTRUCTIONS      ##
############################
##

###########################
##       FUNCTIONS       ##
###########################

DATE=$(date +"%Y-%m-%d_%H_%M")

# Código del contador indicando cantidad de dígitos: %04d

## 24 horas de ejecución:

#raspistill -t 86400000 -tl 30000 -vf -hf -o /home/pi/camera/${DATE}.jpg


## Una sola foto:
raspistill -vf -hf -o /home/pi/camera/${DATE}.jpg
