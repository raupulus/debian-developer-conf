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
## Asigna permisos en el home de usuario poco permisivos donde el propietario
## tiene todos los permisos, el grupo lectura y ejecución y otros nada.
## Además asigna la máscara (umask) para esto por defecto.
##
usuario_permisos() {
    echo -e "$VE Estableciendo permisos en el sistema$CL"
    ## TODO → Permisos en home de usuario poco permisivos
    ## TODO → Máscara de archivos y directorios por defecto poco permisivo
}
