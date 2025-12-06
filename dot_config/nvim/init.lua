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
  require('plugins.mini-pairs')
  require('plugins.mini-icons')
  require('plugins.lspconfig')
  require('plugins.blink-cmp')
end

require('plugins.treesitter')

