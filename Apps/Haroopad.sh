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
## Descarga Haroopad desde su fuente oficial y lo instala en el sistema.

###########################
##       FUNCIONES       ##
###########################
haroopad_descargar() {
    descargar 'haroopad.deb' "https://bitbucket.org/rhiokim/haroopad-download/downloads/haroopad-v0.13.1-x64.deb"
}

haroopad_preconfiguracion() {
    echo -e "$VE Generando Pre-Configuraciones de$RO Haroopad$CL"
}

haroopad_instalar() {
    echo -e "$VE Instalando$RO Haroopad$CL"
    sudo dpkg -i "$WORKSCRIPT/tmp/haroopad.deb" && sudo apt install -f -y
}

haroopad_postconfiguracion() {
    echo -e "$VE Generando Post-Configuraciones$RO Haroopad$CL"
}

haroopad_instalador() {
    echo -e "$VE Comenzando instalación de$RO Haroopad$CL"

    haroopad_preconfiguracion

    if [[ -f '/usr/bin/haroopad' ]]; then
        echo -e "$VE Ya esta$RO Haroopad$VE instalado en el equipo, omitiendo paso$CL"
    else
        if [[ -f "$WORKSCRIPT/tmp/haroopad.deb" ]]; then
            haroopad_instalar
        else
            haroopad_descargar
            haroopad_instalar
        fi

        ## Si falla la instalación se rellama la función tras limpiar
        if [[ ! -f '/usr/bin/haroopad' ]]; then
            rm -f "$WORKSCRIPT/tmp/haroopad.deb"
            haroopad_descargar
            haroopad_instalar
        fi
    fi

    haroopad_postconfiguracion
}
