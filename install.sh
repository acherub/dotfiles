#!/usr/bin/env bash

function doIt() {
    # Copy the files
    for file in .{gitconfig,gitattributes,gitignore,screenrc,bash_profile,extra,aliases}; do
	[ -r "$file" ] && [ -f "$file" ] && cp $(pwd)/$file ~/$file && echo copy $file;
    done;
    source ~/.bash_profile;
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
