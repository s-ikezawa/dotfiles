return {
  'nvim-treesitter/nvim-treesitter-textobjects',
  branch = 'main',
  keys = {
    {
      'af',
      function() require('nvim-treesitter-textobjects.select').select_textobject('@function.outer', 'textobjects') end,
      mode = { 'x', 'o' },
      desc = '関数の外側を選択'
    },
    {
      'if',
      function() require('nvim-treesitter-textobjects.select').select_textobject('@function.inner', 'textobjects') end,
      mode = { 'x', 'o' },
      desc = '関数の内側を選択'
    },
    {
      'ac',
      function() require('nvim-treesitter-textobjects.select').select_textobject('@class.outer', 'textobjects') end,
      mode = { 'x', 'o' },
      desc = 'クラスの外側を選択'
    },
    {
      'ic',
      function() require('nvim-treesitter-textobjects.select').select_textobject('@class.inner', 'textobjects') end,
      mode = { 'x', 'o' },
      desc = 'クラスの内側を選択'
    },
  },
  opts = {
    select = {
      -- Automatically jump forward to textobj, similar to targets.vim
      lookahead = true,
      -- You can choose the select mode (default is charwise 'v')
      --
      -- Can also be a function which gets passed a table with the keys
      -- * query_string: eg '@function.inner'
      -- * method: eg 'v' or 'o'
      -- and should return the mode ('v', 'V', or '<c-v>') or a table
      -- mapping query_strings to modes.
      selection_modes = {
        ['@parameter.outer'] = 'v', -- charwise
        ['@function.outer'] = 'V', -- linewise
        ['@class.outer'] = '<c-v>', -- blockwise
      },
      -- If you set this to `true` (default is `false`) then any textobject is
      -- extended to include preceding or succeeding whitespace. Succeeding
      -- whitespace has priority in order to act similarly to eg the built-in
      -- `ap`.
      --
      -- Can also be a function which gets passed a table with the keys
      -- * query_string: eg '@function.inner'
      -- * selection_mode: eg 'v'
      -- and should return true of false
      include_surrounding_whitespace = false,
    },
  },
}
