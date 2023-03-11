#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2018 Raúl Caro Pastorino
## @license    https://wwww.gnu.org/licenses/gpl.txt
## @email      public@raupulus.dev
## @web        https://raupulus.dev
## @github     https://github.com/raupulus
## @gitlab     https://gitlab.com/raupulus
## @twitter    https://twitter.com/raupulus
##
##             Applied Style Guide:
## @style      https://gitlab.com/raupulus/bash-guide-style

############################
##      INSTRUCTIONS      ##
############################
## Recibe el tipo de captura que realizará: full/window/mon1/mon2/dinamic
## Para ejecutar la acción correspondiente

############################
##       FUNCIONES        ##
############################

## Captura de Pantalla
#bindsym Print exec scrot '%Y-%m-%d_%T_scrot.png' -e 'mv $f ~/Imágenes/Screenshots/'

## Captura de Ventana
#bindsym $mod+Control+Print exec scrot '%Y-%m-%d_%T_scrot.png' -u -e 'mv $f ~/Imágenes/Screenshots/'

## Capturar un área (No termina de funcionar correctamente)
#bindsym --release $mod+Control+Print exec --no-startup-id scrot -s '%Y-%m-%d_%T_scrot.png' -e 'mv $f ~/Imágenes/Screenshots/'



xfce4-screenshooter -crm
