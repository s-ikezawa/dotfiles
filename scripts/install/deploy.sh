#!/bin/bash

set -e

# Zsh
if ! [ -d ${HOME}/.config/zsh ]; then
  mkdir -p ${HOME}/.config/zsh;
fi
stow -d ./config -t ${HOME}/.config/zsh zsh;

# Ghostty
if ! [ -d ${HOME}/.config/ghostty ]; then
  mkdir -p ${HOME}/.config/ghostty;
fi
stow -d ./config -t ${HOME}/.config/ghostty ghostty;

# VisualStudioCode
if ! [ -d ${HOME}/Library/Application\ Support/Code/User ]; then
  mkdir ${HOME}/Library/Application\ Support/Code/User;
fi

if [ -d ${HOME}/Library/Application\ Support/Code/User/snippets ]; then
  rm -rf ${HOME}/Library/Application\ Support/Code/User/snippets
fi
stow -d ./config -t ${HOME}/Library/Application\ Support/Code/User vscode

expect -c "\
  spawn -noecho bash -c \"echo \'export ZDOTDIR=~/.config/zsh' | sudo tee /etc/zshenv\"; \
  expect \"Password:\"; \
  send \"${PASSWORD}\n\"; \
  interact";

