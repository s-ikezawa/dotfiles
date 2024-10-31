# XDG Base Directory
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share
export XDG_STATE_HOME=$HOME/.local/state

# Golang
export GOPATH=$XDG_DATA_HOME/go
export GOBIN=$GOPATH/bin
export PATH=$PATH:$GOBIN

# libpq
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"

# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# mise
if type mise &>/dev/null; then
  eval "$(mise activate zsh --shims)"
fi

# zoxide
if type zoxide &>/dev/null; then
  eval "$(zoxide init zsh)"
fi

# fzf
if type fzf &>/dev/null; then
  source <(fzf --zsh)
fi
