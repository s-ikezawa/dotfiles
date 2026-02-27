SHELL_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/shell"

[ -f "$SHELL_CONFIG/env.sh" ] && source "$SHELL_CONFIG/env.sh"
[ -f "$SHELL_CONFIG/alias.sh" ] && source "$SHELL_CONFIG/alias.sh"

eval "$(mise activate bash)"
eval "$(zoxide init bash)"

