## dotfilesの反映方法
xcode command line toolsがインストールされていない場合はインストールする。

```bash
xcode-select --install
```

以下のコマンドでdotfilesを反映する。

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply s-ikezawa
```

上記で反映した場合はダウンロードされたdotfilesのgitリポジトリの設定がhttpsになっているのでsshに変更する。

```bash
git remote set-url origin git@github.com:s-ikezawa/dotfiles.git
```

