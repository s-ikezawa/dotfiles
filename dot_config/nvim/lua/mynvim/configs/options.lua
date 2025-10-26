-- mapleader
vim.g.mapleader = " "
vim.g.localmapleader = " "

-- clipboard
vim.opt.clipboard = { "unnamedplus", "unnamed" }
vim.g.clipboard = "osc52"

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true

-- <Tab>が入力された場合の設定
vim.opt.expandtab = true
vim.opt.shiftround = true
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.tabstop = 2

-- 分割設定
vim.opt.splitright = true
vim.opt.splitbelow = true

-- 補完
vim.opt.completeopt = {
  "menu",
  "menuone",
  "noinsert",
  "noselect",
  "fuzzy"
}

-- ステータスライン
vim.opt.laststatus = 3

-- Prepend mise shims to PATH
vim.env.PATH = vim.env.HOME .. "/.local/share/mise/shims:" .. vim.env.PATH
