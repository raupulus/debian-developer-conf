#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2020 Raúl Caro Pastorino
## @license    https://wwww.gnu.org/licenses/gpl.txt
## @email      raul@fryntiz.dev
## @web        https://fryntiz.es
## @github     https://github.com/fryntiz
## @gitlab     https://gitlab.com/fryntiz
## @twitter    https://twitter.com/fryntiz
##
##             Applied Style Guide:
## @style      https://gitlab.com/fryntiz/bash-guide-style

############################
##      INSTRUCTIONS      ##
############################
## Personalizando GRUB

############################
##       FUNCIONES        ##
############################

grub_install() {
    echo -e "$VE Personalizando $RO GRUB$CL"

    if [[ -f "$SOFTLIST/Personalizar/grub.lst" ]]; then
        instalarSoftwareLista "$SOFTLIST/Personalizar/grub.lst"
    fi
}
