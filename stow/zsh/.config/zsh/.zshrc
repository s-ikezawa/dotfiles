# ヒストリー設定（XDG対応）
export HISTFILE="$XDG_STATE_HOME/zsh/history" # なぜかMacだとzshrcに書かないと反映されない
HISTSIZE=50000                    # メモリ内の履歴数
SAVEHIST=5000000                  # ファイルに保存する履歴数

# ヒストリーオプション
setopt HIST_EXPIRE_DUPS_FIRST     # 履歴がいっぱいになったら重複を先に削除
setopt HIST_IGNORE_DUPS           # 直前のコマンドと同じなら履歴に追加しない
setopt HIST_IGNORE_ALL_DUPS       # 重複するコマンドは古いものを削除
setopt HIST_IGNORE_SPACE          # スペースで始まるコマンドは履歴に追加しない
setopt HIST_SAVE_NO_DUPS          # 重複するコマンドはファイルに保存しない
setopt HIST_VERIFY                # 履歴展開時に確認
setopt HIST_BEEP                  # 履歴に該当がない場合ビープ音
setopt SHARE_HISTORY              # 複数のzshセッション間で履歴を共有
setopt APPEND_HISTORY             # 履歴をファイルに追記
setopt INC_APPEND_HISTORY         # コマンド実行時に即座に履歴に追加
setopt EXTENDED_HISTORY           # 履歴にタイムスタンプを記録

# compinit設定（XDG準拠）
autoload -Uz compinit

# zcompdumpファイルの場所設定
typeset -g _comp_dumpfile="$XDG_CACHE_HOME/zsh/zcompdump-${ZSH_VERSION}"

# zcompdumpディレクトリが存在しない場合は作成
[[ ! -d "${_comp_dumpfile:h}" ]] && mkdir -p "${_comp_dumpfile:h}"

# セキュリティチェック付きcompinit
if [[ $_comp_dumpfile(#qNmh+24) ]]; then
    # 24時間以上古い場合は再構築
    compinit -d "$_comp_dumpfile"
else
    # キャッシュが新しい場合は高速起動
    compinit -C -d "$_comp_dumpfile"
fi

# Homebrew補完の設定（Homebrewがインストールされている場合）
if command -v brew &> /dev/null; then
    fpath=("$(brew --prefix)/share/zsh/site-functions" $fpath)
fi

#------------------------------------------------------------------------------------------------------
# mise
#------------------------------------------------------------------------------------------------------
if command -v mise &> /dev/null; then
    eval "$(mise activate zsh)"
fi
