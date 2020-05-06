#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2017 Raúl Caro Pastorino
## @license    https://wwww.gnu.org/licenses/gpl.txt
## @email      dev@fryntiz.es
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


            local PGHBA="/etc/postgresql/$V_PSQL/main/pg_hba.conf"
            echo -e "$VE Archivo de configuración$RO $PGHBA$CL"

            ## Permito conectar todos los usuarios en entorno local.
            sudo sed -r -i "s/^\s*#?local\s*all\s*all\s*peer/local all all trust/" "$PGHBA"
        done
    }

    personalizar_postgresql() {
        echo -e "$VE Personalizando$RO postgreSQL$CL"
    }

    postgresql_users_create() {
        echo -e "$VE Crear usuario desarrollador$RO dev$CL"

        ## Crea el usuario usuario y pide que teclee su contraseña.
        sudo -u postgres createuser -P dev

        ## Crea la base de datos basedatos para el usuario.
        sudo -u postgres createdb dev -O dev

        ## Creo la base de datos para almacenar información del sistema.
        sudo -u postgres createdb computer -O dev

        ## Asigno permisos para el usuario dev en las DB creadas.
        sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE dev to dev"
        sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE computer to dev"
    }

    configurar_postgresql
    personalizar_postgresql

    if [[ $MY_ENV = 'dev' ]]; then
        read -p '¿Quieres crear usuario desarrollador? s/N → ' input

        if [[ $input = 's' ]] || [[ $input = 'S' ]]; then
            postgresql_users_create
        fi
    fi
}

postgresql_instalador() {
    postgresql_descargar
    postgresql_preconfiguracion
    postgresql_instalar
    postgresql_postconfiguracion

    ## Reiniciar servidor postgresql
    reiniciarServicio 'postgresql'
}
