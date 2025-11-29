--=========================================================================
-- Options
--=========================================================================
if not vim.g.vscode then
  -- 行番号を相対行番号で表示
  vim.opt.number = true
  vim.opt.relativenumber = true

  -- 24bitカラーを有効化
  vim.opt.termguicolors = true
end

-- リーダーキー設定
vim.g.mapleader = ","
vim.g.localmapleader = " "

-- クリップボード連携
vim.opt.clipboard = "unnamedplus"

--=========================================================================
-- Plugins
--=========================================================================
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    { import = "plugins" }
  },
})

