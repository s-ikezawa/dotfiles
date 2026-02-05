return {
  "folke/sidekick.nvim",
  opts = {
    nes = {
      enabled = false,
    },
    cli = {
      mux = {
        enabled = false,
        -- backend = "tmux",
      },
      win = {
        keys = {
          prompt = false, -- <c-p> を無効化
        },
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
      "<leader>ac",
      function() require("sidekick.cli").send({ msg = "{class}" }) end,
      desc = "カーソルのあるクラスを選択して送信",
    },
    {
      "<leader>af",
      function() require("sidekick.cli").send({ msg = "{function}" }) end,
      desc = "カーソルのある関数を選択して送信",
    },
    {
      "<leader>ad",
      function() require("sidekick.cli").send({ msg = "{diagnostics}" }) end,
      desc = "現在の開いているファイルの診断結果を送信",
    },
    {
      "<leader>at",
      function() require("sidekick.cli").send({ msg = "{this}" }) end,
      desc = "カーソル位置周辺のコンテキストを送信",
    },
    {
      "<leader>al",
      function() require("sidekick.cli").send({ msg = "{line}" }) end,
      desc = "カーソルのある行を送信",
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
