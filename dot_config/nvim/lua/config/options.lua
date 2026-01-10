vim.g.mapleader = ","
vim.g.maplocalleader = ","
vim.g.loaded_python3_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0

local opt = vim.opt

opt.number = true -- 行番号を表示
opt.relativenumber = true -- 行番号部分を常に表示（画面のガタつき防止）
opt.cursorline = true -- カーソル行をハイライト
opt.mouse = "a" -- マウス操作を有効化
opt.termguicolors = true -- 24bitカラーを有効化（モダンなカラースキームに必須）
opt.showmode = false -- モード表示（-- INSERT --等）を非表示（Lualine等を使う前提）
opt.laststatus = 3 -- ステータスラインを全ウィンドウで1つに統合（Global Statusline）
opt.winborder = "rounded" -- ウィンドウのボーダーを設定
opt.signcolumn = "yes" -- 常にsign column を表示

opt.expandtab = true -- タブ入力を空白に変換
opt.shiftwidth = 2 -- 自動インデントの幅
opt.tabstop = 2 -- 画面上のタブ幅
opt.smartindent = true -- 言語に合わせたスマートインデント

opt.ignorecase = true -- 検索時に大文字小文字を区別しない
opt.smartcase = true -- 大文字が含まれる場合は区別する
opt.incsearch = true -- 入力中からマッチする場所を表示
opt.hlsearch = true -- マッチした箇所をハイライト
opt.inccommand = "split" -- 置換（:%s/old/new/g）時に変更内容をプレビュー表示

opt.clipboard:append("unnamedplus") -- システムのクリップボードと同期
opt.hidden = true -- 保存していないバッファがあっても別のファイルを開けるようにする
opt.autoread = true -- 外部でファイルが書き換えられたら自動で読み直す

opt.splitbelow = true -- 分割したウィンドウを下に
opt.splitright = true -- 分割したウィンドウを右に

opt.foldenable = true
opt.foldlevel = 99
opt.foldlevelstart = 99

--- UndoをXDG準拠に
local undo_dir = vim.fn.expand(os.getenv("XDG_STATE_HOME") or "~/.local/state") .. "/nvim/undo"
if vim.fn.isdirectory(undo_dir) == 0 then
  vim.fn.mkdir(undo_dir, "p")
end
opt.undofile = true -- Undo履歴をファイルに保存
opt.undodir = undo_dir -- 保存先ディレクトリ

opt.updatetime = 250 -- 変更が保存されるまでの時間（短いほどLSPの反応が速くなる）
opt.timeoutlen = 400 -- キー入力待ち時間
opt.completeopt = { "menu", "menuone", "noselect" } -- 補完メニューの挙動

-- Prepend mise shims to PATH
vim.env.PATH = vim.env.HOME .. "/.local/share/mise/shims:" .. vim.env.PATH
