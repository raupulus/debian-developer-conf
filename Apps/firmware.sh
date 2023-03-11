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
aplicaciones_firmware() {
    echo -e "$VE Firmware para el Hardware$CL"
    actualizarRepositorios

    repararGestorPaquetes

    instalarSoftwareLista "$SOFTLIST/Firmware/basico-libre.lst"
    instalarSoftwareLista "$SOFTLIST/Firmware/basico-privado.lst"
    instalarSoftwareLista "$SOFTLIST/Firmware/intel.lst"
    instalarSoftwareLista "$SOFTLIST/Firmware/nvidia-optimus.lst"
    instalarSoftwareLista "$SOFTLIST/Firmware/nvidia.lst"

    repararGestorPaquetes
}
