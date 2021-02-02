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
