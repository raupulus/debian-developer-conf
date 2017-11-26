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
        <title>Servidor WEB Apache2 en localhost</title>
        <meta name="description" content="Servidor WEB Apache2 en localhost"/>
        <meta name="keywords" content="programa, script, php, programación, Raúl Caro Pastorino, Fryntiz"/>
        <meta name="author" content="Raúl Caro Pastorino"/>
        <link rel="shortcut icon" href="./favicon.ico"/>
        <link rel="shortcut icon" href="./favicon.png"/>
        <link rel="stylesheet" href="./styles.css"/>
        <script src="./scripts.js"></script>
    </head>

    <body>
        <div id="cajatitulo">
            <h1 id="titulo">Servidor WEB Apache2 en localhost</h1>
            <h2 id="subtitulo">Elige a que lugar del servidor acceder</h2>
        </div>

<?php
    if ($_SERVER['SERVER_ADDR'] == '::1') {
        $direccion = 'localhost';
    } else {
        $direccion = $_SERVER['SERVER_ADDR'] ?? 'localhost';
    }
?>

        <div id="cajacontenido">
            <ul>
                <li>
                    <a href="
                    <?= 'http://'.$direccion.'/Publico'; ?>"
                     title="Sitio Público">
                        Sitio Público
                    </a>
                 </li>

                 <li>
                    <a href="
                    <?= 'http://'.$direccion.'/Privado'; ?>"
                    title="Sitio Privado">
                        Sitio Privado
                    </a>
                </li>
            </ul>
        </div>


        <div id="cajafooter">
            <footer>
                <p id="autor">
                    Raúl Caro Pastorino
                </p>

                <p id="licencia">
                    Proyecto bajo licencia <a href="https://www.gnu.org/licenses/gpl-3.0-standalone.html" title="Licencia GPLv3" target="_blank">GPLv3</a>
                    <br />
                    Licencia libre con reconocimiento de autoría y proyectos derivados bajo las mismas condiciones
                </p>

                <p id="repositorios">
                    <a href="https://github.com/fryntiz" title="Repositorios Oficiales de Raúl Caro Pastorino" target="_blank">Repositorios en GitHub Oficial del desarrollador</a>
                </p>

                <p id="fecha">
                    <?=date('d-m-Y H:i');?>
                </p>
            </footer>
        </div>
    </body>
</html>
