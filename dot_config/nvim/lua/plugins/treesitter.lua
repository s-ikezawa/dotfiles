vim.pack.add({
  {
    src = 'https://github.com/nvim-treesitter/nvim-treesitter',
    version = 'main',
  }
})

require('nvim-treesitter').setup({
  install_dir = vim.fn.stdpath('data') .. '/site'
})
local ensure_installed = {
  -- a
  -- b
  -- c
  'c',
  -- d
  -- e
  -- f
  -- g
  -- h
  -- i
  -- j
  'javascript', 'jsdoc', 'json', 'jsonc',
  -- k
  -- l
  'lua', 'luadoc',
  -- m
  'terraform', 'markdown', 'markdown_inline',
  -- n
  -- o
  -- p
  -- q
  -- r
  -- s
  'scss', 'sql',
  -- t
  'toml', 'typescript', 'tsx',
  -- u
  -- v
  'vim', 'vimdoc',
  -- w
  -- x
  -- y
  'yaml',
  -- z
}

require('nvim-treesitter').install(ensure_installed)

-- Highlighting
vim.api.nvim_create_autocmd('FileType', {
  pattern = ensure_installed,
  callback = function() vim.treesitter.start() end,
})

-- Folds
vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.opt.foldmethod = 'expr'
vim.opt.foldlevel = 99
vim.opt.foldtext = ''
vim.opt.fillchars = { fold = ' ' }

-- function _G.custom_foldtext()
--   local line = vim.fn.getline(vim.v.foldstart)
--   local line_count = vim.v.foldend - vim.v.fodstart + 1
--   return line .. ' ... ' .. line_count .. ' lines'
-- end
-- vim.wo.foldtext = 'v:lua.custom_foldtext()'
-- vim.opt.fillchars:append { fold = ' ' }

-- Indentation
vim.bo.indentexpr = "v:lua.require('nvim-treesitter').indentexpr()"

-- Hook
vim.api.nvim_create_autocmd('PackChanged', {
  desc = 'Handle nvim-treesitter updates',
  group = vim.api.nvim_create_augroup('nvim-treesitter-pack-changed-update', { clear = true }),
  callback = function(event)
    if event.data.kind == 'update' then
      vim.notify('nvim-treesitter updated, running TSUpdate...', vim.log.levels.INFO)
      local ok = pcall(vim.cmd, 'TSUpdate')
      if ok then
        vim.notify('TSUpdate completed successfully.', vim.log.levels.INFO)
      else
        vim.notify('TSUpdate command not available yet, skipping', vim.log.levels.WARN)
      end
    end
  end,
})

