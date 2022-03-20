#!/bin/bash

if type brew > /dev/null 2>&1; then
  echo 'Homebrew installed'
else
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

brew bundle --file './Brewfile'

CURRENT_DIR=`pwd`
if [ ! -e ~/.zshrc ]; then
  echo "create zshrc symlink"
  ln -s $CURRENT_DIR/.zshrc ~/.zshrc
fi

if [ ! -e ~/.p10k.zsh ]; then
  echo "create .p10k.zsh symlink"
  ln -s $CURRENT_DIR/.p10k.zsh ~/.p10k.zsh
fi
