vim.pack.add({
  "https://github.com/folke/which-key.nvim",
})

require("which-key").setup({
  delay = 300,
  sort = { "alphanum", "local", "order", "group", "mod" },
  icons = {
    mappings = true,
    keys = {},
  },
  spec = {
    { "<Leader>a", group = "AI / 引数入れ替え" },
    { "<Leader>b", group = "バッファ" },
    { "<Leader>d", group = "削除 / 診断" },
    { "<Leader>f", group = "ファイル" },
    { "<Leader>q", group = "Quickfix" },
    { "<Leader>t", group = "タブ" },
    { "<Leader>w", group = "ウィンドウ" },
  },
})
