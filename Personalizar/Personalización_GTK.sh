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

###########################
##       FUNCIONES       ##
###########################
configurar_cursores() {
    echo -e "$VE Configurando pack de cursores$CL"
    instalarSoftware 'crystalcursors'

    sudo update-alternatives --set x-cursor-theme /etc/X11/cursors/crystalblue.theme 2>> /dev/null
}

configurar_temas() {
    echo -e "$VE Configurando temas GTK$CL"
    ## TODO → Establecer Flat-Plat como tema activo por defecto

    #echo -e "$VE Configurando temas QT$CL"
}

configurar_grub() {
    echo -e "$VE Configurando fondo del grub$CL"
    ## Realmente se hace al copiar fondos en la función "configurar_fondos"
}

configurar_fondos() {
    echo -e "$VE Configurando$RO fondo de pantalla$CL"
    sudo cp -r $WORKSCRIPT/usr/share/desktop-base/softwaves-themes/* '/usr/share/desktop-base/softwaves-theme/'
    echo -e "$VE Configurando plymouth$CL"
    sudo cp -r $WORKSCRIPT/usr/share/plymouth/themes/softwaves/* '/usr/share/plymouth/themes/softwaves/'
}

instalar_flatplat() {
    ## Instalar Flat-Plat
    if [[ -f "$WORKSCRIPT/tmp/Materia_Theme_Flat-Plat/install.sh" ]]; then
        echo -e "$VE Ya esta$RO Flat-Plat$VE descargado, omitiendo paso$CL"

        ## Actualizar repositorio para Flat-Plat
        echo -e "$VE Actualizando Repositorio de$RO Flat-Plat$CL"
        cd "$WORKSCRIPT/tmp/Materia_Theme_Flat-Plat/"
        git pull
        cd "$WORKSCRIPT"
    else
        ## Descargar desde repositorio
        descargarGIT 'Flat-Plat' 'https://github.com/nana-4/materia-theme.git' "$WORKSCRIPT/tmp/Materia_Theme_Flat-Plat"
    fi

    ## Instalar Flat-Plat, en este punto debe existir instalador
    if [[ -f "$WORKSCRIPT/tmp/Materia_Theme_Flat-Plat/install.sh" ]]; then
        echo -e "$VE Preparando para instalar$RO Tema Flat-Plat$CL"
        cd "$WORKSCRIPT/tmp/Materia_Theme_Flat-Plat/"
        sudo ./install.sh
        cd "$WORKSCRIPT"
    fi
}

configurar_iconos() {
    descargar 'Paper_Theme.deb' 'https://snwh.org/paper/download.php?owner=snwh&ppa=pulp&pkg=paper-gtk-theme,16.04'

    echo -e "$VE Preparando para instalar$RO Iconos Paper_Theme$CL"
    instalarSoftwareDPKG "$WORKSCRIPT/tmp/Paper_Theme.deb"
}

personalizar() {
    echo -e "$VE Iniciando configuracion de estética general y GTK$CL"
    instalar_flatplat
    configurar_iconos
    configurar_cursores
    configurar_temas
    configurar_grub
    configurar_fondos
}
