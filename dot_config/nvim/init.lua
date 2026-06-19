-- ============================================================================
-- Neovim エントリーポイント
-- ============================================================================

require("options")    -- オプション設定（lua/options.lua）を読み込む
require("autoreload") -- 外部変更の自動取り込み（lua/autoreload.lua）を読み込む
require("plugins")    -- プラグイン設定（lua/plugins/init.lua）を読み込む
require("lsp")        -- LSP 設定（lua/lsp.lua, ネイティブ vim.lsp）を読み込む
