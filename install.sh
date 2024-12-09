#! /bin/sh
set -u

export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share
export XDG_STATE_HOME=$HOME/.local/state

# Make directories
mkdir -p $XDG_CONFIG_HOME
mkdir -p $XDG_CACHE_HOME
mkdir -p $XDG_DATA_HOME
mkdir -p $XDG_STATE_HOME

# Homebrew
if !(type brew > /dev/null 2>&1); then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  export PATH=$PATH:/opt/homebrew/bin
fi

# repository clone
REPO_DIR=$HOME/Projects/github.com/s-ikezawa/dotfiles
if [ ! -d $HOME/Projects/github.com/s-ikezawa/dotfiles ]; then
  git clone https://github.com/s-ikezawa/dotfiles.git ${REPO_DIR}
fi
cd ${REPO_DIR}

# package install
brew bundle --file=./Brewfile

# /etc/zshenvはMacの場合なので他のOSの場合は要確認
echo "export ZDOTDIR=$HOME/.config/zsh" | sudo tee /etc/zshenv
