local keymap = vim.keymap

keymap.set("i", "jk", "<ESC>", { desc = "インサートモードを終了" })

keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "検索ハイライトをクリア" })

keymap.set("n", "x", '"_x')

keymap.set("n", "<leader>+", "<C-a>", { desc = "数値をインクリメント" })
keymap.set("n", "<leader>-", "<C-x>", { desc = "数値をデクリメント" })

keymap.set("n", "<leader>sv", "<C-w>v", { desc = "ウィンドウを垂直分割" })
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "ウィンドウを水平分割" })
keymap.set("n", "<leader>se", "<C-w>=", { desc = "分割を均等化" })
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "現在の分割を閉じる" })

keymap.set("n", "<C-h>", "<C-w>h", { desc = "左の分割ウィンドウへ移動" })
keymap.set("n", "<C-j>", "<C-w>j", { desc = "下の分割ウィンドウへ移動" })
keymap.set("n", "<C-k>", "<C-w>k", { desc = "上の分割ウィンドウへ移動" })
keymap.set("n", "<C-l>", "<C-w>l", { desc = "右の分割ウィンドウへ移動" })

keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "新しいタブを開く" })
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "現在のタブを閉じる" })
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "次のタブへ移動" })
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "前のタブへ移動" })
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "現在のバッファを新しいタブで開く" })

keymap.set("v", "<", "<gv")
keymap.set("v", ">", ">gv")

keymap.set("v", "J", ":m '>+1<CR>gv=gv")
keymap.set("v", "K", ":m '<-2<CR>gv=gv")

keymap.set("n", "J", "mzJ`z")
keymap.set("n", "<C-d>", "<C-d>zz")
keymap.set("n", "<C-u>", "<C-u>zz")
keymap.set("n", "n", "nzzzv")
keymap.set("n", "N", "Nzzzv")

keymap.set("x", "<leader>p", [["_dP]])

-- ターミナルモードでのスクロール
keymap.set("t", "<C-h>", [[<C-\><C-n><C-w>h]], { desc = "ターミナルから左の分割ウィンドウへ移動" })
keymap.set("t", "<C-j>", [[<C-\><C-n><C-w>j]], { desc = "ターミナルから下の分割ウィンドウへ移動" })
keymap.set("t", "<C-k>", [[<C-\><C-n><C-w>k]], { desc = "ターミナルから上の分割ウィンドウへ移動" })
keymap.set("t", "<C-l>", [[<C-\><C-n><C-w>l]], { desc = "ターミナルから右の分割ウィンドウへ移動" })

-- ターミナルモードでhjklでスクロール（ノーマルモードに切り替えてからスクロール）
vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  callback = function()
    -- ターミナルバッファでのみ有効なキーマップ
    vim.keymap.set("t", "<C-n>", [[<C-\><C-n>]], { buffer = true, desc = "ターミナルモードからノーマルモードへ" })
    vim.keymap.set("n", "i", "i", { buffer = true, desc = "ターミナルモードに戻る" })
    vim.keymap.set("n", "a", "a", { buffer = true, desc = "ターミナルモードに戻る" })
  end,
})