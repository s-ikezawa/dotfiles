return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  config = function()
    local wk = require("which-key")

    wk.setup({
      preset = "modern",
      delay = 500,
      sort = { "alphanum" }, -- アルファベット順でソート
    })

    -- キーマッピングのグループ設定
    wk.add({
      -- ファイル操作
      { "<leader>f", group = "📁 File" },
      { "<leader>fs", desc = "💾 保存" },
      { "<leader>fe", desc = "🌲 エクスプローラー" },
      { "<leader>fp", desc = "📋 パスをコピー" },

      -- ウィンドウ操作
      { "<leader>w", group = "🪟 Window" },
      { "<leader>wv", desc = "↔️ 垂直分割" },
      { "<leader>wh", desc = "↕️ 水平分割" },
      { "<leader>wq", desc = "❌ 閉じる" },
      { "<leader>wQ", desc = "🚫 全て閉じる" },

      -- バッファ操作
      { "<leader>b", group = "📄 Buffer" },
      { "<leader>bd", desc = "❌ バッファを閉じる" },

      -- タブ操作
      { "<leader>T", group = "📑 Tab" },
      { "<leader>Tn", desc = "➕ 新しいタブ" },
      { "<leader>Tc", desc = "❌ タブを閉じる" },
      { "<leader>To", desc = "🔒 他のタブを閉じる" },

      -- LSP
      { "<leader>l", group = "💡 LSP" },
      { "<leader>lr", desc = "✏️ リネーム" },
      { "<leader>la", desc = "⚡ コードアクション" },
      { "<leader>le", desc = "🔍 診断情報" },
      { "<leader>lpf", desc = "👁️ 関数定義をプレビュー" },
      { "<leader>lpc", desc = "👁️ クラス定義をプレビュー" },

      -- トグル機能
      { "<leader>t", group = "🔄 Toggle" },
      { "<leader>ts", desc = "📝 スペルチェック" },
      { "<leader>tr", desc = "🔢 相対行番号" },
      { "<leader>tl", desc = "👁️ 空白文字表示" },

      -- クイックフィックス
      { "<leader>q", group = "🔧 Quickfix" },
      { "<leader>qo", desc = "📖 開く" },
      { "<leader>qc", desc = "❌ 閉じる" },

      -- クリップボード
      { "<leader>y", group = "📋 Yank" },
      { "<leader>p", group = "📌 Paste" },

      -- AI
      { "<leader>a", group = "🤖 AI" },
      { "<leader>ac", desc = "💬 ClaudeCode" },

      -- Git
      { "<leader>g", group = "🔱 Git" },
      { "<leader>gg", desc = "🚀 Lazygitを開く" },
      { "<leader>gl", desc = "📜 Gitログを開く" },
      { "<leader>gf", desc = "📄 ファイルのGitログを開く" },

      -- Search (将来的に使用予定)
      { "<leader>s", group = "🔍 Search" },

      -- Exchange/Swap
      { "<leader>x", group = "🔄 Exchange" },
      { "<leader>xp", desc = "➡️ 次のパラメータと入れ替え" },
      { "<leader>xP", desc = "⬅️ 前のパラメータと入れ替え" },
      { "<leader>xf", desc = "➡️ 次の関数と入れ替え" },
      { "<leader>xF", desc = "⬅️ 前の関数と入れ替え" },
    })
  end,
}
