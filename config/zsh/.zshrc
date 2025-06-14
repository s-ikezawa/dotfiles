# ~/.config/zsh/.zshrc
# XDG Base Directory Specificationに従ったZsh設定ファイル

# 履歴設定
HISTFILE="$XDG_STATE_HOME/zsh/history"
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_SAVE_NO_DUPS
setopt HIST_VERIFY
setopt SHARE_HISTORY

# 履歴ディレクトリが存在することを確認
[[ ! -d "$(dirname "$HISTFILE")" ]] && mkdir -p "$(dirname "$HISTFILE")"

# ディレクトリ変更オプション
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS

# 補完設定
setopt COMPLETE_IN_WORD
setopt ALWAYS_TO_END

# 基本的なエイリアス
alias ls='ls -G'
alias ll='ls -la'
alias la='ls -la'
alias grep='grep --color=auto'
alias vim='nvim'

# zsh-completionsが利用可能な場合は読み込み
if [[ -d "/opt/homebrew/share/zsh-completions" ]]; then
    fpath=("/opt/homebrew/share/zsh-completions" $fpath)
fi

# 補完システムを有効化
autoload -Uz compinit
compinit -d "$XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION"

# miseの初期化（プログラミング言語バージョン管理）
if command -v mise >/dev/null 2>&1; then
    # miseのシェル統合を有効化
    eval "$(mise activate zsh)"
fi
# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/s-ikezawa/.docker/completions $fpath)
autoload -Uz compinit
compinit
# End of Docker CLI completions
