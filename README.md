# dotfiles

macOS の開発環境を [chezmoi](https://www.chezmoi.io/) で管理するリポジトリ。

新しい Mac で 1 コマンド叩けば、Xcode CLT → Homebrew → mise → 各種設定ファイルまで
一通り揃うことを目標にしている。

---

## セットアップ

```sh
curl -fsSL https://raw.githubusercontent.com/s-ikezawa/dotfiles/main/install.sh | bash
```

`install.sh` がやること:

1. Xcode Command Line Tools のインストール（未インストールなら）
2. chezmoi のインストールと `chezmoi init --apply s-ikezawa`

以降は chezmoi が下記のフローを回す。

---

## 反映される流れ

`chezmoi apply`（`chezmoi init --apply` を含む）は、**3 つのフェーズを必ずこの順**で実行する。

```
  ┌─────────────────────────────────────────────────────────────┐
  │ 1. before フェーズ    run_*_before_*                        │
  │    → $HOME にはまだ 1 ファイルも書かれていない              │
  ├─────────────────────────────────────────────────────────────┤
  │ 2. ファイル適用       dot_* / private_* / executable_*      │
  │    → ソースの内容を $HOME に展開（.tmpl はここで評価）      │
  ├─────────────────────────────────────────────────────────────┤
  │ 3. after フェーズ     run_*_after_*                         │
  │    → 全ファイルが $HOME に揃った状態で走る                  │
  └─────────────────────────────────────────────────────────────┘
```

各フェーズ内では **ファイル名のアルファベット順**に実行される。だから
`00-` `10-` `20-` … と数字を振って順序を固定している。

> **before / after を付けないと？**
> `run_once_foo.sh` のように付けない場合、before でも after でもなく
> **フェーズ 2 のファイル群と混ざってアルファベット順**に実行される。
> つまり実行タイミングが周囲のファイル名に左右されるため、このリポジトリでは
> 必ず `before` / `after` を明示する。

