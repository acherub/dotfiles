# Copilot instructions for acherub's dotfiles

Purpose
- Repo of personal dotfiles and helper scripts. Files in the repo are intended to be symlinked into $HOME by the install script.

Build / test / lint commands
- No build or test suite in this repo.
- Installation: clone then run:
  ./install.sh [--force|-f] [--no-backup] [--dry-run|-n]
  - --dry-run / -n: preview only (recommended before real run)
  - Backups (by default) are saved to: ~/dotfiles_backup_<TIMESTAMP>
- Linting shell scripts: use shellcheck (installed from Brewfile):
  shellcheck install.sh
- Brewfile checks (mac provisioning):
  brew update
  brew bundle check --file=Brewfile
  brew bundle install --file=Brewfile
  (manually inspect Brewfile before installing; it includes older formulas like openssl@1.1)
- Start tmux layout (non-attaching wrapper):
  ./tmux.start.wrapper.sh
  or run tmux.start.sh for interactive attach behavior.

High-level architecture
- Single-directory dotfiles repository whose install.sh:
  - enumerates a files array and creates symlinks from repo files to $HOME (see install.sh lines where files=(...)).
  - when a target exists, it is backed up (unless --no-backup) and optionally overwritten with --force.
  - copies .gitconfig to $HOME if present in repo.
- Vim customization:
  - environment.vim sets g:env and contains plugin/theme notes. README.md documents plugins and key mappings.
- tmux helpers:
  - tmux.start.sh builds a named session (SESSION=work) with a predictable multi-pane layout and a logs window; wrapper starts it without attaching.
- Mac provisioning via Brewfile:
  - Brewfile lists lots of packages, casks, and VSCode extensions. Treat it as an opinionated provisioning script; review before running.

Key conventions and repo-specific patterns
- Symlink-first model: install.sh makes symlinks from repo files to $HOME. The canonical list of dotfiles is in install.sh's files array — update that array if adding/removing dotfiles.
- Backup behavior: existing files are moved to ~/dotfiles_backup_<TIMESTAMP> unless --no-backup is used.
- .extra is intentionally excluded (sensitive local config). A template file .extra.example exists in the repo — keep secrets out of the repo and put local credentials in ~/.extra.
- .gitconfig handling: if .gitconfig exists in the repo it is copied rather than symlinked; be deliberate about committing .gitconfig.
- Editor/ENV detection: environment.vim sets g:env using uname; do not rely on system-specific assumptions without checking environment.vim.
- tmux session naming: default session name is "work"; scripts assume that name when checking/attaching.

Where to look for more context
- README.md: contains most usage notes and Vim keybindings; copy important, non-sensitive additions here.
- install.sh: canonical behavior for installing and backing up dotfiles (single place to update when files change).
- Brewfile: machine provisioning list — review before running on different macOS versions.

AI & assistant config files
- No special AI assistant config files detected (e.g., CLAUDE.md, AGENTS.md, .cursorrules, .windsurfrules, CONVENTIONS.md). If adding assistant-specific config, put it in the repo root or .github and reference it here.

Notes for Copilot sessions
- Prefer reading install.sh first to learn which files are managed and the default behaviors (backup, force, dry-run).
- When suggesting changes that affect $HOME (e.g., adding new dotfiles), mention the need to update install.sh's files array and README.md.
- If proposing package changes in Brewfile, flag potentially deprecated formulas (openssl@1.1, older python versions) and recommend maintaining a short note in Brewfile about rationale.

Repository safety reminders (pulled from README):
- Do not commit personal credentials or private settings. Use local files (e.g., ~/.extra) and keep example templates in the repo.

---
(Synthesized from README.md, install.sh, environment.vim, tmux.start.sh, tmux.start.wrapper.sh, and Brewfile.)

Commit message conventions
- Title: keep the first line at most 50 characters (recommended: exactly 50 characters when possible)
- Body: wrap lines at 72 characters or less
- Include the Co-authored-by trailer when Copilot contributes:
  Co-authored-by: Copilot <223556219+Copilot@users.noreply.github.com>

To enable automatic checking in your local clone, set the hooks path:
  git config core.hooksPath .githooks

This repo includes .githooks/commit-msg which rejects titles >50 chars or body lines >72 chars.
