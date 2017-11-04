#!/bin/bash
# -*- ENCODING: UTF-8 -*-
#######################################
# ###     Raúl Caro Pastorino     ### #
## ##                             ## ##
### # https://github.com/fryntiz/ # ###
## ##                             ## ##
# ###       www.fryntiz.es        ### #
#######################################

# Este archivo hace una limpieza agresiva de directorios conflictivos con el
# script. Normalmente se espera no necesitarse usar pero existirá.
# El uso de este script puede ser perjudicial y debes asumir el riesgo

# TOFIX → Restaurar archivos BACKUP creados con el script antes de eliminar!!!

############################
##   Constantes Colores   ##
############################
amarillo="\033[1;33m"
azul="\033[1;34m"
blanco="\033[1;37m"
cyan="\033[1;36m"
gris="\033[0;37m"
magenta="\033[1;35m"
rojo="\033[1;31m"
verde="\033[1;32m"

#############################
##   Variables Generales   ##
#############################


# Función para comprobar los archivos que están con BACKUP y restaurarlos
function restaurar_Backups() {
    echo -e "$verde Preparando para restaurar archivos$gris"
}


function limpiar_con_fuerza() {
    echo -e "$verde Este script es muy peligroso y borrara muchas cosas"
    echo -e "$verde Asegúrate que es lo que necesitas hacer antes de ejecutarlo"
    read -p "Pulsa una tecla para destruir personalización generada por este script"

    # TODO → Crear una lista con todos los directorios a borrar y otra con todos los archivos
    DIRECTORIOS_BORRAR=""
    ARCHIVOS_BORRAR=""

    for d in $DIRECTORIOS_BORRAR
    do
        rm -R -f $d 2>> /dev/null
        mv $d.BACKUP $d 2>> /dev/null
    done

    for a in $ARCHIVOS_BORRAR
    do
        rm -f $a 2>> /dev/null
        mv $a.BACKUP $a 2>> /dev/null
    done


    # TODO → Pasar archivos y directorios a las listas anteriores
    # para que sean borrados desde los bucles

    rm -R -f ~/.oh-my-zsh 2>> /dev/null
    rm -R -f ~/.bash_it 2>> /dev/null
    rm -R -f ~/.nvm 2>> /dev/null
    rm -R -f ~/fasd 2>> /dev/null
    rm -R -f ~/.vim 2>> /dev/null
    rm -R -f ~/.local/opt/Firefox_Quantum_Developer 2>> /dev/null
    rm -R -f ~/.local/bin/firefox-quantum 2>> /dev/null
    rm -R -f ~/.local/share/applications/firefox-quantum.desktop 2>> /dev/null
    rm -R -f ~/.local/opt/Firefox_Nightly 2>> /dev/null
    rm -R -f ~/.local/bin/firefox-nightly 2>> /dev/null
    rm -R -f ~/.local/share/applications/firefox-nightly.desktop 2>> /dev/null
    rm -R -f ~/.local/bin/psysh 2>> /dev/null
    rm -R -f ~/.atom 2>> /dev/null
    rm -R -f ~/.i3 2>> /dev/null
    rm -R -f ~/.ninja-ide 2>> /dev/null
    rm -R -f ~/dunst 2>> /dev/null
    rm -R -f ~/powerline 2>> /dev/null
    rm -R -f ~/sakura 2>> /dev/null
    rm -R -f ~/.less 2>> /dev/null
    rm -R -f ~/.lessfilter 2>> /dev/null
    rm -R -f ~/.tmux.conf 2>> /dev/null
    rm -R -f ~/.tmux.conf2 2>> /dev/null
    rm -R -f ~/.udisks-glue.conf 2>> /dev/null
    rm -R -f ~/.vimrc 2>> /dev/null
    rm -R -f ~/.zshrc 2>> /dev/null




    sudo apt purge vim
    sudo apt purge atom
}
