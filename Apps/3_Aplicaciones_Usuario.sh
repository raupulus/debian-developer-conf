#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2017 Raúl Caro Pastorino
## @license    https://wwww.gnu.org/licenses/gpl.txt
## @email      tecnico@fryntiz.es
## @web        www.fryntiz.es
## @github     https://github.com/fryntiz
## @gitlab     https://gitlab.com/fryntiz
##
##             Guía de estilos aplicada:
## @style      https://github.com/fryntiz/Bash_Style_Guide

############################
##     INSTRUCCIONES      ##
############################
## Instala software que se configura para cada usuario de forma independiente
## y necesitará ser ejecutado una vez por cada usuario que quiera implementar
## estas funcionalidades para si mismo.

############################
##     IMPORTACIONES      ##
############################
source "$WORKSCRIPT/Apps/bashit.sh"
source "$WORKSCRIPT/Apps/OhMyZsh.sh"
source "$WORKSCRIPT/Apps/Firefox.sh"
source "$WORKSCRIPT/Apps/spacevim.sh"
source "$WORKSCRIPT/Apps/vim.sh"

############################
##       FUNCIONES        ##
############################
configurar_heroku() {
    echo -e "$VE Se va a configurar$RO Heroku$CL"
    instalarSoftware 'heroku'
    echo -e "$VE ¿Quieres configurar tu cuenta de$RO Heroku?$CL"
    echo -e "$VE Para configurar la cuenta tienes que tenerla creada$CL"
    read -p '    s/N → ' input
    if [[ $input = 's' ]] || [[ $input = 'S' ]]; then
        heroku login
    fi
}

##
## Mi generador de proyectos https://github.com/fryntiz/Generador_Proyectos.git
## Este generador de proyectos crea un script que permite generar la estructura
## para los proyectos más recurridos por mi (php, python, bash....) y después
## pregunta si subirlo automáticamente a GitHub
##
generador_proyectos() {
    descargarGIT 'Generador de Proyectos' 'https://github.com/fryntiz/Generador_Proyectos.git' "$WORKSCRIPT/tmp/Generador_Proyectos"

    cd "$WORKSCRIPT/tmp/Generador_Proyectos" || return 1 && ./instalar.sh
    cd "$WORKSCRIPT" || exit
}

##
## Crea un comando para generar plantillas de archivos
##
generador_plantillas() {
    if [[ -f "$HOME/.local/bin/nuevo" ]]; then
        rm -f "$HOME/.local/bin/nuevo"
    fi

    cp "$WORKSCRIPT/conf/home/.local/bin/nuevo" "$HOME/.local/bin/nuevo"
}

devicons_ls() {
    descargarGIT 'devicons-ls' 'https://github.com/ryanoasis/devicons-shell.git' "$WORKSCRIPT/tmp/devicons-shell"

    if [[ -f "$HOME/.local/bin/devicons-ls" ]]; then
        rm -f "$HOME/.local/bin/devicons-ls"
    fi

    cp "$WORKSCRIPT/tmp/devicons-shell/devicons-ls" "$HOME/.local/bin/devicons-ls"
}

aplicaciones_usuarios() {
    echo -e "$VE Instalando Aplicaciones específicas para el usuario$RO $USER$CL"
    configurar_heroku
    firefox_instalador
    bashit_Instalador
    ohmyzsh_Instalador

    while true; do
        echo -e "$VE ¿Quieres instalar$RO vim$VE o$RO spacevim$CL"
        echo -e "$RO 1)$VE vim$CL"
        echo -e "$RO 2)$VE spacevim$CL"
        read -p "→ " editor
        case "$editor" in
            vim | 1)
                vim_Instalador
                break;;
            spacevim | 2)
                spacevim_Instalador
                break;;
            *)  ## Opción errónea
                clear
                echo -e "$RO Opción no válida$CL"
        esac
    done

    devicons_ls

    ## Mis propias aplicaciones
    generador_proyectos
}
