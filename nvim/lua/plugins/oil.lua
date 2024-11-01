return {
  "stevearc/oil.nvim",
  opts = {
    float = {
      max_width = 100,
      max_height = 100,
    }
  },
  dependencies = { { "echasnovski/mini.icons", opts = {} } },
  keys = {
    { "<leader>eo", "<CMD>Oil --float<CR>", { desc = "Open current buffer directory" } },
    { "<leader>eO", "<CMD>Oil --float .<CR>", { desc = "Oil ." } }
  }
}
