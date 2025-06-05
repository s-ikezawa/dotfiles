# 全てのZshセッションで読み込まれる環境変数設定

#---------------------------------------------------------------------------------------------
# XDG Base Directory specification
#---------------------------------------------------------------------------------------------
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

# ディレクトリが存在しなければ作成
[[ ! -d "$XDG_CONFIG_HOME/zsh" ]] && mkdir -p "$XDG_CONFIG_HOME/zsh"
[[ ! -d "$XDG_DATA_HOME" ]] && mkdir -p "$XDG_DATA_HOME"
[[ ! -d "$XDG_CACHE_HOME" ]] && mkdir -p "$XDG_CACHE_HOME"
[[ ! -d "$XDG_STATE_HOME/zsh" ]] && mkdir -p "$XDG_STATE_HOME/zsh"

#---------------------------------------------------------------------------------------------
# MacOS
#---------------------------------------------------------------------------------------------
# macOSのZshセッション保存機能を無効化
export SHELL_SESSIONS_DISABLE=1

#---------------------------------------------------------------------------------------------
# GitHub
#---------------------------------------------------------------------------------------------
export GITHUB_PERSONAL_ACCESS_TOKEN=$(op item get GitHub --fields label="For MCP Server")

#---------------------------------------------------------------------------------------------
# Golang
#---------------------------------------------------------------------------------------------
export GOPATH="$XDG_DATA_HOME/go"
export GOBIN="$XDG_DATA_HOME/go/bin"
export PATH="$GOBIN:$PATH"

#---------------------------------------------------------------------------------------------
# PostgreSQL
#---------------------------------------------------------------------------------------------
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
