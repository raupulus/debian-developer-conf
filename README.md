# Script para Preparar Entorno de Programación en Debian
Script para preparar entorno de programación, aplicaciones y repositorios en Debian.
Basado en el script original de @ricpelo en https://github.com/ricpelo/conf

Con la colaboración de un testeo constante por parte de @mavalro

Todas las configuraciones y elecciones se han establecido a mi gusto, puedes personalizar cualquier parte que decidas para este script.

## Estado
Se han depurado la mayoría de los errores graves, todos los detectados hasta el momento están resueltos.

Si encuentras algún fallo o detectas que algo podría funcionar mejora añade un **Issue** al que estaré encantado de atender y valorar, también puedes colaborar con los PR que creas oportuno siempre que vaya en la línea del script y no sea necesario darle la vuelta a todo el proyecto.

Comenzado a usar sin problemas aparentes. Debido a la edad temprana y poca depuracion recomiendo su uso con prudencia.

Se ha testeado mayormente en entornos virtuales y limpios sin poco uso el sistema por lo que no se garantiza que en un sistema con tiempo de uso y modificaciones pueda alterar el funcionamiento normal

En los equipos de uso diario ya los ejecuto sin problemas hasta la fecha para incorporar mejoras desde la rama principal MASTER

## Advertencias
Puede dar problemas si no usas **repositorios oficiales** o usas repositorios mezclados con los oficiales.

Este script está automatizado y puede cambiar configuración

Se ha testeado todo lo posible en entornos virtuales y en el mio personal de forma real.

Para evitar que sea interactivo y estar constantemente preguntando se establece "-y" como parámetro por defecto en **apt** lo cual puede instalar software en forma de dependencia y/o romper en casos muy extremos el sistema, aunque repito que con repositorios oficiales no debe ocurrir nada extraño y si es así puedes reportarlo para su corrección.

En **ningún caso** me hago responsable de pérdidas de datos con el uso de esta herramienta ya que se ha diseñado en función a mis necesidades y la comparto para que puedas aprovechar parte o por completo la misma (Respetando la licencia GPLv3 que le he asignado).

## Objetivos
Crear un entorno de trabajo personalizado para desarrollar aplicaciones web según las preferencias del autor.

Aún estando personalizado se ha procurado dejar de forma modular para poder hacer retoques sin demasiadas complicaciones.

Estos son los principales objetivos

- Configurar terminales, bash y zsh
- Instalar tipografías
- Instalar editores Brackets, Atom, ninja IDE y Vim con sus personalizaciones
- Configurar sistema y variables globales
- Ampliar repositorios desde fuentes estables y fiables
- Instalar configuraciones y personalizaciones para el sistema y programas en el HOME
- Instalar atajos y personalizaciones para trabajar con git, GitHub y GitLab
- Instalar servidores Apache2, PostgreSQL, MariaDB
- Instalar lenguajes de programación, dependencias y librerías para → php, python, nodejs, ruby, bash, zsh
- Instalar Navegadores WEB para desarrolladores como Firefox Developer y Firefox Nightly
- Instalar herramientas para ayudar a debug en lenguajes web

En resumen dejar con un solo script todo el entorno adaptado a mis necesidades

## Distribución compatible
Está destinado única y exclusivamente para **Debian 9** (estable) y se irá actualizando con esta rama estable

En otras ramas y distribuciones puede romper el sistema, para portarlo no hay demasiadas complicaciones y se deberá renombrar la instalación/nombre de paquetes si procede y establecer repositorios de acorde a la distribución. El resto de los pasos deberían ser idénticos.

## Modularidad
Se ha intentado hacer modular de forma que apenas sea necesario tocar los scripts para añadir/quitar funciones.

La idea es que el script pregunte ciertas cosas como shell a usar (bash o zsh) pero también podemos añadir fuentes simplemente copiándolas al directorio "fonts" o instalar aplicaciones simplemente añadiéndolas a la lista de aplicaciones para instalar "Software.lst"

En las próximas versiones se plantea una Refactorización que permita manejar el script de forma aún más sencilla y además permita utilizar listas.lst donde el usuario introducirá un valor por línea para su configuración personalizada.

## Ejecutar script
Es importante realizar todos los pasos desde bash. Si usas **zsh** cambia a **bash** antes de ejecutarlo:
```bash
bash
```

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
  ./main.sh
```

## Personalización estética
Se han incorporados cambios en la personalización:
- Fondo de pantalla
- Grub
- GDM
- Iconos crystalblue

Además también se añadieron iconos "paper", temas "flatpat" y la instalación de cursores "crystal"

Todo esto se instalará de forma opcional eligiendo dicha opción en el menú. Por ahora se instalan pero se han de activar manualmente.

## Servidores
Se incorporan en la parte servidores instalación para apache2, php, postregsq, mariadb

### Apache 2
Se crean 3 servidores virtuales:

- Por defecto escuchando todo, con ruta /var/www/html
- Público como publico.local, con ruta /var/www/html/Publico
- Privado como privado.local, con ruta /var/www/html/Privado y contraseña creada/generada en /var/www/.htpasswd

Todos por el puerto estándar, 80

### PHP
En este script para seguir rigurosamente la filosofía **Debian** apostando por la seguridad que nos acostumbra y sobre todo la estabilidad la cual es bastante conocida, optamos a seguir siempre con la versión más alta de sus repositorios estables y oficiales libres.

Se instalan los siguientes paquetes básicos desde repositorios:
- php
- php-cli
- libapache2-mod-php

Se instalan los siguientes paquetes extras desde repositorios
- php-gd
- php-curl
- php-pgsql
- php-sqlite3
- sqlite
- sqlite3
- php-intl
- php-mbstring
- php-xml
- php-xdebug
- php-json

Se instala Composer y algunos paquetes con este
- composer



Se instalan las siguientes herramientas de fuentes externas:
- psysh → Un intérprete interactivo para aprender o hacer debug, incluyendo su documentación accesible una vez dentro del mismo intérprete usando la palabra reservada **doc** seguido de la función que solicitamos ayuda/información.

### PostgreSQL

### MariaDB

### Python
Contempla la instalación de Python2 y Python3 con sus gestores de paquetes **pip** para cada uno de ellos.

### NodeJS
Instala NodeJS (tienen que estar los repositorios agregados) y además contempla la instalación de algunos paquetes como ámbito global para poder corregir sintaxis javascript en algunos IDE's y/o desde terminal.

También instala desde **npm** bower y los siguientes paquetes globales:
- eslint
- jscs
- compass
- stylelint
- bundled

## Directorios
- Accesos_Direcots → Contiene los accesos directos individuales para usuario que van en ~/.local/share/applications
- fonts → Contiene un directorio por cada conjunto de fuentes similares
- gedit → Contiene configuración específica para gedit
- home → Contiene archivos de configuración o plantillas para generarlos
- LIB → Archivos de librerías del sistema contando desde la raíz
- TMP → Directorio donde se descargan los archivos temporales
- usr → Contiene archivos compartidos de usuarios
- Apps → Contiene scripts y configuraciones especiales para ciertas aplicaciones

# Scripts
- Agregar_Repositorios.sh → Añade algunos repositorios útiles y sus llaves para seguridad
- Configurar_GIT.sh → Scripts para configurar la integración de GIT, GitHub y GitLab
- Instalar_Configuraciones → Genera todas las configuraciones de programas como Vim, Bashit, ohmyzsh y además añade configuraciones al sistema y el directorio home
- Instalar_Software → Instala los programas indicados en la lista "Software.lst" y algunos extras
- Limpiador.sh → Este script limpia los directorios y archivos que pueden causar más problemas en algún momento, esto existe para depurar principalmente y su uso se desaconseja por ser áltamente arriesgado a perder datos.
- main.sh → Programa principal con menú para elegir paso a realizar
- Personalización_GTK.sh → Genera fondos para grub, escritorio, gdm... y además iconos, temas y cursores
- Servidores.sh → Instala servidores como apache2 php postregsql mariadb y los configura
- Tipografías.sh → Instala fuentes tipográficas
- Variables_Entorno.sh → Genera variables de entorno que seran globales en el sistema

Dentro de Apps/
- Atom_IDE.sh → Instala el editor ATOM con su configuración y complementos
- Firefox.sh → Instala la versión para desarrolladores **Quantum** y la versión en desarrollo principal **Nightly**
