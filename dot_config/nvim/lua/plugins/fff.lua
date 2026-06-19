-- ============================================================================
-- fff.nvim - 高速ファイルピッカー（Rust 製）
-- https://github.com/dmtrKovalenko/fff.nvim
-- ============================================================================
-- 注: ネイティブバイナリ(Rust)が必要。インストール/更新時のビルドは
--     plugins/init.lua の PackChanged autocmd で自動実行される。

require("fff").setup({}) -- 既定設定で初期化（必要に応じてオプションを追加）

-- ----------------------------------------------------------------------------
-- キーマップ（リーダーは "," なので ,ff / ,fg で起動）
-- ----------------------------------------------------------------------------
vim.keymap.set("n", "<leader>ff", function()
  require("fff").find_files() -- ファイル検索（ファイルピッカー）
end, { desc = "FFF: ファイル検索" })

vim.keymap.set("n", "<leader>fg", function()
  require("fff").live_grep() -- ファイル内容を全文検索（ライブ grep）
end, { desc = "FFF: ライブ grep" })

-- ,gf : Git で変更されたファイルだけを fff で開く
-- fff の git 制約構文を初期クエリにプリフィル（git:modified / staged / untracked 等に変更可）
vim.keymap.set("n", "<leader>gf", function()
  require("fff").find_files({ query = "git:modified " })
end, { desc = "FFF: 変更ファイルを検索(git)" })
