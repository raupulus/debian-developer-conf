# Documentación

## Estructura

| Ruta | Contenido | ¿En git? |
|---|---|---|
| [`info/`](info/) | Documentación técnica del estado **actual** del proyecto | Sí |
| `planning/` | Planificación, plan de refactorización y backlog | **No** (`.gitignore`) |
| `*.png`, `*.jpg` | Capturas usadas por el `README.md` de la raíz | Sí |

El punto de entrada a la documentación técnica es
[`info/indice.md`](info/indice.md).

## Documentos destacados

- [`info/sistemas-objetivo.md`](info/sistemas-objetivo.md) — matriz de sistemas
  soportados y variante VPS. Es el documento de referencia para decidir dónde
  debe funcionar cada cosa.
- [`info/arquitectura.md`](info/arquitectura.md) — puntos de entrada y orden de
  carga.
- [`info/functions.md`](info/functions.md) — API de `functions.sh`.
- [`info/auditoria-estado.md`](info/auditoria-estado.md) — qué está roto, qué
  está desfasado y qué funciona tal cual.
- [`info/riesgos.md`](info/riesgos.md) — riesgos de diseño y problemas
  potenciales.

## Capturas

| Fichero | Muestra |
|---|---|
| `Preview.jpg` | Vista general del script |
| `Apps.jpg` | Menú de aplicaciones |
| `IDEs.png` | Menú de IDEs |
| `Servidores.png` | Menú de servidores |
| `Lenguajes.png` | Menú de lenguajes de programación |
| `Personalización.png` | Menú de personalización |
| `i3.png` | i3 configurado |
| `i3-Dual_Monitor.png` | i3 con dos monitores |

## Convención

`docs/info/` describe **lo que hay**, no lo que se pretende. Las intenciones y
los planes van a `docs/planning/`. Cuando se modifique código, la documentación
correspondiente se actualiza en el mismo commit.
