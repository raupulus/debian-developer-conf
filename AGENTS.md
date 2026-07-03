# Reglas y Directrices para Agentes de IA

Este archivo (`AGENTS.md`) documenta el propósito, la estructura, el flujo de arranque y las directrices de estilo y desarrollo para este proyecto. Como agente de IA, debes leer y acatar estas reglas antes de realizar cualquier modificación en el código. Es la fuente de verdad más reciente: el `README.md` contiene datos desactualizados (ver sección 6).

## 1. Propósito del Proyecto

El objetivo de `debian-developer-conf` es configurar entornos de trabajo automatizados para desarrollo, principalmente en **Debian stable** y **Debian testing**, así como en **Raspberry OS** (Raspbian). El soporte para **Fedora**, **Gentoo** y **macOS** es parcial y de carácter experimental; no se garantiza un funcionamiento seguro en ellos.

El script principal automatiza la instalación de aplicaciones, lenguajes de programación, configuraciones de servidor, personalizaciones de interfaz y ajustes a nivel de usuario y root. **Es deliberadamente no interactivo y destructivo con la configuración existente** (fuerza `-y` en apt, sobrescribe dotfiles); solo debe ejecutarse tras un backup o en una VM/equipo dedicado a ello.

## 2. Flujo de arranque

Hay dos puntos de entrada:

- **`main.sh`**: uso normal como usuario con `sudo`, clonando el repo primero.
- **`main-vps.sh`**: pensado para ejecutarse **como root** en un VPS recién creado, antes de clonar nada (se descarga suelto vía `wget`). Crea el usuario del sistema (`adduser`, grupos `sudo crontab go www-data`), clona el repo (nota: usa la URL de **GitLab**, mientras que el README usa **GitHub** — ambos orígenes son válidos, mantenlos en mente si tocas URLs), **deshabilita IPv6 de forma permanente** vía `sysctl`, y finalmente hace `su $username ./main.sh` para continuar. Tiene un bug conocido sin arreglar: la comprobación de usuario vacío usa `&&` en vez de `||` y nunca se cumple.

Orden de carga dentro de `main.sh`:

1. `source /etc/environment` (si existe) y luego `source $WORKSCRIPT/.env` (si existe) — el `.env` local pisa lo global. `WORKSCRIPT=$PWD`, así que **hay que ejecutar el script desde la raíz del repo**.
2. `source routes.sh`, `functions.sh`, `preferences.sh`, `limpiador.sh`.
3. `configurePreferences` (de `preferences.sh`): si es la primera ejecución, pregunta interactivamente distro/rama/entorno/hostname/idioma/monitores y persiste las respuestas en `/etc/environment` vía `setVariableGlobal` (de `functions.sh`), para que ejecuciones futuras no vuelvan a preguntar.
4. `setAllRoutes` (de `routes.sh`): fija rutas de Apache (`APACHECONF`, `DIRWEB`, `APACHESITES`, etc.) según `$DISTRO` (debian/raspbian, fedora, gentoo, macos vía Homebrew); si la distro no coincide con ninguna rama, el script aborta con `exit 1`.
5. Se define `SOFTLIST="${WORKSCRIPT}/Software-Lists/${MY_DISTRO}"` — variable clave que usan todos los módulos para localizar las listas `.lst` de paquetes de la distro activa.
6. Se cargan los `0_Main.sh` de cada módulo (ver sección 3) y se muestra `menuPrincipal()`.

Configuración de entorno (`env.example` → copiar a `.env`, sin punto en el nombre origen): `DISTRO`, `BRANCH` (stable/testing/unstable), `ENV` (dev/prod), `ADMIN_EMAIL`, `DEBUG`, `PATH_LOG`. Nota: el default de `PATH_LOG` en `main.sh` apunta a `errors.log` (inglés) pero el valor real usado en `.env`/`env.example` es `errores.log` (español) — por eso `.gitignore` ignora ambas variantes. No es un bug a "corregir" sin más: cambiarlo rompería configuraciones ya persistidas en `/etc/environment` de otros equipos.

Variables `MY_DISTRO`/`MY_BRANCH`/`MY_ENV` conviven con `$DISTRO`/`$BRANCH`/`$ENV`: unas funciones usan unas, otras las otras. Es una inconsistencia real del código existente, no una convención a seguir en código nuevo — usa `$DISTRO` salvo que el contexto ya use `$MY_DISTRO`.

`main.sh` acepta flags posicionales que saltan el menú (`./main.sh vim`, `./main.sh nano`, `./main.sh terminals`), y una opción de menú "Todos los pasos anteriores a la vez" que encadena Repositorios+Apps+configurations+Personalizar+servers+Lenguajes-Programacion en modo automático.

`limpiador.sh` es un script de limpieza **agresiva y destructiva** (borra dotfiles, directorios de personalización y desinstala paquetes con `rm -Rf`/`apt remove`) sin desinstalador limpio: su función `restaurar_Backups()` es solo un placeholder que no restaura nada pese a existir un TODO pendiente para implementarlo. Trátalo como zona de alto riesgo.

## 3. Arquitectura de Módulos

El proyecto está estructurado modularmente para evitar depender de un único macro-script. La funcionalidad se encuentra dividida en carpetas. Cada carpeta suele contener un archivo `0_Main.sh` que actúa como menú y controlador de ese módulo específico (el patrón se repite recursivamente en al menos un submódulo: `Apps/IDEs/0_Main.sh`).

Los principales módulos (y sus correspondientes directorios) son:
- **Apps/**: Instalación de aplicaciones de todo tipo (IDEs, ofimática, navegación).
- **Repositorios/**: Listas y scripts para añadir repositorios de terceros, separados por distro y rama (`debian/stable`, `debian/testing`, `debian/comunes`, `debian/vps`, etc. — ver `docs/info/repositorios.md`).
- **configurations/**: Ajustes genéricos y variables del sistema (crons, archivos hosts).
- **Personalizar/**: Mejoras visuales (temas GTK/QT, iconos, Grub, fuentes, cursores).
- **servers/**: Software para servidores (Apache, Nginx, MariaDB, Docker, etc.).
- **Lenguajes-Programacion/**: Entornos de programación (PHP, Python, Ruby, Go, etc.).
- **Usuario/**: Configuración específica del entorno del usuario (dotfiles, tmux, vim, shell).
- **Desktops/**: Entornos de escritorio y gestores de ventanas (i3, xmonad, openbox, sway).
- **root/**: Configuración base para el usuario administrador.
- **VPS/**: Configuraciones especializadas en servidores privados virtuales (fail2ban, firewall).
- **raspberry/**: Scripts exclusivos de optimización para Raspberry Pi.

Carpetas auxiliares (no son módulos de instalación, no sigas el patrón `0_Main.sh` en ellas):
- **Accesos_Directos/**: ficheros `.desktop` sueltos que se copian a `~/.local/share/applications`.
- **fonts/**: tipografías organizadas por familia; excluida del análisis de CodeClimate.
- **resources/**: reservada para uso futuro, sin lógica activa actualmente.
- **Backups/** y **tmp/**: directorios de **runtime**, generados por `crearBackup()`/`descargar()` (en `functions.sh`) durante la ejecución del script, no código fuente. Están en `.gitignore`.
- **Software-Lists/**: listas planas `.lst` (un paquete por línea, sin comentarios), una carpeta por distro, consumidas por `instalarSoftwareLista`/`instalarSoftwareFlatPakLista` de `functions.sh`. **No están sincronizadas 1:1 entre distros** — no asumas paridad de ficheros al portar una feature de una distro a otra.

### Gotcha conocido: `servers/` vs `Servidores/`
En `Software-Lists/`, la subcarpeta de listas de servidores se llama `servers/` (debian, raspbian, macos) pero `Servidores/` (fedora, gentoo). Sin embargo, todos los scripts de `servers/*.sh` referencian el path hardcodeado `${SOFTLIST}/servers/...`. Resultado: en Fedora y Gentoo esa ruta no existe y la instalación de listas de servidores falla silenciosamente o no encuentra el fichero. Coherente con el aviso de soporte "experimental" en esas distros — si vas a arreglar Fedora/Gentoo, este es uno de los primeros puntos a tocar.

## 4. Guía de Estilo (Bash Style Guide)

Los scripts deben escribirse en **Bash**, procurando seguir buenas prácticas de programación:
- Reutiliza funciones de `functions.sh` siempre que sea posible.
- Evita configuraciones "hardcodeadas" y variables de entorno fijas para todas las distribuciones si pueden variar; confía en `routes.sh` o condicionales.
- Emplea la terminología de color declarada en `main.sh`:
  - `$RO`: Rojo (peligro, atención, mensajes de borrado/stop).
  - `$VE`: Verde (éxito, procesos instalándose).
  - `$AZ`: Azul (títulos, menú).
  - `$AM`: Amarillo (avisos).
  - `$BL`: Blanco.
  - `$CY`: Cyan.
  - `$GR`: Gris.
  - `$MA`: Magenta.
  - `$CL`: Clean (resetear color al final de cada `echo`).
  - `limpiador.sh` redeclara su propio subconjunto de estas variables (sin `CY/GR/MA`) en vez de heredarlas — si cambias la paleta en `main.sh`, revisa también ese fichero para no divergir.

## 5. Reglas de Comportamiento

1. **No Interactividad**: el script de base debe ser lo menos interactivo posible durante los procesos de instalación para que corra ininterrumpidamente. Esto se logra forzando el flag de la interfaz a `DEBIAN_FRONTEND=noninteractive` e instalando con banderas `-y`.
2. **Backups**: al reescribir configuraciones de usuario que ya existen, se debe crear un respaldo (`crearBackup`).
3. **Distribuciones**: si añades soporte o características, cerciórate con una comprobación (`if [[ "$DISTRO" = 'debian' ]]`) de la distribución antes de aplicar un paquete cuyo nombre puede variar.
4. **Permisos**: ningún script debe contener comandos con `sudo` asumiendo que el usuario es root sin antes validar, o bien invocar `sudo` explícitamente donde corresponda sin romper el flujo de terminal.
5. **Compatibilidad multi-equipo**: este repositorio se sincroniza vía git entre varios equipos del autor. Cualquier arreglo específico de una máquina (drivers, hardware, claves GPG puntuales) debe aplicarse de forma que sea inofensivo o condicional en el resto de equipos — nunca asumir que el hardware/entorno actual es el único caso real.

## 6. Calidad y CI

`.codeclimate.yml` define el análisis estático: `shellcheck` con las reglas **SC2162, SC2086, SC2033, SC1090 deshabilitadas a propósito** (no uses eso como excusa para introducir más deuda a propósito, pero tampoco "arregles" esos warnings masivamente sin que te lo pidan), `markdownlint` (MD002 deshabilitado), detección de duplicación y de `FIXME`/`TODO`. Excluye `conf/`, `Apache2/`, `fonts/`, `usr/` del rating.

El `README.md` de la raíz tiene información **desactualizada** en varios puntos (declara soporte "única y exclusivamente para Debian 9 stable", enlaza a una ruta de `Desktops/` que ya no existe dentro de `Personalizar/`) — no lo tomes como referencia de arquitectura actual, prevalece este `AGENTS.md`. Sí es útil para el detalle de paquetes/versiones instalados por stack (PHP, PostgreSQL, MariaDB, Apache vhosts) que no se repite aquí.

Al interactuar con el código o responder consultas, asume estas guías y refiérete a la documentación en `docs/info/` para información más minuciosa de cada subsistema (`docs/README.md` es solo un placeholder pendiente de desarrollar).
