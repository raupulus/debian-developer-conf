#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-

mainZone() {
    sudo dpkg-reconfigure locales
    sudo dpkg-reconfigure tzdata
}
