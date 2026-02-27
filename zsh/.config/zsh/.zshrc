SHELL_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/shell"

[ -f "$SHELL_CONFIG/aliases.sh" ] && source "$SHELL_CONFIG/aliases.sh"

eval "$(mise activate zsh)"
eval "$(zoxide init zsh)"

