#!/usr/bin/env bash
# templates/*.tpl 内の {{ op://... }} 参照を 1Password の実値に展開し、
# config.d/<name> として出力する。config.d/ は .gitignore 済み。
set -euo pipefail

cd "$(dirname "$0")"

if ! command -v op >/dev/null 2>&1; then
  echo "error: 1Password CLI (op) が見つかりません" >&2
  exit 1
fi

mkdir -p config.d

for tpl in templates/*.tpl; do
  [ -e "$tpl" ] || continue
  name="$(basename "${tpl%.tpl}")"
  out="config.d/$name"
  op inject -f -i "$tpl" -o "$out"
  chmod 600 "$out"
  echo "generated: $out"
done
