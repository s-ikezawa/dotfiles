#!/bin/zsh
# =============================================================
#  ファイルパスを AI ペインへ @ 付きで送り込む
# =============================================================
#  yazi のキーマップ(~/.config/yazi/keymap.toml の "@")から呼ばれる。
#
#  引数: <ホバー中のパス> [<選択中のパス> ...]
#    yazi 側で `%h %s` を渡している。選択が無いときは %s が空になるため、
#    第 1 引数のホバー中パスを使う。選択があればそちらを優先する。
#
#  送信先は yazi-popup.sh が export した HERDR_TARGET_PANE を使う。
#  popup 以外から起動された yazi のために、無ければ自力で特定する。
#
#  Enter は送らない。送信するかどうかは利用者が決める。

emulate -L zsh
set -u

export PATH="${XDG_DATA_HOME:-$HOME/.local/share}/mise/shims:$PATH"

# yazi のバックグラウンド実行なので画面には何も出せない。原因追跡用に残す。
LOGFILE="${XDG_STATE_HOME:-$HOME/.local/state}/herdr/yazi-send.log"
mkdir -p "${LOGFILE:h}" 2>/dev/null
: > "$LOGFILE" 2>/dev/null
log() { print -r -- "$*" >> "$LOGFILE" 2>/dev/null }

(( $# )) || { log "引数なしのため終了"; exit 0 }

# --- 送信先の決定 ---------------------------------------------
target=${HERDR_TARGET_PANE:-}
base=${HERDR_TARGET_CWD:-}

if [[ -z $target ]]; then
  line=$("${XDG_CONFIG_HOME:-$HOME/.config}/herdr/agent-pane.sh") || {
    log "AI ペインを特定できません"
    exit 1
  }
  local _a
  IFS=$'\t' read -r target _a base <<< "$line"
fi
[[ -n ${base:-} && -d $base ]] || base=$PWD

log "target=$target base=$base 引数数=$#"

# --- 対象ファイルの決定 ---------------------------------------
# 第 1 引数 = ホバー中、2 個目以降 = 選択中。選択があればそちらを使う。
typeset -a files
if (( $# > 1 )); then
  files=("${@[2,-1]}")
else
  files=("$1")
fi

# --- @ 付きの参照に整形する -----------------------------------
# base 配下なら相対パス、外なら絶対パスのまま。
typeset -a refs
local f
for f in "${files[@]}"; do
  [[ -n $f ]] || continue
  if [[ $f == $base/* ]]; then
    refs+=("@${f#$base/}")
  else
    refs+=("@$f")
  fi
done

(( ${#refs} )) || { log "refs が空のため終了"; exit 0 }

log "送信: pane=$target text=[${(j: :)refs} ]"
herdr pane send-text "$target" "${(j: :)refs} " >/dev/null 2>&1 \
  || { log "送信失敗"; exit 1 }
log "送信成功"
