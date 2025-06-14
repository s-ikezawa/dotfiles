#!/bin/bash

# library.sh - 共通ユーティリティ関数とログ出力
# dotfilesプロジェクト用の共通ライブラリ

# 重複読み込みを防ぐガード
if [[ -n "${DOTFILES_LIBRARY_LOADED:-}" ]]; then
    return 0
fi
readonly DOTFILES_LIBRARY_LOADED=1

set -e  # エラーが発生したら停止

# カラー定義
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly RED='\033[0;31m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m' # No Color

# ===== ログ出力関数 =====

# 成功メッセージを出力
log_success() {
    local message="$1"
    echo -e "${GREEN}✅ ${message}${NC}"
}

# 警告メッセージを出力
log_warning() {
    local message="$1"
    echo -e "${YELLOW}⚠️  ${message}${NC}"
}

# エラーメッセージを出力
log_error() {
    local message="$1"
    echo -e "${RED}❌ ${message}${NC}" >&2
}

# 情報メッセージを出力
log_info() {
    local message="$1"
    echo -e "${BLUE}📄 ${message}${NC}"
}

# セクション開始を出力
log_section() {
    local message="$1"
    echo -e "${GREEN}🔧 ${message}${NC}"
}

# ===== ユーティリティ関数 =====

# dotfilesディレクトリのパスを取得
get_dotfiles_dir() {
    local script_path="${BASH_SOURCE[1]:-$0}"
    local script_dir="$(cd "$(dirname "$script_path")" && pwd)"
    
    # scriptsディレクトリから呼び出された場合は親ディレクトリ
    if [[ "$(basename "$script_dir")" == "scripts" ]]; then
        echo "$(dirname "$script_dir")"
    else
        echo "$script_dir"
    fi
}

# コマンドの存在をチェック
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# ファイルの存在をチェック（ログ付き）
check_file_exists() {
    local file_path="$1"
    local description="${2:-ファイル}"
    
    if [[ -f "$file_path" ]]; then
        log_info "$description が見つかりました: $file_path"
        return 0
    else
        log_warning "$description が見つかりません: $file_path"
        return 1
    fi
}

# バックアップファイルを安全に削除
cleanup_backup() {
    local backup_file="$1"
    if [[ -f "$backup_file" ]]; then
        rm -f "$backup_file"
        log_info "バックアップファイルを削除しました: $backup_file"
    fi
}

# エラーハンドリング付きでコマンドを実行
safe_execute() {
    local description="$1"
    shift
    
    log_info "$description を実行中..."
    if "$@"; then
        log_success "$description が完了しました"
        return 0
    else
        log_error "$description が失敗しました"
        return 1
    fi
}

# 環境変数が設定されているかチェック
check_env_var() {
    local var_name="$1"
    if [[ -n "${!var_name}" ]]; then
        return 0
    else
        return 1
    fi
}