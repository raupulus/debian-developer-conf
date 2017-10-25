# Script para Preparar Entorno de Programación en Debian
Script para preparar entorno de programación, aplicaciones y repositorios en Debian.
Basado en el script original de @ricpelo en https://github.com/ricpelo/conf

Todas las configuraciones y elecciones se han establecido a mi gusto, puedes personalizar cualquier parte que decidas para este script.

## Estado
Se han depurado la mayoría de los errores graves, todos los detectados hasta el momento están resueltos.

Comenzado a usar sin problemas aparentes. Debido a la edad temprana y poca depuracion recomiendo su uso con prudencia.

Se ha testeado mayormente en entornos virtuales y limpios sin poco uso el sistema por lo que no se garantiza que en un sistema con tiempo de uso y modificaciones pueda alterar el funcionamiento normal

En los equipos de uso diario ya los ejecuto sin problemas hasta la fecha para incorporar mejoras desde la rama principal MASTER

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

En resumen dejar con un solo script todo el entorno adaptado a mis necesidades

## Distribución compatible
Está destinado única y exclusivamente para **Debian 9** (estable) y se irá actualizando con esta rama estable

En otras ramas y distribuciones puede romper el sistema, para portarlo no hay demasiadas complicaciones y se deberá renombrar la instalación/nombre de paquetes si procede y establecer repositorios de acorde a la distribución. El resto de los pasos deberían ser idénticos.

## Modularidad
Se ha intentado hacer modular de forma que apenas sea necesario tocar los scripts para añadir/quitar funciones.

La idea es que el script pregunte ciertas cosas como shell a usar (bash o zsh) pero también podemos añadir fuentes simplemente copiándolas al directorio "fonts" o instalar aplicaciones simplemente añadiéndolas a la lista de aplicaciones para instalar "Software.lst"

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
  bash main.sh
```

## Personalización estética
Se han incorporados cambios en la personalización:
- Fondo de pantalla
- Grub
- GDM

Además también se añadieron iconos "paper", temas "flatpat" y la instalación de cursores "crystal"

Todo esto se instalará de forma opcional eligiendo dicha opción en el menú. Por ahora se instalan pero se han de activar manualmente.

## Servidores
Se incorporan en la parte servidores instalación para apache2, php, postregsq, mariadb


## Directorios
- fonts → Contiene un directorio por cada conjunto de fuentes similares
- gedit → Contiene configuración específica para gedit
- home → Contiene archivos de configuración o plantillas para generarlos
- LIB → Archivos de librerías del sistema contando desde la raíz
- TMP → Directorio donde se descargan los archivos temporales
- usr → Contiene archivos compartidos de usuarios

# Scripts
- Agregar_Repositorios.sh → Añade algunos repositorios útiles y sus llaves para seguridad
- Configurar_GIT.sh → Scripts para configurar la integración de GIT, GitHub y GitLab
- Instalar_Configuraciones → Genera todas las configuraciones de programas como Vim, Bashit, ohmyzsh y además añade configuraciones al sistema y el directorio home
- Instalar_Software → Instala los programas indicados en la lista "Software.lst" y algunos extras
- main.sh → Programa principal con menú para elegir paso a realizar
- Personalización_GTK.sh → Genera fondos para grub, escritorio, gdm... y además iconos, temas y cursores
- Servidores.sh → Instala servidores como apache2 php postregsql mariadb y los configura
- Tipografías.sh → Instala fuentes tipográficas
- Variables_Entorno.sh → Genera variables de entorno que seran globales en el sistema
