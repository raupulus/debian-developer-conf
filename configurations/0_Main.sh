#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2021 Raúl Caro Pastorino
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
source "$WORKSCRIPT/configurations/hosts.sh"
source "$WORKSCRIPT/configurations/crons.sh"
source "$WORKSCRIPT/configurations/scripts.sh"
source "$WORKSCRIPT/configurations/generic.sh"

###########################
##       FUNCTIONS       ##
###########################
##
## Menú para elegir los servidores a instalar
## @param $1 -a Si recibe este parámetro ejecutará todos los scripts
##
menu_configurations() {
    all_configurations() {
        clear_screen
        echo -e "$VE Aplicando todas las configuraciones al equipo$CL"
        configurations_generic
        configurations_hosts
        configurations_crons
        configurations_scripts
    }

    ## Si la función recibe "-a" indica que instale todas las configuraciones
    if [[ "$1" = '-a' ]]; then
        all_configurations
    else
        while true :; do
            clear_screen
            local descripcion='Menú de Configuraciones
                1) Configurar /etc/hosts con listas de bloqueo
                2) Añadir Scripts en /bin/
                3) Añadir Tareas Crons
                4) Configuraciones genéricas
                5) Todas las configuraciones

                0) Atrás
            '
            opciones "$descripcion"

            echo -e "$RO"
            read -p "    Acción → " entrada
            echo -e "$CL"

            case $entrada in

                1)  configurations_hosts;;     ## Configure /etc/hosts
                2)  configurations_scripts;;  ## Instala Scripts en /bin/
                3)  configurations_crons;;    ## Instala NodeJS
                4)  configurations_generic;;  ## Aplica configuraciones genéricas
                5)  all_configurations        ## Todos los servidores
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
