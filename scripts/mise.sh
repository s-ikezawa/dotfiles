#!/bin/bash

# mise.sh - プログラミング言語環境管理
# miseを使用してプログラミング言語のインストールと管理

# ライブラリを読み込み
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/library.sh"

# ===== mise設定処理 =====

# miseの利用可能性をチェック
check_mise_availability() {
    if ! command_exists mise; then
        log_error "miseが見つかりません。install.shを先に実行してください。"
        return 1
    fi
    
    log_success "miseが利用可能です"
    return 0
}

# mise環境をアクティベート
activate_mise_environment() {
    log_info "mise環境をアクティベート中..."
    
    # miseの環境を読み込む
    if eval "$(mise activate bash)"; then
        log_success "mise環境のアクティベートが完了しました"
        return 0
    else
        log_error "mise環境のアクティベートに失敗しました"
        return 1
    fi
}

# プログラミング言語をインストール
install_programming_languages() {
    log_info "設定ファイルに基づいてプログラミング言語をインストールします..."
    
    if mise install; then
        log_success "プログラミング言語のインストールが完了しました！"
        return 0
    else
        log_error "プログラミング言語のインストールに失敗しました"
        return 1
    fi
}

# インストール済みバージョンを表示
show_installed_versions() {
    log_info "インストール済みのバージョン："
    mise list
}

# mise設定のメイン処理
setup_programming_environment() {
    log_section "プログラミング言語のインストールを開始します..."
    
    # miseの利用可能性をチェック
    if ! check_mise_availability; then
        return 1
    fi
    
    # mise環境をアクティベート
    if ! activate_mise_environment; then
        return 1
    fi
    
    # すべての言語をインストール
    if ! install_programming_languages; then
        return 1
    fi
    
    echo ""
    show_installed_versions
    
    return 0
}