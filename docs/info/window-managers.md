# Window managers

Gestores de ventanas del directorio `Desktops/`. Para el escritorio completo
(GNOME) ver [`desktops.md`](desktops.md).

## Scripts disponibles

| Script | Función | Servidor gráfico |
|---|---|---|
| `i3.sh` | `i3wm_instalador` | X11 |
| `sway.sh` | `sway_instalador` | Wayland |
| `xmonad.sh` | `xmonad_instalador` | X11 |
| `openbox.sh` | `openbox_instalador` | X11 |

Todos se cargan desde `Desktops/0_Main.sh`, que expone `menuDesktops` y acepta
`-a` para instalarlos todos de una pasada.

## Patrón común

1. `instalarSoftware` con el metapaquete y sus utilidades de apoyo.
2. `enlazarHome` para colocar la configuración bajo `~/.config/<wm>/`,
   tomándola de `conf/home/.config/<wm>/`.
3. Aplicaciones auxiliares: barra de estado, lanzador, fondo de pantalla.

## i3

Es el más desarrollado. Además de `i3`, instala utilidades del entorno
(`i3blocks`/`i3pystatus`, `rofi`, `feh`) y despliega una configuración con
atajos propios, barra de estado y soporte multi-monitor.

La configuración multi-monitor depende de las variables que fija
`preferences.sh` en `/etc/environment`:

```
DPI, DISPLAY0_NAME, DISPLAY0_DPI, DISPLAY0_RESOLUTION
DISPLAY1_NAME, DISPLAY1_DPI, DISPLAY1_RESOLUTION
DISPLAY2_NAME, DISPLAY2_DPI, DISPLAY2_RESOLUTION
```

Valores por defecto: `HDMI-0` a 1920x1080 y 90 DPI para la primera pantalla;
`false` en la segunda y la tercera para desactivarlas. Al establecerse con
`setVariableGlobal`, **solo se escriben si están vacías**: para cambiar de
monitor hay que editar `/etc/environment` a mano.

## Sway

Equivalente de i3 bajo Wayland, con `waybar` como barra. Comparte filosofía de
configuración pero no comparte fichero.

## Xmonad

Requiere la cadena de Haskell. Es el que más dependencias arrastra y el menos
usado del conjunto.

## Openbox

Gestor flotante ligero, pensado para hardware limitado. Se apoya en `tint2`
para el panel y `nitrogen` para el fondo.

## Notas de estado

- El título del menú en `Desktops/0_Main.sh` dice "Menú de Personalización del
  sistema": es un copiar-pegar de `Personalizar/`.
- Ninguno de estos scripts está condicionado por `$DISTRO`, así que en macOS
  no tienen sentido y en SteamOS chocan con el modo juego de Valve.
- Las capturas de i3 y de i3 con doble monitor están en `docs/i3.png` e
  `docs/i3-Dual_Monitor.png`.
