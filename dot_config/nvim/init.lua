-- <leader>キーをspaceに設定
vim.g.mapleader = ' '
vim.g.localleader = ' '

if vim.g.vscode then
  vim.o.timeout = false --<leader>のディレイをなくす
end

-- クリップボードをOS側と共有
vim.opt.clipboard:append("unnamedplus")

-- 検索時に大文字、小文字を区別しない
vim.opt.ignorecase = true

-- 検索文字列に大文字が含まれる場合は大文字、小文字を区別する
vim.opt.smartcase = true

--
-- Keybindings
-- 
vim.keymap.set("i", "<c-a>", "<c-o>^", { desc = "文頭に移動" })
vim.keymap.set("i", "<c-b>", "<left>", { desc = "１文字左に移動"})
vim.keymap.set("i", "<c-d>", "<del>", { desc = "１文字右を削除"})
vim.keymap.set("i", "<c-e>", "<end>", { desc = "行末に移動" })
vim.keymap.set("i", "<c-f>", "<right>", { desc = "１文字右に移動" })
vim.keymap.set("i", "<c-h>", "<bs>", { desc = "１文字左を削除"})
vim.keymap.set("i", "<c-k>", "<c-o>D", { desc = "カーソルから行末まで削除"})
vim.keymap.set("i", "<c-n>", "<down>", { desc = "１行下に移動"})
vim.keymap.set("i", "<c-p>", "<up>", { desc = "１行上に移動"})
