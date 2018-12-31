#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2018 Raúl Caro Pastorino
## @license    https://wwww.gnu.org/licenses/gpl.txt
## @email      tecnico@fryntiz.es
## @web        https://fryntiz.es
## @gitlab     https://gitlab.com/fryntiz
## @github     https://github.com/fryntiz
## @twitter    https://twitter.com/fryntiz
##
##             Guía de estilos aplicada:
## @style      https://github.com/fryntiz/Bash_Style_Guide

############################
##     INSTRUCCIONES      ##
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
