# Configuración de Root (root)

**Resumen**: Este módulo replica ciertas configuraciones esenciales a nivel de usuario, pero aplicándolas estrictamente al entorno del superusuario (`/root`).

---

## Descripción Técnica y Objetivo

El directorio `root/` garantiza que el usuario administrador (`root`) posea las mismas facilidades en la consola que un usuario estándar desarrollador. Dado que en las labores de administración de servidores Linux el uso temporal del usuario root (a través de `su` o sesiones SSH directas en servidores VPS) es común, su entorno debe ser igualmente productivo y seguro.

### Componentes Clave

1. **Terminales para Superusuario (`terminales.sh`)**:
   - Ajusta los shells y perfiles del administrador (`/root/.bashrc`, `/root/.zshrc`).
   - Evita la dependencia y la carga de configuraciones innecesarias, pero retiene atajos de teclado y los `aliases` útiles que asisten en la depuración del servidor.

2. **Editores CLI Privilegiados (`vim.sh`, `nano.sh`)**:
   - Aplica configuraciones en la carpeta `/root/` de forma análoga a la del módulo `Usuario/`. 
   - Modifica `~/.vimrc` y `~/.nanorc` asegurando un resaltado de sintaxis correcto, que es de vital importancia cuando se editan archivos de configuración críticos en `/etc` como root, para evitar errores tipográficos o indentaciones fallidas (típicamente perjudiciales en YAML o configuraciones de demonios).

3. **Restablecimiento de Entorno (`permisos.sh`, `programas-default.sh`)**:
   - Permite sanear rápidamente variables de entorno o la integridad de los directorios de `/root` asegurando que archivos clave como `.ssh/authorized_keys` contengan permisos estrictos (`600`/`700`).
   - Obliga a definir los programas predeterminados (`update-alternatives`) a nivel global, estipulando el editor por defecto (`EDITOR`), lo cual beneficia a herramientas interactivas como `visudo`, `crontab -e` o comandos de git al ejecutarse como root.

### Mecanismo de Ejecución

Debido a que el script de automatización general corre ya sea con un usuario sudoer o directamente como root (mediante `main-vps.sh`), este módulo explícitamente dirige las copias de archivos y generación de symlinks hacia el `HOME` del usuario UID 0 (`/root/`).
