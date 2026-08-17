# `functions.sh` — librería común

API interna del proyecto. Todo script de módulo debe reutilizar estas funciones
en lugar de reimplementar la lógica.

## Instalación de software

| Función | Qué hace | Distros cubiertas |
|---|---|---|
| `instalarSoftware $*` | Instala uno o más paquetes | apt, emerge, dnf, brew |
| `actualizarSoftware $*` | Actualiza paquetes concretos | apt, emerge, dnf, brew |
| `actualizarRepositorios` | Refresca listas de paquetes | apt, emerge, dnf, brew |
| `instalarSoftwareLista $1` | Instala todos los paquetes de un fichero `.lst` | todas (con matices, ver abajo) |
| `instalarSoftwareDPKG $*` | `dpkg -i` + reparación posterior | solo Debian/Raspbian |
| `instalarSoftwareFlatPak $*` | Instala vía flatpak `--user` | Linux |
| `instalarSoftwareFlatPakLista $1` | Igual pero desde fichero | Linux |
| `desinstalar_paquetes $*` | `apt-get purge` / `brew remove` | apt, brew |
| `repararGestorPaquetes` | `--fix-broken install` | solo Debian/Raspbian |
| `prepararInstalador` | `update` + `install -f` | solo Debian/Raspbian |
| `instalarNpm $*` / `instalarNpmGlobal $*` | Paquetes npm | todas |
| `python3Install $*` | `pip3 --user --break-system-packages` | todas |
| `python3InstallGlobal $*` | `sudo pip3` global | todas |
| `python2Install $*` | **Función muerta**: el `pip2` está comentado | — |

## Ficheros y descargas

| Función | Qué hace |
|---|---|
| `crearBackup $*` | Copia ficheros/directorios a `Backups/` |
| `descargar $1 $2` | Descarga `$2` a `tmp/$1`, hasta 20 reintentos |
| `descargarTo $1 $2` | Descarga `$1` a la ruta `$2`, hasta 10 reintentos |
| `descargarGIT $1 $2 $3` | Clona repo con reintentos; si ya existe, actualiza |
| `actualizarGIT $1 $2` | `git checkout -- . && git pull` sobre un clon existente |
| `enlazarHome $*` | Backup + symlink desde `conf/home/<x>` a `$HOME/<x>` |
| `dir_exist_or_create $1` | `mkdir -p` si no existe |
| `addScriptToBin $*` | Copia `conf/bin/<x>.sh` a `/bin/<x>` con permisos 755 |
| `strFileReplace $1 $2` | `sed -i` con patrón, contemplando la sintaxis de macOS |

## Sistema y utilidades

| Función | Qué hace |
|---|---|
| `setVariableGlobal $1 $2` | Añade `VAR=valor` a `/etc/environment` **solo si está vacía** |
| `reiniciarServicio $*` / `pararServicio $*` | `systemctl` o `brew services` |
| `log $1` | Escribe en `$PATH_LOG` |
| `clear_screen` | `clear`, salvo con `DEBUG=true` |
| `opciones $1` | Pinta el bloque de opciones de un menú |

## Contrato de `enlazarHome`

Es la pieza central de la gestión de dotfiles:

1. Si `$HOME/$x` ya es un symlink → lo borra.
2. Si es fichero o directorio y **no** hay backup previo → `crearBackup` y borra.
3. Si ya existía backup → borra sin más.
4. `ln -s "$WORKSCRIPT/conf/home/$x" "$HOME/$x"`.

Implicación importante: **el repo tiene que quedarse donde está**. Si mueves o
borras el directorio del proyecto, todos los dotfiles enlazados se rompen.

## Defectos conocidos de esta librería

Detallados en [`auditoria-estado.md`](auditoria-estado.md). Los que más
condicionan escribir código nuevo:

- `instalarSoftwareLista` está **rota** en la rama Debian: usa
  `${dpkg-query ...}` (expansión de parámetro) donde debía usar `$( ... )`, y
  `lista_Software=$(cat $1)` produce una cadena que luego se recorre como si
  fuese un array. En la práctica solo evalúa el primer elemento.
- `desinstalar_paquetes` hace `apt-get purge -y x` con la `x` literal, sin `$`.
- `repararGestorPaquetes` es la única función que ramifica por `$MY_DISTRO` en
  lugar de `$DISTRO`.
- `crearBackup` aplana la jerarquía en `Backups/`: dos ficheros con el mismo
  nombre en rutas distintas se pisan.
- `addScriptToBin` escribe en `/bin/`, no en `/usr/local/bin/`.
- Ninguna función contempla `pacman`, lo que bloquea el soporte de SteamOS.
