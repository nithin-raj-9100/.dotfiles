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
| `claude`    | Claude Code         | `~/.claude/` (CLAUDE.md, settings, hooks) |

## Tools I rely on

Installed via [Homebrew](https://brew.sh). The shell (`zsh/.zshrc`) assumes
these exist:

- **Shell/prompt:** zsh, [starship](https://starship.rs)
- **Runtime manager:** [mise](https://mise.jdx.dev) (node, bun, pnpm, etc.)
- **Editor:** neovim (LazyVim distro)
- **Terminal:** ghostty
- **Multiplexer:** tmux
- **CLI replacements:** eza (`ls`), bat (`cat`), fzf, fd, ripgrep (`rg`), trash (`rm`), zoxide
- **Git tooling:** git, lazygit, gh
- **Package managers:** bun, pnpm
- **AI tools:** claude (Claude Code), codex, opencode
- **Keyboard:** karabiner-elements

## Restoring on a new machine

Run these steps in order. (An agent can execute them directly.)

```sh
# 1. Install Homebrew (if missing)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 2. Install stow + the core tools used by the configs
brew install stow starship mise neovim tmux \
  eza bat fzf fd ripgrep trash zoxide \
  lazygit gh bun pnpm
brew install --cask ghostty karabiner-elements

# 3. Set up an SSH key for GitHub, then clone this repo to ~/.dotfiles
#    (remote uses an SSH host alias "github.com-personal" -> see note below)
git clone git@github.com-personal:nithin-raj-9100/.dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# 4. Symlink every package into place.
#    --adopt is NOT used; if a real file already exists stow will refuse —
#    move/delete the conflicting file first, then re-run.
stow zsh git nvim tmux ghostty karabiner lazygit mise gh claude

# 5. Reload the shell
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
