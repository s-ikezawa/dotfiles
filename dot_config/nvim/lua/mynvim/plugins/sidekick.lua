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
      watch = true, -- AIツールによるファイル変更を自動リロード
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
    {
      "<leader>af",
      function()
        local cli = require("sidekick.cli")
        cli.send({ msg = "{file}", name = "claude" })
      end,
      desc = "現在のファイルをClaude Codeに送信",
      mode = "n",
    },
    {
      "<leader>as",
      function()
        local cli = require("sidekick.cli")
        cli.send({ msg = "{selection}", name = "claude" })
      end,
      desc = "選択範囲をClaude Codeに送信",
      mode = "x",
    },
    {
      "<leader>ad",
      function()
        local cli = require("sidekick.cli")
        cli.send({ msg = "{diagnostics}", name = "claude" })
      end,
      desc = "診断情報をClaude Codeに送信",
      mode = "n",
    },
  },
}
