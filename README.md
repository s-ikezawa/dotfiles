# dotfiles

このリポジトリはdotfilesを管理するためのプロジェクトです。

## インストール方法

### ワンライナー（推奨）

パスワード入力が可能なワンライナー：

```bash
curl -fsSL https://raw.githubusercontent.com/s-ikezawa/dotfiles/main/install.sh -o /tmp/install.sh && bash /tmp/install.sh && rm /tmp/install.sh
```

### 従来のクローン方法

```bash
git clone git@github.com:s-ikezawa/dotfiles.git
cd dotfiles
./install.sh
```

### インストール後の追加手順

dotfilesのインストールが完了したら、新しいターミナルセッションを開いて以下のコマンドを実行してください：

```bash
mise install
```

このコマンドにより、Node.js、Python、Goの最新バージョンが自動的にインストールされます。

## 含まれる設定ファイル

- Shell設定 (zsh) - XDG Base Directory仕様準拠
- Git設定
- mise設定（プログラミング言語バージョン管理）
- npm、pip、Go言語のXDG準拠設定
- Ghosttyターミナル設定
- UDEV Gothicフォント
- その他の開発環境設定

## ターミナル環境（Ghostty）

このdotfilesではGhosttyターミナルとUDEV Gothicフォントを使用します。

### インストールされるもの
- **Ghostty**: 高性能なGPUアクセラレーション対応ターミナル
- **UDEV Gothic**: プログラミングに最適化された日本語対応フォント
- **UDEV Gothic Nerd Font**: アイコンフォント付きバージョン
- **UDEV Gothic HS**: 半角スペース調整版

### Ghostty設定の特徴
- UDEV Gothic Nerd Fontを使用
- 背景透明度95%
- 適切なパディング設定
- zshシェル統合
- 日本語IME対応
- 標準的なmacOSキーバインド

## XDG Base Directory準拠

このdotfilesはXDG Base Directory仕様に準拠しており、設定ファイルやデータが適切なディレクトリに配置されます。

### プログラミング言語の設定

各プログラミング言語のパッケージ管理ツールもXDG準拠に設定されています：

#### npm（Node.js）
- **設定ファイル**: `~/.config/npm/npmrc`
- **グローバルパッケージ**: `~/.local/share/npm/`
- **キャッシュ**: `~/.cache/npm/`

#### pip（Python）
- **設定ファイル**: `~/.config/pip/pip.conf`
- **ログファイル**: `~/.local/share/pip/pip.log`
- **キャッシュ**: `~/.cache/pip/`

#### Go言語
- **GOPATH**: `~/.local/share/go/`
- **モジュールキャッシュ**: `~/.cache/go/mod/`
- **ビルドキャッシュ**: `~/.cache/go-build/`

## プログラミング言語管理（mise）

このdotfilesではmiseを使用してプログラミング言語のバージョン管理を行います。

### 自動インストールされる言語

グローバル設定（`~/.config/mise/config.toml`）で以下の言語の最新版が定義されています：

- **Node.js** (latest)
- **Python** (latest) 
- **Go** (latest)

### インストール方法

dotfilesのセットアップ完了後、新しいターミナルセッションで以下のコマンドを実行してください：

```bash
mise install
```

これにより、config.tomlで定義されたすべてのプログラミング言語の最新版が一括インストールされます。

### よく使うmiseコマンド

```bash
# config.tomlで定義されたツールを一括インストール
mise install

# インストール済みツールの確認
mise list

# 特定バージョンのインストール
mise install nodejs@18.17.0

# グローバル設定の変更
mise use --global nodejs@20.0.0

# プロジェクト用設定
mise use nodejs@18.17.0
```