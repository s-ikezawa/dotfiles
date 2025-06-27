local opt = vim.opt

-- リーダーキー
vim.g.mapleader = " " -- スペースキーをリーダーキーに設定
vim.g.maplocalleader = " " -- ローカルリーダーキーもスペースに設定

-- 行番号
opt.number = true -- 行番号を表示
opt.relativenumber = true -- 相対行番号を表示

-- インデント
opt.expandtab = true -- タブをスペースに変換
opt.shiftwidth = 2 -- インデント幅を2に設定
opt.tabstop = 2 -- タブ幅を2に設定
opt.smartindent = true -- 自動インデントを有効化

-- 検索
opt.ignorecase = true -- 検索時に大文字小文字を区別しない
opt.smartcase = true -- 検索パターンに大文字が含まれる場合は区別する
opt.hlsearch = true -- 検索結果をハイライト
opt.incsearch = true -- インクリメンタル検索を有効化

-- 表示
opt.wrap = false -- 行の折り返しを無効化
opt.scrolloff = 8 -- カーソル上下に最低8行表示
opt.sidescrolloff = 8 -- カーソル左右に最低8文字表示
opt.signcolumn = "yes" -- サイン列を常に表示
opt.cursorline = true -- カーソル行をハイライト

-- ファイル
opt.swapfile = false -- スワップファイルを作成しない
opt.backup = false -- バックアップファイルを作成しない
opt.undofile = true -- アンドゥファイルを作成（永続的なアンドゥ）
opt.undodir = vim.fn.stdpath "data" .. "/undo" -- アンドゥファイルの保存先

-- クリップボード
opt.clipboard = "unnamedplus" -- システムクリップボードを使用

-- 分割
opt.splitbelow = true -- 水平分割時に下に新しいウィンドウ
opt.splitright = true -- 垂直分割時に右に新しいウィンドウ

-- マウス
opt.mouse = "a" -- すべてのモードでマウスを有効化

-- 補完
opt.completeopt = { "menuone", "noselect", "noinsert" } -- 補完メニューの動作設定
opt.pumheight = 10 -- 補完メニューの最大高さ

-- パフォーマンス
opt.updatetime = 250 -- CursorHoldイベントのトリガー時間（ミリ秒）
opt.timeoutlen = 300 -- マッピングのタイムアウト時間（ミリ秒）

-- 文字エンコーディング
opt.encoding = "utf-8" -- 内部エンコーディングをUTF-8に設定
opt.fileencoding = "utf-8" -- ファイルエンコーディングをUTF-8に設定

-- 表示文字
opt.list = true -- 不可視文字を表示
opt.listchars = { -- 不可視文字の表示設定
	tab = "▸ ",
	trail = "·",
	extends = "→",
	precedes = "←",
	nbsp = "␣",
}

-- ターミナル
opt.termguicolors = true -- 24ビットカラーを有効化

-- コマンドライン
opt.cmdheight = 1 -- コマンドラインの高さ
opt.showmode = false -- モード表示を無効化（ステータスラインで表示）

-- ステータスライン
opt.laststatus = 3 -- グローバルステータスラインを使用
