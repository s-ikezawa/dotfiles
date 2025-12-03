return {
  'nvim-treesitter/nvim-treesitter-textobjects',
  branch = 'main',
  dependencies = {
    { 'nvim-treesitter/nvim-treesitter' },
  },
  opts = {
    select = {
      lookahead = true,
      selection_modes = {
        ['@parameter.outer'] = 'v', -- charwise
        ['@function.outer'] = 'V', -- linewise
        ['@class.outer'] = '<C-v>', -- blockwise
      },
      include_surrounding_whitespace = false,
    },
  }
}
