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
## Menú principal para instalar y configurar Servidores permitiendo
## elegir entre cada uno de ellos desde un menú o todos directamente
## en un proceso automatizado.

############################
##     IMPORTACIONES      ##
############################
source "$WORKSCRIPT/Servidores/apache.sh"
source "$WORKSCRIPT/Servidores/mariaDB.sh"
source "$WORKSCRIPT/Servidores/nodejs.sh"
source "$WORKSCRIPT/Servidores/php.sh"
source "$WORKSCRIPT/Servidores/postgreSQL.sh"
source "$WORKSCRIPT/Servidores/python.sh"

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
        php_instalador
        postgresql_instalador
        python_instalador
    }

    ## Si la función recibe "-a" indica que instale todos los servidores
    if [[ "$1" = '-a' ]]; then
        todos_servidores
    else
        while true :; do
            clear
            local descripcion='Menú de aplicaciones
                1) Apache
                2) MariaDB
                3) NodeJS
                4) PHP
                5) PostgreSQL
                6) Python
                7) Todos los pasos anteriores

                0) Atrás
            '
            opciones "$descripcion"

            echo -e "$RO"
            read -p "    Acción → " entrada
            echo -e "$CL"

            case $entrada in

                1)  apache2_instalador;;     ## Instala servidor Apache2
                2)  mariadb_instalador;;     ## Instala PHP
                3)  nodejs_instalador;;      ## Instala servidores SQL
                4)  php_instalador;;         ## Instala Python
                5)  postgresql_instalador;;  ## Instala servidor NodeJS
                6)  python_instalador;;      ## Instala servidor NodeJS
                7)  todos_servidores         ## Todas las aplicaciones
                    break;;

                0)  ## SALIR
                    clear
                    echo -e "$RO Se sale del menú$CL"
                    echo ''
                    break;;

                *)  ## Acción ante entrada no válida
                    echo ""
                    echo -e "                      $RO ATENCIÓN: Elección no válida$CL";;
            esac
        done
    fi
}
