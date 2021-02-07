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
aplicaciones_video() {
    echo -e "$VE Aplicaciones para Vídeo$CL"
    actualizarRepositorios

    repararGestorPaquetes

    instalarSoftwareLista "$SOFTLIST/Video/codecs.lst"
    instalarSoftwareLista "$SOFTLIST/Video/conversores.lst"
    instalarSoftwareLista "$SOFTLIST/Video/editores.lst"
    instalarSoftwareLista "$SOFTLIST/Video/reproductores.lst"
    instalarSoftwareLista "$SOFTLIST/Video/record_screen.lst"

    repararGestorPaquetes
}
