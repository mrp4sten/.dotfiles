#!/usr/bin/env bash
# Fires on Stop event — notifies when Claude finishes a task.
# Works on Arch Linux with libnotify + a running notification daemon (dunst, mako, etc.)

set -euo pipefail

# Read JSON input from stdin (Claude Code passes session context)
INPUT=$(cat)

# Extract the session ID if available (for context)
SESSION=$(echo "$INPUT" | grep -o '"session_id":"[^"]*"' | cut -d'"' -f4 2>/dev/null || echo "session")

notify-send \
  --app-name="Claude Code" \
  --icon=dialog-information \
  --urgency=normal \
  "Claude Code — Done" \
  "Task finished in $SESSION"