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
## Asigna permisos en el home de usuario poco permisivos donde el propietario
## tiene todos los permisos, el grupo lectura y ejecución y otros nada.
## Además asigna la máscara (umask) para esto por defecto.
##
root_permisos() {
    echo -e "$VE Estableciendo permisos en el sistema$CL"
    ## TODO → Permisos en home de usuario poco permisivos
    ## TODO → Máscara de archivos y directorios por defecto poco permisivo
}
