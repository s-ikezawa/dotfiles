vim.pack.add({
  "https://github.com/folke/snacks.nvim",
  "https://github.com/nvim-tree/nvim-web-devicons",
})

local Snacks = require("snacks")
Snacks.setup({
  explorer = {
    enabled = true,
  },
  picker = {
    sources = {
      explorer = {
        hidden = true,
      },
    },
  },
})

vim.keymap.set("n", "<leader>fe", function() Snacks.explorer() end, { desc = "ファイルエクスプローラー" })
