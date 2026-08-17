# Riesgos y problemas potenciales

Complemento de [`auditoria-estado.md`](auditoria-estado.md). Aquello no es una
lista de bugs concretos, esto son **riesgos de diseño**: cosas que hoy
funcionan pero que pueden morder.

## Pérdida de datos

| Riesgo | Dónde | Detalle |
|---|---|---|
| Borrado sin restauración | `limpiador.sh` | `rm -Rf` sobre `.zshrc`, `.vimrc`, `.oh-my-zsh`, `.bash_it`, `.vim`… y `restaurar_Backups()` solo hace un `echo`. Las líneas de restauración están comentadas |
| Colisión de backups | `functions.sh` → `crearBackup` | Copia todo a `Backups/` aplanando rutas: dos ficheros con el mismo nombre en directorios distintos se pisan |
| Backups no versionados | `.gitignore` | `Backups/*` está ignorado, así que el respaldo vive **solo** en el equipo. Un `git clean -xdf` se lo lleva |
| Enlaces rotos al mover el repo | `conf/home/` | Los symlinks del `$HOME` son absolutos. Mover el proyecto rompe todos los dotfiles del equipo |
| Sobrescritura sin preguntar | Todo el proyecto | Es una decisión de diseño explícita, pero implica que ejecutar el script sobre un equipo ya configurado a mano destruye esa configuración |

## Seguridad

| Riesgo | Dónde | Detalle |
|---|---|---|
| Sin actualizaciones automáticas | `Personalizar/services.sh`, `VPS/0_Main.sh` | Se deshabilitan `unattended-upgrades`, `apt-daily` y `apt-daily-upgrade`. En `services.sh` afecta a **todos los equipos**, no solo a VPS |
| Credenciales por defecto | `servers/mariaDB.sh` | Crea el usuario `dev` con contraseña `dev` y permisos plenos. Aceptable en local, peligroso si la máquina se expone |
| Claves GPG por métodos obsoletos | `common_vps.sh`, `raspbian.sh` | `apt-key add` está deprecado y `hkp://p80.pool.sks-keyservers.net` es una red apagada desde 2021: la clave no se descarga y el repo queda sin verificar |
| Repos de terceros sin fijar | `Repositorios/debian/comunes/` | Se añaden bastantes repos externos (Kali, Heroku, Stripe, MongoDB, GoCD…). Cada uno es superficie de ataque y fuente de conflictos de dependencias |
| Kali en un Debian | `comunes/kalilinux.list` | Está comentado, pero mezclar Kali con Debian rompe sistemas. Conviene que siga comentado y documentado como trampa |
| `sudo` sobre ficheros descargados | varios | Se descargan instaladores de terceros (`install.sh` de temas, project-generator) y se ejecutan con `sudo` sin verificar firma ni hash |
| Descarga sin TLS | `Apps/Pencil-Project.sh` | Un `.deb` se baja por `http://` y se instala con `dpkg`. Es el punto más expuesto del proyecto: cualquiera en la ruta de red puede sustituir el paquete |
| Binarios de terceros sin verificar | `Apps/*.sh`, `Apps/IDEs/*.sh` | Ningún `.deb` ni tarball descargado se contrasta contra hash o firma. El proyecto confía en el TLS del origen y en nada más |
| URLs con versión fijada | `Apps/IDEs/android_studio.sh`, `Haroopad.sh`, `Pencil-Project.sh` | Se pudren solas. La de Android Studio ya está muerta |
| IPv6 desactivado a lo bruto | `main-vps.sh` | Se escriben líneas en `/etc/sysctl.conf` sin comprobar duplicados. Cada ejecución añade otra tanda |
| Permisos laxos en APT | `Repositorios/debian.sh` | `chmod 744 -R /etc/apt/sources.list.d` — no es un agujero real, pero es innecesario |
| `.env` con datos sensibles | raíz | `ADMIN_EMAIL` y lo que se añada. Está en `.gitignore`, pero solo el de la raíz (`/.env`), no variantes como `.env.local` |

## Fragilidad operativa

| Riesgo | Detalle |
|---|---|
| Ejecución solo desde la raíz | `WORKSCRIPT=$PWD`. Lanzarlo desde otro directorio produce rutas rotas por todas partes, sin aviso claro |
| Variables persistidas e inmutables | `setVariableGlobal` solo escribe si la variable está vacía. Cambiar `DISTRO`, `BRANCH` o la configuración de monitores obliga a editar `/etc/environment` a mano |
| `/etc/environment` con duplicados | El `tee -a` puede acumular líneas repetidas entre ejecuciones |
| Abortos silenciosos por distro | Si `$DISTRO` no encaja en `routes.sh`, el script hace `exit 1` antes del menú. En Gentoo el fallo es aún más opaco: no aborta, simplemente deja las rutas vacías |
| Sin `--dry-run` ni tests | No hay forma de saber qué va a hacer el script antes de que lo haga. La única validación es shellcheck en CodeClimate |
| Dependencia de repos externos | `Art-for-Debian`, `materia-theme`, `project-generator`, `devicons-shell`, Oh My Zsh, Bash-it. Si alguno desaparece o cambia de rama, el paso falla |
| Reintentos ciegos | `descargar` reintenta 20 veces y `descargarGIT` 10. Ante un error permanente (404, DNS) se traduce en una espera larga sin diagnóstico |
| Sincronización multi-equipo | El repo se comparte entre máquinas. Un arreglo específico de hardware puede romper otra máquina si no se condiciona |

## Deuda que bloquea la ampliación

| Problema | Por qué frena |
|---|---|
| Cadenas `if/elif` por distro repetidas en ~10 funciones | Añadir SteamOS obliga a tocar las diez, y olvidar una produce un fallo silencioso |
| Rutas hardcodeadas `/home/${USER}` | Ya rompen macOS. Deberían ser `$HOME` |
| `${SOFTLIST}/servers/` frente a `Servidores/` | Bloquea Fedora y Gentoo |
| `instalarSoftwareLista` rota | Es el consumidor de todas las listas `.lst`: cualquier ampliación basada en listas hereda el fallo |
| Nomenclatura mezclada | Español/inglés y camelCase/snake_case conviven; cada fichero nuevo tiene que elegir y perpetúa la inconsistencia |
| Sin capacidades por sistema | No hay forma de expresar "esta distro no admite servicios systemd" o "la raíz es de solo lectura", que es justo lo que exige SteamOS |

## Cosas que parecen bugs pero no lo son

Documentadas para que nadie las "arregle" sin querer:

- **`errors.log` frente a `errores.log`**: la discrepancia entre `main.sh` y
  `env.example` es real, pero hay equipos con el valor ya persistido en
  `/etc/environment`. Cambiarlo sin migrar rompe esos equipos.
- **shellcheck SC2162, SC2086, SC2033 y SC1090 desactivadas** en
  `.codeclimate.yml`: es intencional.
- **`main-vps.sh` clona desde GitLab** mientras el README documenta GitHub:
  ambos remotos son válidos y están sincronizados.
- **`__init__.py` en `.gitignore`**: ver [`gitignore.md`](gitignore.md); es
  discutible, pero está puesto a propósito.
