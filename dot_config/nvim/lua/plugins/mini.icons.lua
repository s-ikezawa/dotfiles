return {
  "nvim-mini/mini.icons",
  version = false, -- Branch Main = false, Stable = "*"
  ops = {
    style = "glyph",
    default = {},
    directory = {},
    extension = {},
    file = {},
    filetype = {},
    lsp = {},
    os = {},
  },
  config = function(_, opts)
    require("mini.icons").setup(opts)
    MiniIcons.mock_nvim_web_devicons()
  end,
}
