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

## Vídeo

raspivid -o video.h264 -t 10000

## Vídeo noche
#raspivid -o video.h264 -t 10000 -ex night
