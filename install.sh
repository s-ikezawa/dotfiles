#!/bin/bash

# dotfiles インストールスクリプト
set -e  # エラーが発生したら停止

echo "🚀 dotfiles インストールを開始します..."

# OS を判定
detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # WSL (Windows Subsystem for Linux) の検出
        if [[ -f /proc/version ]] && grep -qi microsoft /proc/version; then
            echo "wsl"
        # Ubuntu の検出
        elif [[ -f /etc/os-release ]] && grep -qi "ubuntu" /etc/os-release; then
            echo "ubuntu"
        # Debian の検出
        elif [[ -f /etc/debian_version ]]; then
            echo "debian"
        # Red Hat系の検出
        elif [[ -f /etc/redhat-release ]]; then
            echo "redhat"
        else
            echo "linux"
        fi
    else
        echo "unknown"
    fi
}

OS=$(detect_os)
echo "🖥️  検出されたOS: $OS"

case $OS in
    "unknown")
        echo "❌ サポートされていないOSです: $OSTYPE"
        exit 1
        ;;
esac

# パッケージマネージャーのインストール
install_package_manager() {
    case $OS in
        "macos")
            install_homebrew
            ;;
        "ubuntu"|"debian")
            install_apt_packages
            ;;
        "wsl")
            install_wsl_packages
            ;;
        "redhat"|"linux")
            install_yum_packages
            ;;
    esac
}

# Homebrew のインストール (macOS)
install_homebrew() {
    if command -v brew >/dev/null 2>&1; then
        echo "✅ Homebrew は既にインストールされています"
        echo "📦 Homebrew のバージョン: $(brew --version | head -n1)"
    else
        echo "📦 Homebrew をインストールします..."
        
        # 非対話モードかどうかを判定（複数の方法で確認）
        if [[ ! -t 0 ]] || [[ -n "${CI:-}" ]] || [[ -n "${GITHUB_ACTIONS:-}" ]] || [[ "${TERM:-}" == "dumb" ]]; then
            echo ""
            echo "⚠️  非対話モード（パイプ経由）で実行されています"
            echo "🔐 Homebrewのインストールには管理者権限が必要ですが、パスワード入力ができません"
            echo ""
            echo "📋 以下の方法で実行してください："
            echo ""
            echo "🎯 方法1: リポジトリをクローンして実行（推奨）"
            echo "   git clone https://github.com/s-ikezawa/dotfiles.git"
            echo "   cd dotfiles"
            echo "   ./install.sh"
            echo ""
            echo "🎯 方法2: Homebrewを手動インストール後に再実行"
            echo "   /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
            echo "   curl -sSL https://raw.githubusercontent.com/s-ikezawa/dotfiles/main/install.sh | bash"
            echo ""
            echo "❌ スクリプトを終了します"
            exit 1
        fi
        
        echo "🔐 管理者権限が必要です。パスワードを入力してください："
        
        # 事前にsudo権限を取得してタイムスタンプを更新
        if ! sudo -v; then
            echo "❌ 管理者権限の取得に失敗しました"
            exit 1
        fi
        
        # Homebrewのインストール（公式のインストールスクリプトを使用）
        NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        
        # Apple Silicon Mac用のPATHを設定
        echo "🍎 Apple Silicon Mac - セッション用のPATHを設定します"
        eval "$(/opt/homebrew/bin/brew shellenv)"
        
        echo "✅ Homebrew のインストールが完了しました！"
    fi
    
    # Homebrewのアップデート
    echo "🔄 Homebrew を最新版に更新します..."
    brew update
}

# APT パッケージの更新 (Debian/Ubuntu)
install_apt_packages() {
    echo "📦 APT パッケージを更新します..."
    sudo apt update && sudo apt upgrade -y
    
    # 基本的な開発ツールをインストール
    echo "🔧 基本的な開発ツールをインストールします..."
    sudo apt install -y curl wget git build-essential
    
    echo "✅ APT パッケージの更新が完了しました！"
}

# WSL パッケージの更新 (Windows Subsystem for Linux)
install_wsl_packages() {
    echo "🐧 WSL (Windows Subsystem for Linux) を検出しました"
    echo "📦 APT パッケージを更新します..."
    sudo apt update && sudo apt upgrade -y
    
    # WSL用の基本的な開発ツールをインストール
    echo "🔧 WSL用の基本的な開発ツールをインストールします..."
    sudo apt install -y curl wget git build-essential ca-certificates gnupg lsb-release
    
    # WSL特有の設定
    echo "⚙️  WSL特有の設定を適用します..."
    
    echo "✅ WSL パッケージの更新が完了しました！"
}

# YUM/DNF パッケージの更新 (RHEL/CentOS/Fedora)
install_yum_packages() {
    # dnf が利用可能か確認
    if command -v dnf >/dev/null 2>&1; then
        PKG_MANAGER="dnf"
    elif command -v yum >/dev/null 2>&1; then
        PKG_MANAGER="yum"
    else
        echo "❌ パッケージマネージャーが見つかりません"
        exit 1
    fi
    
    echo "📦 $PKG_MANAGER パッケージを更新します..."
    sudo $PKG_MANAGER update -y
    
    # 基本的な開発ツールをインストール
    echo "🔧 基本的な開発ツールをインストールします..."
    sudo $PKG_MANAGER install -y curl wget git gcc gcc-c++ make
    
    echo "✅ $PKG_MANAGER パッケージの更新が完了しました！"
}

# パッケージマネージャーのインストールを実行
install_package_manager

echo "✅ dotfiles インストールが完了しました！"
