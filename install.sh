#!/usr/bin/env bash

function doIt() {
    cp $(pwd)/.gitconfig ~/.gitconfig
    cp $(pwd)/.gitattributes ~/.gitattributes
    cp $(pwd)/.gitignore ~/.gitignore

    # Load the shell dotfiles, and then some:
    # * ~/.path can be used to extend `$PATH`.
    # * ~/.extra can be used for other settings you don’t want to commit.
    for file in .{path,bash_prompt,exports,aliases,functions,extra}; do
        [ -r "$file" ] && [ -f "$file" ] && source "$file";
    done;
    unset file;
}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
    doIt;
else
    read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
    echo "";
    if [[ $REPLY =~ ^[Yy]$ ]]; then
	doIt;
    fi;
fi;
unset doIt;
