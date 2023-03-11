#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2017 Raúl Caro Pastorino
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
    descargarGIT 'Temas Debian' 'https://github.com/raupulus/Art-for-Debian.git' "$WORKSCRIPT/tmp/Art-for-Debian"

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
    gsettings set org.gnome.desktop.interface cursor-size "40"
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
    gsettings set org.gnome.nautilus.icon-view captions "['size', 'none', 'none']"
    gsettings set org.gnome.nautilus.icon-view default-zoom-level 'large'
    gsettings set org.gnome.nautilus.icon-view text-ellipsis-limit "['3']"
    gsettings set org.gnome.nautilus.preferences show-directory-item-counts "local-only"
    gsettings set org.gnome.nautilus.preferences default-folder-viewer 'icon-view'
    gsettings set org.gnome.nautilus.preferences show-image-thumbnails 'local-only'
    gsettings set org.gnome.nautilus.preferences show-create-link 'true'
    gsettings set org.gnome.nautilus.window-state sidebar-width "241"
    gsettings set org.gnome.nautilus.window-state start-with-location-bar "true"
    gsettings set org.gnome.nautilus.window-state initial-size "(1174, 827)"
    gsettings set org.gnome.nautilus.window-state start-with-sidebar "true"
    gsettings set org.gnome.nautilus.window-state maximized "false"
    gsettings set org.gnome.nautilus.preferences search-filter-time-type 'last_modified'
    gsettings set org.gnome.nautilus.preferences default-sort-order 'name'
    gsettings set org.gnome.nautilus.preferences open-folder-on-dnd-hover "true"
    gsettings set org.gnome.nautilus.preferences default-sort-in-reverse-order "false"
    gsettings set org.gnome.nautilus.preferences show-hidden-files "false"
    gsettings set org.gnome.nautilus.preferences tabs-open-position 'after-current-tab'
    gsettings set org.gnome.nautilus.preferences always-use-location-entry "false"
    gsettings set org.gnome.nautilus.preferences search-view 'list-view'
    gsettings set org.gnome.nautilus.preferences thumbnail-limit "uint64 50"
    gsettings set org.gnome.nautilus.preferences mouse-back-button "8"
    gsettings set org.gnome.nautilus.preferences click-policy 'double'
    gsettings set org.gnome.nautilus.preferences mouse-forward-button "9"
    gsettings set org.gnome.nautilus.preferences mouse-use-extra-buttons "true"
    gsettings set org.gnome.nautilus.preferences show-delete-permanently "false"
    gsettings set org.gnome.nautilus.preferences use-experimental-views "false"
    gsettings set org.gnome.nautilus.preferences fts-enabled "true"
    gsettings set org.gnome.nautilus.preferences default-folder-viewer 'icon-view'
    gsettings set org.gnome.nautilus.preferences install-mime-activation "true"
    gsettings set org.gnome.nautilus.list-view default-zoom-level 'standard'
    gsettings set org.gnome.nautilus.list-view use-tree-view "false"
    gsettings set org.gnome.nautilus.list-view default-visible-columns "['name', 'size', 'date_modified', 'starred']"
    gsettings set org.gnome.nautilus.list-view default-column-order "['name', 'size', 'type', 'owner', 'group', 'permissions', 'mime_type', 'where', 'date_modified', 'date_modified_with_time', 'date_accessed', 'date_created', 'recency', 'starred']"




    ## Aplicaciones por defecto
    gsettings set org.gnome.desktop.default-applications.terminal 'exec-arg' "tilix"
    gsettings set org.gnome.desktop.default-applications.terminal 'exec' "tilix"
    gsettings set org.gnome.desktop.default-applications.office.calendar exec 'thunderbird-wayland'


    ## Geoposicionamiento
    gsettings set org.gnome.system.location enabled "false"



    ## Plugins
    #gsettings set org.gnome.settings-daemon.plugins.xsettings antialiasing "rgba"

    gsettings set org.gnome.settings-daemon.plugins.power power-button-action "suspend"
    #gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-timeout "3600"


    gsettings set org.gnome.nm-applet suppress-wireless-networks-available "true"
    gsettings set org.gnome.desktop.input-sources  "[('xkb', 'es'), ('xkb', 'gb+dvorak')]"




    ## Gedit
    gsettings set org.gnome.gedit.plugins active-plugins "['filebrowser', 'git', 'drawspaces', 'time', 'pythonconsole', 'terminal', 'quickhighlight', 'spell', 'externaltools', 'smartspaces', 'commander', 'docinfo', 'findinfiles', 'modelines', 'bracketcompletion', 'wordcompletion', 'colorpicker', 'codecomment']"
    gsettings set org.gnome.gedit.preferences.editor auto-save-interval "uint32 10"
    gsettings set org.gnome.gedit.preferences.editor wrap-last-split-mode 'word'
    gsettings set org.gnome.gedit.preferences.editor use-default-font "true"
    gsettings set org.gnome.gedit.preferences.editor tabs-size "uint32 4"
    gsettings set org.gnome.gedit.preferences.editor auto-save "false"
    gsettings set org.gnome.gedit.preferences.editor background-pattern 'none'
    gsettings set org.gnome.gedit.preferences.editor smart-home-end 'after'
    gsettings set org.gnome.gedit.preferences.editor search-highlighting "true"
    gsettings set org.gnome.gedit.preferences.editor scheme 'monokai-extended'
    gsettings set org.gnome.gedit.preferences.editor editor-font 'Monospace 12'
    gsettings set org.gnome.gedit.preferences.editor bracket-matching "true"
    gsettings set org.gnome.gedit.preferences.editor syntax-highlighting "true"
    gsettings set org.gnome.gedit.preferences.editor display-right-margin "true"
    gsettings set org.gnome.gedit.preferences.editor insert-spaces "true"
    gsettings set org.gnome.gedit.preferences.editor max-undo-actions "2000"
    gsettings set org.gnome.gedit.preferences.editor restore-cursor-position "true"
    gsettings set org.gnome.gedit.preferences.editor highlight-current-line "true"
    gsettings set org.gnome.gedit.preferences.editor display-line-numbers "true"
    gsettings set org.gnome.gedit.preferences.editor auto-indent "true"
    gsettings set org.gnome.gedit.preferences.editor wrap-mode 'word'
    gsettings set org.gnome.gedit.preferences.editor ensure-trailing-newline "true"
    gsettings set org.gnome.gedit.preferences.editor right-margin-position "uint32 120"
    gsettings set org.gnome.gedit.preferences.editor create-backup-copy "false"
    gsettings set org.gnome.gedit.preferences.encodings candidate-encodings "['']"
    gsettings set org.gnome.gedit.preferences.print print-header "true"
    gsettings set org.gnome.gedit.preferences.print print-font-header-pango 'Sans 11'
    gsettings set org.gnome.gedit.preferences.print print-line-numbers "uint32 0"
    gsettings set org.gnome.gedit.preferences.print print-font-numbers-pango 'Sans 8'
    gsettings set org.gnome.gedit.preferences.print margin-top "15.0"
    gsettings set org.gnome.gedit.preferences.print margin-left "25.0"
    gsettings set org.gnome.gedit.preferences.print margin-right "25.0"
    gsettings set org.gnome.gedit.preferences.print print-font-body-pango 'Monospace 9'
    gsettings set org.gnome.gedit.preferences.print print-syntax-highlighting "true"
    gsettings set org.gnome.gedit.preferences.print margin-bottom "25.0"
    gsettings set org.gnome.gedit.preferences.print print-wrap-mode 'word'
    gsettings set org.gnome.gedit.preferences.ui statusbar-visible "true"
    gsettings set org.gnome.gedit.preferences.ui bottom-panel-visible "false"
    gsettings set org.gnome.gedit.preferences.ui side-panel-visible "false"
    gsettings set org.gnome.gedit.preferences.ui show-tabs-mode 'auto'
    gsettings set org.gnome.gedit.state.file-chooser filter-id "0"
    gsettings set org.gnome.gedit.state.file-chooser open-recent "true"
    gsettings set org.gnome.gedit.state.history-entry replace-with-entry "['']"
    gsettings set org.gnome.gedit.state.history-entry search-for-entry "['']"
    gsettings set org.gnome.gedit.state.window bottom-panel-size "140"
    gsettings set org.gnome.gedit.state.window side-panel-size "200"
    gsettings set org.gnome.gedit.state.window side-panel-active-page 'GeditWindowDocumentsPanel'
    gsettings set org.gnome.gedit.state.window bottom-panel-active-page 'GeditPythonConsolePanel'
    gsettings set org.gnome.gedit.state.window size "(900, 700)"
    gsettings set org.gnome.gedit.state.window state "87168"

    ## nm-applet
    gsettings set org.gnome.nm-applet show-applet "true"
    gsettings set org.gnome.nm-applet disable-disconnected-notifications "false"
    gsettings set org.gnome.nm-applet disable-wifi-create "false"
    gsettings set org.gnome.nm-applet suppress-wireless-networks-available "true"
    gsettings set org.gnome.nm-applet disable-vpn-notifications "false"
    gsettings set org.gnome.nm-applet disable-connected-notifications "false"
    gsettings set org.gnome.nm-applet stamp "0"

    ## Energía
    gsettings set org.gnome.settings-daemon.plugins.power idle-dim "true"
    gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-type 'suspend'
    gsettings set org.gnome.settings-daemon.plugins.power idle-brightness "30"
    gsettings set org.gnome.settings-daemon.plugins.power ambient-enabled "true"
    gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type 'nothing'
    gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-timeout "1200"
    gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-timeout "3600"
    gsettings set org.gnome.settings-daemon.plugins.power power-button-action 'suspend'

    ## Gnome Tweaks
    gsettings set org.gnome.tweaks show-extensions-notice "false"

    ## Gnome Weather
    gsettings set org.gnome.Weather automatic-location "false"

    ## Gnome Software
    gsettings set org.gnome.software download-updates-notify "false"
    gsettings set org.gnome.software download-updates "false"
    gsettings set org.gnome.software show-nonfree-prompt "true"
    gsettings set org.gnome.software show-ratings "true"
    gsettings set org.gnome.software refresh-when-metered "false"
    gsettings set org.gnome.software show-nonfree-ui "true"
    gsettings set org.gnome.software prompt-for-nonfree "true"
    gsettings set org.gnome.software first-run "false"
    gsettings set org.gnome.software allow-updates "false"
    gsettings set org.gnome.software install-bundles-system-wide "true"
    gsettings set org.gnome.software enable-repos-dialog "true"
    gsettings set org.gnome.software show-upgrade-prerelease "true"



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
