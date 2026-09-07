#!/usr/bin/env python3
"""SKILL.md の allowed-tools / disallowed-tools が意図どおり判定されるかを検証する。

権限ルールを変更したら必ず実行する:

    python3 scripts/permission_test.py

判定規則は Claude Code 2.1.263 のバンドル実装から書き起こしたもの。

- ルール種別: `:*` で終われば prefix、エスケープされていない `*` を含めば wildcard、
  それ以外は exact
- prefix: 空白を正規化したうえで `cmd == prefix` か `cmd.startswith(prefix + " ")`。
  `xargs <prefix>` 形も通る
- wildcard: パターンを正規表現へ変換して全一致。**末尾が ` *`（星1個）のときだけ
  ` .*` が `( .*)?` になる**ため、`foo *` は `foo` 単体にも一致する。この特例で
  `git add -- *` のようなパターンは「全部入り」ではなく「git add -- で始まる全部」を
  意味してしまう
- exact: 文字列の完全一致（空白正規化なし）
- deny が allow に優先する

**限界（テストで担保できないこと）**

- これは照合規則の再実装であって、Claude Code 本体を呼んでいない。本体の実装が
  変われば、このテストが通ったまま実挙動がずれる
- 複合コマンド（`a && b`）が prefix / wildcard ルールで弾かれる分岐は再現していない
- `**` を含むパターンの GLOBSTAR 変換は簡略化してある
- allowed-tools / disallowed-tools が「次のユーザーメッセージで失効する」ことは
  文字列マッチの問題ではないので、ここでは検証できない
"""

import re
import sys
from pathlib import Path

SKILL = Path(__file__).resolve().parent.parent / "SKILL.md"

# (コマンド, 期待する判定, 意図)
#   allow = 事前承認で通る / deny = 機構で止まる / ask = どちらでもなく承認を求める
CASES = [
    # 手順が実際に打つコマンド。ここが ask に落ちると毎回承認が要る
    ("git status --short --branch", "allow", "手順1・6"),
    ("git diff --stat HEAD", "allow", "注入・手順1"),
    ("git diff --staged", "allow", "手順1"),
    ("git log --oneline -20", "allow", "注入"),
    ("git log -3 --format=%s%n%n%b%n---", "allow", "手順2"),
    ("git branch --show-current", "allow", "手順4"),
    ("git config --get commit.template", "allow", "手順2"),
    ("git add -- vault/note.md", "allow", "手順6の基本形"),
    ("git add -- 'vault/日本語 ノート.md'", "allow", "空白と日本語を含むパス"),
    ("git add -- src/a.ts src/b.ts", "allow", "複数パス"),
    ("git add -- ./src/parser.ts", "allow", "./ 始まりの相対パスを巻き込まない"),
    ("git add -- :/src/parser.ts", "allow", ":/ 始まりの絶対パス指定を巻き込まない"),
    ("git commit -F -", "allow", "heredoc は照合前に剥がされる"),
    # 本文が禁じているもの。機構でも止まってほしい
    ("git commit -F - --amend", "deny", "既存コミットの書き換え"),
    ("git commit -F - --no-verify", "deny", "フック無視"),
    ("git commit -F - --allow-empty", "deny", "空コミット"),
    ("git commit -F - --all", "deny", "全部入りコミット"),
    ("git add -A", "deny", "全部ステージ"),
    ("git add --all", "deny", "全部ステージ"),
    ("git add -u", "deny", "追跡済み全部ステージ"),
    ("git add --update", "deny", "追跡済み全部ステージ"),
    ("git add .", "deny", "全部ステージ"),
    ("git add . src", "deny", "全部ステージ"),
    ("git add -- .", "deny", "全部ステージ（-- 付き）"),
    ("git add --  .", "deny", "二重空白。wildcard は正規化されるので exact と違い止まる"),
    ("git add -- . src/a.ts", "deny", "末尾 ` *` の特例でパスを続けても止まる"),
    ("git add -- ./", "deny", "全部ステージ（./ 綴り）"),
    ("git add -- ./ src/a.ts", "deny", "./ にパスを続けた形"),
    ("git add -- :/", "deny", "全部ステージ（:/ 綴り）"),
    ("git add -A -- src/a.ts", "deny", "-A はパス付きでも止まる"),
    ("git commit --amend -F -", "deny", "フラグの前置順が変わっても止まる"),
    ("git add -f secret.env", "deny", "gitignore の強制追加"),
    ("git add --force secret.env", "deny", "gitignore の強制追加"),
    # allow に載せず、通常の承認に落としたいもの
    ("git commit -F - --trailer 'Refs: #1'", "ask", "フラグ付きは前置一致で許さない"),
    ("git commit -F - --trailer 'Refs: #1' -n", "ask", "--trailer 経由の -n を塞ぐ"),
    ("git commit -F - -a", "ask", "-a を allow に含めない"),
    ("git commit -F - --author=x", "ask", "別人名義を allow に含めない"),
    ("git push", "ask", "Skill の守備範囲外。deny で他の作業を止めない"),
    ("git reset --hard", "ask", "守備範囲外"),
    ("git rebase -i main", "ask", "守備範囲外"),
    ("git add foo.md", "ask", "-- を省いた形は承認に落とす"),
    ("git add .github/x.md", "ask", "dot 始まりのパスを deny で巻き込まない"),
    ("git add -- .github/x.md", "allow", "-- 付きの dot 始まりパスは手順6が実際に打つ形"),
    # 塞げていないと分かっている穴。閉じたらここが失敗して気づける
    ("git add -- '*'", "allow", "既知の穴: 前置一致は綴りを網羅できない"),
    ("git add -- ':(top)'", "allow", "既知の穴: pathspec マジックは数え上げられない"),
    ("git add -- ../", "allow", "既知の穴: 親ディレクトリ指定"),
]


def has_unescaped_star(s):
    for i, ch in enumerate(s):
        if ch != "*":
            continue
        backslashes = 0
        j = i - 1
        while j >= 0 and s[j] == "\\":
            backslashes += 1
            j -= 1
        if backslashes % 2 == 0:
            return True
    return False


def classify(content):
    if content.endswith(":*"):
        return ("prefix", content[:-2])
    if has_unescaped_star(content):
        return ("wildcard", content)
    return ("exact", content)


def norm(s):
    return re.sub(r"[ \t]+", " ", s)


ESCAPED_STAR = "\x00ESCAPED_STAR\x00"
ESCAPED_BACKSLASH = "\x00ESCAPED_BACKSLASH\x00"


def wildcard_regex(pattern):
    p = norm(pattern.strip())
    lit = ""
    i = 0
    while i < len(p):
        ch = p[i]
        if ch == "\\" and i + 1 < len(p):
            nxt = p[i + 1]
            if nxt == "*":
                lit += ESCAPED_STAR
                i += 2
                continue
            if nxt == "\\":
                lit += ESCAPED_BACKSLASH
                i += 2
                continue
        lit += ch
        i += 1

    body = re.sub(r"""[.+?^${}()|\[\]\\'"]""", lambda m: "\\" + m.group(0), lit)
    body = body.replace("*", ".*")
    star_count = lit.count("*")
    # バンドルの特例: 末尾の " .*" は星が1個のときだけ任意扱いになる
    if body.endswith(" .*") and star_count == 1:
        body = body[:-3] + "( .*)?"
    body = body.replace(ESCAPED_STAR, r"\*").replace(ESCAPED_BACKSLASH, "\\\\")
    return re.compile("^" + body + "$", re.S)


def matches(rule, cmd):
    kind, content = rule
    if kind == "prefix":
        pre, c = norm(content), norm(cmd)
        if c == pre or c.startswith(pre + " "):
            return True
        x = "xargs " + pre
        return c == x or c.startswith(x + " ")
    if kind == "exact":
        return cmd == content
    return bool(wildcard_regex(content).match(norm(cmd)))


def parse_rules(line):
    return [classify(m) for m in re.findall(r"Bash\(([^)]*)\)", line)]


def load():
    allow, deny = [], []
    for line in SKILL.read_text(encoding="utf-8").splitlines():
        if line.startswith("allowed-tools:"):
            allow = parse_rules(line)
        elif line.startswith("disallowed-tools:"):
            deny = parse_rules(line)
        elif line == "---" and allow:
            break
    if not allow:
        sys.exit("allowed-tools が SKILL.md に見つからない")
    return allow, deny


def verdict(cmd, allow, deny):
    if any(matches(r, cmd) for r in deny):
        return "deny"
    if any(matches(r, cmd) for r in allow):
        return "allow"
    return "ask"


def main():
    allow, deny = load()
    for rules, label in ((allow, "allow"), (deny, "deny")):
        for kind, content in rules:
            if kind == "wildcard" and "**" in content:
                print("WARN: %s の '%s' は ** を含む。この実装は GLOBSTAR を簡略化している" % (label, content))

    failures = []
    for cmd, want, why in CASES:
        got = verdict(cmd, allow, deny)
        if got != want:
            failures.append((cmd, want, got, why))

    print("%d ルール（allow %d / deny %d）、%d ケース" % (len(allow) + len(deny), len(allow), len(deny), len(CASES)))
    if failures:
        print("\n%d 件失敗:\n" % len(failures))
        for cmd, want, got, why in failures:
            print("  %s" % cmd)
            print("      期待 %-5s → 実際 %-5s   (%s)" % (want, got, why))
        return 1
    print("すべて期待どおり")
    return 0


if __name__ == "__main__":
    sys.exit(main())
