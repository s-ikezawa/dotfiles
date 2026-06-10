-- ~/.config/nvim/lua/plugins/catppuccin.lua
-- カラースキーム (Colorscheme)

require("catppuccin").setup({
  flavour = "mocha", -- mocha フレーバーを使用する
})
vim.cmd.colorscheme("catppuccin-mocha") -- catppuccin mocha を適用する
