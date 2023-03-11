#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2021 Raúl Caro Pastorino
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
## Menú principal para configurar una raspberry personalizado a mi gusto

############################
##     IMPORTACIONES      ##
############################
source "$WORKSCRIPT/raspberry/add-ram-filesystem.sh"
source "$WORKSCRIPT/raspberry/clone-extra-repositories.sh"
source "$WORKSCRIPT/raspberry/prepare-directories.sh"
source "$WORKSCRIPT/raspberry/piaware.sh"

###########################
##       FUNCIONES       ##
###########################
##
## Menú instalar todas las configuraciones del Root
##
menu_raspberry() {
    echo -e "$RO Preparando Raspberry con personalizaciones extras$CL"

    cd "$WORKSCRIPT"

    while true :; do
        clear_screen

        local descripcion='Menú Principal
            1) Preparar directorios
            2) Añadir sistema de Archivos en Ram /tmp/ramdisk
            3) Clonar repositorios extras en ~/git
            4) Instalar Piaware de FlightAware

            0) Salir
        '
        echo -e "$AZ Versión del script →$RO $VERSION$CL"
        opciones "$descripcion"

        echo -e "$RO"
        read -p '    Acción → ' entrada
        echo -e "$CL"

        case ${entrada} in

            1) prepare_directories;;
            2) add_ram_filesystem;;
            3) clone_extra_repositories;;
            4) install_piaware;;

            0) ## SALIR
              clear_screen
              echo -e "$RO Se sale del menú$CL"
              echo ''
              exit 0;;

            *)  ## Acción ante entrada no válida
              clear_screen
              echo ""
              echo -e "                   $RO ATENCIÓN: Elección no válida$CL";;
        esac
    done
}
