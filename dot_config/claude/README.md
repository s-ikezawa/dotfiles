# Claude Code の設定

設定の実体は chezmoi の `dot_config/claude/settings.json.tmpl`
（配置先 `~/.config/claude/settings.json`）。**なぜその値なのか**の説明はここに置く。

リポジトリの `CLAUDE.md` にもグローバルの `~/.config/claude/CLAUDE.md` にも書かないのは、
どちらも毎セッション読み込まれてコンテキストを食うため。モデルが従うべき指示だけを
CLAUDE.md に置き、人間向けの経緯はこのファイルに寄せる。

## auto mode の bash-first を切っている

`env` の `CLAUDE_CODE_THRIFTY_SONIC=0` は、auto mode のときに system prompt へ
注入される次の指示を消すためのもの。

> Do your work through the Bash tool wherever it can accomplish the job: read files
> with cat, head, or sed -n, search with grep and find, and make file changes with
> sed, heredocs, or short scripts, rather than using the dedicated Read, Edit, or
> Write tools.

これが入っていると Read / Edit / Write が呼ばれなくなり、次が壊れる。

- **`rg` / `fd` が使われない。** 検索が `grep` / `find` に固定される。
  Grep / Glob ツールの実体は同梱の ripgrep なので、**指示さえ消せば黙って rg に戻る**
  （CLAUDE.md に「rg を使え」と書き足す必要も、フックで縛る必要も無い）
- **Read に対する PreToolUse フックが発火しない**
- **サブディレクトリの `CLAUDE.md` が読まれない。** Read を契機に読み込まれるため

代償はツール呼び出し回数の増加。`thrifty` の名の通り、元はトークンとレイテンシの節約策。

**非公開の内部フラグである。** バンドル内の gate 名は `tengu_thrifty_sonic` で、
`cohort` 分岐を持つ A/B 実験の口。将来のリリースで消えたり意味が変わったりしうるので、
更新のたびに効いているか気にすること。値は `triBool` で解釈され、
`0` / `false` / `no` / `off` が false（大小文字は無視、trim 済み）。

```sh
# 実装を確認する（バージョンは適宜差し替え）
rg -a -o '.{0,80}CLAUDE_CODE_THRIFTY_SONIC.{0,400}' \
  ~/.local/share/claude/versions/2.1.263
```

隣に `CLAUDE_CODE_COZY_TEAPOT`（`strict` / `relaxed`、既定 `strict`）もあるが、
`relaxed` は編集ツールの選択を緩めるだけで **`search with grep and find` は残る**。
今回の目的には使えない。
