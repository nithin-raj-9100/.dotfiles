#!/bin/bash
INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // .tool.input.command // empty' 2>/dev/null)

if echo "$COMMAND" | grep -qE '(^|[|;& ])sed '; then
  echo "sed is not allowed. Use the native Read tool to read file contents instead of sed." >&2
  exit 2
fi
exit 0
