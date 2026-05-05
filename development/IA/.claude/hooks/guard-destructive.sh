#!/usr/bin/env bash
# PreToolUse hook — intercepts Bash tool calls and blocks dangerous patterns.
# Exit code 2 = block the command and send error message to Claude.

set -euo pipefail

INPUT=$(cat)

# Extract the command Claude is about to run
COMMAND=$(echo "$INPUT" | python3 -c "
import sys, json
data = json.load(sys.stdin)
print(data.get('tool_input', {}).get('command', ''))
" 2>/dev/null || echo "")

if [[ -z "$COMMAND" ]]; then
  exit 0  # Not a bash command we can parse, allow through
fi

# Patterns to block outright
BLOCKED_PATTERNS=(
  "rm -rf /"
  "rm -rf ~"
  "rm -rf \$HOME"
  "> /etc/"
  "curl.*| *bash"
  "wget.*| *bash"
  "curl.*| *sh"
  "dd if=.*of=/dev/"
  "mkfs\."
  ":(){:|:&};:"   # fork bomb
)

for pattern in "${BLOCKED_PATTERNS[@]}"; do
  if echo "$COMMAND" | grep -qE "$pattern" 2>/dev/null; then
    echo "BLOCKED: Potentially destructive command detected: '$pattern'"
    echo "Command was: $COMMAND"
    exit 2
  fi
done

# Warn (but allow) patterns — these get logged
WARN_PATTERNS=(
  "git push"
  "sudo"
  "chmod 777"
  "eval "
)

for pattern in "${WARN_PATTERNS[@]}"; do
  if echo "$COMMAND" | grep -qE "$pattern" 2>/dev/null; then
    echo "WARNING: Sensitive command pattern detected: $COMMAND" >> ~/.claude/logs/hook-warnings.log
  fi
done

exit 0