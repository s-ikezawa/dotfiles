return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    event = "VimEnter",
    config = function()
      require("catppuccin").setup({
        integrations = {
          treesitter = true,
          which_key = true,
          blink_cmp = true,
          snacks = true,
          mini = true,
          native_lsp = {
            enabled = true,
            underlines = {
              errors = { "undercurl" },
              hints = { "undercurl" },
              warnings = { "undercurl" },
              information = { "undercurl" },
            },
          },
        },
      })
      vim.cmd.colorscheme "catppuccin"
    end
  },
}
