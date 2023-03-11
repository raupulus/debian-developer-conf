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
## @twitter    https://twitter.com/raupulus
##
##             Applied Style Guide:
## @style      https://gitlab.com/raupulus/bash-guide-style

############################
##      INSTRUCTIONS      ##
############################
## Instala vim de forma global al sistema y lo configura para el usuario que
## ha ejecutado el script generando perfil de color, correccion de sintaxis y
## un conjunto de plugins (incluido vundle) para trabajar con los principales
## lenguajes de progamación que utilizo.
## Al terminar instala y habilita todos los complementos.

############################
##       FUNCIONES        ##
############################
vim_before_install() {
    echo -e "$VE Generando Pre-Configuraciones de$RO Vim$CL"

    ## Si el directorio de configuración para vim es un enlace, se borra
    if [[ -h "$HOME/.vim" ]]; then
        rm -f "$HOME/.vim"
    fi

    local archivosConfiguracion='.vim .vimrc .gvimrc'

    ## Enlazar archivos de este repo
    enlazarHome "$archivosConfiguracion"

    vim_colores() {
        if [[ ! -d "$HOME/.vim/colors" ]]; then
            mkdir -p "$HOME/.vim/colors"
        fi

        ## Creando archivos de colores, por defecto usara "monokai"
        echo -e "$VE Descargando colores para sintaxis$AM"

        echo -e "$VE Descargando Tema$RO Monokai$AM"
        if [[ ! -f "$HOME/.vim/colors/monokai.vim" ]]; then
            descargarTo 'https://raw.githubusercontent.com/sickill/vim-monokai/master/colors/monokai.vim' "$HOME/.vim/colors/monokai.vim"
        fi

        echo -e "$VE Se ha concluido la instalacion de temas de colores$CL"
    }

    vim_colores

    ## Instalar Gestor de Plugins Vundle
    vundle_descargar() {
        echo -e "$VE Descargando Vundle desde Repositorios"
        if [[ ! -d "$HOME/.vim/bundle/Vundle.vim" ]]; then
            descargarGIT 'Vundle.vim' 'https://github.com/VundleVim/Vundle.vim.git' "$HOME/.vim/bundle/Vundle.vim"
        else
            echo -e "$VE Vundle ya está instalado$CL"
        fi
    }

    if [[ -d "${HOME}/.vim/bundle/vim-prettier" ]] &&
       [[ -x '/usr/bin/npm' || -x $HOME/.npm/bin/npm ]]; then
        current=$(pwd)

        cd "${HOME}/.vim/bundle/vim-prettier"
        npm install --legacy-peer-deps
        cd $current
    fi

    vundle_descargar
}

vim_install() {
    echo -e "$VE Instalando$RO Vim$CL"
    instalarSoftwareLista "$SOFTLIST/Apps/vim.lst"
}

vim_after_install() {
    echo -e "$VE Generando Post-Configuraciones$RO Vim$CL"

    ## Configura todos los complementos
    echo | vim +PluginInstall +qall

    ## Funcion para instalar todos los plugins
    vim_plugins() {
        #local plugins_vim=(align closetag powerline youcompleteme xmledit autopep8 python-jedi python-indent utilsinps utl rails snippets fugitive ctrlp tlib tabular sintastic detectindent closetag align syntastic)

        local plugins_vim=(powerline, autopep8)

        for plugin in "${plugins_vim[@]}"; do
            echo -e "$VE Activando el plugin$MA →$RO $plugin $AM"
            vim-addon-manager install "$plugin"
            vim-addon-manager enable "$plugin"
        done
        echo -e "$VE Todos los plugins activados$CL"
    }



    vim_plugins
}

##
## Instalador para vim
##
vim_installer() {
    echo -e "$VE Comenzando instalación de$RO Vim$CL"

    vim_before_install

    vim_install
    vim_after_install
}
