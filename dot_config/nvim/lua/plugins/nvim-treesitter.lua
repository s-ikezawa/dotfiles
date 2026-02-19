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
  "bash",
  -- c
  "c",
  "css",
  "csv",
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
  "html",
  -- i
  -- j
  "java",
  "javadoc",
  "javascript",
  "jq",
  "jsdoc",
  "json",
  "json5",
  "jsonnet",
  "jsx",
  -- k
  "kotlin",
  -- l
  "latex",
  "lua",
  "luadoc",
  "luap",
  "luau",
  -- m
  "markdown",
  "markdown_inline",
  "mermaid",
  -- n
  -- o
  -- p
  -- q
  -- r
  "regex",
  -- s
  "scss",
  "sql",
  -- t
  "tmux",
  "toml",
  "tsv",
  "tsx",
  "typescript",
  "typespec",
  -- u
  -- v
  "vim",
  "vimdoc",
  -- w
  -- x
  -- y
  "yaml",
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
