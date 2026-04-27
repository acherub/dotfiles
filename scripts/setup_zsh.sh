#!/usr/bin/env bash
set -euo pipefail

# setup_zsh.sh
# Idempotent script to install zsh, fzf, and recommended plugins
# Usage: ./setup_zsh.sh [--dry-run] [--no-omz]

DRY_RUN=0
NO_OMZ=0

for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY_RUN=1; shift ;;
    --no-omz) NO_OMZ=1; shift ;;
    -h|--help)
      cat <<'EOF'
Usage: setup_zsh.sh [--dry-run] [--no-omz]
  --dry-run   print actions without making changes
  --no-omz     do not install Oh My Zsh
EOF
      exit 0
      ;;
    *) ;;
  esac
done

run() {
  if [ "$DRY_RUN" -eq 1 ]; then
    echo "[DRY] $*"
  else
    echo "+ $*"
    eval "$@"
  fi
}

has_cmd() { command -v "$1" >/dev/null 2>&1; }

detect_pkg_mgr() {
  if has_cmd apt-get; then echo apt-get
  elif has_cmd dnf; then echo dnf
  elif has_cmd yum; then echo yum
  elif has_cmd pacman; then echo pacman
  elif has_cmd apk; then echo apk
  elif has_cmd brew; then echo brew
  else echo unknown
  fi
}

ensure_packages() {
  PKG="$*"
  PKG_MGR=$(detect_pkg_mgr)
  case "$PKG_MGR" in
    apt-get)
      run sudo apt-get update -y
      run sudo apt-get install -y $PKG
      ;;
    dnf)
      run sudo dnf install -y $PKG
      ;;
    yum)
      run sudo yum install -y $PKG
      ;;
    pacman)
      run sudo pacman -Sy --noconfirm $PKG
      ;;
    apk)
      run sudo apk add --no-cache $PKG
      ;;
    brew)
      run brew install $PKG
      ;;
    *)
      echo "No supported package manager found; please install: $PKG" >&2
      ;;
  esac
}

# 1) Ensure basic tools
for p in git curl wget tar; do
  if ! has_cmd "$p"; then
    ensure_packages "$p" || true
  fi
done

# 2) Ensure zsh
if ! has_cmd zsh; then
  echo "zsh not found; attempting to install..."
  ensure_packages zsh || echo "Please install zsh manually"
else
  echo "zsh found: $(command -v zsh)"
fi

# 3) Install fzf (idempotent)
FZF_DIR="$HOME/.fzf"
if [ -d "$FZF_DIR" ]; then
  echo "fzf already present at $FZF_DIR"
else
  run git clone --depth 1 https://github.com/junegunn/fzf.git "$FZF_DIR"
  if [ "$DRY_RUN" -eq 0 ] && [ -f "$FZF_DIR/install" ]; then
    # Download binary and enable keybindings/completion without touching rc files
    "$FZF_DIR/install" --all --no-update-rc || true
  fi
fi

# 4) Install plugins to ZSH_CUSTOM (Oh My Zsh) or local plugins folder
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
PLUGINS_DIR="$ZSH_CUSTOM/plugins"
run mkdir -p "$PLUGINS_DIR"

# fast-syntax-highlighting (preferred)
if [ ! -d "$PLUGINS_DIR/fast-syntax-highlighting" ]; then
  run git clone --depth 1 https://github.com/zdharma-continuum/fast-syntax-highlighting.git "$PLUGINS_DIR/fast-syntax-highlighting"
else
  echo "fast-syntax-highlighting already installed"
fi

# zsh-autosuggestions
if [ ! -d "$PLUGINS_DIR/zsh-autosuggestions" ]; then
  run git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions.git "$PLUGINS_DIR/zsh-autosuggestions"
else
  echo "zsh-autosuggestions already installed"
fi

# zsh-completions
if [ ! -d "$PLUGINS_DIR/zsh-completions" ]; then
  run git clone --depth 1 https://github.com/zsh-users/zsh-completions.git "$PLUGINS_DIR/zsh-completions"
else
  echo "zsh-completions already installed"
fi

# fallback: zsh-syntax-highlighting (optional)
if [ ! -d "$PLUGINS_DIR/zsh-syntax-highlighting" ]; then
  run git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting.git "$PLUGINS_DIR/zsh-syntax-highlighting" || true
fi

# 5) Optionally install or repair Oh My Zsh (non-interactive)
if [ "$NO_OMZ" -eq 0 ]; then
  # If core oh-my-zsh is missing (incomplete directory), either clone or merge a fresh copy.
  if [ ! -s "$HOME/.oh-my-zsh/oh-my-zsh.sh" ]; then
    echo "Installing or repairing Oh My Zsh"
    if [ "$DRY_RUN" -eq 1 ]; then
      echo "[DRY] git clone https://github.com/ohmyzsh/ohmyzsh.git $HOME/.oh-my-zsh"
    else
      if [ -d "$HOME/.oh-my-zsh" ] && [ "$(ls -A "$HOME/.oh-my-zsh")" ]; then
        # Directory exists but core files are missing — merge a fresh clone to avoid losing custom/.
        TMP_DIR=$(mktemp -d)
        run git clone --depth 1 https://github.com/ohmyzsh/ohmyzsh.git "$TMP_DIR"
        # rsync core files but preserve existing custom/ directory
        run rsync -a --exclude 'custom' "$TMP_DIR/" "$HOME/.oh-my-zsh/"
        run rm -rf "$TMP_DIR"
      else
        run git clone --depth 1 https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
      fi
    fi
  fi
fi

# 6) Install Powerlevel10k theme and deploy p10k config
# Install powerlevel10k into ZSH_CUSTOM/themes (idempotent)
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
  run git clone --depth 1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
else
  echo "powerlevel10k already installed"
fi

# Deploy provided .p10k.zsh from repository to user's home (if present in repo)
REPO_P10K="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/.p10k.zsh"
if [ -f "$REPO_P10K" ]; then
  if [ ! -f "$HOME/.p10k.zsh" ]; then
    run cp "$REPO_P10K" "$HOME/.p10k.zsh"
    echo "Deployed .p10k.zsh to $HOME/.p10k.zsh"
  else
    echo "$HOME/.p10k.zsh already exists; leaving it intact"
  fi
fi

# 6) Backup existing .zshrc once, then write a curated .zshrc
ZSHRC="$HOME/.zshrc"
if [ -f "$ZSHRC" ] && [ ! -f "${ZSHRC}.orig-by-setup_zsh" ]; then
  run cp "$ZSHRC" "${ZSHRC}.orig-by-setup_zsh"
  echo "Backed up existing $ZSHRC to ${ZSHRC}.orig-by-setup_zsh"
fi

write_zshrc() {
cat > "$1" <<'EOF'
# Generated by setup_zsh.sh — safe to re-run
# Performance tweaks

# Safety: only run this file when using zsh. If sourced by bash or sh, return early
# to avoid syntax errors from zsh-specific constructs (e.g., arrays, emulate, typeset).
if [ -z "${ZSH_VERSION-}" ]; then
  # Not zsh; skip the rest when accidentally sourced in other shells
  return 0
fi

export KEYTIMEOUT=1

# Prefer fzf binary path
if [ -d "$HOME/.fzf/bin" ]; then
  export PATH="$HOME/.fzf/bin:$PATH"
fi

# Minimal plugin set; heavy plugins lazy-loaded later
plugins=(git zsh-completions)

# Prefer powerlevel10k theme if available
ZSH_THEME="powerlevel10k/powerlevel10k"

# Oh My Zsh bootstrap (if present)
export ZSH="${ZSH:-$HOME/.oh-my-zsh}"
[ -s "$ZSH/oh-my-zsh.sh" ] && source "$ZSH/oh-my-zsh.sh"

# Ensure powerlevel10k theme is sourced if present in custom themes (robustness)
if [ -f "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k/powerlevel10k.zsh-theme" ]; then
  source "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k/powerlevel10k.zsh-theme"
fi

# fzf: keybindings + completion (if installed)
[ -f "$HOME/.fzf/shell/key-bindings.zsh" ] && source "$HOME/.fzf/shell/key-bindings.zsh"
[ -f "$HOME/.fzf/shell/completion.zsh" ] && source "$HOME/.fzf/shell/completion.zsh"

# Lazy-load fast-syntax-highlighting (preferred) or fallback to zsh-syntax-highlighting
if [ -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting" ]; then
  source "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"
elif [ -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
  source "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

# zsh-autosuggestions
if [ -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
  source "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

# Prompt: prefer powerlevel10k if present
[ -f "$HOME/.p10k.zsh" ] && source "$HOME/.p10k.zsh"

# Add local bin
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"

# zcompile to speed startup (best-effort)
if command -v zcompile >/dev/null 2>&1; then
  zcompile -u "$HOME/.zshrc" 2>/dev/null || true
fi
EOF
}

if [ "$DRY_RUN" -eq 1 ]; then
  echo "[DRY] write_zshrc to $ZSHRC"
else
  write_zshrc "$ZSHRC"
  echo "Wrote $ZSHRC (existing backed up if present)"

  # Quick non-interactive check: can powerlevel10k initialize?
  if zsh -i -c 'source "$HOME/.zshrc" >/dev/null 2>&1; typeset -f prompt_powerlevel10k >/dev/null 2>&1' >/dev/null 2>&1; then
    echo "powerlevel10k initialized successfully (non-interactive check)"
  else
    echo "powerlevel10k did not initialize non-interactively; applying fallback theme"
    if grep -q '^ZSH_THEME=' "$ZSHRC"; then
      sed -i 's/^ZSH_THEME=.*/ZSH_THEME="robbyrussell"/' "$ZSHRC"
    else
      echo 'ZSH_THEME="robbyrussell"' >> "$ZSHRC"
    fi
    # Ensure a simple, readable PROMPT for non-interactive fallback
    if ! grep -q '^export PROMPT=' "$ZSHRC"; then
      echo 'export PROMPT="%n@%m:%~ %# "' >> "$ZSHRC"
    fi
  fi
fi

cat <<'EOF'
Done.
Next steps:
  To start using zsh in this session, run:
    exec zsh -l
  Or open a new terminal which will start zsh.

  After starting zsh, verify with:
    echo "$ZSH_VERSION"; type fzf; type zsh-autosuggestions

  If you prefer the installer to launch zsh for you, re-run this script with the
  environment variable NO_AUTO_ZSH unset (the script will prompt to launch zsh).
EOF

# If running in an interactive terminal and not already in zsh, offer to switch now.
# Skip this auto-launch in CI or when NO_AUTO_ZSH=1 is set. To force automatic launch
# without prompt set AUTO_ZSH=1 in the environment when invoking the script.
if [ -t 1 ] && [ -z "${CI-}" ] && [ -z "${NO_AUTO_ZSH-}" ] ; then
  if [ -z "${ZSH_VERSION-}" ]; then
    # If caller requested automatic switch, do it without prompting
    if [ "${AUTO_ZSH-0}" = "1" ]; then
      exec zsh -l
    fi

    printf "\nLaunch zsh now? [y/N] "
    # read input from the controlling terminal to be safe when STDIN is redirected
    if read -r REPLY </dev/tty; then
      case "$REPLY" in
        ''|[Yy]*) exec zsh -l ;;
        *) echo "Skipping launching zsh." ;;
      esac
    else
      echo "\nNo TTY available; not launching zsh. Run 'exec zsh -l' to start zsh." 
    fi
  fi
fi
