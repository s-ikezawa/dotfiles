local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = " "

if vim.g.vscode then
  vim.opt.foldopen=
  require("config.vscode-keymaps")
else
  require("config.options")
  require("config.keymaps")
  require("config.autocmd")
  
  require("lazy").setup("plugins", {
    install = {
      colorscheme = { "catppuccin" },
    },
    rtp = {
      disabled_plugin = {
        "gzip",
        "matchit",
        "matchparen",
        "netrw",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
    change_detection = {
      enabled = true,
      notify = false,
    },
  })
  vim.cmd[[colorscheme catppuccin]]
end
