#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2017 Raúl Caro Pastorino
## @license    https://wwww.gnu.org/licenses/gpl.txt
## @email      raul@fryntiz.dev
## @web        https://fryntiz.es
## @gitlab     https://gitlab.com/fryntiz
## @github     https://github.com/fryntiz
## @twitter    https://twitter.com/fryntiz
##
##             Applied Style Guide:
## @style      https://gitlab.com/fryntiz/bash-style-guide

############################
##      INSTRUCTIONS      ##
############################
## Este script tiene como objetivo ofrecer funciones recurrentes de
## forma auxiliar para todos los demás scripts.

############################
##       FUNCIONES        ##
############################
##
## Crea un respaldo del archivo o directorio pasado como parámetro
## @param  $*  Recibe una serie de elementos a los que crearle un backup
##
crearBackup() {
    ## Crear directorio Backups si no existiera
    if [[ ! -d "$WORKSCRIPT/Backups" ]]; then
        mkdir "$WORKSCRIPT/Backups"
    fi

    for salvando in $*; do
        if [[ -f $salvando ]]; then
            echo "Creando Backup del archivo $salvando"
            cp "$salvando" "$WORKSCRIPT/Backups/"
        elif [[ -d $salvando ]]; then
            echo "Creando Backup del directorio $salvando"
            cp -R "$salvando" "$WORKSCRIPT/Backups/"
        else
            echo "No se encuentra $salvando"
        fi
    done
}

##
## Muestra el texto recibido como parámetro formateado por pantalla
## @param  $1  String  Recibe la cadena a pintar
##
opciones() {
    echo -e "$AZ Opciones Disponibles$CL"
    echo -e "$VE $1$CL"
}

##
## Recibe uno o más parámetros con el nombre de los programas a instalar
## @param  $*  String  Nombre de programas a instalar
##
instalarSoftware() {
    if [[ "$MY_DISTRO" = 'debian' ]] || [[ "$MY_DISTRO" = 'raspbian' ]]; then
        for programa in $*; do
            sudo DEBIAN_FRONTEND=noninteractive apt-get install -y "$programa"
        done
    elif [[ "$MY_DISTRO" = 'gentoo' ]]; then
        for programa in $*; do
            sudo emerge "$programa"
        done
    elif [[ "$MY_DISTRO" = 'fedora' ]]; then
        for programa in $*; do
            sudo dnf install -y "$programa"
        done
    fi
}

##
## Recibe uno o más parámetros con el nombre de los programas y los actualiza
## de versión en el caso de que exista una superior en el repositorio
## @param  $*  String  Nombres de programas para ser actualizados
##
actualizarSoftware() {
    if [[ "$MY_DISTRO" = 'debian' ]] || [[ "$MY_DISTRO" = 'raspbian' ]]; then
        for programa in $*; do
            sudo DEBIAN_FRONTEND=noninteractive apt-get upgrade -y "$programa"
        done
    elif [[ "$MY_DISTRO" = 'gentoo' ]]; then
        for programa in $*; do
            sudo emerge -vDuN "$programa"
        done
    elif [[ "$MY_DISTRO" = 'fedora' ]]; then
        for programa in $*; do
            sudo dnf upgrade -y "$programa"
        done
    fi
}

##
## Recibe uno o más parámetros con el nombre de los paquetes a instalar
## @param  $*  String  Nombre de paquetes a instalar
##
instalarSoftwareDPKG() {
    for programa in $*; do
        sudo dpkg -i "$programa"
    done

    ## Intenta reparar el gestor de paquetes tras instalar, por si hubiese
    ## habido errores en el proceso de instalación ya que son paquetes externos.
    sudo DEBIAN_FRONTEND=noninteractive apt-get install -f -y
}

##
## Recibe SOLO 1 nombre del archivo con la lista de paquetes, se recorrerá
## este archivo e instalará todos los paquetes que contenga.
## @param  $1  String  Nombre de la lista que contiene los paquetes
##
instalarSoftwareLista() {
    ## En caso de no recibir parámetros, saldrá
    if [[ $# = 0 ]]; then
        return 1
    fi
    repararGestorPaquetes

    lista_Software=$(cat $1)

    if [[ "$MY_DISTRO" = 'debian' ]] || [[ "$MY_DISTRO" = 'raspbian' ]]; then
        ## Paquetes a instalar
        ## La siguiente variable guarda toda la lista de paquetes desde DPKG
        local lista_todos_paquetes=(${dpkg-query -W -f='${Installed-Size} ${Package}\n' | sort -n | cut -d" " -f2})

        ## Comprueba si el software está instalado y en caso contrario instala

        for s in "${lista_Software[@]}"; do
            for x in "${lista_todos_paquetes[@]}"; do
                if [[ $s = $x ]]; then
                    echo -e "$RO $s$VE ya estaba instalado$CL"
                    break
                else
                    instalarSoftware "$s"
                    break
                fi
            done
        done
    elif [[ "$MY_DISTRO" = 'gentoo' ]]; then
        for x in "${lista_Software[@]}"; do
            instalarSoftware "$x"
        done
    elif [[ "$MY_DISTRO" = 'fedora' ]]; then
        for x in "${lista_Software[@]}"; do
             instalarSoftware "$x"
        done
    fi

    repararGestorPaquetes

    return 0
}

##
## Repara errores de dependencias rotas que pudiesen haber.
##
repararGestorPaquetes() {
    echo -e "$VE Comprobando estado del$RO Gestor de paquetes$VE (Paciencia)$CL"
    if [[ "$MY_DISTRO" = 'debian' ]] || [[ "$MY_DISTRO" = 'raspbian' ]]; then
        sudo DEBIAN_FRONTEND=noninteractive apt-get --fix-broken install -y >> /dev/null 2>> /dev/null
        sudo DEBIAN_FRONTEND=noninteractive apt-get install -f -y >> /dev/null 2>> /dev/null
    fi
}

##
## Actualiza las listas de los repositorios
##
actualizarRepositorios() {
    echo -e "$VE Actualizando listas de$RO Repositorios$VE (Paciencia)$CL"
    if [[ "$MY_DISTRO" = 'debian' ]] || [[ "$MY_DISTRO" = 'raspbian' ]]; then
        sudo DEBIAN_FRONTEND=noninteractive apt-get update
    elif [[ "$MY_DISTRO" = 'gentoo' ]]; then
        sudo emerge --sync
    elif [[ "$MY_DISTRO" = 'fedora' ]]; then
        sudo dnf update
    fi
}

##
## Recibe uno o más parámetros con el nombre de los programas para instalar
## desde FlatPak en el sistema.
## @param  $*  String  Nombres de programas para ser instalados
##
instalarSoftwareFlatPak() {
    if [[ ! -x '/usr/bin/flatpak' ]]; then
        instalarSoftware 'flatpak'
    fi

    if [[ $# = 0 ]]; then
        echo -e "$VE No hay paquetes$RO FlatPak$VE para instalar$CL"
    fi

    if [[ -x '/usr/bin/flatpak' ]]; then
        echo -e "$VE Instalando desde$RO FlatPak$CL"

        for programa in $*; do
            echo -e "$VE Instalando $RO $programa$VE desde$RO FlatPak$CL"
            if [[ $programa != '' ]]; then
                flatpak install "$programa" --user
            fi
        done

        return 0
    else
        echo -e "$VE No se encuentra$RO FlatPak$VE instalado en el equipo$CL"
        return 1
    fi
}

##
## Instala todos los programas FlatPak del archivo de lista recibido.
## @param  $1  String  Ruta del archivo lista con los paquetes
instalarSoftwareFlatPakLista() {
    ## Paquetes a instalar
    if [[ $1 = '' ]]; then
        echo -e "$VE No hay paquete a instalar$CL"
        return 1
    fi

    local lista_Software=(`cat $1`)

    for x in "${lista_Software[@]}"; do
        if [[ $x != '' ]]; then
            echo -e "$VE Instalando$RO $x$VE desde$RO FlatPak$CL"
            instalarSoftwareFlatPak "$x" --user
        fi
    done

    return 0
}
##
## Descarga desde el lugar pasado como segundo parámetro y lo guarda con el
## nombre del primer parámetro dentro del directorio temporal "tmp" de este
## repositorio, quedando excluido del mismo control de versiones.
## @param  $1  String  Nombre del recurso a descargar (Añadir extensión)
## @param  $2  String  Origen de la descarga (Desde donde descargar)
##
descargar() {
    ## Crear directorio Temporal si no existiera
    if [[ ! -d "$WORKSCRIPT/tmp" ]]; then
        mkdir "$WORKSCRIPT/tmp"
    fi

    echo -e "$VE Descargando$RO $1 $CL"
    local REINTENTOS=20
    for (( i=1; i<=$REINTENTOS; i++ )); do
        rm -f "$WORKSCRIPT/tmp/$1" 2>> /dev/null
        wget --show-progress "$2" -O "$WORKSCRIPT/tmp/$1" && break
    done
}

##
## Descarga desde la web indicada con el primer parámetro para guardarlo en
## el lugar indicado con el segundo parámetro. Incluye el elemento y su ruta
## @param  $1  String  Origen de la descarga (Desde donde descargar)
## @param  $2  String  Destino donde será guardada la descarga
##
descargarTo() {
    local REINTENTOS=10
    for (( i=1; i<=$REINTENTOS; i++ )); do
        rm -f "$WORKSCRIPT/tmp/$2" 2>> /dev/null
        wget --show-progress "$1" -O "$2" && break
    done
}

##
## Recibe un nombre, el repositorio de origen y el directorio destino para
## descargar el repositorio controlando errores y reintentando cuando falle.
## @param  $1  String  Nombre, es más para informar y registrar log
## @param  $2  String  Repositorio desde donde descargar
## @param  $3  String  Lugar donde guardamos el repositorio
##
descargarGIT() {
    local reintentos=10
    echo -e "$VE Descargando $RO$1$VE desde Repositorio$RO GIT$CL"
    if [[ ! -d "$3" ]]; then
        for (( i=1; i<=$reintentos; i++ )); do
            echo -e "$VE Descargando$RO $1$VE, intento$RO $i$CL"
            if [[ $i -eq $reintentos ]]; then
                rm -Rf "$3" 2>> /dev/null
                break
            fi
            git clone "$2" "$3" && break
            rm -Rf "$3" 2>> /dev/null
        done
    else
        echo -e "$RO$1$VE ya está instalado$CL"
        actualizarGIT "$1" "$3"
    fi
}

##
## Recibe un nombre y el directorio donde se encuentra el repositorio.
## @param  $1  String  Nombre, es más para informar y registrar log.
## @param  $2  String  Ruta hacia la raíz del repositorio en el sistema.
##
actualizarGIT() {
    if [[ -d "$2" ]] && [[ -d "$2/.git" ]]; then
        echo -e "$VE Se actualizará el repositorio existente de$RO $1$CL"
        cd $2 || exit 1
        echo -e "$VE Limpiando posibles cambios en el repositorio$RO $1$CL"
        git checkout -- .
        echo -e "$VE Actualizando repositorio$RO $1$CL"
        git pull
        cd $WORKSCRIPT || return
    fi
}

##
## Crea un enlace por archivo pasado después de realizar una copia de seguridad
## tomando como punto de referencia el propio repositorio, ruta conf/home/
## donde estarán situado todos los archivos para ser actualizados con
## el repositorio.
## @param  $*  String  Nombre del archivo o directorio dentro del home del user
##
enlazarHome() {
    for x in $*; do
        echo -e "$VE Creando enlace de$RO $x$CL"

        if [[ -h "$HOME/$x" ]]; then  ## Si es un enlace
            echo -e "$VE Limpiando enlace anterior para$RO $x$CL"
            rm -f "$HOME/$x"
        elif [[ -f "$HOME/$x" ]] &&   ## Si es un archivo y no tiene backup
             [[ ! -f "$WORKSCRIPT/Backups/$x" ]]; then
            echo -e "$VE Creando enlace para el archivo$RO $HOME$x$CL"
            crearBackup "$HOME/$x" && rm -f "$HOME/$x"
        elif [[ -d "$HOME/$x" ]] &&   ## Si es un directorio y no tiene backup
             [[ ! -d "$WORKSCRIPT/Backups/$x" ]]; then
            echo -e "$VE Creando enlace para el directorio$RO $HOME$x$CL"
            crearBackup "$HOME/$x" && rm -Rf "$HOME/$x"
        else
            echo -e "$VE Eliminando $RO$HOME/$x$VE, ya existe$RO Backup$CL"
            rm -f "$HOME/$x" 2>> /dev/null
        fi

        ln -s "$WORKSCRIPT/conf/home/$x" "$HOME/$x"
    done
}

##
## Recibe uno o más paquetes para eliminarse con dpkg mediante "apt-get purge -y"
## @param $* Recibe los paquetes que necesite y los borra
##
desinstalar_paquetes() {
    for x in $*; do
        echo -e "$RO Borrando x$CL"
        sudo DEBIAN_FRONTEND=noninteractive apt-get purge -y x
    done
}

##
## Recibe uno o más nombres de servicios para reiniciarlos
## @param $* Recibe los servicios que necesite reiniciar
##
reiniciarServicio() {
    for x in $*; do
        echo -e "$RO Reiniciando $x$CL"
        sudo systemctl restart "$x"
    done
}

##
## Recibe uno o más nombres de servicios para detenerlos.
##
pararServicio() {
    for x in $*; do
        echo -e "$RO Deteniendo Servicio: $x$CL"
        sudo systemctl stop "$x"
    done
}

##
## Actualiza la lista de repositorios y repara fallos en el si los hubiese
##
prepararInstalador() {
    echo -e "$VE Se actualizarán las$RO listas de repositorios$CL"
    sudo DEBIAN_FRONTEND=noninteractive apt-get update
    sudo DEBIAN_FRONTEND=noninteractive apt-get install -f -y
}

##
## Instala los paquetes recibidos con "npm" el gestor de paquetes de NodeJS.
## De esta forma serán instalado los paquetes localmente
## @param $* Recibe los paquetes que se van a instalar
##
instalarNpm() {
    for x in $*; do
        echo -e "$RO Instalando $x$CL"
        npm install "$x"
    done
}
##
## Instala los paquetes recibidos con "npm" el gestor de paquetes de NodeJS.
## De esta forma serán instalado los paquetes de forma global, no para un
## proyecto concreto como dependencia.
## @param $* Recibe los paquetes que se van a instalar
##
instalarNpmGlobal() {
    for x in $*; do
        echo -e "$RO Instalando $x$CL"
        npm install -g "$x"
    done
}

##
## Agrega variable de entorno si no tiene valor. Si tiene valor no se hace nada.
## @param $1 Recibe el nombre de la variable
## @param $2 Recibe el valor que se quiere poner en caso de no tener valor
##
setVariableGlobal() {
    if [[ "${!1}" = '' ]]; then
        echo -e "$VE Seteando globalmente: ${1}=${2}$CL"
        echo "${1}=${2}" | sudo tee -a /etc/environment
        export "${1}=${2}"
    fi
}


##
## Recibe una lista de paquetes a instalar como usuario en su home
## @param $* Recibe la lista de paquetes
##
python2Install() {
    echo -e "$VE Instalando paquete Python$CL"
    for x in $*; do
        echo -e "$RO Instalando $x$CL"
        pip2 install --user --upgrade "$x"
    done
}

##
## Recibe una lista de paquetes a instalar como usuario en su home
## @param $* Recibe la lista de paquetes
##
python3Install() {
    echo -e "$VE Instalando paquete Python$CL"
    for x in $*; do
        echo -e "$RO Instalando $x$CL"
        pip3 install --user --upgrade "$x"
    done
}

##
## Recibe una lista de paquetes a instalar de forma global como root
## @param $* Recibe la lista de paquetes
##
python3InstallGlobal() {
    echo -e "$VE Instalando paquete Python de forma global$CL"
    for x in $*; do
        echo -e "$RO Instalando $x$CL"
        sudo pip3 install --upgrade "$x"
    done
}

##
## Comprueba si existe el directorio, en caso contrario lo creará.
## @param $1 Recibe la ruta hacia el directorio que se comprobará/creará.
##
dir_exist_or_create() {
    dir="$1"

    echo -e "$VE Creando directorio$RO $dir$CL"
    if [[ ! -d "$dir" ]]; then
        mkdir -p "$dir"
    fi
}

##
## Registra un mensaje en el archivo de logs.
##
log() {
    msg="$1"
    echo -e "$RO Registrando en log:$AM ${msg}$CL"
    echo "${msg}" >> "${PATH_LOG}"
}

##
## Limpia la pantalla solo cuando estamos en producción pero no cuando
## estamos en desarrollo, en ese caso mostrará por completo lo que sucede.
##
clear_screen() {
    if [[ "${DEBUG}" = 'true' ]]; then
        echo -e "$RO -----Aquí habría un salto de terminal -----$CL"
    else
        clear
    fi
}

##
## Añade dentro de /bin/ los scripts recibidos
## @param  $*  String  Nombres de scripts dentro de conf/bin/ sin la extensión.
##
addScriptToBin() {
    for script in $*; do
        sudo cp "${WORKSCRIPT}/conf/bin/${script}.sh" "/bin/${script}"
        sudo chmod 755 -R "/bin/${script}"
    done
}
