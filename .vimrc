set nocompatible              " be iMproved, required
filetype off                  " required

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/Vundle.vim'
Plugin 'itchyny/lightline.vim'
Plugin 'jordwalke/flatlandia'
Plugin 'molokai'
Plugin 'vivkin/flatland.vim'
Plugin 'Yggdroot/indentLine'
Plugin 'xterm-color-table.vim'
Plugin 'SyntaxComplete'
Plugin 'https://github.com/ervandew/supertab.git'
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'
Plugin 'https://github.com/Raimondi/delimitMate.git'
Plugin 'jeffkreeftmeijer/vim-numbertoggle'
Plugin 'scrooloose/nerdtree'
autocmd vimenter * NERDTree
map <C-n> :NERDTreeToggle<CR>
Plugin 'showhide.vim' "  zs Show all lines containing word under cursor / zh Hide all lines containing word under cursor / zn Open all folds

call vundle#end() 
filetype plugin indent on

syntax enable
"set clipboard+=unnamed	" yank to the system register (*) by default
set expandtab        	"replace <TAB> with spaces
set softtabstop=3 
set shiftwidth=3 
let mapleader=" "
set fillchars+=vert:│
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
" colors flatlandia
" colors flatland
" set background=dark
" colorscheme solarized
"colors vincent
colors molokai
hi Normal ctermfg=252 ctermbg=none " remove ugly background with picture
set guifont=Monaco:h14

"set cursorline
"set cursorcolumn
augroup CursorLine
  au!
  au VimEnter,WinEnter,BufWinEnter * setlocal cursorline cursorcolumn
  au WinLeave * setlocal nocursorline nocursorcolumn
augroup END
hi CursorLine term=bold cterm=bold guibg=Grey10

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

command! F :%!python -m json.tool



