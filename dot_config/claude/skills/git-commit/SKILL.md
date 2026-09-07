---
name: git-commit
description: Writes a commit message that states both what changed and why, following the repository's existing convention, then stages the relevant paths and runs git commit. Use when the user asks to commit changes, to write or fix a commit message, or to split work into atomic commits.
when_to_use: 'Trigger phrases: コミットして / コミットメッセージを書いて / 変更をコミット / コミットに分けて / commit this / write a commit message / stage and commit / split into atomic commits'
argument-hint: [背景・意図・issue 番号など（任意）]
allowed-tools: Bash(git status:*), Bash(git diff:*), Bash(git log:*), Bash(git show:*), Bash(git add:*), Bash(git commit:*), Bash(git config:*), Bash(git rev-parse:*), Bash(git symbolic-ref:*)
---

# コミットを書いて実行する

差分から What を要約し、文脈から Why を復元して、リポジトリの既存規約に沿った
メッセージでコミットする。守るべき順序は **Why を捏造しない > 1 コミット 1 目的 >
形式の統一**。

## 現在の状態

```!
git status --short --branch 2>&1 || true
echo '--- HEAD との差分（規模の把握） ---'
git diff --stat HEAD 2>&1 || true
echo '--- 直近のコミット（このリポジトリの規約を読み取る材料） ---'
git log --format='%h %s%n%b' -5 2>&1 || true
```

ユーザーからの補足: $ARGUMENTS

## 手順

このチェックリストを応答にコピーして進捗を追う。

```
- [ ] 1. 差分を読む
- [ ] 2. リポジトリの規約を読み取る
- [ ] 3. 分割するか決める
- [ ] 4. Why を確定する
- [ ] 5. メッセージを起草し、検証する
- [ ] 6. ステージしてコミットし、結果を確認する
```

### 1. 差分を読む

- `git diff --staged` と `git diff` を読む。上の diffstat が大きければパス単位で絞って読む。
- 秘密情報（API キー、トークン、認証情報、`.env` の値）が差分に含まれていたら
  **コミットせずに報告する。**

### 2. リポジトリの規約を読み取る

上の `git log` 出力から次を判断し、**既存の履歴に合わせる**。自分の好みではなく現物に従う。

| 見るもの | 合わせるもの |
| --- | --- |
| 件名 | `type(scope):` 形式か、使われている型の語彙は何か |
| 本文 | 本文を書く文化があるか、その書式（見出し語、箇条書き、段落） |
| 言語 | 日本語か英語か（混在ならユーザーの設定・指示に従う） |
| トレーラ | `Refs:` `Fixes:` `Co-authored-by:` などの慣習の有無 |

`commitlint` 設定・`.gitmessage`・`CONTRIBUTING.md` があればそれが最優先。履歴からも
設定からも読み取れないときは Conventional Commits を既定にする。確認するなら:

```sh
git config --get commit.template
ls -a "$(git rev-parse --show-toplevel)" | grep -iE 'commitlint|gitmessage|contributing' || true
```

型の選び方は [reference.md](reference.md) を参照。

### 3. 分割するか決める

**このコミットの Why を 1 文で言えないなら、分割のサイン。**

- 無関係な変更が混ざっていたら、パス単位で `git add -- <path>` して複数回に分ける。
  分けた各コミットについて手順 4〜6 を繰り返す。
- 同一ファイル内で目的が混ざっている場合はハンク単位の選別が要る。非対話では扱えないので、
  ユーザーに `git add -p` を促すか、まとめてよいか確認する。
- ユーザーが「まとめてよい」と言っているならそれに従う。分割は提案であって強制ではない。

### 4. Why を確定する

Why は差分の外にしかない。次の順で探す。

1. この会話でユーザーが述べた目的、報告した不具合、貼り付けたエラー文言
2. 補足指示（上の `$ARGUMENTS`）
3. コード中の issue 番号・TODO、失敗していたテストの内容
4. ブランチ名（`git symbolic-ref --short HEAD`）に含まれる issue 番号やキーワード

**どこからも得られないときは、推測で埋めずに一度だけ短く聞く**（「なぜこの変更が必要に
なったか」を一文で）。ただし整形・タイポ修正・機械的なリネームなど Why が自明な変更では
聞かずに省略してよい。

### 5. メッセージを起草し、検証する

```
<type>(<scope>): <要約>

なぜ: 観測された事象 / 要件 / 制約。何がきっかけでこの変更が必要になったか。
何を: 方針レベルで何をしたか。差分の逐語訳ではなく、選んだアプローチ。
補足: 検討して採らなかった案とその理由、既知の制約（あれば）

Refs: #123
```

見出し語は履歴の書式に合わせる。英語の履歴なら見出しを置かず段落で書く。

規則:

- 件名は `git log --oneline` で切れない長さ。英語 50 字以内（上限 72）、日本語 30〜40 字程度。
- 件名は現在形・命令形で、末尾に句点を打たない。
- **プレーンテキストで書く。** `git log` は Markdown を描画しない。太字・コードブロック・
  見出し記号・絵文字は使わない（本文の簡素な `-` は可）。本文は 72 字前後で折り返す。
- 検索で引ける固有名詞を入れる（関数名・ファイル名・環境変数名・実際のエラー文言・issue 番号）。
  「処理を修正」のような抽象化は履歴の検索性をゼロにする。
- 差分を読めば分かることを逐語的に繰り返さない。文脈窓は有限で、冗長な履歴は他を押し出す。
- 破壊的変更は `feat(api)!:` のように `!` を付けるか、フッタに `BREAKING CHANGE: <説明>`
  （大文字必須）を書く。
- 署名トレーラ（`Co-Authored-By` など）は、環境やユーザーの設定が指示しているときだけ付ける。
  指示がなければ付けない。

起草したら、コミット前に自己検証する。

```
- [ ] Why が 1 文で言えて、それが本文に書かれている
- [ ] What が方針レベルで書かれている（逐語訳でない）
- [ ] 検索で引ける固有名詞が入っている
- [ ] 型・scope・言語・本文の書式が履歴と一致している
- [ ] 件名が --oneline で切れない長さ
- [ ] Markdown 装飾や不要な署名が入っていない
- [ ] ステージ内容がこの Why 1 つに対応している
```

満たさない項目があれば直してから 6 へ進む。判断に迷ったら [reference.md](reference.md) の
良い例・悪い例と突き合わせる。

### 6. ステージしてコミットする

ステージ:

- **`git add -A` / `git add .` は使わない。** 意図に関係するパスだけを `git add -- <path>`
  で追加する。
- すでにステージ済みの変更があれば、ユーザーが意図的に選別した可能性がある。勝手に足さず、
  ステージ済みの内容だけでコミットしてよいか確認する。

実行（引用符やバッククォートの解釈を避けるため、メッセージは stdin から渡す）:

```sh
git commit -F - <<'MSG'
fix(payment): 削除済み商品の返金で null になる問題を修正

なぜ: ...
何を: ...
MSG
```

issue 参照などのトレーラは `--trailer` で足すと区切りが正しく保たれる（git 2.32 以降）。
古い git では本文の末尾に直接書く。

```sh
git commit -F - --trailer 'Refs: #456' <<'MSG'
...
MSG
```

やらないこと:

- `--no-verify` を使わない。フックが失敗したら原因を直して再実行する。フックがファイルを
  整形した場合は、その結果を確認してから add し直してコミットする。
- `--amend` `rebase` `reset` など履歴を書き換える操作は、ユーザーが明示的に指示したときだけ。
- **push しない。** 明示的に指示されたときだけ。

完了後に `git status --short` と `git log -1 --stat` を確認し、意図した内容だけが入ったか
検証する。ユーザーには件名と、残っている未コミットの変更を報告する。
