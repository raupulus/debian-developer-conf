set encoding=utf-8

" Muestra el número de línea
set number

" Muestra último comando introducido
set showcmd

" Habilita sintaxis
syntax on
syntax enable

" Esquema de colores
"colorscheme industry
color monokai
colorscheme monokai

" Tabulaciones
set tabstop=4

" Copia la identación de la línea actual a la siguiente línea
set autoindent

" Convertir tabulaciones en espacios
set expandtab
set softtabstop=4

" Identa según el tipo de archivo, carga desde ~/.vim/indent/*
if has("autocmd")
  filetype plugin indent on
endif

" Remarcar línea actual
set cursorline

" Ancho de contenido para escribir, muestra línea
set textwidth=120

" Color de la línea que delimita la columna
set colorcolumn=80

" Ajustar palabras visualmente
set wrap

" Ajustar salto de línea
set linebreak
set textwidth=0
set wrapmargin=0

" Ajustar salto de línea si son largas pero permite mantener algunas
set formatoptions+=l

" Menú grafico para autocompletar comandos
set wildmenu

" Redibujar pantalla solo cuando es necesario, esto aumenta rendimiento en algunos escenarios como macros
set lazyredraw

" Resaltar parejas corchetes, llaves y paréntesis [{()}] al poner el cursor encima
set showmatch

" Desactivo clipboard de vim para copiar en portapapeles del sistema
set clipboard+=unnamed

" Habilito el portapapeles y selección con el ratón
set mouse=a

" Activa crear parejas de corchetes, llaves y paréntesis [{()}] al abrirlas
"let g:AutoPairsFlyMode = 1
"let g:AutoPairsShortcutBackInsert = '<M-b>'

" Buscar a medida que se escribe
set incsearch

" Buscar, resaltar coincidencias
set hlsearch

" Buscar, no distingue mayúsculas/minúsculas
set ignorecase
set ic

" Mapea tecla espacio e intro para dejar de resaltar coincidencias
nnoremap <leader><space> :nohlsearch<CR>
nnoremap <CR> :nohlsearch<cr>

" Habilita pliegues/folding
set foldenable

" Nivel de pliegues/folds
set foldlevelstart=10

" pliegues/Folds anidados
set foldnestmax=10

" Asigno la tecla espacio para abrir/cerrar pliegues/folds
nnoremap <space> za

" Plegar/folding en función a la sintaxis
set foldmethod=syntax

" Movimiento vertical sobre la línea visual, si una línea es larga no parte al bajar
nnoremap j gj
nnoremap k gk

" Selecciona el último bloque que se insertó en el último modo "insert"
nnoremap gV `[v`]

" Permite cambiar el cursor en modo tmux
if exists('$TMUX')
    let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
    let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
    let &t_SI = "\<Esc>]50;CursorShape=1\x7"
    let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif

" Modifico el directorio de archivos temporales para no dejar sucio el directorio de trabajo
set backup
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set backupskip=/tmp/*,/private/tmp/*
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set writebackup

" Función para cambiar entre número y número relativo
function! ToggleNumber()
    if(&relativenumber == 1)
        set norelativenumber
        set number
    else
        set relativenumber
    endif
endfunc

" Elimina los espacios al final del archivo.
function! <SID>StripTrailingWhitespaces()
    " save last search & cursor position
    let _s=@/
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    let @/=_s
    call cursor(l, c)
endfunction

" importa la barra de powerline
python3 from powerline.vim import setup as powerline_setup
python3 powerline_setup()
python3 del powerline_setup

" Powerline, activa la barra (si se quita, la barra desaparece)
set laststatus=2

" <Esc> cambia al modo Normal inmediatamente:
set timeoutlen=250

" Carácteres para indicar/visualizar tipos especiales o invisibles (intro, espacio)
set listchars=tab:▸\ ,trail:•,extends:❯,precedes:❮
set showbreak=↪
set list

" Tratar archivos json como javascript
autocmd BufNewFile,BufRead *.json setf javascript

" Tipos de archivos que deberán usar tabs reales
autocmd FileType {make,gitconfig,apache} set noexpandtab

" Autoidentar al pegar contenido
set paste

" Convertir tabs en espacios
set et|retab
retab

" Destacar syntaxis de python
let python_highlight_all=1

" Prettier, formatea archivos al modificar o guardarlos
let g:prettier#autoformat = 1
let g:prettier#exec_cmd_async = 1
autocmd BufWritePre,InsertLeave *.jsx,*.js,*.json,*.css,*.scss,*.less,*.graphql,*.ts,*.css,*.scss,*.md,*.vue PrettierAsync


" NetRw configuración del explorador de archivo
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 25
augroup ProjectDrawer
  " Abrir automáticamente netrw al abrir el editor
  "autocmd!
  "autocmd VimEnter * :Vexplore
augroup END


" Plugins externos
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'sheerun/vim-polyglot'  " Resaltado de sintaxis para muchos lenguajes
Plugin 'prettier/vim-prettier' " Formatea contenido, principalmente js/css
Plugin 'jiangmiao/auto-pairs' " Cierra parejas [](){}... → No me funciona
Plugin 'tpope/vim-surround' " Cierra parejas de etiquetas <p></p> → No me funciona
Plugin 'airblade/vim-gitgutter' " Añade información sobre líneas git modificadas
Plugin 'tpope/vim-fugitive' " Añade comandos e información de git (Gstatus,Gblame, Gcommit, Gpush... https://github.com/tpope/vim-fugitive)
Plugin 'tpope/vim-vinegar' " Ventana actual :Explore, Horizontal:Sexplore, Vertical :Vexplore
call vundle#end()
