#!/usr/bin/env bash

function doIt() {
    # Copy the files
    for file in .{gitattributes,gitignore,screenrc,bash_profile,extra,aliases,bash_prompt,functions,exports,vimrc,tmux.conf,dircolors}; do
        [ -r "$file" ] && [ -f "$file" ] && ln -s $(pwd)/$file ~/$file && echo Create symbolic link for $file
    done
    copy $(pwd)/.gitconfig ~/.gitconfig && echo Copy .gitconfig
    source ~/.bash_profile
}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
    doIt
else
    read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        doIt
    fi
fi
unset doIt
