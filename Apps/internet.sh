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
aplicaciones_internet() {
    echo -e "$VE Aplicaciones para Internet$CL"
    actualizarRepositorios

    repararGestorPaquetes

    instalarSoftwareLista "$SOFTLIST/Internet/correo.lst"
    instalarSoftwareLista "$SOFTLIST/Internet/descargar.lst"
    instalarSoftwareLista "$SOFTLIST/Internet/herramientas.lst"
    instalarSoftwareLista "$SOFTLIST/Internet/navegadores.lst"
    instalarSoftwareLista "$SOFTLIST/Internet/nubes.lst"
    instalarSoftwareLista "$SOFTLIST/Internet/redes-sociales.lst"

    repararGestorPaquetes
}
