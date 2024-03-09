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
## Recibe un parámetro con la acción de apagado/bloqueo/suspensión/hibernación

############################
##       FUNCIONES        ##
############################
case "$1" in
    lock) ~/.config/sway/scripts/lock_and_blur.sh ;;
    reload) swaymsg reload;;
    logout) swaymsg exit;;
    suspend) lock && systemctl suspend;;
    hibernate) lock && systemctl hibernate;;
    reboot) systemctl reboot;;
    shutdown) systemctl poweroff;;
    *)
        echo "Modo de uso: $0 {lock|logout|suspend|hibernate|reboot|shutdown}"
        exit 2
esac

exit 0
