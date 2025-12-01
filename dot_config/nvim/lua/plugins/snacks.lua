return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  keys = {
    -- ファイルピッカー(<leader>f)
    { '<leader>fe', function() Snacks.explorer.open() end, mode = { 'n' }, desc = 'ファイルエクスプローラのトグル' },
    { '<leader>ff', function() Snacks.picker.files() end, mode = { 'n' }, desc = 'ファイルピッカー' },
    -- Git
    {
      '<leader>gg',
      function()
        Snacks.lazygit.open({ win = { position = 'float', width = 0.95, height = 0.95, border = 'none' } })
      end,
      mode = { 'n' },
      desc = 'LazyGitをフローティングウィンドウで開く'
    },
    -- ターミナル
    { 
      '<leader>tt',
      function()
        Snacks.terminal.toggle(nil, { win = { position = 'bottom', width = 0, height = 0.2 } } )
      end,
      mode = { 'n' },
      desc = 'ターミナルの開閉をトグル'
    },
  },
  ---@type snacks.Config
  opts = {
    bigfile = { enabled = false },
    dashboard = { enabled = false },
    explorer = {
      enabled = true,
      replace_netrw = true,
      trash = true
    },
    image = { enabled = false },
    input = { enabled = true },
    notifier = { enabled = false },
    picker = { enabled = true },
    quickfile = { enabled = false },
    scope = { enabled = false },
    scroll = { enabled = true },
    statuscolumn = { enabled = false },
    words = { enabled = false },
  }
}
