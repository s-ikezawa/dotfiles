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

## 含まれる設定ファイル

- Shell設定 (zsh)
- エディタ設定
- その他の開発環境設定