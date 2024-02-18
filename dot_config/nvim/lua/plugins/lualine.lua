local config = function()
  require("lualine").setup({
    options = {
      ignore_focus = { "NvimTree" },
    },
  })
end

return {
  "nvim-lualine/lualine.nvim",
  dependencies = {
    { "AndreM222/copilot-lualine" },
  },
  config = config,
}
