#!/bin/zsh
# =============================================================
#  フォーカス中のペインのディレクトリで lazygit を開く
# =============================================================
#  config.toml の [[keys.command]] から popup として呼ばれる(prefix+alt+g)。
#
#  lazygit は「どのリポジトリで開くか」がすべてなので、cwd の決定が要。
#  ところが herdr の [[keys.command]] には cwd 指定が無く、popup の cwd が
#  何になるかは仕様として保証されていない(new_cwd の説明は panes/tabs/
#  workspaces が対象で popup に言及していない)。
#  そこで cwd に依存しない作りにしている。

emulate -L zsh
set -u

# popup はログインシェルを経由するとは限らないため shim を明示的に通す。
export PATH="${XDG_DATA_HOME:-$HOME/.local/share}/mise/shims:$PATH"

die() {
  print -u2 -- "エラー: $1"
  print -u2 -- "(3 秒後に閉じます)"
  sleep 3
  exit 1
}

(( $+commands[lazygit] )) || die "lazygit が PATH に見つかりません"

# (1) popup 自身の cwd が既に Git 管理下ならそれを使う
# (2) そうでなければ herdr にフォーカス中のペインの cwd を尋ねる
#     (対象を省略した pane current は UI がフォーカスしているペインを返す。
#      popup を開いたのは利用者自身なので、これが目的のペインになる)
target=""
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  target=$PWD
elif (( $+commands[herdr] )) && (( $+commands[jq] )); then
  target=$(
    herdr pane current 2>/dev/null \
      | jq -r '.result.pane.foreground_cwd // .result.pane.cwd // empty'
  )
fi

[[ -n ${target:-} && -d $target ]] || target=$HOME
cd -- "$target" || die "ディレクトリへ移動できません: $target"

# Git 管理下でない場合もそのまま起動する。
# lazygit 自身が「リポジトリを作るか」と尋ねてくれるため、ここでは弾かない。
exec lazygit
