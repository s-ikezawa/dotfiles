-- ============================================================================
-- noice.nvim - cmdline / メッセージ / 通知の UI を置き換える
-- https://github.com/folke/noice.nvim
-- ============================================================================
-- cmdheight=0（options.lua）で常時消したコマンドライン行の代わりに、
-- コマンド入力・検索・各種メッセージをポップアップで描画する。
--
-- snacks 連携:
--   * 通知(notify)ビューの backend は既定で { "snacks", "notify" }。snacks の
--     notifier を有効化済み（plugins/snacks.lua）なので通知は snacks に集約され、
--     nvim-notify は無効時のフォールバックとして残す。
--   * snacks picker 有効時は Snacks.picker.sources.noice が自動登録され、
--     メッセージ履歴を snacks ピッカーで閲覧できる（`:Noice snacks`）。
--     fff.nvim は「ファイル専用」ピッカーで任意アイテムを出せないため履歴には使えない。
--     ファイル探索は fff、履歴は snacks ピッカーに統一する（下のキーマップ参照）。
-- 依存: nui.nvim（UI 部品）, snacks.nvim（通知/履歴ピッカー）, nvim-notify（通知のフォールバック）

require("noice").setup({
  lsp = {
    -- LSP の hover / signature を Markdown として描画する（treesitter ハイライト付き）
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
    },
  },
  -- よく使う UI プリセット
  presets = {
    bottom_search = true,         -- / 検索は画面下のクラシックなコマンドラインで表示
    command_palette = true,       -- : コマンドと候補を画面中央寄りにまとめて表示
    long_message_to_split = true, -- 長いメッセージは分割ウィンドウに送る
  },
})

-- ----------------------------------------------------------------------------
-- キーマップ（リーダーは "," なので ,n* で起動）
-- 履歴は snacks ピッカーに統一（fff はファイル専用なので使わない）。
-- ----------------------------------------------------------------------------
vim.keymap.set("n", "<leader>nh", "<cmd>Noice snacks<cr>", { desc = "Noice: メッセージ履歴を snacks ピッカーで表示" })
vim.keymap.set("n", "<leader>nl", "<cmd>Noice last<cr>", { desc = "Noice: 最後のメッセージを再表示" })
vim.keymap.set("n", "<leader>nd", "<cmd>Noice dismiss<cr>", { desc = "Noice: 表示中の通知を消す" })
