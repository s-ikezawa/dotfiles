-- Core libraries
vim.pack.add({
  "https://github.com/nvim-lua/plenary.nvim",
})

-- Colorscheme
require("plugins.catppuccin")
vim.cmd.colorscheme("catppuccin")
