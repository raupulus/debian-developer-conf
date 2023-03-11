#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2021 Raúl Caro Pastorino
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
