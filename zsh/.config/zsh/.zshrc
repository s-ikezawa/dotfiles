# ~/.config/zsh/.zshrc
# Zsh configuration file following XDG Base Directory Specification

# History settings
HISTFILE="$XDG_STATE_HOME/zsh/history"
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_SAVE_NO_DUPS
setopt HIST_VERIFY
setopt SHARE_HISTORY

# Ensure history directory exists
[[ ! -d "$(dirname "$HISTFILE")" ]] && mkdir -p "$(dirname "$HISTFILE")"

# Change directory options
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS

# Completion settings
setopt COMPLETE_IN_WORD
setopt ALWAYS_TO_END

# Basic aliases
alias ls='ls -G'
alias ll='ls -la'
alias la='ls -la'
alias grep='grep --color=auto'

# Load zsh-completions if available
if [[ -d "/opt/homebrew/share/zsh-completions" ]]; then
    fpath=("/opt/homebrew/share/zsh-completions" $fpath)
fi

# Enable completion system
autoload -Uz compinit
compinit -d "$XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION"
