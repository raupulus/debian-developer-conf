#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2019 Raúl Caro Pastorino
## @license    https://wwww.gnu.org/licenses/gpl.txt
## @email      raul@fryntiz.dev
## @web        https://fryntiz.es
## @gitlab     https://gitlab.com/fryntiz
## @github     https://github.com/fryntiz
##
##             Applied Style Guide:
## @style      https://gitlab.com/fryntiz/bash-guide-style

############################
##      INSTRUCTIONS      ##
############################
##

###########################
##       FUNCIONES       ##
###########################
aplicaciones_ofimatica() {
    echo -e "$VE Aplicaciones de Ofimática$CL"
    actualizarRepositorios

    repararGestorPaquetes

    instalarSoftwareLista "$SOFTLIST/Ofimatica/conversores.lst"
    instalarSoftwareLista "$SOFTLIST/Ofimatica/editores.lst"
    instalarSoftwareLista "$SOFTLIST/Ofimatica/suites.lst"
    instalarSoftwareLista "$SOFTLIST/Ofimatica/visores.lst"

    repararGestorPaquetes
}
