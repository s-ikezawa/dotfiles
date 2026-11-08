-- which-key: キーを途中まで押すと、続けて押せるキーと説明（keymap の desc）を一覧で出す。
-- https://github.com/folke/which-key.nvim

vim.pack.add({ 'https://github.com/folke/which-key.nvim' })

local wk = require('which-key')

wk.setup({
  preset = 'helix', -- 一覧を右下に縦長で出す（ほかに classic・modern）
})

-- <leader> の後のキーのまとまりに名前を付ける（keymaps.lua の割り当てと合わせる）
wk.add({
  { '<leader>a', group = 'Claude Code' },
  { '<leader>b', group = 'バッファ' },
  { '<leader>c', group = 'コード' },
  { '<leader>f', group = 'ファイル' },
  { '<leader>g', group = 'git' },
  { '<leader>gh', group = '変更の固まり（hunk）' },
  { '<leader>q', group = '終了' },
  { '<leader>s', group = '検索・置換' },
  { '<leader>u', group = '表示の切り替え' },
  { '<leader>w', group = 'ウィンドウ' },
  { '<leader>x', group = 'リスト' },
  { '<leader><tab>', group = 'タブ' },
  { '[', group = '前へ' },
  { ']', group = '次へ' },
  { 'g', group = 'g で始まる操作' },
  { 'gr', group = 'LSP' },
  { 'z', group = '折り畳み・画面の位置' },
})

-- <leader>? で、いまのバッファだけのマッピングを一覧する
vim.keymap.set('n', '<leader>?', function()
  wk.show({ global = false })
end, { desc = 'このバッファのキーマップを一覧する' })
