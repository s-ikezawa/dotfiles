# User CLAUDE.md

## IMPORTANT

- 返答は日本語で行う

## パッケージ管理方針

- **Homebrew**: GUIツール(cask)のみを管理する。
- **mise**: CLIツール・言語ランタイムは原則すべて mise で管理する。
- **sheldon**: zsh プラグインは sheldon(`~/.config/sheldon/plugins.toml`)で管理する。Homebrew では入れない。
- **例外**: 上記いずれにも該当しないライブラリで mise レジストリに無いものは、やむを得ず Homebrew で管理してよい。
- 新規ツールを追加する際はまず mise レジストリ(`mise registry`)を確認し、存在すれば mise を選ぶこと。

