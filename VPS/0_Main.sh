#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2018 Raúl Caro Pastorino
## @license    https://wwww.gnu.org/licenses/gpl.txt
## @email      dev@fryntiz.es
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
source "$WORKSCRIPT/VPS/administrador.sh"
source "$WORKSCRIPT/VPS/fail2ban.sh"

###########################
##       FUNCIONES       ##
###########################
##
## Menú instalar todas las configuraciones de un VPS
##
menuVPS() {
    ## Deshabilito actualizaciones automáticas
    sudo systemctl disable apt-daily
    sudo systemctl stop apt-daily.timer
    sudo systemctl stop apt-daily
    sudo systemctl disable apt-daily-upgrade
    sudo systemctl stop apt-daily-upgrade.timer
    sudo systemctl stop apt-daily-upgrade

    stable_agregar_repositorios
    aplicaciones_basicas

    instalarSoftwareLista "$SOFTLIST/Vps/basico.lst"

    configuracion_git

    #menuServidores -a 'prod'
    #menuLenguajes -a 'prod'

    vim_Instalador

    ## Específicos de VPS en este directorio
    mainFirewall

    ## Idioma y Zona Horaria
    mainZone

    ## Protección contra ataques e intentos de crackeo
    fail2ban_instalador

    ## Configura el usuario "web" como administrador
    configureAdmin
}
