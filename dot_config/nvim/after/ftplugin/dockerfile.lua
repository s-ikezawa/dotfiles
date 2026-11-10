-- Dockerfile の設定。Neovim に同梱の ftplugin のあとに読まれる（after/）。

-- hadolint の警告を診断として出す（lua/config/hadolint.lua）
local buf = vim.api.nvim_get_current_buf()
require('config.hadolint').attach(buf)
vim.b.undo_ftplugin = (vim.b.undo_ftplugin and vim.b.undo_ftplugin .. ' | ' or '')
  .. ('lua require("config.hadolint").detach(%d)'):format(buf)
