# Entornos de Escritorio (Desktops)

**Resumen**: Este módulo ofrece instalaciones y pre-configuraciones avanzadas de varios entornos de escritorio (Desktop Environments) y gestores de ventanas (Window Managers). Permite a los usuarios elegir entre paradigmas tradicionales o basados en "Tiling".

---

## Descripción Técnica y Objetivo

El directorio `Desktops/` abarca scripts enfocados en alterar o establecer la interfaz gráfica base del equipo. Al ser Linux altamente personalizable, este módulo se asegura de instalar los metapquetes correctos para el entorno elegido y además volcar archivos de configuración (dotfiles) optimizados para flujos de desarrollo.

### Componentes Clave

1. **Gestores de Ventanas Tiling (i3wm, Sway, Xmonad)**:
   - `i3.sh`: Instala `i3` (y utilidades como `i3blocks`, `rofi`, `feh` para fondos). Acto seguido invoca `enlazarHome` para colocar la configuración de i3 en `~/.config/i3/config`, habilitando atajos de teclado personalizados, scripts de estado en la barra y configuración de múltiples monitores.
   - `sway.sh`: Ofrece la configuración equivalente para el entorno moderno bajo Wayland, desplegando los paquetes específicos (como `waybar`).
   - `xmonad.sh`: Proporciona las dependencias Haskell y la configuración precompilada o los binarios base para usar este window manager dinámico.

2. **Gestores Flotantes y Ligeros (Openbox)**:
   - `openbox.sh`: Instala un gestor tradicional muy ligero, inyectando un `rc.xml` y programas de soporte (como `tint2` para paneles y `nitrogen` para fondos) creando un escritorio minimalista pero completamente funcional para hardware limitado.

3. **Entornos Completos (GNOME Shell)**:
   - `gnome-shell.sh`: Configura profundamente el entorno GNOME. Emplea fuertemente la herramienta de línea de comandos `gsettings` para definir la barra lateral, comportamiento de las áreas de trabajo, atajos de teclado del sistema (minimizar, anclar ventanas), y activar o desactivar extensiones.

### Mecanismo de Ejecución

El usuario selecciona su escritorio preferido a través del menú de `0_Main.sh`. Los scripts llaman a `instalarSoftware` para resolver todas las dependencias gráficas, y proceden a situar la configuración en los directorios `~/.config/` respectivos. Algunos comandos (como `gsettings` en GNOME) son dependientes del sistema de visualización (X11/Wayland), por lo que ciertas configuraciones pueden requerir ser ejecutadas tras reiniciar la sesión para que tomen efecto absoluto en dconf.
