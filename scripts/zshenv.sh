#!/bin/bash

# zshenv.sh - .zshenv設定ファイル生成
# テンプレートから.zshenvを生成し、1Passwordから環境変数を取得

# ライブラリを読み込み
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/library.sh"
source "$SCRIPT_DIR/1password.sh"

# ===== .zshenv設定処理 =====

# テンプレートファイルから.zshenvを生成
generate_zshenv_from_template() {
    local template_file="$1"
    local output_file="$2"
    
    if ! check_file_exists "$template_file" ".zshenvテンプレートファイル"; then
        log_error ".zshenvテンプレートファイルが見つかりません: $template_file"
        return 1
    fi
    
    log_info "テンプレートから.zshenvを生成中..."
    cp "$template_file" "$output_file"
    
    # 残っている未置換のテンプレート変数を削除
    sed -i.bak -e '/{{#.*}}/,/{{\/.*}}/d' "$output_file"
    
    # バックアップファイルを削除
    cleanup_backup "$output_file.bak"
    
    log_success ".zshenvファイルの基本生成が完了しました"
}

# .zshenv設定のメイン処理
setup_zshenv() {
    local dotfiles_dir="$(get_dotfiles_dir)"
    local template_file="$dotfiles_dir/config/zsh/.zshenv.template"
    local output_file="$dotfiles_dir/config/zsh/.zshenv"
    
    log_section ".zshenv環境変数の設定を開始します..."
    
    # テンプレートから基本的な.zshenvを生成
    if ! generate_zshenv_from_template "$template_file" "$output_file"; then
        return 1
    fi
    
    # 1Password統合を試行（失敗しても処理は続行）
    setup_1password_integration "$output_file" || {
        log_warning "1Password統合をスキップしました"
    }
    
    log_success ".zshenvの生成が完了しました！"
    
    # 生成されたファイルの確認
    if [[ -f "$output_file" ]]; then
        log_info "生成されたファイル: $output_file"
        return 0
    else
        log_error ".zshenvファイルの生成に失敗しました"
        return 1
    fi
}