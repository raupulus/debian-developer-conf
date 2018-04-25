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
## Este archivo hace una limpieza agresiva de directorios conflictivos con el
## script. Normalmente se espera no necesitarse usar pero existirá.
## El uso de este script puede ser perjudicial y debes asumir el riesgo

## FIXME → Restaurar archivos BACKUP creados con el script antes de eliminar!!!

############################
##       CONSTANTES       ##
############################
AM="\033[1;33m"  ## Color Amarillo
AZ="\033[1;34m"  ## Color Azul
BL="\033[1;37m"  ## Color Blanco
RO="\033[1;31m"  ## Color Rojo
VE="\033[1;32m"  ## Color VE
CL="\e[0m"       ## Limpiar colores

############################
##       FUNCIONES        ##
############################
##
## Función para comprobar los archivos que están con BACKUP y restaurarlos
##
restaurar_Backups() {
    echo -e "$VE Preparando para$RO Restaurar$AZ archivos$CL"
}

limpiar_con_fuerza() {
    echo -e "$VE Este$AM script$VE es muy$BL peligroso$VE y borrará muchas cosas"
    echo -e "$VE Asegúrate que es lo que necesitas hacer antes de ejecutarlo"
    read -p "Pulsa una tecla para destruir personalización generada por este script"

    local DIRECTORIOS_BORRAR=".oh-my-zsh .bash_it .nvm fasd .vim .local/opt/Firefox_Quantum_Developer .local/bin/firefox-quantum .local/share/applications/firefox-quantum.desktop .local/opt/Firefox_Nightly .local/bin/firefox-nightly .local/share/applications/firefox-nightly.desktop .atom .i3 .ninja-ide dunst powerline sakura"

    local ARCHIVOS_BORRAR=".local/bin/psysh .tmux.conf .udisks-glue.conf .vimrc .gvimrc .zshrc"

    for d in $DIRECTORIOS_BORRAR
    do
        if [[ -d "$HOME/$d" ]]; then
            rm -Rf "$HOME/$d"
        fi
        #mv "$WORKSCRIPT/Backups/$d" $d 2>> /dev/null
    done

    for a in $ARCHIVOS_BORRAR
    do
        if [[ -f "$HOME/$a" ]]; then
            rm -f "$HOME/$a"
        fi
        #mv "$WORKSCRIPT/Backups/$d" $a 2>> /dev/null
    done

    local paquetes_borrar="vim atom ninja-ide dbeaver brackets haroopad"
    desinstalar_paquetes "$paquetes_borrar"
}
