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
## Plantea instalación y configuración del gestor de ventanas i3

###########################
##       FUNCIONES       ##
###########################
i3wm_descargar() {
    echo ""
}

i3wm_preconfiguracion() {
    echo -e "$VE Generando Pre-Configuraciones de$RO i3wm$CL"
}

i3wm_instalar() {
    echo -e "$VE Preparando para instalar$RO i3wm$CL"
}

i3wm_postconfiguracion() {
    echo -e "$VE Generando Post-Configuraciones$RO i3wm$CL"

    local archivosConfiguracion='.i3'

    ## Crear Backup
    crearBackup "$archivosConfiguracion"

    ## Enlazar archivos de este repo
    enlazarHome "$archivosConfiguracion"
}

i3wm_instalador() {
    echo -e "$VE Comenzando instalación de$RO i3wm$CL"

    i3wm_preconfiguracion

    if [[ -f '/usr/bin/i3wm' ]]; then
        echo -e "$VE Ya esta$RO i3wm$VE instalado en el equipo, omitiendo paso$CL"
    else
        i3wm_instalar
    fi

    i3wm_postconfiguracion
}
