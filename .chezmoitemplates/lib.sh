# 共通ヘルパ。各スクリプト冒頭の template 呼び出しでここが展開される。
set -euo pipefail

trap 'printf "\033[1;31mFAIL\033[0m %s:%s: %s\n" "${BASH_SOURCE[0]##*/}" "$LINENO" "$BASH_COMMAND" >&2' ERR

log()  { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
skip() { printf '\033[1;33m--\033[0m  %s\n' "$*"; }

# Homebrew を PATH に載せる(Apple Silicon 前提)。
load_brew() {
  command -v brew >/dev/null 2>&1 && return 0
  [[ -x /opt/homebrew/bin/brew ]] || return 1
  eval "$(/opt/homebrew/bin/brew shellenv)"
}
