#!/bin/bash

if type brew > /dev/null 2>&1; then
  echo 'Homebrew installed'
else
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
