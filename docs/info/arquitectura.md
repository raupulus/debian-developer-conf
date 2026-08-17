# Arquitectura y flujo de arranque

## Puntos de entrada

| Script | Usuario | Cuándo |
|---|---|---|
| `main.sh` | usuario con `sudo` | Uso normal. **Debe ejecutarse desde la raíz del repo** (`WORKSCRIPT=$PWD`) |
| `main-vps.sh` | root | VPS recién aprovisionado, antes de clonar el repo. Se descarga suelto con `wget` |

`main.sh` acepta tres atajos posicionales que saltan el menú y salen:
`./main.sh vim`, `./main.sh nano`, `./main.sh terminals`.

## Orden de carga de `main.sh`

1. Constantes de color (`$RO`, `$VE`, `$AZ`, `$AM`, `$BL`, `$CY`, `$GR`, `$MA`, `$CL`).
2. `source /etc/environment` si existe.
3. `DEBIAN_FRONTEND=noninteractive`, `WORKSCRIPT=$PWD`, `PATH_LOG`.
4. `source $WORKSCRIPT/.env` si existe → **pisa lo global**.
5. `MY_DISTRO`, `MY_BRANCH`, `MY_ENV` se copian de `$DISTRO`, `$BRANCH`, `$ENV`.
6. `source routes.sh`, `functions.sh`, `preferences.sh`, `limpiador.sh`.
7. `source` de los once `0_Main.sh` de módulo.
8. `configurePreferences` → pregunta distro/rama/entorno si faltan y los
   persiste en `/etc/environment` con `setVariableGlobal`.
9. `setAllRoutes` → fija rutas de Apache según `$DISTRO`. **Aborta con `exit 1`
   si la distro no encaja en ninguna rama.**
10. `SOFTLIST="${WORKSCRIPT}/Software-Lists/${MY_DISTRO}"`.
11. `menuPrincipal`.

Versión declarada en `main.sh`: `VERSION='0.8.14'`.

## Patrón de módulo

Cada directorio de módulo contiene un `0_Main.sh` que:

- hace `source` de los scripts hermanos del módulo,
- define una función de menú (`menuAplicaciones`, `menuServidores`,
  `menu_configurations`, `menuUsuario`, `menuVPS`…),
- acepta `-a` para ejecutar todo el módulo sin interacción.

El patrón se anida un nivel en `Apps/IDEs/0_Main.sh`.

**No hay convención de nombres única**: conviven `menuServidores` (camelCase
español), `menu_configurations` (snake_case inglés) y `menu_root`. Igual con las
funciones instaladoras: `apache2_installer` frente a `mariadb_instalador`.

## Variables de entorno

Plantilla en `env.example` (copiar a `.env`):

```
DISTRO=debian
BRANCH=stable
ENV=dev
ADMIN_EMAIL=admin@email.es
DEBUG=false
PATH_LOG="$WORKSCRIPT/errores.log"
```

Precedencia: `.env` > `/etc/environment` > valores por defecto de `main.sh`.

`setVariableGlobal` **solo escribe si la variable está vacía** y hace `tee -a`
sobre `/etc/environment`. Consecuencias: cambiar de rama obliga a editar
`/etc/environment` a mano, y ejecuciones repetidas pueden acumular líneas
duplicadas.

`DEBUG=true` hace que `clear_screen` no limpie la pantalla y activa `log`.

## Dependencias mínimas

- `main.sh` exige `/usr/bin/sudo` o aborta.
- `main-vps.sh` exige ser root y tener `git` y `wget`.

## Ficheros de la raíz

| Fichero | Rol |
|---|---|
| `main.sh` | Menú principal |
| `main-vps.sh` | Bootstrap de VPS como root |
| `functions.sh` | Librería común — ver [`functions.md`](functions.md) |
| `routes.sh` | Rutas de Apache por distro |
| `preferences.sh` | Configuración interactiva inicial y persistencia |
| `limpiador.sh` | Limpieza agresiva. **Zona de alto riesgo**, sin restauración real |
| `env.example` | Plantilla de `.env` |
| `.codeclimate.yml` | shellcheck + markdownlint; SC2162, SC2086, SC2033 y SC1090 desactivadas a propósito |

## Directorios que no son módulos

`Accesos_Directos/` (ficheros `.desktop`), `fonts/`, `conf/` (dotfiles maestros
y scripts para `/bin`), `resources/` (sin uso activo), `Software-Lists/`, y
`Backups/` y `tmp/` que se generan en tiempo de ejecución y están en
`.gitignore`.
