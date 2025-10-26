return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  branch = "main",
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter").setup({
      install_dir = vim.fn.stdpath("data") .. "/site"
    })

    local filetypes = {
      "c", "markdown", "markdown-inline", "query", "lua", "vim", "vimdoc",
      "json", "jsonc", "json5", "php", "php_only", "phpdoc", "xml", "yaml"
    }
    require("nvim-treesitter").install(filetypes)

    -- Highlighting
    vim.api.nvim_create_autocmd("FileType", {
      pattern = filetypes,
      callback = function() vim.treesitter.start() end,
    })

    -- Folds
    vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"

    -- Indentation
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end
}
