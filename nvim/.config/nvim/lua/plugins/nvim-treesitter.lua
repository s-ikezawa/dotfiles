vim.pack.add({
  "https://github.com/nvim-treesitter/nvim-treesitter",
})

local TS = require("nvim-treesitter")
local ensure_installed = {
  "lua",
  "luadoc",
}

TS.install(ensure_installed)

-- Highlighting
vim.api.nvim_create_autocmd("FileType", {
  pattern = ensure_installed,
  callback = function() vim.treesitter.start() end,
})

-- Folds
vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.wo[0][0].foldmethod = "expr"

-- Indentation
vim.bo.indentexpr = "v:lua.require('nvim-treesitter').indentexpr()"

