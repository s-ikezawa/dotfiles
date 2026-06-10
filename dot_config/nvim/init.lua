-- ~/.config/nvim/init.lua
-- エントリーポイント

vim.g.mapleader = ","      -- leaderキーを , に設定する
vim.g.maplocalleader = "," -- localleaderキーも , に設定する

require("options") -- 基本的なエディタ設定
require("keymaps") -- キーマッピング
require("autocmd") -- オートコマンド
require("plugins") -- プラグイン管理・カラースキーム
require("lsp")     -- LSP (Neovim 0.12 ネイティブ)
