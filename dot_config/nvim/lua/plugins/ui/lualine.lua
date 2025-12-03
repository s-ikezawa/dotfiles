return {
  'nvim-lualine/lualine.nvim',
  dependencies = {
    { 'nvim-mini/mini.icons' }, -- or nvim-tree/nvim-web-devicons
  },
  opts = {
    options = {
      component_separators = {
        left = '',
        right = ''
      },
      section_separators = {
        left = '',
        right = ''
      },
    },
    sections = {
      lualine_a = { 'mode' },
      lualine_b = { 'branch', 'diff', 'diagnostics' },
      lualine_c = {
        {
          'filename',
          path = 2
        },
      },
      lualine_x = {
        'encoding',
        {
          'fileformat',
          symbols = {
            unix = 'LF', -- default  (e712)
            dos = 'CRLF', -- default '' (e70f)
            mac = 'CR', -- default '' (e711)
          }
        },
        'filetype'
      },
      lualine_y = { 'lsp_status' },
      lualine_z = { 'location' },
    }
  }
}
