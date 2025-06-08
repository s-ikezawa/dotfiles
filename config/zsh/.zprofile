# ~/.config/zsh/.zprofile
# ログインシェル用のZshプロファイルファイル - .zshrcより先に実行される

# Apple Silicon Mac用のHomebrew設定
if [[ -f "/opt/homebrew/bin/brew" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# miseのPATH設定（ログインシェル用）
# mise初期化前にshimディレクトリをPATHに追加
if [[ -d "$HOME/.local/share/mise/shims" ]]; then
    export PATH="$HOME/.local/share/mise/shims:$PATH"
fi

# プログラミング言語のグローバルパッケージパス設定
# npm（Node.js）グローバルパッケージ
if [[ -d "$XDG_DATA_HOME/npm/bin" ]]; then
    export PATH="$XDG_DATA_HOME/npm/bin:$PATH"
fi

# Go言語のバイナリパス
if [[ -d "$GOPATH/bin" ]]; then
    export PATH="$GOPATH/bin:$PATH"
fi
