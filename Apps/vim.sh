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
## Instala vim de forma global al sistema y lo configura para el usuario que
## ha ejecutado el script generando perfil de color, correccion de sintaxis y
## un conjunto de plugins (incluido vundle) para trabajar con los principales
## lenguajes de progamación que utilizo.
## Al terminar instala y habilita todos los complementos.

############################
##       FUNCIONES        ##
############################
vim_preconfiguracion() {
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

        if [[ ! -f "$HOME/.vim/colors/wombat.vim" ]]; then
            descargarTo 'http://www.vim.org/scripts/download_script.php?src_id=6657' "$HOME/.vim/colors/wombat.vim"
        fi

        echo -e "$VE Descargando Tema$RO Monokai$AM"
        if [[ ! -f "$HOME/.vim/colors/monokai1.vim" ]]; then
            descargarTo 'https://raw.githubusercontent.com/lsdr/monokai/master/colors/monokai.vim' "$HOME/.vim/colors/monokai_1.vim"
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

    vundle_descargar
}

vim_instalar() {
    echo -e "$VE Preparando para instalar$RO Vim$CL"
    ## La siguiente variable guarda toda la lista de paquetes desde DPKG
    local lista_todos_paquetes=(${dpkg-query -W -f='${Installed-Size} ${Package}\n' | sort -n | cut -d" " -f2})

    ## Comprueba si el software está instalado y en caso contrario instala
    local dependencias=(vim vim-addon-manager vim-addon-mw-utils vim-asciidoc vim-athena vim-autopep8 vim-command-t vim-conque vim-ctrlp vim-editorconfig vim-fugitive vim-gnome vim-gocomplete vim-gtk vim-gtk3 vim-haproxy vim-icinga2 vim-khuno vim-lastplace vim-latexsuite vim-migemo vim-nox vim-pathogen vim-python-jedi vim-rails vim-runtime vim-scripts vim-snipmate vim-snippets vim-syntastic vim-syntax-gtk vim-tabular vim-tjp vim-tlib vim-ultisnips vim-vimerl vim-vimerl-syntax vim-vimoutliner vim-voom vim-youcompleteme)
    for s in "${dependencias[@]}"; do
        for x in "${lista_todos_paquetes[@]}"; do
            if [[ "$s" = "$x" ]]; then
                echo -e "$RO $s$VE ya estaba instalado$CL"
                break
            else
                instalarSoftware "$s"
                break
            fi
        done
    done
}

vim_postconfiguracion() {
    echo -e "$VE Generando Post-Configuraciones$RO Vim$CL"

    ## Configura todos los complementos
    echo | vim +PluginInstall +qall

    ## Funcion para instalar todos los plugins
    vim_plugins() {
        local plugins_vim=(align closetag powerline youcompleteme xmledit autopep8 python-jedi python-indent utilsinps utl rails snippets fugitive ctrlp tlib tabular sintastic detectindent closetag align syntastic)

        for plugin in "${plugins_vim[@]}"; do
            echo -e "$VE Activando el plugin$MA →$RO $plugin $AM"
            vim-addon-manager install "$plugin"
            vim-addon-manager enable "$plugin"
        done
        echo -e "$VE Todos los plugins activados$CL"
    }

    vim_plugins
}

vim_Instalador() {
    echo -e "$VE Comenzando instalación de$RO Vim$CL"

    vim_preconfiguracion

    vim_instalar
    vim_postconfiguracion
}
