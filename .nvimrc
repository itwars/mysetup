"   ┌───────────────────────────┐
"   │ NeoVim configuration file │
"   │ Author: Vincent RABAH     │
"   │ Update date: 2015-06-01   │
"   └───────────────────────────┘

" ┌─────────┐
" │ Plugins │
" └─────────┘
call plug#begin('~/.nvim/plugged')
   Plug 'tomasr/molokai'
   Plug 'ervandew/supertab'
   Plug 'Raimondi/delimitMate'
   Plug 'majutsushi/tagbar'
   Plug 'scrooloose/nerdtree',                     { 'on':  'NERDTreeToggle' }
   Plug 'junegunn/goyo.vim',                       { 'on':  'Goyo'}
   Plug 'Yggdroot/indentLine'
   Plug 'docunext/closetag.vim',                   { 'for': 'html'}
   Plug 'pangloss/vim-javascript',                 { 'for': 'javascript' }
   Plug 'tpope/vim-markdown',                      { 'for': 'markdown'}
   Plug 'gorodinskiy/vim-coloresque',              { 'for': ['css', 'sass', 'scss', 'less'] }
   Plug 'rstacruz/sparkup',                        { 'for': ['html', 'xhtml']}
   Plug 'othree/tern_for_vim_coffee',              { 'for': ['javascript', 'coffee'] }
   Plug 'othree/javascript-libraries-syntax.vim',  { 'for': ['javascript', 'coffee'] }
call plug#end()

" ┌────────────────┐
" │ User interface │
" └────────────────┘

set timeout
set timeoutlen=750
set ttimeoutlen=250

"NeoVim handles ESC keys as alt+key set this to solve the problem
if has('nvim')
   set ttimeout
   set ttimeoutlen=0
   set matchtime=0
endif

syntax on
set synmaxcol=128       " disable syntax on large line
set t_ut=               " fuckin 256colors zones in tmux !!!
set expandtab        	" replace <TAB> with spaces
set tabstop=3
set softtabstop=3 
set shiftwidth=3 
au Filetype javascript setlocal ts=4 sts=4 sw=4
au Filetype markdown   setlocal ts=4 sts=4 sw=4
let mapleader=","
set fillchars+=vert:│
let g:indentLine_char = '│'
let g:indentLine_color_term = 1
colorscheme molokai
set background=dark
" set ctermfont=Monaco:h14
set number
set backspace=2 " make backspace work like most other apps
set laststatus=2
set nocompatible
set lazyredraw  " Don't redraw while executing macros (better performance)
filetype plugin indent on

let g:toggle=1
autocmd vimenter * call StatusBarToggle()
highlight CursorLine   ctermbg=blue
highlight CursorColumn ctermbg=blue
augroup CursorLine
  au!
  au VimEnter,WinEnter,BufWinEnter * setlocal cursorline cursorcolumn
  au WinLeave * setlocal nocursorline nocursorcolumn
augroup END
"Restore cursor to file position in previous editing session
set viminfo='10,\"100,:20,%,n~/.viminfo
au BufReadPost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm '\"")|else|exe "norm $"|endif|endif
nmap <leader>p :set paste!<BAR>set paste?<CR> " ,p toggles paste mode
map <C-n> :NERDTreeToggle<CR>
map <C-t> :TagbarToggle<CR>
set pastetoggle=<F2>
" auto reload vimrc when editing it
autocmd! bufwritepost .nvimrc source ~/.nvimrc
" Markdown
autocmd BufNewFile,BufReadPost *.md set filetype=markdown

" ┌─────────────┐
" │ Beautifiers │
" └─────────────┘
command! Xselect norm! ggVG
command! Xbeautifyhtml norm! ggVG :!js-beautify --type html -s 2 -q -f -<CR>
command! Xbeautifyjs norm! ggVG :!js-beautify --type js -s 2 -q -f -<CR>
command! Xbeautifycss norm! ggVG :!js-beautify --type css -s 2 -q -f -<CR>
command! Xbeautifyjson :%!python -m json.tool
command! Xindent norm! ggVG='.

" ┌───────────────────────────────────────────┐
" │  Enable omni completion. (Ctrl-X Ctrl-O)  │
" └───────────────────────────────────────────┘
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
" use syntax complete if nothing else available
if has("autocmd") && exists("+omnifunc")
  autocmd Filetype *
              \ if &omnifunc == "" |
              \         setlocal omnifunc=syntaxcomplete#Complete |
              \ endif
endif

" ┌──────────────────┐
" │ supertab stuffs  │
" └──────────────────┘
" let g:SuperTabDefaultCompletionType = "context"
" let g:SuperTabClosePreviewOnPopupClose=1
" set completeopt=menuone,longest,preview
let g:SuperTabDefaultCompletionType='context'
autocmd FileType *
  \ if &omnifunc != '' |
  \   call SuperTabChain(&omnifunc, "<c-p>") |
  \ endif

" ┌──────────┐
" │  TagBar  │
" └──────────┘
let g:tagbar_usearrows = 1
let g:tagbar_autofocus = 1

" ┌──────────┐
" │ NERDTree │
" └──────────┘
"autocmd vimenter * NERDTree
"autocmd BufNew * wincmd l  " Autofocus to file on NerdTree
let NERDTreeShowHidden=1   " Show hidden files in NerdTree
"autocmd VimEnter * wincmd p
" Close vim if the last open window is nerdtree
autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

" ┌─────────────┐
" │ Box drawing │
" └─────────────┘
" ╔═╗┌─┐
" ║ ║│ │
" ╚═╝└─┘
function! WrapThem() range
    let lines = getline(a:firstline,a:lastline)
    let maxl = 0
    for l in lines
        let maxl = len(l)>maxl? len(l):maxl
    endfor
    let h1 = '┌' . repeat('─', maxl+2) . '┐'
    let h2 = '└' . repeat('─', maxl+2) . '┘'
    for i in range(len(lines))
        let ll = len(lines[i])
        let lines[i] = '│ ' . lines[i] . repeat(' ', maxl-ll) . ' │'
    endfor  
    let result = [h1]             " Ligne du haut
    call extend(result, lines)   " Le corps du cadre
    call add(result,h2)           " Ligne du bas
    execute a:firstline.','.a:lastline . ' d'
    let s = a:firstline-1<0?0:a:firstline-1
    call append(s, result)
endfunction
vmap <F4> :call WrapThem()<CR>

" ┌───────────────────┐
" │ Status bar toggle │
" └───────────────────┘
" ┌────────────────────────────────────────────────────────────────┐
" │ %< truncation point                                            │
" │ %n buffer number                                               │
" │ %f relative path to file                                       │
" │ %m modified flag [+] (modified), [-] (unmodifiable) or nothing │
" │ %r readonly flag [RO]                                          │
" │ %y filetype [ruby]                                             │
" │ %= split point for left and right justification                │
" │ %-35. width specification                                      │
" │ %l current line number                                         │
" │ %L number of lines in buffer                                   │
" │ %c current column number                                       │
" │ %V current virtual column number (-n), if different from %c    │
" │ %p percentage file                                             │
" │ %) end of width specification                                  │
" └────────────────────────────────────────────────────────────────┘
function! StatusBarToggle()
      hi User1 ctermbg=green ctermfg=darkred 
      hi User2 ctermbg=red   ctermfg=darkblue
      hi User3 ctermbg=blue  ctermfg=darkred 
      if g:toggle==1
         let g:toggle=0
         set statusline=
         set statusline+=%1*        
         set statusline+=\ [%t]\    
         set statusline+=%2*        
         set statusline+=\ %y\      
         set statusline+=%3*        
         set statusline+=%=%-35.(line:\ %l\ of\ %L,\ col:\ %c%V\ (%p%%)%)
      else
         let g:toggle=1
         set statusline =
         set statusline+=%2*\ C-n\ Tree\ %3*
         set statusline+=\ %2*\ C-t\ Tag\ %3*
         set statusline+=\ %2*\ F4\ Box\ %3*
         set statusline+=\ %2*\ F9\ Goyo\ %3*
         set statusline+=\ %2*\ F10\ Toggle\ %3*
      endif
endfunction
nnoremap <silent> <F10> :call StatusBarToggle()<CR> 
nnoremap <silent> <F9>  :Goyo<CR>

au BufNewFile Dockerfile r ~/mysetup/templates/Dockerfile.txt

""# Pull base image
""FROM resin/rpi-raspbian:wheezy
""MAINTAINER Vincent RABAH <vincent.rabah@gmail.com>
""
""# Install Node.js (from tarball)
""RUN \
""        apt-get update && \
""        apt-get -y dist-upgrade && \
""        apt-get install -y wget && \
""        wget http://node-arm.herokuapp.com/node_latest_armhf.deb && \
""        dpkg -i node_latest_armhf.deb && \
""        apt-get remove -y wget && \
""        apt-get clean -y && \
""        apt-get autoclean -y && \
""        apt-get autoremove -y && \
""        rm -f node_latest_armhf.deb && \
""        rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
"        rm -rf /var/lib/{apt,dpkg,cache,log}/
""
""# Define working directory
""WORKDIR /data
""
""# Define default command
""CMD ["bash"]


