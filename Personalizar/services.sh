#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2020 Raúl Caro Pastorino
## @license    https://wwww.gnu.org/licenses/gpl.txt
## @email      raul@fryntiz.dev
## @web        https://fryntiz.es
## @github     https://github.com/fryntiz
## @gitlab     https://gitlab.com/fryntiz
## @twitter    https://twitter.com/fryntiz
##
##             Applied Style Guide:
## @style      https://gitlab.com/fryntiz/bash-guide-style

############################
##      INSTRUCTIONS      ##
############################
## Habilita y/o deshabilita servicios

############################
##       FUNCIONES        ##
############################

services_enable_disable() {
    echo -e "$VE Habilitando servicios al iniciar$CL"

    echo -e "$VE Deshabilitando servicios al iniciar$CL"
    sudo systemctl disable apt-daily.timer
    sudo systemctl stop apt-daily.timer

    sudo systemctl disable apt-daily-upgrade.timer
    sudo systemctl stop apt-daily-upgrade.timer

    sudo systemctl disable unattended-upgrades.service
    sudo systemctl stop unattended-upgrades.service
}
