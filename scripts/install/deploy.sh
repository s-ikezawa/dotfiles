#!/bin/bash

set -e

if ! [ -d ${HOME}/.config/zsh ]; then
  mkdir -p ${HOME}/.config/zsh;
fi
stow -d ./config -t ${HOME}/.config/zsh zsh;

expect -c "\
  spawn -noecho bash -c \"echo \'export ZDOTDIR=~/.config/zsh' | sudo tee /etc/zshenv\"; \
  expect \"Password:\"; \
  send \"${PASSWORD}\n\"; \
  interact";

