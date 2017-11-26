<!DOCTYPE html>
<?php
/**
 * @author Raúl Caro Pastorino
 * @copyright Copyright © 2017 Raúl Caro Pastorino
 * @license https://www.gnu.org/licenses/gpl-3.0-standalone.html
 */
?>
<html lang="es">
    <head>
        <meta charset="utf-8">
        <title>Gestores de contenido</title>
        <meta name="description" content="Gestores de contenido"/>
        <meta name="keywords" content="programa, script, php, programación, Raúl Caro Pastorino, Fryntiz"/>
        <meta name="author" content="Raúl Caro Pastorino"/>
    </head>
    <body>
        <?php
        function listar_archivos($carpeta){
            if(is_dir($carpeta)){
                if($dir = opendir($carpeta)){
                    while(($archivo = readdir($dir)) !== false){
                        if($archivo != '.' && $archivo != '..' && $archivo != '.htaccess'){
                            echo '<TR><TD><a target="_blank" href="'.$carpeta.'/'.$archivo.'">'.$archivo.'</a></TD></TR>';
                        }
                    }
                    closedir($dir);
                }
            }
        }
        ?>
    </body>
</html>
