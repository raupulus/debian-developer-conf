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
<h1>Gestores de contenido</h1>

<?php
function generarTabla($dir, $carpeta)
{
    $tabla = '';
    while(($archivo = readdir($dir)) !== false) {
        if($archivo != '.' && $archivo != '..' && $archivo != '.htaccess') {
            $tabla = $tabla.'<tr><td><a href="'
                .$carpeta.'/'.$archivo.'">'.$archivo.'</a></td></t>';
        }
    }
    return $tabla;
}

function listar_archivos($carpeta)
{
    if ((is_dir($carpeta)) && ($dir = opendir($carpeta))) {
        return generarTabla($dir, $carpeta);
        closedir($dir);
    } else {
        return false;
    }
}
?>

<table>
    <?= listar_archivos('.')  ?>
</table>
</body>
</html>
