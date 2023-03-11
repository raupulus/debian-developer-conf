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
install_piaware() {
  echo -e "$RO Instalando Piaware para flightaware$CL"

  cd '/tmp'

  wget https://es.flightaware.com/adsb/piaware/files/packages/pool/piaware/p/piaware-support/piaware-repository_4.0_all.deb

  sudo dpkg -i piaware-repository_4.0_all.deb

  cd "${$WORKSCRIPT}"

  sudo apt-get update
  sudo apt-get install piaware

  sudo piaware-config allow-auto-updates yes
  sudo piaware-config allow-manual-updates yes

  sudo apt-get install dump1090-fa
  sudo apt-get install dump978-fa
}
