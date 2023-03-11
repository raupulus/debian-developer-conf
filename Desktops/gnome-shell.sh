#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2018 Raúl Caro Pastorino
## @license    https://wwww.gnu.org/licenses/gpl.txt
## @email      public@raupulus.dev
## @web        https://raupulus.dev
## @gitlab     https://gitlab.com/raupulus
## @github     https://github.com/raupulus
## @twitter    https://twitter.com/raupulus
##
##             Applied Style Guide:
## @style      https://gitlab.com/raupulus/bash-guide-style

############################
##      INSTRUCTIONS      ##
############################
## Plantea la instalación de gnome_shell con las configuraciones

############################
##       FUNCIONES        ##
############################

##
## Crea un nuevo atajo de teclado recibiendo el nombre, atajo y comando.
## Ejemplo de llamada: gnome_shell_create_custom_shortcut "Abrir aplicación de notas" "QOwnNotes" "<Super>n"
##
## TOFIX → Cuando se ejecuta varias veces, duplica el comando
##
## $1 Nombre  Ex: "Abrir aplicación de notas"
## $2 Comando Ex: "QOwnNotes"
## $3 Teclas  Ex: "<Super>n"
gnome_shell_create_custom_shortcut() {
    ## Comando de gsettings para la configuración de atajos personalizados
    CMD_GSETTINGS="gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding"

    ## Ruta base para los atajos personalizados
    KEY_PATH_BASE="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings"

    # Almaceno todos los atajos ya existentes
    EXISTED_PATHS=$(gsettings get org.gnome.settings-daemon.plugins.media-keys custom-keybindings)

    ## Busco cuantas combinaciones de teclas hay definidas para crear un nuevo valor como índice para la nueva
    NEW_KEY_INDEX=$(dconf list /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/ | wc -l)

    ## Genero la nueva ruta conteniendo también el nuevo índice
    NEW_KEY_PATH="${KEY_PATH_BASE}/custom${NEW_KEY_INDEX}/"

    if [[ $NEW_KEY_INDEX -gt 0 ]]; then
      NEW_PATHS=${EXISTED_PATHS%]},\ \'${NEW_KEY_PATH}\'\]  # Add the new custom folder into `custom-keybindings` key
    else
      NEW_PATHS="[\'$NEW_KEY_PATH\']"
    fi

    ## Agrega el nuevo directorio para los atajos
    gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "${NEW_PATHS}"

    if [[ $# -eq 3 ]]; then
        ## Establece el nombre
        $CMD_GSETTINGS:$NEW_KEY_PATH name "$1"

        ## Establece el comando
        $CMD_GSETTINGS:$NEW_KEY_PATH command "$2"

        ## Establece teclas
        $CMD_GSETTINGS:$NEW_KEY_PATH binding "$3"
    fi

    #########################################################################################
    # Alternatively, you can put the gsetting key value to set literally to avoid parameters typing errors.
    # $CMD_GSETTINGS:$NEW_KEY_PATH name "Select an area to screenshot"
    # $CMD_GSETTINGS:$NEW_KEY_PATH command "flameshot gui"
    # $CMD_GSETTINGS:$NEW_KEY_PATH binding "F1"
}

gnome_shell_preconfiguracion() {
    echo -e "$VE Generando Pre-Configuraciones de$RO Gnome Shell$CL"
    instalarSoftwareLista "$SOFTLIST/Desktops/wayland-base.lst"
    instalarSoftwareLista "$SOFTLIST/Desktops/x11-base.lst"
}

gnome_shell_instalar() {
    echo -e "$VE Preparando para instalar$RO Gnome Shell$CL"
    instalarSoftwareLista "$SOFTLIST/Desktops/gnome.lst"
}

##
## Instalando software extra y configuraciones adicionales
##
gnome_shell_postconfiguracion() {
    echo -e "$VE Generando Post-Configuraciones$RO Gnome Shell$CL"

    echo -e "$VE Instalando software secundario$CL"
    instalarSoftwareLista "$SOFTLIST/Desktops/gnome-extensions.lst"

    echo -e "$VE Generando archivos de configuración$CL"
    enlazarHome '.config/geany' '.config/gtk-2.0' '.config/gtk-3.0' '.config/gtk-4.0'

    ## Creo atajos de teclado

    if [[ -f '/usr/bin/QOwnNotes' ]]; then
        gnome_shell_create_custom_shortcut "Abrir aplicación de notas" "QOwnNotes" "<Super>n"
    fi

    if [[ -f '/usr/bin/keepass2' ]]; then
        gnome_shell_create_custom_shortcut "Keepass2" "keepass2" "<Super>k"
    elif [[ -f '/usr/bin/keepass' ]]; then
       gnome_shell_create_custom_shortcut "Keepass" "keepass" "<Super>k"
    fi
}

gnome_shell_postconfiguracionOpcional() {
    echo -e "$VE Generando Post-Configuraciones Opcionales$RO Gnome Shell$CL"

    # Listar propiedades
    #gsettings list-recursively org.gnome.shell.keybindings
    #gsettings list-recursively org.gnome.desktop.wm.keybindings

    ## Ver valores posibles de una propiedad
    #gsettings range org.gnome.desktop.wm.preferences visual-bell-type

    ## Teclas especiales
    # <Control>,<Shift>,<Alt>,<Super>,Right,Left,Up,Down,Tab,Super_L,Control_L

    ## Listar todos los keybind
    # gsettings list-recursively | grep keybindings

    ## Listar los atajos personalizados
    # gsettings list-recursively org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/

    ## Cantidad de escritorios
    gsettings set org.gnome.desktop.wm.preferences num-workspaces '10'

    ## No mostrar iconos en el escritorio
    gsettings set org.gnome.desktop.background show-desktop-icons 'false'

    ## Calendario
    gsettings set org.gnome.desktop.calendar show-weekdate 'false'
    gsettings set org.gnome.desktop.datetime automatic-timezone 'false'

    ##################
    ## Ventanas y escritorios
    #################

    ## Minimizar al dock
    gsettings set org.gnome.desktop.wm.keybindings minimize "['<Super>comma']"

    ## Bloquear ventana mostrándose siempre encima de las demás
    gsettings set org.gnome.desktop.wm.keybindings always-on-top "['<Super><Shift>U']"

    ## Redimensionar
    gsettings set org.gnome.desktop.wm.keybindings begin-resize "['<Alt>F8']"

    ## Mover
    gsettings set org.gnome.desktop.wm.keybindings begin-move "['<Alt>F7']"

    ## Cambiar fuente de entrad de teclado
    gsettings set org.gnome.desktop.wm.keybindings switch-input-source "['<Super>space', 'XF86Keyboard']"

    ## Abrir menú de la ventana
    gsettings set org.gnome.desktop.wm.keybindings activate-window-menu "['<Alt>space']"

    ## Configuración de mutter
    gsettings set org.gnome.mutter center-new-windows "true"
    gsettings set org.gnome.mutter dynamic-workspaces "false"
    gsettings set org.gnome.mutter edge-tiling "true"
    gsettings set org.gnome.mutter workspaces-only-on-primary "true"
    gsettings set org.gnome.mutter overlay-key 'Super_L'
    gsettings set org.gnome.mutter focus-change-on-pointer-rest "true"
    gsettings set org.gnome.mutter draggable-border-width "15"
    gsettings set org.gnome.mutter auto-maximize "true"
    gsettings set org.gnome.mutter attach-modal-dialogs "true"
    gsettings set org.gnome.mutter locate-pointer-key 'Control_L'
    gsettings set org.gnome.mutter check-alive-timeout "uint32 5000"
    gsettings set org.gnome.mutter no-tab-popup "false"
    gsettings set org.gnome.mutter.keybindings tab-popup-cancel "[]"
    gsettings set org.gnome.mutter.keybindings tab-popup-select "[]"
    gsettings set org.gnome.mutter.keybindings rotate-monitor "[]"
    gsettings set org.gnome.mutter.keybindings switch-monitor "[]"

    ## Mueve la ventana a media pantalla ocupando todo el alto
    gsettings set org.gnome.mutter.keybindings toggle-tiled-right "['<Shift><Super>Right']"
    gsettings set org.gnome.mutter.keybindings toggle-tiled-left "['<Shift><Super>Left']"

    ## Sesion Manager
    gsettings set org.gnome.SessionManager auto-save-session "false"
    gsettings set org.gnome.SessionManager auto-save-session-one-shot "false"
    gsettings set org.gnome.SessionManager show-fallback-warning "true"
    gsettings set org.gnome.SessionManager logout-prompt "true"


    ## Toggle ventana a pantalla completa y maximizada
    gsettings set org.gnome.desktop.wm.keybindings toggle-maximized "['<Super>f']"
    gsettings set org.gnome.desktop.wm.keybindings toggle-fullscreen "['<Super><Shift>f']"

    ## Cerrar aplicación
    gsettings set org.gnome.desktop.wm.keybindings close "['<Super><Shift>q']"

    ## Diálogo para ejecutar
    gsettings set org.gnome.desktop.wm.keybindings panel-run-dialog "['<Alt>F2']"

    ## Switch entre aplicaciones abiertas
    gsettings set org.gnome.desktop.wm.keybindings switch-applications "['<Super>Tab']"

    ## Mover entre escritorios
    gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-1 "['<Super><Shift>1']"
    gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-2 "['<Super><Shift>2']"
    gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-3 "['<Super><Shift>3']"
    gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-4 "['<Super><Shift>4']"
    gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-5 "['<Super><Shift>5']"
    gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-6 "['<Super><Shift>6']"
    gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-7 "['<Super><Shift>7']"
    gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-8 "['<Super><Shift>8']"
    gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-9 "['<Super><Shift>9']"
    gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-10 "['<Super><Shift>0']"

    ## Cambiar de escritorio
    gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-1 "['<Super>1']"
    gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-2 "['<Super>2']"
    gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-3 "['<Super>3']"
    gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-4 "['<Super>4']"
    gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-5 "['<Super>5']"
    gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-6 "['<Super>6']"
    gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-7 "['<Super>7']"
    gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-8 "['<Super>8']"
    gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-9 "['<Super>9']"
    gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-10 "['<Super>0']"

    ## Maximiza la ventana en el eje vertical
    gsettings set org.gnome.desktop.wm.keybindings maximize-vertically "['<Super><Shift>Up']"

    ## Maximiza la ventana en el eje horizontal
    gsettings set org.gnome.desktop.wm.keybindings maximize-horizontally "['<Super><Shift>Down']"

    ## Pegar a la parte de arriba
    gsettings set org.gnome.desktop.wm.keybindings move-to-side-n "['<Super><Control>Up']"

    ## Pegar al lateral derecho
    gsettings set org.gnome.desktop.wm.keybindings move-to-side-e "['<Super><Control>Right']"

    ## Pegar a la parte de abajo
    gsettings set org.gnome.desktop.wm.keybindings move-to-side-s "['<Super><Control>Down']"

    ## Pegar al lateral izquierdo
    gsettings set org.gnome.desktop.wm.keybindings move-to-side-w "['<Super><Control>Left']"

    ## Mueve al centro de la pantalla
    gsettings set org.gnome.desktop.wm.keybindings move-to-center "['<Super><Control>Space']"

    ## Mover a esquina arriba a la izquierda
    gsettings set org.gnome.desktop.wm.keybindings move-to-corner-nw "['<Super>UpLeft']"

    ## Mover a esquina arriba a la derecha
    gsettings set org.gnome.desktop.wm.keybindings move-to-corner-ne "['<Super>UpRight']"

    ## Mover a esquina abajo a la izquierda
    gsettings set org.gnome.desktop.wm.keybindings move-to-corner-sw  "['<Super>DownLeft']"

    ## Mover a esquina abajo a la derecha
    gsettings set org.gnome.desktop.wm.keybindings move-to-corner-se "['<Super>DownRight']"


    ##################
    ## Aplicaciones de Gnome Shell
    #################
    ## Gnome Screenshot
    gsettings set org.gnome.gnome-screenshot default-file-type 'png'
    gsettings set org.gnome.gnome-screenshot include-pointer "false"
    gsettings set org.gnome.gnome-screenshot delay "0"
    gsettings set org.gnome.gnome-screenshot take-window-shot "false"
    gsettings set org.gnome.gnome-screenshot last-save-directory ''
    gsettings set org.gnome.gnome-screenshot auto-save-directory ''
    gsettings set org.gnome.gnome-screenshot include-icc-profile "true"

    ## Pantalla de login
    gsettings set org.gnome.login-screen allowed-failures "5"
    #gsettings set org.gnome.login-screen logo '/usr/share/pixmaps/fedora-gdm-logo.png'
    gsettings set org.gnome.login-screen fallback-logo ''
    gsettings set org.gnome.login-screen banner-message-text "Equipo $(hostname), interacciones monitorizadas por seguridad"
    gsettings set org.gnome.login-screen disable-restart-buttons "false"
    gsettings set org.gnome.login-screen enable-fingerprint-authentication "false"
    gsettings set org.gnome.login-screen enable-smartcard-authentication "false"
    gsettings set org.gnome.login-screen disable-user-list "false"
    gsettings set org.gnome.login-screen banner-message-enable "true"
    gsettings set org.gnome.login-screen enable-password-authentication "true"


    ##################
    ## Anulo configuraciones que no necesito
    #################
    gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-up "[]"
    gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-right "[]"
    gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-down "[]"
    gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-left "[]"
    gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-last "[]"
    gsettings set org.gnome.desktop.wm.keybindings switch-panels-backward "[]"
    gsettings set org.gnome.desktop.wm.keybindings move-to-monitor-up "[]"
    gsettings set org.gnome.desktop.wm.keybindings move-to-monitor-right "[]"
    gsettings set org.gnome.desktop.wm.keybindings move-to-monitor-down "[]"
    gsettings set org.gnome.desktop.wm.keybindings move-to-monitor-left "[]"
    gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-up  "[]"
    gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-right "[]"
    gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-down "[]"
    gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-left "[]"
    gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-last "[]"
    gsettings set org.gnome.desktop.wm.keybindings maximize "[]"
    gsettings set org.gnome.desktop.wm.keybindings unmaximize "[]"
    gsettings set org.gnome.desktop.wm.keybindings switch-input-source-backward "[]"
    gsettings set org.gnome.desktop.wm.keybindings switch-windows "[]"
    gsettings set org.gnome.desktop.wm.keybindings show-desktop "[]"
    gsettings set org.gnome.desktop.wm.keybindings switch-group-backward "[]"
    gsettings set org.gnome.desktop.wm.keybindings panel-main-menu "[]"
    gsettings set org.gnome.desktop.wm.keybindings switch-panels "[]"
    gsettings set org.gnome.desktop.wm.keybindings cycle-windows "[]"
    gsettings set org.gnome.desktop.wm.keybindings cycle-panels "[]"
    gsettings set org.gnome.desktop.wm.keybindings cycle-windows-backward "[]"
    gsettings set org.gnome.desktop.wm.keybindings cycle-panels-backward "[]"
    gsettings set org.gnome.desktop.wm.keybindings cycle-group-backward "[]"
    gsettings set org.gnome.desktop.wm.keybindings cycle-group "[]"
    gsettings set org.gnome.desktop.wm.keybindings switch-group "[]"
    gsettings set org.gnome.desktop.wm.keybindings switch-applications-backward "[]"
    gsettings set org.gnome.desktop.wm.keybindings switch-windows-backward "[]"
    gsettings set org.gnome.desktop.wm.keybindings toggle-above "[]"
    gsettings set org.gnome.mutter.keybindings tab-popup-cancel "[]"
    gsettings set org.gnome.mutter.keybindings tab-popup-select "[]"
    gsettings set org.gnome.mutter.keybindings rotate-monitor "[]"
    gsettings set org.gnome.mutter.keybindings switch-monitor "[]"
    gsettings set org.gnome.mutter.wayland.keybindings switch-to-session-1 "[]"
    gsettings set org.gnome.mutter.wayland.keybindings switch-to-session-2 "[]"
    gsettings set org.gnome.mutter.wayland.keybindings switch-to-session-3 "[]"
    gsettings set org.gnome.mutter.wayland.keybindings switch-to-session-4 "[]"
    gsettings set org.gnome.mutter.wayland.keybindings switch-to-session-5 "[]"
    gsettings set org.gnome.mutter.wayland.keybindings switch-to-session-6 "[]"
    gsettings set org.gnome.mutter.wayland.keybindings switch-to-session-7 "[]"
    gsettings set org.gnome.mutter.wayland.keybindings switch-to-session-8 "[]"
    gsettings set org.gnome.mutter.wayland.keybindings switch-to-session-9 "[]"
    gsettings set org.gnome.mutter.wayland.keybindings switch-to-session-10 "[]"
    gsettings set org.gnome.mutter.wayland.keybindings switch-to-session-11 "[]"
    gsettings set org.gnome.mutter.wayland.keybindings switch-to-session-12 "[]"
    gsettings set org.gnome.mutter.wayland.keybindings restore-shortcuts "[]"
    gsettings set org.gnome.desktop.wm.keybindings set-spew-mark "[]"
    gsettings set org.gnome.desktop.wm.keybindings raise-or-lower "[]"
    gsettings set org.gnome.desktop.wm.keybindings raise "[]"
    gsettings set org.gnome.desktop.wm.keybindings toggle-shaded "[]"
    gsettings set org.gnome.desktop.wm.keybindings lower "[]"
    gsettings set org.gnome.shell.keybindings focus-active-notification "[]"
    gsettings set org.gnome.shell.keybindings open-application-menu "[]"
    gsettings set org.gnome.shell.keybindings toggle-message-tray "[]"
    gsettings set org.gnome.shell.keybindings toggle-application-view "[]"
    gsettings set org.gnome.shell.keybindings toggle-overview "[]"
    gsettings set org.gnome.shell.keybindings shift-overview-up "[]"
    gsettings set org.gnome.shell.keybindings shift-overview-down "[]"
    gsettings set org.gnome.shell.keybindings switch-to-application-1 "[]"
    gsettings set org.gnome.shell.keybindings switch-to-application-2 "[]"
    gsettings set org.gnome.shell.keybindings switch-to-application-3 "[]"
    gsettings set org.gnome.shell.keybindings switch-to-application-4 "[]"
    gsettings set org.gnome.shell.keybindings switch-to-application-5 "[]"
    gsettings set org.gnome.shell.keybindings switch-to-application-6 "[]"
    gsettings set org.gnome.shell.keybindings switch-to-application-7 "[]"
    gsettings set org.gnome.shell.keybindings switch-to-application-8 "[]"
    gsettings set org.gnome.shell.keybindings switch-to-application-9 "[]"

    ## Configuración de la shell
    gsettings set org.gnome.shell always-show-log-out "false"
    gsettings set org.gnome.shell command-history "['tilix']"
    gsettings set org.gnome.shell disable-user-extensions "false"
    gsettings set org.gnome.shell favorite-apps "['firefox-developer.desktop', 'firefox-wayland.desktop', 'com.gexperts.Tilix.desktop', 'org.gnome.Nautilus.desktop', 'phpstorm.desktop', 'pycharm.desktop', 'codium.desktop', 'libreoffice-writer.desktop', 'gpodder.desktop', 'virtualbox.desktop', 'com.obsproject.Studio.desktop']"
    gsettings set org.gnome.shell disable-extension-version-validation "false"
    gsettings set org.gnome.shell app-picker-layout "[{'0ad.desktop': <{'position': <0>}>, 'system-config-selinux.desktop': <{'position': <1>}>, 'tint2conf.desktop': <{'position': <2>}>, 'xfce4-clipman.desktop': <{'position': <3>}>, 'alsamixergui.desktop': <{'position': <4>}>, 'arandr.desktop': <{'position': <5>}>, 'cc.arduino.arduinoide.desktop': <{'position': <6>}>, 'atom.desktop': <{'position': <7>}>, 'audacity.desktop': <{'position': <8>}>, 'org.avidemux.Avidemux.desktop': <{'position': <9>}>, 'WebHTTrack-Websites.desktop': <{'position': <10>}>, 'org.gnome.Boxes.desktop': <{'position': <11>}>, 'calf.desktop': <{'position': <12>}>, 'org.gnome.Cheese.desktop': <{'position': <13>}>, 'clementine.desktop': <{'position': <14>}>, 'compton.desktop': <{'position': <15>}>, 'gnome-control-center.desktop': <{'position': <16>}>, 'org.gnome.Contacts.desktop': <{'position': <17>}>, 'pavucontrol.desktop': <{'position': <18>}>}, {'soundconverter.desktop': <{'position': <0>}>, 'firewall-config.desktop': <{'position': <1>}>, 'io.atom.Atom.desktop': <{'position': <2>}>, 'dropbox.desktop': <{'position': <3>}>, 'bluefish.desktop': <{'position': <4>}>, 'gconf-editor.desktop': <{'position': <5>}>, 'ca.desrt.dconf-editor.desktop': <{'position': <6>}>, 'dia.desktop': <{'position': <7>}>, 'org.gnome.gedit.desktop': <{'position': <8>}>, 'simple-scan.desktop': <{'position': <9>}>, 'filezilla.desktop': <{'position': <10>}>, 'firefox.desktop': <{'position': <11>}>, 'firefox-developer.desktop': <{'position': <12>}>, 'firefox-nightly.desktop': <{'position': <13>}>, 'org.raspberrypi.rpi-imager.desktop': <{'position': <14>}>, 'fotoxx.desktop': <{'position': <15>}>, 'geany.desktop': <{'position': <16>}>, 'selinux-polgengui.desktop': <{'position': <17>}>, 'java-1.8.0-openjdk-1.8.0.282.b08-4.fc34.x86_64-policytool.desktop': <{'position': <18>}>, 'planner.desktop': <{'position': <19>}>, 'gwget.desktop': <{'position': <20>}>, 'gns3.desktop': <{'position': <21>}>}, {'google-chrome.desktop': <{'position': <0>}>, 'gparted.desktop': <{'position': <1>}>, 'gpick.desktop': <{'position': <2>}>, 'gpodder.desktop': <{'position': <3>}>, 'grub-customizer.desktop': <{'position': <4>}>, 'hp-uiscan.desktop': <{'position': <5>}>, 'hplip.desktop': <{'position': <6>}>, 'system-config-language.desktop': <{'position': <7>}>, 'imagination.desktop': <{'position': <8>}>, 'org.inkscape.Inkscape.desktop': <{'position': <9>}>, 'org.kde.kate.desktop': <{'position': <10>}>, 'org.kde.kdevelop.desktop': <{'position': <11>}>, 'org.kde.kdevelop_ps.desktop': <{'position': <12>}>, 'keepass.desktop': <{'position': <13>}>, 'org.kde.kexi.desktop': <{'position': <14>}>, 'org.kde.konsole.desktop': <{'position': <15>}>, 'libreoffice-calc.desktop': <{'position': <16>}>, 'libreoffice-draw.desktop': <{'position': <17>}>, 'libreoffice-impress.desktop': <{'position': <18>}>, 'libreoffice-math.desktop': <{'position': <19>}>, 'libreoffice-writer.desktop': <{'position': <20>}>, 'lmms.desktop': <{'position': <21>}>}, {'gtk-lshw.desktop': <{'position': <0>}>, 'org.gnome.Maps.desktop': <{'position': <1>}>, 'org.gnome.Weather.desktop': <{'position': <2>}>, 'mypaint.desktop': <{'position': <3>}>, 'chromium-browser.desktop': <{'position': <4>}>, 'com.nextcloud.desktopclient.nextcloud.desktop': <{'position': <5>}>, 'nitrogen.desktop': <{'position': <6>}>, 'virtualbox.desktop': <{'position': <7>}>, 'appimagekit-pcloud.desktop': <{'position': <8>}>, 'pdfmod.desktop': <{'position': <9>}>, 'phpstorm.desktop': <{'position': <10>}>, 'projectM-pulseaudio.desktop': <{'position': <11>}>, 'putty.desktop': <{'position': <12>}>, 'pgadmin3.desktop': <{'position': <13>}>, 'pycharm.desktop': <{'position': <14>}>, 'PBE.QOwnNotes.desktop': <{'position': <15>}>, 'ranger.desktop': <{'position': <16>}>, 'org.gnome.clocks.desktop': <{'position': <17>}>, 'org.gnome.Extensions.desktop': <{'position': <18>}>}, {'org.remmina.Remmina.desktop': <{'position': <0>}>, 'vlc.desktop': <{'position': <1>}>, 'rhythmbox.desktop': <{'position': <2>}>, 'rxvt-unicode.desktop': <{'position': <3>}>, 'scribus.desktop': <{'position': <4>}>, 'sepolicy.desktop': <{'position': <5>}>, 'st.desktop': <{'position': <6>}>, 'steam.desktop': <{'position': <7>}>, 'supertux2.desktop': <{'position': <8>}>, 'supertuxkart.desktop': <{'position': <9>}>, 'surf.desktop': <{'position': <10>}>, 'telegramdesktop.desktop': <{'position': <11>}>, 'terminator.desktop': <{'position': <12>}>, 'mozilla-thunderbird.desktop': <{'position': <13>}>, 'mozilla-thunderbird-wayland.desktop': <{'position': <14>}>, 'torbrowser.desktop': <{'position': <15>}>, 'torbrowser-settings.desktop': <{'position': <16>}>, 'transmageddon.desktop': <{'position': <17>}>, 'transmission-gtk.desktop': <{'position': <18>}>, 'ufraw.desktop': <{'position': <19>}>, 'org.gnome.Tour.desktop': <{'position': <20>}>, 'org.kde.umbrello.desktop': <{'position': <21>}>}, {'Utilities': <{'position': <0>}>, 'nvidia-settings.desktop': <{'position': <1>}>, 'org.gnome.Totem.desktop': <{'position': <2>}>, 'gpicview.desktop': <{'position': <3>}>, 'org.gnome.eog.desktop': <{'position': <4>}>, 'WebHTTrack.desktop': <{'position': <5>}>, 'wireshark.desktop': <{'position': <6>}>, 'xfe-xfe.desktop': <{'position': <7>}>, 'xfe-xfi.desktop': <{'position': <8>}>, 'xfe-xfp.desktop': <{'position': <9>}>, 'xfe-xfw.desktop': <{'position': <10>}>, 'xterm.desktop': <{'position': <11>}>, 'org.pwmt.zathura.desktop': <{'position': <12>}>, 'com.obsproject.Studio.desktop': <{'position': <13>}>, 'codium.desktop': <{'position': <14>}>}]"
    gsettings set org.gnome.shell had-bluetooth-devices-setup "true"
    gsettings set org.gnome.shell looking-glass-history '[]'
    gsettings set org.gnome.shell enabled-extensions "['background-logo@fedorahosted.org', 'freon@UshakovVasilii_Github.yahoo.com', 'TopIcons@phocean.net', 'user-theme@gnome-shell-extensions.gcampax.github.com', 'native-window-placement', 'pop-shell@system76.com', 'argos@pew.worldwidemann.com', 'auto-move-windows@gnome-shell-extensions.gcampax.github.com']
    org.gnome.shell disabled-extensions ['window-list@gnome-shell-extensions.gcampax.github.com']"
    gsettings set org.gnome.shell development-tools "true"
    gsettings set org.gnome.shell introspect "false"
    gsettings set org.gnome.shell remember-mount-password "true"
    gsettings set org.gnome.shell welcome-dialog-last-shown-version '40.0'



    ## a11
    gsettings set org.gnome.desktop.a11y.applications screen-keyboard-enabled "false"
    gsettings set org.gnome.desktop.a11y.applications screen-magnifier-enabled "false"
    gsettings set org.gnome.desktop.a11y.applications screen-reader-enabled "false"

}

gnome_shell_instalador() {
    echo -e "$VE Comenzando instalación de$RO Gnome Shell$CL"

    gnome_shell_preconfiguracion
    gnome_shell_instalar
    gnome_shell_postconfiguracion
    gnome_shell_postconfiguracionOpcional
}
