-- =============================================================================
-- catppuccin/nvim (mocha)
-- =============================================================================
-- パステル調のカラースキーム。4 つのフレーバー (latte/frappe/macchiato/mocha) を
-- 内蔵し、ここでは最も濃いダークテーマである "mocha" を採用する。
--
-- 設定の主なポイント:
--   - flavour: 適用するフレーバー
--   - transparent_background: ターミナル側の背景を透過させたい場合に true
--   - integrations: 他プラグインとの色合わせ (treesitter は標準で有効)
--
-- 詳細は :help catppuccin もしくは https://github.com/catppuccin/nvim
-- =============================================================================

require("catppuccin").setup({
  flavour = "mocha",

  -- 背景透過は無効 (ターミナル側で透過する場合のみ true にする)
  transparent_background = false,

  -- ターミナル (:terminal) の 16 色も catppuccin パレットに合わせる
  term_colors = true,

  -- 他プラグインとの色合わせ。利用しているものだけ true にして余計なロードを避ける
  integrations = {
    treesitter = true,
    native_lsp = {
      enabled = true,
      virtual_text = {
        errors = { "italic" },
        hints = { "italic" },
        warnings = { "italic" },
        information = { "italic" },
      },
      underlines = {
        errors = { "underline" },
        hints = { "underline" },
        warnings = { "underline" },
        information = { "underline" },
      },
    },
  },
})

-- カラースキーム適用
vim.cmd.colorscheme("catppuccin-mocha")
