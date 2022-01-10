"================================================
" Author: Chun-Hsien Chi (acherub)
" Last Modified: 2021/07/26
"================================================

if !exists('g:env')
  if has('win64') || has('win32') || has('win16')
    let g:env = 'WINDOWS'
  else
    let g:env = toupper(substitute(system('uname'), '\n', '', ''))
  endif
endif

" Move the cursor to the previously editing position
if filereadable($VIMRUNTIME . "/vimrc_example.vim")
 so $VIMRUNTIME/vimrc_example.vim
endif

if filereadable($VIMRUNTIME . "/macros/matchit.vim")
 so $VIMRUNTIME/macros/matchit.vim
endif

if g:env !~ "WINDOWS"
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
endif

"-----------------------------------------------------------------------
" Vundle setting.
"-----------------------------------------------------------------------
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
if g:env =~ "WINDOWS"
    set rtp+=$VIM/vimfiles/bundle/Vundle.vim
    call vundle#begin('$VIM/vimfiles/bundle/')
else
    set rtp+=~/.vim/bundle/Vundle.vim
    call vundle#begin()
    " alternatively, pass a path where Vundle should install plugins
    " call vundle#begin('~/some/path/here')
endif


" let Vundle manage Vundle, required
Plugin 'gmarik/vundle'

" :: coding
Plugin 'autoload_cscope.vim'

" :: language support
" Plugin for Qt syntax
Plugin 'fedorenchik/qt-support.vim'
" Plugin for Kotlin Support
Plugin 'udalov/kotlin-vim'

" Completion
" Bundle 'Valloric/YouCompleteMe'

" Integration
" Shows git diff in the 'gutter' (sign column)
Plugin 'airblade/vim-gitgutter'

" Interface
" Show file-tree on sidebar
Plugin 'scrooloose/nerdtree'
" Show code structure on sidebar
Plugin 'vim-scripts/taglist.vim'
" Browse the tags of the current file and get an overview of its structure
Plugin 'majutsushi/tagbar'

if g:env !~ "WINDOWS"
    " status bar and tabline for vim
    Plugin 'bling/vim-airline'
    " VIM airline theme
    Plugin 'vim-airline/vim-airline-themes'
endif

" Commands
" Parentheses, brackets, quotes, XML, tags, and more.
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-repeat'
" Pair some command with open/close bracket for easy use
Plugin 'tpope/vim-unimpaired'
" Line up text with symbol
Plugin 'godlygeek/tabular'
" extended % matching for HTML, LaTeX, and many other languages
Plugin 'matchit.zip'
" Plugin for moving fast
Plugin 'Lokaltog/vim-easymotion'
let g:EasyMotion_leader_key = ','

" Plugin for fuzzy file finder
Plugin 'kien/ctrlp.vim'

" Plugin for source code definition
Plugin 'wesleyche/SrcExpl'

" Plugin to open NERDTree/TagList/SrcExpl
Plugin 'wesleyche/Trinity'

" A Vim Bundle for visually displaying indent levels in code.
Plugin 'nathanaelkane/vim-indent-guides'
"Plugin 'tomasr/molokai'
Plugin 'flazz/vim-colorschemes'

Plugin 'scrooloose/nerdcommenter'

" latex
Plugin 'vim-latex/vim-latex'
"Plugin 'scrooloose/syntastic'

" liu
Plugin 'pi314/boshiamy.vim'

" All of your Plugins must be added before the following line

if g:env =~ "WINDOWS"
    call vundle#end('$VIM/vimfiles/bundle/') " required
else
    call vundle#end()            " required
endif
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

"-----------------------------------------------------------------------
" General
"-----------------------------------------------------------------------

" Auto reload vimrc when editing it
if g:env !~ "WINDOWS"
    autocmd! bufwritepost .vimrc source ~/.vimrc
endif

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

"-----------------------------------------------------------------------
" Encoding settings
"-----------------------------------------------------------------------
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

" 2022/01/06 --> Not sure if it's required
"============ encoding utf8 ===============
" piaip's gvim settings for gvim/win32 with UTF8
" optimized for Traditional Chinese users
" last update: Mon Jun 7 17:59:54 CST 2004
"let $LANG="zh_TW.UTF-8" " locales
"set encoding=utf-8 " ability
"set fileencoding=big5 " prefer
" charset detect list. ucs-bom must be earlier than ucs*.
"set fileencodings=ascii,ucs-bom,utf-8,ucs-2,ucs-le,sjis,big5,latin1
" for console mode we use big5
"set fileencodings=utf-8,big5,euc-jp,gbk,euc-kr,utf-bom,iso8859-1
"set encoding=utf8
"set tenc=utf8

if g:env =~ "WINDOWS"
    " Encoding Setting
    "
    set fileencodings=utf-8,big5,gbk,gb2312,cp936,iso-2022-jp,sjis,euc-jp "charset detect list. ucs-bom must be earlier than ucs

    if has("gui_running")
    set termencoding=utf-8
    else
    set termencoding=big5
    endif

    set langmenu=en_US
    let $LANG = 'en_US'

    source $VIMRUNTIME/delmenu.vim
endif
"============ encoding utf8 ===============


"-----------------------------------------------------------------------
" Colors and Fonts
"-----------------------------------------------------------------------

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

if g:env =~ "WINDOWS"
    colorscheme ansi_blows
    "set guifont=Courier\ New:h10
    set guifont=DejaVu\ Sans\ Mono\ for\ Powerline:h10
else
    colorscheme solarized
    if has('gui_running')
        set background=light
    else
        set background=dark
    endif
endif


"-----------------------------------------------------------------------
" VIM userinterface
"-----------------------------------------------------------------------
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
" lcs: listchars
set lcs=tab:▸\ ,trail:·,eol:¬,nbsp:_
" Invisible character colors
highlight NonText guifg=#4a4a59
highlight SpecialKey guifg=#4a4a59
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

if g:env =~ "WINDOWS"
    "set enc=taiwan
    set laststatus=2                " Display a status-bar.
endif
"-----------------------------------------------------------------------
" Fileformats
"-----------------------------------------------------------------------

" Favorite filetypes
set ffs=unix,dos,mac

"-----------------------------------------------------------------------
" Files and Bakcup
"-----------------------------------------------------------------------
" Centralize backups, swapfiles and undo history
if g:env =~ "WINDOWS"
    set backupdir=C:\vimbak
    set directory=C:\vimbak\swap
    set undodir=C:\vimbak
else
    set backupdir=~/.vim/backups,~/tmp,.,/var/tmp/vi.recover,/tmp
    set directory=~/.vim/swaps,~/tmp,/var/tmp/vi.recover,/tmp,.
    if exists("&undodir")
        set undodir=~/.vim/undo,~/tmp,/var/tmp/vi.recover,/tmp,.
    endif
    " Don’t create backups when editing files in certain directories
    set backupskip=/tmp/*,/private/tmp/*
endif


"-----------------------------------------------------------------------
" Quick Fix
"-----------------------------------------------------------------------
map cn :cn<CR>
map cp :cp<CR>

"-----------------------------------------------------------------------
" Using tab to edit files
"-----------------------------------------------------------------------
map tn :tabnew
map th :tabprev<CR>
map tl :tabnext<CR>
map td :tabclose<CR>

"-----------------------------------------------------------------------
" Using tab to edit files
"-----------------------------------------------------------------------
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'

"-----------------------------------------------------------------------
" Folding
"-----------------------------------------------------------------------

"-----------------------------------------------------------------------
" Useful Keyboard Binding
"-----------------------------------------------------------------------
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
"map <leader>v :sp $VIMRC<CR><C-W>_
"map <silent> <leader>V :source $VIMRC<CR>:filetype detect<CR>:exe ":echo 'vimrc reloaded'"<CR>

" For Programming
" Showing the ASCII value of current character
imap <F1>   <ESC>ga                         " replace <HLEP> by <ESC> in insert mode
map <F1>    ga                              " dispplay encoding

"map <F2>    :set tenc=utf-8<CR>
"map <F5>    <ESC>:!gentags .<CR>
"map <F6>    <ESC>:w!<CR>:make -j4<CR>
"map <F8>    :set hls!<BAR>set hls?<CR>      " switch hls/nohls
"map <F9>    :set nu!<BAR>set nu?<CR>        " switch nu/nonu
"map <F10>   :set list!<BAR>set list?<CR>    " switch list/nolist
map <F11>   :%!xxd<CR>                      " display binary file by Hex
map <F12>   :%!xxd -r<CR>                   " display normal text file

"nmap <CR>   o<ESC>k

" Mapping ;; to <ESC> in normal mode
imap ;;     <ESC>

"-----------------------------------------------------------------------
" Tip #382: Search for <cword> and replace with input() in all open buffers
"-----------------------------------------------------------------------
function! Replace()
    let s:word = input("Replace " . expand('<cword>') . " with:")
    :exe 'bufdo! %s/\<' . expand('<cword>') . '\>/' . s:word . '/ge'
    :unlet! s:word
endfunction

" Replace the current word in all opened buffers
map <leader>r :call Replace()<CR>

"-----------------------------------------------------------------------
" Remove trailing whitespace
"-----------------------------------------------------------------------
highlight TrailingWhitespaces ctermbg=gray guibg=gray
match TrailingWhitespaces /\s\+$/

function! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    %s/$\n\+\%$//ge
    call cursor(l, c)
endfunction

autocmd FileWritePre   *.c,*.cpp,*.h,*.js,*.py,*.java,*.tex :call <SID>StripTrailingWhitespaces()
autocmd FileAppendPre  *.c,*.cpp,*.h,*.js,*.py,*.java,*.tex :call <SID>StripTrailingWhitespaces()
autocmd FilterWritePre *.c,*.cpp,*.h,*.js,*.py,*.java,*.tex :call <SID>StripTrailingWhitespaces()
autocmd BufWritePre    *.c,*.cpp,*.h,*.js,*.py,*.java,*.tex :call <SID>StripTrailingWhitespaces()
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

"-----------------------------------------------------------------------
" Language Specific
"-----------------------------------------------------------------------
" C++
function! GenCppHeader()
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

autocmd BufNewFile *.cpp exec ":call GenCppHeader()"

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
autocmd BufRead wscript set syntax=python

" Set spell checking and automatic wrapping 72 characters in the message
autocmd Filetype gitcommit setlocal textwidth=72

" Set the QuickFix window always on the bottom taking the whole horizontal
" space
autocmd Filetype qf wincmd J

"-----------------------------------------------------------------------
" Plug-in Setting
"-----------------------------------------------------------------------

"Python
"if has("autocmd")
"  autocmd FileType python set complete+=k~/.vim/tags/pydiction-0.5/pydiction
"endif

"------------------------------------
" NERDtree
"------------------------------------
nnoremap <silent> <F5> :NERDTreeToggle<CR>
let g:NERDTreeWinPos = "left"

"------------------------------------
" YouCompleteMe
"------------------------------------
" let g:ycm_confirm_extra_conf = 0
" let g:ycm_key_list_select_completion = ['<TAB>']
" let g:ycm_key_list_previous_completion=['<S-TAB>']
" let g:ycm_global_ycm_extra_conf='~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'

"------------------------------------
" Vim-indent Guide
"------------------------------------
" Toggle with <Leader>ig
let g:indent_guides_auto_colors = 0
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=Grey25 ctermbg=3
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=Grey25 ctermbg=4
" au VimEnter * IndentGuidesToggle

"------------------------------------
" Taglist
"------------------------------------
nmap <silent><F11> :TlistToggle<CR>
imap <silent><F11> <C-o>:TlistToggle<CR>
"let Tlist_Ctags_Cmd = '/usr/bin/ctags'
let Tlist_Use_SingleClick = 1
let Tlist_Use_Right_Window = 0
let Tlist_Show_One_File = 1
let Tlist_Exit_OnlyWindow = 1
let tlist_php_settings = 'php;c:class;d:constant;f:function'

"------------------------------------
" TagBar
"------------------------------------
" toggle TagBar with F7
nnoremap <silent> <F7> :TagbarToggle<CR>
" set focus to TagBar when opening it
let g:tagbar_autofocus = 1

"------------------------------------
" Tagbar Settings
"------------------------------------
" Open and close the tagbar separately
nmap <F7> :TagbarToggle<CR>

"------------------------------------
" Trinity Settings
"------------------------------------
" Open and close all the three plugins on the same time
nmap <F8>  :TrinityToggleAll<CR>

" Open and close the Source Explorer separately
nmap <F9>  :TrinityToggleSourceExplorer<CR>

" Open and close the Taglist separately
nmap <F10> :TrinityToggleTagList<CR>

" Open and close the NERD Tree separately
nmap <F11> :TrinityToggleNERDTree<CR>

"------------------------------------
" Vim-LaTeX
"------------------------------------

" REQUIRED. This makes vim invoke Latex-Suite when you open a tex file.
filetype plugin on

" IMPORTANT: win32 users will need to have 'shellslash' set so that latex
" can be called correctly.
set shellslash

" IMPORTANT: grep will sometimes skip displaying the file name if you
" search in a singe file. This will confuse latex-suite. Set your grep
" program to always generate a file-name.
set grepprg=grep\ -nH\ $*

" OPTIONAL: This enables automatic indentation as you type.
" filetype indent on

" OPTIONAL: Starting with Vim 7, the filetype of empty .tex files defaults to
" 'plaintex' instead of 'tex', which results in vim-latex not being loaded.
" The following changes the default filetype back to 'tex':
let g:tex_flavor='latex'

"------------------------------------
" Syntastic
"------------------------------------
"let g:syntastic_jshint_exec="jshint-gecko"
"let g:syntastic_javascript_checkers = ['jshint']
"let g:syntastic_python_checkers=['pyflakes', 'pylint']
"let g:syntastic_always_populate_loc_list = 1
"nnoremap <silent> <F4> :lwindow<CR>

"------------------------------------
" Vim-airline
"------------------------------------
if g:env !~ "WINDOWS"
    let g:airline_powerline_fonts = 1

    if !exists('g:airline_symbols')
      let g:airline_symbols = {}
    endif

    " powerline symbols
    let g:airline_left_sep = ''
    let g:airline_left_alt_sep = ''
    let g:airline_right_sep = ''
    let g:airline_right_alt_sep = ''
    let g:airline_symbols.branch = ''
    let g:airline_symbols.readonly = ''
    let g:airline_symbols.linenr = ''

    " enable tabline
    let g:airline#extensions#tabline#enabled = 1
    " set left separator
    let g:airline#extensions#tabline#left_sep = ''
    " set left separator which are not editting
    let g:airline#extensions#tabline#left_alt_sep = ''
    " show buffer number
    let g:airline#extensions#tabline#tab_nr_type = 1 " tab number
    " Set solarized theme
    let g:airline_theme='solarized'
    let g:airline#extensions#tagbar#enabled = 0
endif

"------------------------------------
" CrtlP
"------------------------------------
"let g:ctrlp_map = '<c-p>'
let g:ctrlp_map = '<leader>p'
map <leader>m :CtrlPMRU<CR>
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn)$',
  \ 'file': '\v\.(exe|so|dll|pyc|bmp|jpg)$',
  \ }
let g:ctrlp_working_path_mode = 'ra'

"------------------------------------
" Vim-gitgutter
"------------------------------------
" disable the highlight for sign column (for vim-airline)
highlight clear SignColumn
