#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2018 Raúl Caro Pastorino
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
## Plantea la instalación de i3wm con las configuraciones

############################
##       FUNCIONES        ##
############################
i3wm_preconfiguracion() {
    echo -e "$VE Generando Pre-Configuraciones de$RO i3wm$CL"

    instalarSoftwareLista "$SOFTLIST/Desktops/x11-base.lst"

    ## Al pulsar botón de apagar se suspende
    if [[ -f /etc/systemd/logind.conf ]]; then
        sudo sed -r -i "s/^#?\s*HandlePowerKey\s*=.*$/HandlePowerKey=suspend/" /etc/systemd/logind.conf
    else
        echo "Plantear método independiente de systemd"
    fi

    ## Instalo fuentes tipográficas necesarias
    fuentes_repositorios
}

i3wm_instalar() {
    echo -e "$VE Preparando para instalar$RO i3wm$CL"
    instalarSoftwareLista "$SOFTLIST/Desktops/i3wm.lst"
}

##
## Instalando software extra y configuraciones adicionales
##
i3wm_postconfiguracion() {
    echo -e "$VE Generando Post-Configuraciones$RO i3wm$CL"
    instalarSoftwareLista "$SOFTLIST/Desktops/wm-min-software.lst"

    echo -e "$VE Generando archivos de configuración$CL"
    enlazarHome '.config/i3' '.config/tint2' '.config/compton.conf' '
    .config/conky' '.Xresources' '.config/nitrogen' '.config/i3status' '.config/plank' '.config/rofi' '.config/i3pystatus' '.scripts'

    dir_exist_or_create "$HOME/Imágenes/Screenshots"

    ## Instalo y Configuro Python: Lenguajes-Programacion/python.sh
    python_instalador

    ## Dependencias para i3pystatus con python.
    python3Install 'basiciw' 'netifaces' 'colour' \
    'pyalsaaudio' 'fontawesome'

    ## Tema Paper para GTK2 (Debe estar instalado)
    gconftool-2 --type string --set /desktop/gnome/interface/icon_theme 'Paper'

    if [[ -f "$HOME/.local/bin/brillo" ]]; then
        rm -f "$HOME/.local/bin/brillo"
    fi
    ln -s "$HOME/.config/i3/scripts/brillo.py" "$HOME/.local/bin/brillo"
    chmod a+rx "$HOME/.local/bin/brillo"
}

i3wm_instalador() {
    echo -e "$VE Comenzando instalación de$RO i3wm$CL"

    i3wm_preconfiguracion
    i3wm_instalar
    i3wm_postconfiguracion

    ## Configurando Personalizaciones
    conf_gtk2  ## Configura gtk-2.0 desde script → Personalizacion_GTK
    conf_gtk3  ## Configura gtk-3.0 desde script → Personalizacion_GTK
    conf_gtk4  ## Configura gtk-4.0 desde script → Personalizacion_GTK
}

