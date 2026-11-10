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
| `Git user.email（プライベート用 github.com/s-ikezawa）?` | `~/Projects/github.com/s-ikezawa/` 配下の `user.email` |
| `Git user.email（会社用 github.com/ebisol）?` | `~/Projects/github.com/ebisol/` 配下の `user.email` |

`user.email` は `~/.config/git/config` の `includeIf` で、リポジトリの場所ごとに切り替える。
どれにも当てはまらない場所では `user.useConfigOnly = true` のため commit できない（メールアドレスの取り違えを防ぐ）。
この dotfiles リポジトリ（`~/.local/share/chezmoi`）も当てはまらないので、commit する前にリポジトリに設定しておく
（`user.name` はグローバルのものが使われる）。

```sh
chezmoi git -- config --local user.email "<プライベート用のメールアドレス>"
```

項目の定義は `.chezmoi.toml.tmpl` にある。

### 手で作るファイル

会社のホスト名など、公開したくない設定は chezmoi で管理せず、マシンごとに次のファイルへ手で書く。
どちらも無くてもエラーにはならないので、必要になったときに作ればよい（中身は今のマシンから写す）。

| ファイル | 読み込む場所 | 書くもの |
| --- | --- | --- |
| `~/.ssh/config.local` | `~/.ssh/config` の先頭 | 会社のサーバーの `Host` など |
| `~/.config/git/config.local` | `~/.config/git/config` の末尾 | 会社のホストのリポジトリ用の `includeIf`（`path = users/ebisol` で会社用の `user.email` を使う） |

`~/.config/git/config.local` を作り忘れると、そこに書くはずだった場所のリポジトリでは
`user.useConfigOnly = true` のため commit できない（別のメールアドレスで commit されることはない）。

### 入力した値を変更するとき

もう一度入力し直す場合は `--prompt` を付けて init し、反映する。

```sh
chezmoi init --prompt
chezmoi apply
```

`~/.config/chezmoi/chezmoi.toml` を直接編集して `chezmoi apply` してもよい。
