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
git clone https://github.com/s-ikezawa/dotfiles.git
cd dotfiles
./install.sh
```

### パイプ経由（制限あり）

```bash
curl -sSL https://raw.githubusercontent.com/s-ikezawa/dotfiles/main/install.sh | bash
```

**注意**: パイプ経由での実行時は、パスワード入力ができないためHomebrewが未インストールの場合はエラーになります。

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
- その他の開発環境設定

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