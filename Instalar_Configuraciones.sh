#!/bin/bash
# -*- ENCODING: UTF-8 -*-
#######################################
# ###     Raúl Caro Pastorino     ### #
## ##                             ## ##
### # https://github.com/fryntiz/ # ###
## ##                             ## ##
# ###       www.fryntiz.es        ### #
#######################################

############################
##   Constantes Colores   ##
############################
amarillo="\033[1;33m"
azul="\033[1;34m"
blanco="\033[1;37m"
cyan="\033[1;36m"
gris="\033[0;37m"
magenta="\033[1;35m"
rojo="\033[1;31m"
verde="\033[1;32m"

#############################
##   Variables Generales   ##
#############################

#Instala el script de OhMyZSH
function ohMyZSH() {
	#echo -e "$verde Descargando OhMyZSH$gris"
	#curl -L http://install.ohmyz.sh | sh
}

function configurar_vim() {
	DIR_ACTUAL=$(echo $PWD)
	echo -e "$verde Configurando VIM"

	#Instalar Gestor de Plugins Vundle
	echo -e "$verde Instalando gestor de plugins$rojo Vundle$gris" && sleep 2
	if [ -f ~/.vim/bundle/Vundle.vim ]
	then #Si existe solo actualiza plugins
		echo | vim +PluginInstall +qall
	else #Instala plugins dentro de ~/.vimrc #Se intenta 3 veces
		for (i=0;i<3;i++)
		do
			git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
			echo | vim +PluginInstall +qall && break;
		done
	fi

	#funcion para instalar todos los plugins
	function vim_plugins() {
		plugins_vim="powerline,youcompleteme,xmledit,autopep8,python-jedi,python-indent"
		for plugin in $plugins_vim
		do
			echo -e "Activando el plugin  → $rojo $plugin$yellow" && sleep 2
			vim-addon-manager install $plugin
		done
		echo -e "$verde Todos los plugins activados$gris"
	}

	function vim_colores() {
		mkdir -p ~/.vim/colors 2>> /dev/null
		#Creando archivos de colores, por defecto usara "monokai"
		echo -e "$verde Descargando colores para sintaxis$amarillo"
		if [ ! -f "~/.vim/colors/wombat.vim" ]
		then
			wget http://www.vim.org/scripts/download_script.php?src_id=6657 -O ~/.vim/colors/wombat.vim
		fi

		if [ ! -f "~/.vim/colors/monokai.vim" ]
		then
			wget https://raw.githubusercontent.com/lsdr/monokai/master/colors/monokai.vim -O ~/.vim/colors/monokai.vim
		fi
		echo -e "$verde Se ha concluido la instalacion de temas de colores$gris"
	}

	vim_plugins
	vim_colores

	#git clone https://github.com/Valloric/YouCompleteMe ~/.vim/bundle/YouCompleteMe
	#cd ~/.vim/bundle/YouCompleteMe
	#git submodule update --init --recursive
	#./install.py --clang-completer --gocode-completer

	cd $DIR_ACTUAL
}

#Agregar Archivos de configuración al home
function agregar_conf_home() {
  	conf=$(ls -A ./home/)
	echo -e "$verde Preparando para añadir archivos de configuración en el home de usuario$gris"
	for c in $conf
	do
		if [ -f ~/$c ] || [ -d ~/$c ] #Si existe hago backup
		then
			if [ -f "~/$c.BACKUP" ] || [ -f "~/$c.BACKUP" ] #Contemplo que exista copia y no la borra
			then
				rm ~/$c 2>> /dev/null
			else
				echo -e "$verde Creando backup de ~/home/$(whoami)/$c $gris"
				mv ~/$c ~/$c.BACKUP 2>> /dev/null
			fi
		fi
		echo -e "$verde Generando configuración$gris"
		cp -r ./home/$c ~/$c 2>> /dev/null
	done
}

#Permisos
function permisos() {
    #TODO --> Quitar permios para atom como superusuario
	echo -e "$verde Estableciendo permisos en el sistema$gris"
}

#Establecer programas por defecto
function programas_default() {
	echo -e "$verde Estableciendo programas por defecto$gris"
	#sudo update-alternatives --set x-terminal-emulator /usr/bin/tilix
}

#Elegir intérprete de comandos
function terminal() {
  while true
  do
  	echo -e "$verde 1) bash$gris"
	echo -e "$verde 2) zsh$gris"
  	read -p "Introduce el terminal → bash/zsh: " term
  	case $term in
		bash || 1)#Establecer bash como terminal
			chsh -s /bin/bash
			break;;
		zsh || 2)#Establecer zsh como terminal
			chsh -s /bin/zsh
			break;;
		*)#Opción errónea
			echo -e "$rojo Opción no válida$gris"
	esac
  done
}

#Instalar Todas las configuraciones
function instalar_configuraciones() {
  	agregar_conf_home
	ohMyZSH
	permisos
	programas_default
	terminal #Pregunta el terminal a usar
	configurar_vim
}
