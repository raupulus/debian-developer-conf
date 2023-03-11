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
aplicaciones_desarrollo() {
    echo -e "$VE Aplicaciones para Desarrollo$CL"
    actualizarRepositorios

    repararGestorPaquetes

    instalarSoftwareLista "$SOFTLIST/Desarrollo/comandos.lst"
    instalarSoftwareLista "$SOFTLIST/Desarrollo/control-versiones.lst"
    instalarSoftwareLista "$SOFTLIST/Desarrollo/databases.lst"
    instalarSoftwareLista "$SOFTLIST/Desarrollo/diagramas.lst"
    instalarSoftwareLista "$SOFTLIST/Desarrollo/editores.lst"
    instalarSoftwareLista "$SOFTLIST/Desarrollo/ftp.lst"
    instalarSoftwareLista "$SOFTLIST/Desarrollo/ide.lst"
    instalarSoftwareLista "$SOFTLIST/Desarrollo/nubes.lst"
    instalarSoftwareLista "$SOFTLIST/Desarrollo/android.lst"

    repararGestorPaquetes
}
