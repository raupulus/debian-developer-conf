#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2019 Raúl Caro Pastorino
## @license    https://wwww.gnu.org/licenses/gpl.txt
## @email      dev@fryntiz.es
## @web        https://fryntiz.es
## @gitlab     https://gitlab.com/fryntiz
## @github     https://github.com/fryntiz
##
##             Guía de estilos aplicada:
## @style      https://gitlab.com/fryntiz/bash-guide-style

############################
##     INSTRUCCIONES      ##
############################
##

###########################
##       FUNCIONES       ##
###########################
aplicaciones_flatpak() {
    echo -e "$VE Aplicaciones desde Flatpak$CL"
    actualizarRepositorios

    local gimp='https://flathub.org/repo/appstream/org.gimp.GIMP.flatpakref'
    local libreoffice='https://flathub.org/repo/appstream/org.libreoffice.LibreOffice.flatpakref'
    local natron='https://flathub.org/repo/appstream/fr.natron.Natron.flatpakref'
    local kdenlive='https://flathub.org/repo/appstream/org.kde.kdenlive.flatpakref'
    local krita='https://flathub.org/repo/appstream/org.kde.krita.flatpakref'
    local blender='https://flathub.org/repo/appstream/org.blender.Blender.flatpakref'
    local mypaint='https://flathub.org/repo/appstream/org.mypaint.MyPaint.flatpakref'


    while true :; do
        clear
        local descripcion='Menú para instalar paquetes FlatPak
            1) Gimp
            2) LibreOffice
            3) Natron
            4) Kdenlive
            5) Krita
            6) Blender
            7) MyPaint

            0) Atrás
        '
        opciones "$descripcion"

        echo -e "$RO"
        read -p "    Acción → " entrada
        echo -e "$CL"

        case $entrada in

            1)  instalarSoftwareFlatPak $gimp;;
            2)  instalarSoftwareFlatPak $libreoffice;;
            3)  instalarSoftwareFlatPak $natron;;
            4)  instalarSoftwareFlatPak $kdenlive;;
            5)  instalarSoftwareFlatPak $krita;;
            6)  instalarSoftwareFlatPak $blender;;
            7)  instalarSoftwareFlatPak $mypain;;

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
}
