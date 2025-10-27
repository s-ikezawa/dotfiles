return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    explorer = { enabled = true },
  },
  keys = {
    { "<leader>fe", function() require("snacks").explorer.open() end, desc = "ファイルツリーをトグル" }
  }
}
