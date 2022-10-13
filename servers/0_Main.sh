#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2017 Raúl Caro Pastorino
## @license    https://wwww.gnu.org/licenses/gpl.txt
## @email      raul@fryntiz.dev
## @web        https://fryntiz.es
## @gitlab     https://gitlab.com/fryntiz
## @github     https://github.com/fryntiz
## @twitter    https://twitter.com/fryntiz
##
##             Applied Style Guide:
## @style      https://gitlab.com/fryntiz/bash-guide-style

############################
##      INSTRUCTIONS      ##
############################
## Menú principal para instalar y configurar Servidores permitiendo
## elegir entre cada uno de ellos desde un menú o todos directamente
## en un proceso automatizado.

############################
##     IMPORTACIONES      ##
############################
source "$WORKSCRIPT/servers/apache2/install.sh"
source "$WORKSCRIPT/servers/bind.sh"
source "$WORKSCRIPT/servers/mariaDB.sh"
source "$WORKSCRIPT/servers/nodejs.sh"
source "$WORKSCRIPT/servers/postgreSQL.sh"
source "$WORKSCRIPT/servers/docker.sh"
source "$WORKSCRIPT/servers/ssh.sh"
source "$WORKSCRIPT/servers/mongodb.sh"
source "$WORKSCRIPT/servers/sqlite.sh"
source "$WORKSCRIPT/servers/mumble.sh"
source "$WORKSCRIPT/servers/gocd.sh"
source "$WORKSCRIPT/servers/nginx.sh"

###########################
##       FUNCIONES       ##
###########################
##
## Menú para elegir los servidores a instalar
## @param $1 -a Si recibe este parámetro ejecutará todos los scripts
##
menuServidores() {
    todos_servidores() {
        clear_screen
        echo -e "$VE Instalando todos los servidores$CL"
        apache2_installer
        mariadb_instalador
        nodejs_instalador
        postgresql_installer
        docker_installer
        ssh_instalador
        mongodb_instalador
        sqlite_instalador
    }

    ## Si la función recibe "-a" indica que instale todos los servidores
    if [[ "$1" = '-a' ]]; then
        todos_servidores
    else
        while true :; do
            clear_screen
            local descripcion='Menú de Servidores y Lenguajes de programación
                1) Apache
                2) MariaDB
                3) NodeJS
                4) PostgreSQL
                5) Docker
                6) Ssh
                7) MongoDB
                8) Sqlite 3
                9) Todos los servidores anteriores

                10) Bind 9
                11) Mumble
                12) Postfix y Dovecot (Mail)
                13) Nginx
                14) GoCD (Agent y Server)

                0) Atrás
            '
            opciones "$descripcion"

            echo -e "$RO"
            read -p "    Acción → " entrada
            echo -e "$CL"

            case $entrada in

                1)  apache2_installer;;      ## Instala Apache2
                2)  mariadb_instalador;;     ## Instala MariaDB
                3)  nodejs_instalador;;      ## Instala NodeJS
                4)  postgresql_installer;;  ## Instala PostgreSQL
                5)  docker_installer;;       ## Instala Docker
                6)  ssh_instalador;;         ## Instala Ssh
                7)  mongodb_instalador;;     ## Instala MongoDB
                8)  sqlite_instalador;;      ## Instala Sqlite
                9) todos_servidores;;        ## Todos los servidores

                10)  bind_instalador;;       ## Instala Bind
                11)  mumble_instalador;;     ## Instala Mumble
                12)  postfix_instalador;;    ## Instala Mumble
                13)  nginx_installer;;       ## Instala Nginx
                14)  gocd_installer          ## Instala Servidor Mail
                     break;;

                0)  ## SALIR
                    clear_screen
                    echo -e "$RO Se sale del menú$CL"
                    echo ''
                    break;;

                *)  ## Acción ante entrada no válida
                    echo ""
                    echo -e "             $RO ATENCIÓN: Elección no válida$CL";;
            esac
        done
    fi
}
