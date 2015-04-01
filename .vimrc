"================================================
" Author: Chun-Hsien Chi (acherub)
" Last Modified: 2014/05/15
"================================================

" Move the cursor to the previously editing position
if filereadable($VIMRUNTIME . "/vimrc_example.vim")
 so $VIMRUNTIME/vimrc_example.vim
endif

if filereadable($VIMRUNTIME . "/macros/matchit.vim")
 so $VIMRUNTIME/macros/matchit.vim
endif

" http://www.erikzaadi.com/2012/03/19/auto-installing-vundle-from-your-vimrc/
" Setting up Vundle - the vim plugin bundler
let iCanHazVundle=1
let vundle_readme=expand('~/.vim/bundle/Vundle.vim/README.md')
if !filereadable(vundle_readme)
  echo "Installing Vundle.."
  echo ""
  silent !mkdir -p ~/.vim/bundle
  silent !git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
  let iCanHazVundle=0
endif

"------------------------------------------------------------------------------
" Vundle setting.
"------------------------------------------------------------------------------
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
" call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/vundle'

" ::Basic editing or moving
Bundle 'Lokaltog/vim-easymotion'
let g:EasyMotion_leader_key = ','

" extended % matching for HTML, LaTeX, and many other languages
Bundle 'matchit.zip'

" :: coding
Bundle 'autoload_cscope.vim'

" :: language support

" latex
Bundle 'jcf/vim-latex'
Bundle 'scrooloose/syntastic'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

"------------------------------------------------------------------------------
" General
"------------------------------------------------------------------------------

" Auto reload vimrc when editing it
autocmd! bufwritepost .vimrc source ~/.vimrc

" Get out of VI's compatible mode
set nocompatible

" Sets how many lines of history VIM has to remember
set history=100

" Enable filetype plugin
filetype plugin on
filetype indent on

" Set to auto read when a file is changed from the outside
set autoread

" Have the mouse disable
set mouse=

" Use the OS clipboard by default (on versions compiled with `+clipboard`)
set clipboard=unnamed

" Disable error bells
set noerrorbells

"------------------------------------------------------------------------------
" Colors and Fonts
"------------------------------------------------------------------------------

" Enable syntax highlighting
syntax on

" Display Colors (:h hi)
"hi Comment         ctermfg=Blue
"hi Folded          ctermfg=Green       ctermbg=Black
"hi FoldColumn      ctermfg=DarkGray    ctermbg=Black
"hi TabLine         ctermfg=Black       ctermbg=Gray
"hi TabLineFill     ctermfg=Gray        ctermbg=Gray
"hi TabLineSel      ctermfg=White       ctermbg=Black

" Omni menu colors
hi Pmenu guibg=#333333
hi PmenuSel guibg=#555555 guifg=#ffffff

set background=dark

"------------------------------------------------------------------------------
" VIM userinterface
"------------------------------------------------------------------------------
" Show the filename in the window titlebar
set title

" Enhance command-line completion
set wildmenu

" Hilight search things
set hlsearch

" Move to target when search
set incsearch

" Return to top of file when search hit buttom
set wrapscan

" Show the cursor position all the time
set ruler

" Ignore case of searches
set ignorecase

" Show “invisible” characters
set lcs=tab:▸\ ,trail:·,eol:¬,nbsp:_
"set list

" Autoindent: always set autoindenting on
set autoindent
set smartindent

" Show the current mode. show mode. show filename size when open file
set showmode
set bs=2

" Show matching parenthese
set showmatch

" Read/write a .viminfo file, don't store less than 50 lines of registers 20 commands
set viminfo='20,\"50

" Show the (partial) command as it’s being typed
set showcmd

" Always show status line (Display a status-bar)
set laststatus=2

" Make tabs as wide as four spaces
set shiftwidth=4
set softtabstop=4
set expandtab

autocmd FileType Makefile set noexpandtab
autocmd FileType c,cpp,cc,h set cindent

" Enable line numbers
set number

" Start scrolling three lines before the horizontal window border
" Minimal number of screen lines to keep above and below the cursor. (default
" 0)
set scrolloff=3

" Don’t reset cursor to start of line when moving around. (When using 'G',
" 'gg" .. etc)
set nostartofline

" Highlight current line
"set cursorline

"------------------------------------------------------------------------------
" Fileformats
"------------------------------------------------------------------------------

" Favorite filetypes
set ffs=unix,dos,mac

"---------------------------------------------------------------------------
" Encoding settings
"---------------------------------------------------------------------------
set encoding=utf-8
set termencoding=utf-8
set fileencoding=utf-8
set fileencodings=ucs-bom,utf-8,big5,gb2312,latin1

function! ViewUTF8()
    set encoding=utf-8
    set termencoding=big5
endfunction

function! UTF8()
    set encoding=utf-8
    set termencoding=big5
    set fileencoding=utf-8
    set fileencodings=ucs-bom,big5,utf-8,latin1
endfunction

function! Big5()
    set encoding=big5
    set fileencoding=big5
endfunction

"------------------------------------------------------------------------------
" Files and Bakcup
"------------------------------------------------------------------------------
" Centralize backups, swapfiles and undo history
set backupdir=~/.vim/backups,~/tmp,.,/var/tmp/vi.recover,/tmp
set directory=~/.vim/swaps,~/tmp,/var/tmp/vi.recover,/tmp,.
if exists("&undodir")
    set undodir=~/.vim/undo,~/tmp,/var/tmp/vi.recover,/tmp,.
endif

" Don’t create backups when editing files in certain directories
set backupskip=/tmp/*,/private/tmp/*

"------------------------------------------------------------------------------
" Quick Fix
"------------------------------------------------------------------------------
map cn :cn<CR>
map cp :cp<CR>

"------------------------------------------------------------------------------
" Using tab to edit files
"------------------------------------------------------------------------------
map tn :tabnew
map th :tabprev<CR>
map tl :tabnext<CR>
map td :tabclose<CR>

"------------------------------------------------------------------------------
" Folding
"------------------------------------------------------------------------------

"------------------------------------------------------------------------------
" Useful Keyboard Binding
"------------------------------------------------------------------------------
" Change mapleader to ','
let mapleader=","
let g:mapleader=","

" ,/ turn off search highlighting
nmap <leader>/ :nohl<CR>

" ,p toggles paste mode
nmap <leader>p :set paste!<BAR>set paste?<CR>

" allow multiple indentation/deindentation in visual mode
vnoremap < <gv
vnoremap > >gv

" Fast editing vimrc and reload it, need to define $VIMRC
map <leader>v :sp $VIMRC<CR><C-W>_
map <silent> <leader>V :source $VIMRC<CR>:filetype detect<CR>:exe ":echo 'vimrc reloaded'"<CR>

"For Programming
imap <F1>   <ESC>ga                         " replace <HLEP> by <ESC> in insert mode
map <F1>    ga                              " dispplay encoding
map <F2>    :set tenc=utf-8<CR>
map <F5>    <ESC>:!gentags .<CR>
map <F6>    <ESC>:w!<CR>:make -j4<CR>
map <F8>    :set hls!<BAR>set hls?<CR>      " switch hls/nohls
map <F9>    :set nu!<BAR>set nu?<CR>        " switch nu/nonu
map <F10>   :set list!<BAR>set list?<CR>    " switch list/nolist
map <F11>   :%!xxd<CR>                      " display binary file by Hex
map <F12>   :%!xxd -r<CR>                   " display normal text file

"------------------------------------------------------------------------------
" Tip #382: Search for <cword> and replace with input() in all open buffers
"------------------------------------------------------------------------------
function! Replace()
    let s:word = input("Replace " . expand('<cword>') . " with:")
    :exe 'bufdo! %s/\<' . expand('<cword>') . '\>/' . s:word . '/ge'
    :unlet! s:word
endfunction

"replace the current word in all opened buffers
map <leader>r :call Replace()<CR>

"------------------------------------------------------------------------------
" Remove trailing whitespace
"------------------------------------------------------------------------------
highlight TrailingWhitespaces ctermbg=gray guibg=gray
match TrailingWhitespaces /\s\+$/

function! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    %s/$\n\+\%$//ge
    call cursor(l, c)
endfunction

autocmd FileWritePre   *.c,*.cpp,*.h,*.js,*.py :call <SID>StripTrailingWhitespaces()
autocmd FileAppendPre  *.c,*.cpp,*.h,*.js,*.py :call <SID>StripTrailingWhitespaces()
autocmd FilterWritePre *.c,*.cpp,*.h,*.js,*.py :call <SID>StripTrailingWhitespaces()
autocmd BufWritePre    *.c,*.cpp,*.h,*.js,*.py :call <SID>StripTrailingWhitespaces()
nmap <F2> :call <SID>StripTrailingWhitespaces()<CR>

" Strip trailing whitespace (,ss)
function! StripWhitespace()
    let save_cursor = getpos(".")
    let old_query = getreg('/')
    :%s/\s\+$//e
    call setpos('.', save_cursor)
    call setreg('/', old_query)
endfunction
noremap <leader>ss :call StripWhitespace()<CR>

"------------------------------------------------------------------------------
" Language Specific
"------------------------------------------------------------------------------
" C++
function! GenCPPHeader()
    call setline(1, "#include <iostream>")
    call append(line("."), "")
    call append(line(".")+1, "using namespace std;")
    call append(line(".")+2, "")
    call append(line(".")+3, "int main(void)")
    call append(line(".")+4, "{")
    call append(line(".")+5, "")
    call append(line(".")+6, "  return 0;")
    call append(line(".")+7, "}")
    call append(line(".")+8, "")
endfunction

autocmd BufNewFile *.cpp exec ":call GenCPPHeader()"

" Perl
function! GenPerlHeader()
    call setline(1, "#!/usr/bin/perl")
    call append(line("."), "")
    call append(line(".")+1, "# Author: Chi, Chun-Hsien (acherub)")
    call append(line(".")+2, "# Email: chunhsienchi@gmail.com")
    call append(line(".")+3, "")
    call append(line(".")+4, "use strict;")
    call append(line(".")+5, "use warnings;")
    call append(line(".")+6, "use utf8;")
    call append(line(".")+7, "")
    call append(line(".")+8, 'binmode(STDIN, ":encoding(utf8)");')
    call append(line(".")+9, 'binmode(STDOUT, ":encoding(utf8)");')
    call append(line(".")+10, 'binmode(STDERR, ":encoding(utf8)");')
endfunction

autocmd BufNewFile *.pl exec ":call GenPerlHeader()"
autocmd FileType perl map <leader>e :w<CR>:!perl %<CR>

" Python
function! GenPythonHeader()
    call setline(1, '#!/usr/bin/python')
    call append(line("."), '# -*- coding: utf-8 -*-')
    call append(line(".")+1, '')
    call append(line(".")+2, 'import re')
    call append(line(".")+3, 'import math')
    call append(line(".")+4, 'import sys')
    call append(line(".")+5, 'import codecs')
    call append(line(".")+6, '')
    call append(line(".")+7, 'if __name__ == "__main__":')
endfunction

" Insert header when opening a new python file
autocmd BufNewFile *.py exec ":call GenPythonHeader()"
autocmd FileType python map <leader>e :w<CR>:!python %<CR>

autocmd BufRead /tmp/crontab* :set backupcopy=yes

"------------------------------------------------------------------------------
" Plug-in Setting
"------------------------------------------------------------------------------

"Python
"if has("autocmd")
"  autocmd FileType python set complete+=k~/.vim/tags/pydiction-0.5/pydiction
"endif

" Vim-Latex

" IMPORTANT: win32 users will need to have 'shellslash' set so that latex
" can be called correctly.
set shellslash

" IMPORTANT: grep will sometimes skip displaying the file name if you
" search in a singe file. This will confuse latex-suite. Set your grep
" program to alway generate a file-name.
set grepprg=grep\ -nH\ $*

" OPTIONAL: This enables automatic indentation as you type.
" filetype indent on

" OPTIONAL: Starting with Vim 7, the filetype of empty .tex files defaults to
" 'plaintex' instead of 'tex', which results in vim-latex not being loaded.
" The following changes the default filetype back to 'tex':
let g:tex_flavor='latex'

" ---- syntastic
"let g:syntastic_jshint_exec="jshint-gecko"
"let g:syntastic_javascript_checkers = ['jshint']
let g:syntastic_python_checkers=['pyflakes', 'pylint']
let g:syntastic_always_populate_loc_list = 1
nnoremap <silent> <F4> :lwindow<CR>
