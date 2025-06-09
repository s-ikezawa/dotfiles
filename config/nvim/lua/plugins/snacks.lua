return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  config = function()
    local Snacks = require("snacks")
    
    
    Snacks.setup({
      picker = {
        sources = {
          explorer = {
            finder = "explorer",
            tree = true,
            git_status = true,
            git_untracked = true,
            git_status_open = false,
            diagnostics = true,
            diagnostics_open = false,
            watch = true,
            follow_file = true,
            focus = "list",
            auto_close = false,
            layout = { preset = "sidebar", preview = false },
            formatters = {
              file = { filename_only = true },
              severity = { pos = "right" },
            },
            exclude = { ".DS_Store" },
          },
        },
      },
      -- その他のsnacks.nvim機能も利用可能
      bigfile = { enabled = true },
      quickfile = { enabled = true },
      statuscolumn = { enabled = false },
      words = { enabled = true },
    })

    -- keymaps
    local keymap = vim.keymap
    keymap.set("n", "<leader>ee", function() Snacks.explorer() end, { desc = "ファイルエクスプローラーをトグル" })
    keymap.set("n", "<leader>ef", function() Snacks.explorer({ reveal = true }) end, { desc = "現在のファイルをエクスプローラーで表示" })
  end,
}