local opt = vim.opt
local g = vim.g

g.mapleader = " "
g.maplocalleader = " "

opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"
opt.wrap = false

opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true

opt.ignorecase = true
opt.smartcase = true

opt.cursorline = true
opt.termguicolors = true
opt.background = "dark"

opt.backspace = "indent,eol,start"

opt.clipboard:append("unnamedplus")

opt.splitright = true
opt.splitbelow = true

opt.iskeyword:append("-")

opt.mouse = "a"

opt.backup = false
opt.writebackup = false
opt.swapfile = false
opt.undofile = true
opt.undodir = os.getenv("HOME") .. "/.vim/undodir"

opt.updatetime = 300
opt.timeoutlen = 300

opt.conceallevel = 0

opt.fileencoding = "utf-8"

opt.hlsearch = true
opt.incsearch = true

opt.scrolloff = 8
opt.sidescrolloff = 8

opt.confirm = true

opt.showtabline = 2

opt.showmode = false

opt.laststatus = 3

opt.pumheight = 10

opt.conceallevel = 0

opt.fillchars = { eob = " " }