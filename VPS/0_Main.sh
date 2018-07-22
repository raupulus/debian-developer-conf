#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2018 Raúl Caro Pastorino
## @license    https://wwww.gnu.org/licenses/gpl.txt
## @email      tecnico@fryntiz.es
## @web        https://fryntiz.es
## @gitlab     https://gitlab.com/fryntiz
## @github     https://github.com/fryntiz
## @twitter    https://twitter.com/fryntiz
##
##             Guía de estilos aplicada:
## @style      https://github.com/fryntiz/Bash_Style_Guide

############################
##     INSTRUCCIONES      ##
############################
## Menú principal para configurar un VPS

############################
##     IMPORTACIONES      ##
############################
source "$WORKSCRIPT/VPS/firewall.sh"
source "$WORKSCRIPT/VPS/idioma_hora.sh"

###########################
##       FUNCIONES       ##
###########################
##
## Menú instalar todas las configuraciones de un VPS
##
menuVPS() {
    stable_agregar_repositorios
    aplicaciones_basicas

    instalarSoftwareLista "$WORKSCRIPT/Apps/Packages/vps.lst"
    instalarSoftwareLista "$WORKSCRIPT/Apps/Packages/developer.lst"

    configuracion_git
    terminales_instalador
    instalar_variables

    menuServidores -a
    menuLenguajes -a

    bashit_Instalador
    ohmyzsh_Instalador
    vim_Instalador

    ## Específicos de VPS en este directorio
    mainFirewall

    ## Idioma y Zona Horaria
    mainZone
}
