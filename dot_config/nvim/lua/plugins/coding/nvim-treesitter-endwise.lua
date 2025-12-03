return {
  'AbaoFromCUG/nvim-treesitter-endwise',
  branch = 'main',
  dependencies = {
    { 'nvim-treesitter/nvim-treesitter', branch = 'main' },
  },
  config = function()
    require('nvim-treesitter-endwise').init()
  end
}
