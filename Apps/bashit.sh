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
## @twitter    https://twitter.com/fryntiz
##
##             Guía de estilos aplicada:
## @style      https://github.com/fryntiz/Bash_Style_Guide

############################
##     INSTRUCCIONES      ##
############################

###########################
##       FUNCIONES       ##
###########################
bashit_descargar() {
    local REINTENTOS=5

    echo -e "$VE Descargando$RO Bash-It$CL"
    for (( i=1; i<=$REINTENTOS; i++ )); do
        rm -R ~/.bash_it 2>> /dev/null
        git clone --depth=1 "https://github.com/Bash-it/bash-it.git" "$HOME/.bash_it" && bash "$HOME/.bash_it/install.sh" --silent && break
    done
}

bashit_preconfiguracion() {
    local paquetes_dependencias='rbenv'

    ## Instalando dependencias
    echo -e "$VE Instalando dependencias de$RO Bashit$CL"
    instalarSoftware "$paquetes_dependencias"
}

bashit_instalar() {
    ## Instalar Bash-It
    bash "$HOME/.bash_it/install.sh" --silent 2>> /dev/null

    ## Instalar "nvm"
    if [[ -f "$HOME/.nvm/nvm.sh" ]]; then ## Comprobar si ya esta instalado
        echo -e "$VE Ya esta$RO nvm$VE instalado para este usuario, omitiendo paso$CL"
    else
        descargarGIT 'Nvm' "https://github.com/creationix/nvm.git" "$HOME/.nvm" && "$HOME/.nvm/install.sh"
    fi

    ## Instalar "fasd"
    ## TOFIX → Mandar a $HOME/.local/src=? ya que compila y no se vuelve a usar
    if [[ -f "$HOME/fasd/fasd.1.md" ]]; then
        echo -e "$VE Ya esta$RO fasd$VE instalado para este usuario, omitiendo paso$CL"
    else
        cd "$HOME"
        rm -R -f "$HOME/fasd" 2>> /dev/null
        descargarGIT 'fasd' "https://github.com/clvv/fasd" "$HOME/fasd" && cd "$HOME/fasd" && sudo make install
        cd "$WORKSCRIPT"
    fi
}

bashit_postconfiguracion() {
    local archivosConfiguracion='.bashrc powerline dunst .dircolors .less .lessfilter .tmux.conf'

    ## Crea el backup y enlazar archivos de este repo
    enlazarHome $archivosConfiguracion

    ## Actualizando repositorio para Bash-It
    cd "$HOME/.bash_it/"
    git pull 2>> /dev/null
    cd "$WORKSCRIPT"

    ## Habilitar todos los plugins
    local plugins_habilitar="alias-completion aws base battery edit-mode-vi explain extract fasd git gif hg java javascript latex less-pretty-cat node nvm postgres projects python rails ruby sshagent ssh subversion xterm dirs nginx plenv pyenv rbenv"

    local plugins_deshabilitar="chruby chruby-auto z z_autoenv visual-studio-code gh"

    if [[ -n "$BASH" ]] && [[ "$BASH" = '/bin/bash' ]]; then
        echo -e "$VE Habilitando todos los plugins para$RO Bashit$CL"

        ## Incorpora archivo de bashit
        export BASH_IT="/$HOME/.bash_it"
        export BASH_IT_THEME='powerline-multiline'
        export SCM_CHECK=true
        export SHORT_TERM_LINE=true
        source "$BASH_IT"/bash_it.sh

        for p in $plugins_habilitar; do
            bash-it enable plugin "$p"
        done

        ## Asegurar que los plugins conflictivos estén deshabilitados:
        echo -e "$VE Deshabilitando plugins no usados en$RO Bashit$CL"
        for p in $plugins_deshabilitar; do
            bash-it disable plugin "$p"
        done
    else
        echo -e "$VE Para habilitar los$RO plugins de BASH$VE ejecuta este scripts desde$RO bash$CL"
    fi
}

bashit_Instalador() {
    bashit_preconfiguracion

    ## Instalar script bash-it desde github solo si no está instalado
    if [[ -f "$HOME/.bash_it/bash_it.sh" ]]; then
        echo -e "$VE Ya esta$RO Bash-It$VE instalado para este usuario, omitiendo paso$CL"
    else
        bashit_descargar
        bashit_instalar
    fi

    bashit_postconfiguracion
}
