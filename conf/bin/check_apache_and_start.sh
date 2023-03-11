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
##

###########################
##       FUNCTIONS       ##
###########################

## Este script comprueba si apache se ha caído para levantarlo de nuevo.

# Añadir cada 5 minutos al cron:
# chmod +x script.sh
# */5 * * * * /root/script.sh

#PATH=/usr/sbin:/usr/bin:/sbin:/bin

if [[ ! "$(/usr/sbin/service apache2 status)" =~ "active (running)" ]]
then
    #echo "Apache restarted" | mail -s "yourwebsite server Apache restarted" public@raupulus.dev
    echo "Apache restarted"
    echo "Apache restarted" > /tmp/restarts.log
    /usr/sbin/service apache2 start
fi
