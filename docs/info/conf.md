# `conf/` — dotfiles maestros y scripts

Directorio de **datos**, no de lógica. No tiene `0_Main.sh` ni se le hace
`source`. Contiene los ficheros que los módulos copian o enlazan en el sistema.

Está excluido del análisis de CodeClimate.

## `conf/home/`

Origen de todos los dotfiles del usuario. Es el destino fijo de `enlazarHome`:

```bash
ln -s "$WORKSCRIPT/conf/home/$x" "$HOME/$x"
```

Los ficheros se guardan **con el punto inicial** (`.zshrc`, `.vimrc`,
`.tmux.conf`…) y con la misma jerarquía que tendrán en el `$HOME`, incluidos
subdirectorios como `.config/i3/`, `.config/gtk-3.0/` o `.local/bin/`.

Contenido conocido, deducido de las llamadas a `enlazarHome` repartidas por el
proyecto:

| Ruta en `conf/home/` | Módulo que la enlaza |
|---|---|
| `.bashrc`, `.zshrc`, `.aliases` | `Usuario/terminales.sh` |
| `.vimrc`, `.gvimrc`, `.vim/` | `Usuario/vim.sh` |
| `.nanorc` | `Usuario/nano.sh` |
| `.tmux.conf` | `Usuario/tmux.sh` |
| `.config/gtk-2.0`, `.config/gtk-3.0`, `.config/gtk-4.0` | `Personalizar/gtk.sh` |
| `.config/i3/`, `.config/sway/` | `Desktops/i3.sh`, `Desktops/sway.sh` |
| `.local/bin/nuevo` | `Usuario/0_Main.sh` → `generador_plantillas` |
| `.local/bin/actualizar` | `Usuario/0_Main.sh` → `comandosPersonalizados` |
| `.local/bin/limpiar-cache-dns` | ídem |
| `.local/bin/limpiar-cache-sistema` | ídem |

### Consecuencias operativas

- **El repositorio no se puede mover ni borrar.** Los enlaces del `$HOME`
  apuntan a rutas absolutas dentro de `conf/home/`. Si mueves el proyecto, se
  rompen todos a la vez en ese equipo.
- **No renombres estos ficheros.** Hay symlinks vivos apuntando a ellos en
  varios equipos del autor.
- `.gitignore` excluye los subdirectorios generados de Vim
  (`conf/home/.vim/plugin`, `bundle`, `colors`, `sessions`, `doc`, `autoload`,
  `.netrwhist`, `vimoutlinerrc`) porque los crean los gestores de plugins.

## `conf/bin/`

Scripts que `addScriptToBin` copia al PATH del sistema:

```bash
sudo cp "${WORKSCRIPT}/conf/bin/${script}.sh" "/bin/${script}"
sudo chmod 755 -R "/bin/${script}"
```

Dos detalles: se copian **sin la extensión `.sh`**, y el destino es `/bin/`, no
`/usr/local/bin/`, que sería lo correcto para software ajeno a la distribución.
A diferencia de `conf/home/`, aquí se copia, no se enlaza: modificar el fichero
del repo no actualiza el que ya está en `/bin`.

En macOS la función no hace nada (`Scripts no implementados para macos`).

Quien invoca esto es `configurations/scripts.sh`.

## Otros contenidos

`conf/` también aloja plantillas de configuración que los módulos usan como
base antes de aplicar `sed` (por ejemplo, ficheros de Apache o de servicios).
`VPS/conf/.bashrc` es un caso aparte: vive dentro del módulo `VPS/`, no aquí.

## Diferencia con `Accesos_Directos/` y `fonts/`

| Directorio | Qué guarda | Cómo se aplica |
|---|---|---|
| `conf/home/` | Dotfiles del usuario | Symlink (`enlazarHome`) |
| `conf/bin/` | Scripts de utilidad | Copia a `/bin/` (`addScriptToBin`) |
| `Accesos_Directos/` | Ficheros `.desktop` | Copia a `~/.local/share/applications` |
| `fonts/` | Tipografías por familia | Copia a `/usr/share/fonts` o `~/.local/share/fonts` + `fc-cache` |
| `resources/` | — | Sin uso activo actualmente |
