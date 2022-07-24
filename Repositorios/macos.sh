#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2022 Raúl Caro Pastorino
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
## Prepara y configura los repositorios para la última versión de Macos Stable.

############################
##     IMPORTACIONES      ##
############################

############################
##       FUNCIONES        ##
############################
agregarRepositoriosMacos() {
    echo -e '$VE Configurando Repositorios para$RO Macos'

    ## Preparar xcode
    xcode-select --install

    ## Instalar Homebrew
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

    ## Declaro tty para firmas gpg si hiciera falta
    export GPG_TTY=$(tty)

    if [[ ! -d "${HOME}/.gnupg/gpg-agent.conf" ]];then
        echo 'pinentry-program /usr/local/bin/pinentry-mac' > ~/.gnupg/gpg-agent.conf
    fi

    ## Aseguro que se encuentra el ejecutable "brew"
    eval "$(/opt/homebrew/bin/brew shellenv)"

    ## Verificar instalación de Homebrew
    brew doctor

    ## Instalo herramientas
    brew install wget

    ## Añado más repositorios a HomeBrew
    brew tap homebrew/core
    brew tap homebrew/cask-versions
    brew tap shivammathur/php

    ## Repositorio de mongodb https://www.mongodb.com/docs/manual/tutorial/install-mongodb-on-os-x/
    brew tap mongodb/brew

    ## Cakebrew (Gui para homebrew) https://www.cakebrew.com/
    brew install --cask cakebrew

    ## Instalo llavero gpg: https://gist.github.com/troyfontaine/18c9146295168ee9ca2b30c00bd1b41e
    brew install gnupg pinentry-mac gpg-suite

    if [[ ! -d $HOME/.gnupg ]]; then
        mkdir "${HOME}/.gnupg"
    fi

    # This tells gpg to use the gpg-agent
    echo 'use-agent' > "${HOME}/.gnupg/gpg.conf"
    sudo chmod 700 "${HOME}/.gnupg"
    export GPG_TTY=$(tty)

    #echo "test" | gpg --clearsign

    if [[ ! -f "${HOME}/.bashrc" ]]; then
        echo 'GPG_TTY=$(tty)' > "${HOME}/.bashrc"
        echo 'export GPG_TTY' >> "${HOME}/.bashrc"
    else
      echo
        #TODO COMPROBAR SI LO CONTIENE
    fi

    if [[ ! -f "${HOME}/.zshrc" ]]; then
        echo 'GPG_TTY=$(tty)' > "${HOME}/.zshrc"
        echo 'export GPG_TTY' >> "${HOME}/.zshrc"
    else
        echo
        #TODO COMPROBAR SI LO CONTIENE
    fi

    # TODO Comprobar intérprete
    source "${HOME}/.bashrc"
    #source "${HOME}/.zshrc"


    ## Si locate no tiene base de datos
    sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.locate.plist 2> /dev/null
}
