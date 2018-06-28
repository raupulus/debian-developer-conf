#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2018 Raúl Caro Pastorino
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
## Plantea la instalación de i3wm con las configuraciones

############################
##       FUNCIONES        ##
############################
i3wm_preconfiguracion() {
    echo -e "$VE Generando Pre-Configuraciones de$RO i3wm$CL"

    ## Al pulsar botón de apagar se suspende
    sudo sed -r -i "s/^#?\s*HandlePowerKey\s*=.*$/HandlePowerKey=suspend/" /etc/systemd/logind.conf

    ## Instalo fuentes tipográficas necesarias
    fuentes_repositorios
}

i3wm_instalar() {
    echo -e "$VE Preparando para instalar$RO i3wm$CL"
    instalarSoftware i3 i3-wm i3blocks i3lock i3status suckless-tools rofi
    instalarSoftware acpi gawk

    ## Notificaciones del escritorio con dunst
    instalarSoftware dunst

    ## Instalando gestor de archivos xfe
    instalarSoftware xfe xfe-i18n xfe-themes

    ## Navegador web liviano "surf"
    instalarSoftware surf

    ## Visor de imágenes nomacs
    instalarSoftware nomacs
}

##
## Instalando software extra y configuraciones adicionales
##
i3wm_postconfiguracion() {
    echo -e "$VE Generando Post-Configuraciones$RO i3wm$CL"

    echo -e "$VE Instalando software secundario$CL"
    instalarSoftware rxvt-unicode-256color compton compton-conf compton-conf-l10n nitrogen thunar ranger w3m tint2 arandr xbacklight gvfs gpicview mplayer cmus zathura xautolock xbindkeys xbindkeys-config pulseaudio volumeicon-alsa alsamixergui xfce4-settings firewall-applet firewall-config firewalld unclutter lxappearance gtk-chtheme qt4-qtconfig pm-utils xfce4-screenshooter parcellite zenity scrot lxpolkit ssh-askpass wireless-tools fonts-powerline xfce4-clipman redshift

    echo -e "$VE Generando archivos de configuración$CL"
    enlazarHome '.config/i3' '.config/tint2' '.config/compton.conf' '.config/conky' '.Xresources' '.config/nitrogen' '.config/i3status' '.config/plank' '.config/rofi'

    if [[ ! -d "$HOME/Imágenes/Screenshot" ]]; then
        mkdir -p "$HOME/Imágenes/Screenshots"
    fi

    ## Instalando i3pystatus
    ## libasound2-dev → Necesario para pyalsaaudio
    ## libiw-dev → Necesario para basiciw
    instalarSoftware 'python3' 'python3-pip' 'libasound2-dev' 'libiw-dev' \
    'python3-powerline' 'python3-psutil' 'python3-powerline-taskwarrior' \
    'fonts-font-awesome'


    sudo pip3 install --upgrade 'i3pystatus' 'basiciw' 'netifaces' 'colour' \
    'pyalsaaudio' 'fontawesome'

    ## Tema Paper para GTK2 (Debe estar instalado)
    gconftool-2 --type string --set /desktop/gnome/interface/icon_theme 'Paper'

    if [[ -f "$HOME/.local/bin/brillo" ]]; then
        rm -f "$HOME/.local/bin/brillo"
    fi
    ln -s "$HOME/.config/i3/scripts/brillo.py" "$HOME/.local/bin/brillo"
    chmod +x "$HOME/.local/bin/brillo"

}

i3wm_instalador() {
    echo -e "$VE Comenzando instalación de$RO i3wm$CL"

    i3wm_preconfiguracion
    i3wm_instalar
    i3wm_postconfiguracion

    ## Configurando Personalizaciones
    conf_gtk2  ## Configura gtk-2.0 desde script → Personalizacion_GTK
    conf_gtk3  ## Configura gtk-3.0 desde script → Personalizacion_GTK
}

##
## Instalador para el fork de i3 gaps en:
## https://github.com/Airblader/i3/tree/gaps
## Se usa la rama "gaps" en vez de la rama "gaps-next"
##
i3wm_gaps_instalador() {
    ## Instalando dependencias
    instalarSoftware libxcb-keysyms1-dev libpango1.0-dev libxcb-util0-dev xcb libxcb1-dev libxcb-icccm4-dev libyajl-dev libev-dev libxcb-xkb-dev libxcb-cursor-dev libxkbcommon-dev libxcb-xinerama0-dev libxkbcommon-x11-dev libstartup-notification0-dev libxcb-randr0-dev libxcb-xrm0 libxcb-xrm-dev

    ## Instalo i3gaps desde repositorio GitHub en vez de i3 normal
    git clone https://www.github.com/Airblader/i3 i3-gaps
    cd i3-gaps || exit
    git checkout gaps && git pull

    autoreconf --force --install
    rm -rf build/
    mkdir -p build && cd build || exit

    ./configure
    cd x86_64-pc-linux-gnu && make && sudo make install
}
