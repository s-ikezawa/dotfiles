return {
  "folke/sidekick.nvim",
  opts = {
    nes = {
      enabled = false,
    },
    cli = {
      mux = {
        enabled = true,
        backend = "tmux",
      },
    },
  },
  keys = {
    {
      "<c-.>",
      function() require("sidekick.cli").toggle() end,
      desc = "Sidekickをトグル",
      mode = { "n", "t", "i", "x" },
    },
    {
      "<leader>aa",
      function() require("sidekick.cli").toggle() end,
      desc = "Sidekickをトグル",
    },
    {
      "<leader>ac",
      function() require("sidekick.cli").toggle({ name = "claude", focus = true }) end,
      desc = "SidekickでClaude Codeをトグル",
    },
    {
      "<leader>as",
      function() require("sidekick.cli").select({ filter = { installed = true } }) end,
      desc = "Sidekickで利用するCLIツールを選択する",
    },
    {
      "<leader>ad",
      function() require("sidekick.cli").close() end,
      desc = "SidekickのCLIをデタッチ",
    },
    {
      "<leader>at",
      function() require("sidekick.cli").send({ msg = "{this}" }) end,
      desc = "Send This",
    },
    {
      "<leader>af",
      function() require("sidekick.cli").send({ msg = "{file}"}) end,
      desc = "ファイル名を送信",
    },
    {
      "<leader>av",
      function() require("sidekick.cli").send({ msg = "{selection}" }) end,
      desc = "選択範囲を送信",
    },
    {
      "<leader>ap",
      function() require("sidekick.cli").prompt() end,
      desc = "プロンプトから選択",
    },
  },
}
