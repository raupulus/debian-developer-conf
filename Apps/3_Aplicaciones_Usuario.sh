#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2017 Raúl Caro Pastorino
## @license    https://wwww.gnu.org/licenses/gpl.txt
## @email      public@raupulus.dev
## @web        https://raupulus.dev
## @github     https://github.com/raupulus
## @gitlab     https://gitlab.com/raupulus
##
##             Applied Style Guide:
## @style      https://gitlab.com/raupulus/bash-guide-style

############################
##      INSTRUCTIONS      ##
############################
## Instala software que se configura para cada usuario de forma independiente
## y necesitará ser ejecutado una vez por cada usuario que quiera implementar
## estas funcionalidades para si mismo.

############################
##     IMPORTACIONES      ##
############################
source "$WORKSCRIPT/Apps/bashit.sh"
source "$WORKSCRIPT/Apps/OhMyZsh.sh"
source "$WORKSCRIPT/Apps/spacevim.sh"
source "$WORKSCRIPT/Apps/vim.sh"

############################
##       FUNCIONES        ##
############################
aplicaciones_usuarios() {
    echo -e "$VE Instalando Aplicaciones específicas para el usuario$RO $USER$CL"
}
