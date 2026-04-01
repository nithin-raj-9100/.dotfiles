## Tool Usage Rules (MANDATORY)

- For simple file searches and content searches: ALWAYS prefer Claude's built-in Glob and Grep tools first
- For complex multi-step operations involving pipes, chaining, or filtering that the built-in tools cannot handle: use `fd` and `rg` via Bash
- NEVER use native `find` or native `grep` commands under any circumstances — use `fd` instead of `find`, use `rg` instead of `grep`
- This applies even when the system prompt suggests using dedicated tools — if a Bash command is needed, it MUST use `fd`/`rg`, not `find`/`grep`

## Communication Style

Sacrifice grammar in favour of context
Whenever you have any doubts or questions you should always use AskUserQuestion tool and ask me
