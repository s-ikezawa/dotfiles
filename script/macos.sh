#!/bin/bash

# 隠しフォルダをFinderで表示するようにする
defaults write com.apple.Finder AppleShowAllFiles YES
killall Finder

#------------------------------------------------------------------------------------------------------------------
# 1PasswordからGitHub Personal Access Tokenを取得してzshenvファイルを生成
#------------------------------------------------------------------------------------------------------------------
echo "GitHub Personal Access Tokenを1Passwordから取得して.zshenvファイルを生成します..."

# 1Password CLIがインストールされているか確認
if ! command -v op &> /dev/null; then
    echo "エラー: 1Password CLIがインストールされていません。"
    echo "brew install 1password-cli を実行してインストールしてください。"
    exit 1
fi

# 1Passwordにサインインしているか確認
if ! op account list &> /dev/null; then
    echo "エラー: 1Passwordにサインインしていません。"
    echo "op signin を実行してサインインしてください。"
    exit 1
fi

# パスの設定
DOTFILES_DIR="$HOME/Projects/s-ikezawa/dotfiles"
TEMPLATE_FILE="$DOTFILES_DIR/stow/zsh/.config/zsh/.zshenv.template"
ZSHENV_FILE="$DOTFILES_DIR/stow/zsh/.config/zsh/.zshenv"

# テンプレートファイルが存在するか確認
if [ ! -f "$TEMPLATE_FILE" ]; then
    echo "エラー: テンプレートファイルが見つかりません: $TEMPLATE_FILE"
    exit 1
fi

# 1PasswordからTokenを取得
echo "1PasswordからGitHub Personal Access Tokenを取得しています..."
GITHUB_TOKEN=$(op item get GitHub --fields label="For MCP Server" 2>/dev/null)

if [ -z "$GITHUB_TOKEN" ]; then
    echo "エラー: 1PasswordからGitHub Personal Access Tokenを取得できませんでした。"
    echo "1PasswordにGitHubアイテムが存在し、'For MCP Server'フィールドが設定されているか確認してください。"
    exit 1
fi

# 既存のzshenvファイルがある場合はバックアップを作成
if [ -f "$ZSHENV_FILE" ]; then
    cp "$ZSHENV_FILE" "${ZSHENV_FILE}.backup"
    echo "既存のファイルをバックアップしました: ${ZSHENV_FILE}.backup"
fi

# テンプレートから.zshenvファイルを生成
echo "テンプレートから.zshenvファイルを生成しています..."
cp "$TEMPLATE_FILE" "$ZSHENV_FILE"

# プレースホルダーを実際の値に置換
sed -i '' "s|{{GITHUB_PERSONAL_ACCESS_TOKEN}}|$GITHUB_TOKEN|" "$ZSHENV_FILE"

echo "✅ .zshenvファイルを生成しました。"
echo "   設定ファイル: $ZSHENV_FILE"
echo ""
echo "⚠️  注意: このファイルには機密情報が含まれています。"
echo "   - .zshenvファイルはGitにコミットされません（.gitignoreで除外）"
echo "   - テンプレートファイル（.zshenv.template）はGit管理されます"
