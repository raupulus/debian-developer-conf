#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2018 Raúl Caro Pastorino
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

##
## Elegir intérprete de comandos entre los actuales instalados del sistema
## Contempla bash y zsh, por defecto si no está zsh configurará solo para bash
##
root_interprete() {
    echo -e "$VE Configurando terminal$CL"
}

##
## Personaliza terminal tilix
##
root_tilix() {
     echo -e "$VE Configurando tilix$CL"
}

root_terminales() {
    echo -e "$VE Configurando terminales$CL"
    root_tilix
    root_interprete
}
