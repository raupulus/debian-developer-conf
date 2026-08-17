# Índice de documentación técnica

Documentos cortos y de contexto acotado. Cada uno se puede leer suelto sin
arrastrar el resto del proyecto.

## Transversales

| Documento | Contenido |
|---|---|
| [`arquitectura.md`](arquitectura.md) | Puntos de entrada, orden de carga, variables globales, patrón `0_Main.sh` |
| [`functions.md`](functions.md) | Referencia de la librería `functions.sh` (API interna del proyecto) |
| [`sistemas-objetivo.md`](sistemas-objetivo.md) | Matriz de los 7 sistemas soportados + variante VPS. **Documento de referencia** |
| [`software-lists.md`](software-lists.md) | Sistema de listas `.lst` de paquetes por distro |
| [`conf.md`](conf.md) | `conf/` — dotfiles maestros y scripts que van al PATH |
| [`gitignore.md`](gitignore.md) | Qué ignora git, por qué, y huecos detectados |
| [`auditoria-estado.md`](auditoria-estado.md) | Registro de qué está desfasado, qué está roto y qué sirve tal cual |
| [`riesgos.md`](riesgos.md) | Riesgos de diseño y problemas potenciales (no bugs concretos) |

## Por módulo

| Documento | Directorio | Contenido |
|---|---|---|
| [`repositorios.md`](repositorios.md) | `Repositorios/` | Gestión de repos y claves GPG por distro y rama |
| [`apps.md`](apps.md) | `Apps/` | Instalación de aplicaciones e IDEs |
| [`configurations.md`](configurations.md) | `configurations/` | Ajustes globales del sistema (hosts, crons, scripts en PATH) |
| [`servers.md`](servers.md) | `servers/` | Apache, Nginx, MariaDB, PostgreSQL, Docker, etc. |
| [`lenguajes_programacion.md`](lenguajes_programacion.md) | `Lenguajes-Programacion/` | PHP, Python, Ruby, Go, C/C++, Perl, Android |
| [`personalizar.md`](personalizar.md) | `Personalizar/` | Temas GTK/QT, iconos, cursores, fuentes, git |
| [`desktops.md`](desktops.md) | `Desktops/` | Entornos de escritorio completos (GNOME) |
| [`window-managers.md`](window-managers.md) | `Desktops/` | Window managers (i3, Sway, Xmonad, Openbox) |
| [`usuario.md`](usuario.md) | `Usuario/` | Dotfiles, shell, editores CLI, directorios del `$HOME` |
| [`root.md`](root.md) | `root/` | Entorno del superusuario |
| [`vps.md`](vps.md) | `VPS/` | Hardening y aprovisionamiento de servidores |
| [`raspberry.md`](raspberry.md) | `raspberry/` | Optimizaciones para Raspberry Pi |
| [`steamos.md`](steamos.md) | — | Sistema objetivo **no implementado todavía**. Análisis previo |

## Cómo usar esta documentación

- Para entender **cómo arranca** el proyecto → `arquitectura.md`.
- Para escribir un script nuevo → `functions.md` + `sistemas-objetivo.md`.
- Para saber **si algo se puede tocar sin romper nada** → `auditoria-estado.md`
  (bugs concretos) y `riesgos.md` (riesgos de diseño).
- Para entender dónde viven los dotfiles → `conf.md`.
- Las reglas de trabajo para agentes de IA están en `AGENTS.md` (raíz del repo).

## Qué no está aquí

La **planificación** (plan de refactorización, ampliación de sistemas, backlog)
vive en `docs/planning/`, que está excluido de git a propósito: es trabajo local
y no forma parte del proyecto publicado.

Esta carpeta `docs/info/` documenta el proyecto **tal y como es hoy**. Si algo
aquí describe una intención en vez de la realidad, es un error a corregir.
