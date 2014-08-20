set nocompatible              " be iMproved, required
filetype off                  " required

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/Vundle.vim'
Plugin 'itchyny/lightline.vim'
"Plugin 'Valloric/YouCompleteMe'
Plugin 'jordwalke/flatlandia'
Plugin 'Yggdroot/indentLine'
Plugin 'xterm-color-table.vim'
"Plugin 'shellsea'
"Plugin 'vincent'
"Plugin 'https://github.com/othree/javascript-libraries-syntax.vim.git'
Plugin 'SyntaxComplete'
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'
Bundle 'https://github.com/Raimondi/delimitMate.git'
Bundle 'jeffkreeftmeijer/vim-numbertoggle'
call vundle#end() 
filetype plugin indent on

syntax enable
"set clipboard+=unnamed	" yank to the system register (*) by default
set expandtab        	"replace <TAB> with spaces
set softtabstop=3 
set shiftwidth=3 
let mapleader=" "
set fillchars=""
set guioptions-=m                       " remove menubar
set guioptions-=T                       " remove toolbar
set guioptions-=r                       " remove right scrollbar

" ,p toggles paste mode
nmap <leader>p :set paste!<BAR>set paste?<CR> 
" disable syntax on large line
" disable cursorline (default: nocursorline)
set synmaxcol=128
set nocursorline "
set number
set backspace=2 " make backspace work like most other apps
colors flatlandia
"colors vincent
hi Normal ctermfg=252 ctermbg=none " remove ugly background with picture
set guifont=Monaco:h14

set cursorline
set cursorcolumn
hi CursorLine term=bold cterm=bold guibg=Grey40

"Restore cursor to file position in previous editing session
set viminfo='10,\"100,:20,%,n~/.viminfo
au BufReadPost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm'\"")|else|exe "norm $"|endif|endif


" ---------------------
"  lightline setup
" ---------------------
let g:lightline = {
      \ 'colorscheme': 'default',
      \ 'component': {
      \ 'readonly': '%{&readonly?"⭤":""}',
      \ },
      \ 'separator': { 'left': '⮀', 'right': '⮂' },
      \ 'subseparator': { 'left': '⮁', 'right': '⮃' }
      \ }
set laststatus=2

" ---------------------
"  YouCompleteMe setup
" ---------------------
let g:ycm_min_num_of_chars_for_completion = 2


let g:indentLine_char = '│'
let g:indentLine_color_term = 0

" ---------------------
"  SyntaxComplete setup
" ---------------------

if has("autocmd") && exists("+omnifunc")
     autocmd Filetype *
         \ if &omnifunc == "" |
         \    setlocal omnifunc=syntaxcomplete#Complete |
         \ endif
endif

" Line Number
" --------------------------------------------
let g:NumberToggleTrigger="<F3>"
