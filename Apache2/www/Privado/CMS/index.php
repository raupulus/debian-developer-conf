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
