# Created by `pipx` on 2025-04-02 04:53:45
export PATH="$PATH:/Users/s-ikezawa/.local/bin"

# 重複したPATHを削除する
typeset -U PATH

eval "$(mise activate zsh)"
eval "$(starship init zsh)"

