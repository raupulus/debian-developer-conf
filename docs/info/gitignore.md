# `.gitignore` — qué se ignora y por qué

Estado revisado sobre la rama `main`.

## Lo que ya está cubierto

| Grupo | Patrones | Motivo |
|---|---|---|
| Runtime del script | `Backups/*`, `tmp/*`, `/TMP/*`, `logs/*` | Directorios que genera `crearBackup` y `descargar` en cada ejecución |
| Logs | `errores.log`, `errors.log`, `npm-debug.log` | Ambas grafías de `PATH_LOG` conviven a propósito (ver [`riesgos.md`](riesgos.md)) |
| Entorno | `/.env` | Contiene `ADMIN_EMAIL` y la configuración local del equipo |
| Plugins de Vim | `conf/home/.vim/{plugin,bundle,colors,sessions,doc,autoload}`, `.netrwhist`, `vimoutlinerrc` | Los genera el gestor de plugins, no son fuente |
| Editores / IDE | `/.idea` | Metadatos de JetBrains |
| Python | `__pycache__`, `.ropeproject`, `__init__.py` | Caché y metadatos |
| Sistema operativo | `.DS_Store` | Ruido de macOS |
| Varios | `/NOTAS.txt`, `test.sh`, `/wget-log*` | Notas y pruebas locales del autor |
| **Planificación** | `docs/planning/`, `/docs/planning/` | Trabajo de planificación local, no forma parte del proyecto publicado |

`docs/planning/` **ya está excluido**. No hace falta tocar nada para eso.

## Observaciones sobre lo que hay

1. **Duplicación sistemática de patrones.** Casi todas las entradas aparecen dos
   veces, con y sin barra inicial (`/Backups/*` y `Backups/*`). En Git,
   `Backups/` sin barra ya cubre cualquier profundidad y `/Backups/` ancla a la
   raíz. Tener ambas no hace daño, pero infla el fichero a más del doble.
2. **`__init__.py` ignorado es discutible.** Es un marcador de paquete Python,
   no un artefacto generado. Si algún día se añade una herramienta en Python al
   repo, este patrón la romperá de forma difícil de diagnosticar. Merece al
   menos un comentario que explique por qué está.
3. **`test.sh` sin ancla** ignora cualquier `test.sh` a cualquier profundidad.
   Si en la fase 2 se añaden tests, hay que revisarlo antes.
4. **`/TMP/*` en mayúsculas** parece un resto histórico: el directorio que usa
   el código es `tmp/`.

## Huecos detectados

Ninguno crítico, pero conviene valorarlos en la fase 2:

| Falta | Por qué importa aquí |
|---|---|
| `.env*` o `.env.local` | Solo se ignora `/.env`. Cualquier variante quedaría versionada, y ahí van correo y configuración del equipo |
| `*.swp`, `*.swo`, `*~` | El proyecto instala y configura Vim; los swap son inevitables al editar dentro del repo |
| `*.bak`, `*.orig`, `*.rej` | Los generan `sed -i` y los merges de git |
| `node_modules/` | El proyecto usa `instalarNpm` y `instalarNpmGlobal`; una prueba local dejaría el directorio dentro |
| `*.pyc`, `venv/`, `.venv/` | `__pycache__` cubre parte, pero no todo |
| `.vscode/` | Solo está cubierto JetBrains (`/.idea`) |
| Material sensible: `*.pem`, `*.key`, `id_rsa*`, `.htpasswd` | Red de seguridad ante un `git add .` descuidado, dado que el proyecto genera `.htpasswd` y maneja claves GPG |

## Propuesta

No la aplico: en esta fase no se toca nada. Queda como bloque a añadir al final
del `.gitignore` actual cuando se abra la rama `dev`.

```gitignore
## --- Propuesta fase 2 ---

## Variantes de entorno
.env
.env.*
!env.example

## Editores
*.swp
*.swo
*~
.vscode/

## Artefactos de edición y merge
*.bak
*.orig
*.rej

## Dependencias locales de pruebas
node_modules/
venv/
.venv/
*.pyc

## Material sensible (red de seguridad, no debería llegar aquí nunca)
*.pem
*.key
id_rsa*
.htpasswd
```

Nota sobre `!env.example`: la plantilla **debe seguir versionada**. El patrón
`.env.*` no la afecta porque el fichero se llama `env.example`, sin punto
inicial, pero la negación se deja explícita por seguridad ante futuros cambios
de nombre.
