return {
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  branch = 'main',
  build = ':TSUpdate',
  config = function()
    require('nvim-treesitter').setup({
      install_dir = vim.fn.stdpath('data') .. '/site'
    })

    local types = {
      -- default
      'c', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc',
    }

    require('nvim-treesitter').install(types)

    -- Highlighting
    vim.api.nvim_create_autocmd('FileType', {
      pattern = types,
      callback = function() vim.treesitter.start() end,
    })

    -- Folds
    vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'

    -- Indentation
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end
}
