# Sistemas objetivo

Documento de referencia para decidir **dónde debe funcionar** cada cosa que se
escriba en este proyecto.

## Matriz de soporte

| Sistema | Valor de `$DISTRO` | Gestor de paquetes | Estado real | Notas |
|---|---|---|---|---|
| Debian Testing | `debian` + `BRANCH=testing` | apt | **Referencia** | Es el entorno principal del autor y el mejor mantenido |
| Debian Stable | `debian` + `BRANCH=stable` | apt | Bueno | Base de la variante VPS |
| Debian Stable (VPS) | `debian` + `stable` + `ENV=prod` | apt | Funcional con deuda | Ver sección "Variante VPS" |
| Raspberry OS | `raspbian` | apt | **Desfasado** | Repos fijados a `buster` (EOL) |
| Fedora | `fedora` | dnf | Parcial / experimental | Rutas Apache con `TODO` sin verificar |
| Gentoo | `gentoo` | emerge | **Roto** | Ver "Gentoo" más abajo |
| macOS | `macos` | brew | Parcial / experimental | Sin scripts en PATH, rutas Apple Silicon |
| SteamOS | *(no existe)* | pacman | **No implementado** | Ver [`steamos.md`](steamos.md) |

`BRANCH` admite `stable`, `testing` y `unstable`. `ENV` admite `dev` y `prod`.

## Dónde se decide la distro

Tres puntos, y hay que tocar los tres para añadir un sistema nuevo:

1. **`preferences.sh`** → `getDistrosAvailable()`, `getBranchAvailable()` y el
   bucle de validación de `setDistro()`. Si el valor no está en esa lista, el
   script no deja continuar.
2. **`functions.sh`** → `instalarSoftware()`, `actualizarSoftware()`,
   `actualizarRepositorios()`, `repararGestorPaquetes()`, `prepararInstalador()`,
   `desinstalar_paquetes()`, `reiniciarServicio()`, `pararServicio()`,
   `addScriptToBin()`, `strFileReplace()`. Todas ramifican por `$DISTRO`.
3. **`routes.sh`** → `routesApache2()`. Si `$DISTRO` no coincide con ninguna
   rama, **el script aborta con `exit 1`** antes de mostrar el menú.

A eso se suma `Software-Lists/<distro>/` (ver [`software-lists.md`](software-lists.md))
y `Repositorios/<distro>.sh`.

## Variante VPS

No es un `$DISTRO` aparte: es una combinación de variables.

```bash
# Repositorios/debian.sh
if [[ "$MY_BRANCH" = 'stable' ]] && [[ "$MY_ENV" = 'prod' ]]; then
    vps_add_repositories        # Repositorios/debian/vps.sh
    common_vps_add_repositories # Repositorios/debian/common_vps.sh
else
    ...
fi
```

Es decir: **VPS = `DISTRO=debian` + `BRANCH=stable` + `ENV=prod`**.

Qué cambia respecto a un escritorio:

- Repos: se usa `Repositorios/debian/vps/` en vez de `debian/stable/`, más
  `common_vps.sh` (PostgreSQL, Heroku, Tor, GoCD, MongoDB, sury PHP, Webmin).
- Punto de entrada alternativo `main-vps.sh`, que se ejecuta **como root** y
  antes de clonar el repo.
- Módulo `VPS/`: firewall UFW, fail2ban, usuario administrador, zona horaria.
- `menuVPS()` deshabilita `apt-daily` y `apt-daily-upgrade` (actualizaciones
  automáticas) — decisión discutible en una máquina expuesta a internet.
- `main-vps.sh` desactiva IPv6 de forma permanente vía `/etc/sysctl.conf`.

Dependencias extra que solo se instalan en esta variante están en
`Apps/vps.sh` y `Repositorios/debian/common_vps.sh`.

### Incoherencia conocida

En la rama "no VPS" también se llama a `common_vps_add_repositories`, con lo
que los repos "de VPS" acaban en equipos de escritorio. O el nombre está mal o
la llamada sobra.

## Gentoo

Está declarado pero no funciona:

- `Repositorios/0_Main.sh` **no hace `source` de `gentoo.sh`**, pero sí llama a
  `agregarRepositoriosGentoo` → *command not found*.
- `routes.sh` entra en la rama de Gentoo y **no asigna ninguna variable**
  (`APACHECONF`, `DIRWEB`…). Todo lo que dependa de esas rutas falla después.
- `Software-Lists/gentoo/` usa `Servidores/` mientras los scripts buscan
  `servers/` (mismo problema que Fedora).

## macOS

- `routesApache2()` asume `/opt/homebrew` → **solo Apple Silicon**. En Intel el
  prefijo es `/usr/local`.
- `addScriptToBin()` imprime "Scripts no implementados para macos" y no hace
  nada.
- `instalarSoftwareFlatPak()` intenta `brew install flatpak` y luego comprueba
  `/usr/bin/flatpak`, que en macOS nunca existe → siempre devuelve error.
- Varios scripts de `Usuario/` construyen rutas como `/home/${USER}/...`, que en
  macOS es `/Users/${USER}/...`.

## Reglas al añadir soporte

1. Ramifica siempre por `$DISTRO` explícitamente; no asumas apt.
2. Si el paquete se llama distinto en otra distro, resuélvelo con una lista en
   `Software-Lists/<distro>/`, no con un `if` dentro del script.
3. No añadas una distro a `preferences.sh` sin cubrir a la vez `functions.sh` y
   `routes.sh`, o el script abortará al arrancar.
4. Usa `$DISTRO`, no `$MY_DISTRO`, salvo que el fichero ya use la segunda.
