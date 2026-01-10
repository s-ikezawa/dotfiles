return {
  "folke/sidekick.nvim",
  event = "VimEnter",
  cmd = "Sidekick",
  opts = {
    cli = {
      -- AIがバックグラウンドでファイルを書き換えた際、自動でバッファをリロードする
      auto_reload = true,
    },
    nes = {
      enabled = false,
    },
    ui = {
      position = "right", -- right, bottom, top, left
      size = 0.4,
      diff_style = "inline", -- inline, block
      treesitter_diff = true, -- Treesitterを利用した詳細なDiffを表示
    },
  },
  keys = {
    {
      "<leader>ac",
      function() require("sidekick.cli").toggle({ name = "claude", focus = true }) end,
      desc = "Claude Codeを起動/終了"
    },
    {
      "<leader>af",
      function() require("sidekick.cli").send({ msg = "{file}" }) end,
      desc = "ファイル名を送信",
    },
    {
      "<leader>at",
      function() require("sidekick.cli").send({ msg = "{this}" }) end,
      mode = { "n", "x" },
      desc = "",
    },
    {
      "<leader>av",
      function() require("sidekick.cli").send({ msg = "```\n{selection}\n```" }) end,
      mode = { "x" },
      desc = "選択された部分を送信",
    },
  },
}
