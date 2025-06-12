return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
  end,
  config = function()
    local wk = require("which-key")
    
    wk.setup({})
    
    wk.add({
      { "<leader>t", group = "タブ" },
      { "<leader>w", group = "ウィンドウ分割/ワークスペース" },
      { "<leader>wv", desc = "垂直分割" },
      { "<leader>wh", desc = "水平分割" },
      { "<leader>we", desc = "分割均等化" },
      { "<leader>wx", desc = "分割を閉じる" },
      { "<leader>wa", desc = "ワークスペース追加" },
      { "<leader>wr", desc = "ワークスペース削除" },
      { "<leader>wl", desc = "ワークスペース一覧" },
      { "<leader>n", group = "ユーティリティ" },
      { "<leader>nh", desc = "検索ハイライトクリア" },
      { "<leader>ni", desc = "数値インクリメント" },
      { "<leader>nd", desc = "数値デクリメント" },
      { "<leader>e", group = "編集/エクスプローラー" },
      { "<leader>ep", desc = "削除せずに貼り付け" },
      { "<leader>h", group = "Git変更箇所" },
      { "<leader>c", group = "Claude Code" },
      { "<leader>l", group = "LSP" },
      { "<leader>ld", desc = "診断を表示" },
      { "<leader>D", desc = "型定義へ移動" },
      { "<leader>rn", desc = "リネーム" },
      { "<leader>ca", desc = "コードアクション" },
      { "<leader>f", desc = "フォーマット" },
      { "<leader>q", desc = "診断をリストへ" },
    })
  end,
}