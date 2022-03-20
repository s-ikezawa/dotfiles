# 履歴ファイルの保存先
export HISTFILE=${HOME}/.zsh_history

# メモリに保存される履歴の件数
export HISTSIZE=1000

# 履歴ファイルに保存される履歴の件数
export SAVEHISTFILE=100000

# 重複する履歴は記録しない
setopt hist_ignore_dups

# 履歴に追加されるコマンドが古いものと同じであれば古いものを削除
setopt hist_ignore_all_dups

# 余分な余白は詰めて記録
setopt hist_reduce_blanks

# 自動補完
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
