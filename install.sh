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
        echo "🔐 管理者権限が必要です。パスワードを入力してください："
        
        # Homebrewのインストール（公式のインストールスクリプトを使用）
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        
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

# dotfilesリポジトリをクローン
clone_dotfiles() {
    DOTFILES_DIR="$HOME/Projects/github.com/s-ikezawa"
    REPO_URL="https://github.com/s-ikezawa/dotfiles.git"
    
    echo "📂 dotfilesリポジトリをクローンします..."
    
    # ディレクトリが存在しない場合は作成
    if [[ ! -d "$DOTFILES_DIR" ]]; then
        echo "📁 ディレクトリを作成します: $DOTFILES_DIR"
        mkdir -p "$DOTFILES_DIR"
    fi
    
    # リポジトリをクローン
    if [[ -d "$DOTFILES_DIR/dotfiles" ]]; then
        echo "📦 dotfilesリポジトリは既に存在します。更新します..."
        cd "$DOTFILES_DIR/dotfiles"
        git pull origin main
    else
        echo "⬇️  dotfilesリポジトリをクローンします..."
        cd "$DOTFILES_DIR"
        git clone "$REPO_URL"
        cd dotfiles
    fi
    
    echo "✅ dotfilesリポジトリの準備が完了しました！"
    echo "📍 現在のディレクトリ: $(pwd)"
}

# macOS用のパッケージインストール
install_macos_packages() {
    if [[ "$OS" == "macos" ]]; then
        echo "🍺 Brewfileからパッケージをインストールします..."
        
        # Brewfileが存在するか確認
        if [[ -f "Brewfile" ]]; then
            echo "📋 Brewfileが見つかりました。パッケージをインストールします..."
            brew bundle install
            echo "✅ brew bundle installが完了しました！"
        else
            echo "⚠️  Brewfileが見つかりません。スキップします。"
        fi
    fi
}

# stowを使って設定ファイルをシンボリックリンクで配置
setup_dotfiles_with_stow() {
    echo "🔗 stowを使って設定ファイルを配置します..."
    
    # stowが利用可能か確認
    if ! command -v stow >/dev/null 2>&1; then
        echo "❌ stowが見つかりません。パッケージインストールが完了していない可能性があります。"
        return 1
    fi
    
    # zshディレクトリが存在するか確認
    if [[ -d "zsh" ]]; then
        echo "📁 zsh設定ファイルをstowで配置します..."
        
        # 既存の.zshenvをバックアップ（存在する場合）
        if [[ -f "$HOME/.zshenv" && ! -L "$HOME/.zshenv" ]]; then
            echo "📝 既存の ~/.zshenv をバックアップします..."
            mv "$HOME/.zshenv" "$HOME/.zshenv.backup.$(date +%Y%m%d_%H%M%S)"
        fi
        
        # stowでzsh設定をシンボリックリンク
        stow -v -t "$HOME" zsh
        echo "✅ zsh設定ファイルの配置が完了しました！"
        
        # 設定が正しく配置されたか確認
        if [[ -L "$HOME/.zshenv" ]]; then
            echo "✅ ~/.zshenv がシンボリックリンクとして作成されました"
        fi
        
        if [[ -d "$HOME/.config/zsh" ]]; then
            echo "✅ ~/.config/zsh ディレクトリが作成されました"
        fi
    else
        echo "⚠️  zshディレクトリが見つかりません。スキップします。"
    fi
}

# dotfilesリポジトリをクローン
clone_dotfiles

# macOSの場合はパッケージをインストール
install_macos_packages

# stowを使って設定ファイルを配置
setup_dotfiles_with_stow

echo "✅ dotfiles インストールが完了しました！"
