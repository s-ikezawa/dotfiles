#!/bin/zsh
# =============================================================
#  AI ペインの作業ディレクトリで yazi を開く
# =============================================================
#  config.toml の [[keys.command]] から popup として呼ばれる(prefix+alt+f)。
#
#  --chooser-file は使わない。使うと Enter が「選んで閉じる」に固定され、
#  yazi 本来の「Enter でファイルを開く」ができなくなるため。
#  AI へ送る操作は yazi 側のキーマップ(@)に割り当ててある。
#  実際の送信は yazi-send.sh が行う。
#
#  ここで特定した送信先を環境変数で yazi に渡しておく。yazi から起動される
#  子プロセス(= yazi-send.sh)もこれを継承するので、popup を開いた時点の
#  ペインへ確実に送れる(その後フォーカスが変わっても影響を受けない)。

emulate -L zsh
set -u

export PATH="${XDG_DATA_HOME:-$HOME/.local/share}/mise/shims:$PATH"

die() {
  print -u2 -- "エラー: $1"
  print -u2 -- "(3 秒後に閉じます)"
  sleep 3
  exit 1
}

(( $+commands[yazi] )) || die "yazi が PATH に見つかりません"

line=$("${XDG_CONFIG_HOME:-$HOME/.config}/herdr/agent-pane.sh") \
  || die "AI が動いているペインが見つかりません(このワークスペース内)"

local target agent base
IFS=$'\t' read -r target agent base <<< "$line"
[[ -n ${base:-} && -d $base ]] || base=$HOME

export HERDR_TARGET_PANE=$target
export HERDR_TARGET_CWD=$base

cd -- "$base" || die "ディレクトリへ移動できません: $base"
exec yazi
