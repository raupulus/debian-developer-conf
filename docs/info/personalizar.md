# Personalización (Personalizar)

**Resumen**: Este módulo es el encargado del apartado estético y visual del entorno gráfico. Automatiza la configuración e instalación de fuentes, temas GTK/QT, conjuntos de iconos, cursores y fondos de pantalla, e incluso manipula la apariencia del gestor de arranque (Grub).

---

## Descripción Técnica y Objetivo

El directorio `Personalizar/` transforma un entorno Linux funcional en un ecosistema de desarrollo visualmente agradable y coherente. El proyecto preestablece decisiones estéticas sólidas y personalizadas (diseños planos o "flat", iconos tipo "paper", cursores específicos) que homogeneizan la experiencia de trabajo del programador a lo largo de sus distintas máquinas y distribuciones.

### Componentes Clave

1. **Gestión de Temas (GTK y QT)**:
   - `gtk.sh` es el orquestador: hace `source` de `gtk2.sh`, `gtk3.sh` y `gtk4.sh`, instala el tema Materia/Flat-Plat desde GitHub, aplica fondos y llama a `conf_gtk2`/`conf_gtk3`/`conf_gtk4`.
   - Cada `conf_gtk*` hace `enlazarHome '.config/gtk-N.0'` y después instala la lista `$SOFTLIST/Personalizar/gtkN.lst`.
   - Si existen `/usr/bin/gsettings` y `/usr/bin/gnome-shell`, ejecuta además `preconfiguracion_gnome3` y `conf_gnome3`, un bloque muy extenso de `gsettings` que cubre interfaz, privacidad, salvapantallas, teclado, ratón, Nautilus, energía, gedit y nm-applet.
   - **Defectos verificados**: `configurar_temas()` usa `gconftool-2 –type string –set` con guion largo tipográfico (`–`) en lugar de `--`, así que la orden falla siempre; el tema que fija ahí (`Flat-Plat-compact`) lo pisa después `conf_gnome3` con `Paper`; y la línea de `org.gnome.desktop.input-sources` omite el nombre de la clave. Detalle en [`auditoria-estado.md`](auditoria-estado.md).
   - `gtk_install()` termina con `sudo update-initramfs -u` incondicional, que no existe fuera de Debian.

2. **Tipografía (`fonts.sh`)**:
   - Descarga fuentes optimizadas para desarrollo desde repositorios centralizados y las copia sistemáticamente a `/usr/share/fonts/` o `~/.local/share/fonts/`. 
   - Automáticamente regenera la caché tipográfica usando `fc-cache -fv` para hacer las fuentes inmediatamente utilizables por terminales e IDEs.

3. **Gestores de Arranque e Iconografía (`icons.sh`, `cursors.sh`, `grub.sh`)**:
   - El entorno incluye iconos uniformes y cursores distintivos ("crystalblue"). Estos scripts extraen los archivos desde el propio repositorio o fuentes de terceros para ubicarlos en `/usr/share/icons/`.
   - **El fondo de GRUB no se configura desde `grub.sh`**. Ese fichero existe y define `grub_install()`, pero ningún script le hace `source`: es código inalcanzable. Quien toca GRUB en la práctica es `configurar_fondos()` dentro de `gtk.sh`, vía `update-alternatives` sobre `desktop-grub` con el tema *DebBlood* del repositorio externo `raupulus/Art-for-Debian`.
   - `configurar_grub()` en `gtk.sh` es un stub vacío.

4. **Servicios de arranque (`services.sh`)**:
   - `services_enable_disable()` deshabilita `apt-daily.timer`, `apt-daily-upgrade.timer` y `unattended-upgrades.service`.
   - **Ojo**: se aplica en todos los equipos, no solo en VPS. El efecto es que ninguna máquina recibe actualizaciones de seguridad desatendidas.
   - Sin implementación para macOS (`TODO` reconocido en el propio script).

### Mecanismo de Ejecución

El script menú `0_Main.sh` de la sección engloba todas las opciones estéticas y puede ejecutarlas secuencialmente. Como muchas configuraciones de GUI dependen de la sesión del usuario o de comandos que requieren que exista una sesión X/Wayland como `gsettings`, este módulo realiza una mezcla de instalación a nivel root (para copiar un tema global) y ejecución a nivel usuario (para aplicarlo en el Desktop Environment en uso).
