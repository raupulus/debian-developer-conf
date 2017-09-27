# Script para Preparar Entorno de Programación en Debian
Script para preparar entorno de programación, aplicaciones y repositorios en Debian

## Estado
Aún es inestable y no se recomienda su uso

## Objetivos
Crear un entorno de trabajo personalizado para desarrollar aplicaciones web según las preferencias del autor.

Aún estando personalizado se ha procurado dejar de forma modular para poder hacer retoques sin demasiadas complicaciones.

## Distribución compatible
Está destinado única y exclusivamente para Debian 9 (estable) y se irá actualizando con esta rama

En otras ramas y distribuciones puede romper el sistema, para portarlo no hay demasiadas complicaciones y se deberá renombrar la instalación/nombre de paquetes si procede y establecer repositorios de acorde a la distribución. El resto de los pasos deberían ser idénticos.

## Modularidad
Se ha intentado hacer modular de forma que apenas sea necesario tocar los scripts para añadir/quitar funciones.

La idea es que el script pregunte ciertas cosas como shell a usar (bash o zsh) pero también podemos añadir fuentes simplemente copiándolas al directorio "fonts" o instalar aplicaciones simplemente añadiéndolas a la lista de aplicaciones para instalar "Software.lst"

## Ejecutar script
Primero instalamos GIT
```debian
  sudo apt install git
```

Clonamos el repositorio actual en nuestro equipo
```GIT
  git clone https://github.com/fryntiz/preparar_entorno
```

Entramos y ejecutamos el script principal
```bash
  cd preparar_entorno
  bash main.sh
```
