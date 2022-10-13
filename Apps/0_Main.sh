#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2017 Raúl Caro Pastorino
## @license    https://wwww.gnu.org/licenses/gpl.txt
## @email      raul@fryntiz.dev
## @web        https://fryntiz.es
## @github     https://github.com/fryntiz
## @gitlab     https://gitlab.com/fryntiz
## @twitter    https://twitter.com/fryntiz
##
##             Applied Style Guide:
## @style      https://gitlab.com/fryntiz/bash-guide-style

############################
##      INSTRUCTIONS      ##
############################
## Menú principal para instalar aplicaciones desde el que se permite
## elegir entre los tipos de aplicaciones a instalar desde un menú
## interactivo seleccionando el número que le corresponda

############################
##     IMPORTACIONES      ##
############################
source "$WORKSCRIPT/Apps/1_Aplicaciones_Basicas.sh"
source "$WORKSCRIPT/Apps/2_Aplicaciones_Extras.sh"
source "$WORKSCRIPT/Apps/desarrollo.sh"
source "$WORKSCRIPT/Apps/firmware.sh"
source "$WORKSCRIPT/Apps/flatpak.sh"
source "$WORKSCRIPT/Apps/grafico.sh"
source "$WORKSCRIPT/Apps/herramientas.sh"
source "$WORKSCRIPT/Apps/internet.sh"
source "$WORKSCRIPT/Apps/juegos.sh"
source "$WORKSCRIPT/Apps/ofimatica.sh"
source "$WORKSCRIPT/Apps/pentesting.sh"
source "$WORKSCRIPT/Apps/servidor-grafico.sh"
source "$WORKSCRIPT/Apps/sonido.sh"
source "$WORKSCRIPT/Apps/video.sh"
source "$WORKSCRIPT/Apps/virtualizacion.sh"
source "$WORKSCRIPT/Apps/vps.sh"
source "$WORKSCRIPT/Apps/IDEs/0_Main.sh"

############################
##       FUNCIONES        ##
############################
##
## Menú para elegir las aplicaciones a instalar
## @param $1 -a Si recibe este parámetro ejecutará todos los scripts
##
menuAplicaciones() {
    todas_aplicaciones() {
        clear_screen
        echo -e "$VE Instalando todas las aplicaciones$CL"
        aplicaciones_basicas
        aplicaciones_firmware
        aplicaciones_desarrollo
        aplicaciones_grafico
        aplicaciones_herramientas
        aplicaciones_internet
        aplicaciones_juegos
        aplicaciones_ofimatica
        aplicaciones_pentesting
        aplicaciones_servidor_grafico
        aplicaciones_sonido
        aplicaciones_video
        aplicaciones_virtualizacion
    }

    ## Si la función recibe "-a" indica que ejecute todas las aplicaciones
    if [[ "$1" = '-a' ]]; then
        todas_aplicaciones
    else
        while true :; do
            clear_screen
            local descripcion='Menú de aplicaciones
                1) Aplicaciones Básicas
                2) Firmware
                3) Desarrollo
                4) Diseño Gráfico
                5) Herramientas
                6) Internet
                7) Juegos
                8) Ofimática
                9) Pentesting
                10) Servidor Gráfico
                11) Sonido
                12) Vídeo
                13) Virtualización

                14) Todos los pasos anteriores completos
            '

            # Opciones solo para Linux
            if [[ "${DISTRO}" != 'macos' ]]; then
                descripcion="${descripcion}
                15) Instalar IDEs
                16) Instalar Aplicaciones Extras
                17) Flatpak
                18) VPS
                "
            fi

            descripcion="${descripcion}
                0) Atrás
                "

            opciones "$descripcion"

            echo -e "$RO"
            read -p "    Acción → " entrada
            echo -e "$CL"

            case $entrada in

                1)  aplicaciones_basicas;;   ## Aplicaciones Básicas
                2)  aplicaciones_firmware;;
                3)  aplicaciones_desarrollo;;
                4)  aplicaciones_grafico;;
                5)  aplicaciones_herramientas;;
                6)  aplicaciones_internet;;
                7)  aplicaciones_juegos;;
                8)  aplicaciones_ofimatica;;
                9)  aplicaciones_pentesting;;
                10) aplicaciones_servidor_grafico;;
                11) aplicaciones_sonido;;
                12) aplicaciones_video;;
                13) aplicaciones_virtualizacion;;
                14) todas_aplicaciones;;     ## Todas las aplicaciones
                15) menuIDES;;               ## Menú para instalar IDEs
                16) aplicaciones_extras;;    ## Aplicaciones Extras
                17) aplicaciones_flatpak;;
                18) aplicaciones_vps
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
