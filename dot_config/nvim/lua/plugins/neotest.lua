vim.pack.add({
  "https://github.com/nvim-neotest/neotest",
  -- required
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/nvim-neotest/nvim-nio",
  {
    src = "https://github.com/nvim-treesitter/nvim-treesitter",
    version = "main",
  },
  -- adapters
  "https://github.com/fredrikaverpil/neotest-golang",
})

require("neotest").setup({
  adapters = {
    require("neotest-golang")({
      go_test_args = {
        "-coverprofile=" .. vim.uv.cwd() .. "/coverage.out",
      },
    }),
  },
  summary = {
    -- 左側: "topleft vsplit | vertical resize 50"
    -- 右側: "botright vsplit | vertical resize 50"
    -- 上側: "topleft split | resize 20"
    -- 下側: "botright split | resize 20"
    open = "topleft vsplit | vertical resize 30",
  },
})

local neotest = require("neotest")

vim.keymap.set("n", "<leader>tn", function()
  neotest.run.run()
end, { desc = "最も近いテストを実行" })

vim.keymap.set("n", "<leader>tf", function()
  neotest.run.run(vim.fn.expand("%"))
end, { desc = "ファイルのテストを実行" })

vim.keymap.set("n", "<leader>ta", function()
  neotest.run.run(vim.uv.cwd())
end, { desc = "全テストを実行" })

vim.keymap.set("n", "<leader>ts", function()
  neotest.summary.toggle()
end, { desc = "テストサマリーを表示切替" })

vim.keymap.set("n", "<leader>to", function()
  neotest.output.open({ enter = true, auto_close = true })
end, { desc = "テスト出力を表示" })

vim.keymap.set("n", "<leader>tO", function()
  neotest.output_panel.toggle()
end, { desc = "出力パネルを表示切替" })

vim.keymap.set("n", "<leader>tS", function()
  neotest.run.stop()
end, { desc = "テストを停止" })

vim.keymap.set("n", "<leader>tw", function()
  neotest.watch.toggle(vim.fn.expand("%"))
end, { desc = "ウォッチモードを切替" })

vim.keymap.set("n", "]t", function()
  neotest.jump.next({ status = "failed" })
end, { desc = "次の失敗テストへ" })

vim.keymap.set("n", "[t", function()
  neotest.jump.prev({ status = "failed" })
end, { desc = "前の失敗テストへ" })
