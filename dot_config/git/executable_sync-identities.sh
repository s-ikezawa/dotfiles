#!/usr/bin/env bash
# 1Password のテンプレートから git identity 設定ファイルを生成する。
# 各 *.tpl 内の {{ op://... }} 参照を実値に展開して同名(拡張子なし)で出力。
set -euo pipefail

cd "$(dirname "$0")"

if ! command -v op >/dev/null 2>&1; then
  echo "error: 1Password CLI (op) が見つかりません" >&2
  exit 1
fi

for tpl in *.tpl; do
  [ -e "$tpl" ] || continue
  out="${tpl%.tpl}"
  op inject -f -i "$tpl" -o "$out"
  chmod 600 "$out"
  echo "generated: $out"
done
