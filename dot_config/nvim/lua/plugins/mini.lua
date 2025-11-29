return {
  'nvim-mini/mini.nvim',
  branch = 'main',
  config = function()
    require('mini.ai').setup({})
  end,
}
