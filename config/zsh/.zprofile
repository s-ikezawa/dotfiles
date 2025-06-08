# ~/.config/zsh/.zprofile
# ログインシェル用のZshプロファイルファイル - .zshrcより先に実行される

# Apple Silicon Mac用のHomebrew設定
if [[ -f "/opt/homebrew/bin/brew" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi
