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
   - Instala intérpretes de Python (contemplando la coexistencia de `python2` y `python3`).
   - Setea e instala el gestor de paquetes (`pip` y `pip3`) habilitando también instalaciones globales si corresponde (gracias a métodos envoltorio como `python3Install` en la librería base).

3. **NodeJS y Ecosistema JavaScript**:
   - (El componente NodeJS tiene fuertes enlaces cruzados con el script de servidor `servers/nodejs.sh` y repositorios), en este módulo recae la responsabilidad de instalar utilidades globales usando NPM (como linters tipo `eslint`, `stylelint` o preprocesadores como `compass`).

4. **Lenguajes Compilados y Secundarios**:
   - `c.sh`, `go.sh`, `ruby.sh`, `perl.sh`, `android.sh`: Instalan colecciones de compiladores como GCC/Clang, entornos de Go (GOPATH), Ruby (junto a gems) y herramientas SDK para Android.

### Mecanismo de Ejecución

Al escoger un lenguaje en el menú principal (`0_Main.sh`), el script determina las dependencias, utiliza el gestor del sistema para volcar los paquetes binarios y, tras ello, ejecuta comandos envolventes como `sed` para adaptar las variables de desarrollo directamente en los archivos `/etc/` sin abrir editores de texto interactivos, agilizando todo el proceso de onboarding del programador.
