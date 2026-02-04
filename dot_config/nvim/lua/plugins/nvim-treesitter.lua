return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    local treesitter = require("nvim-treesitter")
    treesitter.setup({
      install_dir = vim.fn.stdpath("data") .. "/site"
    })

    local filetypes = {
      -- a
      -- b
      "bash",
      -- c
      -- d
      -- e
      -- f
      -- g
      "go","gomod","gosum","gotmpl","gowork",
      -- h
      -- i
      -- j
      "json", "json5", "jsonnet",
      -- k
      -- l
      "lua", "luadoc", "luap", "luau",
      -- m
      -- n
      -- o
      -- p
      -- q
      -- r
      -- s
      -- t
      "toml",
      -- u
      -- v
      -- w
      -- x
      -- y
      "yaml",
      -- z
      "zsh",
    }
    treesitter.install(filetypes)

    -- Highlighting
    vim.api.nvim_create_autocmd("FileType", {
      pattern = filetypes,
      callback = function() vim.treesitter.start() end,
    })

    -- Folds
    vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
    vim.wo[0][0].foldmethod = "expr"

    -- Indentation
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
}
