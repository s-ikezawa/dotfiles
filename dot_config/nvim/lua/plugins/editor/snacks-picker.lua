return {
  'folke/snacks.nvim',
  opts = {
    picker = {
      enabled = true,
    }
  },
  keys = {
    -- Find
    {
      '<leader>ff',
      function() Snacks.picker.files() end,
      mode = { 'n' },
      desc = 'Snacks Open Files'
    },
    {
      '<leader>fb',
      function() Snacks.picker.buffers() end,
      mode = { 'n' },
      desc = 'Snacks Open Buffers'
    },
    -- search/grep
    {
      '<leader>sg',
      function() Snacks.picker.grep() end,
      mode = { 'n' },
      desc = 'Snacks Grep Root Dir'
    },
    -- LSP
    {
      'gd',
      function() Snacks.picker.lsp_definitions() end,
      mode = { 'n' },
      desc = 'Goto Definition'
    },
    {
      'gD',
      function() Snacks.picker.lsp_declarations() end,
      mode = { 'n' },
      desc = 'Goto Declaration',
    },
    {
      'gr',
      function() Snacks.picker.lsp_references() end,
      mode = { 'n' },
      nowait = true,
      desc = 'References'
    },
    {
      'gI',
      function() Snacks.picker.lsp_implementations() end,
      mode = { 'n' },
      desc = 'Goto Implementation'
    },
    {
      'gy',
      function() Snacks.picker.lsp_type_definitions() end,
      mode = { 'n' },
      desc = 'Goto Type Definition',
    },
    {
      'gai',
      function() Snacks.picker.lsp_incoming_calls() end,
      mode = { 'n' },
      desc = 'Calls Incoming',
    },
    {
      'gao',
      function() Snacks.picker.lsp_outgoing_calls() end,
      mode = { 'n' },
      desc = 'Calls Outgoing'
    },
    {
      '<leader>ss',
      function() Snacks.picker.lsp_symbols() end,
      mode = { 'n' },
      desc = 'LSP Symbols'
    },
  }
}
