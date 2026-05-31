# .dotfiles

Personal macOS configuration for my CLI tools, editor, terminal and packages.
Managed with [GNU Stow](https://www.gnu.org/software/stow/) so every config
lives in this single git repo while still being symlinked into the locations
each tool expects (mostly `$HOME` and `$HOME/.config`).

> **For future me / any AI agent (Claude Code, Codex, etc.):** this repo is the
> source of truth for my setup. The section [Restoring on a new machine](#restoring-on-a-new-machine)
> tells you exactly how to get the whole environment back.

## How it works (Stow)

This repo lives at `~/.dotfiles`. Each top-level folder is a **Stow package**.
The directory structure *inside* a package mirrors where the files should land
in `$HOME`. Running `stow <package>` from `~/.dotfiles` creates symlinks from
`$HOME` back into this repo, so editing a file here = editing the live config.

Example: `git/.gitconfig` → symlinked to `~/.gitconfig`, and
`nvim/.config/nvim/` → symlinked to `~/.config/nvim/`.

## Packages

| Package     | Tool                | Symlinked to                          |
| ----------- | ------------------- | ------------------------------------- |
| `zsh`       | Zsh shell           | `~/.zshrc`                            |
| `git`       | Git                 | `~/.gitconfig`, `~/.gitignore_global`, `~/.gitconfig-personal`, `~/.gitconfig-work` |
| `nvim`      | Neovim (LazyVim)    | `~/.config/nvim/`                     |
| `tmux`      | tmux                | `~/.tmux.conf`                        |
| `ghostty`   | Ghostty terminal    | `~/.config/ghostty/config`            |
| `karabiner` | Karabiner-Elements  | `~/.config/karabiner/karabiner.json`  |
| `lazygit`   | LazyGit             | `~/.config/lazygit/config.yml`        |
| `mise`      | mise (runtime mgr)  | `~/.config/mise/config.toml`          |
| `gh`        | GitHub CLI          | `~/.config/gh/`                       |
| `claude`    | Claude Code         | `~/.claude/` (CLAUDE.md, settings, hooks, skills) |

## How tools are installed (the mix)

Packages are split across three installers on purpose — Homebrew is slow to
publish latest versions for fast-moving CLIs, so those live in mise instead:

| Installer  | Source of truth                     | What it manages |
| ---------- | ----------------------------------- | --------------- |
| **Homebrew** | `Brewfile`                          | System libs, native deps, GUI casks (ghostty, karabiner, postgresql, imagemagick, watchman…) and a few stable CLIs (eza, stow, trash) |
| **mise**     | `mise/.config/mise/config.toml`     | Fast-moving CLI tools + language runtimes: bat, fd, fzf, gh, lazygit, neovim, ripgrep, tmux, node, pnpm, codex, gemini, jq, delta… **plus global npm CLIs** (vercel, eas-cli, @shopify/cli, copilot…) via the `npm:` backend, so they survive node upgrades |
| **curl**     | install scripts (below)             | [starship](https://starship.rs) prompt, [bun](https://bun.sh) |

- `Brewfile` — regenerate with `brew bundle dump --file=Brewfile --force`.
- `mise/.config/mise/config.toml` — add a tool with `mise use -g <tool>@latest`
  (it edits this file, which is stowed and committed).

The shell (`zsh/.zshrc`) assumes these exist: zsh + starship prompt, mise
(node/bun/pnpm), neovim (LazyVim), ghostty, tmux, the CLI replacements
eza (`ls`) / bat (`cat`) / fzf / fd / ripgrep (`rg`) / trash (`rm`) / zoxide,
git tooling (git, lazygit, gh), and AI tools (claude, codex, gemini).

## Restoring on a new machine

Run these steps in order. (An agent can execute them directly.)

```sh
# 1. Install Homebrew (if missing)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 2. Install mise (runtime + CLI tool manager)
brew install mise

# 3. Set up an SSH key for GitHub, then clone this repo to ~/.dotfiles
#    (remote uses an SSH host alias "github.com-personal" -> see note below)
git clone git@github.com-personal:nithin-raj-9100/.dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# 4. Symlink every package into place FIRST, so the mise config is in position.
#    If a real file already exists stow will refuse — move/delete it, then re-run.
stow zsh git nvim tmux ghostty karabiner lazygit mise gh claude

# 5. Brew-managed packages (system libs + GUI casks)
brew bundle --file=~/.dotfiles/Brewfile

# 6. mise-managed CLI tools + runtimes (reads the now-stowed config.toml)
mise install

# 7. curl-installed tools not covered by brew/mise
curl -sS https://starship.rs/install.sh | sh
curl -fsSL https://bun.sh/install | bash

# 8. Reload the shell
exec zsh
```

### SSH host alias note

The git remote uses a custom SSH host alias `github.com-personal` (so multiple
GitHub identities can coexist). Add this to `~/.ssh/config`:

```sshconfig
Host github.com-personal
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519_personal
```

Generate the key with `ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519_personal`
and add the public key to GitHub. If you'd rather use the default
`git@github.com:...` remote, update it with `git remote set-url origin ...`.

## Adding / removing config

```sh
cd ~/.dotfiles

# add a new tool's config: create pkg/.config/<tool>/... then
stow <package>

# remove a package's symlinks
stow -D <package>

# restow after moving files around
stow -R <package>
```

Because everything is symlinked, just edit files in `~/.dotfiles` (or via the
live path) and `git commit && git push` to back them up.
