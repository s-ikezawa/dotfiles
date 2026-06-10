-- ~/.config/nvim/lua/plugins/overlook.lua
-- WilliamHsieh/overlook.nvim
-- =============================================================================
-- 定義 / カーソル位置などを、その場を離れずにフローティングポップアップで
-- プレビューする (peek)。ポップアップはスタックでき、その中でさらに peek して
-- 潜っていける。<leader>(= ,) prefix の `p` 系にキーを割り当てる。
-- =============================================================================

require("overlook").setup({})

local api = require("overlook.api")
local map = vim.keymap.set

-- Peek (プレビューを開く)
map("n", "<leader>pd", function() api.peek_definition() end, { desc = "Overlook: 定義をプレビュー" })
map("n", "<leader>pp", function() api.peek_cursor() end, { desc = "Overlook: カーソル位置をプレビュー" })

-- スタック操作
map("n", "<leader>pf", function() api.switch_focus() end, { desc = "Overlook: ポップアップへフォーカス移動" })
map("n", "<leader>pu", function() api.restore_popup() end, { desc = "Overlook: 直前に閉じたポップアップを復元" })
map("n", "<leader>pU", function() api.restore_all_popups() end, { desc = "Overlook: 全ポップアップを復元" })
map("n", "<leader>pc", function() api.close_all() end, { desc = "Overlook: 全ポップアップを閉じる" })

-- ポップアップの内容を実体のウィンドウで開く
map("n", "<leader>ps", function() api.open_in_split() end, { desc = "Overlook: 水平分割で開く" })
map("n", "<leader>pv", function() api.open_in_vsplit() end, { desc = "Overlook: 垂直分割で開く" })
map("n", "<leader>pt", function() api.open_in_tab() end, { desc = "Overlook: 新規タブで開く" })
map("n", "<leader>po", function() api.open_in_original_window() end, { desc = "Overlook: 元のウィンドウで開く" })
