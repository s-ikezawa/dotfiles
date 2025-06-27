local keymap = vim.keymap.set

-------------------------------------------------------------------------------
--- Normal Mode
-------------------------------------------------------------------------------
-- ノーマルモードでのウィンドウ間の移動
keymap("n", "<C-h>", "<C-w>h", { desc = "Navigate to left window" })
keymap("n", "<C-j>", "<C-w>j", { desc = "Navigate to window below" })
keymap("n", "<C-k>", "<C-w>k", { desc = "Navigate to window above" })
keymap("n", "<C-l>", "<C-w>l", { desc = "Navigate to right window" })

-------------------------------------------------------------------------------
--- Terminal Mode
-------------------------------------------------------------------------------
-- ターミナルモードからノーマルモードへ
keymap("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- ターミナルからウィンドウ間の移動
keymap("t", "<C-h>", "<C-\\><C-n><C-w>h", { desc = "Navigate to left window from terminal" })
keymap("t", "<C-j>", "<C-\\><C-n><C-w>j", { desc = "Navigate to window below from terminal" })
keymap("t", "<C-k>", "<C-\\><C-n><C-w>k", { desc = "Navigate to window above from terminal" })
keymap("t", "<C-l>", "<C-\\><C-n><C-w>l", { desc = "Navigate to right window from terminal" })

