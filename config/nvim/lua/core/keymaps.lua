local keymap = vim.keymap.set

-------------------------------------------------------------------------------
--- Normal Mode
-------------------------------------------------------------------------------
-- ノーマルモードでのウィンドウ間の移動
keymap("n", "<C-h>", "<C-w>h", { desc = "Navigate to left window" })
keymap("n", "<C-j>", "<C-w>j", { desc = "Navigate to window below" })
keymap("n", "<C-k>", "<C-w>k", { desc = "Navigate to window above" })
keymap("n", "<C-l>", "<C-w>l", { desc = "Navigate to right window" })

-- ウィンドウのリサイズ
keymap("n", "<leader>H", "<C-w>5<", { desc = "Decrease window width" })
keymap("n", "<leader>J", "<C-w>5-", { desc = "Decrease window height" })
keymap("n", "<leader>K", "<C-w>5+", { desc = "Increase window height" })
keymap("n", "<leader>L", "<C-w>5>", { desc = "Increase window width" })

-------------------------------------------------------------------------------
--- Insert Mode
-------------------------------------------------------------------------------
-- Insert ModeからNormal Modeに戻る
keymap("i", "jk", "<Esc>", { desc = "Exit insert mode" })
keymap("i", "<C-[>", "<Esc>", { desc = "Exit insert mode" })

-------------------------------------------------------------------------------
--- Terminal Mode
-------------------------------------------------------------------------------
-- ターミナルモードからノーマルモードへ（jkを使用）
keymap("t", "jk", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- ターミナルからウィンドウ間の移動
keymap("t", "<C-h>", "<C-\\><C-n><C-w>h", { desc = "Navigate to left window from terminal" })
keymap("t", "<C-j>", "<C-\\><C-n><C-w>j", { desc = "Navigate to window below from terminal" })
keymap("t", "<C-k>", "<C-\\><C-n><C-w>k", { desc = "Navigate to window above from terminal" })
keymap("t", "<C-l>", "<C-\\><C-n><C-w>l", { desc = "Navigate to right window from terminal" })
