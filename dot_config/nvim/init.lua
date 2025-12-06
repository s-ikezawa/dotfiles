require('config.options')
if not vim.g.vscode then
  require('config.lsp')
end

--=============================================================================
-- Plugins
--=============================================================================
if not vim.g.vscode then
-- Colorscheme
require('plugins.catppuccin')
-- LSP
require('plugins.nvim-lspconfig')
end

-- Treesitter
require('plugins.nvim-treesitter')
