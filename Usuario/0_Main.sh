#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2018 Raúl Caro Pastorino
## @license    https://wwww.gnu.org/licenses/gpl.txt
## @email      raul@fryntiz.dev
## @web        https://fryntiz.es
## @gitlab     https://gitlab.com/fryntiz
## @github     https://github.com/fryntiz
## @twitter    https://twitter.com/fryntiz
##
##             Applied Style Guide:
## @style      https://gitlab.com/fryntiz/bash-guide-style

############################
##      INSTRUCTIONS      ##
############################
## Menú principal para configurar al usuario

############################
##     IMPORTACIONES      ##
############################
source "$WORKSCRIPT/Usuario/gedit.sh"
source "$WORKSCRIPT/Usuario/nano.sh"
source "$WORKSCRIPT/Usuario/permisos.sh"
source "$WORKSCRIPT/Usuario/plantillas.sh"
source "$WORKSCRIPT/Usuario/programas-default.sh"
source "$WORKSCRIPT/Usuario/terminales.sh"
source "$WORKSCRIPT/Usuario/heroku.sh"
source "$WORKSCRIPT/Usuario/bashit.sh"
source "$WORKSCRIPT/Usuario/OhMyZsh.sh"
source "$WORKSCRIPT/Usuario/spacevim.sh"
source "$WORKSCRIPT/Usuario/vim.sh"
source "$WORKSCRIPT/Usuario/tmux.sh"
source "$WORKSCRIPT/Usuario/powerline.sh"

###########################
##       FUNCIONES       ##
###########################
##
## Mi generador de proyectos https://github.com/fryntiz/project-generator
## Este generador de proyectos crea un script que permite generar la estructura
## para los proyectos más recurridos por mi (php, python, bash....) y después
## pregunta si subirlo automáticamente a GitHub
##
generador_proyectos() {
    descargarGIT 'Generador de Proyectos' 'https://github.com/fryntiz/project-generator.git' "$WORKSCRIPT/tmp/project-generator"

    cd "$WORKSCRIPT/tmp/project-generator" || return 1 && ./instalar.sh
    cd "$WORKSCRIPT" || exit
}
##
## Crea un comando para generar plantillas de archivos
##
generador_plantillas() {
    enlazarHome '.local/bin/nuevo'
    sudo chmod 755 "/home/${USER}/.local/bin/nuevo"
    sudo chown ${USER}:${USER} "/home/${USER}/.local/bin/nuevo"
}

##
## Enlaza comandos personalizados en ~/.local/bin
##
comandosPersonalizados() {
    ## Actualizar Sistema y Paquetes
    enlazarHome '.local/bin/actualizar'
    sudo chmod 755 "/home/${USER}/.local/bin/actualizar"
    sudo chown ${USER}:${USER} "/home/${USER}/.local/bin/actualizar"

    ## Limpiar caché DNS local
    enlazarHome '.local/bin/limpiar-cache-dns'
    sudo chmod 755 "/home/${USER}/.local/bin/limpiar-cache-dns"
    sudo chown ${USER}:${USER} "/home/${USER}/.local/bin/limpiar-cache-dns"

    ## Limpiar Sistema y aplicaciones de usuario/root
    enlazarHome '.local/bin/limpiar-cache-sistema'
    sudo chmod 755 "/home/${USER}/.local/bin/limpiar-cache-sistema"
    sudo chown ${USER}:${USER} "/home/${USER}/.local/bin/limpiar-cache-sistema"
}

devicons_ls() {
    descargarGIT 'devicons-ls' 'https://github.com/ryanoasis/devicons-shell.git' "$WORKSCRIPT/tmp/devicons-shell"

    if [[ -f "$HOME/.local/bin/devicons-ls" ]]; then
        rm -f "$HOME/.local/bin/devicons-ls"
    fi

    cp "$WORKSCRIPT/tmp/devicons-shell/devicons-ls" "$HOME/.local/bin/devicons-ls"
}

softwareUsuarioMinimo() {
    usuario_permisos
    usuario_programas_default
    usuario_nano
    usuario_terminales
    tmux_Instalador
    powerline_Instalador

    ## Instalación de Vim o Spacevim
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
                clear_screen
                echo -e "$RO Opción no válida$CL"
        esac
    done
}

softwareUsuarioExtra() {
    bashit_Instalador
    ohmyzsh_Instalador
    usuario_gedit
    usuario_plantillas
    usuario_heroku
    devicons_ls

    ## Mis propias aplicaciones
    generador_proyectos
    generador_plantillas
    comandosPersonalizados
}

##
## Menú instalar todas las configuraciones del usuario
##
menuUsuario() {
    cd "$WORKSCRIPT" || exit 1

    if [[ "$1" = '-m' ]] || [[ "$1" = '-min' ]]; then
        softwareUsuarioMinimo
    else
        softwareUsuarioMinimo
        softwareUsuarioExtra
    fi
}
