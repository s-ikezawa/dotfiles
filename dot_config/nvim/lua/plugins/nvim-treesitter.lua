vim.pack.add({
  {
    src = "https://github.com/nvim-treesitter/nvim-treesitter",
    version = "main",
  },
})

require("nvim-treesitter").setup({
  -- Directory to install parsers and queries to (prepended to `runtimepath` to have priority)
  install_dir = vim.fn.stdpath("data") .. "/site",
})

local filetypes = {
  -- a
  -- b
  -- c
  "c",
  -- d
  "diff",
  -- e
  -- f
  -- g
  "go",
  "gomod",
  "gosum",
  "gotmpl",
  "gowork",
  -- h
  -- i
  -- j
  -- k
  -- l
  "lua",
  "luadoc",
  -- m
  "markdown",
  "markdown_inline",
  -- n
  -- o
  -- p
  -- q
  -- r
  "regex",
  -- s
  -- t
  -- u
  -- v
  "vim",
  "vimdoc",
  -- w
  -- x
  -- y
  -- z
}

require("nvim-treesitter").install(filetypes)

-- Highlighting
vim.api.nvim_create_autocmd("FileType", {
  pattern = filetypes,
  callback = function()
    vim.treesitter.start()
  end,
})

-- Folds
vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.wo[0][0].foldmethod = "expr"

-- Indentation
vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
