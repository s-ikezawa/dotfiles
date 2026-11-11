# やりとり

- ユーザー向けの文章（回答・説明・質問・確認）は日本語で書く。
- 質問・確認・実行してもらうコマンドは 1 回に 1 つ。返事を待ち、内容が変わるなら直してから次を出す
  （まとめて出すとスクロールが要り、どの手順の結果か追えなくなるため）。

# ファイルの読み書き

- 読むのは Read ツール。cat・head・sed は使わない（Edit の前提で、読んだ後の変更も検出できるため）。
- 作成・編集は auto mode でも Edit / Write ツールだけ。sed・awk・perl・python・`cat >>`・
  ヒアドキュメント・`echo >` では書かない（外れても黙って成功し、ミスが多いため）。
- 行番号は場所の確認だけに使い、編集位置の指定には使わない（ずれても気付けないため）。
- Edit では現実的でない一括置換などは、シェルで編集する前にユーザーに確認する。

# コードの探索

- 定義・参照・実装・呼び出し階層・型は LSP ツール（TypeScript・Go・Kotlin・Lua・シェルスクリプトの
  sh・bash）。同じ名前の別物やコメントに紛れず、grep のような見落としがない。
- LSP の結果は信用し、確かめるためにファイルを開き直さない（開き直すと grep より高くつく）。
- 文字列・コメント・設定ファイル・LSP のない言語は `rg`、構文の形で探す・書き換えるなら `ast-grep`。
- 編集した後に返ってくる LSP の診断（型エラーや shellcheck の警告など）は、その場で直す。
- chezmoi のテンプレート（`*.sh.tmpl`）と zsh のスクリプトは LSP の対象外。テンプレートは
  `chezmoi execute-template < ファイル | shellcheck -s bash -` で確かめる（zsh は shellcheck も非対応）。

# シェルのツール（mise で導入済み。従来のコマンドより優先）

- 文字列検索は `rg -n`（Bash からだと `-n` なしでは行番号が出ない）。隠し・無視ファイル
  （`.github/`、ビルド結果など）も探すなら `--hidden` か `-uu`。
- ファイル検索は `fd <パターン> [フォルダ]`。隠しファイルは `-H`、無視されたファイルは `-I`。
- JSON は `jq`。gh の出力は `gh ... --json <項目> --jq <式>` で取り出す。
- YAML / TOML / XML は `yq`（mikefarah 版 v4）。TOML 入力は `-p toml`、出力は YAML `-oy` / TOML `-o toml`。
- 構文の形で探すとき（空白・改行を無視、コメント・文字列を除外）は `ast-grep`。名前や文字列なら rg。
  型や参照の解決はできない（LSP ツールを使う）。
  - 例: `ast-grep run -l ts -p 'useEffect($F, [])'`（`$A` は 1 ノード、`$$$` は 0 個以上）。
  - Go の `pkg.Func($$$)` 単独は型変換と解釈され一致しない。`ast-grep scan --inline-rules` で
    `pattern: {context: "func t() { fmt.Println($$$A) }", selector: call_expression}` のように書く。
  - 0 件ならパターンを疑い `--debug-query=ast` で確かめる。
  - `-r` の置き換えはまず `-U` なしで差分を確認。`-U` はシェルでの編集なので実行前にユーザーに確認。
- GitHub（リポジトリ・PR・Issue・CI ログ）は curl や Web 取得でなく `gh` / `gh api`（認証済み）。
- リポジトリは `~/Projects/<ホスト>/<オーナー>/<リポジトリ>`（ghq）。clone 前に `ghq list -p | rg <名前>`。
- `bat`・`eza`・`delta` は使わない（人向けの装飾が出力に混ざる）。代わりに Read・`ls`・`git diff`。

# シークレット

- シークレット（トークン・パスワード・鍵・`.env` の値）を表示・出力・コミットしない。あるかどうかだけ
  確かめるなら、中身を読まずに `test -f` や環境変数の名前（`printenv | cut -d= -f1` など）で見る
  （一度読んだ値は API に送られ、取り消せないため）。
- シークレットをコマンドの引数に直接書かない（シェルの履歴やログに残るため）。
- `git commit --no-verify` などでコミット前のフックを飛ばさない。フックで止まったら原因をユーザーに報告する。

# 図のフォント

- SVG の font-family は OS の標準フォントだけを並べる:
  `'Menlo', 'Consolas', 'Hiragino Sans', 'Meiryo', 'Yu Gothic', sans-serif`
  （画像として埋め込むと外部フォントを読み込めず、追加フォントやメイリオだけでは Mac で崩れるため）。
