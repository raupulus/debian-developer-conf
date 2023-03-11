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
## Elegir intérprete de comandos entre los actuales instalados del sistema
## Contempla bash y zsh, por defecto si no está zsh configurará solo para bash
##
usuario_interprete() {
    local shell='bash'

    if [[ -f '/bin/bash' ]] && [[ -f '/bin/zsh' ]]; then
        while true; do
            echo -e "$VE Selecciona a continuación el$RO terminal$VE a usar$CL"
            echo -e "$VE Tenga en cuenta que este script está optimizado para$RO bash$CL"
            echo -e "$RO 1)$VE bash$CL"
            echo -e "$RO 2)$VE zsh$CL"
            read -p "Introduce el terminal → bash/zsh: " term
            case "$term" in
                bash | 1) local shell='bash'; break;;
                zsh  | 2) local shell='zsh'; break;;
                *)  ## Opción errónea
                    echo -e "$RO Opción no válida$CL"
            esac
        done
    fi

    ## Asignar shell
    sudo usermod -s "/bin/$shell" "$USER"

    ## Cambiar enlace por defecto desde sh a bash
    sudo rm '/bin/sh'
    sudo ln -s "/bin/$shell" '/bin/sh'
}

##
## Personaliza terminal tilix
##
usuario_tilix() {
    ## TODO → Comprobar si existe instalado cada tema

    if [[ ! -d "$HOME/.config/tilix/schemes/" ]]; then
        echo -e "$VE Creando directorio $HOME/.config/tilix/schemes/$CL"
        mkdir -p "$HOME/.config/tilix/schemes/"
    fi

    wget -qO $HOME"/.config/tilix/schemes/3024-night.json" https://git.io/v7QVY
    wget -qO $HOME"/.config/tilix/schemes/dimmed-monokai.json" https://git.io/v7QaJ
    wget -qO $HOME"/.config/tilix/schemes/monokai.json" https://git.io/v7Qad
    wget -qO $HOME"/.config/tilix/schemes/monokai-soda.json" https://git.io/v7Qao
    wget -qO $HOME"/.config/tilix/schemes/molokai.json" https://git.io/v7QVE
    wget -qO $HOME"/.config/tilix/schemes/cobalt2.json" https://git.io/v7Qav
    wget -qO $HOME"/.config/tilix/schemes/dracula.json" https://git.io/v7QaT
}

user_terminals_installer() {
    echo -e "$VE Configurando terminales$CL"
    usuario_tilix
    usuario_interprete
}
