# XDG Base Directory
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_CACHE_HOME="${HOME}/.cache"
export XDG_DATA_HOME="${HOME}/.local/share"
export XDG_STATE_HOME="${HOME}/.local/state"

# PATH
export PATH="${HOME}/.local/bin:${PATH}"

SHELL_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/shell"
case "$(uname -s)" in
  Darwin)  [ -f "$SHELL_CONFIG/env.darwin.sh" ] && source "$SHELL_CONFIG/env.darwin.sh" ;;
esac

