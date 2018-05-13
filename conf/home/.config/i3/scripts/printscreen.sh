#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2018 Raúl Caro Pastorino
## @license    https://wwww.gnu.org/licenses/gpl.txt
## @email      tecnico@fryntiz.es
## @web        www.fryntiz.es
## @github     https://github.com/fryntiz
## @gitlab     https://gitlab.com/fryntiz
## @twitter    https://twitter.com/fryntiz
##
##             Guía de estilos aplicada:
## @style      https://github.com/fryntiz/Bash_Style_Guide

############################
##     INSTRUCCIONES      ##
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
