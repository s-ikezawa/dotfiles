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

  if ! command -v rustup &>/dev/null; then
    echo "Installing Rust..."
    export RUSTUP_HOME="$HOME/.local/share/rustup"
    export CARGO_HOME="$HOME/.local/share/cargo"
    export PATH="${CARGO_HOME}/bin:${PATH}"
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  else
    echo "rust already installed."
  fi

  if ! command -v mise &>/dev/null; then
    echo "Installing mise..."
    curl -fsSL https://mise.run | bash
    export PATH="$HOME/.local/bin:$PATH"
  else
    echo "mise already installed."
  fi

  if ! grep -q 'ZDOTDIR' /etc/zshenv 2>/dev/null; then
    echo "Setting ZDOTDIR..."
    echo 'export ZDOTDIR="$HOME/.config/zsh"' | sudo tee -a /etc/zshenv
  else
    echo "rust already installed."
  fi

  # ── Keyboard ──
  echo "Setting keyboard preferences..."
  defaults write NSGlobalDomain KeyRepeat -int 1
  defaults write NSGlobalDomain InitialKeyRepeat -int 10
  # 自動修正・自動大文字・スマート引用符/ダッシュを無効化
  defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
  defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
  defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
  defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
  defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
  # ライブ変換を無効化
  defaults write com.apple.inputmethod.Kotoeri JIMPrefLiveConversionKey -bool false
  # Tabで全てのコントロール間を移動
  defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

  # ── Trackpad ──
  echo "Setting trackpad preferences..."
  # タップでクリック
  defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
  defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true

  # ── Dock ──
  echo "Setting Dock preferences..."
  defaults write com.apple.dock orientation -string left
  defaults write com.apple.dock tilesize -int 36
  defaults write com.apple.dock autohide -bool true
  defaults write com.apple.dock minimize-to-application -bool true
  # 最近使ったアプリを非表示
  defaults write com.apple.dock show-recents -bool false
  killall Dock

  # ── Window Manager ──
  echo "Setting Window Manager preferences..."
  defaults write com.apple.WindowManager GloballyEnabled -bool false
  defaults write com.apple.WindowManager EnableStandardClickToShowDesktop -bool false
  defaults write com.apple.WindowManager StandardHideWidgets -bool true
  defaults write com.apple.WindowManager StageManagerHideWidgets -bool true

  # ── Finder ──
  echo "Setting Finder preferences..."
  # 隠しファイルを表示
  defaults write com.apple.finder AppleShowAllFiles -bool true
  # 拡張子を常に表示
  defaults write NSGlobalDomain AppleShowAllExtensions -bool true
  # パスバー・ステータスバーを表示
  defaults write com.apple.finder ShowPathbar -bool true
  defaults write com.apple.finder ShowStatusBar -bool true
  # タイトルバーにフルパスを表示
  defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
  # デフォルトをリスト表示に
  defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
  # 検索時にデフォルトでカレントフォルダを対象に
  defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
  # 拡張子変更時の警告を無効化
  defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
  killall Finder

  # ── Screenshot ──
  echo "Setting screenshot preferences..."
  # スクリーンショットの保存先を~/Screenshotsに
  mkdir -p "${HOME}/Screenshots"
  defaults write com.apple.screencapture location -string "${HOME}/Screenshots"
  # スクリーンショットの影を無効化
  defaults write com.apple.screencapture disable-shadow -bool true

  # ── Global ──
  echo "Setting global preferences..."
  # 保存ダイアログをデフォルトで展開
  defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
  defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
  # 印刷ダイアログをデフォルトで展開
  defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
  defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true
  # iCloudではなくディスクにデフォルト保存
  defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false
fi

# Claude Codeのインストール
if ! command -v claude &>/dev/null; then
  echo "Installing Claude Code..."
  curl -fsSL https://claude.ai/install.sh | bash
else
  echo "Claude Code already installed."
fi


# 設定ファイルの配置
packages=(
  shell
  zsh
  bash
  mise
  claude
  ghostty
  tmux
  yazi
  bat
  nvim
)

echo "Stowing dotfiles form $DOTFILES_DIR → $HOME"
for pkg in "${packages[@]}"; do
  if [ -d "$DOTFILES_DIR/$pkg" ]; then
    echo " [$pkg] stowing..."
    # --restow: 既存のリンクを貼り直す
    # --no-folding フォルダは実態として作成する
    stow -v -d "$DOTFILES_DIR" -t "$HOME" --no-folding --restow "$pkg"
  else
    echo " [$pkg] skipped (directory not found)"
  fi
done

# 後処理
if [[ "$(uname)" == "Darwin" ]]; then
  mise install
fi

echo "Done!"
