#!/bin/zsh
# =============================================================
#  ghq のリポジトリ一覧から Herdr のワークスペースを作る
# =============================================================
#  config.toml の [[keys.command]] から popup として呼ばれる(prefix+alt+p)。
#
#  Git リポジトリ以外を開きたい場合は、Herdr 標準の new_workspace
#  (prefix+shift+n) を使う。このスクリプトは ghq 管理下のリポジトリ専用。

emulate -L zsh
set -u

# popup はログインシェルを経由するとは限らないため、mise の shim を明示的に通す。
# これが無いと ghq / fzf / eza が PATH に無く、原因の分かりにくい失敗になる。
export PATH="${XDG_DATA_HOME:-$HOME/.local/share}/mise/shims:$PATH"

# エラーは popup が閉じる前に読めるよう、少し待ってから終了する。
die() {
  print -u2 -- "エラー: $1"
  print -u2 -- "(3 秒後に閉じます)"
  sleep 3
  exit 1
}

for c in ghq fzf herdr; do
  (( $+commands[$c] )) || die "$c が PATH に見つかりません"
done

root=$(ghq root) || die "ghq root の取得に失敗しました"

# fzf の {} はシェル用にクォートされて展開されるため、'$root'/{} で連結できる。
# プレビューは eza。--icons=always なのは、プレビューが端末ではないため
# auto では出ないことによる(eza 0.23.x の挙動。aliases.zsh のコメント参照)。
selected=$(
  ghq list | fzf \
    --prompt='repo > ' \
    --reverse \
    --border=rounded \
    --info=inline \
    --preview="eza --icons=always --group-directories-first --long --git --time-style=long-iso '$root'/{}" \
    --preview-window=right,55%
) || exit 0   # ESC / ctrl-c は「取り消し」であってエラーではない

[[ -n $selected ]] || exit 0

dir="$root/$selected"
# ラベルはリポジトリ名のみ。サイドバーの幅が限られるため owner は落とす。
label="${selected:t}"

# 同じラベルのワークスペースが既にあるなら、作らずにそちらへ移動する。
# workspace list は cwd を返さないため、判定はラベルで行う(名前が同じ別の
# リポジトリを開いている場合は既存側にフォーカスされる、という割り切り)。
if (( $+commands[jq] )); then
  existing=$(
    herdr workspace list 2>/dev/null \
      | jq -r --arg l "$label" '.result.workspaces[]? | select(.label == $l) | .workspace_id' \
      | head -1
  )
  if [[ -n ${existing:-} ]]; then
    herdr workspace focus "$existing" >/dev/null || die "ワークスペースの切り替えに失敗しました"
    exit 0
  fi
fi

herdr workspace create --cwd "$dir" --label "$label" --focus >/dev/null \
  || die "ワークスペースの作成に失敗しました ($dir)"
