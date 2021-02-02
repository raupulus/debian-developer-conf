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
##             Guía de estilos aplicada:
## @style      https://gitlab.com/fryntiz/bash-guide-style

############################
##     INSTRUCCIONES      ##
############################

##
## Configurar editor de terminal, nano
##
usuario_nano() {
    echo -e "$VE Configurando editor$RO nano$CL"

    if [[ -d "$HOME/.nano" ]] && [[ ! -d "$HOME/.nano/.git" ]]; then
        crearBackup '.nano'
        rm -Rf "$HOME/.nano"
    fi

    descargarGIT 'Nano' 'https://github.com/scopatz/nanorc.git' "$HOME/.nano"

    ## Habilita syntaxis para el usuario
    cat "$HOME/.nano/nanorc" > "$HOME/.nanorc"
}
