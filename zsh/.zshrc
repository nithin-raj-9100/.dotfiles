export ZSH="$HOME/.oh-my-zsh"

DISABLE_UNTRACKED_FILES_DIRTY="true"

plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

alias ls='eza --icons'
alias l='eza -l --icons'
alias la='eza -la'
alias lt='eza --tree --git-ignore --icons'
alias ll='eza -l -g --icons --git'
alias lg='lazygit'
alias ff="fzf --preview 'bat --color=always --style=numbers --line-range=:500 {}' | xargs nvim"
alias c='clear'
alias cat='bat --paging=never'
alias s='source ~/.zshrc'
alias e='exit'
alias ce='claude'
alias n='nvim'
alias vim='nvim'
alias a='alias'
alias pn='pnpm'
alias oc='opencode'
alias zedit='nvim ~/.zshrc'
alias rm='trash'
alias md='mkdir -p'
alias bd="bun dev"
alias pd="pnpm dev"
alias cx='codex'

eval "$(starship init zsh)"
export PATH="$HOME/.local/bin:$PATH"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_STATE_HOME="$HOME/.local/state"
export MISE_SHELL=zsh
if [ -z "${__MISE_ORIG_PATH:-}" ]; then
  export __MISE_ORIG_PATH="$PATH"
fi
export __MISE_ZSH_PRECMD_RUN=0

mise() {
  local command
  command="${1:-}"
  if [ "$#" = 0 ]; then
    command "$HOME/.local/bin/mise"
    return
  fi
  shift

  case "$command" in
  deactivate|shell|sh)
    # if argv doesn't contains -h,--help
    if [[ ! " $@ " =~ " --help " ]] && [[ ! " $@ " =~ " -h " ]]; then
      eval "$(command "$HOME/.local/bin/mise" "$command" "$@")"
      return $?
    fi
    ;;
  esac
  command "$HOME/.local/bin/mise" "$command" "$@"
}

_mise_hook() {
  eval "$("$HOME/.local/bin/mise" hook-env -s zsh)";
}
_mise_hook_precmd() {
  eval "$("$HOME/.local/bin/mise" hook-env -s zsh --reason precmd)";
}
_mise_hook_chpwd() {
  eval "$("$HOME/.local/bin/mise" hook-env -s zsh --reason chpwd)";
}
typeset -ag precmd_functions;
if [[ -z "${precmd_functions[(r)_mise_hook_precmd]+1}" ]]; then
  precmd_functions=( _mise_hook_precmd ${precmd_functions[@]} )
fi
typeset -ag chpwd_functions;
if [[ -z "${chpwd_functions[(r)_mise_hook_chpwd]+1}" ]]; then
  chpwd_functions=( _mise_hook_chpwd ${chpwd_functions[@]} )
fi

_mise_hook
if [ -z "${_mise_cmd_not_found:-}" ]; then
    _mise_cmd_not_found=1
    [ -n "$(declare -f command_not_found_handler)" ] && eval "${$(declare -f command_not_found_handler)/command_not_found_handler/_command_not_found_handler}"

    function command_not_found_handler() {
        if [[ "$1" != "mise" && "$1" != "mise-"* ]] && "$HOME/.local/bin/mise" hook-not-found -s zsh -- "$1"; then
          _mise_hook
          "$@"
        elif [ -n "$(declare -f _command_not_found_handler)" ]; then
            _command_not_found_handler "$@"
        else
            echo "zsh: command not found: $1" >&2
            return 127
        fi
    }
fi

# fzf key bindings and completion
eval "$(fzf --zsh)"
eval "$(zoxide init zsh)"

# opencode
export PATH="$HOME/.opencode/bin:$PATH"

# Added by Antigravity
export PATH="$HOME/.antigravity/antigravity/bin:$PATH"

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

export JAVA_HOME=/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home

export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools

# --- Custom Functions --- #
# Automatically attach to or create a tmux session named after the current directory.
function t(){
  local session_name=$(basename "$PWD" | tr '.' '-')
  if ! tmux has-session -t="$session_name" 2>/dev/null; then
    tmux new-session -d -s "$session_name"
  fi
  if [ -z "$TMUX" ]; then
    tmux attach-session -t "$session_name"
  else
    tmux switch-client -t "$session_name"
  fi
}

function cds () {
  if [[ "$TMUX" ]]; then
    session=$(tmux display-message -p "#{session_path}")
    cd "$session"
  else
    echo "Runs only inside Tmux"
  fi
}
export EDITOR=nvim

# Vite+ bin (https://viteplus.dev)
. "$HOME/.vite-plus/env"
