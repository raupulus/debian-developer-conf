# Lenguajes de Programación (Lenguajes-Programacion)

**Resumen**: Módulo destinado a la instalación y configuración completa de lenguajes de programación, sus intérpretes, compiladores y gestores de paquetes asociados (Composer, Pip, Npm, etc.).

---

## Descripción Técnica y Objetivo

El directorio `Lenguajes-Programacion/` gestiona el núcleo de las herramientas de compilación y ejecución de código. El objetivo principal es descargar las dependencias, instalar la versión principal en uso (o habilitar el uso de múltiples versiones como suele hacerse con Python o PHP), y desplegar sus ecosistemas paralelos (librerías, frameworks y gestores de paquetes).

### Componentes Clave

1. **Gestión Detallada de PHP (`php.sh`)**:
   - Automatiza la instalación de las distintas versiones estables y oficiales (o del repositorio dotdeb/sury dependiendo de la distro y antigüedad). 
   - Modifica globalmente los archivos de configuración (`php.ini`) en todas las ubicaciones (`/etc/php/*/cli`, `/etc/php/*/apache2`) fijando límites y configuraciones de desarrollo (ej. `error_reporting = E_ALL`, `display_errors = On`, `memory_limit = 128M`).
   - Instala herramientas satelitales (como Xdebug, Composer, Psysh).

2. **Python (`python.sh`)**:
   - Instala intérpretes de Python y el gestor `pip3`, con instalaciones globales cuando corresponde mediante los envoltorios `python3Install` y `python3InstallGlobal` de la librería base.
   - **Estado**: la coexistencia con Python 2 ya no es real. `python2Install` sigue existiendo en `functions.sh` pero su línea `pip2 install` está comentada: la función solo imprime mensajes. Python 2 lleva años EOL.
   - `python3Install` usa `--break-system-packages`, necesario desde PEP 668 en Debian, pero elude la protección del sistema. Conviene revisarlo en la fase 2.

3. **NodeJS y Ecosistema JavaScript**:
   - **NodeJS no se instala desde este módulo**: vive en `servers/nodejs.sh` y no aparece en el menú de lenguajes. Es una incoherencia de organización heredada.
   - Lo que sí ofrece la librería base son los envoltorios `instalarNpm` e `instalarNpmGlobal`, usados para utilidades globales (`eslint`, `stylelint`, `compass`).

4. **Lenguajes Compilados y Secundarios**:
   - `c.sh`, `go.sh`, `ruby.sh`, `perl.sh`, `android.sh`: Instalan colecciones de compiladores como GCC/Clang, entornos de Go (GOPATH), Ruby (junto a gems) y herramientas SDK para Android.

### Mecanismo de Ejecución

Al escoger un lenguaje en el menú principal (`0_Main.sh`), el script determina las dependencias, utiliza el gestor del sistema para volcar los paquetes binarios y, tras ello, ejecuta comandos envolventes como `sed` para adaptar las variables de desarrollo directamente en los archivos `/etc/` sin abrir editores de texto interactivos, agilizando todo el proceso de onboarding del programador.
