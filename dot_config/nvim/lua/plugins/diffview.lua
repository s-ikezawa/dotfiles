-- ============================================================================
-- diffview.nvim - 変更ファイル一覧 + 差分レビュー
-- https://github.com/sindrets/diffview.nvim
-- ============================================================================
-- このワークフローの中核。:DiffviewOpen で
--   左: 変更ファイル一覧パネル / 右: side-by-side 差分
-- を開き、AI が変更したファイルを「一覧 → 中身確認」できる。
-- 外部編集は自動反映されないため、パネル内で `R`（refresh）するか
-- 開き直すと最新になる（自動リロード設定は lua/autoreload.lua）。

require("diffview").setup({
  enhanced_diff_hl = true, -- 差分のハイライトを見やすくする
})

-- ----------------------------------------------------------------------------
-- キーマップ（リーダーは "," なので ,gd など）
-- ----------------------------------------------------------------------------
-- ,gd : 作業ツリーの変更をレビュー（変更ファイル一覧 + 差分）
vim.keymap.set("n", "<leader>gd", "<cmd>DiffviewOpen<cr>", { desc = "Diffview: 変更をレビュー" })
-- ,gm : main ブランチとの差分（AI が作業したブランチ全体をレビュー）
vim.keymap.set("n", "<leader>gm", "<cmd>DiffviewOpen origin/HEAD...HEAD --imply-local<cr>", { desc = "Diffview: ブランチ差分" })
-- ,gc : diffview を閉じる
vim.keymap.set("n", "<leader>gc", "<cmd>DiffviewClose<cr>", { desc = "Diffview: 閉じる" })
-- ,gh : 現在のファイルの変更履歴
vim.keymap.set("n", "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", { desc = "Diffview: ファイル履歴" })
