# Script para Preparar Entorno de Programación en Debian
Script para preparar entorno de programación, aplicaciones y repositorios en Debian.
Basado en el script original de @ricpelo en https://github.com/ricpelo/conf

Todas las configuraciones y elecciones se han establecido a mi gusto, puedes personalizar cualquier parte que decidas para este script.

## Estado
Comenzado a usar sin problemas aparentes. Debido a la edad temprana y poca depuracion aun no recomiendo su uso

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

## Personalización estética
Se han incorporados cambios en la personalización:
- Fondo de pantalla
- Grub
- GDM

Además también se añadieron iconos "paper", temas "flatpat" y la instalación de cursores "crystal"

Todo esto se instalará de forma opcional eligiendo dicha opción en el menú

## Servidores
Se incorporan en la parte servidores instalación para apache2, php, postregsq, mariadb


## Directorios
- fonts → Contiene un directorio por cada conjunto de fuentes similares
- gedit → Contiene configuración específica para gedit
- home → Contiene archivos de configuración o plantillas para generarlos
- LIB → Archivos de librerías del sistema contando desde la raíz
- TMP → Directorio donde se descargan los archivos temporales
- usr → Contiene archivos compartidos de usuarios
