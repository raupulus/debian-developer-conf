#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2018 Raúl Caro Pastorino
## @license    https://wwww.gnu.org/licenses/gpl.txt
## @email      dev@fryntiz.es
## @web        https://fryntiz.es
## @github     https://github.com/fryntiz
## @gitlab     https://gitlab.com/fryntiz
## @twitter    https://twitter.com/fryntiz
##
##             Guía de estilos aplicada:
## @style      https://github.com/fryntiz/bash-guide-style

############################
##     INSTRUCCIONES      ##
############################

##
## Añadir plantillas Genéricas
##
usuario_plantillas() {
    crearBackup "$HOME/Plantillas"
    if [[ ! -d "$HOME/Plantillas" ]]; then
        mkdir "$HOME/Plantillas"
    fi
    enlazarHome 'Plantillas/Genéricas'
}
