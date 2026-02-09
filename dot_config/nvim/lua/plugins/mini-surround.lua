vim.pack.add({
  "https://github.com/nvim-mini/mini.surround",
})

require("mini.surround").setup({
  -- gsa: Add surrounding (e.g. gsaiw" → word を " で囲む)
  -- gsd: Delete surrounding (e.g. gsd")
  -- gsr: Replace surrounding (e.g. gsr"')
  -- gsf: Find surrounding (右方向)
  -- gsF: Find surrounding (左方向)
  -- gsh: Highlight surrounding
  -- gsn: Update `n_lines`
  mappings = {
    add = "gsa",
    delete = "gsd",
    find = "gsf",
    find_left = "gsF",
    highlight = "gsh",
    replace = "gsr",
    update_n_lines = "gsn",
  },

  -- 囲み文字の検索範囲（行数）
  n_lines = 20,

  -- カーソル周辺の囲み文字の検索方法
  search_method = "cover",
})
