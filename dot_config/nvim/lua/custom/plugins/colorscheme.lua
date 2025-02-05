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
            virtual_text = {
              errors = { "italic" },
              hints = { "italic" },
              warnings = { "italic" },
              information = { "italic" },
              ok = { "italic" },
            },
            underlines = {
              errors = { "undercurl" },
              hints = { "undercurl" },
              warnings = { "undercurl" },
              information = { "undercurl" },
              ok = { "undercurl" },
            },
            inlay_hints = {
              background = true,
            },
          },
        },
      })
      vim.cmd.colorscheme "catppuccin"
    end
  },
}
