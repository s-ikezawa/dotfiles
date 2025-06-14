#!/bin/bash

# 1password.sh - 1Password CLI連携機能
# 1Password Vaultから環境変数を取得して.zshenvに設定

# ライブラリを読み込み
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/library.sh"

# ===== 1Password設定処理 =====

# YAMLファイルから1Password設定を解析
parse_yaml_secrets() {
    local file="$1"
    local in_secrets=false
    local current_env_var=""
    local in_fields=false
    
    while IFS= read -r line; do
        # コメント行と空行をスキップ
        [[ "$line" =~ ^[[:space:]]*# ]] && continue
        [[ -z "$(echo "$line" | tr -d '[:space:]')" ]] && continue
        
        # secretsセクションの開始をチェック
        if [[ "$line" =~ ^secrets:[[:space:]]*$ ]]; then
            in_secrets=true
            continue
        fi
        
        # secretsセクション内の処理
        if [[ "$in_secrets" == true ]]; then
            # インデントレベル0の行が来たらsecrets終了
            if [[ "$line" =~ ^[[:alpha:]] ]]; then
                in_secrets=false
                in_fields=false
                continue
            fi
            
            # 環境変数名の行（インデントレベル1）
            if [[ "$line" =~ ^[[:space:]]{2}([A-Z_][A-Z0-9_]*):$ ]]; then
                current_env_var="${BASH_REMATCH[1]}"
                in_fields=false
                continue
            fi
            
            # 設定値の行（インデントレベル2）
            if [[ -n "$current_env_var" ]]; then
                if [[ "$line" =~ ^[[:space:]]{4}item:[[:space:]]+[\"\']*([^\"\']+)[\"\']*$ ]]; then
                    eval "item_${current_env_var}=\"${BASH_REMATCH[1]}\""
                    in_fields=false
                elif [[ "$line" =~ ^[[:space:]]{4}vault:[[:space:]]+[\"\']*([^\"\']+)[\"\']*$ ]]; then
                    eval "vault_${current_env_var}=\"${BASH_REMATCH[1]}\""
                    in_fields=false
                elif [[ "$line" =~ ^[[:space:]]{4}fields:[[:space:]]*$ ]]; then
                    # fieldsリストの開始
                    in_fields=true
                    eval "fields_${current_env_var}=''"
                elif [[ "$in_fields" == true && "$line" =~ ^[[:space:]]{6}-[[:space:]]+(.+)$ ]]; then
                    # fieldsリスト内のアイテム（インデントレベル3）
                    local field_spec="${BASH_REMATCH[1]}"
                    
                    # label: value の形式を label=value に変換
                    if [[ "$field_spec" =~ ^([a-z_]+):[[:space:]]*[\"\']*([^\"\']+)[\"\']*$ ]]; then
                        local field_type="${BASH_REMATCH[1]}"
                        local field_value="${BASH_REMATCH[2]}"
                        local field_formatted="${field_type}=${field_value}"
                        
                        # 既存のfieldsに追加（カンマ区切り）
                        eval "existing_fields=\$fields_${current_env_var}"
                        if [[ -n "$existing_fields" ]]; then
                            eval "fields_${current_env_var}=\"${existing_fields},${field_formatted}\""
                        else
                            eval "fields_${current_env_var}=\"${field_formatted}\""
                        fi
                    fi
                else
                    in_fields=false
                fi
            fi
        fi
    done < "$file"
}

# 1Password CLIからトークンを取得
get_1password_token() {
    local var_name="$1"
    local item="$2"
    local vault="$3"
    local fields="$4"
    
    # 1Password CLIコマンドを構築
    local cmd="op item get \"$item\""
    if [[ -n "$vault" ]]; then
        cmd="$cmd --vault \"$vault\""
    fi
    
    local token=""
    
    # フィールド指定がある場合はそれを使用、なければデフォルトフィールドを試行
    if [[ -n "$fields" ]]; then
        cmd="$cmd --fields \"$fields\""
        token=$(eval "$cmd" 2>/dev/null || true)
    else
        # デフォルトフィールドを順番に試行
        for default_fields in "label=token" "label=password" "label=credential"; do
            local test_cmd="$cmd --fields \"$default_fields\""
            token=$(eval "$test_cmd" 2>/dev/null || true)
            if [[ -n "$token" ]]; then
                break
            fi
        done
    fi
    
    echo "$token"
}

# 1Passwordから環境変数を取得してファイルに追記
process_1password_secrets() {
    local config_file="$1"
    local output_file="$2"
    
    if ! check_file_exists "$config_file" "1Password設定ファイル"; then
        log_warning "1password-config.ymlファイルを編集して、実際の1Passwordアイテムを設定してください"
        return 1
    fi
    
    log_info "1Password設定ファイルから環境変数を取得中..."
    
    # YAML設定を解析
    parse_yaml_secrets "$config_file"
    
    # 設定された環境変数を処理
    local env_vars=$(grep -E '^[[:space:]]{2}[A-Z_][A-Z0-9_]*:$' "$config_file" | sed 's/^[[:space:]]*//' | sed 's/:$//' | grep -v '^#')
    
    for var_name in $env_vars; do
        eval "item=\$item_${var_name}"
        eval "vault=\$vault_${var_name}"
        eval "fields=\$fields_${var_name}"
        
        if [[ -n "$item" ]]; then
            log_info "取得中: $var_name <- $item"
            local token=$(get_1password_token "$var_name" "$item" "$vault" "$fields")
            
            if [[ -n "$token" ]]; then
                # 環境変数を直接exportして.zshenvに出力（改行を追加）
                echo "" >> "$output_file"
                echo "export $var_name=\"$token\"" >> "$output_file"
                log_success "$var_name を取得しました"
            else
                log_error "$item からトークンを取得できませんでした"
            fi
        fi
    done
    
    log_success "1Passwordから環境変数の取得が完了しました"
}

# 1Password統合のメイン処理
setup_1password_integration() {
    local output_file="$1"
    
    log_section "1Password環境変数の設定を開始します..."
    
    # 1Password CLIがインストールされているかチェック
    if ! command_exists op; then
        log_warning "1Password CLIがインストールされていません"
        return 1
    fi
    
    log_success "1Password CLIが検出されました"
    
    # 1Passwordにサインインしているかチェック
    if ! op account get >/dev/null 2>&1; then
        log_warning "1Password CLIにサインインしていません"
        echo "以下のコマンドでサインインしてください："
        echo "  op signin"
        return 1
    fi
    
    # dotfilesディレクトリ内の1Password設定ファイル
    local dotfiles_dir="$(get_dotfiles_dir)"
    local config_file="$dotfiles_dir/1password-config.yml"
    
    # 1Password設定を処理
    process_1password_secrets "$config_file" "$output_file"
}