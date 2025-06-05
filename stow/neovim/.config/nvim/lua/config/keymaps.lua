-- キーマッピング設定

local keymap = vim.keymap.set

-- ノーマルモード
keymap('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = '検索ハイライトをクリア' })

-- ウィンドウ操作
keymap('n', '<C-h>', '<C-w>h', { desc = '左のウィンドウへ移動' })
keymap('n', '<C-j>', '<C-w>j', { desc = '下のウィンドウへ移動' })
keymap('n', '<C-k>', '<C-w>k', { desc = '上のウィンドウへ移動' })
keymap('n', '<C-l>', '<C-w>l', { desc = '右のウィンドウへ移動' })

-- バッファ操作
keymap('n', '<leader>bd', '<cmd>bdelete<CR>', { desc = 'バッファを削除' })
keymap('n', '<leader>bn', '<cmd>bnext<CR>', { desc = '次のバッファ' })
keymap('n', '<leader>bp', '<cmd>bprevious<CR>', { desc = '前のバッファ' })

-- ビジュアルモードでのインデント保持
keymap('v', '<', '<gv', { desc = '左にインデント' })
keymap('v', '>', '>gv', { desc = '右にインデント' })

-- 行の移動
keymap('v', 'J', ":m '>+1<CR>gv=gv", { desc = '選択行を下に移動' })
keymap('v', 'K', ":m '<-2<CR>gv=gv", { desc = '選択行を上に移動' })

-- ヤンク後のカーソル位置保持
keymap('v', 'y', 'y`]', { desc = 'ヤンク後カーソル位置を保持' })

-- ターミナルモードでのキーマッピング
keymap('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'ターミナルモードを抜ける' })