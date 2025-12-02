return {
  'nvim-mini/mini.icons',
  version = '*',
  opts = {
    style = 'glyph',
    file = {
      [".keep"] = { glyph = "󰊢", hl = "MiniIconsGrey" },
      ["devcontainer.json"] = { glyph = "", hl = "MiniIconsAzure" },
    },
    filetype = {
      dotenv = { glyph = "", hl = "MiniIconsYellow" },
    },
  },
  init = function()
    require('mini.icons').mock_nvim_web_devicons()
  end
}
