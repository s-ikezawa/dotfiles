# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## リポジトリ概要

このdotfilesリポジトリは、macOS環境での個人開発環境を管理するためのものです。GNU Stowを使用してシンボリックリンクで設定ファイルを管理し、XDG Base Directory仕様に準拠した構成になっています。

## 主要なコマンド

### 設定ファイルのセットアップ
```bash
# すべての設定ファイルのシンボリックリンクを作成
./install.sh

# Homebrewパッケージのインストール
brew bundle

# macOS固有の設定を適用
./script/macos.sh
```

### 新しい設定を追加する場合
```bash
# 新しいアプリケーションの設定ディレクトリを作成
mkdir -p stow/[app_name]/.config/[app_name]

# 設定ファイルを追加後、シンボリックリンクを作成
cd ~/Projects/s-ikezawa/dotfiles
stow -v -d stow -t ~ [app_name]
```

## アーキテクチャと構成

### ディレクトリ構造
- `stow/`: 各アプリケーションの設定ファイルを格納
  - 各サブディレクトリはホームディレクトリの構造を模倣
  - GNU Stowによってホームディレクトリにシンボリックリンクが作成される
- `script/`: セットアップスクリプト
- `Brewfile`: Homebrewでインストールするパッケージリスト

### 重要な規約
1. **XDG Base Directory仕様の準拠**: 設定ファイルは`.config/`以下に配置
2. **日本語での記述**: グローバルなCLAUDE.mdの設定により、コメント、コミットメッセージはすべて日本語で記述
3. **シンボリックリンク管理**: GNU Stowを使用してファイルの実体は`stow/`以下に保持し、ホームディレクトリにはシンボリックリンクのみを配置

### 設定ファイルの追加・変更時の注意点
- 新しい設定ファイルは必ず`stow/[app_name]/`以下に適切なディレクトリ構造で配置
- `.DS_Store`ファイルは自動的に無視される
- 設定変更後は`install.sh`を実行してシンボリックリンクを更新