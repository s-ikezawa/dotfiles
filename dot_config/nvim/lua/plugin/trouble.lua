-- trouble: 診断・参照・呼び出し階層・シンボル・quickfix を、ファイルごとにまとめたツリー状のリストで出す。
-- 一覧では <CR> で開き、p でプレビュー、o で開いてリストを閉じ、q で閉じる。? でキーの一覧。
-- Claude には一覧を送らない。Claude からは claudecode.nvim の getDiagnostics で同じ診断を読める。
-- https://github.com/folke/trouble.nvim

vim.pack.add({ { src = 'https://github.com/folke/trouble.nvim', version = vim.version.range('*') } }) -- 最新のリリースを追う

require('trouble').setup({})

local map = vim.keymap.set
-- 診断
map('n', '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>', { desc = '診断の一覧（すべてのファイル）を開く・閉じる' })
map('n', '<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', { desc = '診断の一覧（このファイル）を開く・閉じる' })
-- LSP（右に出し、カーソルはコードに残す）。シンボルの一覧は aerial（<leader>cs）で出す
map('n', '<leader>cl', '<cmd>Trouble lsp toggle focus=false win.position=right<cr>', { desc = 'カーソルの語の定義・参照・実装などを一覧する' })
map('n', '<leader>ci', '<cmd>Trouble lsp_incoming_calls toggle<cr>', { desc = 'この関数を呼んでいるところを一覧する' })
map('n', '<leader>co', '<cmd>Trouble lsp_outgoing_calls toggle<cr>', { desc = 'この関数から呼んでいるものを一覧する' })
-- quickfix・ロケーションリスト（標準の画面は <leader>xq・<leader>xl のまま）
map('n', '<leader>xQ', '<cmd>Trouble qflist toggle<cr>', { desc = 'quickfix リストを trouble で開く・閉じる' })
map('n', '<leader>xL', '<cmd>Trouble loclist toggle<cr>', { desc = 'ロケーションリストを trouble で開く・閉じる' })

-- [q・]q は、trouble の一覧が開いていればその項目を、なければ quickfix を順に移る（keymaps.lua の割り当てを上書き）
local function list_jump(dir)
  return function()
    local trouble = require('trouble')
    if trouble.is_open() then
      trouble[dir]({ skip_groups = true, jump = true })
    else
      local ok, err = pcall(dir == 'next' and vim.cmd.cnext or vim.cmd.cprev)
      if not ok then vim.notify(err, vim.log.levels.ERROR) end
    end
  end
end
map('n', ']q', list_jump('next'), { desc = '次の項目へ（trouble か quickfix）' })
map('n', '[q', list_jump('prev'), { desc = '前の項目へ（trouble か quickfix）' })
