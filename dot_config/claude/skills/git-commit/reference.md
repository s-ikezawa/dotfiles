# コミットメッセージの詳細

- [型の選び方](#型の選び方)
- [scope の付け方](#scope-の付け方)
- [変更の種類ごとの Why](#変更の種類ごとの-why)
- [良い例・悪い例](#良い例悪い例)
- [分割の例](#分割の例)
- [トレーラ](#トレーラ)
- [BREAKING CHANGE](#breaking-change)
- [なぜここまで書くのか](#なぜここまで書くのか)

## 型の選び方

**リポジトリの履歴に別の型体系があれば、そちらが優先。** 履歴から読み取れないときだけ
Conventional Commits の既定（feat / fix / docs / style / refactor / perf / test / build /
ci / chore / revert）に落とす。

判断が割れやすいのは次の 2 つ。

- 挙動を変えない整形は `style`、挙動を変えない構造変更は `refactor`。どちらも「振る舞いが
  変わらない」と件名で言い切れるときだけ使う。言い切れないなら `fix` か `feat`。
- コード以外を主に扱うリポジトリ（ドキュメント、ノート、設定集）では、履歴が
  `add` / `update` / `remove` / `restructure` のような操作寄りの型を使っていることがある。
  無理に上の語彙へ寄せず、履歴の語彙をそのまま使う。誤りの訂正は `fix`。

## scope の付け方

- 履歴で実際に使われている scope 名の集合から選ぶ（`git log --oneline -50` で確認できる）。
- 該当がなければ、変更の中心にあるモジュール名・ディレクトリ名・機能名を短く。
- 全体に及ぶ変更や、うまく 1 語にならない変更では scope を省略してよい。
- 履歴が scope を使っていないなら、自分も使わない。

## 変更の種類ごとの Why

| 変更の種類 | 書くべき Why | 例 |
| --- | --- | --- |
| 修正（corrective） | 発生した事象・再現条件 | 削除済み商品を返金処理すると null になる |
| 適応（adaptive） | 要件・外部要因 | API v2 が旧形式を受け付けなくなるため |
| 改善（perfective） | 目的・利点 | 命名を揃えて呼び出し側の分岐を減らすため |
| 純粋な整形 | 省略可 | 機能的変更がないなら Why は書かなくてよい |

What 側は、**変更対象のコードオブジェクト（関数名・クラス名・ファイル名）を明示する**のが
最も有用。

## 良い例・悪い例

悪い例:

```text
fix bug
```

何を直したのかも、なぜ直したのかも分からない。検索にも引っかからない。

悪い例（What はあるが Why がない）:

```text
fix(payment): PaymentProcessor に null チェックを追加
```

差分を読めば分かることしか書いていない。「なぜ null が来るのか」が最重要情報なのに欠けている。

良い例（日本語）:

```text
fix(payment): 削除済み商品の返金で null になる問題を修正

なぜ: 本番で発生した障害。削除済み商品の返金時に Product が解決できず
      PaymentProcessor#refund で NullPointerException が発生していた。
何を: 商品参照を Optional で受け、解決できない場合は保存済みスナップショットの
      価格で返金する。
補足: 削除時に返金を禁止する案は、既存の返金期限（90 日）と両立しないため不採用。

Refs: #456
```

良い例（英語・見出しなしの段落）:

```text
fix(auth): stop refreshing tokens on every request

The refresh endpoint was called on each API request because the expiry
check compared seconds against milliseconds, adding ~120ms of latency to
every authenticated call.

Compare against Date.now() consistently in TokenStore#isExpired, and add a
regression test for a token that expires in 30 seconds.

Refs: #789
```

どちらも Why があり、固有名詞（`PaymentProcessor#refund`、`NullPointerException`、
`TokenStore#isExpired`）で検索でき、却下案や根本原因が残っている。

## 分割の例

作業ツリーに次が混ざっている場合:

- `src/parser.ts` — バグ修正
- `src/parser.test.ts` — その回帰テスト
- `README.md` — 無関係な誤字修正

修正とそのテストは 1 つの Why を共有するので同じコミットにする。README の誤字は別コミット。

```sh
git add -- src/parser.ts src/parser.test.ts
git commit -F - <<'MSG'
...
MSG

git add -- README.md
git commit -F - <<'MSG'
docs: README の誤字を修正
MSG
```

## トレーラ

- **番号を推測しない。** ユーザーの指示・ブランチ名・コード内の参照から確実に分かるときだけ書く。
- キー名は履歴で使われているものに合わせる（`Refs` と `Ref`、`Fixes` と `Closes` を混ぜない）。
- 本文に手で連結せず `--trailer` で足す。ブロックの区切りが正しく保たれる。

## BREAKING CHANGE

`!` とフッタは併用してよい。フッタに書くのは変更点の再掲ではなく、**利用者が移行のために
何をする必要があるか**。`BREAKING CHANGE` は大文字必須。

## なぜここまで書くのか

AI エージェントが見られるのはリポジトリの**現在の状態だけ**で、「なぜ今の形になったのか」
「どの方針が既に試されて捨てられたのか」はコードに残らない。一方でエージェントは
`git log --grep` や `git log -S` を実行できる。つまりコミット履歴は、追加コストゼロで使える
検索可能なメモリ層になりうる——メッセージに検索で引っかかる情報が書かれている場合に限り。
`fix bug` しかない履歴は、メモリ層としては空である。

これは人間向けの原則（What と Why を書く）と別物ではなく、同じ原則が効く場面が増えた、
というだけ。差分から What を要約するのは AI が得意だが、Why は原理的に分からない。だから
手順 4 で会話や issue から Why を拾い、拾えなければ聞く。

## 出典

- [What Makes a Good Commit Message? (arXiv:2202.02974)](https://arxiv.org/abs/2202.02974)
- [Commit Message Matters (ICSE 2023)](https://dl.acm.org/doi/abs/10.1109/ICSE48619.2023.00076)
- [Conventional Commits v1.0.0](https://www.conventionalcommits.org/en/v1.0.0/)
- [git-interpret-trailers(1)](https://git-scm.com/docs/git-interpret-trailers)
