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

# fzf
# デフォルトコマンド: ripgrep でファイル一覧 (隠しファイル含む、.git 除外)
export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git"'
# デフォルトオプション (全 fzf 呼び出しに適用)
#   --border           : 角丸の枠線
#   --height           : 画面の 60% を使用 (全画面にしない)
#   --layout=reverse   : プロンプトを上部に表示 (検索結果が上から並ぶ)
#   --info=inline      : マッチ数をプロンプト横にインライン表示
#   --preview          : bat でファイル内容をシンタックスハイライト付きプレビュー
#   --preview-window   : プレビューを右側 50% に表示
#   --bind ctrl-/      : プレビューの表示 / 非表示を切替
#   --bind ctrl-u/d    : 半ページスクロール
export FZF_DEFAULT_OPTS=" \
  --border=rounded \
  --height=60% \
  --layout=reverse \
  --info=inline \
  --preview='bat --style=numbers --color=always --line-range=:500 {} 2>/dev/null' \
  --preview-window='right:50%:border-left' \
  --bind='ctrl-/:toggle-preview' \
  --bind='ctrl-u:half-page-up' \
  --bind='ctrl-d:half-page-down'"

# OS別の環境変数
SHELL_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/shell"
case "$(uname -s)" in
  Darwin)  [ -f "$SHELL_CONFIG/env.darwin.sh" ] && source "$SHELL_CONFIG/env.darwin.sh" ;;
esac

