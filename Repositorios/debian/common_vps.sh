#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2021 Raúl Caro Pastorino
## @license    https://wwww.gnu.org/licenses/gpl.txt
## @email      public@raupulus.dev
## @web        https://raupulus.dev
## @gitlab     https://gitlab.com/raupulus
## @github     https://github.com/raupulus
## @twitter    https://twitter.com/raupulus
##
##             Applied Style Guide:
## @style      https://gitlab.com/raupulus/bash-guide-style

############################
##      INSTRUCTIONS      ##
############################
## Add commons repositories to all debian versions and vps.

###########################
##       FUNCIONES       ##
###########################
##
## Añade llaves oficiales para cada repositorio común
##
common_vps_add_keys() {
    ## Agregando llave para Gitlab Runner.
    echo -e "$VE Agregando llave para$RO Gitlab Runner$CL"
    curl -L "https://packages.gitlab.com/runner/gitlab-runner/gpgkey" 2> /dev/null | sudo apt-key add - &>/dev/null

    ## Webmin
    echo -e "$VE Agregando clave para$RO Webmin$CL"
    wget http://www.webmin.com/jcameron-key.asc && sudo apt-key add jcameron-key.asc
    sudo rm jcameron-key.asc

    ## Docker
    echo -e "$VE Agregando clave para$RO Docker$CL"
    sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys F76221572C52609D

    ## Heroku
    echo -e "$VE Agregando clave para$RO Heroku$CL"
    curl -L https://cli-assets.heroku.com/apt/release.key | sudo apt-key add -

    ## Mi propio repositorio en launchpad
    echo -e "$VE Agregando clave para$RO Fryntiz Repositorio$CL"
    gpg --keyserver keyserver.ubuntu.com --recv-key B5C6D9592512B8CD && gpg -a --export $PUBKRY | sudo apt-key add -

    ## Repositorio de PostgreSQL Oficial
    wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -

    ## Debian Multimedia
    instalarSoftware deb-multimedia-keyring

    ## Repositorio para Tor oficial y estable
    echo -e "$VE Agregando clave para$RO Tor Repositorio$CL"
    curl https://deb.torproject.org/torproject.org/A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89.asc | sudo gpg --import && sudo gpg --export A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89 | sudo apt-key add -
    actualizarRepositorios
    instalarSoftware 'deb.torproject.org-keyring' 'apt-transport-tor'

    ## GoPass (Gestor de Passwords colectivo)
    echo -e "$VE Agregando clave para $RO GooPass$CL"
    wget -q -O- https://api.bintray.com/orgs/gopasspw/keys/gpg/public.key | sudo apt-key add -

    ## GO CD (Desarrollo continuo)
    echo -e "$VE Agregando clave para $RO GO CD$CL"
    curl https://download.gocd.org/GOCD-GPG-KEY.asc | sudo apt-key add -

    ## MongoDB
    echo -e "$VE Agregando clave para $RO MongoDB$CL"
    wget -qO - https://www.mongodb.org/static/pgp/server-5.0.asc | sudo apt-key add -

    ## Jenkins
    echo -e "$VE Agregando clave para $RO Jenkins$CL"
    sudo wget -O /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian/jenkins.io-2023.key

    ## Sury (Paquetes PHP)
    echo -e "$VE Agregando llave para$RO PHP$VE de sury,org$CL"
    sudo wget -O '/etc/apt/trusted.gpg.d/php.gpg' 'https://packages.sury.org/php/apt.gpg'
    sudo chmod 744 '/etc/apt/trusted.gpg.d/php.gpg'

    ## NodeJS
    echo -e "$VE Agregando llave para$RO Nodejs$CL"
    sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 1655A0AB68576280
    curl -fsSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | sudo apt-key add -
}

##
## Instala repositorios que son descargados mediante un script oficial
##
common_vps_download_repositories() {
    echo -e "$VE Descargando repositorios desde scripts oficiales$CL"
    ## NodeJS Oficial
    echo -e "$VE Agregando repositorio$RO NodeJS$AM Repositorio Oficial$CL"
    curl -sL https://deb.nodesource.com/setup_current.x | sudo -E bash -

    ## Sury (Paquetes PHP)
    echo -e "$VE Agregando repositorio$RO Sury$AM Repositorio Oficial$CL"
    #echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/php.list
    echo "deb https://packages.sury.org/php/ bullseye main" | sudo tee /etc/apt/sources.list.d/php.list
}

##
## Añade todos los repositorios y llaves
##
common_vps_add_repositories() {
    echo -e "$VE Instalando repositorios$RO Comunes con los VPS$CL"
    common_vps_download_repositories
    echo -e "$VE Actualizando antes de obtener las llaves, es normal que se muestren errores$AM (Serán solucionados en el próximo paso)$CL"
    actualizarRepositorios
    common_vps_add_keys
    echo -e "$VE Actualizando listas de repositorios definitiva, comprueba que no hay$RO errores$CL"
    actualizarRepositorios
}
