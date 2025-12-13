vim.pack.add({
  {
    src = 'https://github.com/folke/snacks.nvim',
    version = 'main',
  }
})

local Snacks = require('snacks')
Snacks.setup({
  explorer = { enabled = true }
})

vim.keymap.set('n', '<leader>fb', function() Snacks.picker.buffers() end)
vim.keymap.set('n', '<leader>fe', function() Snacks.explorer() end)

-- Terminal
vim.keymap.set('n', '<leader>tb', function()
  Snacks.terminal.open(
    nil,
    {
      win = {
        style = 'terminal',
        position = 'bottom',
        height = 0.2,
        width = 0
      }
    }
) end)
