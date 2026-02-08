vim.pack.add({
  "https://github.com/nvim-mini/mini.icons",
})

local MiniIcons = require("mini.icons")
MiniIcons.setup({
  -- Icon style: 'glyph' or 'ascii'
  style = "glyph",

  -- Customize per category. See `:h MiniIcons.config` for details.
  default = {},
  directory = {},
  extension = {},
  file = {},
  filetype = {},
  lsp = {},
  os = {},

  -- Control which extensions will be considered during "file" resolution
  use_file_extension = function(ext, file)
    return true
  end,
})

MiniIcons.mock_nvim_web_devicons()
