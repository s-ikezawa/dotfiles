return {
  "folke/sidekick.nvim",
  opts = {
    cli = {
      tools = {
        claude = {
          cmd = { "claude" }
        },
      },
      win = {
        layout = "right",
        split = {
          width = 80,
          height = 0,
        },
        keys = {
          prompt = false, -- <C-p>をCLIに渡す(デフォルトのプロンプト選択機能を無効化)
        },
      },
    },
    nes = {
      enabled = false
    },
  },
  keys = {
    {
      "<leader>ac",
      function()
        require("sidekick.cli").toggle("claude")
      end,
      desc = "ClaudeCodeをトグル",
      mode = { "n", "t", "i", "x" },
    },
  },
}
