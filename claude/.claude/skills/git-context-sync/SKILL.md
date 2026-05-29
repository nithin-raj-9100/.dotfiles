---
name: git-context-sync
description: >
  Syncs Claude with the current state of a git repository by reading staged and unstaged changes,
  then loading the full contents of every changed file into context. Use this skill whenever the user
  says things like "sync up with my repo", "catch up on my changes", "look at what I've been working on",
  "review my recent changes", "get up to speed", "context sync", "what's changed", or any request that
  implies Claude should understand the current state of in-progress work before starting a new task.
  Also trigger when a user starts a new conversation about an existing project and wants Claude oriented
  before diving in, or when they say "let's continue where I left off" in a coding context. Even casual
  phrasing like "here's my repo, take a look" or "check out what I've done so far" should trigger this skill.
---

# Git Context Sync

Build a full picture of the user's in-progress work by inspecting git state and reading changed files.
This gives Claude the context it needs to immediately assist with whatever comes next — code reviews,
continuation of work, debugging, refactoring, writing tests, etc.

## Workflow

### Step 1: Verify git repository

Run `git rev-parse --is-inside-work-tree` to confirm we're in a git repo. If not, ask the user for the
repo path or let them know the current directory isn't a git repository.

### Step 2: Gather change summary

Run these commands and capture the output:

```bash
# Branch and recent commit context
git branch --show-current
git log --oneline -5

# Staged changes (files + diff)
git diff --cached --stat
git diff --cached --name-status

# Unstaged changes (files + diff)
git diff --stat
git diff --name-status

# Untracked files (new files not yet added)
git ls-files --others --exclude-standard
```

### Step 3: Categorize and present the change overview

Before reading files, present a concise summary to the user organized into three buckets:

1. **Staged** — files in the index, ready to commit
2. **Unstaged** — tracked files with modifications not yet staged
3. **Untracked** — new files not yet tracked by git

For each file, show the status (added/modified/deleted/renamed) and the path.

Also mention the current branch and the last few commit messages to orient around recent work direction.

### Step 4: Read changed files into context

Read the **full contents** of every changed file (staged + unstaged + untracked) so that Claude has
deep context, not just diffs. Use the `view` tool or `cat` for each file.

Important guidelines for this step:

- **Skip deleted files** — they no longer exist on disk.
- **Skip binary files** — images, compiled assets, lock files, etc. Mention them but don't try to read them.
- **Skip large generated files** — anything in `node_modules/`, `dist/`, `build/`, `.next/`, `__pycache__/`,
  `vendor/`, or common lock files (`package-lock.json`, `yarn.lock`, `pnpm-lock.yaml`, `Gemfile.lock`,
  `poetry.lock`, `Cargo.lock`). Mention them in the summary as skipped.
- **Cap per-file read** — if a file is longer than 500 lines, read the first 200 and last 100 lines,
  noting the truncation. For most source files this won't be an issue.
- **Read diffs too** — after reading the full file, also show the relevant diff hunks
  (`git diff --cached -- <file>` for staged, `git diff -- <file>` for unstaged) so it's clear what
  exactly changed vs. what was already there.

### Step 5: Read the diffs for detailed change context

After loading file contents, display the actual diffs to understand *what* changed:

```bash
# Staged diff (what will be committed)
git diff --cached

# Unstaged diff (working directory changes)
git diff
```

This is important because file contents alone don't tell Claude which parts are new or modified.

### Step 6: Synthesize and brief

After loading everything, provide the user with a structured briefing:

- **Branch & recent direction**: What branch they're on and what the last few commits suggest about the work direction.
- **What's staged**: A narrative summary of the staged changes — what they accomplish together, not just a file list.
- **What's in progress**: A narrative summary of unstaged changes — what seems to be actively being worked on.
- **New files**: What new (untracked) files exist and what they appear to be for.
- **Potential next steps**: Based on the patterns seen (e.g., half-finished feature, test files missing, TODOs in the diff), suggest what the user might want to do next.

End with something like: "I'm up to speed — what would you like to work on?"

## Edge cases

- **No changes at all**: If working tree is clean and nothing is staged, let the user know. Offer to look at recent commits instead (`git log --oneline -10` and `git diff HEAD~3..HEAD`).
- **Merge conflicts**: If `git diff` shows conflict markers, flag those files prominently and offer to help resolve them.
- **Very large changesets** (>30 files): Read only the most important-looking files (source code over config, application code over tests) and summarize the rest. Let the user know some files were skimmed and offer to dive deeper into specific ones.
- **Detached HEAD**: Note this and show the commit hash instead of a branch name.
- **Submodules**: Note any submodule changes but don't recurse into them unless asked.

## Tone

Be practical and direct. The user wants Claude oriented and ready to work, not a verbose walkthrough of
every git command being run. Run the commands, read the files, and deliver the briefing efficiently.
