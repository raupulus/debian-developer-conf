# Personalización (Personalizar)

**Resumen**: Este módulo es el encargado del apartado estético y visual del entorno gráfico. Automatiza la configuración e instalación de fuentes, temas GTK/QT, conjuntos de iconos, cursores y fondos de pantalla, e incluso manipula la apariencia del gestor de arranque (Grub).

---

## Descripción Técnica y Objetivo

El directorio `Personalizar/` transforma un entorno Linux funcional en un ecosistema de desarrollo visualmente agradable y coherente. El proyecto preestablece decisiones estéticas sólidas y personalizadas (diseños planos o "flat", iconos tipo "paper", cursores específicos) que homogeneizan la experiencia de trabajo del programador a lo largo de sus distintas máquinas y distribuciones.

### Componentes Clave

1. **Gestión de Temas (GTK y QT)**:
   - Scripts como `gtk.sh`, `gtk2.sh`, `gtk3.sh`, `gtk4.sh` y `qt.sh` clonan e instalan repositorios con temas específicos (como los temas Flatpat o variaciones modernas de Material Design).
   - Generan y configuran los archivos en `~/.config/gtk-3.0/settings.ini` o equivalentes, manipulando `gsettings` para definir un tema por defecto sin intervención manual del usuario.

2. **Tipografía (`fonts.sh`)**:
   - Descarga fuentes optimizadas para desarrollo desde repositorios centralizados y las copia sistemáticamente a `/usr/share/fonts/` o `~/.local/share/fonts/`. 
   - Automáticamente regenera la caché tipográfica usando `fc-cache -fv` para hacer las fuentes inmediatamente utilizables por terminales e IDEs.

3. **Gestores de Arranque e Iconografía (`grub.sh`, `icons.sh`, `cursors.sh`)**:
   - El entorno incluye iconos uniformes y cursores distintivos ("crystalblue"). Estos scripts extraen los archivos desde el propio repositorio o fuentes de terceros para ubicarlos en `/usr/share/icons/`.
   - Modifica el archivo `/etc/default/grub` e inyecta fondos o resoluciones en el inicio, finalizando con `update-grub` u `update-grub2` según disponga el sistema.

### Mecanismo de Ejecución

El script menú `0_Main.sh` de la sección engloba todas las opciones estéticas y puede ejecutarlas secuencialmente. Como muchas configuraciones de GUI dependen de la sesión del usuario o de comandos que requieren que exista una sesión X/Wayland como `gsettings`, este módulo realiza una mezcla de instalación a nivel root (para copiar un tema global) y ejecución a nivel usuario (para aplicarlo en el Desktop Environment en uso).
