vim.g.loaded_python3_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.mapleader = ","

vim.opt.termguicolors = true

vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2

vim.opt.foldenable = true     -- 折りたたみを有効化
vim.opt.foldmethod = "indent" -- 折りたたみ方法(manual, indent, expr, syntax, marker, diff)
vim.opt.foldlevel = 99        -- 起動時は折りたたまれていない状態で表示
vim.opt.foldcolumn = "0"      -- 折りたたみ列の表示幅(0で非表示)

vim.opt.timeoutlen = 200 -- <leader>入力後にどれくらい待つか

