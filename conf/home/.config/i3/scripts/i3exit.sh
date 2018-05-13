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
## Recibe un parámetro con la acción de apagado/bloqueo/suspensión/hibernación

############################
##       FUNCIONES        ##
############################
case "$1" in
    lock) ~/.config/i3/scripts/lock_and_blur.sh ;;
    logout) i3-msg exit;;
    suspend) lock && systemctl suspend;;
    hibernate) lock && systemctl hibernate;;
    reboot) systemctl reboot;;
    shutdown) systemctl poweroff;;
    *)
        echo "Modo de uso: $0 {lock|logout|suspend|hibernate|reboot|shutdown}"
        exit 2
esac

exit 0
