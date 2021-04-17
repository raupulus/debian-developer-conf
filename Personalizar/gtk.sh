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
## Este script configura la parte visual que concierne al usuario en temas
## de personalización como temas, cursores, fondo de pantalla, bordes de
## ventanas, iconos, shell...
##
## Además también configura el tema de grub

############################
##     IMPORTACIONES      ##
############################
source "$WORKSCRIPT/Personalizar/gtk2.sh"
source "$WORKSCRIPT/Personalizar/gtk3.sh"
source "$WORKSCRIPT/Personalizar/gtk4.sh"

############################
##       FUNCIONES        ##
############################
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
        git checkout -- .
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
    echo -e "$VE Configurando gtk3/gtk4$CL"
    gsettings set org.gnome.desktop.interface clock-format "24h"
    gsettings set org.gnome.desktop.interface clock-show-date "true"
    gsettings set org.gnome.desktop.interface clock-show-seconds "false"
    gsettings set org.gnome.desktop.interface gtk-theme "Paper"
    gsettings set org.gnome.desktop.interface icon-theme "Paper"
    gsettings set org.gnome.desktop.interface cursor-theme "Oxygen_Blue"
    #gsettings set org.gnome.desktop.interface cursor-theme "crystalblue"
    gsettings set org.gnome.desktop.interface enable-animations "false"
    gsettings set org.gnome.desktop.interface toolkit-accessibility "false"
    gsettings set org.gnome.desktop.interface show-battery-percentage "true"
    gsettings set org.gnome.desktop.interface cursor-size "32"
    gsettings set org.gnome.desktop.interface font-hinting "full"
    gsettings set org.gnome.desktop.interface toolbar-icons-size "small"

    gsettings set org.gnome.desktop.session idle-delay "720"
    gsettings set org.gnome.desktop.search-providers disable-external "true"

    ## Privacidad
    gsettings set org.gnome.desktop.privacy hide-identity "true"
    gsettings set org.gnome.desktop.privacy old-files-age "14"
    gsettings set org.gnome.desktop.privacy recent-files-max-age "-1"
    gsettings set org.gnome.desktop.privacy remember-recent-files "false"
    gsettings set org.gnome.desktop.privacy remove-old-temp-files "true"
    gsettings set org.gnome.desktop.privacy remove-old-trash-files "true"
    gsettings set org.gnome.desktop.privacy report-technical-problems "false"
    gsettings set org.gnome.desktop.privacy send-software-usage-stats "false"
    gsettings set org.gnome.desktop.privacy show-full-name-in-top-bar "false"
    gsettings set org.gnome.desktop.privacy disable-microphone 'false'
    gsettings set org.gnome.desktop.privacy usb-protection-level 'lockscreen'
    gsettings set org.gnome.desktop.privacy disable-sound-output 'false'
    gsettings set org.gnome.desktop.privacy remember-app-usage 'true'
    gsettings set org.gnome.desktop.privacy disable-camera 'true'
    gsettings set org.gnome.desktop.privacy report-technical-problems 'false'
    gsettings set org.gnome.desktop.privacy usb-protection 'true'

    ## Salvapantallas
    gsettings set org.gnome.desktop.screensaver user-switch-enabled 'true'
    gsettings set org.gnome.desktop.screensaver color-shading-type 'solid'
    gsettings set org.gnome.desktop.screensaver embedded-keyboard-command ''
    gsettings set org.gnome.desktop.screensaver embedded-keyboard-enabled 'false'
    gsettings set org.gnome.desktop.screensaver status-message-enabled 'true'
    gsettings set org.gnome.desktop.screensaver show-full-name-in-top-bar 'true'
    gsettings set org.gnome.desktop.screensaver logout-command ''
    #org.gnome.desktop.screensaver picture-uri 'file:///usr/share/backgrounds/f34/default/f34.xml'
    gsettings set org.gnome.desktop.screensaver idle-activation-enabled 'true'
    gsettings set org.gnome.desktop.screensaver lock-enabled 'true'
    gsettings set org.gnome.desktop.screensaver logout-enabled 'false'
    gsettings set org.gnome.desktop.screensaver primary-color '#023c88'
    gsettings set org.gnome.desktop.screensaver logout-delay 'uint32 7200'
    gsettings set org.gnome.desktop.screensaver picture-opacity '100'
    gsettings set org.gnome.desktop.screensaver picture-options 'zoom'
    gsettings set org.gnome.desktop.screensaver lock-delay 'uint32 0'
    gsettings set org.gnome.desktop.screensaver secondary-color '#5789ca'


    ## Bloqueo de dispositivos
    gsettings set org.gnome.desktop.lockdown mount-removable-storage-devices-as-read-only 'false'
    gsettings set org.gnome.desktop.lockdown disable-command-line 'false'
    gsettings set org.gnome.desktop.lockdown disable-log-out 'false'
    gsettings set org.gnome.desktop.lockdown disable-printing 'false'
    gsettings set org.gnome.desktop.lockdown disable-lock-screen 'false'
    gsettings set org.gnome.desktop.lockdown disable-print-setup 'false'
    gsettings set org.gnome.desktop.lockdown disable-user-switching 'false'
    gsettings set org.gnome.desktop.lockdown disable-application-handlers 'false'
    gsettings set org.gnome.desktop.lockdown disable-save-to-disk 'false'
    gsettings set org.gnome.desktop.lockdown user-administration-disabled 'false'

    ## Montaje automático de dispositivos
    gsettings set org.gnome.desktop.media-handling autorun-never 'true'
    gsettings set org.gnome.desktop.media-handling autorun-x-content-open-folder '[]'
    gsettings set org.gnome.desktop.media-handling automount-open 'false'
    gsettings set org.gnome.desktop.media-handling autorun-x-content-ignore '[]'
    gsettings set org.gnome.desktop.media-handling automount 'false'

    ## Notificaciones
    gsettings set org.gnome.desktop.notifications show-banners 'true'
    gsettings set org.gnome.desktop.notifications show-in-lock-screen 'false'

    ## Teclado
    gsettings set org.gnome.desktop.peripherals.keyboard delay "300"
    gsettings set org.gnome.desktop.peripherals.keyboard repeat "true"
    gsettings set org.gnome.desktop.peripherals.keyboard repeat-interval "20"
    gsettings set org.gnome.desktop.peripherals.touchpad click-method "none"
    gsettings set org.gnome.desktop.peripherals.touchpad edge-scrolling-enabled "true"
    gsettings set org.gnome.desktop.peripherals.touchpad speed "0.2"
    gsettings set org.gnome.desktop.peripherals.trackball accel-profile "adaptative"
    gsettings set org.gnome.desktop.peripherals.keyboard numlock-state 'true'
    gsettings set org.gnome.desktop.peripherals.keyboard remember-numlock-state 'false'

    ## Ratón
    gsettings set org.gnome.desktop.peripherals.mouse natural-scroll 'false'

    ## Eventos de Sonido
    gsettings set org.gnome.desktop.sound event-sounds 'false'
    gsettings set org.gnome.desktop.sound input-feedback-sounds 'false'
    gsettings set org.gnome.desktop.sound allow-volume-above-100-percent 'true'

    ## Nautilus
    gsettings set org.gnome.nautilus.compression default-compression-format "7z"
    gsettings set org.gnome.nautilus.preferences show-directory-item-counts "local-only"
    gsettings set org.gnome.nautilus.preferences default-folder-viewer 'icon-view'
    gsettings set org.gnome.nautilus.preferences show-image-thumbnails 'local-only'
    gsettings set org.gnome.nautilus.preferences show-create-link 'true'




    ## Aplicaciones por defecto
    gsettings set org.gnome.desktop.default-applications.terminal 'exec-arg' "tilix"
    gsettings set org.gnome.desktop.default-applications.terminal 'exec' "tilix"
    gsettings set org.gnome.desktop.default-applications.office.calendar exec 'thunderbird-wayland'






    ## Plugins
    #gsettings set org.gnome.settings-daemon.plugins.xsettings antialiasing "rgba"

    gsettings set org.gnome.settings-daemon.plugins.power power-button-action "suspend"
    #gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-timeout "3600"


    gsettings set org.gnome.nm-applet suppress-wireless-networks-available "true"
    gsettings set org.gnome.desktop.input-sources  "[('xkb', 'es'), ('xkb', 'gb+dvorak')]"




    ## Gedit
    org.gnome.gedit.preferences.editor tabs-size 'uint32 4'


#org.gnome.gedit
#org.gnome.gnome-screenshot
#org.gnome.login-screen
#org.gnome.mutter
#org.gnome.nautilus
#org.gnome.nm-applet
#org.gnome.online-accounts
#org.gnome.SessionManager
#org.gnome.settings-daemon.plugins.power
#org.gnome.settings-daemon.plugins.xsettings
#org.gnome.shell
#org.gnome.software
#org.gnome.system.locale
#org.gnome.system.location
#org.gnome.tweaks
#org.gnome.Weather
#org.gnome.system.smb



}

preconfiguracion_gnome3() {
    echo -e "$VE Instalando software para configurar$RO Gnome-Shell 3$CL"
    instalarSoftwareLista "$SOFTLIST/Personalizar/gnome_shell.lst"
}

conf_gtk2() {
    echo -e "$VE Configurando$RO GTK 2$CL"
    enlazarHome '.config/gtk-2.0'
    gtk2_install
}

conf_gtk3() {
    echo -e "$VE Configurando$RO GTK 3$CL"
    enlazarHome '.config/gtk-3.0'
    gtk3_install
}

conf_gtk4() {
    echo -e "$VE Configurando$RO GTK 4$CL"
    enlazarHome '.config/gtk-4.0'
    gtk4_install
}

gtk_install() {
    echo -e "$VE Iniciando configuracion de estética general y GTK$CL"

    instalarSoftwareLista "$SOFTLIST/Personalizar/gtk.lst"

    instalar_flatplat
    configurar_temas
    configurar_grub
    configurar_fondos

    conf_gtk2
    conf_gtk3
    conf_gtk4

    if [[ -f '/usr/bin/gsettings' ]] && [[ -f '/usr/bin/gnome-shell' ]]; then
        preconfiguracion_gnome3
        conf_gnome3
    fi

    sudo update-initramfs -u
}
