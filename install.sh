#! /bin/sh
set -u

export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share

# Make directories
mkdir -p $XDG_CONFIG_HOME
mkdir -p $XDG_CACHE_HOME
mkdir -p $XDG_DATA_HOME

# Homebrew
if !(type brew > /dev/null 2>&1); then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  export PATH=$PATH:/opt/homebrew/bin
fi

# repository clone
if [ ! -d $HOME/Projects/github.com/s-ikezawa/dotfiles ]; then
  git clone https://github.com/s-ikezawa/dotfiles.git $HOME/Projects/github.com/s-ikezawa/dotfiles
fi
cd $HOME/Projects/github.com/s-ikezawa/dotfiles

# package install
brew bundle --file=./Brewfile
