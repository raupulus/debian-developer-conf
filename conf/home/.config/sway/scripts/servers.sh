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
##

############################
##       VARIABLES        ##
############################
##

############################
##       FUNCIONES        ##
############################
servidor=$1
accion=$2

if [[ $servidor = '' ]] || [[ $accion = '' ]]; then
    exit 1
fi

notificarServicio() {
    mensaje=$1
    notify-send "$mensaje"
}

serviceApache() {
    local accion=$1
    systemctl $accion apache2
    notificarServicio "Se ha ejecutado $accion sobre Apache2"
}

serviceMariadb() {
    local accion=$1
    systemctl $accion mariadb
    notificarServicio "Se ha ejecutado $accion sobre MariaDB"
}

servicePostgresql() {
    local accion=$1
    systemctl $accion postgresql
    notificarServicio "Se ha ejecutado $accion sobre PostgreSQL"
}

case $servidor in
    apache) serviceApache $accion;;
    mariadb) serviceMariadb $accion;;
    postgresql) servicePostgresql $accion;;
esac

exit 0
