return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
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
  opts = {
    explorer = { enabled = true }
  }
}
