#!/bin/zsh
# =============================================================
#  AI が動いている herdr のペインを 1 つ特定して出力する
# =============================================================
#  出力: "<pane_id>\t<agent 名>\t<cwd>" を 1 行。見つからなければ終了コード 1。
#
#  yazi-popup.sh と yazi-send.sh の両方から使う。
#  選び方は「フォーカス中のペインが AI ならそれ、でなければ最初の AI ペイン」。
#  対話的に選ばせないのは、yazi のキーマップから呼ばれる場合に
#  画面を奪えない(バックグラウンド実行)ため。

emulate -L zsh
set -u

export PATH="${XDG_DATA_HOME:-$HOME/.local/share}/mise/shims:$PATH"

(( $+commands[herdr] )) || exit 1
(( $+commands[jq] )) || exit 1

ws=$(
  herdr workspace list 2>/dev/null \
    | jq -r '.result.workspaces[] | select(.focused) | .workspace_id' | head -1
)
[[ -n ${ws:-} ]] || exit 1

panes=$(herdr pane list --workspace "$ws" 2>/dev/null) || exit 1

# フォーカス中のペインが AI ならそれを優先する
line=$(
  print -r -- "$panes" \
    | jq -r '.result.panes[] | select(.focused and .agent != null)
             | "\(.pane_id)\t\(.agent)\t\(.cwd)"' | head -1
)

# でなければワークスペース内の最初の AI ペイン
if [[ -z ${line:-} ]]; then
  line=$(
    print -r -- "$panes" \
      | jq -r '.result.panes[] | select(.agent != null)
               | "\(.pane_id)\t\(.agent)\t\(.cwd)"' | head -1
  )
fi

[[ -n ${line:-} ]] || exit 1
print -r -- "$line"
