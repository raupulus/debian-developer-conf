# Usuario

**Resumen**: Este módulo administra la personalización específica del entorno del usuario actual (el `$HOME`). Gestiona archivos "dotfiles", personaliza el comportamiento de la terminal, los editores de texto de consola, y crea la estructura de directorios preferida del desarrollador.

---

## Descripción Técnica y Objetivo

El directorio `Usuario/` trabaja en una capa no destructiva para el sistema operativo en general, afectando únicamente al usuario que ejecuta el script. Es donde se inyecta la productividad a través de plugins de bash/zsh, gestores de ventanas de terminal (tmux), y editores hipervitaminados como Vim o SpaceVim.

### Componentes Clave

1. **Gestión de Terminal y Shell (`terminales.sh`, `bashit.sh`, `OhMyZsh.sh`)**:
   - Descarga e instala los frameworks de shell como *Oh My Zsh* y *Bash-it*.
   - A través de la función `enlazarHome`, crea enlaces simbólicos (`symlinks`) desde el directorio `conf/home/` hacia la raíz del usuario (ej. `.bashrc`, `.zshrc`, `.aliases`), proveyendo un control de versiones de la configuración personal.
   - Instala comodines visuales y de estado como *Powerline* para enriquecer la interfaz de línea de comandos.

2. **Editores CLI (`vim.sh`, `nano.sh`, `spacevim.sh`, `gedit.sh`)**:
   - Automatiza la creación de `~/.vimrc`, `~/.nanorc` o el despliegue del framework de SpaceVim.
   - Habilita plugins por defecto, esquemas de color, tabulaciones y comportamientos predeterminados idóneos para la lectura y escritura de código directamente en el servidor o entorno local.

3. **Estructura y Permisos (`directories.sh`, `permisos.sh`, `plantillas.sh`)**:
   - `directories.sh`: Fuerza la creación de carpetas clave de trabajo y organización (por ejemplo `~/www`, `~/scripts`, etc.) usando comprobaciones condicionales `dir_exist_or_create`.
   - `plantillas.sh`: Inyecta archivos esqueleto en la carpeta `~/Plantillas` que facilitan la creación rápida de nuevos scripts o documentos desde los gestores gráficos de archivos.
   - `permisos.sh`: Asegura y repara la pertenencia (`chown`) y los permisos de ejecución de los directorios del usuario si estos hubieran sido accidentalmente corrompidos.

### Mecanismo de Ejecución

Este módulo asume que no todas las acciones requieren `sudo` (de hecho, trata de evitarlo para configuraciones del `$HOME`). Hace amplio uso de la función `enlazarHome`, que primero respalda (backup) cualquier configuración existente en `Backups/` y luego impone los dotfiles maestros del repositorio.
