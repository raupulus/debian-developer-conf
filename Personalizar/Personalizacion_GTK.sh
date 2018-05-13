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
## Este script configura la parte visual que concierne al usuario en temas
## de personalización como temas, cursores, fondo de pantalla, bordes de
## ventanas, iconos, shell...
##
## Además también configura el tema de grub

############################
##       FUNCIONES        ##
############################
configurar_cursores() {
    echo -e "$VE Configurando pack de cursores$CL"
    instalarSoftware 'crystalcursors'

    update-alternatives --set x-cursor-theme /etc/X11/cursors/crystalblue.theme

    sudo update-alternatives --set x-cursor-theme /etc/X11/cursors/crystalblue.theme

    if [[ ! -d "$HOME/.icons" ]]; then
        mkdir "$HOME/.icons"
    fi

    ## Enlazo en el usuario hacia los iconos crystalblue
    if [[ ! -d "$HOME/.icons/default" ]] &&
       [[ -f '/etc/X11/cursors/crystalblue.theme' ]]
    then
        mkdir "$HOME/.icons/default"
        ln -s '/etc/X11/cursors/crystalblue.theme' "$HOME/.icons/default/index.theme"
    fi
}

configurar_temas() {
    echo -e "$VE Configurando temas GTK$CL"
    instalarSoftware 'gtk2-engines-murrine'
    gconftool-2 –type string –set /desktop/gnome/interface/gtk_theme "Flat-Plat-compact"
    gsettings set org.gnome.desktop.interface gtk-theme "Flat-Plat-compact"

    echo -e "$VE Configurando temas QT$CL"
}

configurar_grub() {
    echo -e "$VE Configurando fondo del grub$CL"
    ## Realmente se hace al copiar fondos en la función "configurar_fondos"
}

configurar_fondos() {
    descargarGIT 'Temas Debian' 'https://github.com/fryntiz/Art-for-Debian.git' "$WORKSCRIPT/tmp/Art-for-Debian"

    cd "$WORKSCRIPT/tmp/Art-for-Debian/Temas_Completos/DebBlood" || return 1 && ./install.sh
    cd "$WORKSCRIPT" || return 1

    #echo -e "$VE Configurando$RO fondo de pantalla$CL"
    #sudo cp -r $WORKSCRIPT/tmp/fondos_debian/Temas Completos/DebBlood/usr/share/* '/usr/share/desktop-base/softwaves-theme/'

    #echo -e "$VE Configurando plymouth$CL"
    #sudo cp -r $WORKSCRIPT/usr/share/plymouth/themes/softwaves/* '/usr/share/plymouth/themes/softwaves/'

    ## Configuro thema debblood:
    ## Configuro plymouth
    sudo update-alternatives --install /usr/share/plymouth/themes/default.plymouth default.plymouth /usr/share/plymouth/themes/debblood 100

    ## Configuro fondo de pantalla debblood
    sudo update-alternatives --install /usr/share/images/desktop-base/desktop-background desktop-background /usr/share/desktop-base/debblood/wallpaper/contents/images/1920x1080.svg 65

    sudo update-alternatives --set desktop-background /usr/share/desktop-base/debblood/wallpaper/contents/images/1920x1080.svg

    ## Configuro Fondo de GRUB con debblood
    sudo update-alternatives --install /usr/share/desktop-base/desktop-grub desktop-grub /usr/share/desktop-base/debblood/grub/grub-4x3.png 65
    sudo update-alternatives --install /usr/share/desktop-base/desktop-grub desktop-grub /usr/share/desktop-base/debblood/grub/grub-16x9.png 66

    sudo update-alternatives --set desktop-grub /usr/share/desktop-base/debblood/grub/grub-16x9.png

    ## Configuro Fondo de GDM
    #update-alternatives --set desktop-splash /usr/share/desktop-base/debblood/
}

instalar_flatplat() {
    ## Instalar Flat-Plat
    if [[ -f "$WORKSCRIPT/tmp/Materia_Theme_Flat-Plat/install.sh" ]]; then
        echo -e "$VE Ya esta$RO Flat-Plat$VE descargado, omitiendo paso$CL"

        ## Actualizar repositorio para Flat-Plat
        echo -e "$VE Actualizando Repositorio de$RO Flat-Plat$CL"
        cd "$WORKSCRIPT/tmp/Materia_Theme_Flat-Plat/" || return
        git pull
        cd "$WORKSCRIPT" || return
    else
        ## Descargar desde repositorio
        descargarGIT 'Flat-Plat' 'https://github.com/nana-4/materia-theme.git' "$WORKSCRIPT/tmp/Materia_Theme_Flat-Plat"
    fi

    ## Instalar Flat-Plat, en este punto debe existir instalador
    if [[ -f "$WORKSCRIPT/tmp/Materia_Theme_Flat-Plat/install.sh" ]]; then
        echo -e "$VE Preparando para instalar$RO Tema Flat-Plat$CL"
        cd "$WORKSCRIPT/tmp/Materia_Theme_Flat-Plat/" || return
        sudo ./install.sh
        cd "$WORKSCRIPT" || return
    fi
}

conf_gnome3() {
    echo -e "$VE Configurando gtk3$CL"
    gsettings set org.gnome.desktop.interface gtk-theme "Flat-Plat-compact"
    gsettings set org.gnome.desktop.interface clock-format "24h"
    gsettings set org.gnome.desktop.interface clock-show-date "true"
    gsettings set org.gnome.desktop.interface clock-show-seconds "false"
    gsettings set org.gnome.desktop.interface cursor-theme "crystalblue"
    gsettings set org.gnome.desktop.interface enable-animations "false"
    gsettings set org.gnome.desktop.interface toolkit-accessibility "false"

    gsettings set org.gnome.desktop.session idle-delay "720"
    gsettings set org.gnome.desktop.search-providers disable-external "true"

    gsettings set org.gnome.desktop.privacy hide-identity "true"
    gsettings set org.gnome.desktop.privacy old-files-age "14"
    gsettings set org.gnome.desktop.privacy recent-files-max-age "-1"
    gsettings set org.gnome.desktop.privacy remember-recent-files "false"
    gsettings set org.gnome.desktop.privacy remove-old-temp-files "true"
    gsettings set org.gnome.desktop.privacy remove-old-trash-files "true"
    gsettings set org.gnome.desktop.privacy report-technical-problems "false"
    gsettings set org.gnome.desktop.privacy send-software-usage-stats "false"
    gsettings set org.gnome.desktop.privacy show-full-name-in-top-bar "false"

    gsettings set org.gnome.desktop.peripherals.keyboard delay "300"
    gsettings set org.gnome.desktop.peripherals.keyboard repeat "true"
    gsettings set org.gnome.desktop.peripherals.keyboard repeat-interval "20"
    gsettings set org.gnome.desktop.peripherals.touchpad click-method "none"
    gsettings set org.gnome.desktop.peripherals.touchpad edge-scrolling-enabled "true"
    gsettings set org.gnome.desktop.peripherals.touchpad speed "0.2"
    gsettings set org.gnome.desktop.peripherals.trackball accel-profile "adaptative"

    gsettings set org.gnome.desktop.notifications show-in-lock-screen "false"

    gsettings set org.gnome.desktop.media-handling automount "false"
    gsettings set org.gnome.desktop.media-handling automount-open "false"
    gsettings set org.gnome.desktop.media-handling autorun-never "true"

    gsettings set org.gnome.desktop.input-sources  "[('xkb', 'es'), ('xkb', 'gb+dvorak')]"

    gsettings set org.gnome.desktop.archives default-format "7zip"

    gsettings set org.gnome.desktop.default-applications.terminal 'exec' "tilix"

    gsettings set org.gnome.mutter center-new-windows "true"
    gsettings set org.gnome.mutter dynamic-workspaces "true"
    gsettings set org.gnome.mutter edge-tiling "true"
    gsettings set org.gnome.mutter workspaces-only-on-primary "true"

    gsettings set org.gnome.nautilus.desktop home-icon-visible "false"
    gsettings set org.gnome.nautilus.desktop volumes-visible "false"

    gsettings set org.gnome.nm-applet suppress-wireless-networks-available "true"

    gsettings set org.gnome.settings-daemon.peripherals.keyboard numlock-state "on"
    gsettings set org.gnome.settings-daemon.peripherals.keyboard remember-numlock-state "false"

    ## Plugins
    gsettings set org.gnome.settings-daemon.plugins.xsettings antialiasing "rgba"
    gsettings set org.gnome.settings-daemon.plugins.xsettings hinting "full"

    gsettings set org.gnome.settings-daemon.plugins.power power-button-action "suspend"
    gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-timeout "3600"
}

preconfiguracion_gnome3() {
    echo -e "$VE Instalando software para configurar$RO Gnome-Shell 3$CL"
    instalarSoftware 'dconf-cli' 'dconf-editor' 'dconf-gsettings-backend'
}

conf_gtk2() {
    echo -e "$VE Configurando$RO GTK 2$CL"
    enlazarHome '.config/gtk-2.0'
}

conf_gtk3() {
    echo -e "$VE Configurando$RO GTK 3$CL"
    enlazarHome '.config/gtk-3.0'
}

personalizarGTK() {
    echo -e "$VE Iniciando configuracion de estética general y GTK$CL"
    instalar_flatplat
    configurar_cursores
    configurar_temas
    configurar_grub
    configurar_fondos

    conf_gtk2
    conf_gtk3

    if [[ -f '/usr/bin/gsettings' ]] && [[ -f '/usr/bin/gnome-shell' ]]; then
        preconfiguracion_gnome3
        conf_gnome3
    fi

    sudo update-initramfs -u
}
