return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  opts = {
    explorer = {
      enabled = true,
    },
    picker = {
      sources = {
        explorer = {
          layout = {
            layout = {
              position = 'left',
              width = 0.15
            }
          }
        },
      },
    },
  },
  keys = {
    {
      '<leader>fe',
      function()
        Snacks.explorer.open()
      end,
      mode = { 'n' },
      desc = 'Snacks Open Explorer'
    }
  },
}
