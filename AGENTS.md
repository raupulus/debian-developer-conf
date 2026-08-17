# Reglas y Directrices para Agentes de IA

> **Ubicación**: este fichero debe vivir en la **raíz del repositorio**, no en
> `docs/`. Está aquí temporalmente porque la herramienta que lo generó no tenía
> permiso de escritura en la raíz. Muévelo con:
> `mv docs/AGENTS.md AGENTS.md`

Este archivo documenta el propósito, la estructura, el flujo de arranque y las
directrices de estilo y desarrollo del proyecto. Como agente de IA, léelo y
acátalo antes de modificar nada. Es la fuente de verdad: el `README.md` contiene
datos desactualizados (ver sección 8).

La documentación técnica detallada vive en `docs/info/`, con un documento corto
por área. El índice está en [`docs/info/indice.md`](docs/info/indice.md).

## 0. Cómo trabajar en este repositorio

Léelo antes que nada:

1. **`docs/info/` describe lo que hay, no lo que se pretende.** Si un documento
   describe una intención en vez de la realidad, es un error a corregir. Toda
   afirmación debe poder verificarse contra el fichero que describe.
2. **La planificación va a `docs/planning/`**, que está **excluido de git** a
   propósito. No propongas versionarlo ni muevas su contenido a `docs/info/`.
3. **`main` está congelada en cuanto a código.** El trabajo de modificación va
   en la rama `dev`. No hagas cambios de código sobre `main`.
4. **Cuando modifiques código, actualiza su documentación en el mismo commit.**
   No dejes `docs/info/` describiendo un comportamiento que ya cambiaste.
5. **No improvises implementaciones.** Si detectas algo roto y no se te ha
   pedido arreglarlo, anótalo en
   [`docs/info/auditoria-estado.md`](docs/info/auditoria-estado.md) y sigue.
6. **No muevas ni renombres ficheros que empiecen por punto** dentro de
   `conf/home/`: son los dotfiles maestros y hay symlinks vivos apuntando a
   ellos, con ruta absoluta, en varios equipos.

## 1. Propósito del Proyecto

`debian-developer-conf` configura entornos de trabajo automatizados para
desarrollo, y sincroniza la configuración del autor entre varios equipos y
servidores.

El script principal automatiza la instalación de aplicaciones, lenguajes de
programación, configuraciones de servidor, personalizaciones de interfaz y
ajustes a nivel de usuario y root. **Es deliberadamente no interactivo y
destructivo con la configuración existente** (fuerza `-y` en apt, sobrescribe
dotfiles); solo debe ejecutarse tras un backup o en una VM/equipo dedicado.

## 2. Sistemas objetivo

Documento de referencia: [`docs/info/sistemas-objetivo.md`](docs/info/sistemas-objetivo.md).

| Sistema | `$DISTRO` | Gestor | Estado |
|---|---|---|---|
| **Debian Testing** | `debian` + `BRANCH=testing` | apt | **Referencia del proyecto** |
| Debian Stable | `debian` + `BRANCH=stable` | apt | Bueno |
| Debian Stable VPS | `debian` + `stable` + `ENV=prod` | apt | Funcional con deuda |
| Raspberry OS | `raspbian` | apt | Desfasado (repos en `buster`) |
| Fedora | `fedora` | dnf | Parcial / experimental |
| Gentoo | `gentoo` | emerge | Roto |
| macOS | `macos` | brew | Parcial / experimental |
| SteamOS | *(pendiente)* | pacman | No implementado |

Reglas:

- **Debian Testing es la referencia.** Si una funcionalidad solo puede estar en
  un sitio, va ahí. Es donde primero se prueba todo.
- **La variante VPS no es una distro**, es `DISTRO=debian` + `BRANCH=stable` +
  `ENV=prod`. La detección está en `Repositorios/debian.sh`. Arrastra
  dependencias extra (`Apps/vps.sh`, `Repositorios/debian/common_vps.sh`) y el
  módulo `VPS/` (UFW, fail2ban, usuario administrador, zona horaria).
- **Añadir una distro exige tocar tres ficheros a la vez**: `preferences.sh`
  (validación), `functions.sh` (gestor de paquetes) y `routes.sh` (rutas). Si
  falta la rama en `routes.sh`, el script **aborta con `exit 1`** al arrancar.
- No asumas apt. Ramifica siempre por `$DISTRO` de forma explícita.
- Si el nombre del paquete cambia entre distros, resuélvelo con una lista en
  `Software-Lists/<distro>/`, no con un `if` dentro del script.

## 3. Flujo de arranque

Detalle completo en [`docs/info/arquitectura.md`](docs/info/arquitectura.md).

Dos puntos de entrada:

- **`main.sh`**: uso normal como usuario con `sudo`, clonando el repo primero.
  `WORKSCRIPT=$PWD`, así que **hay que ejecutarlo desde la raíz del repo**.
- **`main-vps.sh`**: se ejecuta **como root** en un VPS recién creado, antes de
  clonar nada (se descarga suelto vía `wget`). Crea el usuario del sistema,
  clona el repo (usa la URL de **GitLab**, mientras el README usa **GitHub**;
  ambos orígenes son válidos), **deshabilita IPv6 de forma permanente** y hace
  `su $username ./main.sh`. Bug conocido sin arreglar: la comprobación de
  usuario vacío usa `&&` en vez de `||` y nunca se cumple.

Orden de carga de `main.sh`:

1. `source /etc/environment` y luego `source $WORKSCRIPT/.env` — el `.env`
   local pisa lo global.
2. `source routes.sh`, `functions.sh`, `preferences.sh`, `limpiador.sh`.
3. `configurePreferences`: en la primera ejecución pregunta
   distro/rama/entorno/hostname/idioma/monitores y persiste las respuestas en
   `/etc/environment` vía `setVariableGlobal`.
4. `setAllRoutes`: fija rutas de Apache según `$DISTRO`; aborta si no encaja.
5. `SOFTLIST="${WORKSCRIPT}/Software-Lists/${MY_DISTRO}"`.
6. Carga los `0_Main.sh` de cada módulo y muestra `menuPrincipal()`.

Configuración: `env.example` → copiar a `.env`. Variables `DISTRO`, `BRANCH`
(stable/testing/unstable), `ENV` (dev/prod), `ADMIN_EMAIL`, `DEBUG`, `PATH_LOG`.
El default de `PATH_LOG` en `main.sh` apunta a `errors.log` pero `env.example`
usa `errores.log` — por eso `.gitignore` ignora ambas. **No lo "corrijas" sin
más**: cambiarlo rompería configuraciones ya persistidas en otros equipos.

`MY_DISTRO`/`MY_BRANCH`/`MY_ENV` conviven con `$DISTRO`/`$BRANCH`/`$ENV`. Es una
inconsistencia real del código, no una convención: usa `$DISTRO` salvo que el
contexto ya use `$MY_DISTRO`.

`main.sh` acepta flags posicionales que saltan el menú (`./main.sh vim`,
`nano`, `terminals`).

`limpiador.sh` es **agresivo y destructivo** (`rm -Rf`, `apt remove`) y su
`restaurar_Backups()` es un placeholder que no restaura nada. Zona de alto
riesgo.

## 4. Arquitectura de módulos

Cada carpeta de módulo contiene un `0_Main.sh` que actúa como menú y controlador
y acepta `-a` para ejecución desatendida. El patrón se anida en
`Apps/IDEs/0_Main.sh`.

| Módulo | Doc | Contenido |
|---|---|---|
| `Apps/` | [`apps.md`](docs/info/apps.md) | Aplicaciones e IDEs |
| `Repositorios/` | [`repositorios.md`](docs/info/repositorios.md) | Repos y claves GPG por distro y rama |
| `configurations/` | [`configurations.md`](docs/info/configurations.md) | Crons, hosts, scripts en PATH |
| `Personalizar/` | [`personalizar.md`](docs/info/personalizar.md) | GTK/QT, iconos, fuentes, cursores, git |
| `servers/` | [`servers.md`](docs/info/servers.md) | Apache, Nginx, MariaDB, PostgreSQL, Docker |
| `Lenguajes-Programacion/` | [`lenguajes_programacion.md`](docs/info/lenguajes_programacion.md) | PHP, Python, Ruby, Go, C/C++, Perl, Android |
| `Usuario/` | [`usuario.md`](docs/info/usuario.md) | Dotfiles, shell, editores CLI |
| `Desktops/` | [`desktops.md`](docs/info/desktops.md) · [`window-managers.md`](docs/info/window-managers.md) | GNOME · i3, Sway, Xmonad, Openbox |
| `root/` | [`root.md`](docs/info/root.md) | Entorno del superusuario |
| `VPS/` | [`vps.md`](docs/info/vps.md) | Firewall, fail2ban, hardening |
| `raspberry/` | [`raspberry.md`](docs/info/raspberry.md) | Optimizaciones Raspberry Pi |

Carpetas auxiliares — **no sigas el patrón `0_Main.sh` en ellas**:
`Accesos_Directos/` (ficheros `.desktop`), `fonts/`,
`conf/` (ver [`conf.md`](docs/info/conf.md)), `resources/` (sin uso activo),
`Software-Lists/` (ver [`software-lists.md`](docs/info/software-lists.md)), y
`Backups/` y `tmp/`, que son de runtime y están en `.gitignore`.

## 5. Librería común

`functions.sh` es la API interna. Referencia completa en
[`docs/info/functions.md`](docs/info/functions.md). **Reutilízala siempre en vez
de reimplementar.** Piezas clave: `instalarSoftware`, `instalarSoftwareLista`,
`enlazarHome`, `crearBackup`, `descargarGIT`, `setVariableGlobal`,
`dir_exist_or_create`, `addScriptToBin`, `strFileReplace`.

Ojo: varias de estas funciones tienen defectos conocidos y documentados en
[`docs/info/auditoria-estado.md`](docs/info/auditoria-estado.md). Consúltalo
antes de dar por bueno un comportamiento.

## 6. Guía de estilo

Bash, siguiendo <https://gitlab.com/raupulus/bash-guide-style>.

- Reutiliza `functions.sh` siempre que puedas.
- Evita rutas y variables hardcodeadas que puedan variar entre distros; apóyate
  en `routes.sh` o en condicionales.
- Paleta declarada en `main.sh`: `$RO` rojo (peligro/borrado), `$VE` verde
  (éxito/instalando), `$AZ` azul (títulos), `$AM` amarillo (avisos), `$BL`
  blanco, `$CY` cyan, `$GR` gris, `$MA` magenta, `$CL` reset al final de cada
  `echo`. `limpiador.sh` redeclara su propio subconjunto (sin `CY/GR/MA`): si
  cambias la paleta, revísalo también.
- Convive nomenclatura mezclada (`menuServidores` / `menu_configurations`,
  `*_installer` / `*_instalador`, español e inglés). Es deuda existente: sigue
  la convención del fichero que estés tocando, no introduzcas una tercera.

## 7. Reglas de comportamiento

1. **No interactividad**: `DEBIAN_FRONTEND=noninteractive` y `-y`. El script
   debe correr sin bloquearse.
2. **Backups**: al reescribir configuración de usuario existente, `crearBackup`.
3. **Distribuciones**: comprueba `$DISTRO` antes de instalar un paquete cuyo
   nombre pueda variar.
4. **Permisos**: no asumas root; invoca `sudo` donde corresponda sin romper el
   flujo de terminal.
5. **Compatibilidad multi-equipo**: el repo se sincroniza vía git entre varios
   equipos del autor. Cualquier arreglo específico de una máquina (drivers,
   claves GPG puntuales) debe ser inofensivo o condicional en el resto.
6. **No muevas ni renombres ficheros que empiecen por punto** dentro de
   `conf/home/`: son los dotfiles maestros y hay symlinks vivos apuntando a
   ellos en varios equipos.

## 8. Calidad y CI

`.codeclimate.yml`: `shellcheck` con **SC2162, SC2086, SC2033 y SC1090
deshabilitadas a propósito** (no las "arregles" masivamente sin que te lo
pidan), `markdownlint` (MD002 deshabilitado), duplicación y detección de
`FIXME`/`TODO`. Excluye `conf/`, `Apache2/`, `fonts/`, `usr/`.

No hay tests ni modo `--dry-run`.

El `README.md` de la raíz tiene información desactualizada en varios puntos. No
lo tomes como referencia de arquitectura: prevalece este `AGENTS.md`. Sí sirve
para el detalle de paquetes y versiones por stack (PHP, PostgreSQL, MariaDB,
vhosts de Apache) que no se repite aquí.

## 9. Estado del código

Antes de tocar nada, consulta:

- [`docs/info/auditoria-estado.md`](docs/info/auditoria-estado.md) — registro
  numerado de qué está roto, qué está desfasado y qué funciona tal cual.
- [`docs/info/riesgos.md`](docs/info/riesgos.md) — riesgos de diseño y
  problemas potenciales. Incluye una sección **"Cosas que parecen bugs pero no
  lo son"**: léela antes de "arreglar" nada por iniciativa propia.

## 10. Estructura de la documentación

| Ruta | Contenido | ¿En git? |
|---|---|---|
| `AGENTS.md` | Este fichero. Reglas y arquitectura | Sí |
| `README.md` | Presentación e instrucciones de uso | Sí |
| `docs/info/` | Documentación técnica del estado actual | Sí |
| `docs/planning/` | Planificación, plan de refactor, backlog | **No** |
| `docs/*.png`, `*.jpg` | Capturas del README | Sí |

Índice completo en [`docs/info/indice.md`](docs/info/indice.md). Lo que ignora
git y por qué está en [`docs/info/gitignore.md`](docs/info/gitignore.md).
