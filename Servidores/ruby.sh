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

ruby_descargar() {
    echo -e "$VE Descargando$RO Ruby$CL"
}

ruby_preconfiguracion() {
    echo -e "$VE Generando Pre-Configuraciones de$RO Ruby"
}

ruby_instalar() {
    echo -e "$VE Instalando$RO Ruby$CL"
    instalarSoftware 'ruby' 'ruby-full'

    echo -e "$VE Instalando gestor de paquetes$RO Rbenv$CL"
    instalarSoftware 'rbenv'

    echo -e "$VE Instalando paquetes complementarios de$RO Ruby$CL"
    local complementarios='rubygems-integration ruby-base64 ruby-bcrypt ruby-cairo ruby-clutter ruby-color ruby-crack ruby-curses ruby-debian ruby-dbus ruby-http ruby-i18n ruby-inline ruby-indentation ruby-json ruby-mime ruby-mongo ruby-ncurses ruby-nenv ruby-neovim ruby-net-ssh ruby-password ruby-pg ruby-pkg-config ruby-rbpdf ruby-rbpdf-font ruby-sqlite3 ruby-twitter ruby-zip'
    instalarSoftware "$complementarios"
}

ruby_postconfiguracion() {
    echo -e "$VE Generando Post-Configuraciones de Ruby$CL"
}

ruby_instalador() {
    ruby_descargar
    ruby_preconfiguracion
    ruby_instalar
    ruby_postconfiguracion
}
