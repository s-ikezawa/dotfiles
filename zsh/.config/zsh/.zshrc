SHELL_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/shell"

[ -f "$SHELL_CONFIG/aliases.sh" ] && source "$SHELL_CONFIG/aliases.sh"

# EDITOR=nvim/vim でも zsh のキーバインドは emacs モードを維持
bindkey -e

# --- ヒストリ ---
HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history"
HISTSIZE=10000            # メモリ上に保持する履歴数
SAVEHIST=10000            # ファイルに保存する履歴数
setopt HIST_IGNORE_DUPS   # 直前と同じコマンドを記録しない
setopt HIST_IGNORE_SPACE  # 先頭がスペースのコマンドを記録しない
setopt HIST_REDUCE_BLANKS # 余分な空白を除去して記録
setopt SHARE_HISTORY      # セッション間で履歴を共有

# ヒストリファイルの親ディレクトリを自動作成
[[ -d "${HISTFILE:h}" ]] || mkdir -p "${HISTFILE:h}"

# --- ディレクトリ移動 ---
setopt AUTO_CD            # ディレクトリ名だけで cd
setopt AUTO_PUSHD         # cd 時に自動で pushd
setopt PUSHD_IGNORE_DUPS  # pushd で重複を積まない

# --- プラグイン (sheldon) ---
eval "$(sheldon source)"

# --- 補完 ---
autoload -Uz compinit

# 補完キャッシュを XDG_CACHE_HOME に配置
_zcompdump="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump"
[[ -d "${_zcompdump:h}" ]] || mkdir -p "${_zcompdump:h}"
compinit -d "$_zcompdump"
unset _zcompdump

setopt COMPLETE_IN_WORD   # カーソル位置で補完
setopt ALWAYS_TO_END      # 補完後カーソルを末尾へ移動

# 補完メニューを有効化
zstyle ':completion:*' menu select
# 補完候補をグループ表示
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'
# 大文字小文字を無視して補完
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
# 補完キャッシュを有効化
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/compcache"

# --- その他 ---
setopt INTERACTIVE_COMMENTS  # コマンドラインで # 以降をコメントとして扱う
setopt NO_BEEP               # ビープ音を無効化

# --- 外部ツール ---
eval "$(mise activate zsh)"
eval "$(zoxide init zsh)"
