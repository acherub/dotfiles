# Commit message conventions

This repository follows concise commit message conventions to keep history readable.

- Title: keep the first line at most 50 characters (recommended: 50 chars)
- Body: wrap lines at 72 characters or less
- When Copilot contributes to a commit, include the Co-authored-by trailer exactly as:
  Co-authored-by: Copilot <223556219+Copilot@users.noreply.github.com>

Enabling Git hook to enforce these rules (optional):
1. Set hooks path in your clone: git config core.hooksPath .githooks
2. The repository includes .githooks/commit-msg which enforces <=50/<=72.

If you prefer stricter rules (exact lengths instead of maxima), edit .githooks/commit-msg accordingly.
