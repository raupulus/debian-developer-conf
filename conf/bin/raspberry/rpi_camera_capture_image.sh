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

DATE=$(date +"%Y-%m-%d_%H_%M")

# Código del contador indicando cantidad de dígitos: %04d

## 24 horas de ejecución:

#raspistill -t 86400000 -tl 30000 -vf -hf -o /home/pi/camera/${DATE}.jpg


## Una sola foto:
raspistill -vf -hf -o /home/pi/camera/${DATE}.jpg
