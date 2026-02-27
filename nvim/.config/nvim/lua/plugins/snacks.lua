vim.pack.add({
  "https://github.com/folke/snacks.nvim",
  "https://github.com/nvim-tree/nvim-web-devicons",
})

local Snacks = require("snacks")
Snacks.setup({
  explorer = {
    enabled = true,
  },
  picker = {
    actions = {
      sidekick_send = function(...)
        return require("sidekick.cli.picker.snacks").send(...)
      end,
    },
    win = {
      input = {
        keys = {
          ["<a-a>"] = {
            "sidekick_send",
            mode = { "n", "i" },
          },
        },
      },
    },
    sources = {
      explorer = {
        hidden = true,
      },
    },
  },
  statuscolumn = {
    enabled = true,
    left = { "mark", "sign" },
    right = { "fold", "git" },
    folds = {
      open = false,
      git_hl = false,
    },
    git = {
      patterns = { "GitSign", "MiniDiffSign" },
    },
  },
})

vim.keymap.set("n", "<leader>fe", function() Snacks.explorer() end, { desc = "ファイルエクスプローラー" })
