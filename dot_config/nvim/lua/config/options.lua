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

-- 常にsigncolumnを表示する
vim.opt.signcolumn = 'yes'

-- フローティングウィンドウの罫線
vim.opt.winborder = 'double'

-- 隠れバッファを許可（保存せずに他のバッファに移動可能）
vim.opt.hidden = true
-- スワップファイルを作成しない
vim.opt.swapfile = false
-- バックアップファイルを作成しない
vim.opt.backup = false
-- undoファイルを永続化
vim.opt.undofile = true
-- undoの保存ディレクトリ
vim.opt.undodir = vim.fn.stdpath("data") .. "/undo"

-- 補完メニューの動作設定
vim.opt.completeopt = {
  "menu",     -- 補完メニューを使用
  "menuone",  -- 候補が1つでもメニューを表示
  "noinsert", -- 自動的に挿入しない
  "noselect", -- 自動的に選択しない
  "fuzzy"     -- ファジー検索を有効化
}
