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

############################
##     IMPORTACIONES      ##
############################

###########################
##       FUNCIONES       ##
###########################

ohMyZSH() {
    if [ -f ~/.oh-my-zsh/oh-my-zsh.sh ] #Comprobar si ya esta instalado
    then
        echo -e "$verde Ya esta$rojo OhMyZSH$verde instalado para este usuario, omitiendo paso$gris"
    else
        REINTENTOS=5
        echo -e "$verde Descargando OhMyZSH$gris"
        for (( i=1; i<=$REINTENTOS; i++ ))
        do
            ###TOFIX → Reparar script que sale mal: contraseña PAM y error (no continua por eso)
            rm -R ~/.oh-my-zsh 2>> /dev/null
            curl -L http://install.ohmyz.sh | sh && break || break
        done
    fi
}
