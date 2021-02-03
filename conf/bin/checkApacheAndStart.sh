#!/usr/bin/env bash

## Este script comprueba si apache se ha caído para levantarlo de nuevo.

# Añadir cada 5 minutos al cron:
# chmod +x script.sh
# */5 * * * * /root/script.sh

#PATH=/usr/sbin:/usr/bin:/sbin:/bin

if [[ ! "$(/usr/sbin/service apache2 status)" =~ "active (running)" ]]
then
    #echo "Apache restarted" | mail -s "yourwebsite server Apache restarted" raul@fryntiz.dev
    echo "Apache restarted"
    echo "Apache restarted" > /tmp/restarts.log
    /usr/sbin/service apache2 start
fi

