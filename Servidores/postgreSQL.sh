#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2017 Raúl Caro Pastorino
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
## Instala y configura postgreSQL tanto la parte cliente como el servidor.

############################
##        FUNCIONES       ##
############################

postgresql_descargar() {
    echo -e "$VE Descargando$RO postgresql$CL"
}

postgresql_preconfiguracion() {
    echo -e "$VE Generando Pre-Configuraciones de$RO postgreSQL"
}

postgresql_instalar() {
    echo -e "$VE Instalando$RO PostgreSQL$CL"
    local dependencias="postgresql postgresql-client postgresql-contrib postgresql-all"

    ## Instalando dependencias
    instalarSoftware "$dependencias"
}

postgresql_postconfiguracion() {
    echo -e "$VE Generando Post-Configuraciones de postgreSQL"

    configurar_postgresql() {
        echo -e "$VE Preparando configuracion de$RO postgreSQL$CL"
        ## FIXME → Detectar todas las versionesde postgresql y aplicar cambios por cada versión encontrada en el sistema.

        ## Versión de PostgreSQL
        local V_PSQL='9.6'

        ## Archivo de configuración para postgresql
        local POSTGRESCONF="/etc/postgresql/$V_PSQL/main/postgresql.conf"

        echo -e "$VE Estableciendo intervalstyle = 'iso_8601'$CL"
        sudo sed -r -i "s/^\s*#?intervalstyle\s*=/intervalstyle = 'iso_8601' #/" "$POSTGRESCONF"

        echo -e "$VE Estableciendo timezone = 'UTC'$CL"
        sudo sed -r -i "s/^\s*#?timezone\s*=/timezone = 'UTC' #/" "$POSTGRESCONF"
    }

    personalizar_postgresql() {
        echo -e "$VE Personalizando$RO postgreSQL$CL"
        #sudo -u postgres createdb basedatos #Crea la base de datos basedatos
        #sudo -u postgres createuser -P usuario #Crea el usuario usuario y pide que teclee su contraseña
    }

    configurar_postgresql
    personalizar_postgresql
}


postgresql_instalador() {
    postgresql_descargar
    postgresql_preconfiguracion
    postgresql_instalar
    postgresql_postconfiguracion

    ## Reiniciar servidor postgresql
    reiniciarServicio 'postgresql'
}
