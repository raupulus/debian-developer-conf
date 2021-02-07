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
aplicaciones_sonido() {
    echo -e "$VE Aplicaciones para Sonido$CL"
    actualizarRepositorios

    repararGestorPaquetes

    instalarSoftwareLista "$SOFTLIST/Sonido/codecs.lst"
    instalarSoftwareLista "$SOFTLIST/Sonido/conversores.lst"
    instalarSoftwareLista "$SOFTLIST/Sonido/editores.lst"
    instalarSoftwareLista "$SOFTLIST/Sonido/reproductores.lst"

    repararGestorPaquetes
}
