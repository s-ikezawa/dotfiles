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

-- 基本設定を読み込む
require('config.options')
require('config.keymaps')
require('config.autocmds')

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
