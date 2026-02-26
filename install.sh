#!/usr/bin/env bash

set -euo pipefail

DOTFILES_DIR="${HOME}/Projects/github.com/s-ikezawa/dotfiles"

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
  else
    echo "CLT package not found, falling back to xcode-select"
    xcode-select --install
    until xcode-select -p &>/dev/null; do sleep 5; done
  fi

  rm -f "$clt_placeholder"
}

# XDGフォルダの作成(zshフォルダが自動で作成されないのであらかじめ作っておく)
mkdir -p "${HOME}/.config/zsh" "${HOME}/.cache/zsh" "${HOME}/.local/share/zsh" "${HOME}/.local/state/zsh"

# Macのみの処理
if [[ "$(uname)" == "Darwin" ]]; then
  if ! xcode-select -p &>/dev/null; then
    install_clt
  else
    echo "Command Line Tools already installed."
  fi

  if ! command -v brew &>/dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
  else
    echo "Homebrew already installed."
  fi

  if [[ -f "$DOTFILES_DIR/Brewfile" ]]; then
    echo "Installing packages from Brewfile..."
    brew bundle --file="$DOTFILES_DIR/Brewfile"
  fi

  if ! grep -q 'ZDOTDIR' /etc/zshenv 2>/dev/null; then
    echo "Setting ZDOTDIR..."
    echo 'export ZDOTDIR="$HOME/.config/zsh"' | sudo tee -a /etc/zshenv
  fi
fi
