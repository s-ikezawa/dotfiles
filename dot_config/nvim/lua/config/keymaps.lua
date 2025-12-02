-- Basic
-- 検索ハイライトを消去
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = '検索ハイライトを消去' })

-- wrap表示でも1行ずつ移動
vim.keymap.set('n', 'j', 'gj', { desc = '表示行として下に移動' })
vim.keymap.set('n', 'k', 'gk', { desc = '表示行として上に移動' })

-- インデント後もビジュアルモードを維持
vim.keymap.set('v', '<', '<gv', { desc = 'インデントを左に（選択を維持）' })
vim.keymap.set('v', '>', '>gv', { desc = 'インデントを右に（選択を維持）' })

-- ビジュアルモードで行を移動
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { desc = '選択行を下に移動' })
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { desc = '選択行を上に移動' })

-- カーソル位置を維持したままJで結合
vim.keymap.set('n', 'J', 'mzJ`z', { desc = 'カーソル位置を維持して行を結合' })

-- 画面中央を維持したままスクロール
vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = '半画面下にスクロール（中央維持）' })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = '半画面上にスクロール（中央維持）' })
vim.keymap.set('n', 'n', 'nzzzv', { desc = '次の検索結果（中央維持）' })
vim.keymap.set('n', 'N', 'Nzzzv', { desc = '前の検索結果（中央維持）' })

-- システムクリップボードとのやり取り
vim.keymap.set({ 'n', 'v' }, '<leader>y', '"+y', { desc = 'システムクリップボードにヤンク' })
vim.keymap.set('n', '<leader>Y', '"+Y', { desc = '行全体をシステムクリップボードにヤンク' })
vim.keymap.set({ 'n', 'v' }, '<leader>p', '"+p', { desc = 'システムクリップボードから貼り付け' })

-- 削除時にレジスタに保存しない
vim.keymap.set({ 'n', 'v' }, '<leader>x', '"_d', { desc = 'レジスタに保存せずに削除' })

-- Window
-- ウィンドウ分割
vim.keymap.set('n', '<leader>wv', '<cmd>vsplit<CR>', { desc = 'ウィンドウを垂直分割' })
vim.keymap.set('n', '<leader>wh', '<cmd>split<CR>', { desc = 'ウィンドウを水平分割' })
vim.keymap.set('n', '<leader>wx', '<cmd>close<CR>', { desc = '現在のウィンドウを閉じる' })

-- ウィンドウ間の移動
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = '左のウィンドウへ移動' })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = '下のウィンドウへ移動' })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = '上のウィンドウへ移動' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = '右のウィンドウへ移動' })

-- ウィンドウサイズ変更
vim.keymap.set('n', '<C-Up>', '<cmd>resize +2<CR>', { desc = 'ウィンドウの高さを増やす' })
vim.keymap.set('n', '<C-Down>', '<cmd>resize -2<CR>', { desc = 'ウィンドウの高さを減らす' })
vim.keymap.set('n', '<C-Left>', '<cmd>vertical resize -2<CR>', { desc = 'ウィンドウの幅を減らす' })
vim.keymap.set('n', '<C-Right>', '<cmd>vertical resize +2<CR>', { desc = 'ウィンドウの幅を増やす' })

-- Terminal
vim.keymap.set('t', '<C-h>', '<C-\\><C-n><C-w>h', { desc = "ターミナルから左のウィンドウへ移動" })
vim.keymap.set('t', '<C-j>', '<C-\\><C-n><C-w>j', { desc = "ターミナルから下のウィンドウへ移動" })
vim.keymap.set('t', '<C-k>', '<C-\\><C-n><C-w>k', { desc = "ターミナルから上のウィンドウへ移動" })
vim.keymap.set('t', '<C-l>', '<C-\\><C-n><C-w>l', { desc = "ターミナルから右のウィンドウへ移動" })
