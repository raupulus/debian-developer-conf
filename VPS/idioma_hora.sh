#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-

mainZone() {
    sudo dpkg-reconfigure locales
    sudo dpkg-reconfigure tzdata

    ## Descomentar en /etc/locale.gen es_ES.UTF-8 UTF-8

    ## meter LC_ALL=es_ES.UTF-8 en /etc/enviroment
}
