#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2021 Raúl Caro Pastorino
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

###########################
##       FUNCIONES       ##
###########################
prepare_directories() {
  echo -e "$RO Preparando directorios$CL"

  if [[ ! -d '/home/pi/git' ]]; then
    mkdir '/home/pi/git'
  fi

  if [[ ! -d '/home/pi/scripts' ]]; then
    mkdir '/home/pi/scripts'
  fi
}