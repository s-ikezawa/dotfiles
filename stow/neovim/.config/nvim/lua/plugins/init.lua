-- プラグイン設定のエントリーポイント
-- このファイルは lazy.nvim によって自動的に読み込まれます

-- 各カテゴリのプラグイン設定を読み込み
local plugins = {}

-- カラースキーム設定を追加
vim.list_extend(plugins, require('plugins.colorscheme'))

-- Treesitter設定を追加
vim.list_extend(plugins, require('plugins.treesitter'))

-- UI関連プラグイン設定を追加
vim.list_extend(plugins, require('plugins.ui'))

-- 開発支援プラグイン設定を追加
vim.list_extend(plugins, require('plugins.development'))

return plugins