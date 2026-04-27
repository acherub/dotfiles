#!/usr/bin/env bash
# tmux.start.sh — start default tmux session and split layout
SESSION=work
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
tmux new-session -d -s "$SESSION" -n "$WINDOW"
# Start editor in the first pane
tmux send-keys -t "$SESSION:$WINDOW" 'cd ~/projects 2>/dev/null || true; ${EDITOR:-vim}' C-m
# Split horizontally and start shell on the right
tmux split-window -h -t "$SESSION:$WINDOW"
# Further split the left pane vertically (create bottom pane)
# Note: pane indexes may vary between tmux versions; select the left pane then split vertically
tmux select-pane -t "$SESSION:$WINDOW".0
tmux split-window -v -t "$SESSION:$WINDOW".0

# Add a window named 'logs' and tail system log
tmux new-window -t "$SESSION" -n logs
tmux send-keys -t "$SESSION:logs" 'tail -f /var/log/syslog 2>/dev/null || bash' C-m

# Switch back to editor window and select the first pane
tmux select-window -t "$SESSION:$WINDOW"
# attach session
tmux attach -t "$SESSION"
