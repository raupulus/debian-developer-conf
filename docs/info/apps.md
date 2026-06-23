# Aplicaciones (Apps)

**Resumen**: Este módulo se encarga de la automatización e instalación de aplicaciones generales y específicas del sistema (IDEs, herramientas ofimáticas, navegadores y otras utilidades), ofreciendo soporte tanto para gestores de paquetes tradicionales (como `apt` o `dnf`) como para tecnologías de contenedores (como `flatpak`).

---

## Descripción Técnica y Objetivo

El directorio `Apps/` agrupa todos los scripts orientados a la instalación de software a nivel de sistema. Su propósito principal es permitir a los desarrolladores y usuarios disponer de sus herramientas cotidianas (navegadores web, IDEs, software de ofimática, edición de gráficos, etc.) con una simple ejecución de un script.

### Componentes Clave

1. **Gestión de Instalación Mixta**: 
   - Utiliza las funciones globales `instalarSoftware` o `instalarSoftwareLista` para el software disponible en los repositorios oficiales de la distribución.
   - Cuenta con scripts especializados como `flatpak.sh` para la adopción y soporte de aplicaciones aisladas, usando la función `instalarSoftwareFlatPak`.

2. **Categorización por Ficheros**:
   - `1_Aplicaciones_Basicas.sh`, `2_Aplicaciones_Extras.sh`, etc., agrupan la instalación por niveles de necesidad.
   - Existen archivos temáticos como `ofimatica.sh`, `juegos.sh`, `grafico.sh`, `internet.sh`, `pentesting.sh`, `video.sh` y `sonido.sh`. Cada uno de estos scripts es invocable de forma independiente o desde el menú principal del módulo (`0_Main.sh`).

3. **Software Especializado y Scripts Propios**:
   - Para aplicaciones que requieren métodos de instalación complejos (descarga de tarballs, scripts bash externos, configuraciones en `/opt` y enlaces en `/usr/bin`), existen scripts con el nombre de la aplicación. Por ejemplo, `Firefox.sh` gestiona la instalación de las ediciones Developer (Quantum) y Nightly, mientras que `GitKraken.sh`, `Haroopad.sh`, `DBeaver.sh` configuran sus respectivos binarios y accesos directos `.desktop`.
   - El subdirectorio `IDEs/` contiene la configuración específica para editores y entornos de desarrollo integrados que a menudo requieren pasos de integración adicionales.

### Mecanismo de Ejecución

El script `0_Main.sh` de este módulo despliega un menú interactivo invocando a la función `opciones()` de la librería base (`functions.sh`). Cuando el usuario selecciona una categoría, se evalúan las dependencias, y luego se hace un source o bash del script correspondiente, que a su vez llama a la instalación automatizada (con la bandera `DEBIAN_FRONTEND=noninteractive` para instalaciones APT, logrando un proceso transparente y sin bloqueos).
