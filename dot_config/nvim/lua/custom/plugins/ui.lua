return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VimEnter",
    opts = function()
      local options = {
        options = {
          icons_enabled = true,
          theme = "auto",
          globalstatus = vim.o.laststatus == 3,
          disabled_filetypes = { statusline = { "dashboard", "alpha", "ninistarter", "snacks_dashboard" } },
        },
      }
      return options
    end,
  },
}
