# ログインシェル時に実行される設定
# Homebrew設定
if [[ -f "/opt/homebrew/bin/brew" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f "/usr/local/bin/brew" ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
fi

# Homebrewの追加設定
export HOMEBREW_NO_ANALYTICS=1   # 分析データ送信を無効化
export HOMEBREW_NO_AUTO_UPDATE=1 # 自動アップデートを無効化（お好みで）
export HOMEBREW_BUNDLE_FILE="$HOME/Projects/s-ikezawa/dotfiles/Brewfile" # Brewfileの場所を指定
