-- ============================================================================
-- Catppuccin - カラーテーマ
-- https://github.com/catppuccin/nvim
-- ============================================================================

require("catppuccin").setup({
  flavour = "mocha",            -- テーマの種類: latte / frappe / macchiato / mocha
  background = {                -- background オプション連動時に使う flavour
    light = "latte",           -- 'background=light' のときは latte
    dark = "mocha",            -- 'background=dark'  のときは mocha
  },
  transparent_background = false, -- 背景を透過させない（true で透過）
  term_colors = true,          -- 内蔵ターミナルの 16 色もテーマに合わせる
  integrations = {             -- 連携プラグインのハイライトを有効化する
    treesitter = true,         -- nvim-treesitter
    native_lsp = { enabled = true }, -- 標準 LSP
    render_markdown = true,    -- render-markdown.nvim（見出し/コードブロック等の配色）
  },
})

vim.cmd.colorscheme("catppuccin") -- カラースキームを Catppuccin に適用する
