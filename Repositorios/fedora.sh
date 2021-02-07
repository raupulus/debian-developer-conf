#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2019 Raúl Caro Pastorino
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
## Prepara y configura los repositorios para la última versión de Fedora Stable.

############################
##     IMPORTACIONES      ##
############################

############################
##       FUNCIONES        ##
############################
agregarRepositoriosFedora() {
    echo -e "$VE Configurando Repositorios para$RO Fedora$CL"
    sudo dnf update --refresh -y

    echo -e "$VE Configurando Repositorios para$RO Fedora$CL"
    instalarSoftware 'wget' 'alien' 'sudo' 'git'


    ## Oficiales
    echo -e "$VE Añadiendo Repositorio$RO fedora-workstation-repositories$CL"
    instalarSoftware fedora-workstation-repositories

    ## QownNotes
    echo -e "$VE Añadiendo Repositorio$RO $CL"
    sudo rpm --import http://download.opensuse.org/repositories/home:/pbek:/QOwnNotes/Fedora_$(rpm -E %fedora)/repodata/repomd.xml.key
    sudo wget http://download.opensuse.org/repositories/home:/pbek:/QOwnNotes/Fedora_$(rpm -E %fedora)/home:pbek:QOwnNotes.repo -O /etc/yum.repos.d/QOwnNotes.repo

    ## Atom IDE
    echo -e "$VE Añadiendo Repositorio$RO Atom Editor$CL"
    sudo rpm --import https://packagecloud.io/AtomEditor/atom/gpgkey
    sudo sh -c 'echo -e "[Atom]\nname=Atom Editor\nbaseurl=https://packagecloud.io/AtomEditor/atom/el/7/\$basearch\nenabled=1\ngpgcheck=0\nrepo_gpgcheck=1\ngpgkey=https://packagecloud.io/AtomEditor/atom/gpgkey" > /etc/yum.repos.d/atom.repo'

    ## RPMfusion
    echo -e "$VE Añadiendo Repositorio$RO RPMfusion$CL"
    instalarSoftware https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
    instalarSoftware https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
    #sudo dnf config-manager rpmfusion-nonfree-nvidia-driver --set-enabled

    ## Google Chrome
    echo -e "$VE Añadiendo Repositorio$RO Google Chrome$CL"
    sudo dnf config-manager --set-enabled google-chrome
    sudo dnf config-manager --set-enabled google-chrome-beta

    ## NodeJS
    echo -e "$VE Añadiendo Repositorio para$RO NodeJS$CL"
    curl -sL https://rpm.nodesource.com/setup_12.x | bash -

    ## Gitlab Runner
    echo -e "$VE Añadiendo Repositorio$RO Gitlab Runner$CL"
    curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.rpm.sh | sudo bash

    sudo dnf update --refresh -y
}
