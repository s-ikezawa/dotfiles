#!/bin/bash

set -e

# Zsh
if ! [ -d ${HOME}/.config/zsh ]; then
  mkdir -p ${HOME}/.config/zsh;
fi
stow -d ./config -t ${HOME}/.config/zsh zsh;

if ! [ -d ${HOME}/.cache/zsh ]; then
  mkdir -p ${HOME}/.cache/zsh;
fi

if ! [ -d ${HOME}/.local ]; then
  mkdir -p ${HOME}/.local/share ${HOME}/.local/state ${HOME}/.local/bin
fi

# Git
if ! [ -d ${HOME}/.config/git ]; then
  mkdir -p ${HOME}/.config/git;
fi 
stow -d ./config -t ${HOME}/.config/git git;

# AWS CLI
if ! [ -d ${HOME}/.aws ]; then
  mkdir -p ${HOME}/.aws;
fi
stow -d ./config -t ${HOME}/.aws aws

# Ghostty
if ! [ -d ${HOME}/.config/ghostty ]; then
  mkdir -p ${HOME}/.config/ghostty;
fi
stow -d ./config -t ${HOME}/.config/ghostty ghostty;

# Starship
stow -d ./config -t ${HOME}/.config starship;

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

