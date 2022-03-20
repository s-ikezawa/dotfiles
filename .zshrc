# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

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

# theme(powerlevel10k)
source $(brew --prefix)/opt/powerlevel10k/powerlevel10k.zsh-theme
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# lima + docker
export DOCKER_HOST=unix://$HOME/.lima/docker/sock/docker.sock
