-- ============================================================================
-- overlook.nvim - スタック可能な編集可能フロートでコードをプレビューする
-- https://github.com/WilliamHsieh/overlook.nvim
-- ============================================================================
-- 定義(LSP)やマーク・カーソル位置を、現在地を失わずにフロートで覗ける。
-- ポップアップは実バッファなので編集・保存・バッファ移動もそのまま可能で、
-- 覗いた先からさらに覗くとポップアップが積み重なり、探索の経路が可視化される。
-- AI 変更レビュー（読む）用途と相性が良く、peek_definition は kotlin-lsp 等の
-- ネイティブ LSP をそのまま利用する（lua/lsp.lua）。

require("overlook").setup({}) -- 既定設定で動作（border=rounded, ポップアップ内 q で閉じる 等）

-- ----------------------------------------------------------------------------
-- キーマップ（リーダーは "," なので ,p* で起動）
-- ----------------------------------------------------------------------------
local api = require("overlook.api")
local function map(lhs, fn, desc)
  vim.keymap.set("n", lhs, fn, { desc = desc })
end

map("<leader>pd", api.peek_definition, "Overlook: 定義をフロートでプレビュー")
map("<leader>pp", api.peek_cursor, "Overlook: カーソル位置をフロート化")
map("<leader>pf", api.switch_focus, "Overlook: ポップアップ/元ウィンドウのフォーカス切替")
map("<leader>pu", api.restore_popup, "Overlook: 直前に閉じたポップアップを復元")
map("<leader>pc", api.close_all, "Overlook: 全ポップアップを閉じる")
-- ポップアップの昇格（見つけた箇所を分割/タブで本格的に開く）
map("<leader>ps", api.open_in_split, "Overlook: ポップアップを水平分割に昇格")
map("<leader>pv", api.open_in_vsplit, "Overlook: ポップアップを垂直分割に昇格")
map("<leader>pt", api.open_in_tab, "Overlook: ポップアップをタブに昇格")
