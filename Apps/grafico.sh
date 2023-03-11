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
aplicaciones_grafico() {
    echo -e "$VE Aplicaciones de Diseño Gráfico$CL"
    actualizarRepositorios

    repararGestorPaquetes

    instalarSoftwareLista "$SOFTLIST/Diseño-grafico/2d.lst"
    instalarSoftwareLista "$SOFTLIST/Diseño-grafico/3d.lst"
    instalarSoftwareLista "$SOFTLIST/Diseño-grafico/mapas-de-bits.lst"
    instalarSoftwareLista "$SOFTLIST/Diseño-grafico/utilidades.lst"
    instalarSoftwareLista "$SOFTLIST/Diseño-grafico/vectores.lst"
    instalarSoftwareLista "$SOFTLIST/Diseño-grafico/visores.lst"

    repararGestorPaquetes
}
