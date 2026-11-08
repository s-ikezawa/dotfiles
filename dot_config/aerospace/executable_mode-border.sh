#!/usr/bin/env bash
# AeroSpace のいまのモードに合わせた色で、フォーカスしているウィンドウに枠を付ける（JankyBorders）。
# aerospace.toml の after-startup-command（起動時）と on-mode-changed（モードが変わるたび）から呼ぶ。
# borders は動いていなければ常駐プロセスとして起動し、動いていれば色だけ変えてすぐ終わる。
# 色は Ghostty・Neovim と同じ Catppuccin Mocha（形式は 0xAARRGGBB）。
set -euo pipefail

# Finder などから起動した AeroSpace の PATH には Homebrew が入っていないので足す
export PATH="/opt/homebrew/bin:${PATH}"

case "$(aerospace list-modes --current)" in
  service) active_color=0xfffab387 ;; # Peach。service モードに入っていることを目立たせる
  *) active_color=0xff89b4fa ;;       # Blue
esac

# inactive_color は透明にして、フォーカスしていないウィンドウには枠を付けない
# 幅は 5.0 だと細くて分かりにくかったので 10.0 にしている
exec borders style=round width=10.0 hidpi=on \
  active_color="${active_color}" inactive_color=0x00000000
