#!/usr/bin/env bash

set -euo pipefail

install_clt() {
  local clt_placeholder="/tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress"
  touch "$clt_placeholder"

  clt_pkg=$(softwareupdate -l 2>&1 \
    | grep '^\* Label: Command Line Tools' \
    | sed 's/^\* Label: //' \
    | sort -r \
    | head -n 1)

  if [[ -n "$clt_pkg" ]]; then
    echo "Installing: $clt_pkg"
    softwareupdate -i "$clt_pkg" --agree-to-license
    # インストール完了を確認
    until xcode-select -p &>/dev/null; do sleep 5; done
  else
    echo "CLT package not found, falling back to xcode-select"
    xcode-select --install
    until xcode-select -p &>/dev/null; do sleep 5; done
  fi

  rm -f "$clt_placeholder"
}

if [[ "$(uname)" == "Darwin" ]]; then
  if ! xcode-select -p &>/dev/null; then
    install_clt
  else
    echo "Command Line Tools already installed."
  fi
fi

# get.chezmoi.io は -b を付けないと、カレントの ./bin に chezmoi を置く（~ で実行すると ~/bin）。
# 残すと PATH で Homebrew 版より前に来て、更新されない古い版が使われ続けるので、
# 一時フォルダに置いて init --apply だけに使い、終わったら消す。
# 以降は [bootstrap.packages] の brew:chezmoi（mise run up で更新される）を使う。
chezmoi_bin_dir=$(mktemp -d)
trap 'rm -rf "$chezmoi_bin_dir"' EXIT
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$chezmoi_bin_dir" init --apply s-ikezawa
