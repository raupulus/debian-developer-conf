#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2021 Raúl Caro Pastorino
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
##

###########################
##       FUNCTIONS       ##
###########################

## En caso de no recibir parámetros, saldrá
if [[ $# = 0 ]]; then
    echo 'No hay parámetros, se espera la versión como único parámetro.'
    echo 'Ejemplo: php_version_select 7.4'
    exit 1
fi

setVersion() {
  version="$1"

  sudo update-alternatives --set php "/usr/bin/php${version}"
  sudo update-alternatives --set phar "/usr/bin/phar${version}"
  sudo update-alternatives --set phar.phar "/usr/bin/phar.phar${version}"
}

setVersion $1

exit 0
