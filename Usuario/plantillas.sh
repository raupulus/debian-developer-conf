#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2018 Raúl Caro Pastorino
## @license    https://wwww.gnu.org/licenses/gpl.txt
## @email      public@raupulus.dev
## @web        https://raupulus.dev
## @github     https://github.com/raupulus
## @gitlab     https://gitlab.com/raupulus
## @twitter    https://twitter.com/raupulus
##
##             Applied Style Guide:
## @style      https://gitlab.com/raupulus/bash-guide-style

############################
##      INSTRUCTIONS      ##
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
