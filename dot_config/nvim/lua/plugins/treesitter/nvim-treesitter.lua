return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  lazy = false,
  build = ':TSUpdate',
  init = function()
    local types = {
      'c',
      -- lua
      'lua', 'luadoc',
      -- markdown
      'markdown', 'markdown_inline',
      -- vim
      'vim', 'vimdoc',
    }

    -- Highlighting
    vim.api.nvim_create_autocmd('FileType', {
      pattern = types,
      callback = function()
        vim.treesitter.start()
      end,
    })

    -- Folds
    vim.opt.foldmethod = 'expr'
    vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'

    -- Indentation
    vim.bo.indentexpr = 'v:lua.require("nvim-treesitter").indentexpr()'
  end,
  opts = {
    install_dir = vim.fn.stdpath('data') .. '/site'
  },
}
