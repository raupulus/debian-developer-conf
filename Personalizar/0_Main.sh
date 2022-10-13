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

############################
##     IMPORTACIONES      ##
############################
source "$WORKSCRIPT/Personalizar/Configurar_GIT.sh"
source "$WORKSCRIPT/Personalizar/gtk.sh"
source "$WORKSCRIPT/Personalizar/fonts.sh"
source "$WORKSCRIPT/Personalizar/icons.sh"
source "$WORKSCRIPT/Personalizar/Terminales.sh"
source "$WORKSCRIPT/Personalizar/cursors.sh"
source "$WORKSCRIPT/Personalizar/qt.sh"
source "$WORKSCRIPT/Personalizar/services.sh"

############################
##       FUNCIONES        ##
############################
menuPersonalizacion() {
    todas_personalizaciones() {
        clear_screen
        echo -e "$VE Instalando todas las personalizaciones$CL"
        configuracion_git
        fonts_install
        icons_install
        cursors_install

        terminales_instalador
        services_enable_disable

        if [[ "${DISTRO}" != 'macos' ]]; then
            gtk_install
            qt_install
        fi

    }

    if [[ "$1" = '-a' ]]; then
        todas_personalizaciones
    else
        while true :; do
            clear_screen
            local descripcion='Menú de Personalización del sistema
                1) Configurar GIT
                2) Tipografías (Fuentes)
                3) Iconos
                4) Cursores
                5) Personalizar GTK
                6) Personalizar QT
                7) Configurar Terminales
                8) Habilitar/Deshabilitar Servicios al iniciar
                9) Todos los pasos anteriores

                0) Atrás
            '
            opciones "$descripcion"

            echo -e "$RO"
            read -p "    Acción → " entrada
            echo -e "$CL"

            case $entrada in

                1)  configuracion_git;;        ## Configurar GIT
                2)  fonts_install;;          ## Tipografías
                3)  icons_install;;            ## Iconos Personalizados
                4)  cursors_install;;          ## Cursores Personalizados
                5)  gtk_install;;              ## Personalizar GTK
                6)  qt_install;;               ## Personalizar QT
                7)  terminales_instalador;;    ## Configurar Terminales
                8)  services_enable_disable;;  ## Configurar servicios
                9)  todas_personalizaciones;;  ## Todos los pasos anteriores

                0)  ## SALIR
                    clear_screen
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
