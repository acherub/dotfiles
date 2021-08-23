# acherub's dotfiles

## Installation

You can clone the repository and run the script to install:

```bash
source install.sh
```

The installation is to copy dotfiles from the project folder, say `~/Projects/dotfiles`, to `~`

## VIM

### Vim plugins

* [vim-gitgutter](https://github.com/airblade/vim-gitgutter)
  * The highlight for sign column was disabled for vim-airline
* [nerdtree](https://github.com/scrooloose/nerdtree)
  * `<F5>` to toggle nerdtree
* [unimpaired](https://github.com/tpope/vim-unimpaired)
  * [Document](https://github.com/tpope/vim-unimpaired/blob/master/doc/unimpaired.txt)
  * `yol`: toggle list
  * `yon`: toggle number
  * `yoh`: toggle hlsearch
  * `[` / `]` to open / close settings
  *  `b`: buffer switch
  *  `B`: buffer first/last
  *  `q`: quickfix switch
  *  `Q`: quickfix first/last
* [vim-airline](https://github.com/bling/vim-airline)
  * The theme is also set to `solarized`
* [vim-surround](https://github.com/tpope/vim-surround)
  * `cs` + `marker1` + `marker2`: change `marker1` as `marker2` (ex: `cs"'`)
  * `ds` + `marker`: delete `marker` (ex: `ds"`)
  * `ys`: add surround
* [tagbar](https://github.com/majutsushi/tagbar)
  * `<F7>`: Toggle TagBar
* [taglist](http://vimawesome.com/plugin/taglist-vim)
  * depends on ctags
  * `<F11>`: Toggle Tlist
* [nerdcommenter](https://github.com/scrooloose/nerdcommenter)
  * `<leader>` is set to `,`
  * `,` + `cl`: comment current line. We can add `count` before the command. (`,` + `cb` is preferred for block)
  * `,` + `cu`: Uncomment the selected lines
  * `,` + `ca`: Change the style of comment. (From `/* */` to `//` in c/cpp)
* [nerdtree](https://github.com/scrooloose/nerdtree)
* [vim-easymotion](https://github.com/Lokaltog/vim-easymotion)
  * `g:EasyMotion_leader_key` is set to `,`
  * `,` + `w`
  * `,` + `b`
  * `,` + `f`
* [vim-repeat](https://github.com/tpope/vim-repeat)
* matchit
* [vim-colorschemes](https://github.com/flazz/vim-colorschemes)
  * Set the `colortheme` as `solarized` in `vimrc`
* [vim-latex](https://github.com/vim-latex/vim-latex)
* [ctrlp](https://github.com/kien/ctrlp.vim)
  * `,` + `p`: Open the ctrl p window, current directory and sub-directories
  * `,` + `m`: Open the ctrl p window, with recently modified files

### VIM Theme - Solarized

Here are some notes about setting terminal color in windows

#### Pietty

1. Download the color settings from [official website](http://ethanschoonover.com/solarized/vim-colors-solarized)
2. Unzip it and enter `putty-colors-solarized` directory, copy the color settings.
3. Edit `PieTTY.ini` and add the color settings to the session that you want.
4. Check the setting `Terminal-type string` in `Connection -> Data` should be `xterm-256color`
5. Check the setting `Allow terminal to use xterm 256-colour mode` in `Window -> Colours` is enabled

#### Bash/dircolors

Download the dircolors for solarized in [dircolors-solarized](https://github.com/seebi/dircolors-solarized). I use `dircolors.256dark` and it works fine. In the install script, the file will be copied as `~/.dircolors` and there's an command in `.alias` to apply the setting

```bash
test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
```

#### Git Gutter

The highlight for sign column was disabled for vim-airline

```vim
highlight clear SignColumn
```

### Customized VIM commands

#### Function keys

* `<F5>`: Toggle NERDTree (on Left)
* `<F6>`: Not using
* `<F7>`: Toggle TagBar
* `<F8>`: Trinity Toggle All
* `<F9>`: Trinity Toggle ScrExpl
* `<F10>`: Trinity Toggle TagList
* `<F11>`: Trinity Toggle NerdTree (onRight)

#### Commands with Leader keys

* `,` + `r`: Replace the current word in all opened buffers
* `,` + `v`: Reload
* `,` + `ss`: Strip trailing whitespace

#### Normal Mode Shortcuts

* `;;`: Mapping `;;` to `<ESC>` in normal mode
