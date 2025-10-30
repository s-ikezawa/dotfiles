return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    explorer = { enabled = true },
    lazygit = { enabled = true },
    terminal = {
      enabled = true,
      win = {
        position = "bottom", -- デフォルト: "bottom" (コマンドなし) または "float" (コマンドあり)
        height = 0.2,        -- デフォルト: 0.4 (画面の40%), left or right = 0(full screen)
        width = 0,           -- デフォルト: bottom = 0(full screen), left or right = 0.4
      },
    },
    picker = {
      sources = {
        explorer = {
          layout = {
            layout = {
              width = 30,        -- デフォルト: 40
              min_width = 30,    -- デフォルト: 40
              position = "left", -- デフォルト: "left" (または "right")
            },
          },
        },
      },
    },
  },
  keys = {
    { "<leader>fe", function() require("snacks").explorer.open() end, desc = "ファイルツリーをトグル" },
    { "<leader>gg", function() require("snacks").lazygit.open() end, desc = "Lazygitを開く" },
    { "<leader>gl", function() require("snacks").lazygit.log() end, desc = "Lazygitログを開く" },
    { "<leader>gf", function() require("snacks").lazygit.log_file() end, desc = "現在のファイルのGitログを開く" },
    { "<leader>tt", function() require("snacks").terminal.toggle() end, desc = "ターミナルをトグル" },
    { "<leader>tf", function() require("snacks").terminal.open() end, desc = "フローティングターミナルを開く" }
  }
}
