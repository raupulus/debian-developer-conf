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
##             Guía de estilos aplicada:
## @style      https://gitlab.com/fryntiz/bash-guide-style

############################
##     INSTRUCCIONES      ##
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
