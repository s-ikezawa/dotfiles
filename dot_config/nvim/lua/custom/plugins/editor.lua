return {
  {
    "folke/which-key.nvim",
    event = "VimEnter",
    opts = {
      -- classic window下部一杯に表示される
      -- modern window下部両端のスペースありで表示される
      -- helix window右下に表示される
      preset = "helix",
      spec = {
        {
          mode = { "n", "v" },
          { "<leader>f", group = "file/find" },
          { "<leader>g", group = "git" },
          { "<leader>s", group = "search" },
        },
      },
    },
  },
}
