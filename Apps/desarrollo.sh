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
aplicaciones_desarrollo() {
    echo -e "$VE Aplicaciones para Desarrollo$CL"
    actualizarRepositorios

    repararGestorPaquetes

    instalarSoftwareLista "$SOFTLIST/Desarrollo/databases.lst"
    instalarSoftwareLista "$SOFTLIST/Desarrollo/diagramas.lst"
    instalarSoftwareLista "$SOFTLIST/Desarrollo/editores.lst"
    instalarSoftwareLista "$SOFTLIST/Desarrollo/ftp.lst"
    instalarSoftwareLista "$SOFTLIST/Desarrollo/ide.lst"

    repararGestorPaquetes
}
