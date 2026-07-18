#!/usr/bin/env bash

set -euo pipefail

brew bundle dump --force --file=- | \
awk ' \
  /^# / { desc = substr($0, 3); next }
  desc != "" { print $0 " # " desc; desc = ""; next }
  { print }
' > Brewfile
