vim.pack.add({
  {
    src = 'https://github.com/folke/sidekick.nvim',
    version = 'main',
  }
})

local sidekick = require('sidekick')
sidekick.setup({
  cli = {
    mux = {
      backend = 'tmux',
      enabled = false,
    }
  },
  nes = {
    enabled = false,
  }
})

local cli = require('sidekick.cli')
vim.keymap.set(
  'n',
  '<leader>ac',
  function()
    cli.toggle({ name = 'claude', focus = true })
  end,
  { desc = 'Sidekick Toggle CLI' }
)

vim.keymap.set(
  'n',
  '<leader>at',
  function()
    cli.send({ msg = '{this}' })
  end,
  { desc = 'Sidekick Send This' }
)

vim.keymap.set(
  'n',
  '<leader>af',
  function()
    cli.send({ msg = '{file}' })
  end,
  { desc = 'Sidekick Send File' }
)

vim.keymap.set(
  'x',
  '<leader>av',
  function()
    cli.send({ msg = '{selection}' })
  end,
  { desc = 'Sidekick Send Visual Selection' }
)

vim.keymap.set(
  { 'n', 'x' },
  '<leader>ap',
  function()
    cli.prompt()
  end,
  { desc = 'Sidekick Select Prompt' }
)
