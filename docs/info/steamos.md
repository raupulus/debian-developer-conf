# SteamOS — sistema objetivo pendiente

**Estado: no implementado.** No existe `steamos` en `preferences.sh`, ni rama
`pacman` en `functions.sh`, ni `Repositorios/steamos.sh`, ni
`Software-Lists/steamos/`. Este documento recoge el análisis previo para
decidir cómo encajarlo.

## Qué es

SteamOS 3.x es la distribución de Valve para Steam Deck y Steam Machine.
Está basada en Arch Linux y usa `pacman`, pero **no se comporta como un Arch
normal**. Las diferencias condicionan todo el diseño.

## Restricciones que cambian las reglas del proyecto

1. **Sistema de ficheros raíz de solo lectura.** `/` está montado en modo
   lectura. Escribir requiere `sudo steamos-readonly disable`, lo que
   invalida las garantías del sistema.
2. **Actualizaciones atómicas A/B.** Al actualizar el sistema se reemplaza la
   partición raíz entera. **Todo lo instalado con `pacman` desaparece.**
   Cualquier instalación en `/` es efímera por diseño.
3. **Keyring de pacman sin inicializar** en muchas imágenes: haría falta
   `pacman-key --init` y `--populate` antes de instalar nada.
4. **Dos modos de sesión**: modo juego (gamescope) y modo escritorio (KDE
   Plasma). Un window manager como i3 o Sway no encaja en el flujo de Valve.
5. **Usuario por defecto** `deck`, sin contraseña establecida de origen.

## Consecuencia de diseño

La estrategia de este proyecto — instalar paquetes del sistema y volcar
configuración global — **no es trasladable tal cual**. Lo que sí persiste
entre actualizaciones es `$HOME`.

Reparto recomendado:

| Necesidad | Vía en SteamOS |
|---|---|
| Aplicaciones gráficas | Flatpak (persiste en `$HOME`) |
| Herramientas de desarrollo y CLI | Contenedor (`distrobox` / `toolbox`) |
| Dotfiles, shell, editores | `enlazarHome` sobre `$HOME` — funciona igual |
| Paquetes del sistema con `pacman` | Evitar. Se pierden en cada actualización |
| Servidores (Apache, MariaDB…) | Dentro del contenedor, nunca en el host |

## Qué habría que tocar

1. `preferences.sh` → añadir `steamos` a `getDistrosAvailable()`,
   `getBranchAvailable()` (rama única) y al bucle de `setDistro()`.
2. `functions.sh` → rama `pacman` en `instalarSoftware`, `actualizarSoftware`,
   `actualizarRepositorios`, `desinstalar_paquetes`; y decidir qué hacen
   `repararGestorPaquetes` y `prepararInstalador` (probablemente nada).
3. `routes.sh` → rama para `steamos` o, mejor, marcar el módulo `servers/`
   como no aplicable en el host. Recordar que hoy una distro sin rama provoca
   `exit 1`.
4. `Software-Lists/steamos/` → listas separadas: `flatpak/` para el host y
   `contenedor/` para lo que va dentro de distrobox.
5. Módulo nuevo o condicional que gestione `steamos-readonly` de forma
   explícita y avisada, nunca de forma silenciosa.
6. Excluir de SteamOS los módulos `Desktops/`, `configurations/` (crons y
   hosts globales se pierden al actualizar) y `VPS/`.

## Alternativa a valorar en la fase 2

En vez de tratar SteamOS como una distro más dentro de la misma cadena de
`if/elif`, puede salir más limpio introducir un **perfil de capacidades**:
`tiene_paquetes_persistentes`, `admite_wm`, `admite_servicios_systemd`,
`raiz_escribible`. SteamOS sería el primer caso donde varias son `false`, pero
también aclararía los límites de macOS.

## Pendiente de verificar antes de implementar

- Nombre exacto del identificador en `/etc/os-release` de la versión vigente.
- Si el Steam Machine comparte imagen con Steam Deck o diverge.
- Comportamiento actual de `steamos-readonly` y si sigue siendo el mecanismo
  recomendado.
