#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2017 Raúl Caro Pastorino
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
## Instala y configura postgreSQL tanto la parte cliente como el servidor.

############################
##        FUNCTIONS       ##
############################

postgresql_descargar() {
    echo -e "$VE Descargando$RO postgresql$CL"
}

postgresql_preconfiguracion() {
    echo -e "$VE Generando Pre-Configuraciones de$RO postgreSQL"
}

postgresql_instalar() {
    echo -e "$VE Instalando$RO PostgreSQL$CL"
    instalarSoftwareLista "${SOFTLIST}/servers/postgresql.lst"
}

postgresql_postconfiguracion() {
    echo -e "$VE Generando Post-Configuraciones de postgreSQL"

    if [[ $DISRTRO = 'macos' ]]; then
        brew services start postgresql
    fi

    configurar_postgresql() {
        echo -e "$VE Preparando configuracion de$RO postgreSQL$CL"

        ## Añade a un array todas las versiones de postgreSQL
        ## existentes en /etc/postgresql

        if [[ $DISTRO = 'macos' ]]; then
            #TODO: reutilizar función de php para editar con sed
            #TODO: buscar ruta hacia los archivos de configuración

            echo -e "$VE Configurando$RO postgreSQL$CL"

            ## Archivo de configuración para postgresql
            local POSTGRESCONF="/opt/homebrew/var/postgres/postgresql.conf"

            echo -e "$VE Archivo de configuración$RO $POSTGRESCONF$CL"

            echo -e "$VE Estableciendo intervalstyle = 'iso_8601'$CL"
            strFileReplace "s/^\s*#?intervalstyle\s*=.*/intervalstyle = 'iso_8601'/" "$POSTGRESCONF"

            echo -e "$VE Estableciendo timezone = 'UTC'$CL"
            strFileReplace "s/^\s*#?timezone\s*=.*/timezone = 'UTC'/" "$POSTGRESCONF"


            local PGHBA="/opt/homebrew/var/postgres/pg_hba.conf"

            echo -e "$VE Archivo de configuración$RO $PGHBA$CL"

            ## Permito conectar todos los usuarios en entorno local.
            strFileReplace "s/^\s*#?local\s*all\s*all\s*peer/local all all trust/" "$PGHBA"
        else
            local ALL_POSTGRESQL=(`ls /etc/postgresql/`)

            ## Configura todas las versiones de postgresql existentes
            for V_PSQL in "${ALL_POSTGRESQL[@]}"; do
                echo -e "$VE Configurando$RO postgreSQL$VE versión:$AM $V_PSQL$CL"

                ## Archivo de configuración para postgresql
                local POSTGRESCONF="/etc/postgresql/$V_PSQL/main/postgresql.conf"
                echo -e "$VE Archivo de configuración$RO $POSTGRESCONF$CL"

                echo -e "$VE Estableciendo intervalstyle = 'iso_8601'$CL"
                strFileReplace "s/^\s*#?intervalstyle\s*=.*/intervalstyle = 'iso_8601'/" "$POSTGRESCONF"

                echo -e "$VE Estableciendo timezone = 'UTC'$CL"
                strFileReplace "s/^\s*#?timezone\s*=.*/timezone = 'UTC'/" "$POSTGRESCONF"


                local PGHBA="/etc/postgresql/$V_PSQL/main/pg_hba.conf"
                echo -e "$VE Archivo de configuración$RO $PGHBA$CL"

                ## Permito conectar todos los usuarios en entorno local.
                strFileReplace "s/^\s*#?local\s*all\s*all\s*peer/local all all trust/" "$PGHBA"
            done
        fi
    }

    personalizar_postgresql() {
        echo -e "$VE Personalizando$RO postgreSQL$CL"

        if [[ $DISTRO = 'macos' ]]; then
            createuser -s postgres -w
            createdb postgres -O postgres 2> /dev/null
        fi
    }

    postgresql_users_create() {
        echo -e "$VE Crear usuario desarrollador$RO dev$CL"

        if [[ $DISTRO = 'macos' ]]; then
            createuser -P dev
            createdb dev -O dev
            createdb computer -O dev
            psql -U postgres -c "GRANT ALL PRIVILEGES ON DATABASE dev to dev"
            psql -U postgres -c "GRANT ALL PRIVILEGES ON DATABASE computer to dev"
        else
            ## Crea el usuario usuario y pide que teclee su contraseña.
            sudo -u postgres createuser -P dev

            ## Crea la base de datos basedatos para el usuario.
            sudo -u postgres createdb dev -O dev

            ## Creo la base de datos para almacenar información del sistema.
            sudo -u postgres createdb computer -O dev

            ## Asigno permisos para el usuario dev en las DB creadas.
            sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE dev to dev"
            sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE computer to dev"
        fi
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

postgresql_installer() {
    postgresql_descargar
    postgresql_preconfiguracion
    postgresql_instalar
    postgresql_postconfiguracion

    ## Reiniciar servidor postgresql
    reiniciarServicio 'postgresql'
}
