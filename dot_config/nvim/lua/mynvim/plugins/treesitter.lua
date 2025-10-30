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
      "json", "jsonc", "json5", "php", "php_only", "phpdoc", "xml", "yaml",
      "latex", "html"
    }
    require("nvim-treesitter").install(filetypes)

    -- Highlighting
    vim.api.nvim_create_autocmd("FileType", {
      pattern = filetypes,
      callback = function() vim.treesitter.start() end,
    })

    -- Folds
    -- Treesitterを利用した折り畳み
    vim.opt.foldmethod = "expr"
    vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    vim.opt.foldenable = true -- 折りたたみを有効化
    vim.opt.foldlevel = 99 -- ファイルを開いた時は全て展開された状態
    vim.opt.foldlevelstart = 99 -- ファイルを開いた時は全て展開された状態
    vim.opt.foldcolumn = "1" -- 折りたたみ列を表示

    -- Indentation
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end
}
