#!/usr/bin/env bash
# tmux.start.sh — start default tmux session and split layout
SESSION="work"
WINDOW=editor
NOATTACH=0
if [ "${1-}" = "--no-attach" ]; then
  NOATTACH=1
fi

# If session exists attach directly
if tmux has-session -t "$SESSION" 2>/dev/null; then
  if [ "$NOATTACH" -eq 0 ]; then
    tmux attach -t "$SESSION"
  fi
  exit 0
fi

# Create new session
# Start with a detached session; panes will be explicitly spawned and then
# replaced with login zsh shells so tmux panes use zsh regardless of $SHELL.
tmux new-session -d -s "$SESSION" -n "$WINDOW"

# Create the layout (no commands yet)
# Create right split
tmux split-window -h -t "$SESSION:$WINDOW"
# Create bottom split in left pane (pane 0)
tmux select-pane -t "$SESSION:$WINDOW".0
tmux split-window -v -t "$SESSION:$WINDOW".0

# Ensure each pane runs login zsh (replace whatever was in the pane)
for pane in 0 1 2; do
  tmux send-keys -t "$SESSION:$WINDOW"."$pane" 'export SHELL="$(command -v zsh)"; exec "$(command -v zsh)" -l' C-m
done

# Give shells a moment to start (tmux schedules commands quickly)
sleep 0.1

# Start editor in the first pane (now running zsh)
# Use export in editor pane too to ensure $SHELL is zsh inside the pane
tmux send-keys -t "$SESSION:$WINDOW".0 'export SHELL="$(command -v zsh)"; cd ~/projects 2>/dev/null || true; ${EDITOR:-vim}' C-m

# Add a window named 'logs' and tail system log (fallback to zsh)
tmux new-window -t "$SESSION" -n logs
tmux send-keys -t "$SESSION:logs" 'exec "$(command -v zsh)" -l' C-m

# Switch back to editor window and select the first pane
tmux select-window -t "$SESSION:$WINDOW"
# attach session
tmux attach -t "$SESSION"
