#!/usr/bin/env bash
# Claude Code の LSP ツールを、すべての会話で共有する 1 つの kotlin-lsp（intellij-server）につなぐ。
#
# kotlin-lsp は、1 つの作業用のフォルダ（--system-path）を 1 つのサーバーしか使えない。会話ごとに --stdio で
# 起動すると、別の会話（同じプロジェクトでも別のプロジェクトでも）が使っている間は
# 「Another language server already uses the instance directory」で起動できない。
# そこで、--multi-client のサーバーを 1 つだけ裏で動かし、各会話はこのスクリプトから nc でつなぐ
# （Claude Code の LSP は標準入出力で話すので、nc で TCP に中継する）。
# 1 つのサーバーで複数のプロジェクトを扱える（kotlin-lsp の issue #115）。
#
# intellij-server --client は、自分のログを標準出力に書き、LSP の応答も返さなかったので使わない（271.2085.0 で確認）。
set -euo pipefail

dir="${XDG_CACHE_HOME:-$HOME/.cache}/kotlin-lsp-claude-shared"
# サーバーが待ち受けるポートを書き出すファイル。1 行目がポート、2 行目がプロセスの番号、3 行目が版
port_file="$dir/server.port"
lock="$dir/start.lock"
mkdir -p "$dir"

port() {
  [[ -s "$port_file" ]] && head -n 1 "$port_file"
}

alive() {
  local p
  p=$(port) || return 1
  nc -z 127.0.0.1 "$p" 2>/dev/null
}

if ! alive; then
  # 同時に起動した会話が 2 つのサーバーを立てないよう、フォルダの作成をロックにする。
  # 起動の途中で落ちて残ったロックは、3 分たったら消す
  find "$lock" -maxdepth 0 -mmin +3 -exec rmdir {} \; 2>/dev/null || true
  if mkdir "$lock" 2>/dev/null; then
    rm -f "$port_file"
    # どの会話もつないでいない状態が 30 分続いたら、サーバーは自分で止まる（--idle-timeout）。
    # --socket の 0 は、空いているポートを選ばせる
    nohup intellij-server \
      --multi-client \
      --socket=127.0.0.1:0 \
      --port-file="$port_file" \
      --idle-timeout=30m \
      --system-path="$dir/system" \
      >"$dir/server.out" 2>&1 </dev/null &
  fi
  for _ in $(seq 1 120); do
    alive && break
    sleep 1
  done
  rmdir "$lock" 2>/dev/null || true
  if ! alive; then
    echo "kotlin-lsp の共有のサーバーにつなげなかった（ログ: $dir/server.out）" >&2
    exit 1
  fi
fi

exec nc 127.0.0.1 "$(port)"
