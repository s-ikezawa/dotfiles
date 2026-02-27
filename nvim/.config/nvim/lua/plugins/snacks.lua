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
  statuscolumn = {
    enabled = true,
    left = { "mark", "sign" },
    right = { "fold", "git" },
    folds = {
      open = false,
      git_hl = false,
    },
    git = {
      patterns = { "GitSign", "MiniDiffSign" },
    },
  },
})

vim.keymap.set("n", "<leader>fe", function() Snacks.explorer() end, { desc = "ファイルエクスプローラー" })
