# dotfiles

このリポジトリはdotfilesを管理するためのプロジェクトです。

## インストール方法

### 推奨方法（対話モード）

リポジトリをクローンしてから実行（推奨）：

```bash
git clone https://github.com/s-ikezawa/dotfiles.git
cd dotfiles
./install.sh
```

### ワンライナー（制限あり）

```bash
curl -sSL https://raw.githubusercontent.com/s-ikezawa/dotfiles/main/install.sh | bash
```

**注意**: ワンライナーでの実行時、macOSでHomebrewが未インストールの場合は管理者権限の入力ができないため、手動でのインストールが必要になります。

## 含まれる設定ファイル

- Shell設定 (zsh)
- エディタ設定
- その他の開発環境設定