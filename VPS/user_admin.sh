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
## This script create and prepare a user admin (not root).

############################
##        FUNCTIONS       ##
############################

user_admin_create_user() {
    echo -e "$VE Create$AM new$RO User$CL"
    #TODO → New user interactive name and password, this is a first option in script
}

user_admin_installer() {
    user_admin_create_user
}
