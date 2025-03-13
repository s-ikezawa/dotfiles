#!/bin/bash

set -e

# VSCodeでキーリピートが有効になるようにする
defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false
defaults write com.microsoft.VSCodeInsiders ApplePressAndHoldEnabled -bool false
