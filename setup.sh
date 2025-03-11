#!/bin/bash

set -e

# Command Line Tools がインストールされていなければインストールする
if ! [ -e "/Library/Developer/CommandLineTools/usr/bin/git" ]; then
  echo "Searching online for the Command Line Tools"
  PLACEHOLDER='/tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress'
  touch ${PLACEHOLDER}
  LABEL=$(/usr/sbin/softwareupdate -l | \
    grep -B 1 -E 'Command Line Tools' | \
    awk -F'*' '/^ *\\*/ {print $2}' | \
    sed -e 's/^ *Label: //' -e 's/^ *//' | \
    sort -V | \
    tail -n1)
  echo "Installing ${LABEL}"
  /usr/sbin/softwareupdate -i "${LABEL}" 
  
  expect -c "\
    spawn -noecho sudo /usr/bin/xcode-select --switch /Library/Developer/CommandLineTools \
    expect \"Password:\" \
    send \"${PASSWORD}\\n\" \
    interact"
  rm -f ${PLACEHOLDER}
fi

# dotfilesのリポジトリをclone
REPO_PATH="${HOME}/Projects/github.com/s-ikezawa/dotfiles"
if [ -d ${REPO_PATH} ]; then
  cd $REPO_PATH
  git pull
else
  git clone https://github.com/s-ikezawa/dotfiles.git ${HOME}/Projects/github.com/s-ikezawa/dotfiles/
  cd $REPO_PATH
fi

make all
