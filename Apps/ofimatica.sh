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
