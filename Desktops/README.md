# Descripción de los Escritorios y WM

## Paquetes comunes a todos los Window Manager

- acpi → Muestra información de dispositivos ACPI
- suckless-tools → Menú alternativo
- gawk → Lenguaje de Escaneado y procesado de patrones
- xfe → Explorador de archivos minimalista y usable solo con atajos de teclado
- dunst → Notificaciones del escritorio
- nomacs → Visor de imágenes
- rxvt-unicode → Emulador con codificación Unicode
- compton → Compositor de ventanas para X11
- nitrogen → Seleccionar fondo de pantalla
- ranger → Explorador de archivos para terminal con ncurses y python
- w3m → Navegador web con excelente soporte de tablas/marcos
- tint2 → Barra de iconos personalizable y de poco consumo
- arandr → Interfaz de xrandr para organizar pantallas/monitores
- x11-xserver-utils → Utilidades para el servidor X11
- xbacklight → Utilidad para cambiar la retroiluminación de la pantalla
- xfce4-screenshooter → Captura Imágenes
- gpicview → visor de imágenes
- gvfs → Automontaje de dispositivos y papelera
- zathura → Lector pdf que permite usar las teclas de vim
- cmus → Reproductor C con curses.
- mplayer → Reproductor
- xautolock → Lanzador de programas en sesiones de X inactivas
- xbindkeys → Permite asignar combinaciones de teclas a acciones
- unclutter → Oculta el ratón mientras no se utiliza
- parcellite → Portapapeles
- zenity → Calendario
- pipewire → Servidor de sonido
- firewalld → Cortafuegos con interfaz gráfica y applet
- xfce4-settings → Configuración de XFCE4 (para gtk2)
- lxappearance → Configuración de gtk por lxde
- gtk-chtheme → Configura tema gtk2
- qt4-qtconfig → Configura tema qt
- pm-utils → Herramientas y scripts para la gestión de energía
- zenity → Muestra cajas de diálogos desde ShellScript
- scrot → Captura la pantalla desde línea de comandos
- lxpolkit → Agente de autenticación
- ssh-askpass → Autenticación para ssh
- wireless-tools → Herramientas para manipular extensiones de redes inalámbricas
- fonts-powerline → Fuentes parcheadas con símbolos
- xfce4-clipman → Portapapeles con soporte para imágenes de XFCE4
- redshift → Cambia el tono de la pantalla según la hora del día
- lm-sensors → Sensores de temperatura para el hardware
- network-manager → Configuración de red
- lxrandr → Gestor de pantalla, muy útil cuando deseas proyectar mediante HDMI
- volti → administra el volumen

## i3wm

Instalo y configuro i3 con diversos componentes para construir un entorno
agradable, liviano y despejado pero a la vez suficientemente potente para
trabajar con las herramientas necesarias.

![Previsualización i3](docs/i3.png)

![Previsualización i3 con dos monitores](docs/i3-Dual_Monitor.png)

### Paquetes instalados por este escritorio

-   i3-lock
-   i3status
-   perl-json-xs
-   perl-anyevent-i3
-   i3-save-tree

### Organización de los escritorios

- 1 → Terminal
- 2 → IDE/Editor
- 3 → Web
- 4 → Networking
- 5 → Graphic Design
- 6 → Multimedia
- 7 → Virtual Machine
- 8 → Games


## Gnome Keyring (guardar sesión de apps mediante libsecret)

Tanto `i3.sh` como `sway.sh` instalan `gnome-keyring`, `libsecret-1-0` y
`libpam-gnome-keyring`, y arrancan el daemon con
`exec gnome-keyring-daemon --start --components=pkcs11,secrets,ssh` desde
la configuración de la WM. Esto es necesario para que aplicaciones que
guardan credenciales vía D-Bus (`org.freedesktop.secrets`), como por
ejemplo **Claude Code Desktop** para persistir la sesión, encuentren un
keyring desbloqueado.

Con **GDM3** como gestor de login (caso por defecto en este repo) no hace
falta nada más: el paquete `libpam-gnome-keyring` ya deja configurado
`/etc/pam.d/gdm-password` con:

```
auth    optional    pam_gnome_keyring.so
...
session optional    pam_gnome_keyring.so auto_start
```

y el keyring queda desbloqueado automáticamente al iniciar sesión con tu
contraseña de usuario.

### Paso manual (solo si usas otro gestor de login, ej. lightdm, o `startx` sin gestor gráfico)

Si el keyring pide contraseña aparte de la de login, o `busctl --user list`
no muestra `org.freedesktop.secrets`, añade estas dos líneas al archivo PAM
de tu gestor de login (`/etc/pam.d/lightdm`, `/etc/pam.d/login`, etc.):

```
auth    optional    pam_gnome_keyring.so
session optional    pam_gnome_keyring.so auto_start
```

- La línea `auth` debe ir justo después de `@include common-auth`.
- La línea `session` debe ir justo después de `@include common-session`.

Verificar que quedó activo tras reiniciar sesión:

```bash
ps aux | grep gnome-keyring-daemon
busctl --user list | grep secret   # debe listar org.freedesktop.secrets
```

## Openbox

### Paquetes instalados por este escritorio
- idesk → Maneja fondo de escritorio y los iconos
- obconf → Gestor de configuraciones para openbox
- obmenu → Editor de menú gráfico
- menu → Genera menús de programas para todas las aplicaciones que sean de menú
- openbox-gnome-session → Integración con gnome
- openbox-menu → Menú que muestra las entradas de archivos *.desktop
