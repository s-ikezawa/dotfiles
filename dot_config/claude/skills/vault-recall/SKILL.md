---
name: vault-recall
description: ユーザーのナレッジ Vault（obsidian-vault リポジトリ）から、今の作業に関係する過去の知識・判断・ミスを探して使う。「前に調べた？」「Vault にある？」「過去の判断は？」と聞かれたとき、また、エラーの調査やツールの設定などで、以前に同じことを調べたり決めたりしていそうなときに使う。
---

# Vault から思い出す

Vault は `~/Projects/github.com/s-ikezawa/obsidian-vault` にある（なければ `ghq list -p | rg obsidian-vault`）。
ナレッジは `vault/` の下にあり、書き方の決まりはリポジトリのルートの `AGENTS.md` にある。

## 探す順番

Vault 全体を読まない。目次と要約で当たりを付け、必要な本文だけを開く。

1. `vault/index.md` を読み、関係しそうなフォルダを選ぶ。
2. そのフォルダの `index.md` を読み、`description` から候補を 3 件まで選ぶ。
   作業中のリポジトリに対応する `vault/projects/<リポジトリ名>/` があれば、その `index.md` も読む。
3. 目次で見つからなければ、frontmatter を `rg` で探す（`-g '!templates/'` で templates を外す）:
   - `rg -n '^description:.*<語>' <Vault>/vault -g '!templates/'`
   - `rg -n '^(tags|aliases):.*<語>' <Vault>/vault -g '!templates/'`
   - エラーメッセージなら本文も: `rg -nF '<エラーの一部>' <Vault>/vault/notes`
4. 候補の本文を読む。読んだノートの中のリンクは、必要なものだけ辿る。
5. 見つからなければ、ないと伝える。似たノートで代用しない。

## 読んだ内容の扱い

frontmatter で、どこまで信用してよいかを判断し、ユーザーに伝えるときも添える。

- `status: deprecated` は古い情報。本文の先頭にある代わりのノートを読む。
- `status: draft`、または `verified` がないものは、確かめられていない。そのまま事実として使わず、確かめてから使う。
- `verified` に `human:` があればユーザーが確かめたもの。AI の名前だけなら AI が確かめたもの。
- `generated.at` が最新の `verified` の `at` より新しければ、その後の変更は確かめられていない。
- `stale_after` を過ぎていたら古い可能性がある。
- `vault/inbox/` は取り込んだだけの記事の原文なので、根拠にしない。
- ノートに書かれた環境（バージョンや OS）が今の作業と違えば、そのまま当てはまるとは限らない。

## 伝え方

どのノートを根拠にしたかを、ファイルのパスで示す。ノートが古い・確かめられていないなど、
信用度に注意が要るときはそれも書く。

## 見つけたことが今の作業と食い違ったら

ノートが間違っている・古いと分かったら、`vault-remember` Skill で直すことをユーザーに提案する。
