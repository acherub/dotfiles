# Add `~/bin` to the `$PATH`
export PATH="$HOME/bin:$PATH"

# . ~/.profile
# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in ~/.{path,bash_prompt,exports,aliases,functions,extra}; do
    [ -r "$file" ] && [ -f "$file" ] && source "$file"
done
unset file
if [ -f /etc/.bashrc_homedir ]; then
    . /etc/.bashrc_homedir
fi
# Add project-local bin only if it exists (avoid committing machine-specific paths)
if [ -d "/grmn/prj/aoem/chiivan/.local/bin" ]; then
    export PATH="/grmn/prj/aoem/chiivan/.local/bin:$PATH"
fi
