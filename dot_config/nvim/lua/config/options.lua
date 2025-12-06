-- 行番号を表示
vim.opt.number = true

-- <Tab>を入力したら<Space>を２個挿入する
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2

--不可視文字を表示
vim.opt.list = true
vim.opt.listchars = {
  tab = '→ ',
  space = '·',
  trail = '·',
  nbsp = '␣',
  eol = '↵',
}

-- 折りたたみ
vim.opt.foldenable = true
-- ファイルを開いた時は折りたたまずに全てを展開した状態で開く
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
-- 折りたたみ列は表示しない
vim.opt.foldcolumn = '0'
