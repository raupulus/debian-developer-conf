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
vim_descargar() {
    echo ""
}

vim_preconfiguracion() {
    echo -e "$VE Generando Pre-Configuraciones de$RO Vim$CL"
}

vim_instalar() {
    echo -e "$VE Preparando para instalar$RO Vim$CL"
}

vim_postconfiguracion() {
    echo -e "$VE Generando Post-Configuraciones$RO Vim$CL"
}

vim_instalador() {
    echo -e "$VE Comenzando instalación de$RO Vim$CL"

    vim_preconfiguracion

    if [[ -f '/usr/bin/vim' ]] || ; then
        echo -e "$VE Ya esta$RO Vim$VE instalado en el equipo, omitiendo paso$CL"
    else
        vim_instalar
    fi

    vim_postconfiguracion
}
