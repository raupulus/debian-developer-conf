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
## Este script agrega repositorios comunes para todas las ramas.

###########################
##       FUNCIONES       ##
###########################
##
## Añade llaves oficiales para cada repositorio común
##
comunes_agregar_llaves() {
    ## Riot
    echo -e "$VE Agregando clave para$RO Riot$CL"
    curl -L https://riot.im/packages/debian/repo-key.asc | sudo apt-key add -

    ## Multisystem
    echo -e "$VE Agregando clave para$RO Multisystem$CL"
    sudo wget -q -O - http://liveusb.info/multisystem/depot/multisystem.asc | sudo apt-key add -

    ## Webmin
    echo -e "$VE Agregando clave para$RO Webmin$CL"
    wget http://www.webmin.com/jcameron-key.asc && sudo apt-key add jcameron-key.asc
    sudo rm jcameron-key.asc

    ## Virtualbox Oficial
    echo -e "$VE Agregando clave para$RO Virtualbox$CL"
    sudo wget https://www.virtualbox.org/download/oracle_vbox_2016.asc -O '/tmp/oracle_vbox.asc'
    sudo apt-key add '/tmp/oracle_vbox.asc'
    sudo rm '/tmp/oracle_vbox.asc'

    ## Docker
    echo -e "$VE Agregando clave para$RO Docker$CL"
    sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys F76221572C52609D

    ## Heroku
    echo -e "$VE Agregando clave para$RO Heroku$CL"
    curl -L https://cli-assets.heroku.com/apt/release.key | sudo apt-key add -

    ## Kali Linux
    echo -e "$VE Agregando clave para$RO Kali Linux$CL"
    sudo apt-key adv --keyserver pgp.mit.edu --recv-keys ED444FF07D8D0BF6

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

    ## Repositorio para Team Viewer.
    echo -e "$VE Agregando clave para$RO Team Viewer Repositorio Oficial$CL"
    wget -O - https://download.teamviewer.com/download/linux/signature/TeamViewer2017.asc | sudo apt-key add -

    ## Repositorio para Etcher
    echo -e "$VE Agregando clave para$RO Etcher$CL"
    sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 379CE192D401AB61

    ## Repositorio para editor Atom.
    echo -e "$VE Agregando clave para el editor$RO Atom$CL"
    wget -qO - https://packagecloud.io/AtomEditor/atom/gpgkey | sudo apt-key add -

    ## Repositorio para editor DBeaver.
    echo -e "$VE Agregando clave para el editor SQL$RO DBeaver$CL"
    wget -O - https://dbeaver.io/debs/dbeaver.gpg.key | sudo apt-key add -

    ## Repositorio para editor VS Codium.
    echo -e "$VE Agregando clave para el editor$RO VS Codium$CL"
    wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg | gpg --dearmor | sudo dd of=/etc/apt/trusted.gpg.d/vscodium-archive-keyring.gpg
    sudo chmod ugo+r /etc/apt/trusted.gpg.d/vscodium-archive-keyring.gpg
    #sudo touch /etc/apt/apt.conf.d/99verify-peer.conf
    #echo "Acquire { https::Verify-Peer false }" | sudo tee /etc/apt/apt.conf.d/99verify-peer.conf

    ## Google Earth
    echo -e "$VE Agregando clave para $RO Google Earth$CL"
    wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -

    ## Sublime Text
    echo -e "$VE Agregando clave para el editor$RO Sublime Text$CL"
    wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -

    ## Skype
    #echo -e "$VE Agregando clave para $RO Skype$CL"
    #sudo curl https://packages.microsoft.com/keys/microsoft.asc | sudo gpg --dearmor > microsoft.gpg && sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
    #sudo chown root:root /etc/apt/trusted.gpg.d/microsoft.gpg && sudo chmod 644 /etc/apt/trusted.gpg.d/microsoft.gpg

    ## GoPass (Gestor de Passwords colectivo)
    echo -e "$VE Agregando clave para $RO GooPass$CL"
    wget -q -O- https://api.bintray.com/orgs/gopasspw/keys/gpg/public.key | sudo apt-key add -

    ## Lynis
    echo -e "$VE Agregando clave para $RO Lynis$CL"
    sudo wget -O - https://packages.cisofy.com/keys/cisofy-software-public.key | sudo apt-key add -

    ## Spotify
    echo -e "$VE Agregando clave para $RO Spotify$CL"
    sudo apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-keys 4773BD5E130D1D45

    ## Steam
    echo -e "$VE Agregando clave para $RO Steam$CL"
    sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys F24AEA9FB05498B7

    ## QOwnNotes
    echo -e "$VE Agregando clave para $RO QOwnNotes$CL"
    wget http://download.opensuse.org/repositories/home:/pbek:/QOwnNotes/Debian_10/Release.key -O - | sudo apt-key add -

    ## Any Desk
    echo -e "$VE Agregando clave para $RO Any Desk$CL"
    wget -qO - https://keys.anydesk.com/repos/DEB-GPG-KEY | sudo apt-key add -

    ## GO CD (Desarrollo continuo)
    echo -e "$VE Agregando clave para $RO GO CD$CL"
    curl https://download.gocd.org/GOCD-GPG-KEY.asc | sudo apt-key add -

    ## Jenkins
    echo -e "$VE Agregando clave para $RO Jenkins$CL"
    wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -

    ## MongoDB
    echo -e "$VE Agregando clave para $RO MongoDB$CL"
    wget -qO - https://www.mongodb.org/static/pgp/server-4.4.asc | sudo apt-key add -

    ## Beekeeper Studio (Gestionar Bases de Datos)
    echo -e "$VE Agregando clave para $RO Beekeeper Studio$CL"
    wget --quiet -O - https://bintray.com/user/downloadSubjectPublicKey?username=bintray | sudo apt-key add -

    ## Sury (Paquetes PHP)
    echo -e "$VE Agregando llave para$RO PHP$VE de sury,org$CL"
    sudo wget -O '/etc/apt/trusted.gpg.d/php.gpg' 'https://packages.sury.org/php/apt.gpg'
    sudo chmod 744 '/etc/apt/trusted.gpg.d/php.gpg'
}

##
## Agrega los repositorios desde su directorio "comunes"
##
comunes_sources_repositorios() {
    echo -e "$VE Añadido$RO sources.list$VE y$RO sources.list.d/$VE Agregados$CL"

    if [[ ! -d '/etc/apt/sources.list.d' ]]; then
        sudo mkdir -p '/etc/apt/sources.list.d'
    fi

    sudo cp $WORKSCRIPT/Repositorios/debian/comunes/sources.list.d/* /etc/apt/sources.list.d/
}

##
## Instala repositorios que son descargados mediante un script oficial
##
comunes_download_repositorios() {
    echo -e "$VE Descargando repositorios desde scripts oficiales$CL"
    ## NodeJS Oficial
    echo -e "$VE Agregando repositorio$RO NodeJS$AM Repositorio Oficial$CL"
    curl -sL https://deb.nodesource.com/setup_current.x | sudo -E bash -

    ## Riot
    echo -e "$VE Agregando Repositorio para$RO Riot (Matrix)$CL"
    sudo sh -c "echo '##deb https://riot.im/packages/debian/ artful main' > /etc/apt/sources.list.d/matrix-riot-im.list"

    ## Atom
    echo -e "$VE Agregando Repositorio para$RO Editor Atom$CL"
    sudo sh -c 'echo "deb [arch=amd64] https://packagecloud.io/AtomEditor/atom/any/ any main" > /etc/apt/sources.list.d/atom.list'

    ## Sury (Paquetes PHP)
    #echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/php.list
    echo "deb https://packages.sury.org/php/ buster main" | sudo tee /etc/apt/sources.list.d/php.list

}

##
## Añade todos los repositorios y llaves
##
comunes_agregar_repositorios() {
    echo -e "$VE Instalando repositorios$RO Comunes$CL"
    comunes_sources_repositorios
    comunes_download_repositorios
    echo -e "$VE Actualizando antes de obtener las llaves, es normal que se muestren errores$AM (Serán solucionados en el próximo paso)$CL"
    actualizarRepositorios
    comunes_agregar_llaves
    echo -e "$VE Actualizando listas de repositorios definitiva, comprueba que no hay$RO errores$CL"
    actualizarRepositorios
}
