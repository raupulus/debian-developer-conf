#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2019 Raúl Caro Pastorino
## @license    https://wwww.gnu.org/licenses/gpl.txt
## @email      dev@fryntiz.es
## @web        https://fryntiz.es
## @gitlab     https://gitlab.com/fryntiz
## @github     https://github.com/fryntiz
## @twitter    https://twitter.com/fryntiz
##
##             Guía de estilos aplicada:
## @style      https://gitlab.com/fryntiz/bash-guide-style

############################
##     INSTRUCCIONES      ##
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
    sudo dnf update --refresh

    ## Oficiales
    echo -e "$VE Añadiendo Repositorio$RO fedora-workstation-repositories$CL"
    sudo dnf install fedora-workstation-repositories

    ## QownNotes
    echo -e "$VE Añadiendo Repositorio$RO $CL"
    sudo rpm --import http://download.opensuse.org/repositories/home:/pbek:/QOwnNotes/Fedora_$(rpm -E %fedora)/repodata/repomd.xml.key
    sudo wget http://download.opensuse.org/repositories/home:/pbek:/QOwnNotes/Fedora_$(rpm -E %fedora)/home:pbek:QOwnNotes.repo -O /etc/yum.repos.d/QOwnNotes.repo

    ## Atom IDE
    echo -e "$VE Añadiendo Repositorio$RO Atom Editor$CL"
    sudo dnf copr enable mosquito/atom

    ## RPMfusion
    echo -e "$VE Añadiendo Repositorio$RO RPMfusion$CL"
    sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
    sudo dnf install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

    ## Google Chrome
    echo -e "$VE Añadiendo Repositorio$RO Google Chrome$CL"
    sudo dnf config-manager --set-enabled google-chrome
    sudo dnf config-manager --set-enabled google-chrome-beta

    sudo dnf update --refresh
}
