-- Core libraries
vim.pack.add({
  "https://github.com/nvim-lua/plenary.nvim",
})

-- Colorscheme & icons
require("plugins.catppuccin")
vim.cmd.colorscheme("catppuccin")
require("plugins.mini-icons")

-- Treesitter
require("plugins.nvim-treesitter")
require("plugins.nvim-treesitter-textobjects")

-- Editor
require("plugins.which-key")
require("plugins.snacks")
require("plugins.blink-cmp")

-- LSP
require("plugins.nvim-lspconfig")

-- AI
require("plugins.sidekick")

-- Coding
require("plugins.conform")

-- Go
require("plugins.nvim-lint")

-- Git
require("plugins.gitsigns")
require("plugins.diffview")
