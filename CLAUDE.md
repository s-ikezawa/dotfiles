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

## アーキテクチャ

### ディレクトリ構造
- `config/` - すべてのアプリケーション設定（XDG準拠）
  - `zsh/` - シェル設定（.zshenv、.zshrc）
  - `git/` - Git設定とグローバルgitignore
  - `mise/` - プログラミング言語バージョン管理
  - `ghostty/` - ターミナルエミュレータ設定
  - `npm/`, `pip/` - パッケージマネージャー設定
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