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

expect -c "\
  spawn -noecho bash -c \"echo \'export ZDOTDIR=~/.config/zsh' | sudo tee /etc/zshenv\"; \
  expect \"Password:\"; \
  send \"${PASSWORD}\n\"; \
  interact";

