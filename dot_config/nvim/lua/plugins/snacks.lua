return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  keys = {
    {
      '<leader>fe',
      function() Snacks.explorer.open() end,
      mode = { 'n' },
      desc = 'ファイルエクスプローラのトグル'
    }
  },
  opts = {
    explorer = { enabled = true }
  }
}
