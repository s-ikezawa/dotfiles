-- Neovim の設定。主に Claude Code の変更をじっくりレビューするために使う（簡単な差分は hunk）。

-- ---------------------------------------------------------------------------
-- オプション
-- ---------------------------------------------------------------------------
vim.g.mapleader = ' '

vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = 'yes'     -- 差分の印などで本文が左右にずれないよう、常に表示する
vim.o.cursorline = true
vim.o.scrolloff = 5
vim.o.wrap = false

vim.o.ignorecase = true
vim.o.smartcase = true       -- 大文字を含むときだけ大文字と小文字を区別する

vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2

vim.o.clipboard = 'unnamedplus' -- ヤンクを macOS のクリップボードと共有する
vim.o.undofile = true
vim.o.splitright = true
vim.o.splitbelow = true
