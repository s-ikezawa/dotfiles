# XDG Base Directory
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_CACHE_HOME="${HOME}/.cache"
export XDG_DATA_HOME="${HOME}/.local/share"
export XDG_STATE_HOME="${HOME}/.local/state"

# PATH
export PATH="${HOME}/.local/bin:${PATH}"

# Editor (nvim が無ければ vim にフォールバック)
if command -v nvim >/dev/null 2>&1; then
  export EDITOR="nvim"
  export VISUAL="nvim"
else
  export EDITOR="vim"
  export VISUAL="vim"
fi

# Claude Code
export CLAUDE_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/claude"

# Rust
export RUSTUP_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/rustup"
export CARGO_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/cargo"
export PATH="${CARGO_HOME}/bin:${PATH}"

# yazi
source "${CARGO_HOME:-$HOME/.local/share/cargo}/env"

# OS別の環境変数
SHELL_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/shell"
case "$(uname -s)" in
  Darwin)  [ -f "$SHELL_CONFIG/env.darwin.sh" ] && source "$SHELL_CONFIG/env.darwin.sh" ;;
esac

