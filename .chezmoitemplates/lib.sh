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

# Homebrew が内部で使う Ruby（portable-ruby）を PATH の先頭に置く。
# mise は tap のパッケージ（brew-cask:nikitabobko/tap/aerospace など）を入れるとき、tap の
# レシピ（Casks/*.rb）を PATH にある ruby で読む。これには Ruby 3 以上が要るが、macOS 標準の
# /usr/bin/ruby は 2.6 なので失敗する。portable-ruby は Homebrew の内部の場所なので、
# Homebrew の作りが変わったらここを直すこと。無ければ brew vendor-install で入れる。
# 同じ処理を dot_config/mise/config.toml の [tasks.up] にも書いている。
load_brew_ruby() {
  load_brew || return 1
  local dir
  dir="$(brew --repository)/Library/Homebrew/vendor/portable-ruby/current/bin"
  [[ -x "${dir}/ruby" ]] || brew vendor-install ruby
  export PATH="${dir}:${PATH}"
}
