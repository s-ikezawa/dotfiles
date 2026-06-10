-- ~/.config/nvim/lua/plugins/treesitter.lua
-- Tree-sitter (Parser / Highlight)

require("tree-sitter-manager").setup({
  ensure_installed = "all", -- 全てのパーサーをインストールする
  auto_install = false,     -- ファイルを開いた際の自動インストールは無効
  highlight = true,         -- Tree-sitter によるシンタックスハイライトを有効にする
})
