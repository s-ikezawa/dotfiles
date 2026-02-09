vim.pack.add({
  "https://github.com/nvim-treesitter/nvim-treesitter",
  "https://github.com/nvim-mini/mini.icons",
  "https://github.com/MeanderingProgrammer/render-markdown.nvim",
})

require("render-markdown").setup({
  -- 見出し
  heading = {
    sign = false,
    width = "block",
    min_width = 40,
    border = true,
    border_virtual = true,
  },
  -- コードブロック
  code = {
    sign = false,
    width = "block",
    left_pad = 2,
    right_pad = 2,
    min_width = 50,
    border = "thin",
  },
  -- テーブル（rounded borderで統一）
  pipe_table = {
    preset = "round",
  },
  -- インデントガイド
  indent = {
    enabled = true,
  },
  -- blink.cmpとの連携
  completions = {
    blink = { enabled = true },
  },
})
