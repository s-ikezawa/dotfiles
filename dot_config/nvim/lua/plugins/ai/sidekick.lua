return {
  'folke/sidekick.nvim',
  keys = {
    {
      '<leader>ac',
      function()
        require('sidekick.cli').toggle({ name = 'claude', focus = true })
      end,
      desc = 'Sidekick Open ClaudeCode'
    },
    {
      '<leader>at',
      function()
        require('sidekick.cli').send({ msg = '{this}' })
      end,
      mode = { 'x', 'n' },
      desc = 'Sidekick Send This'
    },
    {
      '<leader>af',
      function()
        require('sidekick.cli').send({ msg = '{file}' })
      end,
      mode = { 'n' },
      desc = 'Sidekick Send File'
    },
    {
      '<leader>av',
      function()
        require('sidekick.cli').send({ msg = '{selection}' })
      end,
      mode = { 'x' },
      desc = 'Sidekick Send Selection'
    },
    {
      '<leader>ap',
      function()
        require('sidekick.cli').prompt()
      end,
      mode = { 'n', 'x' },
      desc = 'Sidekick Select Prompt'
    }
  },
  opts = {
    cli = {
      win = {
        keys = {
          buffers = false,
          files = false,
          prompt = false,
          nav_left = { "<c-w>h", 'nav_left', expr = true },
          nav_down = { "<c-w>j", 'nav_down', expr = true },
          nav_up = { "<c-w>k", 'nav_up', expr = true },
          nav_right = { "<c-w>l", 'nav_right', expr = true },
        }
      },
      mux = { backend = 'tmux', enabled = true }
    }
  }
}
