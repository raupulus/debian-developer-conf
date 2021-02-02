#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2017 Raúl Caro Pastorino
## @license    https://wwww.gnu.org/licenses/gpl.txt
## @email      raul@fryntiz.dev
## @web        https://fryntiz.es
## @github     https://github.com/fryntiz
## @gitlab     https://gitlab.com/fryntiz
## @twitter    https://twitter.com/fryntiz
##
##             Guía de estilos aplicada:
## @style      https://gitlab.com/fryntiz/bash-guide-style

############################
##     INSTRUCCIONES      ##
############################
## Instala el programa Pencil Project desde su sitio web oficial

############################
##       FUNCIONES        ##
############################
pencilProject_descargar() {
    descargar 'Pencil_Project.deb' 'http://pencil.evolus.vn/dl/V3.0.4/Pencil_3.0.4_amd64.deb'
}

pencilProject_preconfiguracion() {
    echo -e "$VE Generando Pre-Configuraciones de$RO Pencil Project$CL"
}

pencilProject_instalar() {
    echo -e "$VE Instalando$RO Pencil Project$CL"
    instalarSoftwareDPKG "$WORKSCRIPT/tmp/Pencil_Project.deb"
}

pencilProject_postconfiguracion() {
    echo -e "$VE Generando Post-Configuraciones$RO Pencil Project$CL"
}

pencilProject_instalador() {
    echo -e "$VE Comenzando instalación de$RO Pencil Project$CL"

    pencilProject_preconfiguracion

    if [[ -f '/usr/bin/pencil' ]] ||
       [[ -f '/usr/local/bin/pencil' ]]; then
        echo -e "$VE Ya esta$RO Pencil Project$VE instalado en el equipo, omitiendo paso$CL"
    else
        if [[ -f "$WORKSCRIPT/tmp/Pencil_Project.deb" ]]; then
            pencilProject_instalar
        else
            pencilProject_descargar
            pencilProject_instalar
        fi

        ## Si falla la instalación se rellama la función tras limpiar
        if [[ ! -f '/usr/bin/pencil' ]] ||
           [[ ! -f '/usr/local/bin/pencil' ]]; then
            rm -f "$WORKSCRIPT/tmp/Pencil_Project.deb"
            pencilProject_descargar
            pencilProject_instalar
        fi
    fi

    pencilProject_postconfiguracion
}
