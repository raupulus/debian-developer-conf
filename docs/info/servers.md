# Servidores (Servers)

**Resumen**: Este módulo despliega un completo abanico de servidores locales y demonios útiles para desarrollo y producción, automatizando la instalación y la parametrización de servicios como Apache, MariaDB, Docker, PostgreSQL, entre otros.

---

## Descripción Técnica y Objetivo

El directorio `servers/` se focaliza en el backend y la infraestructura. Es capaz de proveer y dejar listos para usar servidores web, bases de datos y contenedores. Al integrarlo, el equipo final queda preparado para desarrollo full-stack o despliegue inmediato.

### Componentes Clave

1. **Servidores Web y Proxy**:
   - `apache2/` y sub-scripts: Instalan el servidor y habilitan módulos típicos de reescritura. Permiten la configuración automática de Virtual Hosts (como directorios `Publico` y `Privado` en `/var/www/html` con protección `.htpasswd`). Depende mucho del script de rutas `routes.sh` para encontrar la carpeta `sites-available` adecuada a la distro.
   - `nginx.sh`: Provee la alternativa ligera a Apache, con configuraciones base y establecimiento de reglas proxy si se requiere en los `server_blocks`.

2. **Bases de Datos**:
   - `mariaDB.sh`: Configura MariaDB con scripts automatizados. Si se decide, despliega también phpMyAdmin y automatiza la creación de un usuario `dev` con contraseña `dev` y permisos plenos para agilizar el inicio del desarrollo (práctica indicada solo para entornos controlados/locales).
   - `postgreSQL.sh`: Instala la base de datos y herramientas de integración; modifica la zona horaria a 'UTC' por defecto en el clúster.
   - `sqlite.sh` y `mongodb.sh`: Ofrecen configuraciones de cero-configuración y motores NoSQL, respectivamente.

3. **Plataformas de Contenedores e Integración (`docker.sh`, `gocd.sh`)**:
   - Descarga, instala dependencias (ej. `apt-transport-https`), añade los repositorios docker (oficiales de Docker Inc.) al gestor de paquetes de la distribución (basándose en `$DISTRO`) y agrega el usuario actual al grupo `docker` para evitar invocar operaciones docker con privilegios `sudo`.
   - Incluye GoCD para orquestación de integración y despliegue continuo (CI/CD) local o de desarrollo.

4. **Herramientas Adicionales y Demonios de Red**:
   - `bind.sh` automatiza un servidor DNS interno para resolver nombres `.local` en las máquinas de desarrollo.
   - `ssh.sh`, `postfix.sh`, `mumble.sh` aseguran servidores base para conectividad, emulación de correos y VoIP si fuera necesario.

### Mecanismo de Ejecución

Cada script individual detiene o reinicia servicios a demanda (empleando las utilidades base como `reiniciarServicio`) para que las configuraciones de los demonios recarguen instantáneamente tras la instalación, de forma que el servidor esté listo (listening en su puerto predeterminado) justo al terminar el proceso de scripting.
