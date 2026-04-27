#!/usr/bin/env bash
set -euo pipefail

# Install script: create symlinks from this repo to $HOME; existing files are backed up by default
# Supported args: --force/-f (force overwrite), --no-backup (no backup), --dry-run/-n (preview)

PWD="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/dotfiles_backup_$(date +%Y%m%d%H%M%S)"
DRY_RUN=0
FORCE=0
MAKE_BACKUP=1

usage() {
  echo "Usage: $0 [--force|-f] [--no-backup] [--dry-run|-n]"
  exit 1
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --force|-f) FORCE=1; shift ;;
    --no-backup) MAKE_BACKUP=0; shift ;;
    --dry-run|-n) DRY_RUN=1; shift ;;
    --help|-h) usage ;;
    *) echo "Unknown option: $1"; usage ;;
  esac
done

files=(.{gitattributes,gitignore,screenrc,bash_profile,extra,aliases,bash_prompt,functions,exports,vimrc,tmux.conf,dircolors})

log() { printf "%s\n" "$1"; }

doIt() {
  [ "$DRY_RUN" -eq 1 ] && log "DRY RUN: no changes will be made"

  if [ "$MAKE_BACKUP" -eq 1 ]; then
    log "Creating backup directory: $BACKUP_DIR"
    [ "$DRY_RUN" -eq 0 ] && mkdir -p "$BACKUP_DIR"
  fi

  for file in "${files[@]}"; do
    src="$PWD/$file"
    dest="$HOME/$file"

    # If source does not exist, skip
    if [ ! -e "$src" ]; then
      log "Skipping: source does not exist $src"
      continue
    fi

    if [ -L "$dest" ] || [ -e "$dest" ]; then
      if [ "$MAKE_BACKUP" -eq 1 ]; then
        log "Backing up $dest -> $BACKUP_DIR/"
        [ "$DRY_RUN" -eq 0 ] && mv -f "$dest" "$BACKUP_DIR/" || true
      fi

      if [ "$FORCE" -eq 1 ]; then
        log "Creating/updating symlink: $dest -> $src"
        [ "$DRY_RUN" -eq 0 ] && ln -sfn "$src" "$dest"
      else
        log "Skipping existing target: $dest (use --force to overwrite)"
      fi
    else
      log "Creating symlink: $dest -> $src"
      [ "$DRY_RUN" -eq 0 ] && ln -s "$src" "$dest"
    fi
  done

  if [ -f "$PWD/.gitconfig" ]; then
    log "Copy .gitconfig to $HOME"
    [ "$DRY_RUN" -eq 0 ] && cp "$PWD/.gitconfig" "$HOME/.gitconfig"
  fi

  # Attempt to source shell profile (if present)
  if [ -r "$HOME/.bash_profile" ] && [ "$DRY_RUN" -eq 0 ]; then
    # Do not let this fail the whole script
    source "$HOME/.bash_profile" || true
  fi

  log "Done"
}

# Execute
doIt

unset -f doIt
unset -f log
