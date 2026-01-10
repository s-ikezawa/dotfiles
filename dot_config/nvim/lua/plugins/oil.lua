return {
  "stevearc/oil.nvim",
  dependencies = {
    "nvim-mini/mini.icons"
  },
  cmd = "Oil",
  keys = {
    { "<leader>-", "<cmd>Oil --float<cr>", desc = "フローティングウィンドウでOilを開く" }
  },
  opts = {
    default_file_explorer = true,         -- デフォルトのエクスプローラ(netrw)を無効化してOilを使用
    delete_to_trash = true,               -- 削除時はゴミ箱へ移動
    skip_confirm_for_simple_edits = true, -- ファイル操作時の確認ダイアログをスキップ
    view_options = {
      show_hidden = true,
      is_hidden_file = function(name, _)
        return vim.startswith(name, "..")
      end,
    },
    float = {
      padding = 2,
      max_width = 90,
      max_height = 0,
      border = "rounded",
      win_options = {
        winblend = 0,
      },
    },
    preview = {
      border = "rounded",
    },
    keymaps = {
      ["<esc>"] = "actions.close",
      ["<C-v>"] = "actions.select_vsplit",
      ["<C-s>"] = "actions.select_split",
    },
  },
}
