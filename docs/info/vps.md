# Servidor Privado Virtual (VPS)

**Resumen**: Este módulo provee automatizaciones orientadas puramente a máquinas y contenedores de tipo servidor de cara a la red pública (Virtual Private Servers u hosts dedicados). Su foco es elevar la postura de seguridad y gestionar el aprovisionamiento inicial.

---

## Descripción Técnica y Objetivo

El directorio `VPS/` actúa como un orquestador para entornos Headless (sin interfaz gráfica) conectados directamente a internet. Cuando este proyecto se despliega usando `main-vps.sh` (a menudo corriendo inmediatamente después del aprovisionamiento en la nube), entra en juego este módulo para mitigar riesgos (bloquear bots, restringir puertos) y aislar el usuario root.

### Componentes Clave

1. **Cortafuegos (Firewall) Avanzado (`firewall.sh`)**:
   - Descarga e instala `UFW` (Uncomplicated Firewall).
   - Genera políticas de denegación predeterminada (Default Deny) en el tráfico entrante.
   - Aplica filtros permitiendo únicamente puertos esenciales (SSH `22`, HTTP `80`, HTTPS `443` y en algunos casos puertos de bases de datos o servicios como el `3306` si se requiere externamente).

2. **Mitigación de Intrusiones (`fail2ban.sh`)**:
   - Instala y configura `fail2ban`.
   - Crea archivos de configuración locales (`jail.local`) aislando las definiciones de los archivos maestros de la distribución para prevenir sobreescrituras en actualizaciones del sistema.
   - Habilita las jaulas (jails) de SSH, reduciendo drásticamente las probabilidades de intrusiones mediante ataques de diccionario y fuerza bruta.

3. **Gestión de Administradores (`administrator.sh`, `user_admin.sh`)**:
   - **Hardening de usuarios**: Frecuentemente los VPS entregan acceso vía el usuario `root`. Estos scripts se encargan de aprovisionar un usuario sin privilegios con sudoers configurado adecuadamente (ej. grupo `sudo` o `wheel`).
   - Bloquean o restringen el login directo de `root` vía SSH (editando el archivo `/etc/ssh/sshd_config` y configurando `PermitRootLogin no`), forzando así a los desarrolladores a escalar privilegios a través del usuario previamente creado, una de las capas de defensa en profundidad más habituales en la nube.

4. **Regionalización (`internationalization_and_timezone.sh`)**:
   - Fija la codificación de caracteres a `UTF-8` y asegura que el huso horario (Timezone) se estandarice preferentemente a `UTC`, una práctica mandatoria en despliegues distribuidos que previene problemas en los logs, las tareas programadas (crons) y bases de datos.

### Mecanismo de Ejecución

Es usual que estos scripts sean invocados de manera desatendida. Altera archivos profundos de la distribución, reescribiendo configuraciones en `/etc/` utilizando `sed` en vez de intervención directa de texto. Luego invoca reinicios de daemons (ej. `sudo systemctl reload sshd` o `ufw reload`) validando la nueva seguridad instaurada.
