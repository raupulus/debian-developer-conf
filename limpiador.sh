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

function limpiar_con_fuerza() {
    echo -e "$verde Este script es muy peligroso y borrara muchas cosas"
    echo -e "$verde Asegúrate que es lo que necesitas hacer antes de ejecutarlo"
    read -p "Pulsa una tecla para destruir personalización generada por este script"
    rm -R -f ~/.oh-my-zsh 2>> /dev/null
    rm -R -f ~/.bash_it 2>> /dev/null
    rm -R -f ~/.nvm 2>> /dev/null
    rm -R -f ~/fasd 2>> /dev/null
    rm -R -f ~/.vim 2>> /dev/null
    rm -R -f ~/.local/opt/Firefox_Quantum_Developer 2>> /dev/null
    rm -R -f ~/.local/opt/Firefox_Nightly 2>> /dev/null
    rm -R -f ~/.atom /dev/null
    rm -R -f ~/.i3 /dev/null
    rm -R -f ~/.ninja-ide /dev/null
    rm -R -f ~/dunst /dev/null
    rm -R -f ~/powerline /dev/null
    rm -R -f ~/sakura /dev/null
    rm -R -f ~/.less /dev/null
    rm -R -f ~/.lessfilter /dev/null
    rm -R -f ~/.tmux.conf /dev/null
    rm -R -f ~/.tmux.conf2 /dev/null
    rm -R -f ~/.udisks-glue.conf /dev/null
    rm -R -f ~/.vimrc /dev/null
    rm -R -f ~/.zshrc /dev/null
}
limpiar_con_fuerza








