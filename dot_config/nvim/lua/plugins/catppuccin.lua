return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  cond = not vim.g.vscode,
  init = function()
    vim.cmd.colorscheme "catppuccin"
  end,
  opts = {
    flavour = "mocha"
  },
}
