#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2020 Raúl Caro Pastorino
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
