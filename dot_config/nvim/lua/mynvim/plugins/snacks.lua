return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    explorer = { enabled = true },
    lazygit = { enabled = true },
  },
  keys = {
    { "<leader>fe", function() require("snacks").explorer.open() end, desc = "ファイルツリーをトグル" },
    { "<leader>gg", function() require("snacks").lazygit.open() end, desc = "Lazygitを開く" },
    { "<leader>gl", function() require("snacks").lazygit.log() end, desc = "Lazygitログを開く" },
    { "<leader>gf", function() require("snacks").lazygit.log_file() end, desc = "現在のファイルのGitログを開く" }
  }
}
