#!/bin/bash

if ! type brew &> /dev/null; then
  curl -O -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh
  chmod 755 install.sh
  expect -c "\
    spawn bash install.sh; \
    expect \"Password:\"; \
    send \"${PASSWORD}\n\"; \
    expect \"Press RETURN/ENTER to continue or any other key to abort:\"; \
    send \"\n\"; \
    interact";
  rm -f install.sh
fi
eval "$(/opt/homebrew/bin/brew shellenv)"
