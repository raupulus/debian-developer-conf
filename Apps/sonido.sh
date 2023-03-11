#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2019 Raúl Caro Pastorino
## @license    https://wwww.gnu.org/licenses/gpl.txt
## @email      public@raupulus.dev
## @web        https://raupulus.dev
## @gitlab     https://gitlab.com/raupulus
## @github     https://github.com/raupulus
##
##             Applied Style Guide:
## @style      https://gitlab.com/raupulus/bash-guide-style

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
