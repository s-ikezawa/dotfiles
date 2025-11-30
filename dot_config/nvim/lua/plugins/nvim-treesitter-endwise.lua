return {
  'AbaoFromCUG/nvim-treesitter-endwise', -- RRethy/nvim-treesitter-endwiseがmainブランチ対応してないので
  dependencies = {
    { 'nvim-treesitter/nvim-treesitter', branch = 'main' },
  },
  branch = 'main',
  cond = not vim.g.vscode,
  config = function()
    require('nvim-treesitter-endwise').init()
  end
}
