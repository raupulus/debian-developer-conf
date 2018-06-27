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
##
##             Guía de estilos aplicada:
## @style      https://github.com/fryntiz/Bash_Style_Guide

############################
##     INSTRUCCIONES      ##
############################
## Este script instala siempre las aplicaciones que considero básicas en un
## sistema operativo para trabajar y desarrollar.
##
## La lista de software utilizada se extrae de "Software.lst" y cualquier
## progama que añadamos en este archivo, será instalado desde este script.

###########################
##       FUNCIONES       ##
###########################
aplicaciones_basicas() {
    echo -e "$VE Instalando aplicaciones básicas$CL"
    actualizarRepositorios

    repararGestorPaquetes

    instalarSoftwareLista "$WORKSCRIPT/Apps/Packages/Software-Basico.lst"

    repararGestorPaquetes
}
