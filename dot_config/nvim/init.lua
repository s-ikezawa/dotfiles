-- Neovim 設定エントリーポイント
-- 設定モジュールは lua/config/ 配下に配置する

-- Leader キーは最初に設定する必要がある
-- (プラグインのキーマップ宣言時に <leader> が解決されるため、それより前で確定させる)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("config.options")
require("config.providers")
require("config.plugins")
require("config.lsp")
require("config.keymaps")
