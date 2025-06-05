#!/bin/bash

# 隠しフォルダをFinderで表示するようにする
defaults write com.apple.Finder AppleShowAllFiles YES
killall Finder
