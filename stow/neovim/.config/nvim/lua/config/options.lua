-- 基本オプション設定

local opt = vim.opt

-- 行番号
opt.number = true         -- 行番号を表示
opt.relativenumber = true -- 相対行番号を表示

-- インデント
opt.expandtab = true      -- タブを空白に変換
opt.shiftwidth = 2        -- インデント幅
opt.tabstop = 2          -- タブ幅
opt.softtabstop = 2      -- ソフトタブ幅
opt.smartindent = true   -- スマートインデント有効

-- 検索
opt.ignorecase = true    -- 大文字小文字を無視
opt.smartcase = true     -- 大文字が含まれる場合は区別
opt.hlsearch = true      -- 検索結果をハイライト
opt.incsearch = true     -- インクリメンタルサーチ

-- 表示
opt.wrap = false         -- 行折り返しを無効
opt.scrolloff = 8        -- スクロール時の余白
opt.sidescrolloff = 8    -- 水平スクロール時の余白
opt.signcolumn = 'yes:1' -- サインカラムを有効化
opt.termguicolors = true -- 24bitカラーを有効化
opt.cursorline = true    -- カーソル行をハイライト


-- フォント設定（GUI版Neovim用）
if vim.g.neovide then
  vim.g.neovide_font_family = 'UDEV Gothic NF'
  vim.g.neovide_font_size = 15
end

-- アイコン表示のための設定
vim.g.have_nerd_font = true

-- ファイル
opt.swapfile = false     -- スワップファイルを作成しない
opt.backup = false       -- バックアップファイルを作成しない
opt.undofile = true      -- アンドゥファイルを有効化
opt.undodir = vim.fn.expand('~/.local/state/nvim/undo//')

-- その他
opt.clipboard = 'unnamedplus' -- システムクリップボードを使用
opt.mouse = ''               -- マウスを無効化
opt.splitright = true        -- 垂直分割時に右に開く
opt.splitbelow = true        -- 水平分割時に下に開く
opt.updatetime = 100         -- アップデート時間（Gitステータス更新を高速化）
opt.timeoutlen = 300         -- キーコンボのタイムアウト

-- 不可視文字の表示
opt.list = true
opt.listchars = {
  tab = '» ',
  trail = '·',
  nbsp = '␣',
}