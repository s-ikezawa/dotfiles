#=========================================================================
# Alias
#=========================================================================
if type eza &>/dev/null; then
  alias ls='eza -a --icons --git'
  alias ll='eza -al --icons --git'
fi

#=========================================================================
# Original Command
#=========================================================================
# ghq + fzf
function ghq-fzf_change_directory() {
  local src=$(ghq list | fzf --preview "eza -al --icons $(ghq root)/{} tail -n+4 | awk '{print \$6\"/\"\$8\" \"\$9 \" \" \$10}'")
  if [ -n "$src" ]; then
    BUFFER="cd $(ghq root)/$src"
    zle accept-line
  fi
  zle -R -c
}
zle -N ghq-fzf_change_directory
bindkey '^g' ghq-fzf_change_directory

#=========================================================================
# History
#=========================================================================
export HISTFILE=$XDG_DATA_HOME/zsh/history
export HISTSIZE=1000
export SAVEHIST=100000
setopt hist_ignore_dups
setopt share_history
setopt hist_verify
setopt hist_reduce_blanks
setopt hist_save_no_dups
setopt hist_no_store
setopt hist_expand
setopt inc_append_history

#=========================================================================
# Completion
#=========================================================================
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

  autoload -Uz compinit
  compinit -d $XDG_DATA_HOME/zsh/zcompdump
fi

