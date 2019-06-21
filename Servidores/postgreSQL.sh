#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2017 Raúl Caro Pastorino
## @license    https://wwww.gnu.org/licenses/gpl.txt
## @email      tecnico@fryntiz.es
## @web        https://fryntiz.es
## @gitlab     https://gitlab.com/fryntiz
## @github     https://github.com/fryntiz
## @twitter    https://twitter.com/fryntiz
##
##             Guía de estilos aplicada:
## @style      https://gitlab.com/fryntiz/bash-guide-style

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
    instalarSoftwareLista "${SOFTLIST}/Servidores/postgresql.lst"
}

postgresql_postconfiguracion() {
    echo -e "$VE Generando Post-Configuraciones de postgreSQL"

    configurar_postgresql() {
        echo -e "$VE Preparando configuracion de$RO postgreSQL$CL"

        ## Añade a un array todas las versiones de postgreSQL
        ## existentes en /etc/postgresql
        local ALL_POSTGRESQL=(`ls /etc/postgresql/`)

        ## Configura todas las versiones de postgresql existentes
        for V_PSQL in "${ALL_POSTGRESQL[@]}"; do
            echo -e "$VE Configurando$RO postgreSQL$VE versión:$AM $V_PSQL$CL"

            ## Archivo de configuración para postgresql
            local POSTGRESCONF="/etc/postgresql/$V_PSQL/main/postgresql.conf"
            echo -e "$VE Archivo de configuración$RO $POSTGRESCONF$CL"

            echo -e "$VE Estableciendo intervalstyle = 'iso_8601'$CL"
            sudo sed -r -i "s/^\s*#?intervalstyle\s*=.*/intervalstyle = 'iso_8601'/" "$POSTGRESCONF"

            echo -e "$VE Estableciendo timezone = 'UTC'$CL"
            sudo sed -r -i "s/^\s*#?timezone\s*=.*/timezone = 'UTC'/" "$POSTGRESCONF"
        done
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
