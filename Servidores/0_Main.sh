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
## Menú principal para instalar y configurar Servidores permitiendo
## elegir entre cada uno de ellos desde un menú o todos directamente
## en un proceso automatizado.

############################
##     IMPORTACIONES      ##
############################
source "$WORKSCRIPT/Servidores/apache2/install.sh"
source "$WORKSCRIPT/Servidores/bind.sh"
source "$WORKSCRIPT/Servidores/mariaDB.sh"
source "$WORKSCRIPT/Servidores/nodejs.sh"
source "$WORKSCRIPT/Servidores/postgreSQL.sh"
source "$WORKSCRIPT/Servidores/docker.sh"
source "$WORKSCRIPT/Servidores/ssh.sh"
source "$WORKSCRIPT/Servidores/mongodb.sh"
source "$WORKSCRIPT/Servidores/sqlite.sh"
source "$WORKSCRIPT/Servidores/mumble.sh"

###########################
##       FUNCIONES       ##
###########################
##
## Menú para elegir los servidores a instalar
## @param $1 -a Si recibe este parámetro ejecutará todos los scripts
##
menuServidores() {
    todos_servidores() {
        clear
        echo -e "$VE Instalando todos los servidores$CL"
        apache2_instalador
        mariadb_instalador
        nodejs_instalador
        postgresql_instalador
        docker_instalador
        ssh_instalador
        mongodb_instalador
        sqlite_instalador
    }

    ## Si la función recibe "-a" indica que instale todos los servidores
    if [[ "$1" = '-a' ]]; then
        todos_servidores
    else
        while true :; do
            clear
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

                0) Atrás
            '
            opciones "$descripcion"

            echo -e "$RO"
            read -p "    Acción → " entrada
            echo -e "$CL"

            case $entrada in

                1)  apache2_instalador;;     ## Instala Apache2
                2)  mariadb_instalador;;     ## Instala MariaDB
                3)  nodejs_instalador;;      ## Instala NodeJS
                4)  postgresql_instalador;;  ## Instala PostgreSQL
                5)  docker_instalador;;      ## Instala Docker
                6)  ssh_instalador;;         ## Instala Ssh
                7)  mongodb_instalador;;     ## Instala MongoDB
                8)  sqlite_instalador;;      ## Instala Sqlite
                9) todos_servidores;;          ## Todos los servidores

                10)  bind_instalador;;       ## Instala Bind
                11)  mumble_instalador;;     ## Instala Mumble
                12)  postfix_instalador    ## Instala Servidor Mail
                     break;;

                0)  ## SALIR
                    clear
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
