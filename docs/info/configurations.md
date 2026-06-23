# Configuraciones (Configurations)

**Resumen**: Este módulo administra y aplica configuraciones transversales y ajustes globales al sistema operativo. Modifica comportamientos por defecto del núcleo y los demonios esenciales mediante scripts genéricos, crons y alteraciones de red (archivos hosts).

---

## Descripción Técnica y Objetivo

El directorio `configurations/` está diseñado para establecer una base homogénea y optimizada en la máquina destino independientemente del software y repositorios que se vayan a instalar después. Afecta directamente al sistema base (como reglas `/etc/hosts` o tareas automatizadas del sistema).

### Componentes Clave

1. **Gestión del Archivo Hosts (`hosts.sh`)**:
   - Descarga listas consolidadas y recomendadas de `hosts` (como listas orientadas a bloqueo de telemetría o malware) y las fusiona de forma segura dentro de `/etc/hosts`. 
   - Preserva siempre la estructura base del sistema (la definición de `127.0.0.1 localhost` y las configuraciones de loopback IPV6) asegurando que el equipo y sus servidores en desarrollo sigan funcionando localmente.

2. **Crontabs y Tareas Programadas (`crons.sh`)**:
   - Automatiza tareas de mantenimiento instalando archivos directamente en los directorios administrados por cron (`/etc/cron.d`, `/etc/cron.daily`, etc.).
   - Generalmente se encargan de rotación de logs especiales o actualizaciones desatendidas preconfiguradas que evitan que el desarrollador tenga que realizar limpiezas a mano.

3. **Scripts Base del Sistema (`scripts.sh` y `generic.sh`)**:
   - Traslada scripts utilitarios al path del sistema (típicamente `/bin` o `/usr/local/bin`) utilizando funciones como `addScriptToBin` para hacerlos globalmente ejecutables por cualquier usuario.
   - Estos scripts a menudo abarcan alias complejos, lanzadores de entornos y herramientas exclusivas del flujo de desarrollo definidas en el directorio maestro `conf/bin/`.

### Mecanismo de Ejecución

Cuando el usuario selecciona la opción correspondiente en `0_Main.sh`, el script delega los cambios requiriendo privilegios `sudo`. A diferencia de las configuraciones en el entorno del usuario (aisladas en el `$HOME`), las operaciones aquí impactan globalmente, por lo cual es una fase crítica del script inicial que estandariza el comportamiento general de la distribución.
