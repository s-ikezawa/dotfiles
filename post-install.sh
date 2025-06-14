#!/bin/bash

# post-install.sh - dotfilesインストール後の追加設定スクリプト
# モジュラー設計でメンテナンス性を向上

set -e  # エラーが発生したら停止

# scriptsディレクトリのパスを取得
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/scripts"

# ライブラリを読み込み
source "$SCRIPT_DIR/library.sh"
source "$SCRIPT_DIR/zshenv.sh"
source "$SCRIPT_DIR/mise.sh"

# ===== メイン処理 =====

main() {
    log_section "dotfiles post-installスクリプトを開始します..."
    
    # .zshenv設定の処理
    if setup_zshenv; then
        log_success ".zshenv設定が完了しました"
    else
        log_error ".zshenv設定に失敗しました"
        exit 1
    fi
    
    echo ""
    
    # プログラミング環境のセットアップ
    if setup_programming_environment; then
        log_success "プログラミング環境のセットアップが完了しました"
    else
        log_error "プログラミング環境のセットアップに失敗しました"
        exit 1
    fi
    
    echo ""
    log_success "すべての post-install処理が完了しました！"
}

# スクリプトが直接実行された場合のみmainを実行
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi