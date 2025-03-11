#!/bin/bash

if type brew &> /dev/null; then
  brew cleanup
  curl -O -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh
  expect -c "\
    spawn bash uninstall.sh; \
    expect \"y/N\"; \
    send \"y\n\"; \
    expect \"Password:\"; \
    send \"${PASSWORD}\n\"; \
    interact";
  rm -f uninstall.sh
fi

expect -c "\
  spawn sudo rm -rf /opt/homebrew; \
  expect \"Password:\"; \
  send \"${PASSWORD}\n\"; \
  interact";
