local opt = vim.opt

-- リーダーキー
vim.g.mapleader = ","
vim.g.maplocalleader = ","

-- 行番号
opt.number = true -- 行番号を表示
opt.relativenumber = true -- 相対行番号を表示

-- インデント
opt.expandtab = true -- タブをスペースに変換
opt.shiftwidth = 2 -- インデント幅
opt.tabstop = 2 -- タブ幅
opt.softtabstop = 2 -- 編集時のタブ幅
opt.smartindent = true -- スマートインデント

-- 検索
opt.ignorecase = true -- 検索時に大文字小文字を区別しない
opt.smartcase = true -- 大文字が含まれる場合は区別する
opt.hlsearch = true -- 検索結果をハイライト
opt.incsearch = true -- インクリメンタルサーチ

-- 表示
opt.termguicolors = true -- True Color を有効化
opt.signcolumn = "yes" -- サイン列を常に表示
opt.cursorline = true -- カーソル行をハイライト
opt.wrap = false -- 行を折り返さない
opt.scrolloff = 8 -- スクロール時に上下に余白を確保
opt.sidescrolloff = 8 -- 横スクロール時に左右に余白を確保
opt.showmode = false -- モード表示を無効化 (ステータスラインで表示するため)
opt.laststatus = 3 -- グローバルステータスライン

-- 分割
opt.splitbelow = true -- 水平分割時に下に開く
opt.splitright = true -- 垂直分割時に右に開く

-- ファイル
opt.swapfile = false -- スワップファイルを作成しない
opt.backup = false -- バックアップファイルを作成しない
opt.undofile = true -- アンドゥ履歴をファイルに保存
opt.fileencoding = "utf-8" -- ファイルのエンコーディング

-- 補完
opt.completeopt = { "menu", "menuone", "noselect" } -- 補完メニューの設定
opt.pumheight = 10 -- 補完メニューの最大表示数

-- その他
opt.mouse = "a" -- マウス操作を有効化
opt.clipboard = "unnamedplus" -- システムクリップボードと連携
opt.updatetime = 250 -- CursorHold の待ち時間 (ms)
opt.timeoutlen = 300 -- キーマッピングのタイムアウト (ms)
opt.conceallevel = 0 -- テキストを隠さない
opt.list = true -- 不可視文字を表示
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" } -- 不可視文字の表示形式
opt.fillchars = { eob = " " } -- バッファ末尾の ~ を非表示
opt.iskeyword:append("-") -- ハイフン付き単語を1単語として扱う
