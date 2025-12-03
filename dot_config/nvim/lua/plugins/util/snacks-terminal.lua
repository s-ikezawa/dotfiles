return {
  'folke/snacks.nvim',
  keys = {
    {
      '<leader>tb',
      function()
        Snacks.terminal.toggle(nil, { win = { position = 'bottom', width = 0, height = 0.3 } })
      end,
      mode = { 'n' },
      desc = 'Snacks Terminal を下にトグル'
    },
    {
      '<leader>tr',
      function()
        Snacks.terminal.toggle(nil, { win = { position = 'right', width = 0.3, height = 0 } })
      end,
      mode = { 'n' },
      desc = 'Snacks Terminal を下にトグル'
    }
  },
}
