# Software-Lists — listas de paquetes por distro

Mecanismo por el que los módulos saben **qué** instalar sin hardcodear nombres
de paquete dentro del script.

## Cómo funciona

`main.sh` define, después de `setAllRoutes`:

```bash
SOFTLIST="${WORKSCRIPT}/Software-Lists/${MY_DISTRO}"
```

Los scripts de módulo construyen rutas a partir de ahí y se las pasan a
`instalarSoftwareLista` o `instalarSoftwareFlatPakLista`:

```bash
instalarSoftwareLista "${SOFTLIST}/servers/apache2.lst"
```

## Formato

Ficheros `.lst` planos: **un paquete por línea, sin comentarios ni cabecera**.
`instalarSoftwareLista` los lee con `cat` y no filtra nada, así que una línea
en blanco o un `#` se tratarían como nombre de paquete.

## Organización

Una carpeta por distro, con subcarpetas por área temática (aplicaciones,
servidores, lenguajes, escritorios…).

**Las listas no están sincronizadas 1:1 entre distros.** No asumas que existe
el mismo fichero en `debian/` y en `fedora/` al portar una funcionalidad: hay
que comprobarlo cada vez.

## Incoherencia conocida: `servers/` vs `Servidores/`

| Distro | Nombre real de la carpeta |
|---|---|
| debian, raspbian, macos | `servers/` |
| fedora, gentoo | `Servidores/` |

Todos los scripts de `servers/*.sh` referencian `${SOFTLIST}/servers/...`
hardcodeado. Resultado: **en Fedora y Gentoo esa ruta no existe** y la
instalación de servidores no encuentra sus listas. Es uno de los primeros
puntos a tocar si se quiere arreglar el soporte de esas dos distros.

## Defecto de `instalarSoftwareLista`

La función que consume estas listas está rota en la rama Debian/Raspbian
(detalle en [`functions.md`](functions.md) y en
[`auditoria-estado.md`](auditoria-estado.md)). En la práctica no comprueba
correctamente qué está ya instalado y no recorre bien la lista. Antes de añadir
listas nuevas conviene arreglar la función.

## Al añadir una distro

1. Crear `Software-Lists/<distro>/` replicando la estructura de `debian/`.
2. Respetar el nombre `servers/` en minúscula, no `Servidores/`.
3. Traducir los nombres de paquete: casi ninguno coincide entre apt, dnf,
   emerge, brew y pacman.
4. Para SteamOS, separar las listas de flatpak de las del contenedor — ver
   [`steamos.md`](steamos.md).
