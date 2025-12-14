--=============================================================================
-- Configurations
--=============================================================================
require('config.options')
require('config.keymaps')
if not vim.g.vscode then
  require('config.lsp')
end

--=============================================================================
-- Plugins
--=============================================================================
if not vim.g.vscode then
  require('plugins.catppuccin')
  require('plugins.mini')
  require('plugins.lspconfig')
  require('plugins.blink-cmp')
  require('plugins.snacks')
  require('plugins.sidekick')
end

require('plugins.treesitter')

