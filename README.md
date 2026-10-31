# dotfiles

[chezmoi](https://www.chezmoi.io/) で管理している macOS 用の dotfiles。

## インストール

新しいマシンで次を実行する。

```sh
bash -c "$(curl -fsLS https://raw.githubusercontent.com/s-ikezawa/dotfiles/main/install.sh)"
```

`install.sh` は Command Line Tools を入れたあと、`chezmoi init --apply s-ikezawa` を実行する。

### 初回に入力を求められる項目

公開リポジトリに載せたくない個人情報は、リポジトリに含めず `chezmoi init` の初回に入力する。
入力した値はそのマシンの `~/.config/chezmoi/chezmoi.toml` にだけ保存され、2 回目以降は聞かれない。

| 質問 | 用途 |
| --- | --- |
| `Git user.name?` | `~/.config/git/config` の `user.name` |
| `Git user.email?` | `~/.config/git/config` の `user.email` |

項目の定義は `.chezmoi.toml.tmpl` にある。

### 入力した値を変更するとき

もう一度入力し直す場合は `--prompt` を付けて init し、反映する。

```sh
chezmoi init --prompt
chezmoi apply
```

`~/.config/chezmoi/chezmoi.toml` を直接編集して `chezmoi apply` してもよい。
