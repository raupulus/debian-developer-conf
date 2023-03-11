#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2018 Raúl Caro Pastorino
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
## Configura un usuario administrador llamado web
configureAdmin() {

    ## Crea el usuario administrador: web
    sudo adduser web
    sudo usermod -a -G sudo web
    sudo usermod -a -G www-data web
    sudo usermod -a -G users web
    sudo usermod -a -G web web
    sudo usermod -a -G docker web
    sudo usermod -a -G mongodb web
    sudo usermod -a -G postgres web
    sudo usermod -a -G crontab web
}
