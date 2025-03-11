#!/bin/bash

set -e

eval "$(/opt/homebrew/bin/brew shellenv)"
brew bundle --file=./scripts/install/Brewfile
