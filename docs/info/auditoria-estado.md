# Auditoría de estado — fase 1

Registro de lo revisado: qué está **roto**, qué está **desfasado** y qué
**sirve tal cual**. Sirve de entrada para la refactorización posterior.

Leyenda: 🔴 roto · 🟠 desfasado · 🟡 deuda / incoherencia · 🟢 correcto

## Cobertura de esta revisión

**Leído íntegro**: `main.sh`, `main-vps.sh`, `functions.sh`, `routes.sh`,
`preferences.sh`, `limpiador.sh`, `env.example`, los `0_Main.sh` de los once
módulos, `Repositorios/debian.sh`, `debian/common.sh`, `debian/common_vps.sh`,
todos los `sources.list` y `sources.list.d/*.list`, y `servers/postfix.sh`.

**Revisado por muestreo**: scripts hoja de `Apps/`, `Usuario/`, `Personalizar/`,
`servers/` y `Lenguajes-Programacion/`, y las listas de `Software-Lists/`.

Quedan sin revisar en detalle los ficheros de `conf/`, `fonts/` y
`Accesos_Directos/`. No hay hallazgos pendientes conocidos ahí, pero tampoco
están descartados.

## Núcleo

| # | Fichero | Est. | Detalle |
|---|---|---|---|
| 1 | `functions.sh` | 🔴 | `instalarSoftwareLista`: `${dpkg-query -W ...}` es expansión de parámetro, debería ser `$( ... )`. Además `lista_Software=$(cat $1)` es una cadena y se recorre como array |
| 2 | `functions.sh` | 🔴 | `desinstalar_paquetes`: `apt-get purge -y x` — falta el `$` en la variable |
| 3 | `functions.sh` | 🟡 | `repararGestorPaquetes` usa `$MY_DISTRO`; el resto usa `$DISTRO` |
| 4 | `functions.sh` | 🟠 | `python2Install` con el `pip2` comentado. Python 2 lleva años EOL |
| 5 | `functions.sh` | 🟡 | `crearBackup` aplana rutas en `Backups/`; colisiones de nombre |
| 6 | `functions.sh` | 🟡 | `addScriptToBin` escribe en `/bin/` en vez de `/usr/local/bin/` |
| 7 | `functions.sh` | 🟢 | `enlazarHome`, `descargarGIT`, `dir_exist_or_create`, `strFileReplace` funcionan bien |
| 8 | `main.sh` | 🟡 | `if [[ -f "$HOME/.gnupg" ]]` y `if [[ -f "/etc/apt/keyrings" ]]` — son directorios, `-f` nunca se cumple. Código muerto |
| 9 | `main.sh` | 🟡 | `PATH_LOG` por defecto `errors.log` frente a `errores.log` en `env.example` |
| 10 | `main.sh` | 🟡 | `USER=$(whoami)` pisa la variable estándar `USER` |
| 11 | `main-vps.sh` | 🔴 | `if [[ "$username" = '' ]] && [[ "$username" = ' ' ]]` — condición imposible, el fallback a `admin` nunca ocurre |
| 12 | `main-vps.sh` | 🟡 | `gpasswd -a $username go` — el grupo `go` no existe salvo que se haya creado antes |
| 13 | `main-vps.sh` | 🟡 | Añade las líneas de IPv6 a `/etc/sysctl.conf` sin comprobar duplicados (hay un TODO reconociéndolo) |
| 14 | `main-vps.sh` | 🟡 | Clona desde GitLab mientras el README documenta GitHub |
| 15 | `routes.sh` | 🔴 | La rama de Gentoo no asigna ninguna variable de ruta |
| 16 | `routes.sh` | 🟠 | macOS asume `/opt/homebrew`: solo Apple Silicon |
| 17 | `routes.sh` | 🟡 | Rutas de Fedora marcadas con `TODO → Estas rutas hay que verificarlas` |
| 18 | `preferences.sh` | 🟡 | `setDistro`/`setBranch` usan la variable global `input` sin inicializar ni declarar `local` |
| 19 | `preferences.sh` | 🟡 | `setHostName` solo actúa si `hostname` devuelve vacío: prácticamente nunca |
| 20 | `preferences.sh` | 🟡 | Idioma fijado a `es_ES.UTF-8` sin posibilidad de elegir |
| 21 | `limpiador.sh` | 🔴 | `restaurar_Backups()` solo hace un `echo`. Las líneas `mv "$WORKSCRIPT/Backups/$d"` que restaurarían están **comentadas**. Borra `.zshrc`, `.vimrc`, `.oh-my-zsh`, `.bash_it`… con `rm -Rf` sin red de seguridad |
| 21b | `limpiador.sh` | 🟡 | Redeclara su propia paleta de colores sin `CY`, `GR` ni `MA`, en vez de heredar la de `main.sh` |
| 21c | `limpiador.sh` | 🟡 | Llama a `desinstalar_paquetes "$paquetes_borrar"` con los seis paquetes en una sola cadena entrecomillada. Por el defecto #2 la orden acaba siendo `apt-get purge -y x` y no borra nada: hoy el bug #2 está tapando este otro |

## Repositorios

| # | Fichero | Est. | Detalle |
|---|---|---|---|
| 22 | `Repositorios/0_Main.sh` | 🔴 | No hace `source` de `gentoo.sh` pero llama a `agregarRepositoriosGentoo` |
| 23 | `Repositorios/0_Main.sh` | 🟡 | Cabecera con datos antiguos del autor (`fryntiz`) mientras el resto usa `raupulus` |
| 24 | `debian/common.sh` | 🟢 | Claves modernas con `gpg --dearmor` + `signed-by`. Kali, Etcher, DBeaver, VSCode, VSCodium, AnyDesk, Beekeeper, QOwnNotes (Debian_13), Stripe |
| 25 | `debian/common_vps.sh` | 🔴 | `apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80` — la red SKS está apagada desde 2021 |
| 26 | `debian/common_vps.sh` | 🟠 | PostgreSQL sigue con `apt-key add -`, obsoleto desde Debian 11 |
| 27 | `debian/stable/sources.list` | 🟡 | Comentario "Actualizaciones para Stretch" (Debian 9) |
| 28 | `debian/vps/sources.list` | 🟡 | Duplicado exacto de `stable/sources.list` |
| 29 | `debian/testing/sources.list` | 🟡 | La línea de `testing-security` omite `contrib` y `non-free`, a diferencia del resto |
| 30 | `debian/*/sources.list` | 🟡 | PPAs de Launchpad `fryntiz` en `xenial`, comentados pero muertos |
| 31 | `raspbian/sources.list.d/raspi.list` | 🔴 | Fijado a `buster` (Debian 10, EOL). Raspberry Pi OS actual es bookworm/trixie |
| 32 | `raspbian/sources.list.d/piaware-buster.list` | 🟠 | Mismo problema, y el nombre del fichero lleva el codename dentro |
| 33 | `raspbian/sources.list.d/runner_gitlab-runner.list` | 🟠 | `buster` + `apt-key add -` |
| 34 | `raspbian.sh` | 🟠 | Repo de sury PHP fijado a `buster`; `apt-key add -` |
| 35 | `debian.sh` | 🟡 | En la rama "no VPS" también llama a `common_vps_add_repositories` |
| 36 | `debian.sh` | 🟡 | `chmod 744 -R /etc/apt/sources.list.d` y después `755` sobre el directorio: redundante y confuso |
| 37 | `comunes/mongodb.list` | 🟢 | MongoDB 8.0 sobre bookworm con `signed-by` |

## Módulos

| # | Fichero | Est. | Detalle |
|---|---|---|---|
| 38 | `servers/0_Main.sh` | 🔴 | La opción 12 llama a `postfix_instalador`. El fichero `servers/postfix.sh` **existe**, pero `0_Main.sh` **no le hace `source`** → *command not found* |
| 39 | `servers/0_Main.sh` | 🟡 | Comentarios copiados: la 12 dice "Instala Mumble" y la 14 "Instala Servidor Mail" |
| 40 | `servers/*` | 🔴 | Ruta fija `${SOFTLIST}/servers/...`, pero en Fedora y Gentoo la carpeta se llama `Servidores/`. Verificado: existe `Software-Lists/fedora/Servidores/apache2.lst` y `Software-Lists/debian/servers/apache2.lst` |
| 40b | `servers/postfix.sh` | 🔴 | `postfix_postconfiguracion`: la condición está invertida (configura **cuando el dominio se deja en blanco**) y `local dominio=''` nunca recibe el valor de `$input`, así que los `sed` escriben una cadena vacía en `main.cf` |
| 40c | `Software-Lists/debian/servers/apache2.lst` | 🟡 | `libapache2-mod-python` y `libapache2-mod-fcgid` aparecen duplicados |
| 41 | `Usuario/0_Main.sh` | 🟠 | `spacevim.sh` comentado. `usuario.md` sigue documentando SpaceVim como activo |
| 42 | `Usuario/0_Main.sh` | 🔴 | Rutas `/home/${USER}/...` en vez de `$HOME`: rompe en macOS |
| 43 | `Usuario/0_Main.sh` | 🟡 | `cd ... \|\| return 1 && ./instalar.sh` — precedencia de operadores confusa |
| 44 | `Usuario/heroku.sh` | 🟠 | Heroku CLI, de uso residual hoy |
| 45 | `Desktops/0_Main.sh` | 🟡 | El título del menú dice "Menú de Personalización del sistema" |
| 46 | `Desktops/0_Main.sh` | 🟢 | i3, Sway, Xmonad, Openbox y GNOME correctamente enlazados |
| 47 | `configurations/0_Main.sh` | 🟡 | Comentario de la opción 3 dice "Instala NodeJS" |
| 48 | `raspberry/0_Main.sh` | 🟡 | La opción `0` hace `exit 0` y mata el script entero en vez de volver al menú anterior |
| 49 | `raspberry/piaware.sh` | 🟠 | FlightAware sobre repos de buster |
| 50 | `VPS/0_Main.sh` | 🟠 | Deshabilita `apt-daily` y `apt-daily-upgrade`: sin actualizaciones automáticas de seguridad en una máquina expuesta |
| 51 | `VPS/0_Main.sh` | 🟡 | Se llama `menuVPS` pero no muestra menú: ejecuta todo de golpe |
| 51b | `Personalizar/gtk.sh` | 🔴 | `gconftool-2 –type string –set ...` usa **guion largo tipográfico** (`–`) en vez de `--`. El comando falla siempre. Además `gconftool-2` es de la era GNOME 2 |
| 51c | `Personalizar/gtk.sh` | 🔴 | `gsettings set org.gnome.desktop.input-sources "[('xkb','es'),...]"` — falta el nombre de la clave entre esquema y valor |
| 51d | `Personalizar/gtk.sh` | 🔴 | `gsettings set org.gnome.desktop.default-applications.terminal 'exec-arg' "tilix"` — ese esquema está obsoleto y el orden de argumentos es incorrecto |
| 51e | `Personalizar/grub.sh` | 🔴 | Define `grub_install()` pero **ningún fichero le hace `source`**: ni `0_Main.sh` ni `gtk.sh`. Código inalcanzable |
| 51f | `Personalizar/gtk.sh` | 🟡 | `configurar_grub()` es un stub vacío con un comentario. El trabajo real lo hace `configurar_fondos` |
| 51g | `Personalizar/gtk.sh` | 🟡 | `configurar_temas` fija el tema `Flat-Plat-compact` y después `conf_gnome3` lo pisa con `Paper`. Contradictorio |
| 51h | `Personalizar/gtk.sh` | 🟠 | `sudo update-initramfs -u` incondicional: no existe en Fedora ni en macOS |
| 51i | `Personalizar/gtk.sh` | 🟡 | `cd ... \|\| return 1 && ./install.sh` en `configurar_fondos`: misma precedencia confusa que en `Usuario/0_Main.sh` |
| 51j | `Personalizar/services.sh` | 🟠 | Deshabilita `unattended-upgrades.service`, `apt-daily.timer` y `apt-daily-upgrade.timer` **en todos los equipos**, no solo en VPS. Ningún equipo recibe actualizaciones de seguridad automáticas |
| 51k | `Personalizar/services.sh` | 🟡 | `TODO` reconocido: sin implementación para macOS, solo imprime un aviso |
| 52 | `Lenguajes-Programacion/0_Main.sh` | 🟡 | El comentario de Perl dice "Instala C y C++" |
| 53 | `Lenguajes-Programacion/` | 🟠 | No hay Rust ni Java; NodeJS está en `servers/` y no aquí |
| 54 | `Apps/0_Main.sh` | 🟢 | Bien estructurado, con exclusión explícita de macOS para IDEs/Flatpak/VPS |
| 54a | `Apps/IDEs/android_studio.sh` | 🔴 | URL fijada a un nodo CDN de Google (`r1---sn-h5q7rn7s.gvt1.com`) con parámetros de sesión caducados (`mt=1585862242`, marca de tiempo de 2020) y versión `3.6.2.0`. Esa descarga está muerta con total seguridad |
| 54b | `Apps/Pencil-Project.sh` | 🔴 | Descarga por **`http://`** sin cifrar un `.deb` que después se instala con `dpkg`. Es el único punto del proyecto donde se instala un paquete descargado sin TLS |
| 54c | `Apps/Haroopad.sh` | 🟠 | Versión `0.13.1` fijada desde Bitbucket. El proyecto Haroopad está abandonado y Bitbucket retiró parte de sus descargas en 2020 |
| 54d | `Apps/DBeaver.sh` | 🟠 | Usa el dominio antiguo `dbeaver.jkiss.org` y descarga el `.deb` a mano, cuando ya existe el repositorio apt oficial en `Repositorios/debian/comunes/dbeaver.list`. Lógica duplicada |
| 54e | `Apps/GitKraken.sh` | 🟢 | URL genérica sin versión fijada (`gitkraken-amd64.deb`): no caduca |
| 54f | `Apps/IDEs/{phpstorm,pycharm_pro,webstorm}.sh` | 🟢 | Reciben la versión por parámetro en vez de fijarla en la URL |

## Transversal

| # | Est. | Detalle |
|---|---|---|
| 55 | 🟡 | Convenciones mezcladas: `menuServidores` / `menu_configurations`; `*_installer` / `*_instalador`; nombres de directorio en `Mayúscula`, `minúscula` y con guion |
| 56 | 🟡 | Español e inglés mezclados en nombres de función, variables y comentarios |
| 57 | 🟠 | Cabeceras de fichero con `@copyright` entre 2017 y 2021 y algún `@email` antiguo |
| 58 | 🟡 | No hay ni un test ni un `--dry-run`. La única validación es shellcheck vía CodeClimate |
| 59 | 🟠 | `docs/README.md` contiene una sola línea: "# Documentación Detallada" |

## Qué sirve tal cual

- El patrón `0_Main.sh` con `-a`: es sólido y merece conservarse.
- `Repositorios/debian/common.sh`: es el ejemplo a seguir para el resto de
  distros en cuanto a manejo de claves GPG.
- `enlazarHome` + `conf/home/`: el modelo de dotfiles versionados funciona.
- El módulo `Apps/` y su submenú `IDEs/`.
- La separación de repos por rama (`stable`/`testing`/`unstable`/`vps`).
- El flujo de `Desktops/`.

## Prioridad sugerida para la fase 2

1. Arreglar `instalarSoftwareLista` — afecta a todas las distros (#1).
2. Desacoplar la distro: tabla de gestores de paquetes en vez de cadenas de
   `if/elif` repetidas en diez funciones.
3. Actualizar Raspberry OS de buster a la versión vigente (#31–34).
4. Cerrar o retirar Gentoo (#15, #22) — hoy está roto de forma silenciosa.
5. Sustituir los `apt-key` restantes por `signed-by` (#25, #26, #33, #34).
6. Añadir SteamOS/pacman — ver [`steamos.md`](steamos.md).
7. `limpiador.sh`: implementar la restauración o retirar el script (#21).
