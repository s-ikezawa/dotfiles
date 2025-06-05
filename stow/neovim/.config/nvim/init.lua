-- Neovim設定ファイル

-- リーダーキーの設定（他の設定より先に行う）
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- lazy.nvimのbootstrap
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- プラグインの設定を読み込む
require('lazy').setup('plugins', {
  defaults = {
    lazy = false, -- デフォルトで遅延読み込みを有効化
  },
  install = {
    colorscheme = { 'habamax' }, -- インストール中のカラースキーム
  },
  checker = {
    enabled = true, -- 自動アップデートチェックを有効化
    notify = false, -- アップデート通知を無効化
  },
  change_detection = {
    enabled = true,
    notify = false,
  },
  performance = {
    rtp = {
      disabled_plugins = {
        'gzip',
        'matchit',
        'matchparen',
        'netrwPlugin',
        'tarPlugin',
        'tohtml',
        'tutor',
        'zipPlugin',
      },
    },
  },
})

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
opt.signcolumn = 'yes'   -- サインカラムを常に表示
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
opt.updatetime = 250         -- アップデート時間
opt.timeoutlen = 300         -- キーコンボのタイムアウト

-- 不可視文字の表示
opt.list = true
opt.listchars = {
  tab = '» ',
  trail = '·',
  nbsp = '␣',
}

-- キーマッピング
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

-- 自動コマンド
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- ヤンク時のハイライト
augroup('YankHighlight', { clear = true })
autocmd('TextYankPost', {
  group = 'YankHighlight',
  pattern = '*',
  callback = function()
    vim.highlight.on_yank({ higroup = 'IncSearch', timeout = 200 })
  end,
})

-- ファイルタイプ別の設定
augroup('FileTypeSettings', { clear = true })
autocmd('FileType', {
  group = 'FileTypeSettings',
  pattern = { 'python' },
  callback = function()
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
  end,
})

-- 末尾の空白を自動削除
augroup('TrimWhitespace', { clear = true })
autocmd('BufWritePre', {
  group = 'TrimWhitespace',
  pattern = '*',
  callback = function()
    local save_cursor = vim.fn.getpos('.')
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.setpos('.', save_cursor)
  end,
})

-- ターミナル設定
autocmd('TermOpen', {
  pattern = '*',
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = 'no'
    vim.cmd('startinsert')
  end,
})

-- ターミナルモードでのキーマッピング
keymap('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'ターミナルモードを抜ける' })
