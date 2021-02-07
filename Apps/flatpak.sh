#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2019 Raúl Caro Pastorino
## @license    https://wwww.gnu.org/licenses/gpl.txt
## @email      raul@fryntiz.dev
## @web        https://fryntiz.es
## @gitlab     https://gitlab.com/fryntiz
## @github     https://github.com/fryntiz
##
##             Applied Style Guide:
## @style      https://gitlab.com/fryntiz/bash-guide-style

############################
##      INSTRUCTIONS      ##
############################
##

###########################
##       FUNCIONES       ##
###########################
aplicaciones_flatpak() {
    echo -e "$VE Aplicaciones desde Flatpak$CL"
    actualizarRepositorios

    ## Compruebo si está instalado flatpak, sino instenta instalarlo
    if [[ ! -f '/usr/bin/flatpak' ]]; then
        instalarSoftware 'flatpak'
    fi

    local gimp='https://flathub.org/repo/appstream/org.gimp.GIMP.flatpakref'
    local libreoffice='https://flathub.org/repo/appstream/org.libreoffice.LibreOffice.flatpakref'
    local natron='https://flathub.org/repo/appstream/fr.natron.Natron.flatpakref'
    local kdenlive='https://flathub.org/repo/appstream/org.kde.kdenlive.flatpakref'
    local krita='https://flathub.org/repo/appstream/org.kde.krita.flatpakref'
    local blender='https://flathub.org/repo/appstream/org.blender.Blender.flatpakref'
    local mypaint='https://flathub.org/repo/appstream/org.mypaint.MyPaint.flatpakref'
    local brackets='https://flathub.org/repo/appstream/io.brackets.Brackets.flatpakref'
    local arduino='https://flathub.org/repo/appstream/cc.arduino.arduinoide.flatpakref'
    local dbeaver='https://flathub.org/repo/appstream/io.dbeaver.DBeaverCommunity.flatpakref'
    local atom='https://flathub.org/repo/appstream/io.atom.Atom.flatpakref'
    local mumble='https://flathub.org/repo/appstream/info.mumble.Mumble.flatpakref'
    local synfig='https://flathub.org/repo/appstream/org.synfig.SynfigStudio.flatpakref'
    local xnconvert='https://flathub.org/repo/appstream/com.xnview.XnConvert.flatpakref'
    local anydesk='https://flathub.org/repo/appstream/com.anydesk.Anydesk.flatpakref'
    local gitkraken='https://flathub.org/repo/appstream/com.axosoft.GitKraken.flatpakref'
    local librepcb='https://flathub.org/repo/appstream/org.librepcb.LibrePCB.flatpakref'
    local playonlinux='https://flathub.org/repo/appstream/org.phoenicis.playonlinux.flatpakref'
    local androidstudio='https://flathub.org/repo/appstream/com.google.AndroidStudio.flatpakref'
    local riot='https://flathub.org/repo/appstream/im.riot.Riot.flatpakref'
    local discord='https://flathub.org/repo/appstream/com.discordapp.Discord.flatpakref'
    local postman='https://flathub.org/repo/appstream/com.getpostman.Postman.flatpakref'


    while true :; do
        clear_screen
        local descripcion='Menú para instalar paquetes FlatPak
            1) Gimp
            2) LibreOffice
            3) Natron
            4) Kdenlive
            5) Krita
            6) Blender
            7) MyPaint
            8) Brackets
            9) Arduino
            10) DBeaver
            11) Atom
            12) Mumble
            13) Synfig
            14) XnConvert
            15) Anydesk
            16) GitKraken
            17) LibrePCB
            18) PlayOnLinux
            19) AndroidStudio
            20) Riot
            21) Discord
            22) Postman

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
            8)  instalarSoftwareFlatPak $brackets;;
            9)  instalarSoftwareFlatPak $arduino;;
            10)  instalarSoftwareFlatPak $dbeaver;;
            11)  instalarSoftwareFlatPak $atom;;
            12)  instalarSoftwareFlatPak $mumble;;
            13)  instalarSoftwareFlatPak $synfig;;
            14)  instalarSoftwareFlatPak $xnconvert;;
            15)  instalarSoftwareFlatPak $anydesk;;
            16)  instalarSoftwareFlatPak $gitkraken;;
            17)  instalarSoftwareFlatPak $librepcb;;
            18)  instalarSoftwareFlatPak $playonlinux;;
            19)  instalarSoftwareFlatPak $androidstudio;;
            20)  instalarSoftwareFlatPak $riot;;
            21)  instalarSoftwareFlatPak $discord;;
            22)  instalarSoftwareFlatPak $postman;;

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
}
