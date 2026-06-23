# Raspberry Pi (Raspberry)

**Resumen**: Un módulo con configuraciones altamente específicas para optimizar el desgaste de almacenamiento y el rendimiento de las placas base Raspberry Pi corriendo Raspbian (Debian adaptado). Incluye clonado de repositorios auxiliares y ajustes de sistemas de ficheros en memoria (RAM filesystem).

---

## Descripción Técnica y Objetivo

El directorio `raspberry/` está destinado a solventar las particularidades y deficiencias inherentes del hardware Raspberry Pi. Principalmente, como estas placas utilizan habitualmente memorias MicroSD para el almacenamiento principal, sufren de un límite finito de ciclos de escritura/lectura mucho más corto que un SSD tradicional, por lo que el objetivo principal es reducir las escrituras y preparar el entorno de domótica o servicios.

### Componentes Clave

1. **Sistemas de Archivos en Memoria (RAMFS) (`add-ram-filesystem.sh`)**:
   - Modifica el archivo `/etc/fstab` del sistema para montar directorios de alta escritura y desgaste (como `/tmp`, `/var/log` y `/var/tmp`) directamente en la memoria RAM del dispositivo (`tmpfs`).
   - Al guardar los logs temporales y ficheros de sesión en RAM, se incrementa drásticamente la vida útil de la tarjeta de memoria SD. Al apagar la placa estos datos se pierden, por lo que el script evalúa el impacto a la hora de preservar registros persistentes frente a durabilidad del dispositivo.

2. **Preparación de Directorios y Estructuras (`prepare-directories.sh`)**:
   - Genera directorios específicos que comúnmente son requeridos para proyectos de IoT, servidores multimedia y scripts crons persistentes de la placa (independientes del entorno del `$HOME`).

3. **Software Extra de Sensores o Red (`piaware.sh`)**:
   - Incluye instalaciones de software de tracking aéreo o domótica muy usado en Raspberry Pi (ej. PiAware para decodificación ADS-B), agilizando el proceso de set-up manual que a menudo requiere compilación.

4. **Repositorios Auxiliares (`clone-extra-repositories.sh`)**:
   - Clona de manera automatizada otras utilidades, dependencias desde Github que son rutinariamente utilizadas por la comunidad de Raspberry, depositándolas de forma centralizada en una estructura bajo `/opt/` o la capeta de utilidades del usuario.

### Mecanismo de Ejecución

Es el menú principal exclusivo de Raspberry (`0_Main.sh`) el que permite disparar estos scripts de forma controlada. A diferencia del entorno de servidor o escritorio, muchas de estas configuraciones exigen reinicio inminente (reboot) para que los puntos de montaje de `fstab` cambien sus descriptores de `/var` a memoria RAM exitosamente sin causar fallos en los logs de los daemons en tiempo de ejecución.
