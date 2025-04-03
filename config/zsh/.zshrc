# Created by `pipx` on 2025-04-02 04:53:45
export PATH="$PATH:/Users/s-ikezawa/.local/bin"

# 重複したPATHを削除する
typeset -U PATH

# completion
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
fi

autoload -Uz compinit
compinit -d $XDG_CACHE_HOME/zsh/zcompdump

# eval
eval "$(mise activate zsh)"
eval "$(starship init zsh)"

