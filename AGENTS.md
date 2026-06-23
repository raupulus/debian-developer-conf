# Reglas y Directrices para Agentes de IA

Este archivo (`AGENTS.md`) documenta el propósito, la estructura y las directrices principales de estilo y desarrollo para este proyecto. Como agente de IA, debes leer y acatar estas reglas antes de realizar cualquier modificación en el código.

## 1. Propósito del Proyecto

El objetivo de `debian-developer-conf` es configurar entornos de trabajo automatizados para desarrollo, principalmente en **Debian stable** y **Debian testing**, así como en **Raspberry OS** (Raspbian). El soporte para **Fedora** y **Gentoo** es parcial y de carácter experimental; no se garantiza un funcionamiento seguro en ellos.

El script principal automatiza la instalación de aplicaciones, lenguajes de programación, configuraciones de servidor, personalizaciones de interfaz y ajustes a nivel de usuario y root.

## 2. Arquitectura de Módulos

El proyecto está estructurado modularmente para evitar depender de un único macro-script. La funcionalidad se encuentra dividida en carpetas. Cada carpeta suele contener un archivo `0_Main.sh` que actúa como menú y controlador de ese módulo específico.

Los principales módulos (y sus correspondientes directorios) son:
- **Apps/**: Instalación de aplicaciones de todo tipo (IDEs, ofimática, navegación).
- **Repositorios/**: Listas y scripts para añadir repositorios de terceros.
- **configurations/**: Ajustes genéricos y variables del sistema (crons, archivos hosts).
- **Personalizar/**: Mejoras visuales (temas GTK/QT, iconos, Grub, fuentes, cursores).
- **servers/**: Software para servidores (Apache, Nginx, MariaDB, Docker, etc.).
- **Lenguajes-Programacion/**: Entornos de programación (PHP, Python, Ruby, Go, etc.).
- **Usuario/**: Configuración específica del entorno del usuario (dotfiles, tmux, vim, shell).
- **Desktops/**: Entornos de escritorio y gestores de ventanas (i3, xmonad, openbox, sway).
- **root/**: Configuración base para el usuario administrador.
- **VPS/**: Configuraciones especializadas en servidores privados virtuales (fail2ban, firewall).
- **raspberry/**: Scripts exclusivos de optimización para Raspberry Pi.

## 3. Guía de Estilo (Bash Style Guide)

Los scripts deben escribirse en **Bash**, procurando seguir buenas prácticas de programación:
- Reutiliza funciones de `functions.sh` siempre que sea posible.
- Evita configuraciones "hardcodeadas" y variables de entorno fijas para todas las distribuciones si pueden variar; confía en `routes.sh` o condicionales.
- Emplea la terminología de color declarada en el `main.sh`:
  - `$RO`: Rojo (Peligro, atención, mensajes de borrado/stop).
  - `$VE`: Verde (Éxito, procesos instalándose).
  - `$AZ`: Azul (Títulos, menú).
  - `$CL`: Clean (Resetear color al final de cada `echo`).

## 4. Reglas de Comportamiento

1. **No Interactividad**: El script de base debe ser lo menos interactivo posible durante los procesos de instalación para que corra ininterrumpidamente. Esto se logra forzando el flag de la interfaz a `DEBIAN_FRONTEND=noninteractive` e instalando con banderas `-y`.
2. **Backups**: Al reescribir configuraciones de usuario que ya existen, se debe crear un respaldo (`crearBackup`).
3. **Distribuciones**: Si añades soporte o características, debes cerciorarte con una comprobación (`if [[ "$DISTRO" = 'debian' ]]`) de la distribución antes de aplicar un paquete cuyo nombre puede variar.
4. **Permisos**: Ningún script debe contener comandos con `sudo` asumiendo que el usuario es root sin antes validar, o bien invocar `sudo` explícitamente donde corresponda sin romper el flujo de terminal.

Al interactuar con el código o responder consultas, asume estas guías y refiérete a la documentación en `docs/info/` para información más minuciosa de cada subsistema.
