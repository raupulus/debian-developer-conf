set nocompatible
filetype off
syntax on
set expandtab
set tabstop=4
retab
set shiftwidth=4
set hlsearch
set paste
set ic
color monokai
colorscheme monokai
set number
set laststatus=2
set encoding=utf-8
filetype plugin indent on
set fdm=syntax
set foldlevelstart=20

let python_highlight_all=1
let NERDTreeIgnore=['\.pyc$', '\~$'] "ignore files in NERDTree

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'jistr/vim-nerdtree-tabs'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'scrooloose/syntastic'
Plugin 'nvie/vim-flake8'
Plugin 'jnurmine/Zenburn'
Plugin 'altercation/vim-colors-solarized'
Plugin 'seebi/dircolors-solarized'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'christoomey/vim-tmux-navigator'
Plugin 'kien/ctrlp.vim'
Plugin 'jiangmiao/auto-pairs'
Plugin 'Lokaltog/vim-easymotion'
Plugin 'scrooloose/nerdtree'
Plugin 'xolox/vim-session'
Plugin 'xolox/vim-misc'
Plugin 'majutsushi/tagbar'
Plugin 'airblade/vim-gitgutter'
Plugin 'vim-ruby/vim-ruby'
Plugin 'tpope/vim-endwise'
Plugin 'xolox/vim-easytags'
Plugin 'tomasr/molokai'
Plugin 'vimoutliner/vimoutliner'
Plugin 'lifepillar/pgsql.vim'
Plugin 'ivalkeen/vim-simpledb'
Plugin 'von-forks/vim-bracketed-paste'
call vundle#end()

set showcmd                     " display incomplete commands

set foldlevelstart=20           " se empieza con todos los pliegues desplegados

" Whitespace
set tabstop=4 shiftwidth=4      " a tab is two spaces (or set this to 4)
set expandtab                   " use spaces, not tabs (optional)

" Joining lines
if v:version > 703 || v:version == 703 && has("patch541")
  set formatoptions+=j          " Delete comment char when joining commented lines
endif
set nojoinspaces                " Use only 1 space after "." when joining lines, not 2

" Indicator chars
set listchars=tab:▸\ ,trail:•,extends:❯,precedes:❮
set showbreak=↪
set list

" Avoid showing trailing whitespace when in insert mode
autocmd InsertEnter * :set listchars-=trail:•
autocmd InsertLeave * :set listchars+=trail:•

" Searching
set hlsearch                    " highlight matches
set incsearch                   " incremental searching
set ignorecase                  " searches are case insensitive...
set smartcase                   " ... unless they contain at least one capital letter

set wrap
set linebreak
set nolist
set wrapmargin=0
set textwidth=0
set colorcolumn=80
set autoindent
set smarttab
set scrolloff=3

" <Esc> pasa a modo Normal inmediatamente:
set timeoutlen=250

" make Python follow PEP8 ( http://www.python.org/dev/peps/pep-0008/ )
autocmd FileType python setl softtabstop=4 tabstop=4 shiftwidth=4 textwidth=79

" Treat JSON files like JavaScript
autocmd BufNewFile,BufRead *.json setf javascript

" Some file types use real tabs
autocmd FileType {make,gitconfig,apache} set noexpandtab

" clear the search buffer when hitting return
nnoremap <CR> :nohlsearch<cr>

" toggle the current fold
nnoremap <Space> za

command! KillWhitespace :normal :%s/ *$//g<cr><c-o><cr>

" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = ","
let g:mapleader = ","

" NOTICE: Really useful!

" In visual mode when you press * or # to search for the current selection
vnoremap <silent> * :call VisualSelection('f')<CR>
vnoremap <silent> # :call VisualSelection('b')<CR>

" When you press gv you vimgrep after the selected text
vnoremap <silent> gv :call VisualSelection('gv')<CR>

" Some useful keys for vimgrep
map <leader>g :vimgrep // **/*.<left><left><left><left><left><left><left>
map <leader><space> :vimgrep // <C-R>%<C-A><right><right><right><right><right><right><right><right><right>

" When you press <leader>r you can search and replace the selected text
vnoremap <silent> <leader>r :call VisualSelection('replace')<CR>

" Bash like keys for the command line
cnoremap <C-A>        <Home>
cnoremap <C-E>        <End>
cnoremap <C-K>        <C-U>

cnoremap <C-P> <Up>
cnoremap <C-N> <Down>

" Tab navigation
nnoremap th  :tabfirst<CR>
nnoremap tj  :tabnext<CR>
nnoremap tk  :tabprev<CR>
nnoremap tl  :tablast<CR>
nnoremap tt  :tabedit<Space>
"nnoremap tn  :tabnext<Space>
nnoremap tm  :tabm<Space>
nnoremap tx  :tabclose<CR>
" Alternatively use
"nnoremap th :tabnext<CR>
"nnoremap tl :tabprev<CR>
nnoremap tn :tabnew<CR>

" Navigation using Alt-num on console
nnoremap <Esc>1 1gt
nnoremap <Esc>2 2gt
nnoremap <Esc>3 3gt
nnoremap <Esc>4 4gt
nnoremap <Esc>5 5gt
nnoremap <Esc>6 6gt
nnoremap <Esc>7 7gt
nnoremap <Esc>8 8gt
nnoremap <Esc>9 9gt
nnoremap <Esc>0 10gt

" Navigation using Alt-num on GUI
nnoremap <A-1> 1gt
nnoremap <A-2> 2gt
nnoremap <A-3> 3gt
nnoremap <A-4> 4gt
nnoremap <A-5> 5gt
nnoremap <A-6> 6gt
nnoremap <A-7> 7gt
nnoremap <A-8> 8gt
nnoremap <A-9> 9gt
nnoremap <A-0> 10gt

" Press F12 to switch to cp850 encoding
nnoremap <F12> :e ++enc=cp850<CR>

let g:session_autosave = 'yes'
let g:session_autoload = 'yes'

" Make YCM compatible with UltiSnips
let g:ycm_key_list_select_completion = ['<s-tab>', '<Down>', '<C-j>']
let g:ycm_key_list_previous_completion = ['<c-tab>', '<Up>', '<C-k>']

" Better key bindings for UltiSnipsExpandTrigger
let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"
let g:UltiSnipsListSnippets = "<c-l>"

" Open TagBar
nmap <F8> :TagbarToggle<CR>

let g:sql_type_default = 'pgsql'
