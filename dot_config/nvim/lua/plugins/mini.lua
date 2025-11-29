return {
  'nvim-mini/mini.nvim',
  branch = 'main',
  config = function()
    require('mini.ai').setup({})
    require('mini.pairs').setup()
    require('mini.surround').setup()
  end,
}
