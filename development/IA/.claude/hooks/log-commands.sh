#!/usr/bin/env bash
# PostToolUse hook — logs every Bash command Claude runs to an audit log.

set -euo pipefail

LOG_DIR="$HOME/.claude/logs"
LOG_FILE="$LOG_DIR/command-audit.log"

mkdir -p "$LOG_DIR"

INPUT=$(cat)

COMMAND=$(echo "$INPUT" | python3 -c "
import sys, json
data = json.load(sys.stdin)
print(data.get('tool_input', {}).get('command', ''))
" 2>/dev/null || echo "unknown")

TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
echo "[$TIMESTAMP] $COMMAND" >> "$LOG_FILE"

exit 0