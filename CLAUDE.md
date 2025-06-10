# CLAUDE.md

このファイルは、このリポジトリで作業する際のClaude Code (claude.ai/code) へのガイダンスを提供します。

## リポジトリ概要

これはmacOS（部分的にLinux/WSLもサポート）上の開発環境設定を管理するための個人用dotfilesリポジトリです。XDG Base Directory仕様に準拠し、GNU Stowを使用してシンボリックリンクを管理しています。

## 主要コマンド

### インストール
```bash
# ワンライナーインストール（推奨）
curl -fsSL https://raw.githubusercontent.com/s-ikezawa/dotfiles/main/install.sh -o /tmp/install.sh && bash /tmp/install.sh && rm /tmp/install.sh

# インストール後、プログラミング言語をインストール
mise install
```

### Stow管理
```bash
# 設定を適用（リポジトリルートから）
stow -v -t "$HOME/.config" config

# 設定を削除
stow -v -D -t "$HOME/.config" config
```

### 開発環境
```bash
# config/mise/config.tomlで定義されたすべてのプログラミング言語をインストール/更新
mise install

# インストール済みバージョンを確認
mise list

# 特定バージョンをインストール
mise install nodejs@18.17.0
```

### Visual Studio Code
```bash
# VS Code設定のシンボリックリンクを作成
stow -v -t "$HOME" vscode
```

### tmux
```bash
# tmuxプラグインマネージャー（TPM）のインストール
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# tmux起動後、プラグインインストール
# Prefix + I（大文字のi）でプラグインをインストール
```

## アーキテクチャ

### ディレクトリ構造
- `config/` - すべてのアプリケーション設定（XDG準拠）
  - `zsh/` - シェル設定（.zshenv、.zshrc）
  - `git/` - Git設定とグローバルgitignore
  - `mise/` - プログラミング言語バージョン管理
  - `ghostty/` - ターミナルエミュレータ設定
  - `npm/`, `pip/` - パッケージマネージャー設定
  - `tmux/` - tmux設定（プラグイン管理とCatppuccinテーマ）
- `vscode/` - Visual Studio Code設定（settings.json、keybindings.json）
- `claude/` - Claude.ai専用設定（CLAUDE.md、settings.json）
- `install.sh` - 自動インストールスクリプト
- `Brewfile` - macOSパッケージ定義

### インストールプロセス
1. OS検出（macOS、Ubuntu、Debian、WSL、RedHat）
2. パッケージマネージャーセットアップ（macOSはHomebrew、Linuxはapt/yum）
3. リポジトリを`~/Projects/github.com/s-ikezawa/dotfiles`にクローン
4. Brewfileからパッケージインストール（macOSのみ）
5. システムレベルのzsh設定（`/etc/zshenv`）
6. macOS固有の設定（Dock、キーリピート）
7. GNU Stowを使用したシンボリックリンク作成

### 主要な設計方針
- **XDG準拠**: ホームディレクトリではなく`~/.config/`にすべての設定を保存
- **Stowベース**: GNU Stowを使用した非破壊的なシンボリックリンク管理
- **言語管理はMise**: Node.js、Python、Goの一貫したバージョン管理
- **モジュラー構造**: 各アプリケーションが独自の設定ディレクトリを持つ
- **クロスプラットフォーム対応**: OSを検出して適切な設定を適用

## 重要な注意事項

### テスト実行時の注意
- このリポジトリにはテストコマンドが定義されていません
- lintやtypecheckのコマンドも存在しません
- 設定ファイルの検証は手動で行う必要があります

### ファイル操作時の注意
- 設定ファイルを編集する際は、既存のフォーマットとインデントを維持してください
- シェルスクリプトはBash互換性を保つようにしてください
- XDG Base Directory仕様に準拠した配置を心がけてください

### 推奨される作業フロー
1. 設定を変更する前に現在の状態をバックアップ
2. 変更後は実際のアプリケーションで動作確認
3. 問題がある場合は`stow -D`で設定を削除して再適用