# dotfiles

## Xcode Command Line Tools のインストール

```bash
xcode-select --install
```

## chezmoi のバイナリダウンロードと設定の反映

```bash
mkdir -p $HOME/.local/bin && sh -c "$(curl -fsLS get.chezmoi.io)" -- -b ~/.local/bin init --apply s-ikezawa
```
