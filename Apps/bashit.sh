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

############################
##     IMPORTACIONES      ##
############################

###########################
##       FUNCIONES       ##
###########################

bashit_instalador() {
    if [ -f ~/.bash_it/bash_it.sh ] #Comprobar si ya esta instalado
    then
        echo -e "$verde Ya esta$rojo Bash-It$verde instalado para este usuario, omitiendo paso$gris"
        bash ~/.bash_it/install.sh --silent 2>> /dev/null
    else
        REINTENTOS=5

        echo -e "$verde Descargando Bash-It$gris"
        for (( i=1; i<=$REINTENTOS; i++ ))
        do
            rm -R ~/.bash_it 2>> /dev/null
            git clone --depth=1 https://github.com/Bash-it/bash-it.git ~/.bash_it && bash ~/.bash_it/install.sh --silent && break
        done
    fi

    if [ -f ~/.nvm/nvm.sh ] #Comprobar si ya esta instalado
    then
        echo -e "$verde Ya esta$rojo nvm$verde instalado para este usuario, omitiendo paso$gris"
    else
        REINTENTOS=5
        echo -e "$verde Descargando nvm$gris"
        for (( i=1; i<=$REINTENTOS; i++ ))
        do
            rm -R ~/.nvm 2>> /dev/null
            git clone https://github.com/creationix/nvm.git ~/.nvm && ~/.nvm/install.sh && break
        done
    fi

    if [ -f ~/fasd/fasd.1.md ] #Comprobar si ya esta instalado
    then
        echo -e "$verde Ya esta$rojo fasd$verde instalado para este usuario, omitiendo paso$gris"
    else
        REINTENTOS=5

        echo -e "$verde Descargando fasd$gris"
        for (( i=1; i<=$REINTENTOS; i++ ))
        do
            tmp=$pwd
            rm -R -f "~/fasd" 2>> /dev/null
            git clone https://github.com/clvv/fasd ~/fasd && cd ~/fasd && sudo make install && break
            cd $tmp
        done
    fi

    #Instalando dependencias
    echo -e "$verde Instalando dependencias de$rojo Bashit$gris"
    sudo apt install -y rbenv >> /dev/null 2>> /dev/null

    #Habilitar todos los plugins
    #TOFIX → Este paso solo puede hacerse correctamente cuando usamos /bin/bash
    plugins_habilitar="alias-completion aws base battery edit-mode-vi explain extract fasd git gif hg java javascript latex less-pretty-cat node nvm postgres projects python rails ruby sshagent ssh subversion xterm dirs nginx plenv pyenv rbenv"

    if [ -n $BASH ] && [ $BASH = '/bin/bash' ]
    then
        echo -e "$verde Habilitando todos los plugins para$rojo Bashit$gris"

        # Incorpora archivo de bashit
        export BASH_IT="/$HOME/.bash_it"
        export BASH_IT_THEME='powerline-multiline'
        export SCM_CHECK=true
        export SHORT_TERM_LINE=true
        source "$BASH_IT"/bash_it.sh

        for p in $plugins_habilitar
        do
            bash-it enable plugin $p
        done

        #Asegurar que los plugins conflictivos estén deshabilitados:
        echo -e "$verde Deshabilitando plugins no usados en$rojo Bashit$gris"
        bash-it disable plugin chruby chruby-auto z z_autoenv visual-studio-code gh
    else
        echo -e "$verde Para habilitar los$rojo plugins de BASH$verde ejecuta este scripts desde$rojo bash$gris"
    fi
}
