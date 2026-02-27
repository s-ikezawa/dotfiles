SHELL_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/shell"

[ -f "$SHELL_CONFIG/aliases.sh" ] && source "$SHELL_CONFIG/aliases.sh"

# EDITOR=nvim/vim でも zsh のキーバインドは emacs モードを維持
bindkey -e

eval "$(mise activate zsh)"
eval "$(zoxide init zsh)"

