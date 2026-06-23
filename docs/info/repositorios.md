# Repositorios

**Resumen**: Módulo responsable de añadir, actualizar y gestionar repositorios de software. Configura tanto los repositorios oficiales como repositorios extra (de terceros) dependiendo de la distribución sobre la que se esté ejecutando (Debian, Raspbian, Fedora, Gentoo o macOS).

---

## Descripción Técnica y Objetivo

El directorio `Repositorios/` aísla toda la lógica que afecta a la configuración del gestor de paquetes principal del sistema operativo subyacente. Un pilar fundamental del entorno de desarrollo es contar con el software actualizado desde fuentes seguras; este módulo prepara al sistema para poder instalar dependencias modernas.

### Componentes Clave

1. **Scripts Base por Distribución**:
   - `debian.sh`, `raspbian.sh`, `fedora.sh`, `gentoo.sh`, `macos.sh`: La instalación invoca al script correcto leyendo la variable global `$DISTRO`. 
   - **Debian / Raspbian**: Configuran y actualizan `/etc/apt/sources.list` y añaden listas adicionales a `/etc/apt/sources.list.d/`. Gestionan las claves GPG correspondientes a los repositorios importados usando sub-carpetas de estructura propia (como `debian/` y `raspbian/`).

2. **Tipos de Repositorios Añadidos**:
   - **Oficiales y Ramas (Testing/Stable)**: Permite ajustar la rama deseada (aunque el proyecto se orienta a Stable). En el caso de Debian, se asegura de que contrib y non-free estén habilitados.
   - **De Terceros Comunes**: Automatiza la adición de repositorios como NodeSource (para NodeJS), PostgreSQL, Dotdeb (en versiones antiguas), entre otros, evitando que el usuario tenga que lidiar con la descarga manual de claves públicas e inserción de la URL.

3. **Restauración y Limpieza**:
   - Para salvaguardar la integridad, los scripts de este módulo emplean la función `crearBackup` (definida en `functions.sh`) antes de sobrescribir el `sources.list`. Así se protege la instalación en caso de fallo o configuración previa conflictiva.
   - Aplican rutinas `apt-get update` inmediatamente después de actualizar las listas para sincronizar la caché local.

### Mecanismo de Ejecución

El script de menú local `0_Main.sh` provee las opciones al usuario para inyectar todas las listas de repositorios recomendadas o sólo repositorios oficiales. En las instalaciones completamente automatizadas, este módulo suele ser llamado muy temprano en el proceso (`prepararInstalador`) para asegurar que todo software posterior se descargue sin problemas.
