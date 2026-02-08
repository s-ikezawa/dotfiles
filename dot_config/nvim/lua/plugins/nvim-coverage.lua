vim.pack.add({
  "https://github.com/andythigpen/nvim-coverage",
  -- required
  "https://github.com/nvim-lua/plenary.nvim",
})

require("coverage").setup({
  auto_reload = true,
  lang = {
    go = {
      -- go test -coverprofile=coverage.out ./... で生成されるファイル
      coverage_file = "coverage.out",
    },
  },
})

local coverage = require("coverage")

vim.keymap.set("n", "<leader>tcl", function()
  coverage.load(true)
end, { desc = "カバレッジを読み込み・表示" })

vim.keymap.set("n", "<leader>tct", function()
  coverage.toggle()
end, { desc = "カバレッジ表示を切替" })

vim.keymap.set("n", "<leader>tcs", function()
  coverage.summary()
end, { desc = "カバレッジサマリーを表示" })

vim.keymap.set("n", "<leader>tcx", function()
  coverage.clear()
end, { desc = "カバレッジをクリア" })
