#!/bin/bash
INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // .tool.input.command // empty' 2>/dev/null)

if echo "$COMMAND" | grep -qE '(^|[|;& ])find '; then
  cat >&2 <<'EOF'
`find` is not allowed. Use `fd` instead — it respects .gitignore and is faster.
- To search normally:           fd <pattern>
- To include hidden/dot files:  fd --hidden <pattern>   (required for .env, .npmrc, etc.)
- To include ignored files too: fd --hidden --no-ignore <pattern>
EOF
  exit 2
fi

if echo "$COMMAND" | grep -qE '(^|[|;& ])grep '; then
  cat >&2 <<'EOF'
`grep` is not allowed. Use `rg` (ripgrep) instead — it respects .gitignore and is faster.
- To search normally:           rg <pattern>
- To include hidden/dot files:  rg --hidden <pattern>   (required for .env, .npmrc, etc.)
- To include ignored files too: rg --hidden --no-ignore <pattern>
EOF
  exit 2
fi

exit 0
