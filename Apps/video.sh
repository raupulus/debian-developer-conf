#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2019 Raúl Caro Pastorino
## @license    https://wwww.gnu.org/licenses/gpl.txt
## @email      dev@fryntiz.es
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
aplicaciones_video() {
    echo -e "$VE Aplicaciones para Vídeo$CL"
    actualizarRepositorios

    repararGestorPaquetes

    instalarSoftwareLista "$SOFTLIST/Video/codecs.lst"
    instalarSoftwareLista "$SOFTLIST/Video/conversores.lst"
    instalarSoftwareLista "$SOFTLIST/Video/editores.lst"
    instalarSoftwareLista "$SOFTLIST/Video/reproductores.lst"

    repararGestorPaquetes
}
