#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2019 Raúl Caro Pastorino
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
## Agrega, configura y habilita el sitio por defecto con ssl.

############################
##        FUNCTIONS       ##
############################
apachePrivateSiteCreate() {
    local nombreSitio='private'
    local existe=$(apache2ExisteSitioVirtual "${nombreSitio}.conf" "$nombreSitio")

    if [[ $existe != 'true' ]]; then
        ## Deshabilita Sitios Virtuales (VirtualHost).
        if [[ -f "${APACHESITES}/${nombreSitio}.conf" ]]; then
            apache2DeshabilitarSitio "${nombreSitio}.conf"
            sudo rm "${APACHESITES}/${nombreSitio}.conf"
        fi
        if [[ -f "${APACHESITES}/${nombreSitio}.conf" ]]; then
            apache2DeshabilitarSitio "${nombreSitio}-ssl.conf"
            sudo rm "${APACHESITES}/${nombreSitio}-ssl.conf"
        fi

        ## Copia el esqueleto a /var/www
        apache2AgregarDirectorio "$nombreSitio"

        ## Copia los archivos de configuración.
        apache2GenerarConfiguracion "${nombreSitio}.conf" "$nombreSitio"
        apache2GenerarConfiguracion "${nombreSitio}-ssl.conf" "$nombreSitio"

        # Habilita Sitios Virtuales (VirtualHost) para desarrollo
        if [[ "$ENV" = 'dev' ]]; then
            apache2HabilitarSitio "${nombreSitio}.conf"
            apache2HabilitarSitio "${nombreSitio}-ssl.conf"
        fi
    fi

    apache2ActivarHost "$nombreSitio"
    apache2AsignarPropietario "$nombreSitio"
    apache2AsignarPermisos "$nombreSitio"
}
