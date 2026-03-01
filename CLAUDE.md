# dotfiles

GNU stow を利用して設定ファイルを管理するリポジトリ。
`stow --no-folding --restow <パッケージ名>` で `$HOME` にシンボリックリンクを作成する。

## リポジトリ構成

| フォルダ | ツール | 配置先 | 概要 |
|---------|--------|--------|------|
| `aerospace/` | AeroSpace | `~/.config/aerospace/` | タイル型ウィンドウマネージャ (vim風キーバインド、borders連携、VLCタイリング) |
| `bash/` | Bash | `~/.bashrc` | シェル環境変数・エイリアス読み込み、mise/zoxide 有効化 |
| `bat/` | bat | `~/.config/bat/` | Catppuccin Mocha テーマ設定、テーマファイル4種同梱 |
| `claude/` | Claude Code | `~/.config/claude/` | settings.json (権限設定)、グローバル CLAUDE.md |
| `ghostty/` | Ghostty | `~/.config/ghostty/` | ターミナルエミュレータ設定 (フォント・テーマ・キーバインド) |
| `git/` | Git | `~/.config/git/` | グローバル設定 (delta pager、Catppuccin Mocha テーマ、エイリアス) |
| `lazygit/` | lazygit | `~/.config/lazygit/` | Git TUI クライアント (delta pager、Catppuccin Mocha テーマ) |
| `mise/` | mise | `~/.config/mise/` | ツールバージョン管理 (bat, eza, fd, fzf, tmux, neovim, ripgrep, yazi, zoxide) |
| `nvim/` | Neovim | `~/.config/nvim/` | init.lua + lua/config/{options,keymaps,autocmds} + lua/plugins/init |
| `sheldon/` | sheldon | `~/.config/sheldon/` | Zsh プラグインマネージャ (autosuggestions, syntax-highlighting, completions) |
| `shell/` | 共通シェル設定 | `~/.config/shell/` | env.sh, env.darwin.sh (XDG/PATH), aliases.sh (bash/zsh 共通) |
| `tmux/` | tmux | `~/.config/tmux/` | Prefix=Ctrl+s、vim風キーバインド、Catppuccin Mocha ステータスバー |
| `yazi/` | yazi | `~/.config/yazi/` | ファイルマネージャ設定、Catppuccin Mocha テーマ、fr/git プラグイン |
| `zsh/` | Zsh | `~/.config/zsh/` | .zshenv (env.sh 読み込み)、.zshrc (aliases/mise/zoxide 有効化) |

## その他のファイル

- `Brewfile` - Homebrew でインストールするパッケージ (git, stow, 1password, ghostty, font-udev-gothic-nf)
- `install.sh` - セットアップスクリプト (Homebrew, Rust, mise, Claude Code, macOS 設定, stow 実行)
- `README.md` - インストール手順

## 共通方針

- テーマ: Catppuccin Mocha を ghostty / tmux / yazi / bat で統一
- XDG Base Directory 準拠 (`~/.config/` 配下に配置)
- mise でランタイム・CLI ツールのバージョン管理
